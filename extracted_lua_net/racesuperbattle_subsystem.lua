---@class RaceSuperBattleSubsystem
RaceSuperBattleSubsystem = class("RaceSuperBattleSubsystem")

function RaceSuperBattleSubsystem:initialize(...)
    NetResponseEventManager:Get():AddListener(MsgID.GET_SUPER_BATTLE_INFO_S2C_RES, self, self.RecMsg_EnterRaceSuperBattle)
    NetResponseEventManager:Get():AddListener(MsgID.SUPER_BATTLE_JOIN_S2C_RES, self, self.RecMsg_JoinRaceSuperBattle)
    NetResponseEventManager:Get():AddListener(MsgID.SUPER_BATTLE_SELECT_CAR_S2C_RES, self, self.RecMsg_SelectCar)
    NetResponseEventManager:Get():AddListener(MsgID.SUPER_BATTLE_CONFIRM_CAR_S2C_RES, self, self.RecMsg_ConfirmCar)
    NetResponseEventManager:Get():AddListener(MsgID.SUPER_BATTLE_RANK_LIST_S2C_RES, self, self.RecMsg_RaceSuperBattleRank)
    NetResponseEventManager:Get():AddListener(MsgID.SUPER_BATTLE_PLAYER_OFF_RANK_LIST_S2C_RES, self, self.RecMsg_RaceSuperBattlePlayerOffRank)
    NetResponseEventManager:Get():AddListener(MsgID.SUPER_BATTLE_64_RANK_LIST_S2C_RES, self, self.RecMsg_RaceSuperBattle64Rank)
    NetResponseEventManager:Get():AddListener(MsgID.SUPER_BATTLE_GUESS_S2C_RES, self, self.RecMsg_Guess)
    NetResponseEventManager:Get():AddListener(MsgID.SUPER_BATTLE_BAN_TRACK_S2C_RES, self, self.RecMsg_BanTrack)
    NetResponseEventManager:Get():AddListener(MsgID.SUPER_BATTLE_RACE_RESULT_S2C_RES, self, self.RecMsg_RaceResult)
    NetResponseEventManager:Get():AddListener(MsgID.SUPER_BATTLE_RACE_RECORD_S2C_RES, self, self.RecMsg_RaceRecord)
    NetResponseEventManager:Get():AddListener(MsgID.SUPER_BATTLE_AWARD_S2C_RES, self, self.RecMsg_RaceAward)
end
--{{{ 请求进入大乱斗
local  _IsRefreshData=false
local EnterSuperBattleCallBack=nil
function RaceSuperBattleSubsystem:SendMsg_EnterRaceSuperBattle(isRefreshData,backfunc)
    if isRefreshData then _IsRefreshData=true else _IsRefreshData=false end
    EnterSuperBattleCallBack=backfunc
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.GET_SUPER_BATTLE_INFO_C2S_REQ, data)
end

function RaceSuperBattleSubsystem:RecMsg_EnterRaceSuperBattle(data)
    ---@type SC_RetKillerInfo
    local msg = assert(Dll_PB.decode("RetKillerInfo", data))
    print(ProtoMsgHelp.block(msg))
    RaceSuperBattleManager:Get():Init(msg)
    if _IsRefreshData then
        RaceSuperBattleSubsystem:SendMsg_RaceSuperBattle64Rank(RaceSuperBattleManager:Get():GetLookGroup())
    else
        if not UIManager:Get():IsViewShow("RaceSuperBattleView") then
            UIManager:Get():OpenView("RaceSuperBattleView",CanvasType.MainCanvas,"RaceSuperBattleView")
        end
        UINotify:Get():SendNotification(UINotifyEvent.RaceSuperBattle_SetData)
    end
    if EnterSuperBattleCallBack then
        EnterSuperBattleCallBack()
        EnterSuperBattleCallBack=nil
    end
end
--}}}
--{{{ 请求报名大乱斗
function RaceSuperBattleSubsystem:SendMsg_JoinRaceSuperBattle(carIdx)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),carIdx })
    NetManager:Get():Send(MsgID.SUPER_BATTLE_JOIN_C2S_REQ, data)
end

function RaceSuperBattleSubsystem:RecMsg_JoinRaceSuperBattle(data)
    ---@type SC_RetTopInfo
    local msg = assert(Dll_PB.decode("RetTopInfo", data))
    print(ProtoMsgHelp.block(msg))
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperEnterSuccess))
    UIManager:Get():CloseView()
