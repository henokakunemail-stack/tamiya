---@class RaceFifaSubsystem
RaceFifaSubsystem = class("RaceFifaSubsystem")

function RaceFifaSubsystem:initialize( ... )
    NetResponseEventManager:Get():AddListener(MsgID.RACE_FIFA_INFO_S2C_RES , self, self.RecvMsg_GetInfo)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_FIFA_SELECT_CHAMPION_S2C_RES , self, self.RecvMsg_SelectChampion)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_FIFA_SELECT_WINNER_S2C_RES , self, self.RecvMsg_SelectWinner)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_FIFA_GET_REWARD_S2C_RES , self, self.RecvMsg_GetReward)
end
function RaceFifaSubsystem:SendMsg_GetInfo(seasonId)
    local reqData=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),seasonId})
    NetManager:Get():Send(MsgID.RACE_FIFA_INFO_C2S_REQ,reqData)
end
function RaceFifaSubsystem:SendMsg_SelectChampion(seasonId,id,cost)
    local reqData=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),seasonId,id,cost})
    NetManager:Get():Send(MsgID.RACE_FIFA_SELECT_CHAMPION_C2S_REQ,reqData)
end
function RaceFifaSubsystem:SendMsg_SelectWinner(seasonId,id,result,cost)
    local reqData=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),seasonId,id,result,cost})
    NetManager:Get():Send(MsgID.RACE_FIFA_SELECT_WINNER_C2S_REQ,reqData)
end
function RaceFifaSubsystem:SendMsg_GetReward(seasonId,id)
    local reqData=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),seasonId,id})
    NetManager:Get():Send(MsgID.RACE_FIFA_GET_REWARD_C2S_REQ,reqData)
end


function RaceFifaSubsystem:RecvMsg_GetInfo(data)
    ---@type SC_RetFifaInfo
    local msg = assert(Dll_PB.decode("RetFifaInfo", data))
    print(ProtoMsgHelp.block(msg))
    local flag= CommonHelper:ShowGetRewardDataBySomeDown(msg.curdown)
    RaceFifaDataManager:Get():Init(msg,flag)
end
function RaceFifaSubsystem:RecvMsg_SelectChampion(data)
    ---@type SC_RetFifaInfo
    local msg = assert(Dll_PB.decode("RetFifaInfo", data))
    print(ProtoMsgHelp.block(msg))
end
function RaceFifaSubsystem:RecvMsg_SelectWinner(data)
    ---@type SC_RetFifaInfo
    local msg = assert(Dll_PB.decode("RetFifaInfo", data))
    print(ProtoMsgHelp.block(msg))
end
function RaceFifaSubsystem:RecvMsg_GetReward(data)
    ---@type SC_RetFifaInfo
    local msg = assert(Dll_PB.decode("RetFifaInfo", data))
    print(ProtoMsgHelp.block(msg))
end

local __subsystem= RaceFifaSubsystem()
function RaceFifaSubsystem:Get() return __subsystem end
return __subsystem
