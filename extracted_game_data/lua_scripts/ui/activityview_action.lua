---@class ActivityViewAction:ViewBaseAction
ActivityViewAction = class("ActivityViewAction", ViewBaseAction)

function ActivityViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return ActivityView
function ActivityViewAction:View()
    return self.view
end

function ActivityViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ActivityView_InitPageInfo, self.InitPageInfo)
    self:AddNotificationEvent(UINotifyEvent.ActivityView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.ActivityView_Refresh, self.Refresh)
    self:AddNotificationEvent(UINotifyEvent.ActivityView_RefreshChargeState, self.RefreshChargeState)
end


function ActivityViewAction:InitPageInfo(data)
    if self:View() then
        self:View():InitPageInfo(data[1],data[2])
    end
end

function ActivityViewAction:Refresh()
    if self:View() then
        self:View():RefreshCurList()
    end
end
function ActivityViewAction:SetData()
    if self:View() then
        self:View():SetData()
    end
end

function ActivityViewAction:RefreshChargeState()
    if self:View() then
        self:View():RefreshChargeState()
    end
end


return ActivityViewAction()