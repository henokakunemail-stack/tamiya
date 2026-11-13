
---@class CostUseInfoViewAction:ViewBaseAction
CostUseInfoViewAction = class("CostUseInfoViewAction",ViewBaseAction)

function CostUseInfoViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function CostUseInfoViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.CostUseViewSetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.CostUseViewRefresh, self.Refresh)
end
---@return CostUseInfoView
function CostUseInfoViewAction:View()
    return self.view
end

function CostUseInfoViewAction:SetData(date)
    if self:View() then
        self:View():SetData(date)
    end
end
function CostUseInfoViewAction:Refresh(date)
    if self:View() then
        self:View():Refresh()
    end
end

return CostUseInfoViewAction()