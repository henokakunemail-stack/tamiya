---@class StrengthSprintActViewAction:ViewBaseAction
StrengthSprintActViewAction = class("StrengthSprintActViewAction", ViewBaseAction)

function StrengthSprintActViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return StrengthSprintActView
function StrengthSprintActViewAction:View()
    return self.view
end

function StrengthSprintActViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.StrengthSprint_RefreshData,self.Refresh)
    self:AddNotificationEvent(UINotifyEvent.StrengthSprint_OpenActivity,self.OpenActivity)
end

function StrengthSprintActViewAction:Refresh(data)
    if self:View() then
        self:View():Refresh()
    end
end
function StrengthSprintActViewAction:OpenActivity(data)
    if self:View() then
        self:View():OpenCurActivityView()
    end
end


return StrengthSprintActViewAction()