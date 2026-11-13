---@class RaceTrotRankListViewAction:ViewBaseAction
RaceTrotRankListViewAction = class("RaceTrotRankListViewAction",ViewBaseAction)

function RaceTrotRankListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceTrotRankListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RankTrotRankList_SetData, self.SetData)
end

---@return RaceTrotRankListView
function RaceTrotRankListViewAction:View()
    return self.view
end

function RaceTrotRankListViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data)
    end
end

return RaceTrotRankListViewAction()