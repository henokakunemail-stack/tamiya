---@class GameStartView : ViewBase
GameStartView = class("GameStartView", ViewBase)

function GameStartView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "GameStartViewAction")

    print("---   GameStartView 初始化完成")
end

function GameStartView:Awake()

    print("---   GameStartView awake")

    self:CacheInfoViewData()
    self:InitInfoViewBtn()
    QuickTa:Get():TrackEvent(TrackEventNames.FirstOpenLogin,nil,TrackEventType.First)
    --self:SetDebug()
end
function GameStartView:UnloadBg()
    --if self.PageBg then
    --    self.PageBg:Unload()
    --    self.PageBg=nil
    --end
end
function GameStartView:GetBg(name)
    if self.PageBg==nil then
        self.PageBg=Page_GameStartBgView()
        local parent=self:GetChild("Viewbg")
        self.PageBg:SetData(parent)
    else
        local parent=self:GetChild("Viewbg")
        self.PageBg:SetData(parent)
    end
end
function GameStartView:SetBgImgBySdk()
    local isAndroid = HotfixHelper:IsAndroidPlatform()
    self:GetBg()
    CommonHelper:SetGameObjectActive("hitcn", self.gameObject,SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseQuickSDKChina) or not SDKHelper:Get():ChickSdk())
    CommonHelper:SetGameObjectActive("hitsa", self.gameObject,SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseGoogleSDK) or SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseGoogleSDK2)
            or SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseGoogleSDK3)
            or SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseGoogleSDK4)
            or SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk)
            or SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk2)
            or SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk3)
            or SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk4)
            or SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk5)
    )
    CommonHelper:SetGameObjectActive("BtnCNYear", self.gameObject, SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseQuickSDKChina) or not SDKHelper:Get():ChickSdk())
end

function GameStartView:OnOpen()
    print("---   GameStartView OnOpen")
    --if GameProperties.AreaType==AreaType.AreaTypeCN then
    --    UIManager:Get():ShowPersistentView("TestShowView",CanvasType.TopCanvas,nil,false,true)
    --end
    cs_coroutine.start(function()
        coroutine.yield()
        coroutine.yield()
        HVersionManager:HideStartCanvas()
    end)
    self:SetClientVersion()
    self:SetBgImgBySdk()
end
function GameStartView:ReOpen()
    --if GameProperties.AreaType==AreaType.AreaTypeCN then
    --    UIManager:Get():ShowPersistentView("TestShowView",CanvasType.TopCanvas,nil,false,true)
    --end
    self:SetBgImgBySdk()
    UINotify:Get():SendNotification(UINotifyEvent.GameStartView_InitCG,false)
    self:SetClientVersion()
end

function GameStartView:CacheInfoViewData()
    ---@type ServerInfo
    self.serverInfo = ServerInfo()

    self.CreatePlayerCanvas = self:GetChildWight("CreatePlayerPage", typeof(CanvasGroup))
    self.LoginAfterPanelCG = self:GetChildWight("LoginAfterPanelCG", typeof(CanvasGroup))
    self.SdkLoginPanelCG = self:GetChildWight("SdkLoginPanelCG", typeof(CanvasGroup))

    if self.CreatePlayerCanvas ~= nil then
        UIUtil.ShowCanvasGroup(self.CreatePlayerCanvas, false)
    end
end

