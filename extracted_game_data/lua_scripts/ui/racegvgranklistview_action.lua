
---@class RaceGVGRankListViewAction:ViewBaseAction
RaceGVGRankListViewAction = class("RaceGVGRankListViewAction",ViewBaseAction)

function RaceGVGRankListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceGVGRankListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceGVGRankList_SetData, self.SetData)
end

---@return RaceGVGRankListView
function RaceGVGRankListViewAction:View()
    return self.view
end

function RaceGVGRankListViewAction:SetData()
    if self:View() then
        self:View():SetData()
    end
end

return RaceGVGRankListViewAction()