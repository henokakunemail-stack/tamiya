---@class RankingListRewardViewAction:ViewBaseAction
RankingListRewardViewAction = class("RankingListRewardViewAction",ViewBaseAction)

function RankingListRewardViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RankingListRewardViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RankListRewardView_SetData, self.SetData)
end

---@return RankingListRewardView
function RankingListRewardViewAction:View()
    return self.view
end
function RankingListRewardViewAction:SetData(type)
    self:View():SetData(type)
end


return RankingListRewardViewAction()