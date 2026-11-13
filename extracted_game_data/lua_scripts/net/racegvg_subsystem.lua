---@class RaceGVGSubsystem
RaceGVGSubsystem = class("RaceGVGSubsystem")

function RaceGVGSubsystem:initialize( ... )
    NetResponseEventManager:Get():AddListener(MsgID.RACE_GVG_INFO_S2C_RET , self, self.RecvMsg_RaceInfo)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_GVG_JOIN_S2C_RET , self, self.RecvMsg_JoinRace)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_GVG_BEGIN_BATTLE_S2C_RET , self, self.RecvMsg_BeginBattle)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_GVG_FINISH_BATTLE_S2C_RET , self, self.RecvMsg_FinishBattle)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_GVG_RANK_LIST_S2C_RET , self, self.RecvMsg_RankList)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_GVG_RE_BATTLE_S2C_RET, self, self.RecvMsg_ReBattle)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_GVG_BATTLE_INFO_S2C_RET, self, self.RecvMsg_BattleScore)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_GVG_RANK_LIST_ALL_S2C_RET, self, self.RecvMsg_GetClubRankList)
end

function RaceGVGSubsystem:SendMsg_GetInfo()
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.RACE_GVG_INFO_C2S_REQ,data)
    --UIManager:Get():OpenView("RaceGVGView", CanvasType.MainCanvas, "RaceGVGView")
end
function RaceGVGSubsystem:RecvMsg_RaceInfo(data)
    ---@type SC_RetGvgPointInfo
    local msg = assert(Dll_PB.decode("RetGvgPointInfo", data))
    print(ProtoMsgHelp.block(msg))
    RaceGVGManager:Get():SetData(msg)
    RaceGVGManager:Get().ReturnBattleGVG=false
    if not UIManager:Get():IsViewShow("RaceGVGView") then
        UIManager:Get():OpenView("RaceGVGView", CanvasType.MainCanvas, "RaceGVGView")
    end
    UINotify:Get():SendNotification(UINotifyEvent.RaceGVG_SetData)
end
function RaceGVGSubsystem:SendMsg_JoinRace()
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.RACE_GVG_JOIN_C2S_REQ,data)
end
function RaceGVGSubsystem:RecvMsg_JoinRace(data)
    ---@type SC_ReqGuildPveInfo
    local msg = assert(Dll_PB.decode("ReqGuildPveInfo", data))
    print(ProtoMsgHelp.block(msg))
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceGVGSignSuccess))
    RaceGVGManager:Get():SetCanJoin(2)
    UINotify:Get():SendNotification(UINotifyEvent.RaceGVG_SetData)
end

function RaceGVGSubsystem:SendMsg_BeginBattle(caridx)
    local body = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),caridx,RaceGVGManager:Get():GetState()})
    NetManager:Get():Send(MsgID.RACE_GVG_BEGIN_BATTLE_C2S_REQ, body)
end
function RaceGVGSubsystem:RecvMsg_BeginBattle(data)
    ---@type SC_RetGvgPointStart
    local msg = assert(Dll_PB.decode("RetGvgPointStart", data))
    print(ProtoMsgHelp.block(msg))
    --RaceGVGManager:Get():SetBattleCar(msg.carid)
    RaceGVGManager:Get():BeginBattle(msg)
end

function RaceGVGSubsystem:SendMsg_FinishRace(time,error,rank)
    local body = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID() ,time,error, rank,RaceGVGManager:Get():GetState()})
    NetManager:Get():Send(MsgID.RACE_GVG_FINISH_BATTLE_C2S_REQ, body)
end
function RaceGVGSubsystem:RecvMsg_FinishBattle(data)
    ---@type SC_GvgPointFinish
    local msg = assert(Dll_PB.decode("GvgPointFinish", data))
    print(ProtoMsgHelp.block(msg))
    RaceGVGManager:Get():SetAddScore(msg.point)
    BattleDataManager:Get():SetStateBattleResult()
