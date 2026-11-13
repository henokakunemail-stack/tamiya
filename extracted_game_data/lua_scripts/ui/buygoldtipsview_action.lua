---@class BuyGoldTipsAction:ViewBaseAction
BuyGoldTipsAction = class("BuyGoldTipsAction", ViewBaseAction)

function BuyGoldTipsAction:initialize()
    ViewBaseAction.initialize(self)
end

function BuyGoldTipsAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ShowBuyGoldTips_Center, self.ShowTips)
end

---@return BuyGoldTipsView
function BuyGoldTipsAction:View()
    return self.view
end

function BuyGoldTipsAction:ShowTips()
    self:View():ShowTips()
end

return BuyGoldTipsAction()