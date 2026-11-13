---@class NetManager
NetManager = class("NetManager")

function NetManager:initialize()
    NetSubSystemManager:Get():OnInit()

    self.GameLoginType = LoginType.None
    self.GameLogoutType = LogoutType.None
end

---@return NetManager
function NetManager:Get()
    if self._instance == nil then
        self._instance = NetManager()
    end
    return self._instance
end

function NetManager:OnInit()
    monoNetMgr:OnInit()
    monoNetMgr:SetLuaNetManager(self._instance)
    monoNetMgr:RegistReconnectEvt()
end

function NetManager:SetGameLoginType(value)
    self.GameLoginType = value
end
function NetManager:SetGameLogoutType(value)
    self.GameLogoutType = value
end
function NetManager:GetGameServerIsConnect()
    return monoNetMgr:GameServerIsConnect()
end
function NetManager:GetBattleReconnectState()
    return monoNetMgr:BattleReconnectState()
end

---@return  NetworkReachability
function NetManager:GetNetReachability()
    return monoNetMgr:GetNetReachability()
end

function NetManager:GetGameEnterType()
    if self.GameLoginType == LoginType.Normal and self.GameLogoutType == LogoutType.BackToLogin then
        return GameEnterType.BackToLogin
    end

    if self.GameLoginType == LoginType.Reconnect then
        return GameEnterType.QucikReconnect
    end

    return GameEnterType.AppStart
end




local _MsgSendBeginTime=nil
--{{{ 接受tcp协议,所有tcp服务器接受的协议都回调这个接口
function NetManager:OnReceive(cmd, bytes)
    log("lua get net msg ..." .. cmd)
    if _MsgSendBeginTime and  ClientDataManager:Get().MsgCount and ClientDataManager:Get().MsgTime then
        ClientDataManager:Get().MsgCount=ClientDataManager:Get().MsgCount+1
        ClientDataManager:Get().MsgTime= ClientDataManager:Get().MsgTime+CommonHelper:SubTimeByDateTime(_MsgSendBeginTime)
    end
    NetResponseEventManager:Get():DispatchEvent(cmd, bytes)
end
--}}}



--{{{ tcp    LoginSever
local _OnLoginSeverConnectSuccess=nil
function NetManager:ConnectLoginServer(OnConnectSuccess)
        _OnLoginSeverConnectSuccess=OnConnectSuccess
       local isWhite= PlayerPrefs.GetInt("GameProperties_FE",0)==1
       if isWhite then
           if CommonHelper:IsNullOrEmpty(PlayerPrefs.GetString("White_Ip", ""))==false then
               GameProperties.LoginUrl=PlayerPrefs.GetString("White_Ip", "")
           end
       end
        local ipPort = stringSplit(GameProperties.LoginUrl, ':')
        monoNetMgr:ConnectLoginServer(ipPort[1], tonumber(ipPort[2]))
    if _OnLoginSeverConnectSuccess==nil then
        CommonHelper:PlayScreenEffectWaiting(true)
    end
end

function NetManager:OnLoginServerConnect(isSuccess, isReconnect)
    log("server服链接成功...", "isSuccess:", isSuccess, "isReconnect:", isReconnect)
    if _OnLoginSeverConnectSuccess then
        _OnLoginSeverConnectSuccess()
        _OnLoginSeverConnectSuccess=nil
        return
    end
    if RankListTestVerifyDataManager:Get():GetIsVerify() then
        RankListTestVerifyDataManager:Get():GetServerList()
    else
        CommonHelper:PlayScreenEffectWaiting(false)
        if isSuccess then
            log("SDKHelper:Get():ChickSdk()", SDKHelper:Get():ChickSdk())
            if SDKHelper:Get():ChickSdk()  then
                QuickTa:Get():TrackEvent(TrackEventNames.LoginServerContent, nil,TrackEventType.First,AnalysisType.LoginServerContent)
                  log("UnifySDKManager:Get():IAccount().isLogin", UnifySDKManager:Get():IAccount().isLogin)
                if UnifySDKManager:Get():IAccount().isLogin then
                    local uid = PlayerPrefsHelper:GetValue_LoginName()
                    LoginSubSystem:Get():Send_GetServerList(uid)
                    ClientDataManager:Get():SetGameState(GameState.Login_Success)
                else
                    UnifySDKManager:Get():IAccount():Login(false)
                end
            else
                UINotify:Get():SendNotification(UINotifyEvent.LoginView_OpenLoginView)
                ClientDataManager:Get():SetGameState(GameState.Login_Success)
            end
        end
    end

end

function NetManager:DisconnectLoginServer()
    monoNetMgr:DisconnectLoginServer()
end
function NetManager:OnLoginServerError()
    CommonHelper:PlayScreenEffectWaiting(false)
end

function NetManager:OnLoginServerReconnect()
    -- CommonHelper:PlayScreenEffectWaiting(true)
end

function NetManager:SendLogin(cmd, protoData,ismsgidx0)
    monoNetMgr:SendLogin(cmd, protoData,ismsgidx0 or false)
end
--}}}