function GameStartView:InitInfoViewBtn()
    self.SelectServerBtn = CommonHelper:HButtonSetCallback("SelectServerBtn", self.gameObject, function(data)
        UIManager:Get():OpenPopup("SelectServerView", CanvasType.FrontCanvas, "SelectServerView", true)
        UINotify:Get():SendNotification(UINotifyEvent.SetSelectServerInfo,self.serverInfo:GetServerId())
    end)
    CommonHelper:HButtonSetCallback("BtnLog1", self.gameObject, function(data)
        DebugLogDataManager:Get():ClickLogBtn(1)
    end)
    CommonHelper:HButtonSetCallback("BtnLog2", self.gameObject, function(data)
        DebugLogDataManager:Get():ClickLogBtn(2)
    end)
    CommonHelper:HButtonSetCallback("BtnCNYear", self.gameObject, function(data)
        CommonHelper:ShowHelpView(PageDetailType.CADPA)
    end)
    self.BtnBtnKp= CommonHelper:HButtonSetCallback("BtnKp", self.gameObject, function(hbtn)
        MonoHelper.SwitchToKpGame(false)
    end)
    self.BtnFBService= CommonHelper:HButtonSetCallback("BtnFBService", self.gameObject, function(param)
        LoginSubSystem:Get():SendMsg_GetFbServiceUrl(function(data)
            local data=Dll_JSON.decode(data)
            CS.UnityEngine.Application.OpenURL(data.fbservice)
        end)
    end)
    CommonHelper:HButtonSetCallback("BtnDisCord", self.gameObject, function(param)
        LoginSubSystem:Get():SendMsg_GetFbServiceUrl(function(data)
            local data=Dll_JSON.decode(data)
            CS.UnityEngine.Application.OpenURL(data.discard)
        end)
    end)
    CommonHelper:HButtonSetCallback("BtnTiktok", self.gameObject, function(param)
        --SDKManager:Get():StartGmBridge(true)
        LoginSubSystem:Get():SendMsg_GetFbServiceUrl(function(data)
            local data=Dll_JSON.decode(data)
            CS.UnityEngine.Application.OpenURL(data.tiktok)
        end)
    end)
    if GameProperties.AreaType==AreaType.AreaTypeKR then
        CommonHelper:SetGameObjectActive("TweenTemp_Scale (4)", self.gameObject,false)
        CommonHelper:SetGameObjectActive("TweenTemp_Scale (2)", self.gameObject,false)
    end
    self.StartBtn = CommonHelper:HButtonSetCallback("StartBtn", self.gameObject, function()
            self:OnClickBtn_EnterGame()
    end)
    self.BtnStart2 = CommonHelper:HButtonSetCallback("StartBtn2", self.gameObject, function(hbtn)
        log("AssetBundleMode ",CS.GameProperties:Get().AssetBundleMode, CS.GameProperties:Get().HotfixEnable)
        if CS.GameProperties:Get().AssetBundleMode and CS.GameProperties:Get().HotfixEnable  then
            ---@param msg SC_CheckVersionRes
            HVersionManager:OnInit(GameProperties.ResourceUrl,false, nil,function(msg,result)
                if result == VersionCheckResult.None then
                    --没有版本更新
                    self:OnEnterGameBtnClick()
                else
                    if result==VersionCheckResult.Package then
                        local boxfunc = function()
                            local ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue, HotfixHelper:GetStringById(HotfixString.MsgUpdateVersionTip), ClientDataManager:Get():GetTemplateString(TemplateStringID.GameWarmPrompt), nil, nil, false, false, true)
                            if ret == MessageBoxHelp.BtnType.OK then
                                HotfixHelper:OpenURL(HVersionManager.PackageUrl)
                                HotfixHelper:ApplicationQuit()
                            end
                        end
                        MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
                    end
                    if result==VersionCheckResult.Assets then
                        local boxfunc = function()
                            local ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue, HotfixHelper:GetStringById(HotfixString.MsgUpdateAssetsTip), ClientDataManager:Get():GetTemplateString(TemplateStringID.GameWarmPrompt), nil, nil, false, false, true)
                            if ret == MessageBoxHelp.BtnType.OK then
                                HotfixHelper:ApplicationQuit()
                            end
                        end
                        MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
                    end
                end
            end)
        else
            log("GameStartView:InitInfoViewBtn11",UnifySDKManager:Get():IAccount().isLogin )
            if UnifySDKManager:Get():IAccount().isLogin == false then
                log("GameStartView:InitInfoViewBtn22" )
                UnifySDKManager:Get():IAccount():Login(false)
            else
                log("GameStartView:InitInfoViewBtn33" )
                self:OnEnterGameBtnClick()
            end
        end
    end)
    --self.UserInfoBtn = CommonHelper:HButtonSetCallback("BtnUserInfo", self.gameObject, function()
    --    self:OnUserInfoBtnClick()
    --end)
    self.BtnAnnouncement = CommonHelper:HButtonSetCallback("BtnAnnouncement", self.gameObject, function()
        --FunctionSkipManager:Get():SkipToFunction(GameFunction.ActProclamation, { 1, 1 })
        LoginSubSystem:Get():SendMsg_GetAnnouncement()
    end)
    CommonHelper:HButtonSetCallback("BtnGameRepair", self.gameObject, function()
        local boxFunc = function()
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(nil, CommonHelper:GetTempStr_Default(TemplateStringID.GameRepair))
            if ret == MessageBoxHelp.BtnType.OK then
                HotfixHelper:ClearLocalPatch()
                local resPath = CS.AppPath.PersistentDataPath4Res
                if CS.System.IO.Directory.Exists(resPath) then
                    local files = CS.System.IO.Directory.GetFiles(resPath, "*", CS.System.IO.SearchOption.AllDirectories)
                    for i = 0, files.Length - 1 do
                        CS.System.IO.File.Delete(files[i])
                    end

                    local dirs = CS.System.IO.Directory.GetDirectories(resPath, "*", CS.System.IO.SearchOption.AllDirectories)
                    -- 反向遍历删除子目录
                    for i = dirs.Length - 1, 0, -1 do
                        CS.System.IO.Directory.Delete(dirs[i])
                    end
                end
                HotfixHelper:ApplicationQuit()
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
    end)

    self.GooglePlayLoginBtn = CommonHelper:HButtonSetCallback("GooglePlayLoginBtn", self.gameObject, function()
        --GlobalSdkDataManager:Get():SetGlobalLoginType(GlobalLoginType.GooglePlay)
        --SDKManager:Get():LoginBase(GlobalLoginType.GooglePlay)
        QuickTa:Get():TrackEvent(TrackEventNames.FirstClickLoginBtn,nil ,TrackEventType.First)
        UnifySDKManager:Get():IAccount():Login(false)
        QuickTa:Get():TrackEvent(TrackEventNames.FirstOpenLoginSDk,nil,TrackEventType.First)
        QuickTa:Get():TrackEvent(TrackEventNames.open_login, nil,TrackEventType.First,AnalysisType.open_login)
        print("login---------sdkCLICK")
    end)


    self.GooglePlayLogoutBtn = CommonHelper:HButtonSetCallback("GooglePlayLogoutBtn", self.gameObject, function()
        UnifySDKManager:Get():IAccount():Logout()
        if HotfixHelper:IsAndroidPlatform() == false then
            UINotify:Get():SendNotification(UINotifyEvent.GameStartView_CloseLoginPanelCG,false)
        end
    end)
    local serverCount = 0
    if ClientDataManager:Get():GetServerList()~=nil then
        serverCount = #(ClientDataManager:Get():GetServerList())
    end

    CommonHelper:SetHButtonClick(self.SelectServerBtn, serverCount>1 and (SDKHelper:Get():ChickSdk() ), true)
    CommonHelper:SetHButtonClick(self.GooglePlayLogoutBtn, false, true)
    CommonHelper:SetHButtonClick(self.BtnStart2,false,true)
    CommonHelper:SetHButtonClick(self.StartBtn,false,true)
    self.serverInfo = ServerInfo()
