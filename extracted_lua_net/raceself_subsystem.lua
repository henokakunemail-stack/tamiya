

---@class RaceSelfSubsystem
RaceSelfSubsystem = class("RaceSelfSubsystem")

function RaceSelfSubsystem:initialize( ... )

end

function RaceSelfSubsystem:GetUrl(type)
    if type == nil then type = ServerType.Battle_Node end
    local servertype = type
    local serverdata = ClientDataManager:Get():GetServerInfoByIndex(servertype,1)
    local str = string.format("http://%s:%d/battle/battle?",serverdata.ip,serverdata.port)
    return str

end

-------------------------------------------------------------获取推荐列表
function RaceSelfSubsystem:SendMsg_GetAllList()
   -- NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(), MsgID.SC_GET_ALL_GAME_INFO_C2B_REQ, "", self.RecvMsg_GetAllList, self)
end
function RaceSelfSubsystem:RecvMsg_GetAllList(data)
    ---@type SC_SC_GetAllGameRes
    local msg = assert(Dll_PB.decode("SC_GetAllGameRes", data))
    print(ProtoMsgHelp.block(msg))

    RaceSelfManager:Get():SetJoinMiniData(msg.joinGameInfo)
    RaceSelfManager:Get():SetCreateData(msg.createGameInfo)
    UINotify:Get():SendNotification(UINotifyEvent.RaceSelfView_SetData, msg.gameInfos)
end
-------------------------------------------------------------获取推荐列表




-------------------------------------------------------------创建赛事
function RaceSelfSubsystem:SendMsg_CreateRace(param)
    local reqData = {
        gameInfo = param,
    }
    local reqBytes = assert(Dll_PB.encode("SC_CreateGameReq", reqData))
    local body = CommonHelper:ConvertByteArrayToString(reqBytes)
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(ServerType.Battle), OldMsgID.SC_CREATE_GAME_C2B_REQ, body, self.RecvMsg_CreateRace, self)

end
function RaceSelfSubsystem:RecvMsg_CreateRace(data)
    ---@type SC_SC_CreateGameRes
    local msg = assert(Dll_PB.decode("SC_CreateGameRes", data))
    print(ProtoMsgHelp.block(msg))

    if MsgErrorManager:Get():HttpMsgError(msg.result) then
        RaceSelfManager:Get():SetCreateBaseData(msg.gameInfo)
        local racedata = RaceSelfData()
        racedata:SetData(msg.gameInfo)
        UIManager:Get():OpenView("RaceSelfJoinView",CanvasType.MainCanvas,"RaceSelfJoinView", false, true)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfJoinView_SetData, racedata)
    end

end
-------------------------------------------------------------创建赛事



-------------------------------------------------------------查看赛事完整数据
function RaceSelfSubsystem:SendMsg_GetRaceDetailInfo(param)
    local reqData = {
        id = param,
    }
    local reqBytes = assert(Dll_PB.encode("SC_GetGameDetailInfoReq", reqData))
    local body = CommonHelper:ConvertByteArrayToString(reqBytes)
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(), OldMsgID.SC_GET_GAME_DETAIL_INFO_C2B_REQ, body, self.RecvMsg_GetRaceDetailInfo, self)

end
function RaceSelfSubsystem:RecvMsg_GetRaceDetailInfo(data)
    ---@type SC_SC_GetGameDetailInfoRes
    local msg = assert(Dll_PB.decode("SC_GetGameDetailInfoRes", data))
    print(ProtoMsgHelp.block(msg))

    if MsgErrorManager:Get():HttpMsgError(msg.result) then
        --RaceSelfManager:Get():TryOpenRaceInfo(msg.gameInfo.miniInfo.id, 1)
    end

end
-------------------------------------------------------------查看赛事完整数据



-------------------------------------------------------------加入赛事
function RaceSelfSubsystem:SendMsg_JoinRace(id, caridx)
    local reqData = {
        id = id,
        idx = caridx,
        type = 1,
    }
    local reqBytes = assert(Dll_PB.encode("SC_JoinRoomReq", reqData))
    local body = CommonHelper:ConvertByteArrayToString(reqBytes)
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(ServerType.Battle), OldMsgID.SC_JOIN_GAME_C2B_REQ, body, self.RecvMsg_JoinRace, self)

end
function RaceSelfSubsystem:RecvMsg_JoinRace(data)
    ---@type SC_SC_JoinRoomRes
    local msg = assert(Dll_PB.decode("SC_JoinRoomRes", data))
    print(ProtoMsgHelp.block(msg))

    if MsgErrorManager:Get():HttpMsgError(msg.result) then
        RaceSelfManager:Get():SetJoinBaseData(msg.gameInfo)
        RaceSelfManager:Get():TryOpenRaceInfo(msg.gameInfo.miniInfo.id, RaceSelfUIFlag.Joiner)
    end
end
-------------------------------------------------------------加入赛事



-------------------------------------------------------------查看赛事某个阶段数据
function RaceSelfSubsystem:SendMsg_GetRaceStateInfo(param, flag)
    local reqData = {
        id = param,
        flag = flag,
    }
    local reqBytes = assert(Dll_PB.encode("SC_GetGameStageInfoReq", reqData))
    local body = CommonHelper:ConvertByteArrayToString(reqBytes)
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(), OldMsgID.SC_GET_GAME_STAGE_INFO_C2B_REQ, body, self.RecvMsg_GetRaceStateInfo, self)

