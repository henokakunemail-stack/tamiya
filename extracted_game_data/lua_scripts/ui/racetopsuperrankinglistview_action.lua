
---@class RaceTopSuperRankingListViewAction:ViewBaseAction
RaceTopSuperRankingListViewAction = class("RaceTopSuperRankingListViewAction",ViewBaseAction)

function RaceTopSuperRankingListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceTopSuperRankingListViewAction:OnRegisterEvents()

end

---@return RaceTopSuperRankingListView
function RaceTopSuperRankingListViewAction:View()
    return self.view
end

return RaceTopSuperRankingListViewAction()