---@class FoundSubsystem
FoundSubsystem = class("FoundSubsystem")
local ShowType=0
function FoundSubsystem:initialize( ... )
    NetResponseEventManager:Get():AddListener(MsgID.GET_FOUND_INFO_S2C_RES , self, self.RecvMsg_GetFoundInfo)
    NetResponseEventManager:Get():AddListener(MsgID.GET_FOUND_AWARD_S2C_RES , self, self.RecvMsg_GetFoundAward)
end

function FoundSubsystem:RecvMsg_GetFoundInfo(data)
    ---@type SC_UserPassFoundInfo
    local msg = assert(Dll_PB.decode("UserPassFoundInfo", data))
    print(ProtoMsgHelp.block(msg))
    FoundListManager:Get():Init(msg,ShowType)
    UINotify:Get():SendNotification(UINotifyEvent.FoundPassToggleView_SetToggle,{ShowType})

end

function FoundSubsystem:RecvMsg_GetFoundAward(data)
    ---@type SC_UserPassFoundInfo
    local msg = assert(Dll_PB.decode("UserPassFoundInfo", data))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:ShowGetRewardDataBySomeDown(msg.downProp[1], true)
    FoundListManager:Get():RefreshReward(msg.myPassFound)
end

function FoundSubsystem:SendMsg_GetFoundInfo(id)
    ShowType=id
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id})
    NetManager:Get():Send(MsgID.GET_FOUND_INFO_C2S_REQ, reqBytes)
end
function FoundSubsystem:SendMsg_GewFoundAward(id)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id})
    NetManager:Get():Send(MsgID.GET_FOUND_AWARD_C2S_REQ, reqBytes)
end

local __subsystem = FoundSubsystem()
function FoundSubsystem:Get() return __subsystem end
return __subsystem