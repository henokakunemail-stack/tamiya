


---@class ClubRaceSelfLevelViewAction:ViewBaseAction
ClubRaceSelfLevelViewAction = class("ClubRaceSelfLevelViewAction",ViewBaseAction)

function ClubRaceSelfLevelViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ClubRaceSelfLevelViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ClubRaceSelfLevelViewSetJoin, self.SetJoin)
    self:AddNotificationEvent(UINotifyEvent.ClubRaceSelfLevelViewSetAll, self.SetAll)
    self:AddNotificationEvent(UINotifyEvent.ClubRaceSelfLevelViewSetDetail, self.SetDetail)
end
function ClubRaceSelfLevelViewAction:SetJoin()

    self:View():UpdateTog(2)

end
function ClubRaceSelfLevelViewAction:SetAll()
    self:View():UpdateTog(1)
end

function ClubRaceSelfLevelViewAction:SetDetail(data)
    self:View():SetDetail(data)
end
---@return ClubRaceSelfLevelView
function ClubRaceSelfLevelViewAction:View()
    return self.view
end

return ClubRaceSelfLevelViewAction()