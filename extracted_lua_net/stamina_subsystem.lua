---@class StaminaSystem
StaminaSubsystem = class("StaminaSystem")

function StaminaSubsystem:initialize(...)
    NetResponseEventManager:Get():AddListener(MsgID.GET_USE_DRUG_PWR_S2C_RES, self, self.RecvMsg_AddStamina)
    --NetResponseEventManager:Get():AddListener(MsgID.BUY_STAMINA_ARTICLE_G2C_RES, self, self.RecvMsg_BuyStaminaArticleCallBack)
    NetResponseEventManager:Get():AddListener(MsgID.GET_REBACK_PWR_S2C_RES, self, self.RecvMsg_RevertStamina)

end

---@param id number
---@param count number
function StaminaSubsystem:SendMsg_ReBackStamina()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.GET_REBACK_PWR_C2S_REQ, data)
end

----请求体力回复通知
function StaminaSubsystem:RecvMsg_RevertStamina(data)
    ---@type SC_UserReBackPow
    local msg = assert(Dll_PB.decode("UserReBackPow", data))
    print(ProtoMsgHelp.block(msg))

    print("msg.curtime + StaminaRecoverInterval",tonumber(msg.curtime) + 360,(msg.staminatime+360)) --体力恢复六分钟,下面获取参数了

    if msg.rebackFlag == 1 then

        if msg.drugCousume ~= nil then
            KnapsackDataManager:Get():UpdatePropByConsume(msg.drugCousume)
        end

        PlayerDataManager:Get():SetPlayerStaminaAndStaminaTime(msg.stamina, msg.staminatime)
        UINotify:Get():SendNotification(UINotifyEvent.Msg_PlayerStamina)
    end

end

----增加体力通知
function StaminaSubsystem:RecvMsg_AddStamina(data)
    ---@type SC_UserReBackPow
    local msg = assert(Dll_PB.decode("UserReBackPow", data))
    print(ProtoMsgHelp.block(msg))
    if msg.drugCousume ~= nil then
        KnapsackDataManager:Get():UpdatePropByConsume(msg.drugCousume)
    end
    PlayerDataManager:Get():SetPlayerStaminaAndStaminaTime(msg.stamina, msg.staminatime)
    if UIManager:Get():IsPopViewShow("StaminaView") then
        UINotify:Get():SendNotification(UINotifyEvent.StaminaView_UpdateData, false)
    end
    UINotify:Get():SendNotification(UINotifyEvent.BagViewRefresh,false)
    UINotify:Get():SendNotification(UINotifyEvent.CostUseViewRefresh)
    UINotify:Get():SendNotification(UINotifyEvent.Msg_PlayerStamina)
end

---@param id number
---@param count number
function StaminaSubsystem:SendMsg_UseStamina(id, count)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), id, count })
    NetManager:Get():Send(MsgID.GET_USE_DRUG_PWR_C2S_REQ, data)
end

---购买体力道具通知
function StaminaSubsystem:RecvMsg_BuyStaminaArticleCallBack(data)
    local msg = assert(Dll_PB.decode("BuyStaminaRes", data))
    print(ProtoMsgHelp.block(msg))
    PlayerDataManager:Get():SetCurrency(CurrencyType.Diamond, msg.diamond)
    PlayerDataManager:Get():SetBuyStamina(msg.buyStamina)
    UINotify:Get():SendNotification(UINotifyEvent.StaminaView_UpdateData, true)
end

local __subsystem = StaminaSubsystem()
function StaminaSubsystem:Get()
    return __subsystem
end
return __subsystem