end

function GameStartView:InitCG(IsHaveLogin)

    self.ReOpenGame=false
    self:SetBgImgBySdk()
    UIUtil.ShowCanvasGroup(self.LoginAfterPanelCG, IsHaveLogin or ( not SDKHelper:Get():ChickSdk()))
    local sdkb = (not IsHaveLogin and SDKHelper:Get():ChickSdk())
    UIUtil.ShowCanvasGroup(self.SdkLoginPanelCG, not IsHaveLogin and SDKHelper:Get():ChickSdk() )
    CommonHelper:SetHButtonClick(self.BtnStart2,false,true)
    CommonHelper:SetHButtonClick(self.BtnBtnKp,HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.ShowCovert),true)
    CommonHelper:SetHButtonClick(self.StartBtn,IsHaveLogin or not SDKHelper:Get():ChickSdk() ,true)
    if IsHaveLogin then
        self:InitServerInfo()
        self:InitBtnInfo(true)
        self:InitViewInfo()
    end
    QuickTa:Get():TrackEvent(TrackEventNames.start_login, nil,TrackEventType.First,AnalysisType.start_login)
end

function GameStartView:CloseLoginPanelCG(IsHaveLogin)
    UIUtil.ShowCanvasGroup(self.SdkLoginPanelCG, not IsHaveLogin and (SDKHelper:Get():ChickSdk() ))
    CommonHelper:SetHButtonClick(self.BtnStart2,false,true)
    CommonHelper:SetHButtonClick(self.StartBtn,true,true)

