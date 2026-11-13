---@class LoginSubSystem
LoginSubSystem = class("LoginSubSystem")

function LoginSubSystem:initialize(...)
    NetResponseEventManager:Get():AddListener(MsgID.REGISTER_SERVER_S2C_RES, self, self.Rec_RegisterUserSuccess)
    NetResponseEventManager:Get():AddListener(MsgID.GET_SERVER_LIST_S2C_RES, self, self.Rec_GetServerList)
    NetResponseEventManager:Get():AddListener(MsgID.ENTER_SERVER_S2C_RES, self, self.Rec_EnterServer)
    NetResponseEventManager:Get():AddListener(MsgID.ENTER_SERVER_PART_S2C_RES, self, self.Rec_EnterServerPart)
    NetResponseEventManager:Get():AddListener(MsgID.GET_ANNOUNCEMENT_S2C_RES, self, self.Rec_GetAnnouncement)
    NetResponseEventManager:Get():AddListener(MsgID.NOTIFY_NEW_DAY_FRESH_S2C_RES, self, self.Notify_NewDayFresh)
    NetResponseEventManager:Get():AddListener(MsgID.GET_DAY_FRESH_S2C_RES, self, self.Rec_NewDayFresh)
    NetResponseEventManager:Get():AddListener(MsgID.CREATE_ROLE_S2C_RES, self, self.Rec_CreateRoleSelectCar)
end
-------------------------------------------------------------------------------------------
function LoginSubSystem.HttpError(data)
    MsgErrorManager:Get():HttpError(data)
end
--------------------------------------------------------------------------------------------登录服
function LoginSubSystem:Notify_NewDayFresh(uid)
    LoginSubSystem:Get():SendNewDayFresh()
end
function LoginSubSystem:SendNewDayFresh()
    ClientDataManager:Get():SetGameState(GameState.CrossDay)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.GET_DAY_FRESH_C2S_REQ, data,true)
end
function LoginSubSystem:Rec_NewDayFresh(data)
    ---@type SC_LoginSuccess
    local msg = assert(Dll_PB.decode("LoginSuccess", data))
    LoginFuncHelper:EnterMainCity(msg)
end
function LoginSubSystem:Rec_CreateRoleSelectCar(data)
    ---@type SC_LoginSuccess
    local msg = assert(Dll_PB.decode("LoginProp", data))
    LoginFuncHelper:EnterServerPart(msg,true)
