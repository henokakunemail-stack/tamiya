---@class ChallengeMatchSubsystem
ChallengeMatchSubsystem = class("ChallengeMatchSubsystem")

function ChallengeMatchSubsystem:initialize(...)
    --453 返回创建挑战赛
    NetResponseEventManager:Get():AddListener(MsgID.GET_CREATE_BATTLE_S2C_REQ, self, self.RecCreateBattle)

    --455 返回挑战赛列表
    NetResponseEventManager:Get():AddListener(MsgID.GET_BATTLE_LIST_S2C_REQ, self, self.RecBattleList)

    --457 返回搜索挑战赛
    NetResponseEventManager:Get():AddListener(MsgID.GET_SEARCH_BATTLE_S2C_REQ, self, self.RecSearchBattle)

    --459 返回参加挑战赛
    NetResponseEventManager:Get():AddListener(MsgID.GET_JOIN_BATTLE_S2C_REQ, self, self.RecJoinBattle)

    --461 返回开始挑战赛
    NetResponseEventManager:Get():AddListener(MsgID.GET_BEGIN_BATTLE_S2C_REQ, self, self.RecBeginBattle)

    --463 返回结算挑战赛
    NetResponseEventManager:Get():AddListener(MsgID.GET_FINISH_BATTLE_S2C_REQ, self, self.RecFinishBattle)

    --465 返回挑战赛详细信息
    NetResponseEventManager:Get():AddListener(MsgID.GET_BATTLE_DETAIL_S2C_REQ, self, self.RecBattleDetail)

    --467 返回挑战赛排行
    NetResponseEventManager:Get():AddListener(MsgID.GET_BATTLE_RANK_S2C_REQ, self, self.RecBattleRank)

    --467 返回挑战赛点赞
    NetResponseEventManager:Get():AddListener(MsgID.GET_BATTLE_AGREE_S2C_RES, self, self.RecBattleAgree)

    --467 返回回放数据
    NetResponseEventManager:Get():AddListener(MsgID.GET_BATTLE_HISTORY_S2C_REQ, self, self.RecBattleHistory)


end

-- 452, --请求创建挑战赛
function ChallengeMatchSubsystem:SendMsg_CreateBattle(awardID, TrackID, SceneID)
    local msgData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), awardID, TrackID, SceneID })
    NetManager:Get():Send(MsgID.GET_CREATE_BATTLE_C2S_RES, msgData)
end

-- 453, -返回创建挑战赛
function ChallengeMatchSubsystem:RecCreateBattle(data)
    ---@type SC_RetBattle
    local msg = assert(Dll_PB.decode("RetBattle", data))
    print(ProtoMsgHelp.block(msg))

    UIManager:Get():CloseView()

    ChallengeMatchManager:Get():InitBattleRoomData(msg.battles)

    ChallengeMatchManager:Get():InitRecordsData(msg.records)

    for i, v in pairs(msg.consumelist) do
        KnapsackDataManager:Get():UpdatePropByConsume(v)
    end

    ChallengeMatchManager:Get():SetFightNum(msg)
    ChallengeMatchManager:Get():SetMaxFightNum(msg)

    if UIManager:Get():IsViewShow("ChallengeMatchView") == false then
        UIManager:Get():OpenView("ChallengeMatchView", CanvasType.MainCanvas, "ChallengeMatchView")
    end

    UINotify:Get():SendNotification(UINotifyEvent.ChallengeMatch_InitData)
    UINotify:Get():SendNotification(UINotifyEvent.ChallengeMatch_RefreshData)
end

local GetBattleChallengeFun=nil
-- 454, --请求挑战赛列表
function ChallengeMatchSubsystem:SendMsg_BattleList(backfunc)
    GetBattleChallengeFun=backfunc
    local msgData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.GET_BATTLE_LIST_C2S_RES, msgData)
end

