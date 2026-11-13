---@class RaceTopSubsystem
RaceTopSubsystem = class("RaceTopSubsystem")

function RaceTopSubsystem:initialize( ... )
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP_INFO_S2C_RET, self, self.RecvMsg_EnterRaceTop)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP_AUDITION_BEGIN_BATTLE_S2C_RES, self, self.RecvMsg_BeginBattleRaceTopAudition)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP_AUDITION_FINISH_BATTLE_S2C_RES, self, self.RecvMsg_FinishBattleRaceTopAudition)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP_TOP_BEGIN_BATTLE_S2C_RES, self, self.RecvMsg_BeginBattleRaceTopTop)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP_TOP_FINISH_BATTLE_S2C_RES, self, self.RecvMsg_FinishBattleRaceTopTop)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP_B_BEGIN_BATTLE_S2C_RES, self, self.RecvMsg_BeginBattleRaceTopB)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP_B_FINISH_BATTLE_S2C_RES, self, self.RecvMsg_FinishBattleRaceTopB)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP_AUDITION_RANK_LIST_S2C_RES, self, self.RecvMsg_GetRankListAudition)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP_TOP_RANK_LIST_S2C_RES, self, self.RecvMsg_GetRankListTop)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP_B_RANK_LIST_S2C_RES, self, self.RecvMsg_GetRankListB)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP_RECORD_S2C_RES, self, self.RecvMsg_BeginBattleRaceTopRecord)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP_RE_FIGHT_S2C_RES, self, self.RecvMsg_BeginBattleRaceTopReFight)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TOP_GOOD_S2C_RES, self, self.RecvMsg_RaceTopGoodRes)
end
local EnterCallBack=nil
--{{{ 请求进入巅峰赛
function RaceTopSubsystem:SendMsg_EnterRaceTop(func)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    EnterCallBack=func
    NetManager:Get():Send(MsgID.RACE_TOP_INFO_C2S_REQ, data)
end

function RaceTopSubsystem:RecvMsg_EnterRaceTop(data)
    ---@type SC_RetTopInfo
    local msg = assert(Dll_PB.decode("RetTopInfo", data))
    print(ProtoMsgHelp.block(msg))
    RaceTopManager:Get():Init(msg)
    if not UIManager:Get():IsViewShow("RaceTopView") then
        if EnterCallBack then
            EnterCallBack()
            EnterCallBack=nil
        end
        UIManager:Get():OpenView("RaceTopView",CanvasType.MainCanvas,"RaceTopView")
    end
    UINotify:Get():SendNotification(UINotifyEvent.RaceTop_SetData)
end
--}}}
--{{{ 请求战斗巅峰赛海选
function RaceTopSubsystem:SendMsg_BeginBattleRaceTopAudition(carid)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),carid})
    NetManager:Get():Send(MsgID.RACE_TOP_AUDITION_BEGIN_BATTLE_C2S_REQ, data)
end

function RaceTopSubsystem:RecvMsg_BeginBattleRaceTopAudition(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("RetTopStart", data))
    print(ProtoMsgHelp.block(msg))
    RaceTopManager:Get():SetRaceType(RaceTopRaceType.Audition)
    RaceTopManager:Get():BeginBattle(msg)

end
--}}}
--{{{ 完成战斗巅峰赛海选
function RaceTopSubsystem:SendMsg_FinishBattleRaceTopAudition(time,error,rank,startTime,recordValue)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),time,error,rank,RaceTopManager:Get():GetStates(),recordValue,startTime})
    NetManager:Get():Send(MsgID.RACE_TOP_AUDITION_FINISH_BATTLE_C2S_REQ, data)
end

function RaceTopSubsystem:RecvMsg_FinishBattleRaceTopAudition(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("TopFinish", data))
    print(ProtoMsgHelp.block(msg))
    RaceTopManager:Get():BattleResult()
end
--}}}
--{{{ 请求战斗巅峰赛巅峰
function RaceTopSubsystem:SendMsg_BeginBattleRaceTopTop(carid)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),carid,RaceTopManager:Get():GetStates() })
    NetManager:Get():Send(MsgID.RACE_TOP_TOP_BEGIN_BATTLE_C2S_REQ, data)
end

function RaceTopSubsystem:RecvMsg_BeginBattleRaceTopTop(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("RetTopStart", data))
    print(ProtoMsgHelp.block(msg))
    RaceTopManager:Get():SetRaceType(RaceTopRaceType.RaceTop)
    RaceTopManager:Get():BeginBattle(msg)

end
--}}}
function RaceTopSubsystem:SendMsg_ReFight()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.RACE_TOP_RE_FIGHT_C2S_REQ, data)
end
function RaceTopSubsystem:RecvMsg_BeginBattleRaceTopReFight(data)
    ---@type SC_RetTopStart
    local msg = assert(Dll_PB.decode("RetTopStart", data))
    print(ProtoMsgHelp.block(msg))
    if msg.round==RaceTopState.Audition then
        RaceTopManager:Get():SetRaceType(RaceTopRaceType.Audition)
    elseif msg.round==RaceTopState.RaceB then
        RaceTopManager:Get():SetRaceType(RaceTopRaceType.RaceB)
    else
        RaceTopManager:Get():SetRaceType(RaceTopRaceType.RaceTop)
    end
    RaceTopManager:Get().RaceData=RaceTopData()
    RaceTopManager:Get().RaceData.Status=msg.round
    RaceTopManager:Get():BeginBattle(msg)
