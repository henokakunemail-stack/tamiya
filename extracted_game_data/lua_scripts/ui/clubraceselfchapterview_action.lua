


---@class ClubRaceSelfChapterViewAction:ViewBaseAction
ClubRaceSelfChapterViewAction = class("ClubRaceSelfChapterViewAction",ViewBaseAction)

function ClubRaceSelfChapterViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ClubRaceSelfChapterViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ClubRaceSelfChapterViewSetJoin, self.SetJoin)
    self:AddNotificationEvent(UINotifyEvent.ClubRaceSelfChapterViewSetAll, self.SetAll)
end

---@return ClubRaceSelfChapterView
function ClubRaceSelfChapterViewAction:View()
    return self.view
end
function ClubRaceSelfChapterViewAction:SetJoin()

    self.view:UpdateTog(2)

end
function ClubRaceSelfChapterViewAction:SetAll()
    self.view:UpdateTog(1)
end
return ClubRaceSelfChapterViewAction()