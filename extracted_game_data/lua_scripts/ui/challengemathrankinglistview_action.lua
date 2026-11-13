---@class ChallengeMathRankingListViewAction:ViewBaseAction
ChallengeMathRankingListViewAction = class("ChallengeMathRankingListViewAction",ViewBaseAction)

function ChallengeMathRankingListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ChallengeMathRankingListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ChallengeMathRankingListView_SetData, self.SetData)
end

---@return ChallengeMathRankingListView
function ChallengeMathRankingListViewAction:View()
    return self.view
end

function ChallengeMathRankingListViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data)
    end
end

return ChallengeMathRankingListViewAction()