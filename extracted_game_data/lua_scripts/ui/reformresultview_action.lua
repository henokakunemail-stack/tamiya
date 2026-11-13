


---@class ReformResultViewAction:ViewBaseAction
ReformResultViewAction = class("ReformResultViewAction",ViewBaseAction)

function ReformResultViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ReformResultViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ReformSucceedView_SetData, self.SetData)
end

---@return ReformResultView
function ReformResultViewAction:View()
    return self.view
end

function ReformResultViewAction:SetData(node)
    if self:View() then
        self:View():SetData(node[1], node[2], node[3], node[4], node[5])
    end
end

return ReformResultViewAction()