
---@class ClubTaskViewAction:ViewBaseAction
ClubTaskViewAction = class("ClubTaskViewAction",ViewBaseAction)

function ClubTaskViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return ClubTaskView
function ClubTaskViewAction:View()
    return self.view
end
function  ClubTaskViewAction:OnRegisterEvents()
    log("----ClubTaskView注册事件---------------")
    self:AddNotificationEvent(UINotifyEvent.RefreshCurView,self.RefreshCurView)
    self:AddNotificationEvent(UINotifyEvent.ClubTaskView_SetData,self.SetData)
end
function ClubTaskViewAction:SetData(data)
    if self:View() then
        self:View():TaskViewSetData(data)
    end
end
function ClubTaskViewAction:RefreshCurView()
    if self:View() then
        self:View():RefreshCurView()
    end
end
return ClubTaskViewAction()