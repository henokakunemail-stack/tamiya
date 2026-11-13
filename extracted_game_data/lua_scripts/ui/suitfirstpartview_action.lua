


---@class SuitFirstPartViewAction:ViewBaseAction
SuitFirstPartViewAction = class("SuitFirstPartViewAction",ViewBaseAction)

function SuitFirstPartViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function SuitFirstPartViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SuitFirstPartView_SetData, self.SetData)
end

---@return SuitFirstPartView
function SuitFirstPartViewAction:View()
    return self.view
end

function SuitFirstPartViewAction:SetData(param)
    if self:View() then
        self:View():SetData(param)
    end
end

return SuitFirstPartViewAction()