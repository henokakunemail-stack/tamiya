---@class PveChapterRankListViewAction:ViewBaseAction
PveChapterRankListViewAction = class("PveChapterRankListViewAction",ViewBaseAction)

function PveChapterRankListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function PveChapterRankListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.PVEChapterRankListView_SetData, self.SetData)
end

---@return PveChapterRankListView
function PveChapterRankListViewAction:View()
    return self.view
end

function PveChapterRankListViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data)
    end
end

return PveChapterRankListViewAction()