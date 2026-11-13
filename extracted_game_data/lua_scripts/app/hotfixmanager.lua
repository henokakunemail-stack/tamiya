



---@class HotfixManager
HotfixManager = class("HotfixManager")
function HotfixManager:initialize()
    ---@type table<string, AssetData>@客户端资源配置
    self.ClientCfg = {}
    ---@type table<string, AssetData>@包体资源配置
    self.PkgCfg = {}


    ---@type table<string, AssetData>@服务器资源配置
    self.ServerCfg = {}
    ---@type table<number, AssetData>@已经下载的资源列表 Key 是索引  value 是assetData
    self.DownloadAssetList = {}

    ---@type AssetLoadMachine
    self.Machine = nil

    self.InitFinish = nil
end


---@return HotfixManager
function HotfixManager:Get()
    if self._instance == nil then
        self._instance = HotfixManager()
    end
    return self._instance
end

----如果本地有热更映射，就加载本地的资源映射，否则加载包体内的资源映射
function HotfixManager:Init(initfun,errorFun)
    self.InitFinish = initfun
    self.ErrorFun=errorFun
    print("hotfix_time1", CS.UnityEngine.Time.realtimeSinceStartup)
    local flag, result = self:ReadLocalCfg()
    print("进入热更----------》》》》。flag = ", flag,result)
    print("hotfix_time2", CS.UnityEngine.Time.realtimeSinceStartup)

    if flag then
        self:AnalysePkgHotfixMap(function()
            self:DecompressPkgHotfixMapFinish(result)
        end)

    else
        self:DecompressPkgHotfixMap()
    end
end
----获取本地的热更hotfix资源映射,如果有返回true  分别是ab路径:md5码:字节大小:版本号  比如：asset/main.ab:1241243:1024:10_1_10
function HotfixManager:ReadLocalCfg()
    local path = HotfixHelper:GetLocalHotfixMapPath()
    local result = HotfixHelper:ReadFileContents(path)
    if result == "" or result==nil then
        return false, ""
    end
    return true, result
end

----解压包体内的hotfix map,为什么安卓就要用www
function HotfixManager:DecompressPkgHotfixMap()
    local isandroid = HotfixHelper:IsAndroidPlatform()
    if isandroid then
        print("hotfix_time14", CS.UnityEngine.Time.realtimeSinceStartup)
        VersionManager:Get():SetTipText( HotfixHelper:GetStringById(HotfixString.MsgLoadingTip_StreamHotfixMap))
        cs_coroutine.start(function()
            local w = CS.UnityEngine.WWW(HotfixHelper:GetPkgHotfixMapPath())
            while not w.isDone do coroutine.yield() end
            if w.error and w.error ~= "" then
                if self.ErrorFun then
                    self.ErrorFun()
                end
            else
                VersionManager:Get():SetTipText( HotfixHelper:GetStringById(HotfixString.MsgLoadingTip_StreamHotfixMap))
                print("hotfix_time15", CS.UnityEngine.Time.realtimeSinceStartup)
                coroutine.yield()
                --print("---   安卓解压包体hotfixmap", w.text)
                self:DecompressPkgHotfixMapFinish(w.text)
                print("hotfix_time16", CS.UnityEngine.Time.realtimeSinceStartup)
                VersionManager:Get():SetTipText( HotfixHelper:GetStringById(HotfixString.MsgLoadingTip_HotfixMapParseFinish))
                coroutine.yield()
            end
            w:Dispose()
        end)
    else
        local path = HotfixHelper:GetPkgHotfixMapPath()
        local result = HotfixHelper:ReadFileContents(path)
        self:DecompressPkgHotfixMapFinish(result)
    end
end
----解析包体的资源配置
function HotfixManager:AnalysePkgHotfixMap(func)
    print("hotfix_time3", CS.UnityEngine.Time.realtimeSinceStartup)
    local isandroid = HotfixHelper:IsAndroidPlatform()
    if isandroid then
        cs_coroutine.start(function()
            coroutine.yield()
            print("hotfix_time4", CS.UnityEngine.Time.realtimeSinceStartup)
            VersionManager:Get():SetTipText( HotfixHelper:GetStringById(HotfixString.MsgLoadingTip_StreamHotfixMap))
            local w = CS.UnityEngine.WWW(HotfixHelper:GetPkgHotfixMapPath())
            while not w.isDone do coroutine.yield() end
            if w.error and w.error ~= "" then
                self.ErrorFun()
            else
                VersionManager:Get():SetTipText( HotfixHelper:GetStringById(HotfixString.MsgLoadingTip_HotfixMapParse))
                print("hotfix_time5", CS.UnityEngine.Time.realtimeSinceStartup)
                coroutine.yield()
                --print("---   安卓解压包体hotfixmap", w.text)
                self.PkgCfg= self:AnalyseCfg(w.text)
                print("hotfix_time6", CS.UnityEngine.Time.realtimeSinceStartup)
                VersionManager:Get():SetTipText( HotfixHelper:GetStringById(HotfixString.MsgLoadingTip_HotfixMapParseFinish))
                coroutine.yield()
                func()
            end
            w:Dispose()

        end)
    else
        local path = HotfixHelper:GetPkgHotfixMapPath()
        local result = HotfixHelper:ReadFileContents(path)
        self.PkgCfg= self:AnalyseCfg(result)
        func()
    end
