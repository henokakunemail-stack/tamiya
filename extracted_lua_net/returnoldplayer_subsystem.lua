---@class ReturnOldPlayerSubsystem
ReturnOldPlayerSubsystem = class("ReturnOldPlayerSubsystem")

function ReturnOldPlayerSubsystem:initialize(...)

    --264, --返回回归签到信息
    NetResponseEventManager:Get():AddListener(MsgID.RET_REBACK_SIGN_INFO, self, self.RecMsg_ReturnBackSignInfo)
    --266, --返回回归签到
    NetResponseEventManager:Get():AddListener(MsgID.RET_REBACK_SIGN, self, self.RecMsg_ReturnBackSign)


end

-- 263, --请求回归签到信息
function ReturnOldPlayerSubsystem:SendMsg_ReturnBackSignInfo()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.REQ_REBACK_SIGN_INFO, data)
end

--264, --返回回归签到信息
function ReturnOldPlayerSubsystem:RecMsg_ReturnBackSignInfo(data)
    ---@type SC_UserBackSign
    local msg = assert(Dll_PB.decode("UserBackSign", data))
    print(ProtoMsgHelp.block(msg))

    if not UIManager:Get():IsPopViewShow("ReturnOldPlayerView") then
        UIManager:Get():OpenPopup("ReturnOldPlayerView", CanvasType.MainCanvas, "ReturnOldPlayerView", true)
    end

    ReturnOldPlayerDataManager:Get():SetSignIfCharge(msg.ifbuy)
    ReturnOldPlayerDataManager:Get():SetSignGift(msg)
    UINotify:Get():SendNotification(UINotifyEvent.ReturnOldPlayer_SetSign)

end

-- 265, --请求回归签到P2=天数P3=0/1普通高级
function ReturnOldPlayerSubsystem:SendMsg_ReturnBackSign(dayNum, ifMoney)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), dayNum, ifMoney })
    NetManager:Get():Send(MsgID.REQ_REBACK_SIGN, data)
end

--266, --返回回归签到
function ReturnOldPlayerSubsystem:RecMsg_ReturnBackSign(data)
    ---@type SC_RebackSign
    local msg = assert(Dll_PB.decode("RebackSign", data))
    print(ProtoMsgHelp.block(msg))

    if msg.mySomeDown[1] ~= nil then
        CommonHelper:ShowGetRewardDataBySomeDown(msg.mySomeDown[1], true)
    end

    ReturnOldPlayerDataManager:Get():SetSignGift(msg.curSign)
    UINotify:Get():SendNotification(UINotifyEvent.ReturnOldPlayer_SetSign)
end


function ReturnOldPlayerSubsystem:Clear()

end

local __subsystem = ReturnOldPlayerSubsystem()

function ReturnOldPlayerSubsystem:Get()
    return __subsystem
end

return __subsystem

