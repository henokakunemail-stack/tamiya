---@class RaceClub3v3Subsystem
RaceClub3v3Subsystem = class("RaceClub3v3Subsystem")

function RaceClub3v3Subsystem:initialize( ... )
    NetResponseEventManager:Get():AddListener(MsgID.RACE_CLUB3V3_INFO_S2C_RES , self, self.RecvMsg_GetInfo)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_CLUB3V3_BEGIN_BATTLE_S2C_RES , self, self.RecvMsg_BeginBattle)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_CLUB3V3_FINISH_BATTLE_S2C_RES , self, self.RecvMsg_FinishBattle)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_CLUB3V3_CLUB_REWARD_S2C_RES , self, self.RecvMsg_GetClubReward)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_CLUB3V3_SELF_REWARD_S2C_RES , self, self.RecvMsg_GetSelfReward)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_CLUB3V3_REBATTLE_S2C_RES , self, self.RecvMsg_GetRefight)
end

function RaceClub3v3Subsystem:SendMsg_GetInfo()
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.RACE_CLUB3V3_INFO_C2S_REQ,data)
end
function RaceClub3v3Subsystem:RecvMsg_GetInfo(data)
    ---@type SC_ReqGuildPveInfo
    local msg = assert(Dll_PB.decode("ReqGuildPveInfo", data))
    print(ProtoMsgHelp.block(msg))
    RaceClub3V3Manager:Get().ReturnBattle=false
    RaceClub3V3Manager:Get():SetData(msg)
    UIManager:Get():OpenView("RaceClub3V3View", CanvasType.MainCanvas, "RaceClub3V3View")
end
function RaceClub3v3Subsystem:SendMsg_BeginBattle(carIdx)
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),carIdx})
    NetManager:Get():Send(MsgID.RACE_CLUB3V3_BEGIN_BATTLE_C2S_REQ,data)
end
function RaceClub3v3Subsystem:RecvMsg_BeginBattle(data)
    ---@type SC_RetGuildPVEBegin
    local msg = assert(Dll_PB.decode("RetGuildPVEBegin", data))
    print(ProtoMsgHelp.block(msg))
    RaceClub3V3Manager:Get():BeginBattle(msg)
end
function RaceClub3v3Subsystem:SendMsg_FinishBattle(time,rank,error,Result,GetFrameCount,curBat,lastFlag)
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),time,rank,error,Result,curBat,lastFlag})
    NetManager:Get():Send(MsgID.RACE_CLUB3V3_FINISH_BATTLE_C2S_REQ,data)
end
function RaceClub3v3Subsystem:RecvMsg_FinishBattle(data)
    ---@type SC_RetGuildPVEFinish
    local msg = assert(Dll_PB.decode("RetGuildPVEFinish", data))
    print(ProtoMsgHelp.block(msg))
    RaceClub3V3Manager:Get():SetAddScore(msg.scores)
    BattleDataManager:Get():SetStateBattleResult()
end

function RaceClub3v3Subsystem:SendMsg_GetClubReward(idx)
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),idx})
    NetManager:Get():Send(MsgID.RACE_CLUB3V3_CLUB_REWARD_C2S_REQ,data)
end
function RaceClub3v3Subsystem:RecvMsg_GetClubReward(data)
    ---@type SC_RetGuildPointAward
    local msg = assert(Dll_PB.decode("RetGuildPointAward", data))
    print(ProtoMsgHelp.block(msg))
    RaceClub3V3Manager:Get():SetGuideAward(msg.guildaward)
    UINotify:Get():SendNotification(UINotifyEvent.RefreshRaceClub3v3Reward)
    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist[1],true)
    ClubDataManager:Get():GetCurSelectClubData():SetCoin(msg.curExp)
end
function RaceClub3v3Subsystem:SendMsg_GetSelfReward(idx)
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),idx})
    NetManager:Get():Send(MsgID.RACE_CLUB3V3_SELF_REWARD_C2S_REQ,data)
end
function RaceClub3v3Subsystem:RecvMsg_GetSelfReward(data)
    ---@type SC_RetGuildPersonPointAward
    local msg = assert(Dll_PB.decode("RetGuildPersonPointAward", data))
    print(ProtoMsgHelp.block(msg))
    RaceClub3V3Manager:Get():SetSelfAward(msg.guildpersonaward)
    UINotify:Get():SendNotification(UINotifyEvent.RefreshRaceClub3v3Reward)
    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist[1],true)
    ClubDataManager:Get():GetCurSelectClubData():SetCoin(msg.curExp)
end
function RaceClub3v3Subsystem:SendMsg_Refight()
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.RACE_CLUB3V3_REBATTLE_C2S_REQ,data)
end
function RaceClub3v3Subsystem:RecvMsg_GetRefight(data)
    ---@type SC_RetGuildPVEBegin
    local msg = assert(Dll_PB.decode("RetGuildPVEBegin", data))
    print(ProtoMsgHelp.block(msg))
    RaceClub3V3Manager:Get():BeginBattle(msg)
end


local __subsystem = RaceClub3v3Subsystem()
function RaceClub3v3Subsystem:Get() return __subsystem end
return __subsystem