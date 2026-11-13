


---@class ReformStrongResultViewAction:ViewBaseAction
ReformStrongResultViewAction = class("ReformStrongResultViewAction",ViewBaseAction)

function ReformStrongResultViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ReformStrongResultViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.PartUpSucceedView_SetData, self.SetData)
end

---@return ReformStrongResultView
function ReformStrongResultViewAction:View()
    return self.view
end

function ReformStrongResultViewAction:SetData(node)
    if self:View() then
        self:View():SetData(node[1], node[2], node[3])
    end
end

return ReformStrongResultViewAction()