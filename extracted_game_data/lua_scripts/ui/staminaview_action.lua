
---@class StaminaViewAction:ViewBaseAction
StaminaViewAction = class("StaminaViewAction",ViewBaseAction)

function StaminaViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return StaminaView
function StaminaViewAction:View()
    return self.view
end
function StaminaViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.StaminaView_UpdateData, self.UpdateData)
end


function StaminaViewAction:UpdateData(isBuyStamina)
    if self:View() then
        self:View():UpdateData(isBuyStamina)
    end
end
return StaminaViewAction()