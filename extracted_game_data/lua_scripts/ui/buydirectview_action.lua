---@class BuyDirectViewAction:ViewBaseAction
BuyDirectViewAction = class("BuyDirectViewAction", ViewBaseAction)

function BuyDirectViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function BuyDirectViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.BuyDirectViewSetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.BuyDirectViewRefresh, self.Refresh)
end

---@return BuyDirectView
function BuyDirectViewAction:View()
    return self.view
end

function BuyDirectViewAction:SetData(date)
    if self:View() then
        self:View():SetData(date[1],date[2],date[3])
    end
end

function BuyDirectViewAction:SetStaminaData(date)
    if self:View() then
        self:View():SetStaminaData(date)
    end
end

function BuyDirectViewAction:Refresh()
    if self:View() then
        self:View():Refresh()
    end
end

return BuyDirectViewAction()