end
--}}}
--{{{ 请求选车
function RaceSuperBattleSubsystem:SendMsg_SelectCar(carIdx)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),carIdx,RaceSuperBattleManager:Get():GetData():GetState() })
    NetManager:Get():Send(MsgID.SUPER_BATTLE_SELECT_CAR_C2S_REQ, data)
end

function RaceSuperBattleSubsystem:RecMsg_SelectCar(data)
    ---@type SC_RetTopInfo
    local msg = assert(Dll_PB.decode("RetTopInfo", data))
    print(ProtoMsgHelp.block(msg))
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperSelectCarSuccess))
end
--}}}
--{{{ 请求确认选车
function RaceSuperBattleSubsystem:SendMsg_ConfirmCar(carIdx)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() ,carIdx,RaceSuperBattleManager:Get():GetData():GetState()})
    NetManager:Get():Send(MsgID.SUPER_BATTLE_CONFIRM_CAR_C2S_REQ, data)
end

function RaceSuperBattleSubsystem:RecMsg_ConfirmCar(data)
    ---@type SC_RetTopInfo
    local msg = assert(Dll_PB.decode("RetTopInfo", data))
    print(ProtoMsgHelp.block(msg))
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperConfirmCarSuccess))
end
--}}}
--{{{ 请求排行榜
function RaceSuperBattleSubsystem:SendMsg_RaceSuperBattleRank()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.SUPER_BATTLE_RANK_LIST_C2S_REQ, data)
end

function RaceSuperBattleSubsystem:RecMsg_RaceSuperBattleRank(data)
    ---@type SC_RetRank
    local msg = assert(Dll_PB.decode("RetRank", data))
    print(ProtoMsgHelp.block(msg))
    msg.ranktype=RankingListType.RaceSuperBattlePoint
    RankingListDataManager:Get():Init(msg)
    if not UIManager:Get():IsPopViewShow("RaceSuperBattleRankView") then
       UIManager:Get():OpenPopup("RaceSuperBattleRankView", CanvasType.MainCanvas, "RaceSuperBattleRankView")
    end
    UINotify:Get():SendNotification(UINotifyEvent.RaceSuperBattleRankList_SetData)
end
--}}}
--{{{ 请求附加赛
function RaceSuperBattleSubsystem:SendMsg_RaceSuperBattlePlayerOffRank()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.SUPER_BATTLE_PLAYER_OFF_RANK_LIST_C2S_REQ, data)
end

function RaceSuperBattleSubsystem:RecMsg_RaceSuperBattlePlayerOffRank(data)
    ---@type SC_RetRank
    local msg = assert(Dll_PB.decode("RetRank", data))
    print(ProtoMsgHelp.block(msg))
    msg.ranktype=RankingListType.RaceSuperBattlePlayerOffPoint
    RankingListDataManager:Get():Init(msg)
    if not UIManager:Get():IsPopViewShow("RaceSuperBattleRankView") then
       UIManager:Get():OpenPopup("RaceSuperBattleRankView", CanvasType.MainCanvas, "RaceSuperBattleRankView")
    end
    UINotify:Get():SendNotification(UINotifyEvent.RaceSuperBattleRankList_SetData)
end
--}}}
--{{{ 请求64强
function RaceSuperBattleSubsystem:SendMsg_RaceSuperBattle64Rank(group)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),group })
    NetManager:Get():Send(MsgID.SUPER_BATTLE_64_RANK_LIST_C2S_REQ, data)
end

function RaceSuperBattleSubsystem:RecMsg_RaceSuperBattle64Rank(data)
    ---@type SC_MatchInfos
    local msg = assert(Dll_PB.decode("MatchInfos", data))
    print(ProtoMsgHelp.block(msg))
    RaceSuperBattleManager:Get():SetLookGroup(tonumber(msg.rankgroup))
    RaceSuperBattleManager:Get():SetMyGroup(msg.mygroup)
    RaceSuperBattleManager:Get():SetMyGuess(msg.stagestrs,msg.rids)
    RaceSuperBattleManager:Get():SetShowRecordData(msg)


    if not UIManager:Get():IsViewShow("RaceSuperBattleListView") then
        UIManager:Get():OpenView("RaceSuperBattleListView", CanvasType.MainCanvas, "RaceSuperBattleListView")
    end
    UINotify:Get():SendNotification(UINotifyEvent.RaceSuperBattleList_SetData)
