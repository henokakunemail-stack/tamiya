


---@class ClubRaceSelfChapterCreateViewAction:ViewBaseAction
ClubRaceSelfChapterCreateViewAction = class("ClubRaceSelfChapterCreateViewAction",ViewBaseAction)

function ClubRaceSelfChapterCreateViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ClubRaceSelfChapterCreateViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ClubRaceSelfChapterViewSetTickets, self.SetTickets)
end

---@return ClubRaceSelfChapterCreateView
function ClubRaceSelfChapterCreateViewAction:View()
    return self.view
end

function ClubRaceSelfChapterCreateViewAction:SetTickets()
   self:View():SetLevels()
end


return ClubRaceSelfChapterCreateViewAction()