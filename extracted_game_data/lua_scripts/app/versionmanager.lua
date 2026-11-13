----@type string 当前的登录地址
local versionip = CS.GameProperties:Get().ResourceUrl

---@class SerE_VersionCheckResult @和服务器版本对比后的结果，是不更新 还是更新整包 还是更新部分资源
SerE_VersionCheckResult = {
    None = 0, --不更新
    Package = 1, --更新包体
    Assets = 2, --更新部分资源
}

---@class VersionManager
VersionManager = class("VersionManager")
function VersionManager:initialize()
    self.IsAppStart = true
    self.IsForceAsset=false
    self.FuncRecvMsg = nil
    self.IsHotFixDone=false
    ---@type VersionData
    self.PackageVersion = nil
    ---@type VersionData
    self.LocalVersion = nil

    self.AssetPath = ""---资源路径
    self.DefaultVersionFolderName = ""
    self.PackageUrl = ""---整包路径
    self.VersionCheckResult = SerE_VersionCheckResult.None

    ---@type HotfixView
    self.UIView = nil
    self.UIAsset = nil
    self.UIPrefab = nil
    self.TempPkgVersion=nil
    self.TempLocalVersion=nil
    self.TempServerVersion=nil


end

---@return VersionManager
function VersionManager:Get()
    if self._instance == nil then
        self._instance = VersionManager()
    end
    return self._instance
end

function VersionManager:OnInit(isappstart, func)
    print("---   热更启用...")
    self.IsAppStart = isappstart
    self.FuncRecvMsg = func
    self.BeginTime=CS.ServerTime:Get():ConvertDateTimeInt(CS.ServerTime:Get():ServerTimeNow())
    self:ClearData()
    if isappstart then
        self:OpenStartUI(function()
            self:DecompressPkgVersion()
        end)
    else
        self:DecompressPkgVersion()
    end
    --HotfixHelper:SetToken(AnalysisType.HotFixBegin)
end

----解压包体版本号
function VersionManager:DecompressPkgVersion()
    local isandroid = HotfixHelper:IsAndroidPlatform()

    if isandroid then
        cs_coroutine.start(function()
            local w = CS.UnityEngine.WWW(HotfixHelper:GetPkgVersionPath())
            while not w.isDone do
                coroutine.yield()
            end

            if w.error and w.error ~= "" then
                print("---   error:加载包体version配置失败", w.error)
            else
                print("---   安卓解压包体version", w.text)
                self:DecompressPkgVersionFinish(w.text)
            end
        end)
    else
        local path = HotfixHelper:GetPkgVersionPath()
        local value = HotfixHelper:ReadFileContents(path)
        self:DecompressPkgVersionFinish(value)
    end
end
----解压包体版本号
function VersionManager:OnlyReadPkgVersion()

end
----解压包体版本号 和 服务器 上的版本号作对比，如果包体的版本号>本地版本号 就从包体加载 这是在刚安装包的时候出现，
function VersionManager:DecompressPkgVersionFinish(value)
    self:ReadPackageVersion(value)
    self:ReadLocalVersion()
    self:SetUIVersion()

    if self.PackageVersion:IsLaterPkg(self.LocalVersion) then
        print("更新----------------大版本----------》》》》。")
        AssetMapCfg:Get():ReplaceReadFlagFromPkgToLocal()
        VersionManager:Get():SendMsg_GetLogUrl(CS.GameProperties:Get().ResourceUrl,function()
            HotFixEnd(true)
            HotfixHelper:TrackAppStart("Big_Pkg_HotFix_End",nil,nil,false,AnalysisType.Big_Pkg_HotFix_End)

        end)
        return
    end
    if self.UIView then
        self.UIView:SetGetLocalVersion()
    end
    VersionManager:Get():SendMsg_GetLogUrl(CS.GameProperties:Get().ResourceUrl)
end