end

----解压本地的资源映射
function HotfixManager:DecompressPkgHotfixMapFinish(value)

    print("hotfix_time50", CS.UnityEngine.Time.realtimeSinceStartup)
    cs_coroutine.start(function()
        self.ClientCfg = self:AnalyseCfg(value)

        local indexCount = 0
        for i, v in pairs(self.ClientCfg) do
            indexCount = indexCount + 1
        end
        print("hotfix_time51", CS.UnityEngine.Time.realtimeSinceStartup, indexCount)
        coroutine.yield()
        print("hotfix_time51.1", CS.UnityEngine.Time.realtimeSinceStartup, indexCount)
        VersionManager:Get():SetTipText( HotfixHelper:GetStringById(HotfixString.MsgLoadingTip_HotfixMapParse))
        print("hotfix_time51.2", CS.UnityEngine.Time.realtimeSinceStartup, indexCount)
        coroutine.yield()
        print("hotfix_time52", CS.UnityEngine.Time.realtimeSinceStartup)
        self:GetServerCfg(VersionManager:Get():GetAssetPath())
        print("hotfix_time54", CS.UnityEngine.Time.realtimeSinceStartup)
    end)

   -- self:GetServerManifest(VersionManager:Get():GetAssetPath())
end


----解析hotfix映射 包括资源路径 MD5 字节大小 版本，比如 asset/materials/1.ab:adfadf:1024:10_0_114:1
function HotfixManager:AnalyseCfg(data)
    print("hotfix_time1000, AnalyseCfg")
    if data == "" or data == nil then
        print("---   error:HotfixManager:InitClientCfg   MD5配置数据空", debug.traceback())
        return {}
    end
    local map = {}
    local index = 1
    local params = {} -- 存储分割后的每一部分
    for line in data:gmatch("[^\r\n]+") do
        local subIndex =1
        for part in line:gmatch("[^:]+") do
            params[subIndex] = part
            subIndex = subIndex +1
        end

        local filename = params[1]
        local md5 = params[2]
        local size = tonumber(params[3])
        local version = params[4]
        local saveType = params[5]
        local assetdata = AssetData()
        assetdata.FileName = filename
        assetdata.MD5 = md5
        assetdata.Size = size
        if saveType then
            assetdata.SaveType = saveType
        else
            assetdata.SaveType = AssetDataSaveType.Normal
        end
        assetdata.Version = version
        assetdata.BeginTime=CS.ServerTime:Get():ConvertDateTimeInt(CS.ServerTime:Get():ServerTimeNow())
        map[filename] = assetdata

        index = index + 1
    end

    return map

end

--[[function HotfixManager:AnalyseCfg(data)
    print("hotfix_time1000, AnalyseCfg")
    if data == "" then
        print("---   error:HotfixManager:InitClientCfg   MD5配置数据空")
        return {}
    end
    local map = {}
    local lines = data:gmatch("[^\r\n]+") --HotfixHelper:StringSplit(data, '\n')
    local len = #lines
    local index = 1
    while index <= len - 1 do
        local line = lines[index]
        local params = line:gmatch("[^:]+")--HotfixHelper:StringSplit(line, ':')
        local filename = params[1]
        local md5 = params[2]
        local size = tonumber(params[3])
        local version = params[4]
        local saveType = params[5]
        local assetdata = AssetData()
        assetdata.FileName = filename
        assetdata.MD5 = md5
        if size=="" or size==nil then
            size=0
        end
        assetdata.Size = size
        if saveType then
            assetdata.SaveType = saveType
        else
            assetdata.SaveType = AssetDataSaveType.Normal
        end
        assetdata.Version = version
        assetdata.BeginTime=CS.ServerTime:Get():ConvertDateTimeInt(CS.ServerTime:Get():ServerTimeNow())
        map[filename] = assetdata

        index = index + 1
    end

    return map

end]]--
----从服务器上下载热更的映射文件 hotfix map
function HotfixManager:GetServerCfg(asseturl)
    print("hotfix_time56", CS.UnityEngine.Time.realtimeSinceStartup)
    local url = HotfixHelper:GetServerHotfixMapUrl(asseturl)
    self.BeginHotfixMapTime=CS.ServerTime:Get():ConvertDateTimeInt(CS.ServerTime:Get():ServerTimeNow())
    print("hotfix_time57", CS.UnityEngine.Time.realtimeSinceStartup)
    HotfixHelper:SendHttpGetRequest(url,
            function(data) self:LoadHotfixMapFinish(data) end,
            function(data) self:LoadHotfixMapError(data) end)
