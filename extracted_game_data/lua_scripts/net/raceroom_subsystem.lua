---@class RaceRoomSubsystem
RaceRoomSubsystem = class("RaceRoomSubsystem")

function RaceRoomSubsystem:initialize(...)
    NetResponseEventManager:Get():AddListener(MsgID.CREATE_RACE_ROOM_S2C_RES, self, self.SendMsg_CreateRoomResult)
    NetResponseEventManager:Get():AddListener(MsgID.ENTER_RACE_ROOM_S2C_RES, self, self.SendMsg_JoinSelectedRoomResult)
    NetResponseEventManager:Get():AddListener(MsgID.EXIT_RACE_ROOM_S2C_RES, self, self.RecvMsg_Leave)
    NetResponseEventManager:Get():AddListener(MsgID.DISSOLUTION_RACE_ROOM_S2C_RES, self, self.RecvMsg_RoomDismiss)
    NetResponseEventManager:Get():AddListener(MsgID.KICK_OUT_RACE_ROOM_S2C_RES, self, self.RecvMsg_KickoutNotifySelf)
    NetResponseEventManager:Get():AddListener(MsgID.READY_RACE_ROOM_S2C_RES, self, self.Rec_ReadySelfRoom)
    NetResponseEventManager:Get():AddListener(MsgID.CANCEL_RACE_ROOM_S2C_RES, self, self.Rec_CancelReadySelfRoom)
    NetResponseEventManager:Get():AddListener(MsgID.BEGIN_BATTLE_RACE_ROOM_S2C_RES, self, self.RecvMsg_FightBegin)
    NetResponseEventManager:Get():AddListener(MsgID.GET_RACE_ROOM_LIST_S2C_RES, self, self.RecvMsg_GetRoomList)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_ROOM_CHANGE_CAR_S2C_RES, self, self.RecvMsg_PlayerChangeCarNotifyEverybody)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_ROOM_CHANGE_TRACK_S2C_RES, self, self.RecvMsg_ChangeTrack)
    NetResponseEventManager:Get():AddListener(MsgID.SEARCH_RACE_ROOM_S2C_RES, self, self.RecvMsg_SearchRoom)
    NetResponseEventManager:Get():AddListener(MsgID.FINISH_RACE_ROOM_S2C_RES, self, self.RecvMsg_FinishBattle)
    NetResponseEventManager:Get():AddListener(MsgID.OBSERVER_RACE_ROOM_S2C_RES, self, self.RecvMsg_ObserverRaceRoom)


end
--{{{房间赛_创建房间
function RaceRoomSubsystem:SendMsg_CreateRoom(trackid,sceneid,name,passwd,type,trackidx,carIdx,israndom)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),trackid,sceneid,passwd,name,type,trackidx,carIdx,israndom})
    NetManager:Get():Send(MsgID.CREATE_RACE_ROOM_C2S_REQ, reqBytes)
end
--}}}
--{{{房间赛_加入指定房间
function RaceRoomSubsystem:SendMsg_JoinSelectedRoom(roomid, passwd, autoready)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),roomid,passwd})
    NetManager:Get():Send(MsgID.ENTER_RACE_ROOM_C2S_REQ, reqBytes)
end
--}}}
--{{{房间赛_观战指定房间
function RaceRoomSubsystem:SendMsg_ObserverSelectedRoom(roomid)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),roomid})
    NetManager:Get():Send(MsgID.OBSERVER_RACE_ROOM_C2S_REQ, reqBytes)
end
--}}}

--{{{房间赛_创建房间结果
function RaceRoomSubsystem:SendMsg_CreateRoomResult(data)
    --local msg = assert(Dll_PB.decode("RetEnterSelfRoom", data))
    --print(ProtoMsgHelp.block(msg))
    --RaceRoomManager:Get():SetRoomData(msg)
    --UIManager:Get():OpenView("RaceRoomDetailView",CanvasType.MainCanvas,"RaceRoomDetailView")
    --UINotify:Get():SendNotification(UINotifyEvent.RaceRoomDetailView_SetData)
end
--}}}
--{{{房间赛_加入指定房间结果
function RaceRoomSubsystem:SendMsg_JoinSelectedRoomResult(data)
    log("---   加入指定房间，无异常")
    ---@type SC_RetEnterSelfRoom
    local msg = assert(Dll_PB.decode("RetEnterSelfRoom", data))
    print(ProtoMsgHelp.block(msg))
    if msg.rid~=msg.enterRid then
        RaceRoomManager:Get():AddPlayer(msg.racer[1])
        UINotify:Get():SendNotification(UINotifyEvent.RaceRoomDetailView_Revise)
    else
        RaceRoomManager:Get():SetRoomData(msg)
        UIManager:Get():OpenView("RaceRoomDetailView",CanvasType.MainCanvas,"RaceRoomDetailView")
        UINotify:Get():SendNotification(UINotifyEvent.RaceRoomDetailView_SetData)
    end

end
--}}}

