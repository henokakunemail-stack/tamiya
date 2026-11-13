---@class ActivityFirstBuyViewAction:ViewBaseAction
ActivityFirstBuyViewAction = class("ActivityFirstBuyViewAction", ViewBaseAction)

function ActivityFirstBuyViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return ActivityFirstBuyView
function ActivityFirstBuyViewAction:View()
    return self.view
end

function ActivityFirstBuyViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ActivityFirstBuyView_InitViewInfo, self.InitViewInfo)
end

function ActivityFirstBuyViewAction:InitViewInfo(ref)
    if self:View() then
        self:View():InitViewInfo(ref)
    end
end

return ActivityFirstBuyViewAction()