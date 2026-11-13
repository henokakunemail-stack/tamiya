---@class RaceClub3V3RewardViewAction:ViewBaseAction
RaceClub3V3RewardViewAction = class("RaceClub3V3RewardViewAction",ViewBaseAction)

function RaceClub3V3RewardViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceClub3V3RewardViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RefreshRaceClub3v3Reward, self.SetData)
end

---@return RaceClub3V3RewardView
function RaceClub3V3RewardViewAction:View()
    return self.view
end
function RaceClub3V3RewardViewAction:SetData()
    self:View():SetData()
end


return RaceClub3V3RewardViewAction()