end
function RaceSelfSubsystem:RecvMsg_GetRaceStateInfo(data)
    ---@type SC_SC_GetGameStageInfoRes
    local msg = assert(Dll_PB.decode("SC_GetGameStageInfoRes", data))
    print(ProtoMsgHelp.block(msg))

    if MsgErrorManager:Get():HttpMsgError(msg.result) then
        RaceSelfManager:Get():OpenRaceStateUI(msg)
    end
end
-------------------------------------------------------------查看赛事某个阶段数据



-------------------------------------------------------------换车（跟加入赛事用一个协议）
function RaceSelfSubsystem:SendMsg_ChangeCar(id, caridx)

    local reqData = {
        id = id,
        idx = caridx,
        type = 2,
    }
    local reqBytes = assert(Dll_PB.encode("SC_JoinRoomReq", reqData))
    local body = CommonHelper:ConvertByteArrayToString(reqBytes)
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(ServerType.Battle), OldMsgID.SC_JOIN_GAME_C2B_REQ, body, self.RecvMsg_ChangeCar, self)

end
function RaceSelfSubsystem:RecvMsg_ChangeCar(data)
    ---@type SC_SC_JoinRoomRes
    local msg = assert(Dll_PB.decode("SC_JoinRoomRes", data))
    print(ProtoMsgHelp.block(msg))

    if MsgErrorManager:Get():HttpMsgError(msg.result) then

    end
end
-------------------------------------------------------------换车（跟加入赛事用一个协议）



-------------------------------------------------------------试跑
function RaceSelfSubsystem:SendMsg_TryRun(caridx)
    print("-----   ",caridx)
    local reqData = {
        num = caridx,
    }
    local reqBytes = assert(Dll_PB.encode("Tuple1", reqData))
    local body = CommonHelper:ConvertByteArrayToString(reqBytes)
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(ServerType.Battle), OldMsgID.SC_TRY_RACE_REQ, body, self.RecvMsg_TryRun, self)
end
function RaceSelfSubsystem:RecvMsg_TryRun(data)
    ---@type SC_SC_TryRaceRes
    local msg = assert(Dll_PB.decode("SC_TryRaceRes", data))
    print(ProtoMsgHelp.block(msg))

    if MsgErrorManager:Get():HttpMsgError(msg.result) then
        BattleDataManager:Get():SetRoomData(msg.raceInfo, RaceModel.RaceSelf)
        BattleDataManager:Get():SetBattleResultData(msg.resultInfo)
        --SceneManager:Get():UnloadScene(MainCityRes)
        --local scenename = BattleDataManager:Get():GetSceneName()
        --local trackid = msg.raceInfo.trackId
        --local customtrackdata = BattleDataManager:Get():GetCustomTrackData()
        --SceneManager:Get():LoadingRaceSelfScene(scenename, trackid, customtrackdata)

        local scenename = BattleDataManager:Get():GetSceneName()
        local trackdata = BattleDataManager:Get():GetTrackData()
        SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceSelf)
    end


end
-------------------------------------------------------------试跑



-------------------------------------------------------------历史记录
function RaceSelfSubsystem:SendMsg_History()
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(), OldMsgID.SC_VIEW_RACE_HISTORY_C2B_REQ, "", self.RecvMsg_History, self)

end
function RaceSelfSubsystem:RecvMsg_History(data)
    ---@type SC_SC_GetGameHistoryRes
    local msg = assert(Dll_PB.decode("SC_GetGameHistoryRes", data))
    print(ProtoMsgHelp.block(msg))

    if MsgErrorManager:Get():HttpMsgError(msg.result) then
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfHistoryView_SetData, msg)
    end


end
-------------------------------------------------------------历史记录



-------------------------------------------------------------回放
function RaceSelfSubsystem:SendMsg_Replay(recordid)
    local reqData = {
        num = recordid,
    }
    local reqBytes = assert(Dll_PB.encode("Tuple1_64", reqData))
    local body = CommonHelper:ConvertByteArrayToString(reqBytes)
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(), OldMsgID.GET_RECORD_C2B_REQ, body, self.RecvMsg_Replay, self)
end
function RaceSelfSubsystem:RecvMsg_Replay(data)
    ---@type SC_GetRecords2Res
    local msg = assert(Dll_PB.decode("GetRecords2Res", data))
    print(ProtoMsgHelp.block(msg))

    if MsgErrorManager:Get():HttpMsgError(msg.result) then
        local msgdata = msg.records[1]
        local temp = RaceHistoryData()
        temp:SetData(msgdata, msg.type)
        BattleDataManager:Get():SetRoomData(temp, RaceModel.RaceSelf, true)
        BattleDataManager:Get():SetBattleResultData(temp)
        local scenename = BattleDataManager:Get():GetSceneName()
        local trackdata = BattleDataManager:Get():GetTrackData()
        SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceSelf)
    end

end
-------------------------------------------------------------回放




local __subsystem = RaceSelfSubsystem()
function RaceSelfSubsystem:Get() return __subsystem end
return __subsystem