----读取包体版本号 @10.1.111@
function VersionManager:ReadPackageVersion(value)
    print("---   包体版本号...", value)
    local strs = HotfixHelper:StringSplit(value, '@')
    value = strs[2]
    print("---   解析包体版本号...", value)
    self.PackageVersion = VersionData()
    self.PackageVersion:SetData(value)
    self.TempPkgVersion=self.PackageVersion.Version

end
----读取本地版本号10.2.222
function VersionManager:ReadLocalVersion()
    local path = HotfixHelper:GetLocalVersionPath()
    local value = HotfixHelper:ReadFileString(path)
    self.LocalVersion = VersionData()
    self.LocalVersion:SetData(value)
    self.TempLocalVersion=self.LocalVersion.Version
    print("---   缓存版本号...", value)
end


----获取当前最新的loginjson 获取功能列表公告连接 维护公告 登录服
function VersionManager:SendMsg_GetLogUrl(url,PackageUpdateFunc)
    HotfixHelper:SendHttpGetRequest(url,
            function(data)
                self:RecvMsg_LoginInfo(data,PackageUpdateFunc)
            end,
            function(data)
                self:RecvMsg_VersionInfoError(data)
            end)
end

function VersionManager:RecvMsg_LoginInfo(data,PackageUpdateFunc)
    local msg = assert(Dll_JSON.decode(data))
    print(ProtoMsgHelp.block(msg))
    if self.UIView then
        self.UIView:SetLoadGameData()
    end
    self:SetSelfProperties(msg)
    self:RecvMsg_WhiteList(msg,PackageUpdateFunc)
end

----将服务器上的白名单拉取下来进行对比看是否需要热更

function VersionManager:RecvMsg_WhiteList(data,PackageUpdateFunc)
    if self.UIView then
        self.UIView:SetLoadCheckVersionData()
    end
   self:CheckSelfIsWhite(data.WhiteListConfig,function(isWhite)
        if isWhite then
            print("白名单")
            self:RecvMsg_CheckVersion(data.whiteconfig,PackageUpdateFunc)
        else
            self:RecvMsg_CheckVersion(data.config,PackageUpdateFunc)
        end
    end)
end

function VersionManager:CheckSelfIsWhite(msg,func)
    HotfixHelper:GetPhoneNumberIp(function(phoneid)
        local isWhite= CS.UnityEngine.PlayerPrefs.GetInt("GameProperties_FE",0)==1
        if msg.whitelist and #msg.whitelist>0 and not isWhite then
            for i = 1, #msg.whitelist do
                if phoneid==msg.whitelist[i] then
                    isWhite= true
                    break
                end
            end
        end
        func(isWhite)
    end)
end

function VersionManager:RecvMsg_VersionInfoError(error)
    print("---   RecvVersionError：   error = ", error)
    if self.UIView then
        self.UIView:CheckVersionFail(function()
            VersionManager:Get():SendMsg_GetLogUrl(CS.GameProperties:Get().ResourceUrl)
        end)
    end
    self:SdkLogLoadFail(error)
end




function VersionManager:RecvMsg_CheckVersion(msg,PackageUpdateFunc)
    local data = self.PackageVersion:CompareLatest(self.LocalVersion)
    local serverVersion=self:GetServerVersion(msg)
    local version = VersionData()
    version:SetData(serverVersion.version)
    print("Version"..data.Version_1,version.Version_1)
    print("Version"..data.Version_2,version.Version_2)
    print("Version"..data.Version_3,version.Version_3)
    local result=SerE_VersionCheckResult.None
    if data.Version_1<version.Version_1 or data.Version_2<version.Version_2 then
        result =SerE_VersionCheckResult.Package
    end
    if (data.Version_1==version.Version_1 and data.Version_2==version.Version_2) and data.Version_3<version.Version_3 then
        result =SerE_VersionCheckResult.Assets
        if serverVersion.result==2 then
            local path = HotfixHelper:GetAssetFlagMapPath()
            HotfixHelper:WriteFileString(path, "")
            local path2 = HotfixHelper:GetLocalHotfixMapPath()
            HotfixHelper:WriteFileString(path2, "")
        end
    end
    if self.ChangePag then
        result =SerE_VersionCheckResult.Package
    end
    if not self.IsAppStart then
        if self.FuncRecvMsg then
            if platform==1 then
                self.FuncRecvMsg(msg.android,result)
            else
                self.FuncRecvMsg(msg.ios,result)
            end
        end
        return
    end
    self.TempServerVersion=version.Version
    self.LocalVersion = version
    self.AssetPath = serverVersion.resourceUrl
    self.DefaultVersionFolderName = version:GetVersionFolderName()
    self.PackageUrl = serverVersion.url
    self.VersionCheckResult = result
    self:SetGameProperties()
    self:CheckResult(PackageUpdateFunc)