end
----从服务器上下载热更后的依赖文件 Manifest
function HotfixManager:GetServerManifest(asseturl)
    local url = HotfixHelper:GetManifestUrl(asseturl)
    self.BeginManifestTime=CS.ServerTime:Get():ConvertDateTimeInt(CS.ServerTime:Get():ServerTimeNow())
    HotfixHelper:SendHttpGetRequest(url,
            function(data) self:LoadManifestFinish(data) end,
            function(data) self:LoadManifestError(data) end)
end

function HotfixManager:LoadManifestFinish(data)
    local path = HotfixHelper:GetAssetManifestPath()
    HotfixHelper:WriteFileBytes(path, data)
end

function HotfixManager:LoadManifestError(error)
    print("---   LoadManifest：   error = ", error)
    local loadTime=CS.ServerTime:Get():ConvertDateTimeInt(CS.ServerTime:Get():ServerTimeNow()) - self.BeginManifestTime
    self:SdkLogLoadFail("Manifest",error,loadTime)
    if self.ErrorFun then
        self.ErrorFun()
    end
end


function HotfixManager:LoadHotfixMapFinish(data)
    cs_coroutine.start(function()
        print("hotfix_time100", CS.UnityEngine.Time.realtimeSinceStartup)
        VersionManager:Get():SetTipText( HotfixHelper:GetStringById(HotfixString.MsgLoadingTip_HotfixMapParse))
        coroutine.yield()
        local str = CS.MonoHelper.ConvertByteArrayToString(data)
        self.ServerCfg = self:AnalyseCfg(str)
        print("hotfix_time101", CS.UnityEngine.Time.realtimeSinceStartup)
        VersionManager:Get():SetTipText( HotfixHelper:GetStringById(HotfixString.MsgLoadingTip_HotfixMapCompare))
        coroutine.yield()
        self:SiftDownloadAssets()
        VersionManager:Get():SetTipText( HotfixHelper:GetStringById(HotfixString.MsgLoadingTip_HotfixMapCompareFinish))
        coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
        print("hotfix_time102", CS.UnityEngine.Time.realtimeSinceStartup)
        if self.InitFinish then
            self.InitFinish()
        end

    end)
end

function HotfixManager:LoadHotfixMapError(error)
    print("---   LoadHotfixMapError：   error = ", error)
    local loadTime=CS.ServerTime:Get():ConvertDateTimeInt(CS.ServerTime:Get():ServerTimeNow()) - self.BeginHotfixMapTime
    self:SdkLogLoadFail("HotfixMap",error,loadTime)
    if self.ErrorFun then
        self.ErrorFun()
    end
end



----对比和本地的MD5文件，如果不一样就添加到资源加载的列表里面 DownloadAssetList
function HotfixManager:SiftDownloadAssets()
    self.DownloadAssetList = {}
    for k,v in pairs(self.ServerCfg) do
        local clientData = self.ClientCfg[k]
        if clientData then
            local serverMd5 = v.MD5
            local clientMd5 = clientData.MD5
            local IsReadPkg=self:CheckFileIsReadPkg(v)
            if (serverMd5 ~= clientMd5 and IsReadPkg==false) or clientData.SaveType==AssetDataSaveType.Error then
                self:DownloadAssetListAddValue(v)
            end
        else
            self:DownloadAssetListAddValue(v)
        end
    end
end
---@param data AssetData
function HotfixManager:CheckFileIsReadPkg(data)
    local result =false
    if self.PkgCfg then
        local pkgData=self.PkgCfg[data.FileName]
        if pkgData then
            if data.MD5==pkgData.MD5 then
                result=true
                AssetFlagManager:Get():UpdateReadFlag(pkgData.FileName,ReadFlag.Pkg)
            end
        end
    end
    return result
end
function HotfixManager:DownloadAssetListAddValue(value)
    if self:CheckStaticLua(value) then
        table.insert(self.DownloadAssetList, value)
    end
end

