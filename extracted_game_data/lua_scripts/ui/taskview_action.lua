
---@class TaskViewAction:ViewBaseAction
TaskViewAction = class("TaskViewAction",ViewBaseAction)

function TaskViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@return TaskView
function TaskViewAction:View()
    return self.view
end

function  TaskViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.TaskViewSetData,self.SetData)
    self:AddNotificationEvent(UINotifyEvent.RefreshCurView,self.RefreshCurView)
    self:AddNotificationEvent(UINotifyEvent.RefreshNoviceView,self.RefreshNoviceView)
end

function TaskViewAction:SetData(data)
    if self:View() then
        self:View():TaskViewSetData(data)
    end
end

function TaskViewAction:RefreshCurView()
    if self:View() then
        self:View():RefreshCurView()
    end
end

function TaskViewAction:RefreshNoviceView()
    if self:View() then
        self:View():RefreshNoviceView()
    end
end

return TaskViewAction()