end

function VersionManager:RecvVersionError(error)
    print("---   RecvVersionError：   error = ", error)
    self:SdkLogLoadFail(error)
end
function VersionManager:GetServerVersion(msg)
    local result=msg.ios["default"]
    if  HotfixHelper:IsAndroidPlatform() then
        result=msg.android["default"]
        if CS.UnifySDK.UnifySDKManager.Instance.IUnifySDK_Account then
            local device=CS.UnifySDK.UnifySDKManager.Instance.IUnifySDK_Account:GetCPSChannelID()
            if device == nil or device=="" then
                return result
            end
            if msg.android[device] then
                result=msg.android[device]
            end
        end

    else
        if CS.UnifySDK.UnifySDKManager.Instance.IUnifySDK_Account then
            local device=CS.UnifySDK.UnifySDKManager.Instance.IUnifySDK_Account:GetCPSChannelID()
            if device == nil or device=="" then
                return result
            end
            if msg.ios[device] then
                result=msg.ios[device]
            end
        end
    end
    return result
end
function VersionManager:SetSelfProperties(msg)
    local loginurl=msg.loginurl.ios
    if HotfixHelper:IsAndroidPlatform() then
        loginurl=msg.loginurl.Android
    end
    self.LoginUrl = loginurl.login
    self.isTs = loginurl.isTs
    self.AnnouncementUrl = loginurl.announcementUrl
    self.ChangePag=loginurl.changePag==1
    self.cdnUrl=loginurl.cdnUrl
    self.maintainUrl=loginurl.mainyainUrl
    self.ClientLogUrl=loginurl.clientLogUrl
    self.LogSwitch=loginurl.LogSwitch
    self.menulist = loginurl.menulist
end

function VersionManager:CheckResult(PackageUpdateFunc)
    if self.VersionCheckResult == SerE_VersionCheckResult.None then
        if PackageUpdateFunc then
            PackageUpdateFunc()
            return
        end
        self.UIView:SetEnd(function()
            HotFixEnd(false)
        end)
    end

    if self.VersionCheckResult == SerE_VersionCheckResult.Package then
        --  self:SdkLogLoadPkg()
        self:OpenAssetUI()
    end

    if self.VersionCheckResult == SerE_VersionCheckResult.Assets then
        self:OpenAssetUI()
    end
end

function VersionManager:OpenStartUI(func)
    if self.UIAsset==nil then
        self.UIAsset =  CS.UnityEngine.Resources.Load("assetupdata/AssetUpdate",typeof(CS.UnityEngine.GameObject))
    end
    if self.UIPrefab==nil then
        local obj = HotfixHelper:InstantiateGameObjectByObject(self.UIAsset)
        if obj then
            self.UIPrefab = obj
        end
        self:LoadUIPrefabFinish(func)
    end

end
function VersionManager:UnloadAsset()

    self:ClearData()
    if self.UIAsset then
        CS.UnityEngine.Resources.UnloadAsset(self.UIAsset)
        CS.UnityEngine.Resources.UnloadUnusedAssets()
        self.UIAsset=nil
    end
end


function VersionManager:LoadUIPrefabFinish(func)
    self.UIView = HotfixView()
    self.UIView:SetData(self.UIPrefab)
    self.UIView:SetStart()
    func()
