---@class BuyGoldViewAction:ViewBaseAction
BuyGoldViewAction = class("BuyGoldViewAction", ViewBaseAction)

function BuyGoldViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return BuyGoldView
function BuyGoldViewAction:View()
    return self.view
end
function BuyGoldViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.UpdateBuyGoldView, self.UpdateBuyGoldView)
end

function BuyGoldViewAction:UpdateBuyGoldView()
    if self:View() then
        self:View():UpdateBuyGoldView()
    end
end

return BuyGoldViewAction()