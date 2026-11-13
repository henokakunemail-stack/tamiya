---@class RaceTrotSelectTrackViewAction:ViewBaseAction
RaceTrotSelectTrackViewAction = class("RaceTrotSelectTrackViewAction",ViewBaseAction)

function RaceTrotSelectTrackViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceTrotSelectTrackViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RankTrotSelectTrack_SetData, self.SetData)
end

---@return RaceTrotSelectTrackView
function RaceTrotSelectTrackViewAction:View()
    return self.view
end

function RaceTrotSelectTrackViewAction:SetData(isRefresh)
    if self:View() then
        self:View():SetData(isRefresh)
    end
end

return RaceTrotSelectTrackViewAction()