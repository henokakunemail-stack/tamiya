---@class RaceTrotSubsystem
RaceTrotSubsystem = class("RaceTrotSubsystem")

function RaceTrotSubsystem:initialize( ... )
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TROT_ENTER_S2C_REQ, self, self.RecvMsg_EnterRaceTrot)
   -- NetResponseEventManager:Get():AddListener(MsgID.RACE_TROT_GET_RECORD_S2C_REQ, self, self.RecvMsg_GetRecord)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TROT_REFRESH_TRACK_S2C_REQ, self, self.RecvMsg_RefreshTrack)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TROT_SELECT_TRACK_S2C_REQ, self, self.RecvMsg_SelectTrack)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TROT_SELECT_ENEMY_S2C_REQ, self, self.RecvMsg_SelectEnemy)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TROT_REFRESH_ENEMY_S2C_REQ, self, self.RecvMsg_RefreshEnemy)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TROT_OBSERVATION_ENEMY_S2C_REQ, self, self.RecvMsg_ObservationEnemy)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TROT_BEGIN_BATTLE_S2C_REQ, self, self.RecvMsg_BeginBattle)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TROT_FINISH_BATTLE_S2C_REQ, self, self.RecvMsg_FinishBattle)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TROT_RANK_LIST_S2C_REQ, self, self.RecvMsg_RankList)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_TROT_RE_BATTLE_S2C_REQ, self, self.RecvMsg_SetReFightData)
end
local EnterCallBack=nil
--{{{ 请求进入疾走赛
function RaceTrotSubsystem:SendMsg_EnterRaceTrot(func)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    EnterCallBack=func
    NetManager:Get():Send(MsgID.RACE_TROT_ENTER_C2S_RES, data)
end

function RaceTrotSubsystem:RecvMsg_EnterRaceTrot(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("FastMatch", data))
    print(ProtoMsgHelp.block(msg))
    RaceTrotManager:Get():Init(msg)
    if EnterCallBack then
        EnterCallBack()
        EnterCallBack=nil
    end
    if RaceTrotManager:Get():GetStep()==RaceTrotStep.SelectTrack then
        UIManager:Get():OpenView("RaceTrotEnterView", CanvasType.MainCanvas, "RaceTrotEnterView")
    end
    if RaceTrotManager:Get():GetStep()==RaceTrotStep.SelectEnemy then
        --UIManager:Get():OpenView("RaceTrotSelectTrackView", CanvasType.MainCanvas, "RaceTrotSelectTrackView")
        UIManager:Get():OpenView("RaceTrotSelectEnemyView", CanvasType.MainCanvas, "RaceTrotSelectEnemyView")
        UINotify:Get():SendNotification(UINotifyEvent.RankTrotSelectEnemy_SetData,false)
    end
    if RaceTrotManager:Get():GetStep()==RaceTrotStep.Ready then
       -- UIManager:Get():OpenView("RaceTrotSelectTrackView", CanvasType.MainCanvas, "RaceTrotSelectTrackView")
       -- UIManager:Get():OpenView("RaceTrotSelectEnemyView", CanvasType.MainCanvas, "RaceTrotSelectEnemyView")
        UIManager:Get():OpenView("RaceTrotSelectCarView", CanvasType.MainCanvas, "RaceTrotSelectCarView")
        UINotify:Get():SendNotification(UINotifyEvent.RankTrotSelectCar_SetData)
    end
end
--}}}
--{{{ 历史战绩
function RaceTrotSubsystem:SendMsg_GetRecord()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.RACE_TROT_GET_RECORD_C2S_RES, data)
end

function RaceTrotSubsystem:RecvMsg_GetRecord(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("FastMatch", data))
    print(ProtoMsgHelp.block(msg))
    UIManager:Get():OpenPopup("RaceTrotHistoryView",CanvasType.FrontCanvas,"RaceTrotHistoryView")
end
--}}}
--{{{ 刷新赛道
function RaceTrotSubsystem:SendMsg_RefreshTrack()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.RACE_TROT_REFRESH_TRACK_C2S_RES, data)
end

function RaceTrotSubsystem:RecvMsg_RefreshTrack(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("FastMatch", data))
    print(ProtoMsgHelp.block(msg))
    RaceTrotManager:Get():SetStandByTrackList(msg.standbytrack)
    RaceTrotManager:Get():SetFreshTrack(msg.freshtrack)
    RaceTrotManager:Get():SetTrackWinPercent(msg.trackwinpercent)
    KnapsackDataManager:Get():UpdatePropByConsume(msg.payMoney)
    UINotify:Get():SendNotification(UINotifyEvent.RankTrotSelectTrack_SetData,true)
end
--}}}
--{{{ 选择赛道
function RaceTrotSubsystem:SendMsg_SelectTrack(id)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),id })
    NetManager:Get():Send(MsgID.RACE_TROT_SELECT_TRACK_C2S_RES, data)
end

function RaceTrotSubsystem:RecvMsg_SelectTrack(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("FastMatch", data))
    print(ProtoMsgHelp.block(msg))
    RaceTrotManager:Get():SetEnemyList(msg.standbyfighter)
    UIManager:Get():CloseView()
    UIManager:Get():OpenView("RaceTrotSelectEnemyView", CanvasType.MainCanvas, "RaceTrotSelectEnemyView")
    UINotify:Get():SendNotification(UINotifyEvent.RankTrotSelectEnemy_SetData,false)