end
function VersionManager:OpenAssetUI()
    self.UIView:SetUI()
end
function VersionManager:SetUIVersion()
    if self.UIView then
        self.UIView:SetVersion()
    end
end

----把当前版本写到本地缓存里面
function VersionManager:SaveLatestVersion()
    self.LocalVersion:Save()
    print("---   热更结束...")
    self.UIView:SetHotFixEnd()
    HotFixEnd(true)
    HotfixHelper:TrackAppStart("HotFix_End",nil,nil,false,AnalysisType.end_update)

end

function VersionManager:ClearData()
    if self.UIView then
        self.UIView:CloseView()
        self.UIView=nil
    end
    if self.UIPrefab then
        CS.UnityEngine.GameObject.Destroy(self.UIPrefab)
        self.UIPrefab=nil
    end
end

function VersionManager:GetVersionCheckResult()
    return self.VersionCheckResult
end
function VersionManager:GetPackageUrl()
    return self.PackageUrl
end
----获取服务器上资源的路径 比如  serverResourcePath/10_1_10
function VersionManager:GetAssetPath()
    return self.AssetPath .. "/" .. self.DefaultVersionFolderName
end
function VersionManager:GetAssetPathNoVersion()
    return self.AssetPath
end

function VersionManager:UpdateProcess(value, max)
    if self.UIView then
        self.UIView:UpdateProgress(value, max)
    end
end
function VersionManager:SetTipText(string)
    if self.UIView then
        self.UIView:SetTips(string)
    end
end
function VersionManager:HideStartCanvas()
    self.StartCanvas=HotfixHelper:GetRootObjectExactMath("StartCanvas", false)
    if self.StartCanvas then
        HotfixHelper:SetGameObjectActiveByGo(self.StartCanvas, false)
    end
end


function VersionManager:GetVersion()
    if self.LocalVersion then
        return self.LocalVersion.Version
    end
    return ""
end
function VersionManager:SetHotFixDone(value)
    self.IsHotFixDone=value
end
function VersionManager:GetHotFixDone()
    return self.IsHotFixDone
end
function VersionManager:GetServerFunctionIsFlag(key)
    if self.menulist==nil then
        if CS.GameProperties.Get().MenuJson~="" and CS.GameProperties.Get().MenuJson~=nil then
            self.menulist=Dll_JSON.decode(CS.GameProperties.Get().MenuJson)
        end
    end
    if self.menulist then
        if self.menulist[key]~=nil then
            return self.menulist[key]
        end
        return true
    end
    return true
end
function VersionManager:SetGameProperties()
    CS.GameProperties.Get().AnnouncementUrl=self.AnnouncementUrl
    CS.GameProperties.Get().isTs=self.isTs
    CS.GameProperties.Get().LoginUrl=self.LoginUrl
    CS.GameProperties.Get().cdnUrl=self.cdnUrl
    CS.GameProperties.Get().maintainUrl=self.maintainUrl
    CS.GameProperties.Get().MenuJson=Dll_JSON.encode(self.menulist)
    CS.GameProperties.Get().LogSwitch=self.LogSwitch
    CS.GameProperties.Get().ClientVersion=self.LocalVersion.Version
    CS.GameProperties.Get().ClientLogUrl=self.ClientLogUrl
end
function VersionManager:SdkLogLoadPkg()
    --CS.NetEasePOneFunc:Get():UpdateLog(
    --        0,
    --        "app package update",
    --        VersionManager:Get():GetVersion(),
    --        VersionManager:Get():GetAssetPath(),
    --        0,
    --        0,
    --        0,
    --        0)
end

function VersionManager:SdkLogLoadFail(errorcode)

    --CS.NetEasePOneFunc:Get():UpdateLog(
    --        -1,
    --        "check version http error",
    --        VersionManager:Get():GetVersion(),
    --        VersionManager:Get():GetAssetPath(),
    --        errorcode,
    --        0,
    --        0,
    --        0)


end