--{{{房间赛_主动离开房间
function RaceRoomSubsystem:SendMsg_Leave()
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.EXIT_RACE_ROOM_C2S_REQ, reqBytes)
end
--}}}




--{{{房间赛_请求开始
function RaceRoomSubsystem:SendMsg_Start(carIdx)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),carIdx})
    NetManager:Get():Send(MsgID.BEGIN_BATTLE_RACE_ROOM_C2S_REQ, reqBytes)
end
--}}}

--{{{房间赛_开始战斗
function RaceRoomSubsystem:RecvMsg_FightBegin(data)
    ---@type SC_RetSelfStart
    local msg = assert(Dll_PB.decode("RetSelfStart", data))
    print(ProtoMsgHelp.block(msg))
    RaceRoomManager:Get():LoadBattleScene(msg.starttime)
end
--}}}
--{{{房间赛观赛_开始战斗
function RaceRoomSubsystem:RecvMsg_ObserverRaceRoom(data)
    ---@type SC_RetEnterSelfRoom
    local msg = assert(Dll_PB.decode("RetEnterSelfRoom", data))
    print(ProtoMsgHelp.block(msg))
    RaceRoomManager:Get():LoadObBattleScene(msg)
end
--}}}


--{{{房间赛_踢人
function RaceRoomSubsystem:SendMsg_Kickout(pid)
    local reqBytes=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),pid})
    NetManager:Get():Send(MsgID.KICK_OUT_RACE_ROOM_C2S_REQ, reqBytes)
end
--}}}


--{{{房间赛_玩家被踢出房间，被踢的人接收消息
function RaceRoomSubsystem:RecvMsg_KickoutNotifySelf(data)
    ---@type SC_RetKickSelfRoom
    local msg = assert(Dll_PB.decode("RetKickSelfRoom", data))
    print(ProtoMsgHelp.block(msg))

    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.YouOutRoom))

    NetManager:Get():DisconnectSyncBattleServer()
    RaceRoomManager:Get():ClearData()

    if UIManager:Get():IsViewShow("RaceRoomSelectCarView") then
        UIManager:Get():CloseView()
    end

    if UIManager:Get():IsViewShow("RaceRoomDetailView") then
        UIManager:Get():CloseView()
    end
    if UIManager:Get():IsViewShow("RaceRoomView") then
        UINotify:Get():SendNotification(UINotifyEvent.RaceRoomView_Refresh)
    end
end
--}}}

--{{{房间赛_请求房间列表
function RaceRoomSubsystem:SendMsg_GetRoomList(type)
    local reqBytes=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),type})
    NetManager:Get():Send(MsgID.GET_RACE_ROOM_LIST_C2S_REQ, reqBytes)
end
--}}}


--{{{房间赛_返回房间列表
function RaceRoomSubsystem:RecvMsg_GetRoomList(data)
    ---@type SC_RetSelfRoomList
    local msg = assert(Dll_PB.decode("RetSelfRoomList", data))
    print(ProtoMsgHelp.block(msg))
    UINotify:Get():SendNotification(UINotifyEvent.RaceRoomView_SetData, msg)
end
--}}}

--{{{房间赛_请求查找房间
function RaceRoomSubsystem:SendMsg_SearchRoom(id)
    local reqBytes=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id})
    NetManager:Get():Send(MsgID.SEARCH_RACE_ROOM_C2S_REQ, reqBytes)
end
--}}}

--{{{房间赛_返回查找房间结果
function RaceRoomSubsystem:RecvMsg_SearchRoom(data)
    ---@type SC_RetSearchSelf
    local msg = assert(Dll_PB.decode("RetSearchSelf", data))
    print(ProtoMsgHelp.block(msg))

    if msg.selfroom == nil then
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.RaceRoomSearchNull))
    end
    UINotify:Get():SendNotification(UINotifyEvent.RaceRoomView_UpdateSearch, msg)
end
--}}}

