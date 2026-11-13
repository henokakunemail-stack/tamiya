---@class RaceSelfChapterTaskViewAction:ViewBaseAction
RaceSelfChapterTaskViewAction = class("RaceSelfChapterTaskViewAction",ViewBaseAction)

function RaceSelfChapterTaskViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSelfChapterTaskViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceSelfChapterTaskView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfChapterTaskView_Refresh, self.Refresh)
end

---@return RaceSelfChapterTaskView
function RaceSelfChapterTaskViewAction:View()
    return self.view
end
function RaceSelfChapterTaskViewAction:SetData(data)
    self:View():SetData(data)
end
function RaceSelfChapterTaskViewAction:Refresh()
    self:View():Refresh()
end


return RaceSelfChapterTaskViewAction()