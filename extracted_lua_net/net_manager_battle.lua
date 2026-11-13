


local __ManualDisconnect = false--是否手动断开服务器




--{{{tcp回调

--region 链接服务器回调
function NetManager:OnSyncBattleServerConnect(isSuccess, isReconnect)
    if isSuccess then
        log("---   同步战斗服链接成功")
        CommonSubsystem:Get():SendMsg_GetBattleRoomInfo()
    else
        logError("---   同步战斗服链接失败")
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.SyncBattleServerConnectFile))
    end
end
--endregion

--region 服务器断开回调
function NetManager:OnSyncBattleServerDisconnect()
    log("---   同步战斗服断开连接")

    if __ManualDisconnect then
        __ManualDisconnect = false
        return
    end

    if not NetManager:Get():GetGameServerIsConnect() then
        log("---   gameserver已断开，战斗服无法重连")
        return
    end

    logError("---   服务器异常，战斗服断开链接，game服链接正常...")
end
--endregion

--region 服务器异常回调
function NetManager:OnSyncBattleServerError( error )
    logError("---   同步战斗服收到错误码",tostring(error))
end
--endregion

--region 服务器重连失败
function NetManager:OnBattleReconnectFail()
    logError("---   同步战斗服5次重连失败...")
end
--endregion

--}}}



--{{{tcp   主动操作

--region 链接服务器
function NetManager:ConnectSyncBattleServer()
    local ip = MatchManager:Get():GetIP()
    local port = MatchManager:Get():GetPort()
    monoNetMgr:ConnectSyncBattleServer(ip, port)
end
--endregion

--region 断开服务器
function NetManager:DisconnectSyncBattleServer()
    __ManualDisconnect = true
    monoNetMgr:DisconnectSyncBattleServer()
end
--endregion

--region 启动断线重连机制，重连服务器
function NetManager:TryReconnectBattleServer()
    monoNetMgr:TryReconnectBattleServer()
end
--endregion

--region 发送tcp协议
function NetManager:SendSyncBattleServer(cmd, protoData)
    monoNetMgr:SendSyncBattleServer(cmd, protoData)
end
--endregion

--}}}