--{{{房间赛_准备
function RaceRoomSubsystem:SendMsg_Ready(idx)
    local reqBytes=  CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),idx})
    NetManager:Get():Send(MsgID.READY_RACE_ROOM_C2S_REQ, reqBytes)
end
--}}}
--{{{(取消准备)
function RaceRoomSubsystem:SendMsg_CancelReady()
    local reqBytes=  CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.CANCEL_READY_RACE_ROOM_C2S_REQ, reqBytes)
end
--}}}
--{{{房间赛_接受玩家准备状态，广播
function RaceRoomSubsystem:Rec_ReadySelfRoom(data)
    ---@type SC_RetReadySelfRoom
    local msg = assert(Dll_PB.decode("RetReadySelfRoom", data))
    print(ProtoMsgHelp.block(msg))

    RaceRoomManager:Get():SetPlayerReady(msg.readyrid, true)
    UINotify:Get():SendNotification(UINotifyEvent.RaceRoomDetailView_ReviseWithoutMesh)
end
--}}}
--{{{房间赛_接受玩家取消准备状态，广播
function RaceRoomSubsystem:Rec_CancelReadySelfRoom(data)
    ---@type SC_RetReadySelfRoom
    local msg = assert(Dll_PB.decode("RetReadySelfRoom", data))
    print(ProtoMsgHelp.block(msg))

    RaceRoomManager:Get():SetPlayerReady(msg.readyrid, false)
    UINotify:Get():SendNotification(UINotifyEvent.RaceRoomDetailView_ReviseWithoutMesh)
end
--}}}

--{{{房间赛_玩家离开房间，广播，不包括主动离开的人
function RaceRoomSubsystem:RecvMsg_Leave(data)
    ---@type SC_RetQuitSelfRoom
    local msg = assert(Dll_PB.decode("RetQuitSelfRoom", data))
    print(ProtoMsgHelp.block(msg))

    local player = RaceRoomManager:Get():GetPlayerDataByID(msg.quitrid)
    if msg.errorcode>0 then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(tostring(msg.errorcode)))
        if UIManager:Get():IsViewShow("RaceRoomDetailView") then
            UIManager:Get():CloseView()
        end
        if UIManager:Get():IsViewShow("RaceRoomView") then
            UIManager:Get():CloseView()
        end
    else
        if msg.rid==msg.quitrid then
            RaceRoomManager:Get():ClearData()
            if UIManager:Get():IsViewShow("RaceRoomDetailView") then
                UIManager:Get():CloseView()
            end
        else
            if player:IsLeader() then
                RaceRoomManager:Get():ClearData()
                if UIManager:Get():IsViewShow("RaceRoomDetailView") then
                    UIManager:Get():CloseView()
                end
                if UIManager:Get():IsViewShow("RaceRoomView") then
                    UINotify:Get():SendNotification(UINotifyEvent.RaceRoomView_Refresh)
                end
            else
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceRoomPlayerLeaveRoom,player:GetName()))
                RaceRoomManager:Get():KickoutPlayer(msg.quitrid)
                UINotify:Get():SendNotification(UINotifyEvent.RaceRoomDetailView_Revise)
            end
        end
    end
end
--}}}

















local  ReviseRoomFunc=nil
--{{{房间赛_请求更改房间信息
function RaceRoomSubsystem:SendMsg_ReviseRoom(trackid,flag,backFunc)
    ReviseRoomFunc=backFunc
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),trackid,flag})
    NetManager:Get():Send(MsgID.RACE_ROOM_CHANGE_TRACK_C2S_REQ, reqBytes)
end
--}}}
--{{{房间赛_更换赛道
function RaceRoomSubsystem:RecvMsg_ChangeTrack(data)
    ---@type SC_RetAlterTrack
    local msg = assert(Dll_PB.decode("RetAlterTrack", data))
    print(ProtoMsgHelp.block(msg))

    RaceRoomManager:Get():ReviseRoomInfo(msg)
    UINotify:Get():SendNotification(UINotifyEvent.RaceRoomDetailView_Revise)
    if ReviseRoomFunc then
        ReviseRoomFunc()
        ReviseRoomFunc=nil
    end
end
--}}}