-- 455, -返回挑战赛列表
function ChallengeMatchSubsystem:RecBattleList(data)
    ---@type SC_RetBattle
    local msg = assert(Dll_PB.decode("RetBattle", data))
    print(ProtoMsgHelp.block(msg))

    ChallengeMatchManager:Get():InitBattleRoomData(msg.battles)

    ChallengeMatchManager:Get():InitRecordsData(msg.records)

    ChallengeMatchManager:Get():SetFightNum(msg)
    ChallengeMatchManager:Get():SetMaxFightNum(msg)

    if UIManager:Get():IsViewShow("ChallengeMatchView") == false then
        UIManager:Get():OpenView("ChallengeMatchView", CanvasType.MainCanvas, "ChallengeMatchView")
    end

    UINotify:Get():SendNotification(UINotifyEvent.ChallengeMatch_InitData)
    UINotify:Get():SendNotification(UINotifyEvent.ChallengeMatch_RefreshData)
    if GetBattleChallengeFun then
        GetBattleChallengeFun()
        GetBattleChallengeFun=nil
    end
end

-- 456, --请求搜索挑战赛
function ChallengeMatchSubsystem:SendMsg_SearchBattle()
    local msgData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.GET_SEARCH_BATTLE_C2S_RES, msgData)
end

-- 457, --返回搜索挑战赛
function ChallengeMatchSubsystem:RecSearchBattle(data)
    ---@type SC_RetBattle
    local msg = assert(Dll_PB.decode("RetBattle", data))
    print(ProtoMsgHelp.block(msg))

end

-- 458, --请求参加挑战赛
function ChallengeMatchSubsystem:SendMsg_JoinBattle(id, awardid)
    local msgData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), id, awardid })
    NetManager:Get():Send(MsgID.GET_JOIN_BATTLE_C2S_RES, msgData)
end

-- 459, --返回参加挑战赛
function ChallengeMatchSubsystem:RecJoinBattle(data)
    ---@type SC_RetJoinBattle
    local msg = assert(Dll_PB.decode("RetJoinBattle", data))
    print(ProtoMsgHelp.block(msg))
    KnapsackDataManager:Get():UpdatePropByConsumeGroup(msg.consumelist)
    ChallengeMatchManager:Get():AddRecordsData(msg.records[1])
    ChallengeMatchManager:Get():SetBattleRoomPool(msg)

    UINotify:Get():SendNotification(UINotifyEvent.ChallengeMatch_InitData)
    UINotify:Get():SendNotification(UINotifyEvent.RaceSelfLevelViewSetJoinSuccess, msg)
end

-- 460, --请求开始挑战赛
function ChallengeMatchSubsystem:SendMsg_BeginBattle(id, car)
    local msgData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), id, car })
    NetManager:Get():Send(MsgID.GET_BEGIN_BATTLE_C2S_RES, msgData)
end

-- 461, --返回开始挑战赛
function ChallengeMatchSubsystem:RecBeginBattle(data)
    ---@type SC_RetBeginBattle
    local msg = assert(Dll_PB.decode("RetBeginBattle", data))
    print(ProtoMsgHelp.block(msg))
    ChallengeMatchManager:Get():SetRetJoinBattleData(msg)
    BattleDataManager:Get():SetRoomData(msg, RaceModel.RaceSelfLevel)
    local scenename = BattleDataManager:Get():GetSceneName()
    local trackdata = BattleDataManager:Get():GetTrackData()
    SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceSelfLevel)
end

-- 462, --请求结算挑战赛
function ChallengeMatchSubsystem:SendMsg_FinishBattle(battleid, time, rank, error)
    local localTime=0
    if BattleDataManager:Get().BattleTime then
        localTime=BattleDataManager:Get().BattleTime
    end
    local GetFrameCount=BattleDataManager:Get():GetFrameCount()
    local GetEngineControllerFrameCount=BattleDataManager:Get():GetEngineControllerFrameCount()
    local text="GetFrameCount:"..tostring(GetFrameCount).."GetEngineControllerFrameCount:"..tostring(GetEngineControllerFrameCount)
    local msgData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), battleid, time, rank, error ,localTime,text})
    NetManager:Get():Send(MsgID.GET_FINISH_BATTLE_C2S_RES, msgData)