end
--{{{ 请求战斗巅峰赛回放
function RaceTopSubsystem:SendMsg_BeginBattleRaceTopRecord(rid,state)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),rid,RaceTopManager:Get():GetSeasonId(),state})
    NetManager:Get():Send(MsgID.RACE_TOP_RECORD_C2S_REQ, data)
end

function RaceTopSubsystem:RecvMsg_BeginBattleRaceTopRecord(data)
    ---@type SC_RetTopRecord
    local msg = assert(Dll_PB.decode("RetTopRecord", data))
    print(ProtoMsgHelp.block(msg))
    UIManager:Get():ClosePopup()
    cs_coroutine.start(function()
        coroutine.yield()
        RankListTestVerifyDataManager:Get():SetLookVersion(msg.start.ver)
        RaceTopManager:Get():SetRaceType(RaceTopRaceType.Record)
        RaceTopManager:Get():BeginBattle(msg,true)
    end)

end
--}}}

--{{{ 完成战斗巅峰赛巅峰
function RaceTopSubsystem:SendMsg_FinishBattleRaceTopTop(time,error,rank,startTime,recordValue)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),time,error,rank,RaceTopManager:Get():GetStates(),recordValue,startTime})
    NetManager:Get():Send(MsgID.RACE_TOP_TOP_FINISH_BATTLE_C2S_REQ, data)
end

function RaceTopSubsystem:RecvMsg_FinishBattleRaceTopTop(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("TopFinish", data))
    print(ProtoMsgHelp.block(msg))
    RaceTopManager:Get():BattleResult()
end
--}}}
--{{{ 请求战斗巅峰赛B
function RaceTopSubsystem:SendMsg_BeginBattleRaceTopB(carid)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),carid,RaceTopManager:Get():GetStates() })
    NetManager:Get():Send(MsgID.RACE_TOP_B_BEGIN_BATTLE_C2S_REQ, data)
end

function RaceTopSubsystem:RecvMsg_BeginBattleRaceTopB(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("RetTopStart", data))
    print(ProtoMsgHelp.block(msg))
    RaceTopManager:Get():SetRaceType(RaceTopRaceType.RaceB)
    RaceTopManager:Get():BeginBattle(msg)

end
--}}}
--{{{ 完成战斗巅峰赛B
function RaceTopSubsystem:SendMsg_FinishBattleRaceTopB(time,error,rank,startTime,recordValue)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),time,error,rank,RaceTopManager:Get():GetStates(),recordValue,startTime })
    NetManager:Get():Send(MsgID.RACE_TOP_B_FINISH_BATTLE_C2S_REQ, data)
end

function RaceTopSubsystem:RecvMsg_FinishBattleRaceTopB(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("TopFinish", data))
    print(ProtoMsgHelp.block(msg))
    RaceTopManager:Get():BattleResult()
end
--}}}
--{{{ 巅峰赛海选榜
function RaceTopSubsystem:SendMsg_GetRankListAudition()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.RACE_TOP_AUDITION_RANK_LIST_C2S_REQ, data)
end

function RaceTopSubsystem:RecvMsg_GetRankListAudition(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("RetRank", data))
    print(ProtoMsgHelp.block(msg))
    RankingListDataManager:Get():Init(msg)
    if not UIManager:Get():IsPopViewShow("RaceTopRankingListView") then
        UIManager:Get():OpenPopup("RaceTopRankingListView", CanvasType.MainCanvas, "RaceTopRankingListView")
    end
end
--}}}
--{{{ 巅峰赛巅峰榜
function RaceTopSubsystem:SendMsg_GetRankListTop()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.RACE_TOP_TOP_RANK_LIST_C2S_REQ, data)
end

function RaceTopSubsystem:RecvMsg_GetRankListTop(data)
    ---@type SC_TopFight
    local msg = assert(Dll_PB.decode("TopFightRanks", data))
    print(ProtoMsgHelp.block(msg))
    RaceTopManager:Get():SetGroupData(msg)
    UIManager:Get():OpenPopup("RaceTopGroupView",CanvasType.FrontCanvas,"RaceTopGroupView")
end
--}}}
--{{{ 巅峰赛巅峰榜
function RaceTopSubsystem:SendMsg_RaceTopGood(id)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),RaceTopManager:Get():GetStates(),id })
    NetManager:Get():Send(MsgID.RACE_TOP_GOOD_C2S_REQ, data)
end

function RaceTopSubsystem:RecvMsg_RaceTopGoodRes(data)
    ---@type SC_TopFight
    local msg = assert(Dll_PB.decode("TopFightRanks", data))
    print(ProtoMsgHelp.block(msg))
    RaceTopManager:Get().RaceGroupData:SetData(msg)
    UINotify:Get():SendNotification(UINotifyEvent.RaceTopGroup_SetData,false)
end
--}}}
--{{{ 巅峰赛B榜
function RaceTopSubsystem:SendMsg_GetRankListB()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.RACE_TOP_B_RANK_LIST_C2S_REQ, data)
end

function RaceTopSubsystem:RecvMsg_GetRankListB(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("RetRank", data))
    print(ProtoMsgHelp.block(msg))
    RankingListDataManager:Get():Init(msg)
    if not UIManager:Get():IsPopViewShow("RaceTopRankingListView") then
        UIManager:Get():OpenPopup("RaceTopRankingListView", CanvasType.MainCanvas, "RaceTopRankingListView")
    end
end
--}}}

local __subsystem = RaceTopSubsystem()
function RaceTopSubsystem:Get() return __subsystem end
return __subsystem