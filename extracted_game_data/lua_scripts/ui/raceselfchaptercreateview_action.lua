


---@class RaceSelfChapterCreateViewAction:ViewBaseAction
RaceSelfChapterCreateViewAction = class("RaceSelfChapterCreateViewAction",ViewBaseAction)

function RaceSelfChapterCreateViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSelfChapterCreateViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceSelfChapterViewSetTickets, self.SetTickets)
end

---@return RaceSelfChapterCreateView
function RaceSelfChapterCreateViewAction:View()
    return self.view
end

function RaceSelfChapterCreateViewAction:SetTickets()
   self:View():SetLevels()
end


return RaceSelfChapterCreateViewAction()