end
--}}}
--{{{ 选择对手
function RaceTrotSubsystem:SendMsg_SelectEnemy(id)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),id })
    NetManager:Get():Send(MsgID.RACE_TROT_SELECT_ENEMY_C2S_RES, data)
end

function RaceTrotSubsystem:RecvMsg_SelectEnemy(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("FastMatch", data))
    print(ProtoMsgHelp.block(msg))
    RaceTrotManager:Get():SetSelectEnemy(msg)
    UIManager:Get():CloseView()
    UIManager:Get():OpenView("RaceTrotSelectCarView", CanvasType.MainCanvas, "RaceTrotSelectCarView")
end
--}}}
--{{{ 刷新对手
function RaceTrotSubsystem:SendMsg_RefreshEnemy()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.RACE_TROT_REFRESH_ENEMY_C2S_RES, data)
end

function RaceTrotSubsystem:RecvMsg_RefreshEnemy(data)
    ---@type SC_FastMatch
    local msg = assert(Dll_PB.decode("FastMatch", data))
    print(ProtoMsgHelp.block(msg))
    RaceTrotManager:Get():SetEnemyList(msg.standbyfighter)
    RaceTrotManager:Get():SetFreshFighter(msg.freshfighter)
    RaceTrotManager:Get():SetGetEnemyWatched(msg.watchloc)
    KnapsackDataManager:Get():UpdatePropByConsume(msg.payMoney)
    UINotify:Get():SendNotification(UINotifyEvent.RankTrotSelectEnemy_SetData,true)
end
--}}}
--{{{ 侦查对手
function RaceTrotSubsystem:SendMsg_ObservationEnemy(id)
    local data = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id})
    NetManager:Get():Send(MsgID.RACE_TROT_OBSERVATION_ENEMY_C2S_RES, data)
end

function RaceTrotSubsystem:RecvMsg_ObservationEnemy(data)
    ---@type SC_WatchFighter
    local msg = assert(Dll_PB.decode("WatchFighter", data))
    print(ProtoMsgHelp.block(msg))
    KnapsackDataManager:Get():UpdatePropByConsume(msg.payMoney)
    local watchFighter=  RaceTrotManager:Get():GetGetEnemyDataByIdx(msg.watchloc+1)
    CommonHelper:ShowCarInfoByCarReviewData(watchFighter.Car)
    RaceTrotManager:Get():SetGetEnemyWatchedByIdx(msg.watchloc+1,watchFighter.Id)
    UINotify:Get():SendNotification(UINotifyEvent.RankTrotSelectEnemy_RefreshWatch)
end
--}}}
--{{{ 开始战斗
function RaceTrotSubsystem:SendMsg_BeginBattle(caridx,flag)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),caridx,flag })
    NetManager:Get():Send(MsgID.RACE_TROT_BEGIN_BATTLE_C2S_RES, data)
end
function RaceTrotSubsystem:SendMsg_ReEnterBattle()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.RACE_TROT_RE_BATTLE_C2S_RES, data)
end

function RaceTrotSubsystem:RecvMsg_BeginBattle(data)
    ---@type SC_BeginFastPvp
    local msg = assert(Dll_PB.decode("BeginFastPvp", data))
    print(ProtoMsgHelp.block(msg))
    RaceTrotManager:Get():BeginBattle(msg)
end
--}}}
--{{{ 战斗结算
function RaceTrotSubsystem:SendMsg_FinishBattle(time,rank,error,isFerrule,FrameCount)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),time,rank,error,isFerrule,FrameCount})
    NetManager:Get():Send(MsgID.RACE_TROT_FINISH_BATTLE_C2S_RES, data)
end

function RaceTrotSubsystem:RecvMsg_FinishBattle(data)
    ---@type SC_FinishFastPvp
    local msg = assert(Dll_PB.decode("FinishFastPvp", data))
    print(ProtoMsgHelp.block(msg))
    RaceTrotManager:Get():FinishBattle(msg)
end
--}}}
function RaceTrotSubsystem:RecvMsg_SetReFightData(data)
    ---@type SC_BeginFastPvp
    local msg = assert(Dll_PB.decode("BeginFastPvp", data))
    print(ProtoMsgHelp.block(msg))
    RaceTrotManager:Get():Init(msg.match)
    RaceTrotManager:Get():BeginBattle(msg)

end
--}}}

--{{{ 排行榜
function RaceTrotSubsystem:SendMsg_RankList()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.RACE_TROT_RANK_LIST_C2S_RES, data)
end

function RaceTrotSubsystem:RecvMsg_RankList(data)
    ---@type SC_RetRank
    local msg = assert(Dll_PB.decode("RetRank", data))
    print(ProtoMsgHelp.block(msg))
    msg.ranktype = RankingListType.RaceTrot
    local data = RankingListData()
    data:SetData(msg)
    UIManager:Get():OpenPopup("RaceTrotRankingListView",CanvasType.FrontCanvas,"RaceTrotRankListView")
    UINotify:Get():SendNotification(UINotifyEvent.RankTrotRankList_SetData,data)
end
--}}}



local __subsystem = RaceTrotSubsystem()
function RaceTrotSubsystem:Get() return __subsystem end
return __subsystem