--{{{房间赛_请求战斗结束
function RaceRoomSubsystem:SendMsg_BattleFinish(value)
    local reqBytes= CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.FINISH_RACE_ROOM_C2S_REQ, reqBytes)
end
--}}}
--{{{房间赛_请求战斗结束
function RaceRoomSubsystem:RecvMsg_FinishBattle()

end
--}}}
--{{{房间赛_请求更换车辆
function RaceRoomSubsystem:SendMsg_ChangeCar(idx)
    local reqBytes= CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),idx})
    NetManager:Get():Send(MsgID.RACE_ROOM_CHANGE_CAR_C2S_REQ, reqBytes)
end
--}}}
--{{{房间赛_玩家更换车辆，广播除了换车的人
function RaceRoomSubsystem:RecvMsg_PlayerChangeCarNotifyEverybody(data)
    ---@type SC_RetAlterCar
    local msg = assert(Dll_PB.decode("RetAlterCar", data))
    print(ProtoMsgHelp.block(msg))

    RaceRoomManager:Get():UpdatePlayerCarData(msg.alterrid, msg.car, PlayerPrefsHelper:GetValue_MainMenuViewCarIndex())
    UINotify:Get():SendNotification(UINotifyEvent.RaceRoomDetailView_Revise)
end
--}}}
--{{{房间赛_房间解散
function RaceRoomSubsystem:RecvMsg_RoomDismiss()
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.LanderDissolutionRoom))
    NetManager:Get():DisconnectSyncBattleServer()
    RaceRoomManager:Get():ClearData()
    if UIManager:Get():IsViewShow("RaceRoomDetailView") then
        UIManager:Get():CloseView()
    end
    if UIManager:Get():IsViewShow("RaceRoomView") then
        UINotify:Get():SendNotification(UINotifyEvent.RaceRoomView_Refresh)
    end
end
--}}}
































--{{{房间赛_玩家被踢出房间，除了被踢的人收到消息
function RaceRoomSubsystem:RecvMsg_KickoutNotifyEveryBody(data)
    ---@type SC_LeaveGlobalRoomNotify
    local msg = assert(Dll_PB.decode("LeaveGlobalRoomNotify", data))
    print(ProtoMsgHelp.block(msg))

    local player = RaceRoomManager:Get():GetPlayerDataByID(msg.pid)
    if player then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.OtherOutRoom,player:GetName()))
        RaceRoomManager:Get():KickoutPlayer(msg.pid)
    end

    UINotify:Get():SendNotification(UINotifyEvent.RaceRoomDetailView_Revise)
end
--}}}

--{{{房间赛_快速加入房间
function RaceRoomSubsystem:SendMsg_QuickJoinRoom(ready)
    ---@type SC_QuickJoinGlobalRoomReq
    local reqData = {
        autoReady = ready,
    }
    local reqBytes = assert(Dll_PB.encode("QuickJoinGlobalRoomReq", reqData))
    NetManager:Get():Send(OldMsgID.QUICK_JOIN_GLOBAL_ROOM_C2S_REQ, reqBytes)
end
--}}}

--{{{房间赛_快速加入房间结果
function RaceRoomSubsystem:SendMsg_QuickJoinRoomResult()
    log("---   快速加入房间，无异常")
end
--}}}


----{{{房间赛_玩家更换车辆，换车的人收到数据
--function RaceRoomSubsystem:RecvMsg_PlayerChangeCarNotifySelf(data)
--    ---@type SC_Tuple1
--    local msg = assert(Dll_PB.decode("Tuple1", data))
--    print(ProtoMsgHelp.block(msg))
--
--    RaceRoomManager:Get():UpdatePlayerCarData(PlayerDataManager:Get():GetPlayerUID(), nil, msg.num)
--    UINotify:Get():SendNotification(UINotifyEvent.RaceRoomDetailView_Revise)
--
--    if UIManager:Get():IsViewShow("RaceRoomSelectCarView") then
--        UIManager:Get():CloseView()
--    end
--end
----}}}

--{{{房间赛_接收更改房间信息
function RaceRoomSubsystem:RecvMsg_ReviseRoom(data)
    ---@type SC_RetAlterCar
    local msg = assert(Dll_PB.decode("RetAlterCar", data))
    print(ProtoMsgHelp.block(msg))

    RaceRoomManager:Get():ReviseRoomInfo(msg)
    UINotify:Get():SendNotification(UINotifyEvent.RaceRoomDetailView_ReviseWithoutMesh)

end
--}}}


----{{{房间赛_请求更改赛道
--function RaceRoomSubsystem:SendMsg_ReviseTrack(trackid)
--
--end
----}}}