--{{{ tcp    GameSever
local  _GameServerConnected=nil
--region 链接服务器
function NetManager:ConnectGameServer(ip, port,gameServerConnected)
    _GameServerConnected=gameServerConnected
    QuickTa:Get():TrackEvent(TrackEventNames.start_game, nil,TrackEventType.First,AnalysisType.start_game)
    monoNetMgr:ConnectGameServer(ip, port)
    if _GameServerConnected==nil then
        LoginFuncHelper:ConnectingGame()
    end
end
local ReconnectCount = 0
-- 连接服务器返回
function NetManager:OnGameServerConnect(isSuccess, isReconnect)
    log("game服链接成功...", "isSuccess:", isSuccess, "isReconnect:", isReconnect)
    if _GameServerConnected then
        _GameServerConnected()
        _GameServerConnected=nil
        return
    end
    if RankListTestVerifyDataManager:Get():GetIsVerify() then
        RankListTestVerifyDataManager:Get():EnterGameServer()
        return
    end
    if isSuccess then
        QuickTa:Get():TrackEvent(TrackEventNames.GameServerContent, nil,TrackEventType.First,AnalysisType.GameServerContent)
        NetManager:Get():StartHeartBeat()
        if ReconnectCount>0 then
            ReconnectCount=0
            MessageBoxHelp:Get():BreakMessageBox()
        end
    end
    LoginSubSystem:Get():OnGameServerConnect(isSuccess, isReconnect)

    LoginFuncHelper:ConnectingGameFinish(isSuccess)
end
function NetManager:StartHeartBeat()
    monoNetMgr:StartHeartBeat(CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() }))
end
--endregion
function NetManager:OnErrorRemoveDelayInfo(cmd)
    monoNetMgr:OnErrorRemoveDelayInfo(cmd)
end
--region 重连服务器
function NetManager:ReconnectGameServer()
    monoNetMgr:ReconnectGameServer()
end
function NetManager:OnGameServerReconnect()
    CommonHelper:PlayScreenEffectWaiting(true)
end

function NetManager:OnLoginServerDisconnect()

end
--endregion

--region 服务器断开连接
function NetManager:DisconnectGameServer()
    monoNetMgr:DisconnectGameServer()
end
--LoginFuncHelper:LoginOut_GameBackToLogin_Combine(true, false)

-- 服务器断开返回
function NetManager:OnGameServerDisconnect()
    logError("GameServer Disconnect提示框",ReconnectCount)
    if HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.NetErrorLog) then
        HotfixHelper:TrackAppStart("GameServerDisconnect",nil,nil,true,AnalysisType.NetError)
    end
    CommonHelper:PlayScreenEffectWaiting(false)
    if ReconnectCount >= 2 then
        ReconnectCount = 0
        logError("GameServer Disconnect打开登录提示")
        local boxfunc = function()
            local text = ClientDataManager:Get():GetTemplateString(TemplateStringID.NetConnectFail)
            local ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue, text, ClientDataManager:Get():GetTemplateString(TemplateStringID.GameWarmPrompt), nil, nil, false, false, true)
            if ret == MessageBoxHelp.BtnType.OK then
                logError("GameServer Disconnect退出登录")
                LoginFuncHelper:LoginOut_GameBackToLogin_Combine(false, true, nil, false)
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
        NetManager:Get():SendEvent(ReconnectCount)
        return
    else
        local boxfunc = function()
            logError("GameServer Disconnect打开提示框")
            local text = ClientDataManager:Get():GetTemplateString(TemplateStringID.NetReConnect)
            ReconnectCount = ReconnectCount + 1
            local ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue, text, ClientDataManager:Get():GetTemplateString(TemplateStringID.GameWarmPrompt), nil, nil, false, false, true)
            if ret == MessageBoxHelp.BtnType.OK then
                logError("GameServer Disconnect重连调用")
                monoNetMgr:GameServerReconnect()
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
        NetManager:Get():SendEvent(ReconnectCount)
    end
end
--endregion

--region 服务器错误返回
function NetManager:OnGameServerError(error)
    print("---   error:OnGameServerError = ", error)
    --LoginFuncHelper:ConnectingGameError()
end
--endregion

--region 发送tcp协议

