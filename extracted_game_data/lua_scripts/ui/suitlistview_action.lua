


---@class SuitListViewAction:ViewBaseAction
SuitListViewAction = class("SuitListViewAction",ViewBaseAction)

function SuitListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function SuitListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SuitListView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.SuitListView_SetMsgData, self.SetMsgData)
    self:AddNotificationEvent(UINotifyEvent.SuitListView_RefreshScroll, self.RefreshScroll)

end

---@return SuitListView
function SuitListViewAction:View()
    return self.view
end

function SuitListViewAction:SetData(param)
    if self:View() then
        self:View():SetData(param)
    end
end

function SuitListViewAction:SetMsgData()
    if self:View() then
        self:View():SetMsgData()
    end
end

function SuitListViewAction:RefreshScroll()
    if self:View() then
        self:View():RefreshScroll()
    end
end



return SuitListViewAction()