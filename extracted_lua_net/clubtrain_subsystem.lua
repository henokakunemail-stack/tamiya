---@class ClubTrainSubsystem
ClubTrainSubsystem = class("ClubTrainSubsystem")

function ClubTrainSubsystem:initialize(...)
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_UPDATE_SELF_TRACK_DATA_S2C_RES, self, self.RecvMsg_UpdateSelfTrackData)--上传自建赛道数据
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_SET_SELF_TRACK_RACE_S2C_RES, self, self.RecvMsg_SetTrackRace) --设置比赛用道
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_JOIN_SELF_TRACK_RACE_S2C_RES, self, self.RecvMsg_StartTrainRace) --开始练习赛
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_UPDATE_SELF_TRACK_RESULT_S2C_RES, self, self.RecvMsg_UpdateRaceResult) --上传比赛结果
end

----获取比赛基本信息(包括赛道和排行榜)
function ClubTrainSubsystem:SendMsg_GetSelfTrackRaceInfo()
    NetManager:Get():SendGuild(OldMsgID.GUILD_GET_SELF_TRACK_RACE_INFO_C2S_REQ, "")
end

function ClubTrainSubsystem:RecvMsg_GetSelfTrackRaceInfo(data)
    ---@type SC_GetSelfTrackRaceInfoRes
    local msg = assert(Dll_PB.decode("GetSelfTrackRaceInfoRes", data))
    print(ProtoMsgHelp.block(msg))
    if msg.result == ClubOperateResult.Success then
        ClubTrainDataManager:Get():SetCurSelectTrackIdx(msg.raceIdx + 1)
        ClubTrainDataManager:Get():InitTrackListInfo(msg)
        UIManager:Get():OpenView("ClubTrainView", CanvasType.MainCanvas, "ClubTrainView")
        UINotify:Get():SendNotification(UINotifyEvent.ClubTrainView_InitTrainViewInfo)
        UINotify:Get():SendNotification(UINotifyEvent.ClubTrainView_UpdateRank, msg.ranks)
    end
end

----获取赛道列表
function ClubTrainSubsystem:SendMsg_GetTrackListInfo()
    local reqData = {
        num = PlayerDataManager:Get():GetGuildId()
    }
    local reqBytes = assert(Dll_PB.encode("Tuple1", reqData))
    NetManager:Get():SendGuild(OldMsgID.GUILD_GET_SELF_TRACK_INFO_C2S_REQ, reqBytes)
end

function ClubTrainSubsystem:RecvMsg_GetTrackListInfo(data)
    ---@type SC_GetGuildAllSelfTrackRes
    local msg = assert(Dll_PB.decode("GetGuildAllSelfTrackRes", data))
    print(ProtoMsgHelp.block(msg))
    if msg.result == 0 then
        ClubTrainDataManager:Get():InitTrackListInfo(msg)
        UIManager:Get():OpenPopup("ClubTrainSettingView", CanvasType.MainCanvas, "ClubTrainSettingView")
    end
end

----上传自建赛道数据
---@param data SC_TrackWrapInfo
function ClubTrainSubsystem:SendMsg_UpdateSelfTrackData(data)
    local reqBytes = assert(Dll_PB.encode("TrackWrapInfo", data))
    NetManager:Get():SendGuild(OldMsgID.GUILD_UPDATE_SELF_TRACK_DATA_C2S_REQ, reqBytes)
end

function ClubTrainSubsystem:RecvMsg_UpdateSelfTrackData(data)
    local msg = assert(Dll_PB.decode("Tuple1", data))
    print(ProtoMsgHelp.block(msg))
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackUpdateSuccess))
    if msg.num == 1 then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackDeleteSuccess))
    end
    if msg.num == 2 then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackSaveSuccess))
    end
end

----设置比赛用道
function ClubTrainSubsystem:SendMsg_SetTrackRace()
    local curSelectTrackIdx = ClubTrainDataManager:Get():GetCurSelectTrackIdx()
    local reqData = {
        num = curSelectTrackIdx - 1
    }
    local reqBytes = assert(Dll_PB.encode("Tuple1", reqData))

    NetManager:Get():SendGuild(OldMsgID.GUILD_SET_SELF_TRACK_RACE_C2S_REQ, convertStr,reqBytes)
end

function ClubTrainSubsystem:RecvMsg_SetTrackRace(data)
    ---@type SC_SetSelfTrackRaceRes
    local msg = assert(Dll_PB.decode("SetSelfTrackRaceRes", data))
    print(ProtoMsgHelp.block(msg))
    if msg.result == ClubOperateResult.Success then
        ClubTrainDataManager:Get():SetCurSelectTrackIdx(msg.idx + 1)
        self:SendMsg_GetSelfTrackRaceInfo()
    end
end

----开始练习赛
function ClubTrainSubsystem:SendMsg_StartTrainRace(carIdx)
    local reqData = {
        num = carIdx--车的位置索引
    }
    local reqBytes = assert(Dll_PB.encode("RaceResult", reqData))

    NetManager:Get():SendGuild(OldMsgID.GUILD_JOIN_SELF_TRACK_RACE_C2S_REQ,reqBytes)
end

function ClubTrainSubsystem:RecvMsg_StartTrainRace(data)
    ---@type SC_BeginSelfTrackRaceRes
    local msg = assert(Dll_PB.decode("BeginSelfTrackRaceRes", data))
    print(ProtoMsgHelp.block(msg))

    if msg.result == ClubOperateResult.Success then
        msg.raceInfo.sceneId = 29000002
        BattleDataManager:Get():SetRoomData(msg.raceInfo, RaceModel.ClubTrain)

        local scenename = BattleDataManager:Get():GetSceneName()
        local trackdata = BattleDataManager:Get():GetTrackData()
        SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.ClubTrain)
    end
end

----上传比赛结果
function ClubTrainSubsystem:SendMsg_UpdateRaceResult()
    local battleResult = BattleDataManager:Get():GetBattleResultData()
    local reqData = {
        rank = battleResult.ClubTrainMsgData.completeRank, --失败以后负数
        time = battleResult.ClubTrainMsgData.time, --如果失败time位负表示跑动距离
        error = battleResult.ClubTrainMsgData.error,
    }
    local reqBytes = assert(Dll_PB.encode("RaceResult", reqData))

    NetManager:Get():SendGuild(OldMsgID.GUILD_UPDATE_SELF_TRACK_RESULT_C2S_REQ, reqBytes)


end

function ClubTrainSubsystem:RecvMsg_UpdateRaceResult(data)
    ---@type SC_Tuple1
    local msg = assert(Dll_PB.decode("Tuple1", data))
    print(ProtoMsgHelp.block(msg))
    if msg.num == ClubOperateResult.Success then
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ClubTrainUpdateResult))
    end
end

local __subsystem = ClubTrainSubsystem()
function ClubTrainSubsystem:Get()
    return __subsystem
end
return __subsystem