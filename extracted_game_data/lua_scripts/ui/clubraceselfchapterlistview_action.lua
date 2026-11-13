


---@class ClubRaceSelfChapterListViewAction:ViewBaseAction
ClubRaceSelfChapterListViewAction = class("ClubRaceSelfChapterListViewAction",ViewBaseAction)

function ClubRaceSelfChapterListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ClubRaceSelfChapterListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ClubRaceSelfChapterListView_SetLevelList, self.SetLevelList)
end

---@return ClubRaceSelfChapterListView
function ClubRaceSelfChapterListViewAction:View()
    return self.view
end
function ClubRaceSelfChapterListViewAction:SetLevelList()
    if self:View() then
        self:View():SetData()
    end
end

return ClubRaceSelfChapterListViewAction()