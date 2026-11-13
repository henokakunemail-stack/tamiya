
---@class  PveChapterListViewAction:ViewBaseAction
PveChapterListViewAction = class("PveChapterListViewAction",ViewBaseAction)

function PveChapterListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function PveChapterListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.PveChapterListView_SetLevelList, self.SetLevelList)
    self:AddNotificationEvent(UINotifyEvent.PVEChapterListView_Refresh, self.RefreshLevelList)
    self:AddNotificationEvent(UINotifyEvent.PVEChapterListView_UpdateBox, self.SetBoxState)
    self:AddNotificationEvent(UINotifyEvent.PVEChapterListView_SetViewInfo, self.SetViewInfo)
end



---@return  PveChapterListView
function PveChapterListViewAction:View()
    return self.view
end

function PveChapterListViewAction:SetLevelList(id)
    if self:View() then
        self:View():SetData(id)
    end
end
function PveChapterListViewAction:RefreshLevelList()
    if self:View() then
        self:View():RefreshLevelList()
    end
end

function PveChapterListViewAction:SetBoxState()
    if self:View() then
        self:View():SetBoxState()
    end
end
function PveChapterListViewAction:SetViewInfo(data)
    if self:View() then
        self:View():SetLuaViewInfo(data[1],data[2])
    end
end


return PveChapterListViewAction()