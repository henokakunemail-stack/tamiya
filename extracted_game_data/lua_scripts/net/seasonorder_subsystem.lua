---@class SeasonOrderSubsystem
SeasonOrderSubsystem = class("SeasonOrderSubsystem")

function SeasonOrderSubsystem:initialize(...)
    NetResponseEventManager:Get():AddListener(MsgID.GET_SEASON_ORDER_S2C_REQ, self, self.RecvMsg_SeasonInfo)
    NetResponseEventManager:Get():AddListener(MsgID.GET_SEASON_ORDER_LEVEL_S2C_REQ, self, self.RecvMsg_SeasonLevel)
    NetResponseEventManager:Get():AddListener(MsgID.GET_SEASON_ORDER_GIFT_S2C_REQ, self, self.RecvMsg_SeasonGift)
end
function SeasonOrderSubsystem:RecvMsg_SeasonInfo(data)
    ---@type SC_ActToken
    local msg = assert(Dll_PB.decode("ActToken", data))
    print(ProtoMsgHelp.block(msg))
    if msg.tokenid==0 then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.SeasonOrderNoOpen))
        return
    end
    SeasonOrderDataManager:Get():SetTokenData(msg)

    if UIManager:Get():IsPopViewShow("SeasonOrderTaskView") then
        UINotify:Get():SendNotification(UINotifyEvent.SeasonOrderTaskView_SetData,{nil,false})
    else
        UINotify:Get():SendNotification(UINotifyEvent.FoundPassToggleView_SetToggle,{UserFoundType.SeasonOrder,{msg,true}})
    end
    --if UIManager:Get():IsPopViewShow("SeasonOrderTaskView") then
    --    UINotify:Get():SendNotification(UINotifyEvent.SeasonOrderTaskView_SetData,{nil,false})
    --else
    --    UINotify:Get():SendNotification(UINotifyEvent.FoundPassToggleView_SetToggle,{UserFoundType.SeasonOrder,{msg,true}})
    --end
end
function SeasonOrderSubsystem:RecvMsg_SeasonLevel(data)
    ---@type SC_BuyActToken
    local msg = assert(Dll_PB.decode("BuyActToken", data))
    print(ProtoMsgHelp.block(msg))
    UIManager:Get():ClosePopup()
    KnapsackDataManager:Get():UpdatePropByConsume(msg.payMoney)
    SeasonOrderDataManager:Get():SetTokenData(msg.alterActToken)
    UINotify:Get():SendNotification(UINotifyEvent.SeasonOrderView_SetData,{msg.alterActToken,false})
end
function SeasonOrderSubsystem:RecvMsg_SeasonGift(data)
    ---@type SC_GiftActToken
    local msg = assert(Dll_PB.decode("GiftActToken", data))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist)
    SeasonOrderDataManager:Get():SetTokenData(msg.alterActToken)
    UINotify:Get():SendNotification(UINotifyEvent.SeasonOrderView_SetData,{msg.alterActToken,false})
end
function SeasonOrderSubsystem:SendMsg_GetSeasonInfo()
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.GET_SEASON_ORDER_C2S_RES, data)
end
function SeasonOrderSubsystem:SendMsg_GetSeasonGift(id)
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id})
    NetManager:Get():Send(MsgID.GET_SEASON_ORDER_GIFT_C2S_RES, data)
end
function SeasonOrderSubsystem:SendMsg_GetSeasonLevel(id)
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id})
    NetManager:Get():Send(MsgID.GET_SEASON_ORDER_LEVEL_C2S_RES, data)
end
local __subsystem = SeasonOrderSubsystem()
function SeasonOrderSubsystem:Get()
    return __subsystem
end
return __subsystem