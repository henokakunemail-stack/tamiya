---@class RaceTrotRankRewardViewAction:ViewBaseAction
RaceTrotRankRewardViewAction = class("RaceTrotRankRewardViewAction",ViewBaseAction)

function RaceTrotRankRewardViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceTrotRankRewardViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RankTrotRankReward_SetData, self.SetData)
end

---@return RaceTrotRankRewardView
function RaceTrotRankRewardViewAction:View()
    return self.view
end

function RaceTrotRankRewardViewAction:SetData()
    if self:View() then
        self:View():SetData()
    end
end

return RaceTrotRankRewardViewAction()