function NetManager:Send(cmd, protoData,ismsgidx0,showTips)
    if ismsgidx0==nil then ismsgidx0=false end
    _MsgSendBeginTime=CommonHelper:GetNowTime()
    if showTips==nil then MsgErrorManager:Get().ShowTips=true else MsgErrorManager:Get().ShowTips=showTips end
    monoNetMgr:Send(cmd, protoData,ismsgidx0)
end
--endregion

--region 退出登录
function NetManager:SetGameServerLogout()
    monoNetMgr:SetGameServerLogout()
end
--endregion

--}}}


--{{{tcp    ChatSever

--region 链接服务器
function NetManager:ConnectChatServer(ip, port)
    monoNetMgr:ConnectChatServer(ip, port)
end
function NetManager:OnChatServerConnect(isSuccess, isReconnect)
    if isSuccess then
        if isReconnect then
            CommonHelper:PlayScreenEffectWaiting(false)
        end

        --连接成功之后，发5011
        ChatSubsystem:Get():SendMsg_PlayerLogInG2CReq(PlayerDataManager:Get():GetPlayerRID())

        logError("OnChatServerConnect = success ")
    else
        --CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ClubChatNotLinkedChatServer))
        logError("OnChatServerConnect = fail")
    end
end
--endregion

--region 服务器断开
function NetManager:DisconnectChatServer()
    monoNetMgr:DisconnectChatServer()
end

function NetManager:OnChatServerDisconnect()
    --logError("ChatServer Disconnect")
    --ChatDataManager:Get():SetIsConnectedSuccess(false)
    --CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ClubChatChatServerHasDisconnect))
end
--endregion

--region 服务器重连
function NetManager:ReconnectChatServer()
    monoNetMgr:ReconnectChatServer()
end
--endregion

--region 服务器error
function NetManager:OnChatServerError(error)
    logError("OnChatServerError = " .. tostring(error))
end
--endregion

--region 发送tcp协议
function NetManager:SendChat(cmd, protoData)
    monoNetMgr:SendChat(cmd, protoData)
end
--endregion



--region 全部断开连接
function NetManager:DisconnetAll()
    monoNetMgr:DisconnetAll()
end
--endregion

--}}}


--{{{tcp    ChatSever

--region 链接服务器
function NetManager:ConnectChatServer(ip, port)
    monoNetMgr:ConnectChatServer(ip, port)
end
function NetManager:OnChatServerConnect(isSuccess, isReconnect)
    if isSuccess then
        if isReconnect then
            CommonHelper:PlayScreenEffectWaiting(false)
        end

        --连接成功之后，发5011
        ChatSubsystem:Get():SendMsg_PlayerLogInG2CReq(PlayerDataManager:Get():GetPlayerRID())

        logError("OnChatServerConnect = success ")
    else
        --CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ClubChatNotLinkedChatServer))
        logError("OnChatServerConnect = fail")
    end
end
--endregion

--region 服务器断开
function NetManager:DisconnectChatServer()
    monoNetMgr:DisconnectChatServer()
end

function NetManager:OnChatServerDisconnect()
    --logError("ChatServer Disconnect")
    --ChatDataManager:Get():SetIsConnectedSuccess(false)
    --CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ClubChatChatServerHasDisconnect))
end
--endregion

--region 服务器重连
function NetManager:ReconnectChatServer()
    monoNetMgr:ReconnectChatServer()
end
--endregion

--region 服务器error
function NetManager:OnChatServerError(error)
    logError("OnChatServerError = " .. tostring(error))
end
--endregion

--region 发送tcp协议
function NetManager:SendChat(cmd, protoData)
    monoNetMgr:SendChat(cmd, protoData)
end
--endregion



--region 全部断开连接
function NetManager:DisconnetAll()
    monoNetMgr:DisconnetAll()
end
--endregion

--}}}

--{{{tcp    GuildServer

--region 链接服务器
function NetManager:ConnectGuildServer(ip, port)
    if port ~= 0 then
        monoNetMgr:ConnectGuildServer(ip, port)
    end
end
function NetManager:OnGuildServerConnect(isSuccess, isReconnect)
    if isSuccess then
        if isReconnect then
            CommonHelper:PlayScreenEffectWaiting(false)
        end
        --连接成功之后，发765
        ClubSubsystem:Get():SendSendMsg_EnterGuild()

        logError("OnGuildServerConnect = success ")
    else
        logError("OnGuildServerConnect = fail")
    end
end
--endregion

--region 服务器断开
function NetManager:DisconnectGuildServer(isNeedReconnected)
    print("------工会服主动断开，是否需要重连----->", isNeedReconnected)
    --monoNetMgr:DisconnectGuildServer(isNeedReconnected)
end

function NetManager:OnGuildServerDisconnect()
    --logError("ChatServer Disconnect")
    --ChatDataManager:Get():SetIsConnectedSuccess(false)
    --CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ClubChatChatServerHasDisconnect))
end
--endregion

--region 服务器重连
function NetManager:ReconnectGuildServer()
    monoNetMgr:ReconnectGuildServer()
end
--endregion

--region 服务器error
function NetManager:OnGuildServerError(error)
    logError("OnGuildServerError = " .. tostring(error))

end
--endregion

--region 发送tcp协议
function NetManager:SendGuild(cmd, protoData)
    monoNetMgr:SendGuild(cmd, protoData)
end
--endregion

--region 工会服是否已连接
function NetManager:GetGuildServerIsConnected()
    return monoNetMgr:GuildServerIsConnect()
end
--endregion

--}}}