end
local _GetServerList_CallBack=nil
--{{{ 请求服务器列表
function LoginSubSystem:Send_GetServerList(uid,callBack)
    _GetServerList_CallBack=callBack
    -- p2  1是提审服0 是正常
    local isAndroid=HotfixHelper:IsAndroidPlatform() and 1 or 0
    local data = CommonHelper:GetNetSendData({ uid,0 ,CommonHelper:GetClientVersion(),isAndroid})
    if _GetServerList_CallBack==nil then
        NetManager:Get():SendLogin(MsgID.GET_SERVER_LIST_C2S_REQ, data)
    else
        NetManager:Get():SendLogin(MsgID.GET_SERVER_LIST_C2S_REQ, data,true)
    end

end
function LoginSubSystem:Rec_GetServerList(data)
    ---@type SC_AuthuserMess
    local msg = assert(Dll_PB.decode("AuthuserMess", data))
    print(ProtoMsgHelp.block(msg))
    --local androidSers={}
    --local iosSers={}
    --for k, v in pairs(msg.svrs) do
    --    if HotfixHelper:IsAndroidPlatform() and v.svrcode>150 then
    --        table.insert(androidSers, v)
    --    elseif not HotfixHelper:IsAndroidPlatform() and v.svrcode<=150 then
    --        table.insert(iosSers, v)
    --    end
    --end
    --if HotfixHelper:IsAndroidPlatform()then
    --    msg.svrs=androidSers
    --elseif not HotfixHelper:IsAndroidPlatform()then
    --    msg.svrs=iosSers
    --end
    table.sort(msg.svrs,function(a, b)
        return a.svrcode <b.svrcode
    end)
    if _GetServerList_CallBack then
        _GetServerList_CallBack(msg)
        _GetServerList_CallBack=nil
        return
    end
    if RankListTestVerifyDataManager:Get():GetIsVerify() then
        RankListTestVerifyDataManager:Get():RecServerList(msg)
        return
    end
    ClientDataManager:Get():SetLoginMsg(msg)
    if #msg.svrs > 1 then
        if not SDKHelper:Get():ChickSdk() then
            UIManager:Get():OpenPopup("ServerInfoView", CanvasType.FrontCanvas, "ServerInfoView", true)
            --UIManager:Get():OpenView("GameStartView", CanvasType.FrontCanvas, "GameStartView", false, true)
            --UINotify:Get():SendNotification(UINotifyEvent.GameStartView_InitCG, true)
        else
            --通知打开选服列表
            ClientDataManager:Get():SetServerListMsg(msg.svrs)
            UINotify:Get():SendNotification(UINotifyEvent.GameStartView_InitCG, true)
        end
    elseif #msg.svrs == 1 then
        local serverData = ServerInfo()
        serverData:InitServerInfo(msg.svrs[1])
        PlayerPrefsHelper:SetValue_LoginServerId(serverData:GetServerId())
        ClientDataManager:Get():SetPId(serverData:GetRid())
        ClientDataManager:Get():SetIsNew(serverData:GetIsNew())
        ClientDataManager:Get():SetServerListMsg(msg.svrs)
        if not SDKHelper:Get():ChickSdk() then
            LoginFuncHelper:ContentGameServer(serverData:GetIp(),serverData:GetPort())
        else
            UINotify:Get():SendNotification(UINotifyEvent.GameStartView_InitCG, true)
        end
        --LoginFuncHelper:ContentGameServer(serverData:GetIp(),serverData:GetPort())
    else
        local serverData = ServerInfo()
        serverData:InitServerInfo(msg)
        PlayerPrefsHelper:SetValue_LoginServerId(serverData:GetServerId())
        ClientDataManager:Get():SetPId(serverData:GetRid())
        ClientDataManager:Get():SetIsNew(serverData:GetIsNew())
        ClientDataManager:Get():SetServerListMsg({ msg })

        LoginFuncHelper:ContentGameServer(serverData:GetIp(),serverData:GetPort())

    end
    mono.SetServerQualityLevel(0)
end
---}}}
--{{{ 请求注册
function LoginSubSystem:Send_RegisterUser()
    local data = CommonHelper:GetNetSendData({ ClientDataManager:Get():GetUID() })
    NetManager:Get():Send(MsgID.REGISTER_SERVER_C2S_REQ, data)
end
function LoginSubSystem:Rec_RegisterUserSuccess(data)
    ---@type SC_AuthuserMess
    local msg = assert(Dll_PB.decode("AuthuserMess", data))
    print(ProtoMsgHelp.block(msg))
    ClientDataManager:Get():SetLoginMsg(msg)
end
---}}}