end

function GameStartView:InitViewInfo()
    CommonHelper:SetGameObjectActive("HitText", self.gameObject, not SDKHelper:Get():ChickSdk() )
    CommonHelper:SetHButtonClick(self.GooglePlayLogoutBtn, true, true)
    --self:OnAuthorTogClick(true)
end




function GameStartView:InitServerInfo()
   if SDKHelper:Get():ChickSdk()  then
        self.serverInfo=ServerInfo()
        CommonHelper:SetHButtonClick(self.BtnStart2,true,true)
        CommonHelper:SetHButtonClick(self.StartBtn,false,true)
        CommonHelper:SetHButtonClick(self.SelectServerBtn, true , true)
        CommonHelper:SetGameObjectActive("SelectServerBtn",self.gameObject,true)
      self.serverInfo:SetServerId(ClientDataManager:Get():GetLastServer())
      if  CommonHelper:IsNullOrEmpty(tostring(self.serverInfo:GetServerId())) then
          self.serverInfo=ClientDataManager:Get():GetRecommendServer()
      else
          local gameServerInfo = ClientDataManager:Get():GetServerInfoByServerId(self.serverInfo:GetServerId())
          if gameServerInfo  and tonumber(self.serverInfo:GetServerId()) == gameServerInfo:GetServerId() then
              self.serverInfo = gameServerInfo
          else
              self.serverInfo=ClientDataManager:Get():GetFirstServer()
          end
      end
      if self.serverInfo==nil then
          self.serverInfo=ServerInfo()
          self.serverInfo:SetName(CommonHelper:GetTempStr_Default(TemplateStringID.PleaseSelectServer))
      end
      self:InitServerData(self.serverInfo)
  end
end
function GameStartView:InitServerOneInfo(serverInfo)
        self.serverInfo=serverInfo
        self.ReOpenGame=false
        CommonHelper:SetHButtonClick(self.BtnStart2,false,true)
        CommonHelper:SetHButtonClick(self.StartBtn,true,true)
        LoginSubSystem:Get():SendMsg_GetAnnouncement()
        UIUtil.ShowCanvasGroup(self.LoginAfterPanelCG, true)
        CommonHelper:SetHButtonClick(self.StartBtn,true,true)
        CommonHelper:SetGameObjectActive("SelectServerBtn",self.gameObject,false)
end
function GameStartView:ReOpenServerInfo()
        self.ReOpenGame=true
        UIUtil.ShowCanvasGroup(self.LoginAfterPanelCG, true)
        CommonHelper:SetHButtonClick(self.BtnStart2,false,true)
        CommonHelper:SetHButtonClick(self.StartBtn,true,true)
        CommonHelper:SetGameObjectActive("SelectServerBtn",self.gameObject,false)
end

---@param serverInfo ServerInfo
function GameStartView:InitServerData(serverInfo)
    if serverInfo then
        monoAndroidUtility.DebugLog("SetServerName----------------------" .. serverInfo:GetName())

        self.serverInfo = serverInfo
        CommonHelper:SetText("###serverName", self.gameObject, serverInfo:GetName())
        local re=ClientDataManager:Get():GetRecommendServer()

        if re and re:GetServerId()~=serverInfo:GetServerId() then
            CommonHelper:SetServerStatus("serverstate", self.gameObject, serverInfo:GetStatus())
        else
            CommonHelper:SetServerStatus("serverstate", self.gameObject, -1)
        end
        --if serverInfo:GetStatus()~=ServerStatus.Normal then
        CommonHelper:SetServerStatus("serverstate", self.gameObject, serverInfo:GetStatus())
        CommonHelper:SetGameObjectActive("serverstate4",self.gameObject,false)
        --else
        --    CommonHelper:SetGameObjectActive("serverstate4",self.gameObject,re~=nil and re:GetServerId()==serverInfo:GetServerId())
        --end
    end
end

