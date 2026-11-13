---@class ChallengeMathRankingListRewardViewAction:ViewBaseAction
ChallengeMathRankingListRewardViewAction = class("ChallengeMathRankingListRewardViewAction",ViewBaseAction)

function ChallengeMathRankingListRewardViewAction:initialize()
ViewBaseAction.initialize(self)
end

function ChallengeMathRankingListRewardViewAction:OnRegisterEvents()

end

---@return ChallengeMathRankingListRewardView
function ChallengeMathRankingListRewardViewAction:View()
  return self.view
end
function ChallengeMathRankingListRewardViewAction:SetData()
  self:View():SetData()
end


return ChallengeMathRankingListRewardViewAction()