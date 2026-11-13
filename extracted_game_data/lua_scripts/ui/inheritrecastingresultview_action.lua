---@class InheritRecastingResultViewAction:ViewBaseAction
InheritRecastingResultViewAction = class("InheritRecastingResultViewAction",ViewBaseAction)

function InheritRecastingResultViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function InheritRecastingResultViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.InheritRecastingResultView_SetData, self.SetData)
end

---@return InheritRecastingResultView
function InheritRecastingResultViewAction:View()
    return self.view
end

function InheritRecastingResultViewAction:SetData(node)
    if self:View() then
        self:View():SetData(node[1], node[2], node[3])
    end
end

return InheritRecastingResultViewAction()