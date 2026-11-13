---@class GoodsInfoViewAction:ViewBaseAction
GoodsInfoViewAction = class("GoodsInfoViewAction",ViewBaseAction)

function GoodsInfoViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function GoodsInfoViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SetGoodsInfoView, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.SetBuyNum, self.SetBuyNum)
end
---@return GoodsInfoView
function GoodsInfoViewAction:View()
    return self.view
end
function GoodsInfoViewAction:SetData(index)
    self:View():SetData(index)
end
function GoodsInfoViewAction:BuyGoodSuccess()
    self:View():BuyDone()
end
function GoodsInfoViewAction:SetBuyNum(value)
    if value==nil then
        value=true
    end
    self:View():SetBuyNum(value)
end
return GoodsInfoViewAction()
