---@class RaceRankRankingListRewardViewAction:ViewBaseAction
RaceRankRankingListRewardViewAction = class("RaceRankRankingListRewardViewAction",ViewBaseAction)

function RaceRankRankingListRewardViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceRankRankingListRewardViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceRankRankListRewardView_SetData, self.SetData)
end

---@return RaceRankRankingListRewardView
function RaceRankRankingListRewardViewAction:View()
    return self.view
end
function RaceRankRankingListRewardViewAction:SetData(type)
    self:View():SetData(type)
end


return RaceRankRankingListRewardViewAction()