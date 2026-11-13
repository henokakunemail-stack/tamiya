---@class RaceAssembleRankingListViewAction:ViewBaseAction
RaceAssembleRankingListViewAction = class("RaceAssembleRankingListViewAction",ViewBaseAction)

function RaceAssembleRankingListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceAssembleRankingListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceAssembleRankingListView_SetData, self.SetData)
end

---@return RaceAssembleRankingListView
function RaceAssembleRankingListViewAction:View()
    return self.view
end

function RaceAssembleRankingListViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data)
    end
end

return RaceAssembleRankingListViewAction()