
---@class NewPlayerChapterListViewAction:ViewBaseAction
NewPlayerChapterListViewAction = class("NewPlayerChapterListViewAction",ViewBaseAction)

function NewPlayerChapterListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function NewPlayerChapterListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.NewBieChapterListView_SetLevelList, self.SetLevelList)
    self:AddNotificationEvent(UINotifyEvent.NewBieChapterListView_Refresh, self.RefreshLevelList)
    self:AddNotificationEvent(UINotifyEvent.NewBieChapterListView_UpdateBox, self.SetBoxState)
    self:AddNotificationEvent(UINotifyEvent.NewBieChapterListView_SetViewInfo, self.SetViewInfo)

end
function NewPlayerChapterListViewAction:SetLevelList(id)
    if self:View() then
        self:View():SetData(id)
    end
end
function NewPlayerChapterListViewAction:RefreshLevelList()
    if self:View() then
        self:View():RefreshLevelList()
    end
end

function NewPlayerChapterListViewAction:SetBoxState()
    if self:View() then
        self:View():SetBoxState()
    end
end
function NewPlayerChapterListViewAction:SetViewInfo(data)
    if self:View() then
        self:View():SetLuaViewInfo(data[1],data[2])
    end
end

---@return NewPlayerChapterListView
function NewPlayerChapterListViewAction:View()
    return self.view
end
return NewPlayerChapterListViewAction()