end
--}}}
--{{{ 请求竞猜
function RaceSuperBattleSubsystem:SendMsg_Guess(state,id)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),state,id })
    NetManager:Get():Send(MsgID.SUPER_BATTLE_GUESS_C2S_REQ, data)
end

function RaceSuperBattleSubsystem:RecMsg_Guess(data)
    ---@type SC_KillerGuess
    local msg = assert(Dll_PB.decode("KillerGuess", data))
    print(ProtoMsgHelp.block(msg))
    KnapsackDataManager:Get():UpdatePropByConsumeGroup(msg.consumelist)
    RaceSuperBattleManager:Get():SetGuessByStates(RaceSuperBattleManager:Get():GetData():GetMatchRankState(),tonumber(msg.guessrid))
    UINotify:Get():SendNotification(UINotifyEvent.RaceSuperBattleList_Refresh)
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperGuessSuccess))
end
--}}}
--{{{ 请求搬图
function RaceSuperBattleSubsystem:SendMsg_BanTrack(trackidx)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),trackidx })
    NetManager:Get():Send(MsgID.SUPER_BATTLE_BAN_TRACK_C2S_REQ, data)
end

function RaceSuperBattleSubsystem:RecMsg_BanTrack(data)
    ---@type SC_RetTopInfo
    local msg = assert(Dll_PB.decode("RetTopInfo", data))
    print(ProtoMsgHelp.block(msg))
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBanTrackSuccess))
    UIManager:Get():CloseView()
end
--}}}
--{{{ 请求赛事结果
function RaceSuperBattleSubsystem:SendMsg_RaceResult(id,stage)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),stage,id})
    NetManager:Get():Send(MsgID.SUPER_BATTLE_RACE_RESULT_C2S_REQ, data)
end

function RaceSuperBattleSubsystem:RecMsg_RaceResult(data)
    ---@type SC_MatchInfos
    local msg = assert(Dll_PB.decode("MatchInfos", data))
    print(ProtoMsgHelp.block(msg))
    RaceSuperBattleManager:Get():SetShowRecordData(msg)
    RaceSuperBattleManager:Get():SetLookRecordType(tonumber(msg.ranktype))
    if not UIManager:Get():IsPersistentViewShow("RaceSuperBattleRecordView") then
        UIManager:Get():ShowPersistentView("RaceSuperBattleRecordView",CanvasType.FrontCanvas,"RaceSuperBattleRecordView")
    end
    UINotify:Get():SendNotification(UINotifyEvent.RaceSuperBattleRecord_SetData)
end
--}}}
--{{{ 请求赛事回放
function RaceSuperBattleSubsystem:SendMsg_RaceRecord(matchstr,matchid,index)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),matchstr,matchid,index })
    NetManager:Get():Send(MsgID.SUPER_BATTLE_RACE_RECORD_C2S_REQ, data)
end

function RaceSuperBattleSubsystem:RecMsg_RaceRecord(data)
    ---@type SC_MatchInfos
    local msg = assert(Dll_PB.decode("MatchInfos", data))
    print(ProtoMsgHelp.block(msg))
    UIManager:Get():ClosePopup()
    RaceSuperBattleManager:Get():BeginBattle(msg)
end
--}}}
--{{{ 请求赛事回放
function RaceSuperBattleSubsystem:SendMsg_RaceAward(num)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),num })
    NetManager:Get():Send(MsgID.SUPER_BATTLE_AWARD_C2S_REQ, data)
end

function RaceSuperBattleSubsystem:RecMsg_RaceAward(data)
    ---@type SC_KillerAward
    local msg = assert(Dll_PB.decode("KillerAward", data))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlists[1],true)
    local awards=stringSplitToNumber(msg.awards,":")
    TaskDataManager:Get():UpdateTaskByIds(awards)
    UINotify:Get():SendNotification(UINotifyEvent.RefreshCurView)
    self:UpdateRedPoint()
end
--}}}
function RaceSuperBattleSubsystem:UpdateRedPoint()
    RedPointManager:Get():UpdateValue(RedPointID.S_RaceSuperBattle,TaskDataManager:Get():GetTaskIsDone(TaskType.SuperBattle))
end

local __subsystem = RaceSuperBattleSubsystem()
function RaceSuperBattleSubsystem:Get()
    return __subsystem
end
return __subsystem