---@class RankingListViewAction:ViewBaseAction
RankingListViewAction = class("RankingListViewAction",ViewBaseAction)

function RankingListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RankingListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RankListView_SetData, self.SetData)
end

---@return RankingListView
function RankingListViewAction:View()
    return self.view
end

function RankingListViewAction:SetData(type)
    if self:View() then
        self:View():SetData(type)
    end
end

return RankingListViewAction()