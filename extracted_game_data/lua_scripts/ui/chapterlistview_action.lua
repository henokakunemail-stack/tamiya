
---@class ChapterListViewAction:ViewBaseAction
ChapterListViewAction = class("ChapterListViewAction",ViewBaseAction)

function ChapterListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ChapterListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ChapterListView_SetLevelList, self.SetLevelList)
    self:AddNotificationEvent(UINotifyEvent.ChapterListView_UpdateBox, self.SetBoxState)
end



---@return ChapterListView
function ChapterListViewAction:View()
    return self.view
end

function ChapterListViewAction:SetLevelList(id)
    if self:View() then
        self:View():SetData(id)
    end
end

function ChapterListViewAction:SetBoxState()
    if self:View() then
        self:View():SetBoxState()
    end
end


return ChapterListViewAction()