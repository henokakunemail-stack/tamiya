
---@class RaceSuperBattleBanTrackViewAction:ViewBaseAction
RaceSuperBattleBanTrackViewAction = class("RaceSuperBattleBanTrackViewAction",ViewBaseAction)

function RaceSuperBattleBanTrackViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSuperBattleBanTrackViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceSuperBattleBanTrack_SetData, self.SetData)
end

---@return RaceSuperBattleBanTrackView
function RaceSuperBattleBanTrackViewAction:View()
    return self.view
end
function RaceSuperBattleBanTrackViewAction:SetData()
    self:View():SetData()
end

return RaceSuperBattleBanTrackViewAction()