end

-- 463, --返回结算挑战赛
function ChallengeMatchSubsystem:RecFinishBattle(data)
    ---@type SC_RetJoinBattle
    local msg = assert(Dll_PB.decode("RetFinishBattle", data))
    print(ProtoMsgHelp.block(msg))
    BattleDataManager:Get():SetStateBattleResult()
end

-- 464, --请求挑战赛详细信息
function ChallengeMatchSubsystem:SendMsg_BattleDetail(createID)
    local msgData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), createID })
    NetManager:Get():Send(MsgID.GET_BATTLE_DETAIL_C2S_RES, msgData)
end

-- 465, --返回挑战赛详细信息
function ChallengeMatchSubsystem:RecBattleDetail(data)
    ---@type SC_RetBattle
    local msg = assert(Dll_PB.decode("RetBattle", data))
    print(ProtoMsgHelp.block(msg))
    ChallengeMatchManager:Get():SetCurRoom(msg)
    SkipModuleHelper:ToSelectCarView(RaceModel.RaceSelfLevel, msg)
end

-- 466, --请求挑战赛排行榜
function ChallengeMatchSubsystem:SendMsg_BattleRank(id)
    local msgData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), id })
    NetManager:Get():Send(MsgID.GET_BATTLE_RANK_C2S_RES, msgData)
end

-- 467, --返回挑战赛排行榜
function ChallengeMatchSubsystem:RecBattleRank(data)
    ---@type SC_RetJoinBattle
    local msg = assert(Dll_PB.decode("RetBattleRank", data))
    print(ProtoMsgHelp.block(msg))
    UIManager:Get():OpenPopup("ChallengeMathRankingListView", CanvasType.MainCanvas, "ChallengeMathRankingListView")
    msg.ranktype = RankingListType.ChallengeMatch
    local data = RankingListData()
    data:SetData(msg)
    UINotify:Get():SendNotification(UINotifyEvent.ChallengeMathRankingListView_SetData, data)
end

-- 468, --请求挑战赛点赞
function ChallengeMatchSubsystem:SendMsg_BattleAgree(id)
    local msgData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), id })
    NetManager:Get():Send(MsgID.GET_BATTLE_AGREE_C2S_RES, msgData)
end

-- 469, --返回挑战赛点赞
function ChallengeMatchSubsystem:RecBattleAgree(data)
    ---@type SC_RetBattleAgree
    local msg = assert(Dll_PB.decode("RetBattleAgree", data))
    print(ProtoMsgHelp.block(msg))
    ChallengeMatchManager:Get():SetBattleRoomAgree(msg)
    ChallengeMatchManager:Get():SetRecordsAgree(msg)
    UINotify:Get():SendNotification(UINotifyEvent.ChallengeMatch_RefreshData)
end

-- 470, --请求挑战赛回放
function ChallengeMatchSubsystem:SendMsg_BattleHistory(id, time, otherId)
    local msgData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), id, time, otherId })
    NetManager:Get():Send(MsgID.GET_BATTLE_HISTORY_C2S_RES, msgData)
end

--471, --返回挑战赛回放
function ChallengeMatchSubsystem:RecBattleHistory(data)
    ---@type SC_RetBattleRecord
    local msg = assert(Dll_PB.decode("RetBattleRecord", data))
    print(ProtoMsgHelp.block(msg))
    BattleDataManager:Get():SetRoomData(msg, RaceModel.RaceSelfLevel, true)
    local scenename = BattleDataManager:Get():GetSceneName()
    local trackdata = BattleDataManager:Get():GetTrackData()
    SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceSelfLevel)
end

local __subsystem = ChallengeMatchSubsystem()
function ChallengeMatchSubsystem:Get()
    return __subsystem
end
return __subsystem