----排除掉不需要热更的资源
---@param value AssetData
function HotfixManager:CheckStaticLua(value)
    --if value.FileName == "lua/hotfix/hotfixstring.ab" then return false end
    --if value.FileName == "lua/hotfix/assetdata.ab" then return false end
    --if value.FileName == "lua/hotfix/assetloadmachine.ab" then return false end
    --if value.FileName == "lua/hotfix/hotfixhelper.ab" then return false end
    --if value.FileName == "lua/hotfix/hotfixmanager.ab" then return false end
    --if value.FileName == "lua/hotfix/hotfixview.ab" then return false end
    --if value.FileName == "lua/hotfix/hotfixmsgboxhelper.ab" then return false end
    --if value.FileName == "lua/hotfix/versiondata.ab" then return false end
    --if value.FileName == "lua/hotfix/versionmanager.ab" then return false end
    --if value.FileName == "lua/hotfix/assetflagmanager.ab" then return false end
    --if value.FileName == "lua/hotfix/assetmapcfg.ab" then return false end
    --if value.FileName == "lua/hotfixmain.ab" then return false end
    return true
end

----开始热更，热更结束后把资源保存到本地
function HotfixManager:DownloadStart()
    if self.Machine then
        print("---   error:遗留数据   Machine ~= nil")
        return
    end
    self.Machine = AssetLoadMachine()
    self.Machine:Start(self.DownloadAssetList,function()
        self:DownloadFinish()
        AssetFlagManager:Get():Save()
        VersionManager:Get():SaveLatestVersion()
        --HotfixMsgBoxHelper:Get():OpenMsgBox(HotfixString.MsgUpdateFinishTip,function ()
        --    HotfixHelper:ApplicationQuit()
        --end,nil,nil,nil,MsgBoxType.Ensure)
    end)
end

function HotfixManager:GetAssetSize()
    local memory = 0
    for k, v in pairs(self.DownloadAssetList) do
        if v then
            memory = memory + v.Size
        end
    end
    memory = memory / 1024 / 1024
    local isGreat10M=memory>=10--是否大于100k  0.1m  10m
    return isGreat10M , (isGreat10M and memory or math.floor(memory*1024 ))
end

function HotfixManager:DownloadFinish()

    for i = 1, #self.DownloadAssetList do
        local value = self.DownloadAssetList[i]
        self.ClientCfg[value.FileName] = value
        AssetFlagManager:Get():UpdateReadFlag(value.FileName, ReadFlag.Local)
    end
    AssetMapCfg:Get():ReplaceManifestToLocal(ReadFlag.Local)
    self:WriteHotfixMapCfg(self.ClientCfg)

    self:ClearData()


end
function HotfixManager:IsDownloadFinish()
    if self.Machine then
        return self.Machine.DownloadFinish
    else
        return true
    end

end

function HotfixManager:CheckContinueHotfix()
    if self.Machine then
        return self.Machine:ReStartLoad()
    end
end


function HotfixManager:SaveDownloadProcess()
    print("保存打印------》》hotfixmap保存到本地1")
    if self.Machine and self.Machine.DownloadFinish==false then

        self.Machine:ClearOnApplicationPause()
        print("保存打印------》》hotfixmap保存到本地2")
        local finishlist = self.Machine:GetFinishAssetList()
        for i = 1, #finishlist do
            local value = finishlist[i]
            self.ClientCfg[value.FileName] = value
            AssetFlagManager:Get():UpdateReadFlag(value.FileName, ReadFlag.Local)
        end
        AssetMapCfg:Get():ReplaceManifestToLocal(ReadFlag.Local)
        print("保存打印------》》hotfixmap保存到本地2Manifest")
        self:WriteHotfixMapCfg(self.ClientCfg)
        return #finishlist
    end
    return 0
end

----把热更后的资源写到本地的hotfix map
---@param list table<string, AssetData>
function HotfixManager:WriteHotfixMapCfg(list)
    local data = ""
    local tempTab = {}
    print("保存打印------》》hotfix map3")
    for k,v in pairs(list) do
        table.insert(tempTab, v.FileName)
        table.insert(tempTab, ":")
        table.insert(tempTab, v.MD5)
        table.insert(tempTab, ":")
        table.insert(tempTab, v.Size)
        table.insert(tempTab, ":")
        table.insert(tempTab, v.Version)
        table.insert(tempTab, ":")
        table.insert(tempTab, v.SaveType)
        table.insert(tempTab, "\n")
    end
    data = table.concat(tempTab)

    local path = HotfixHelper:GetLocalHotfixMapPath()
    print("---   hotfixmap保存到本地，path = ", path)
    HotfixHelper:WriteFileString(path, data)
end

function HotfixManager:ClearData()
    self.ClientCfg = {}
    self.ServerCfg = {}
    self.DownloadAssetList = {}
    self.Machine.DownloadFinish=true
end


function HotfixManager:SdkLogLoadFail(filename,error,loadTime)
    HotfixHelper:TrackHotFixHttpError(filename,error,VersionManager:Get():GetVersion(),VersionManager:Get():GetAssetPath(),0,0,0,loadTime)
end