function GameStartView:ServerMaintain(data)
    local boxfunc = function()
        local text = data or ClientDataManager:Get():GetTemplateString(TemplateStringID.Maintain)
        local ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue, text, ClientDataManager:Get():GetTemplateString(TemplateStringID.GameWarmPrompt), nil, nil, false, false, true)
        if ret == MessageBoxHelp.BtnType.OK then
            CommonHelper:ApplicationQuit()
        end
    end
    MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
end

function GameStartView:OnClickBtn_EnterGame()
    if NetManager:Get():GetNetReachability() == NetworkReachability.NotReachable then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NetServerNoRes))
    else
        NetManager:Get():ConnectLoginServer()
    end
end

function GameStartView:OnEnterGameBtnClick()
    if self.serverInfo:GetName() == CommonHelper:GetTempStr_Default(TemplateStringID.PleaseSelectServer) then
        CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PleaseSelectServer))
    else
        PlayerPrefsHelper:SetValue_LoginServerId(self.serverInfo:GetServerId())
        monoAndroidUtility.DebugLog("OnEnterGameBtnClick----------------------" .. self.serverInfo:GetIp() .. "端口号：" .. self.serverInfo:GetPort())
        --if self.serverInfo:GetStatus() ~= ServerStatus.Maintain then
            ClientDataManager:Get():SetPId(self.serverInfo:GetRid())
            ClientDataManager:Get():SetIsNew(self.serverInfo:GetIsNew())
            LoginFuncHelper:ContentGameServer(self.serverInfo:GetIp(),self.serverInfo:GetPort())
       -- else
          --  CommonHelper:LoginTipPop(CommonHelper:GetTempStr_Default(TemplateStringID.LoginTips_1001), CommonHelper:GetTempStr_Default(TemplateStringID.OK))
        --end
    end
    self:InitBtnInfo(false)
end

function GameStartView:InitBtnInfo(isEnable)
    CommonHelper:SetBtnDelayClick(self.BtnStart2, 3, isEnable)
end

function GameStartView:SetClientVersion()
    local loaclVersion= string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrStr), "V ", CommonHelper:GetClientVersion())
    CommonHelper:SetText("###versiontext", self.gameObject,loaclVersion)
    if not CommonHelper:IsNullOrEmpty(CommonHelper:GetClientPkeVersion()) then
        local pkgversion=string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrStr), "V ", CommonHelper:GetClientPkeVersion())
        if pkgversion==loaclVersion then
            CommonHelper:SetText("###pkgversiontext", self.gameObject, "")
        else
            CommonHelper:SetText("###pkgversiontext", self.gameObject,pkgversion)
        end
    else
        CommonHelper:SetText("###pkgversiontext", self.gameObject, "")
    end

end

function GameStartView:SetDebug()
    if PlayerPrefsHelper:GetValue_IsDebug() == "false" then
        UIManager:Get():ShowPersistentView("DebugPersistView", CanvasType.TopCanvas, "DebugPersistView")
    else
        Debug.unityLogger.logEnabled = true
        print("开启debug模式")
    end
end

function GameStartView:OnDestroy()
    self.BrokenBtn = nil
    self.GMBtn = nil
    self.AuthorTog = nil
    self.AuthorBtn = nil
    self:UnloadBg()
end

--function GameStartView:OnUserInfoBtnClick()
--    SDKManager:Get():OnUserInfoBtnClick()
--end

--function GameStartView:OnAuthorTogClick(isSelect)
--    CommonHelper:SetToggleState(self.AuthorTog, isSelect)
--end
function GameStartView:OnBackKey()
    --if UIManager:Get():IsPersistentViewShow("AnnouncementView") then
    --    return
    --end
    if UIManager:Get():IsPersistentViewShow("ActProclamationView") then
        UIManager:Get():HidePersistentView("ActProclamationView")
    end
    if  UIManager:Get():GetTopPopViewName() ~= "" then
        return
    end
    if UIManager:Get():GetTopViewName() == self.gameObject.name then
        if UnifySDKManager:Get():IAccount():CanQuitGame() then
            UnifySDKManager:Get():IAccount():QuitGame()
        else
            local boxfunc = function()
                local str = CommonHelper:GetTempStr_Default(TemplateStringID.MakeSureToQuitTheGame)
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, str)
                if ret == MessageBoxHelp.BtnType.OK then
                    HotfixHelper:ApplicationQuit()
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
        end
    end
end
