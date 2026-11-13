---@class BuyGoldNotarizeAction:ViewBaseAction
BuyGoldNotarizeAction = class("BuyGoldNotarizeAction", ViewBaseAction)

function BuyGoldNotarizeAction:initialize()
    ViewBaseAction.initialize(self)
end

function BuyGoldNotarizeAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ShowBuyGoldNotarize_Center, self.UpdateBuyGoldNotarizeView)
end

---@return BuyGoldNotarizeView
function BuyGoldNotarizeAction:View()
    return self.view
end

function BuyGoldNotarizeAction:UpdateBuyGoldNotarizeView(param)
    self:View():UpdateBuyGoldNotarizeView(param)
end

return BuyGoldNotarizeAction()