--region 全部断开连接
function NetManager:DisconnetAll()
    monoNetMgr:DisconnetAll()
end
--endregion

--}}}
--{{{ http协议，post方式

--region 自建赛事
function NetManager:SendHttpPost_RaceSelf(url, msgid, protoData, recvfun, class)
    local playerId = PlayerDataManager:Get():GetPlayerRID()

    --mono.SendHttpPostRequest(url,
    --        function(data)
    --            if recvfun then
    --                if class then
    --                    recvfun(class, data)
    --                else
    --                    recvfun(data)
    --                end
    --            end
    --        end,
    --        nil,
    --        "pid", tostring(playerId),
    --        "body", protoData,
    --        "mid", tostring(msgid))
end
--endregion


--}}}


--{{{ http协议，get方式
--region 公告
function NetManager:SendHttpGet_GetAnnouncement(url, recvfun, errorfun)
   return self:SendHttpGetRequest(url, recvfun, errorfun)
end
--endregion


--region 登录
function NetManager:SendHttpGet_Login(url, name, password, recvfun, errorfun)
    local deviceModel = CSSystemInfo.deviceModel

    local param = {
        name = name,
        passwd = password,
        device_model = deviceModel,
    }
    param = Dll_JSON.encode(param)
    local HttpHelper2= HttpHelperLua()
    HttpHelper2.successCallback=recvfun
    HttpHelper2.errorCallback=errorfun
    HttpHelper2:SendHttpPost(url,
            "body",
            param)
    LuaRelevance:Get():AddHttpRequest(HttpHelper2)

end
--endregion


--region 注册
function NetManager:SendHttpGet_Register(url, name, password, recvfun, errorfun)
    local HttpHelper2= HttpHelperLua()
    HttpHelper2.successCallback=recvfun
    HttpHelper2.errorCallback=errorfun
    HttpHelper2:SendHttpPost(url,
            "name",
            name,
            "passwd",
            password)
    LuaRelevance:Get():AddHttpRequest(HttpHelper2)
end

function NetManager:SendHttpGet_Register_Quick(url, name, password, oldplayer, recvfun, errorfun)
    local HttpHelper2= HttpHelperLua()
    HttpHelper2.successCallback=recvfun
    HttpHelper2.errorCallback=errorfun
    HttpHelper2:SendHttpPost(url,
            "name",
            name,
            "passwd",
            password,
            "oldplayer",
            oldplayer)
    LuaRelevance:Get():AddHttpRequest(HttpHelper2)
end
--endregion


--region 好友
function NetManager:SendHttpPost_Json(url, recvfun, errorfun, jsonStr)
    self:SendHttpPost_JsonRequest(url,jsonStr,recvfun,errorfun)
end
--endregion

function NetManager:SendHttpGetRequest(url,fun,errorfun)
    local HttpHelper2= HttpHelperLua()
    HttpHelper2.successCallback=fun
    HttpHelper2.errorCallback=errorfun
    HttpHelper2:SendHttp(url)
    LuaRelevance:Get():AddHttpRequest(HttpHelper2)
    return HttpHelper2
end
function NetManager:SendHttpPost_JsonRequest(url, jsonData, recvfun, errorfun)
    local HttpHelper2= HttpHelperLua()
    HttpHelper2.successCallback=recvfun
    HttpHelper2.errorCallback=errorfun
    HttpHelper2:SendHttpPost_Json(url,jsonData)
    LuaRelevance:Get():AddHttpRequest(HttpHelper2)
end
function NetManager:SendEvent(count)
    local table={
        ReconnectCount=count
    }
    QuickTa:Get():TrackEvent(TrackEventNames.GameNetError,table)
end
function NetManager:SendDurationEvent()
    if ClientDataManager:Get().MsgCount>0 then
        local time=ClientDataManager:Get().MsgTime/ClientDataManager:Get().MsgCount
        ClientDataManager:Get().MsgTime=0
        ClientDataManager:Get().MsgCount=0
        local table={
            Time=time
        }
        QuickTa:Get():TrackEvent(TrackEventNames.GameNetDuration,table)
    end
end

--}}}
