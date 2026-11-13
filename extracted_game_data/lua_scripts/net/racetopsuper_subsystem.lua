---@class RaceTopSuperSubsystem
RaceTopSuperSubsystem = class("RaceTopSuperSubsystem")

function RaceTopSuperSubsystem:initialize( ... )
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP2_INFO_S2C_RET, self, self.RecvMsg_EnterRaceTop)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP2_AUDITION_BEGIN_BATTLE_S2C_RES, self, self.RecvMsg_BeginBattleRaceTopAudition)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP2_AUDITION_FINISH_BATTLE_S2C_RES, self, self.RecvMsg_FinishBattleRaceTopAudition)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP2_TOP_BEGIN_BATTLE_S2C_RES, self, self.RecvMsg_BeginBattleRaceTopTop)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP2_TOP_FINISH_BATTLE_S2C_RES, self, self.RecvMsg_FinishBattleRaceTopTop)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP2_B_BEGIN_BATTLE_S2C_RES, self, self.RecvMsg_BeginBattleRaceTopB)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP2_B_FINISH_BATTLE_S2C_RES, self, self.RecvMsg_FinishBattleRaceTopB)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP2_AUDITION_RANK_LIST_S2C_RES, self, self.RecvMsg_GetRankListAudition)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP2_TOP_RANK_LIST_S2C_RES, self, self.RecvMsg_GetRankListTop)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP2_B_RANK_LIST_S2C_RES, self, self.RecvMsg_GetRankListB)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP2_RECORD_S2C_RES, self, self.RecvMsg_BeginBattleRaceTopRecord)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP2_RE_FIGHT_S2C_RES, self, self.RecvMsg_BeginBattleRaceTopReFight)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP2_GOOD_S2C_RES, self, self.RecvMsg_RaceTopGoodRes)
end
local EnterCallBack=nil
--{{{ 请求进入巅峰赛
function RaceTopSuperSubsystem:SendMsg_EnterRaceTop(func)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    EnterCallBack=func
    NetManager:Get():Send(MsgID.RACE_TOP2_INFO_C2S_REQ, data)
end

function RaceTopSuperSubsystem:RecvMsg_EnterRaceTop(data)
    ---@type SC_RetTopInfo
    local msg = assert(Dll_PB.decode("RetTopInfo", data))
    print(ProtoMsgHelp.block(msg))
    RaceTopSuperManager:Get():Init(msg)
    if not UIManager:Get():IsViewShow("RaceTopSuperView") then
        if EnterCallBack then
            EnterCallBack()
            EnterCallBack=nil
        end
        UIManager:Get():OpenView("RaceTopSuperView",CanvasType.MainCanvas,"RaceTopSuperView")
    end
    UINotify:Get():SendNotification(UINotifyEvent.RaceTopSuper_SetData)
end
--}}}
--{{{ 请求战斗巅峰赛海选
function RaceTopSuperSubsystem:SendMsg_BeginBattleRaceTopAudition(carid)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),carid})
    NetManager:Get():Send(MsgID.RACE_TOP2_AUDITION_BEGIN_BATTLE_C2S_REQ, data)
end

function RaceTopSuperSubsystem:RecvMsg_BeginBattleRaceTopAudition(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("RetTopStart", data))
    print(ProtoMsgHelp.block(msg))
    RaceTopSuperManager:Get():SetRaceType(RaceTopRaceType.Audition)
    RaceTopSuperManager:Get():BeginBattle(msg)

end
--}}}
--{{{ 完成战斗巅峰赛海选
function RaceTopSuperSubsystem:SendMsg_FinishBattleRaceTopAudition(time, error, rank, startTime, recordValue)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), time, error, rank, RaceTopSuperManager:Get():GetStates(), recordValue, startTime})
    NetManager:Get():Send(MsgID.RACE_TOP2_AUDITION_FINISH_BATTLE_C2S_REQ, data)
end

