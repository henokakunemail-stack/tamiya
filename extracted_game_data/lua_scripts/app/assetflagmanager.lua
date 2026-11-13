---@class ReadFlag @是本地读取还是包体读取
ReadFlag={
    Pkg="0",
    Local="1",
    Error="-1",--cdn错误 没有更到的文件 发现后续有更新自动更新改文件
}

---@class AssetFlagData @资源是从本地读取还是从包体读取，如果请求的版本号比包体的大，就在本地加载
AssetFlagData = class("AssetFlagData")
function AssetFlagData:initialize(key)
    self.Key = key
    self.ReadFlag = ReadFlag.Pkg  -- 0:包体读取   1:本地读取
end




---@class AssetFlagManager
AssetFlagManager = class("AssetFlagManager")
function AssetFlagManager:initialize()
    ---@type table<string, AssetFlagData>
    self.Dict = {}
end
---@return AssetFlagManager
function AssetFlagManager:Get()
    if self._instance == nil then
        self._instance = AssetFlagManager()
    end
    return self._instance
end

----从本地读取资源的信息，包括资源路径，资源的flag 是从本地读取 还是从包体读取
function AssetFlagManager:Read()
    local data = HotfixHelper:ReadFileString(HotfixHelper:GetAssetFlagMapPath())
    local map = {}
    local lines = HotfixHelper:StringSplit(data, '\n')
    local len = #lines
    local index = 1
    while index <= len - 1 do
        local line = lines[index]
        local params = HotfixHelper:StringSplit(line, ':')
        local key = params[1]
        local readflag = params[2]
        local flagdata = AssetFlagData(key)
        flagdata.ReadFlag = readflag
        map[key] = flagdata
        index = index + 1
    end
    self.Dict = map
end
----把下载完之后的资源路径存到本地中
function AssetFlagManager:Save()
    local data = ""
    local tempTab = {}
    for k,v in pairs(self.Dict) do
        table.insert(tempTab, v.Key)
        table.insert(tempTab, ":")
        table.insert(tempTab, v.ReadFlag)
        table.insert(tempTab, "\n")
    end
    data = table.concat(tempTab)

    local path = HotfixHelper:GetAssetFlagMapPath()
    print("---   assetflagmap保存到本地，path = ", path)
    HotfixHelper:WriteFileString(path, data)
end

function AssetFlagManager:IsExist(key)
    local data = self.Dict[key]
    return (data ~= nil)
end
function AssetFlagManager:Clear()
    self.Dict={}
end
----更新资源的读取标记，从本地读取还是从包体读取 0：是包体 1是本地
function AssetFlagManager:UpdateReadFlag(key, readFlag)
    local data = self.Dict[key]
    if data == nil then data = AssetFlagData(key) end
    data.ReadFlag = readFlag
    self.Dict[key] = data
end
------如果不把包体的资源首先写入到本地的话，这个就没意义
--function AssetFlagManager:ReplaceReadFlagFromPkgToLocal()
--    AssetMapCfg:Get():Read()
--    local map = AssetMapCfg:Get():GetDict()
--    for k,v in pairs(map) do
--        --print("-----    ********   ",AssetFlagManager:Get():IsExist(v), self.Dict[v],v)
--        if AssetFlagManager:Get():IsExist(v) then
--            AssetFlagManager:Get():UpdateReadFlag(v, true)
--        end
--    end
--end
