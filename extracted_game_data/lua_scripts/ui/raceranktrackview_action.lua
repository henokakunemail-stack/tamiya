---@class RaceRankTrackViewAction:ViewBaseAction
RaceRankTrackViewAction = class("RaceRankTrackViewAction",ViewBaseAction)

function RaceRankTrackViewAction:initialize()
    ViewBaseAction.initialize(self)
end
function RaceRankTrackViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceRankSelectTrack_SetData, self.SetData)
end

---@return RaceRankTrackView
function RaceRankTrackViewAction:View()
    return self.view
end
function RaceRankTrackViewAction:SetData()
    if self:View() then
        self:View():SetData()
    end
end

return RaceRankTrackViewAction()