--{{{ 创建用户 --94 进入游戏
function LoginSubSystem:Send_CreateUser(name, carid)
    QuickTa:Get():OnInit()
    local pid = PlayerDataManager:Get():GetPlayerRID()
    local uid = ClientDataManager:Get():GetUID()
    local token = ClientDataManager:Get():GetToken()
    local umId = QuickTaHelper:Get():GetUmId()
    local chId = QuickTaHelper:Get():GetChId()
    local data = CommonHelper:GetNetSendData({ 0, uid, token, name, carid,umId,chId })
    NetManager:Get():Send(MsgID.ADVANCE_CREATE_ROLE_C2S_REQ, data)
end
---}}}
-----{{{ 创建用户 --94 进入游戏
function LoginSubSystem:Send_AdvanceCreateUser(name,carid)
    print(debug.traceback())
    QuickTa:Get():OnInit()
    local uid = ClientDataManager:Get():GetUID()
    local token = ClientDataManager:Get():GetToken()
    local umId = QuickTaHelper:Get():GetUmId()
    local chId = QuickTaHelper:Get():GetChId()
    local data = CommonHelper:GetNetSendData({ 0, uid,token,name, carid,umId,chId })
    NetManager:Get():Send(MsgID.ADVANCE_CREATE_ROLE_C2S_REQ, data)
end
---}}}
--{{{连接成功进入服务器
function LoginSubSystem:Send_EnterServer()
    QuickTa:Get():OnInit()
    local uid = ClientDataManager:Get():GetUID()
    local pid = ClientDataManager:Get():GetPID()
    local token = ClientDataManager:Get():GetToken()
    local umId = QuickTaHelper:Get():GetUmId()
    local chId = QuickTaHelper:Get():GetChId()
    local presetProperties=QuickTa:Get():GetPresetProperties()
    local data = CommonHelper:GetNetSendData({ pid, uid, token,umId,chId,presetProperties,CommonHelper:GetClientVersion() })
    NetManager:Get():Send(MsgID.ENTER_SERVER_C2S_REQ, data,true)
end
function LoginSubSystem:Send_GetPartData()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.ENTER_SERVER_GET_PART_C2S_REQ, data,true)
end


function LoginSubSystem:Send_ReContentServer()
    local uid = ClientDataManager:Get():GetUID()
    local pid = ClientDataManager:Get():GetPID()
    local token = ClientDataManager:Get():GetToken()
    local data = CommonHelper:GetNetSendData({ pid, uid, token })
    NetManager:Get():Send(MsgID.ENTER_RECONNECT_C2S_RES, data)
end
local _AdvanceCreateUserCallback=nil
---登录成功填充客户端数据
function LoginSubSystem:Rec_EnterServer(data)
    ---@type SC_LoginSuccess
    local msg = assert(Dll_PB.decode("LoginSuccess", data))
    if _AdvanceCreateUserCallback then
        _AdvanceCreateUserCallback(msg)
        _AdvanceCreateUserCallback=nil
        return
    end
    try( function()
        LoginFuncHelper:EnterMainCity(msg)
    end).catch(function(error)
        logError(error)
        LoginFuncHelper:EnterGameError(error)
    end)
end
--}}}
---登录成功填充客户端配件数据
function LoginSubSystem:Rec_EnterServerPart(data)
    ---@type SC_LoginProp
    local msg = assert(Dll_PB.decode("LoginProp", data))
    try( function()
        if RankListTestVerifyDataManager:Get():GetIsVerify() then
            RankListTestVerifyDataManager:Get():LoginSpeedRankData()
            return
        end
        LoginFuncHelper:EnterServerPart(msg,false)
    end).catch(function(error)
        logError(error)
        LoginFuncHelper:EnterGameError(error)
    end)
end
--}}}


--{{{连接服务成成功
function LoginSubSystem:OnGameServerConnect(isSuccess, isReconnect)
    if isSuccess then
        if isReconnect then
            log("---   重连gameserve")
            NetManager:Get():SetGameLoginType(LoginType.Reconnect)
            LoginFuncHelper:LoginOut_QuickReconnect()
        else
                NetManager:Get():DisconnectLoginServer()

            if ClientDataManager:Get():GetIsNew() then
                cs_coroutine.start(function()
                    CommonHelper:OpenLoading(false)
                    coroutine.yield()
                    UINotify:Get():SendNotification(UINotifyEvent.UpdateLoadingViewProgress, 0.2)
                    coroutine.yield()
                    LoginFuncHelper:EnterGame()
                end)
            else
                cs_coroutine.start(function()
                    CommonHelper:OpenLoading(false)
                    coroutine.yield()
                    UINotify:Get():SendNotification(UINotifyEvent.UpdateLoadingViewProgress, 0.2)
                    coroutine.yield()
                    NetManager:Get():SetGameLoginType(LoginType.Normal)

                    LoginSubSystem:Get():Send_EnterServer()

                end)
            end
        end
    else

    end
    if isSuccess then
        CommonHelper:PlayScreenEffectWaiting(false)
    end
end
--}}}
--{{{ 连接game成功创建角色
function LoginSubSystem:CreateUser(name, carid)
    --if PlayerDataManager:Get():GetPlayerRID()~=0 then
        LoginSubSystem:Get():Send_CreateUser(name, carid)
    --else
       -- LoginSubSystem:Get():Send_AdvanceCreateUser(name, carid)
   -- end

end

function LoginSubSystem:AdvanceCreateUser(name, carid,advanceCreateUserCallback)
    _AdvanceCreateUserCallback=advanceCreateUserCallback
    if ClientDataManager:Get():GetIsNew() then
        LoginSubSystem:Get():Send_AdvanceCreateUser(name, carid)
    end
end
--}}}

