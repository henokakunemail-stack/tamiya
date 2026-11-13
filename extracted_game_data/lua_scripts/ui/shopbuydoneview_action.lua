---@class ShopBuyDoneViewAction:ViewBaseAction
ShopBuyDoneViewAction = class("ShopBuyDoneViewAction",ViewBaseAction)

function ShopBuyDoneViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ShopBuyDoneViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.BuyGoodSuccess, self.BuyGoodSuccess)
    self:AddNotificationEvent(UINotifyEvent.ShopBuyDoneOpen, self.SetData)
end
---@return ShopBuyDoneView
function ShopBuyDoneViewAction:View()
    return self.view
end

function ShopBuyDoneViewAction:BuyGoodSuccess(data)
    UIManager:Get():ShowPersistentView("BuyDoneView",CanvasType.MainCanvas,"ShopBuyDoneView")
    UINotify:Get():SendNotification(UINotifyEvent.ShopBuyDoneOpen,data)
end

function ShopBuyDoneViewAction:SetData(data)
    self:View():SetData(data)
end
return ShopBuyDoneViewAction()