end
function RaceGVGSubsystem:SendMsg_RankList(type,stage,inx)
    local body = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),type,stage,inx})
    NetManager:Get():Send(MsgID.RACE_GVG_RANK_LIST_C2S_REQ, body)
end
function RaceGVGSubsystem:RecvMsg_RankList(data)
    ---@type SC_GvgPointRanks
    local msg = assert(Dll_PB.decode("GvgPointRanks", data))
    print(ProtoMsgHelp.block(msg))
    if msg.type==1 then
        msg.ranktype=RankingListType.RaceGVGPoint
    else
        if msg.stageid==RaceGVGState.Race1Battle then
            msg.ranktype=RankingListType.RaceGVGSpeed1
        end
        if msg.stageid==RaceGVGState.Race2Battle then
            msg.ranktype=RankingListType.RaceGVGSpeed2
        end
        if msg.stageid==RaceGVGState.Race3Battle then
            msg.ranktype=RankingListType.RaceGVGSpeed3
        end
    end
    RankingListDataManager:Get():Init(msg)
    if not UIManager:Get():IsPopViewShow("RaceGVGRankListView") then
        UIManager:Get():OpenPopup("RaceGVGRankListView", CanvasType.FrontCanvas, "RaceGVGRankListView")
    end
    UINotify:Get():SendNotification(UINotifyEvent.RaceGVGRankList_SetData)
end
function RaceGVGSubsystem:SendMsg_ReFight()
    local body = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.RACE_GVG_RE_BATTLE_C2S_REQ, body)
end

function RaceGVGSubsystem:RecvMsg_ReBattle(data)
    ---@type SC_RetGvgPointStart
    local msg = assert(Dll_PB.decode("RetGvgPointStart", data))
    print(ProtoMsgHelp.block(msg))
    RaceGVGManager:Get():SetState(msg.round)
    RaceGVGManager:Get():BeginBattle(msg)
end
function RaceGVGSubsystem:SendMsg_GetBattleScore()
    local body = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),RaceGVGManager:Get():GetMatchSuccess()})
    NetManager:Get():Send(MsgID.RACE_GVG_BATTLE_INFO_C2S_REQ, body)
end

function RaceGVGSubsystem:RecvMsg_BattleScore(data)
    ---@type SC_RetGvgPointScoreInfo
    local msg = assert(Dll_PB.decode("RetGvgPointScoreInfo", data))
    print(ProtoMsgHelp.block(msg))
    for i = 1, #msg.guildids do
        if msg.guildids[i]==RaceGVGManager:Get():GetGuildId() then
            RaceGVGManager:Get():SetGuildScore(msg.scores[i])
        end
        if msg.guildids[i]==RaceGVGManager:Get():GetFGuildId() then
            RaceGVGManager:Get():SetFGuildScore(msg.scores[i])
        end
    end
    UIManager:Get():OpenPopup("RaceGVGResultView",CanvasType.MainCanvas,"RaceGVGResultView")
end
function RaceGVGSubsystem:SendMsg_GetClubRankList()
    local body = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.RACE_GVG_RANK_LIST_ALL_C2S_REQ, body)
end

function RaceGVGSubsystem:RecvMsg_GetClubRankList(data)
    ---@type SC_GvgPointRank
    local msg = assert(Dll_PB.decode("RetGuildInfo", data))
    print(ProtoMsgHelp.block(msg))
    msg.ranktype=RankingListType.RaceClubAll
    RankingListDataManager:Get():Init(msg)
    if not UIManager:Get():IsPopViewShow("RaceGVGRankListView") then
        UIManager:Get():OpenPopup("RaceGVGRankListView", CanvasType.FrontCanvas, "RaceGVGRankListView")
    end
    UINotify:Get():SendNotification(UINotifyEvent.RaceGVGRankList_SetData)
end
local __subsystem = RaceGVGSubsystem()
function RaceGVGSubsystem:Get() return __subsystem end
return __subsystem