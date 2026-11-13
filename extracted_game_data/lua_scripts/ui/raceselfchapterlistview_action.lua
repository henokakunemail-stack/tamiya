


---@class RaceSelfChapterListViewAction:ViewBaseAction
RaceSelfChapterListViewAction = class("RaceSelfChapterListViewAction",ViewBaseAction)

function RaceSelfChapterListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSelfChapterListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceSelfChapterListView_SetLevelList, self.SetLevelList)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfChapterListView_Refresh, self.Refresh)
end

---@return RaceSelfChapterListView
function RaceSelfChapterListViewAction:View()
    return self.view
end
function RaceSelfChapterListViewAction:SetLevelList(id)
    if self:View() then
        self:View():SetData(id)
    end
end
function RaceSelfChapterListViewAction:Refresh(id)
    if self:View() then
        self:View():Refresh()
    end
end

return RaceSelfChapterListViewAction()