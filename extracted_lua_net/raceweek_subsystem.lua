

---@class RaceWeekSubsystem
RaceWeekSubsystem = class("RaceWeekSubsystem")

function RaceWeekSubsystem:initialize( ... )

end

function RaceWeekSubsystem:GetUrl(type)
    if type == nil then type = ServerType.Battle_Node end
    local servertype = type
    local serverdata = ClientDataManager:Get():GetServerInfoByIndex(servertype,1)
    local str = string.format("http://%s:%d/battle/battle?",serverdata.ip,serverdata.port)
    return str

end


--{{{ 获取周赛列表
function RaceWeekSubsystem:SendMsg_GetAllList()
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(), OldMsgID.CHAP_GET_ALL_GAME_INFO_C2B_REQ, "", self.RecvMsg_GetAllList, self)
end
function RaceWeekSubsystem:RecvMsg_GetAllList(data)
    ---@type SC_GetAllChampionshipsRes
    local msg = assert(Dll_PB.decode("GetAllChampionshipsRes", data))
    print(ProtoMsgHelp.block(msg))

    if MsgErrorManager:Get():HttpMsgError(msg.result) then
        RaceWeekManager:Get():SetMsgData(msg.infos)
        UINotify:Get():SendNotification(UINotifyEvent.ChampionshipView_SetRaceWeek)
    end
end
--}}}


--{{{ 获取周赛详情
function RaceWeekSubsystem:SendMsg_RaceDetail(id)
    local reqData = {
        id = id,
    }
    local reqBytes = assert(Dll_PB.encode("GetChampionshipsDetailReq", reqData))
    local body = CommonHelper:ConvertByteArrayToString(reqBytes)
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(), OldMsgID.CHAP_GET_GAME_DETAIL_INFO_C2B_REQ, body, self.RecvMsg_RaceDetail, self)
end
function RaceWeekSubsystem:RecvMsg_RaceDetail(data)
    ---@type SC_GetChampionshipsDetailRes
    local msg = assert(Dll_PB.decode("GetChampionshipsDetailRes", data))
    log("---------------------------   ",msg.state)
    print(ProtoMsgHelp.block(msg))
    if MsgErrorManager:Get():HttpMsgError(msg.result) then
        local data = RaceWeekManager:Get():SetRaceDetailInfo(msg)
        UINotify:Get():SendNotification(UINotifyEvent.RaceWeekDetailView_SetData, data)
    end
end
--}}}


--{{{ 加入周赛
function RaceWeekSubsystem:SendMsg_Join(id, caridx)
    local reqData = {
        id = id,
        idx = caridx,
        type = 1,
    }
    local reqBytes = assert(Dll_PB.encode("Champ_JoinRoomReq", reqData))
    local body = CommonHelper:ConvertByteArrayToString(reqBytes)
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(ServerType.Battle), OldMsgID.CHAP_JOIN_GAME_C2B_REQ, body, self.RecvMsg_Join, self)
end
function RaceWeekSubsystem:RecvMsg_Join(data)
    ---@type SC_Champ_JoinRoomRes
    local msg = assert(Dll_PB.decode("Champ_JoinRoomRes", data))
    print(ProtoMsgHelp.block(msg))
    if MsgErrorManager:Get():HttpMsgError(msg.result) then

    end
end
--}}}


--{{{ 换车
function RaceWeekSubsystem:SendMsg_ChangeCar(id, caridx)
    local reqData = {
        id = id,
        idx = caridx,
        type = 2,
    }
    local reqBytes = assert(Dll_PB.encode("Champ_JoinRoomReq", reqData))
    local body = CommonHelper:ConvertByteArrayToString(reqBytes)
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(ServerType.Battle), OldMsgID.CHAP_JOIN_GAME_C2B_REQ, body, self.RecvMsg_ChangeCar, self)
end
function RaceWeekSubsystem:RecvMsg_ChangeCar(data)
    ---@type SC_Champ_JoinRoomRes
    local msg = assert(Dll_PB.decode("Champ_JoinRoomRes", data))
    print(ProtoMsgHelp.block(msg))
    if MsgErrorManager:Get():HttpMsgError(msg.result) then

    end
end
--}}}


--{{{ 试跑
function RaceWeekSubsystem:SendMsg_Run(id, caridx)
    local reqData = {
        id = id,
        carIdx = caridx,
    }
    local reqBytes = assert(Dll_PB.encode("Champ_TryRaceReq", reqData))
    local body = CommonHelper:ConvertByteArrayToString(reqBytes)
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(ServerType.Battle), OldMsgID.CHAP_TRY_RACE_C2B_REQ, body, self.RecvMsg_Run, self)
end
function RaceWeekSubsystem:RecvMsg_Run(data)
    ---@type SC_Champ_TryRaceRes
    local msg = assert(Dll_PB.decode("Champ_TryRaceRes", data))
    print(ProtoMsgHelp.block(msg))
    if MsgErrorManager:Get():HttpMsgError(msg.result) then
        BattleDataManager:Get():SetRoomData(msg.raceInfo, RaceModel.RaceWeek)
        local scenename = BattleDataManager:Get():GetSceneName()
        local trackdata = BattleDataManager:Get():GetTrackData()
        SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceWeek)
    end
end
--}}}


--{{{ 历史记录
function RaceWeekSubsystem:SendMsg_History()
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(), OldMsgID.CHAP_VIEW_RACE_HISTORY_C2B_REQ, "", self.RecvMsg_History, self)
end
function RaceWeekSubsystem:RecvMsg_History(data)
    ---@type SC_Champ_GetGameHistoryRes
    local msg = assert(Dll_PB.decode("Champ_GetGameHistoryRes", data))
    print(ProtoMsgHelp.block(msg))
    if MsgErrorManager:Get():HttpMsgError(msg.result) then
        UINotify:Get():SendNotification(UINotifyEvent.RaceWeekHistoryView_SetData, msg.infos)
    end
end
--}}}


--{{{ 回放
function RaceWeekSubsystem:SendMsg_Replay(recordid)
    local reqData = {
        num = recordid,
    }
    local reqBytes = assert(Dll_PB.encode("Tuple1_64", reqData))
    local body = CommonHelper:ConvertByteArrayToString(reqBytes)
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(), OldMsgID.GET_RECORD_C2B_REQ, body, self.RecvMsg_Replay, self)
end
function RaceWeekSubsystem:RecvMsg_Replay(data)
    ---@type SC_GetRecords2Res
    local msg = assert(Dll_PB.decode("GetRecords2Res", data))
    print(ProtoMsgHelp.block(msg))

    if MsgErrorManager:Get():HttpMsgError(msg.result) then
        local msgdata = msg.records[1]
        local temp = RaceHistoryData()
        temp:SetData(msgdata, msg.type)

        BattleDataManager:Get():SetRoomData(temp, RaceModel.RaceWeek, true)
        BattleDataManager:Get():SetBattleResultData(temp)
        local scenename = BattleDataManager:Get():GetSceneName()
        local trackdata = BattleDataManager:Get():GetTrackData()
        SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceWeek)
    end

end
--}}}


local __subsystem = RaceWeekSubsystem()
function RaceWeekSubsystem:Get() return __subsystem end
return __subsystem