----{{{房间赛_接收更改赛道
--function RaceRoomSubsystem:RecvMsg_ReviseTrack(data)
--
--end
----}}}


--{{{房间赛_有人加入
function RaceRoomSubsystem:RecvMsg_PlayerJoin(data)
    ---@type SC_JoinGlobalRoomNotify
    local msg = assert(Dll_PB.decode("JoinGlobalRoomNotify", data))
    print(ProtoMsgHelp.block(msg))


end
--}}}









--{{{房间赛_玩家离开房间，通知主动离开的人
function RaceRoomSubsystem:RecvMsg_LeaveNotifySelf()
    if RaceRoomManager:Get():IsLeader() then
        log("---   房主解散房间，通知房主")
    end

    NetManager:Get():DisconnectSyncBattleServer()
    RaceRoomManager:Get():ClearData()
    if UIManager:Get():IsViewShow("RaceRoomDetailView") then
        UIManager:Get():CloseView()
    end
    if UIManager:Get():IsPersistentViewShow("RaceRoomCreateView") then
        UINotify:Get():SendNotification(UINotifyEvent.RaceRoomView_SetViewInfo, { "RaceRoomCreateView", false })
        UIManager:Get():HidePersistentView("RaceRoomCreateView")
    end
    if UIManager:Get():IsViewShow("RaceRoomView") then
        UINotify:Get():SendNotification(UINotifyEvent.RaceRoomView_Refresh)
    end

end
--}}}








--{{{房间赛_请求开始返回结果
function RaceRoomSubsystem:RecvMsg_Start()
    log("---   房间赛_请求开始战斗,无异常")
end
--}}}


--{{{房间赛_开始加载战斗场景
function RaceRoomSubsystem:RecvMsg_LoadingStart(data)
    ---@type SC_NotifyRoomFight
    local msg = assert(Dll_PB.decode("NotifyRoomFight", data))
    print(ProtoMsgHelp.block(msg))

    RaceRoomManager:Get():UpdateRoomState(SerE_RaceRoomState.Loading)
    RaceRoomManager:Get():LoadBattleScene(msg, nil)

    RaceRoomManager:Get():ClientResetPlayerReadyState()
end
--}}}


--{{{房间赛_上传loading进度
function RaceRoomSubsystem:SendMsg_LoadingProgress(value)
    ---@type SC_UpdateBarReq
    local reqData = {
        per = value,
    }
    local reqBytes = assert(Dll_PB.encode("UpdateBarReq", reqData))
    NetManager:Get():SendSyncBattleServer(OldMsgID.GLOBAL_ROOM_LOAD_C2SB_REQ, reqBytes)
end
--}}}


--{{{房间赛_接收玩家loading进度
function RaceRoomSubsystem:RecvMsg_LoadingProgress(data)
    ---@type SC_UpdateBarNotify
    local msg = assert(Dll_PB.decode("UpdateBarNotify", data))
    print(ProtoMsgHelp.block(msg))
end
--}}}







--{{{房间赛_接收战斗结束
function RaceRoomSubsystem:RecvMsg_BattleFinish()
    log("---   房间赛_战斗结束,无异常")
    BattleDataManager:Get():SetStateBattleResult()
end
--}}}


----{{{房间赛_错误
--function RaceRoomSubsystem:RecvMsg_Error(data)
--    ---@type SC_Tuple2
--    local msg = assert(Dll_PB.decode("Tuple2", data))
--    print(ProtoMsgHelp.block(msg))
--
--    local type = msg.num1
--    local errorcode = msg.num2
--    if type == SerE_RaceRoomErrorType.CREATE_ROOM then
--        CommonTipsHelper:ShowCenterTips("创建房间异常，"..ClientDataManager:Get():GetTemplateString(errorcode))
--    end
--    if type == SerE_RaceRoomErrorType.JOIN_ROOM then
--        CommonTipsHelper:ShowCenterTips("加入房间异常，"..ClientDataManager:Get():GetTemplateString(errorcode))
--    end
--    if type == SerE_RaceRoomErrorType.QUICK_JOIN_ROOM then
--        CommonTipsHelper:ShowCenterTips("快速加入房间异常，"..ClientDataManager:Get():GetTemplateString(errorcode))
--    end
--end
----}}}







local __subsystem = RaceRoomSubsystem()
function RaceRoomSubsystem:Get()
    return __subsystem
end
return __subsystem