function RaceTopSuperSubsystem:RecvMsg_FinishBattleRaceTopAudition(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("TopFinish", data))
    print(ProtoMsgHelp.block(msg))
    RaceTopSuperManager:Get():BattleResult()
end
--}}}
--{{{ 请求战斗巅峰赛巅峰
function RaceTopSuperSubsystem:SendMsg_BeginBattleRaceTopTop(carid)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), carid, RaceTopSuperManager:Get():GetStates() })
    NetManager:Get():Send(MsgID.RACE_TOP2_TOP_BEGIN_BATTLE_C2S_REQ, data)
end

function RaceTopSuperSubsystem:RecvMsg_BeginBattleRaceTopTop(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("RetTopStart", data))
    print(ProtoMsgHelp.block(msg))
    RaceTopSuperManager:Get():SetRaceType(RaceTopRaceType.RaceTop)
    RaceTopSuperManager:Get():BeginBattle(msg)

end
--}}}
function RaceTopSuperSubsystem:SendMsg_ReFight()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.RACE_TOP2_RE_FIGHT_C2S_REQ, data)
end
function RaceTopSuperSubsystem:RecvMsg_BeginBattleRaceTopReFight(data)
    ---@type SC_RetTopStart
    local msg = assert(Dll_PB.decode("RetTopStart", data))
    print(ProtoMsgHelp.block(msg))
    if msg.round==RaceTopState.Audition then
        RaceTopSuperManager:Get():SetRaceType(RaceTopRaceType.Audition)
    elseif msg.round==RaceTopState.RaceB then
        RaceTopSuperManager:Get():SetRaceType(RaceTopRaceType.RaceB)
    else
        RaceTopSuperManager:Get():SetRaceType(RaceTopRaceType.RaceTop)
    end
    RaceTopSuperManager:Get().RaceData=RaceTopData()
    RaceTopSuperManager:Get().RaceData.Status=msg.round
    RaceTopSuperManager:Get():BeginBattle(msg)
end
--{{{ 请求战斗巅峰赛回放
function RaceTopSuperSubsystem:SendMsg_BeginBattleRaceTopRecord(rid, state)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), rid, RaceTopSuperManager:Get():GetSeasonId(), state})
    NetManager:Get():Send(MsgID.RACE_TOP2_RECORD_C2S_REQ, data)
end

function RaceTopSuperSubsystem:RecvMsg_BeginBattleRaceTopRecord(data)
    ---@type SC_RetTopRecord
    local msg = assert(Dll_PB.decode("RetTopRecord", data))
    print(ProtoMsgHelp.block(msg))
    UIManager:Get():ClosePopup()
    cs_coroutine.start(function()
        coroutine.yield()
        RankListTestVerifyDataManager:Get():SetLookVersion(msg.start.ver)
        RaceTopSuperManager:Get():SetRaceType(RaceTopRaceType.Record)
        RaceTopSuperManager:Get():BeginBattle(msg,true)
    end)

end
--}}}

--{{{ 完成战斗巅峰赛巅峰
function RaceTopSuperSubsystem:SendMsg_FinishBattleRaceTopTop(time, error, rank, startTime, recordValue)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), time, error, rank, RaceTopSuperManager:Get():GetStates(), recordValue, startTime})
    NetManager:Get():Send(MsgID.RACE_TOP2_TOP_FINISH_BATTLE_C2S_REQ, data)
end

function RaceTopSuperSubsystem:RecvMsg_FinishBattleRaceTopTop(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("TopFinish", data))
    print(ProtoMsgHelp.block(msg))
    RaceTopSuperManager:Get():BattleResult()
end
--}}}
--{{{ 请求战斗巅峰赛B
function RaceTopSuperSubsystem:SendMsg_BeginBattleRaceTopB(carid)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), carid, RaceTopSuperManager:Get():GetStates() })
    NetManager:Get():Send(MsgID.RACE_TOP2_B_BEGIN_BATTLE_C2S_REQ, data)