--{{{请求通告数据
function LoginSubSystem:SendMsg_GetAnnouncement()
    --local url = "http://cdn.miniwdcar.com/Formal/dev/1001/PlacardInfo.txt"
    local url = GameProperties.AnnouncementUrl
    if not CommonHelper:IsNullOrEmpty(url) then
        if ClientDataManager:Get().LanguageType==LanguageType.CHT then
            url=string.format(url,"tw.txt")
        elseif ClientDataManager:Get().LanguageType==LanguageType.EN then
            url=string.format(url,"en.txt")
        else
            url=string.format(url,"en.txt")
        end
     AnnouncementDataManager:Get().Http=  NetManager:Get():SendHttpGet_GetAnnouncement(url, function(data)
            if UIManager:Get():IsViewShow(CommonHelper:GetMainMenuViewName()) or UIManager:Get():IsViewShow("GameStartView") then
                LoginSubSystem:Get():Rec_GetAnnouncement(data)
            elseif UIManager:Get():IsViewShow("RaceView") then
                LoginSubSystem:Get():Rec_GetAnnouncement(data)
            end
        end, LoginSubSystem.HttpError)
    end
end
--{{{请求启动视频请求
function LoginSubSystem:SendMsg_GetMainPlayVideo(func)
    local url = string.format("http://%s/loginvideo/loginvideo.txt",GameProperties.cdnUrl)
    if not CommonHelper:IsNullOrEmpty(url) then
     NetManager:Get():SendHttpGet_GetAnnouncement(url, function(data)
            func(data)
        end, function(data)
         func("")
     end)
    end
end
--{{{请求登录白名单
function LoginSubSystem:SendMsg_GetLoginWhiteConfig(func)
    local url = string.format("http://%s/loginvideo/logwhiteconfig.json",GameProperties.cdnUrl)
    if not CommonHelper:IsNullOrEmpty(url) then
     NetManager:Get():SendHttpGet_GetAnnouncement(url, function(data)
            func(data)
        end, function(data)
         func("")
     end)
    end
end

--{{{请求充值验证方式及充值回调地址
function LoginSubSystem:SendMsg_ChargeFlagConfig(func)
    local url = string.format("http://%s/loginvideo/ChargeFlag.json",GameProperties.cdnUrl)
    if not CommonHelper:IsNullOrEmpty(url) then
     NetManager:Get():SendHttpGet_GetAnnouncement(url, function(data)
            func(data)
        end, function(data)
         func("")
     end)
    end
end
--{{{请求装备推荐的版本
function LoginSubSystem:SendMsg_CarAttrRecommendVersion(func)
    local url = string.format("http://%s/loginvideo/PartRecommend/carattrrecommendversion.txt",GameProperties.cdnUrl)
    if not CommonHelper:IsNullOrEmpty(url) then
     NetManager:Get():SendHttpGet_GetAnnouncement(url, function(data)
            func(data)
        end, function(data)
         func("")
     end)
    end
end
--}}}
--{{{请求装备推荐的内容
function LoginSubSystem:SendMsg_CarAttrRecommend(func)
    local url = string.format("http://%s/loginvideo/PartRecommend/tracksuggest.txt",GameProperties.cdnUrl)
    if not CommonHelper:IsNullOrEmpty(url) then
     NetManager:Get():SendHttpGet_GetAnnouncement(url, function(data)
            func(data)
        end, function(data)
         func("")
     end)
    end
end
--}}}


--{{{请求视频连接
function LoginSubSystem:SendMsg_GetPlayVideoUrl(func)
    local url = string.format("http://%s/loginvideo/video.json",GameProperties.cdnUrl)
    if not CommonHelper:IsNullOrEmpty(url) then
     NetManager:Get():SendHttpGet_GetAnnouncement(url, function(data)
            func(data)
        end, function(data)
         func("")
     end)
    end
end
function LoginSubSystem:SendMsg_GetPlaySignInVideoUrl(func)
    local url = string.format("http://%s/loginvideo/signinvideo.json",GameProperties.cdnUrl)
    if not CommonHelper:IsNullOrEmpty(url) then
     NetManager:Get():SendHttpGet_GetAnnouncement(url, function(data)
            func(data)
        end, function(data)
         func("")
     end)
    end
end
--{{{请求客服连接
function LoginSubSystem:SendMsg_GetFbServiceUrl(func)
    local url = string.format("http://%s/loginvideo/fbservice.json",GameProperties.cdnUrl)
    if GameProperties.AreaType==AreaType.AreaTypeKR then
        if SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk3) then
            url = string.format("http://%s/loginvideo/fbservicekr.json",GameProperties.cdnUrl)
        end
        if SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk4) then
            url = string.format("http://%s/loginvideo/fbservicekrself.json",GameProperties.cdnUrl)
        end
        if SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk5) then
            url = string.format("http://%s/loginvideo/fbservicekrself.json",GameProperties.cdnUrl)
        end
    end
    if not CommonHelper:IsNullOrEmpty(url) then
     NetManager:Get():SendHttpGet_GetAnnouncement(url, function(data)
            func(data)
        end, function(data)
         func("")
     end)
    end
end
--{{{请求功能列表
function LoginSubSystem:SendMsg_GetMainMenuList(func)
    if true then
        func("")
        return
    end
    local url = string.format("http://%s/loginvideo/menulist.json",GameProperties.cdnUrl)
    if not CommonHelper:IsNullOrEmpty(url) then
     NetManager:Get():SendHttpGet_GetAnnouncement(url, function(data)
            func(data)
        end, function(data)
         func("")
     end)
    end
end

function LoginSubSystem:Rec_GetAnnouncement(data)
    ---@type SC_SysPubInfo
    local msg = assert(Dll_JSON.decode(data))
    --print(ProtoMsgHelp.block(msg))
    AnnouncementDataManager:Get().Http=nil
    AnnouncementDataManager:Get():OnInit(msg)
end
--}}}











































































----------------------------------------------------------------------------------
--{{{请求登录账号
function LoginSubSystem:SendMsg_LoginUserServer(name, password)
    local url = string.format("http://%s/nowproj/login?", GameProperties.LoginUrl)
    NetManager:Get():SendHttpGet_Login(url, name, "1111", function(data)
        LoginSubSystem:Get():RecvMsg_Login(data)
    end, LoginSubSystem.HttpError)
end
--}}}

--{{{请求注册账号
function LoginSubSystem:SendMsg_Regist(name, password)
    local url = string.format("http://%s/nowproj/register?", GameProperties.LoginUrl)
    local name = PlayerPrefsHelper:GetValue_LoginName()
    print("register" .. name)
    NetManager:Get():SendHttpGet_Register(url, name, "1111", function(data)
        ---@type SC_RegisterRes
        local msg = assert(Dll_PB.decode("RegisterRes", data))
        print(ProtoMsgHelp.block(msg))
        if MsgErrorManager:Get():HttpMsgError(msg.result) then
            LoginSubSystem:Get():SendMsg_LoginUserServer(name, "1111")
        end
    end, LoginSubSystem.HttpError)
end
--}}}





--{{{请求服务器列表
function LoginSubSystem:SendMsg_GetServerList()
    local url = string.format("http://%s/nowproj/getserverlist?", GameProperties.LoginUrl)
    NetManager:Get():SendHttpGet_Register(url, "zhangsan", "123456", function(data)
        LoginSubSystem:Get():RecvMsg_ServerList(data)
    end, LoginSubSystem.HttpError)
end
--}}}


--{{{收到服务器列表
function LoginSubSystem:RecvMsg_ServerList(data)
    log("---   得到服务器列表")
    ---@type SC_GetServerListRes
    local msg = assert(Dll_PB.decode("GetServerListRes", data))
    print(ProtoMsgHelp.block(msg))
    ClientDataManager:Get():SetServerListMsg(msg)

    AnnouncementDataManager:Get().isMaintain = msg.isMaintain

    if msg.isMaintain then
        LoginSubSystem:Get():SendMsg_GetAnnouncement()
    else
        if SDKHelper:Get():ChickGtaSdk() then
            UIManager:Get():CloseAllPopups()
            UINotify:Get():SendNotification(UINotifyEvent.GameStartView_InitCG, true)
        else
            UIManager:Get():OpenPopup("ServerInfoView", CanvasType.FrontCanvas, "ServerInfoView", true)
        end
    end
end

--}}}


--{{{收到登录数据
function LoginSubSystem:RecvMsg_Login(data)
    ---@type SC_LoginRes
    local msg = assert(Dll_PB.decode("LoginRes", data))
    print(ProtoMsgHelp.block(msg))
    log("---   登录结果，result = ", msg.result)
    if MsgErrorManager:Get():HttpMsgError(msg.result) then
        log("c#---------------------登录服务器成功", msg.sessioncode)
        ClientDataManager:Get():SetLoginMsg(msg)

        --monoNetEaseManager:SetDeviceQua(msg.quality)

        mono.SetServerQualityLevel(monoNetEaseManager:GetDeviceQua())

        -- LoginSubSystem:Get():SendMsg_GetAnnouncement()

        LoginSubSystem:Get():SendMsg_GetServerList()
    end
end
--}}}


--{{{SDK登录,请求token
function LoginSubSystem:SendMsg_GmGetTokenReq()
    --monoAndroidUtility.DebugLog("---    SendMsg_GmGetTokenReq，=== = ")
    --if NetEaseDataManager:Get():GetSauthReturnData() then
    --    if NetEaseDataManager:Get():GetSauthReturnData().username then
    --        monoAndroidUtility.DebugLog("--- " .. NetEaseDataManager:Get():GetSauthReturnData().username)
    --    else
    --        monoAndroidUtility.DebugLog("---    username，为空 ")
    --    end
    --else
    --    monoAndroidUtility.DebugLog("---    sauthReturn，为空 ")
    --end
    --local fullUserName = NetEaseDataManager:Get():GetSauthReturnData().username
    --monoAndroidUtility.DebugLog("---    客服token过期了，给服务端发消息 fullUserName = " .. fullUserName)
    --local reqData = {
    --    userName = fullUserName,
    --}
    --log("---    客服token过期了，给服务端发消息 fullUserName = " .. reqData.userName)
    --local reqBytes = assert(Dll_PB.encode("GmGetTokenReq", reqData))
    --NetManager:Get():Send(OldMsgID.GM_GET_TOKEN_C2G_REQ, reqBytes)
end
--}}}


--{{{SDK登录,收到token
function LoginSubSystem:RecvMsg_GmGetTokenRes(data)
    ---@type SC_GmGetTokenRes
    local msg = assert(Dll_PB.decode("GmGetTokenRes", data))
    print(ProtoMsgHelp.block(msg))
    if msg.json then
        print("这是proto结构里面的json字段", tostring(msg.json))
    end
    --SDKManager:Get():GenToken(tostring(msg.json))
end
--}}}


--{{{sdk收到登录数据
function LoginSubSystem:RecvMsg_LoginSDK()
    log("c#---------------------登录服务器成功, RecvMsg_LoginSDK")
    -- LoginSubSystem:Get():SendMsg_GetAnnouncement()
    LoginSubSystem:Get():SendMsg_GetServerList()
    return
end
--}}}

----{{{sdk注册账号
--function LoginSubSystem:SendMsg_Register(name, password)
--    SDKManager:Get():RegisterUser(name, password)
--end
----}}}


function LoginSubSystem:SendMsg_ExitGame()
    NetManager:Get():SendDurationEvent()
    -- NetManager:Get():Send(MsgID.EXIT_GAME_C2G_REQ, "")
end

--function LoginSubSystem:ResetUserPassword(email)
--    SDKManager:Get():ResetUserPassword(email)
--end

--------------------------------------------------------------------------------------------登录服







--------------------------------------------------------------------------------------------gameserver




--{{{登录game成功，7号
function LoginSubSystem:SendMsg_EnterServer()
    log("---   请求进入服务器   sessioncode = ", ClientDataManager:Get():GetSessioncode())
    local reqData = {
        session = ClientDataManager:Get():GetSessioncode()
    }
    local reqBytes = assert(Dll_PB.encode("EnterServerReq", reqData))
    NetManager:Get():Send(OldMsgID.ENTER_SERVER_C2S_REQ, reqBytes)
end
--}}}


--{{{登录game成功，有角色，收到角色数据
function LoginSubSystem:RecvMsg_EnterServer(data)
    log("---   进入服务器成功，收到角色基本数据")
    ---@type SC_EnterServerRes
    local msg = assert(Dll_PB.decode("EnterServerRes", data))
    print(ProtoMsgHelp.block(msg))

    PlayerDataManager:Get():SetPlayerServerID(msg.serverId)

    if msg.playerInfo == nil then
        monoAndroidUtility.DebugLog("登录失败，需要播放视频创建角色----------不走sdk，直接打开创建角色界面---------")
        LoginFuncHelper:PlayerVideoCreateUser()
    else
        LoginFuncHelper:InitPlayerInfo_BaseData(msg.playerInfo)
    end

end
--}}}


--{{{登录game成功，没有角色需要创建角色
function LoginSubSystem:SendMsg_CreatePlayer(name)
    log("---   创建角色   UID = ", ClientDataManager:Get():GetUID(), "name = ", name)
    local reqData = {
        uid = ClientDataManager:Get():GetUID(),
        name = name
    }
    local reqBytes = assert(Dll_PB.encode("CreatePlayerReq", reqData))
    NetManager:Get():Send(OldMsgID.CREATE_PLAYER_C2S_REQ, reqBytes)
end
--}}}


--{{{创建角色成功
function LoginSubSystem:RecvMsg_CreatePlayer(data)
    log("---   创建角色成功，收到角色基本数据")
    ---@type SC_CreatePlayerRes
    local msg = assert(Dll_PB.decode("CreatePlayerRes", data))
    print(ProtoMsgHelp.block(msg))

    LoginFuncHelper:InitPlayerInfo_BaseData(msg.playerInfo)

    GlobalAd:Get():GlobalAdjust_CreateRole(msg.playerInfo.name)

    --NetEasePoneFunc:Get():CreateRoleLog()
end
--}}}


--{{{请求角色part数据
function LoginSubSystem:SendMsg_EnterPlayer()
    log("---   请求角色扩从数据   playerId = ", PlayerDataManager:Get():GetPlayerRID())

    --local msg = NetEaseDataManager:Get():GetEnterData()
    --
    --local reqData = {
    --    playerId = PlayerDataManager:Get():GetPlayerRID(),
    --    logInfo = msg.logInfoTab,
    --    sauthLoginType = tostring(msg.sauthLoginType),
    --    realNameMsg = msg.realNameMsg,
    --    aasMsg = msg.aasMsg
    --}
    --
    --local reqBytes = assert(Dll_PB.encode("EnterPlayerReq", reqData))
    --NetManager:Get():Send(OldMsgID.ENTER_PLAYER_C2S_REQ, reqBytes)
end
--}}}


--{{{收到角色part数据
function LoginSubSystem:RecvMsg_EnterPlayer(data)
    print("---   收到角色扩充数据")
    ---@type SC_EnterPlayerRes
    local msg = assert(Dll_PB.decode("EnterPlayerRes", data))
    print(ProtoMsgHelp.block(msg))

    LoginFuncHelper:InitPlayerInfo_PartData(msg)

    --GlobalAd:Get():GlobalAdjust_Login()
    if PlayerDataManager:Get():GetPlayerLoginDay() == 2 then
        GlobalAd:Get():GlobalAdjust_Day2Login()
    end

    --SDKManager:Get():GameLoginSuccess()

    local chatIp, chatPort = PlayerDataManager:Get():GetChatServerInfo()
    NetManager:Get():ConnectChatServer(chatIp, chatPort)

    --local guildIp, guildPort = PlayerDataManager:Get():GetGuildIpPort()
    --NetManager:Get():ConnectGuildServer(guildIp, guildPort)

    CommonHelper:NHPSdkSetRoleInfo()

    FriendSubsystem:Get():SendMsg_GetAllFriends()
    --SurveySubsystem:Get():SendMsg_SurveyInfo()
    FriendSubsystem:Get():SendMsg_ChatOtherToSelfOffline()

    LoginFuncHelper:EnterGame()

    --  RaceTrackDataManager:Get():RecServerData(msg.trackInfo)
    SegmentDataManager:Get():RecServerData(msg.traceSegs)

    -- MonoHelper.SetPlayerGuide()
end
--}}}



local __subsystem = LoginSubSystem()
function LoginSubSystem:Get()
    return __subsystem
end
return __subsystem
