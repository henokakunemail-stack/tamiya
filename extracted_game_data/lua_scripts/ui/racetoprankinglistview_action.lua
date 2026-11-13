
---@class RaceTopRankingListViewAction:ViewBaseAction
RaceTopRankingListViewAction = class("RaceTopRankingListViewAction",ViewBaseAction)

function RaceTopRankingListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceTopRankingListViewAction:OnRegisterEvents()

end

---@return RaceTopRankingListView
function RaceTopRankingListViewAction:View()
    return self.view
end

return RaceTopRankingListViewAction()