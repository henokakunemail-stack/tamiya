
---@class KnapsackViewAction:ViewBaseAction
KnapsackViewAction = class("KnapsackViewAction",ViewBaseAction)

function KnapsackViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function KnapsackViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.KnapsackView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.KnapsackView_UpdateScrollView, self.UpdateScrollView)
    self:AddNotificationEvent(UINotifyEvent.KnapsackView_RefreshData, self.RefreshData)
    self:AddNotificationEvent(UINotifyEvent.KnapsackView_UpdateTogView, self.UpdateTogView)
    self:AddNotificationEvent(UINotifyEvent.KnapsackView_ClickTog, self.ClickTog)
end

---@return KnapsackView
function KnapsackViewAction:View()
    return self.view
end

function KnapsackViewAction:SetData(type)
    if self:View() then
        self:View():SetData(type)
    end
end

function KnapsackViewAction:UpdateScrollView(node)
    if self:View() then
        self:View():UpdateScrollView(node[1], node[2], node[3])
    end
end

function KnapsackViewAction:RefreshData()
    if self:View() then
        self:View():RefreshData()
    end
end

function KnapsackViewAction:UpdateTogView(node)
    if self:View() then
        self:View():UpdateToggleView(node[1], node[2], node[3])
    end
end

function KnapsackViewAction:ClickTog(type)
    if self:View() then
        self:View():OnClickTog_Type(type)
    end
end

return KnapsackViewAction()