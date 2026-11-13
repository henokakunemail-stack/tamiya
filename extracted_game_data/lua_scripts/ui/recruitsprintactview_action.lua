---@class RecruitSprintActViewAction:ViewBaseAction
RecruitSprintActViewAction = class("RecruitSprintActViewAction", ViewBaseAction)

function RecruitSprintActViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return RecruitSprintActView
function RecruitSprintActViewAction:View()
    return self.view
end

function RecruitSprintActViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RecruitSprint_Refresh,self.Refresh)
end

function RecruitSprintActViewAction:Refresh()
    if self:View() then
        self:View():Refresh()
    end
end


return RecruitSprintActViewAction()