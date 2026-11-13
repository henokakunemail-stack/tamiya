


---@class RaceSelfChapterViewAction:ViewBaseAction
RaceSelfChapterViewAction = class("RaceSelfChapterViewAction",ViewBaseAction)

function RaceSelfChapterViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSelfChapterViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceSelfChapterViewSetJoin, self.SetJoin)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfChapterViewSetData, self.SetData)
end

---@return RaceSelfChapterView
function RaceSelfChapterViewAction:View()
    return self.view
end
function RaceSelfChapterViewAction:SetJoin()
    self:View():UpdateTog(1)
end
function RaceSelfChapterViewAction:SetData()
    self:View():SetData()
end
return RaceSelfChapterViewAction()