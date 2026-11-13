
---@class TopInfoViewAction:ViewBaseAction
TopInfoViewAction = class("TopInfoViewAction",ViewBaseAction)

function TopInfoViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function TopInfoViewAction:OnRegisterEvents()

    self:AddNotificationEvent(UINotifyEvent.Msg_PlayerCurrency,self.SetCurrencyData)
    self:AddNotificationEvent(UINotifyEvent.Msg_PlayerStamina,self.SetStamina)
    self:AddNotificationEvent(UINotifyEvent.Msg_SetFriendShip,self.SetFriendShip)
    self:AddNotificationEvent(UINotifyEvent.Msg_CloseUI,self.CloseUI)
    --self:AddNotificationEvent(UINotifyEvent.StaminaView_UpdateData,self.SetStamina) --体力恢复刷新
end

---@return TopInfoView
function TopInfoViewAction:View()
    return self.view
end

function TopInfoViewAction:SetCurrencyData()
    if self:View() then
        self:View():SetCurrencyData()
    end
end
function TopInfoViewAction:SetStamina()
    if self:View() then
        self:View():SetStamina()
    end
end
function TopInfoViewAction:CloseUI(flag)
    if self:View() then
        self:View():CloseAllUI(flag)
    end
end

function TopInfoViewAction:SetFriendShip(data)
    if self:View() then
        self:View():SetFriendShip(data[1],data[2])
    end
end

return TopInfoViewAction()