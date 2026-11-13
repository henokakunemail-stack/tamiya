---@class RankingListSubsystem
RankingListSubsystem = class("RankingListSubsystem")

function RankingListSubsystem:initialize( ... )
    NetResponseEventManager:Get():AddListener(MsgID.GET_RANK_LIST_S2C_RES , self, self.RecMsg_RankingListInfo)
    NetResponseEventManager:Get():AddListener(MsgID.GET_USE_CAR_DATA_S2C_REQ , self, self.RecMsg_ShowUserCar)
end

function RankingListSubsystem:SendMsg_RankingListInfo(type,group)
    local reqBytes=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),type,group})
    NetManager:Get():Send(MsgID.GET_RANK_LIST_C2S_REQ, reqBytes)
end
function RankingListSubsystem:SendMsg_GetUserCar(id,trackId,type)
    local reqBytes=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id,trackId,type})
    NetManager:Get():Send(MsgID.GET_USE_CAR_DATA_C2S_REQ, reqBytes)
end

function RankingListSubsystem:RecMsg_RankingListInfo(data)
    local msg = assert(Dll_PB.decode("RetRank", data))
    print(ProtoMsgHelp.block(msg))
    RankingListDataManager:Get():Init(msg)
end
function RankingListSubsystem:RecMsg_ShowUserCar(data)
    local msg = assert(Dll_PB.decode("RetRankCar", data))
    print(ProtoMsgHelp.block(msg))
    UINotify:Get():SendNotification(UINotifyEvent.MainRankingListView_SetCar,msg)
end

local __subsystem = RankingListSubsystem()
function RankingListSubsystem:Get() return __subsystem end
return __subsystem