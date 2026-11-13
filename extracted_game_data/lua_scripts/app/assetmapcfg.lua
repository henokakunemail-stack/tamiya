


---@class AssetMapCfg  @包体内的资源映射
AssetMapCfg = class("AssetMapCfg")
function AssetMapCfg:initialize()
    self.Dict = {}
end

---@return AssetMapCfg
function AssetMapCfg:Get()
    if self._instance == nil then
        self._instance = AssetMapCfg()
    end
    return self._instance
end


---@return table<string,string>
function AssetMapCfg:GetDict() return self.Dict end
----读取包体内的资源映射 解压安卓包体assetMap,key是资源的名字比如 main.prefab value 是以bundle开头的路径 比如bundle/main.ab
function AssetMapCfg:Read()
    self.Dict = {}
    self:DecompressPkgAssetMap()
end

function AssetMapCfg:DecompressPkgAssetMap()
    local isandroid = HotfixHelper:IsAndroidPlatform()
    if isandroid then
        cs_coroutine.start(function()
            local w = CS.UnityEngine.WWW(HotfixHelper:GetPkgAssetMapPath())
            while not w.isDone do coroutine.yield() end
            if w.error and w.error ~= "" then
                print("---   error:加载包体assetmap.txt配置失败", w.error)
            else
                print("---   安卓解压包体assetmap.txt", w.text)
                self:DecompressPkgAssetMapFinish(w.text)
            end
        end)
    else
        local path = HotfixHelper:GetPkgAssetMapPath()
        local result = HotfixHelper:ReadFileString(path)
        self:DecompressPkgAssetMapFinish(result)
    end
end

----解压安卓包体assetMap,key是资源的名字比如 main.prefab value 是以bundle开头的路径 比如bundle/main.ab
function AssetMapCfg:DecompressPkgAssetMapFinish(value)
    local map = {}
    local lines = HotfixHelper:StringSplit(value, '\n')
    local len = #lines
    local index = 1
    while index <= len - 1 do
        local line = lines[index]
        local params = HotfixHelper:StringSplit(line, ':')
        local filename = params[1]
        local path = params[2]
        map[filename] = path
        index = index + 1
    end
    self.Dict = map
end

----如果不把包体的资源首先写入到本地的话，这个就没意义
function AssetMapCfg:ReplaceReadFlagFromPkgToLocal()
--[[    AssetMapCfg:Get():Read()
    local map = AssetMapCfg:Get():GetDict()
    for k,v in pairs(map) do
        --print("-----    ********   ",AssetFlagManager:Get():IsExist(v), self.Dict[v],v)
        if AssetFlagManager:Get():IsExist(v) then
            AssetFlagManager:Get():UpdateReadFlag(v, true)
            AssetMapCfg:Get():ReplaceManifestToLocal(true)
        end
    end
    local path = HotfixHelper:GetAssetFlagMapPath()
    print("---   assetflagmap保存到本地，path = ", path)
    HotfixHelper:WriteFileString(path, "")]]
    HotfixHelper:ClearLocalPatch()

end
----如果不把manifest文件写入的话依赖会变
function AssetMapCfg:ReplaceManifestToLocal(readFlag)
    AssetFlagManager:Get():UpdateReadFlag(CS.AppPath.GetPlatformName(), readFlag)
end