end

function RaceTopSuperSubsystem:RecvMsg_BeginBattleRaceTopB(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("RetTopStart", data))
    print(ProtoMsgHelp.block(msg))
    RaceTopSuperManager:Get():SetRaceType(RaceTopRaceType.RaceB)
    RaceTopSuperManager:Get():BeginBattle(msg)

end
--}}}
--{{{ 完成战斗巅峰赛B
function RaceTopSuperSubsystem:SendMsg_FinishBattleRaceTopB(time, error, rank, startTime, recordValue)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), time, error, rank, RaceTopSuperManager:Get():GetStates(), recordValue, startTime })
    NetManager:Get():Send(MsgID.RACE_TOP2_B_FINISH_BATTLE_C2S_REQ, data)
end

function RaceTopSuperSubsystem:RecvMsg_FinishBattleRaceTopB(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("TopFinish", data))
    print(ProtoMsgHelp.block(msg))
    RaceTopSuperManager:Get():BattleResult()
end
--}}}
--{{{ 巅峰赛海选榜
function RaceTopSuperSubsystem:SendMsg_GetRankListAudition()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.RACE_TOP2_AUDITION_RANK_LIST_C2S_REQ, data)
end

function RaceTopSuperSubsystem:RecvMsg_GetRankListAudition(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("RetRank", data))
    print(ProtoMsgHelp.block(msg))
    RankingListDataManager:Get():Init(msg)
    if not UIManager:Get():IsPopViewShow("RaceTopSuperRankingListView") then
        UIManager:Get():OpenPopup("RaceTopSuperRankingListView", CanvasType.MainCanvas, "RaceTopSuperRankingListView")
    end
end
--}}}
--{{{ 巅峰赛巅峰榜
function RaceTopSuperSubsystem:SendMsg_GetRankListTop()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.RACE_TOP2_TOP_RANK_LIST_C2S_REQ, data)
end

function RaceTopSuperSubsystem:RecvMsg_GetRankListTop(data)
    ---@type SC_TopFight
    local msg = assert(Dll_PB.decode("TopFightRanks", data))
    print(ProtoMsgHelp.block(msg))
    RaceTopSuperManager:Get():SetGroupData(msg)
    UIManager:Get():OpenPopup("RaceTopSuperGroupView",CanvasType.FrontCanvas,"RaceTopSuperGroupView")
end
--}}}
--{{{ 巅峰赛巅峰榜
function RaceTopSuperSubsystem:SendMsg_RaceTopGood(id)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), RaceTopSuperManager:Get():GetStates(), id })
    NetManager:Get():Send(MsgID.RACE_TOP2_GOOD_C2S_REQ, data)
end

function RaceTopSuperSubsystem:RecvMsg_RaceTopGoodRes(data)
    ---@type SC_TopFight
    local msg = assert(Dll_PB.decode("TopFightRanks", data))
    print(ProtoMsgHelp.block(msg))
    RaceTopSuperManager:Get().RaceGroupData:SetData(msg)
    UINotify:Get():SendNotification(UINotifyEvent.RaceTopGroup2_SetData,false)
end
--}}}
--{{{ 巅峰赛B榜
function RaceTopSuperSubsystem:SendMsg_GetRankListB()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.RACE_TOP2_B_RANK_LIST_C2S_REQ, data)
end

function RaceTopSuperSubsystem:RecvMsg_GetRankListB(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("RetRank", data))
    print(ProtoMsgHelp.block(msg))
    RankingListDataManager:Get():Init(msg)
    if not UIManager:Get():IsPopViewShow("RaceTopSuperRankingListView") then
        UIManager:Get():OpenPopup("RaceTopSuperRankingListView", CanvasType.MainCanvas, "RaceTopSuperRankingListView")
    end
end
--}}}

local __subsystem = RaceTopSuperSubsystem()
function RaceTopSuperSubsystem:Get() return __subsystem end
return __subsystem