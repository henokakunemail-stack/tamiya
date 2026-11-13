


---@class SuitWarningViewAction:ViewBaseAction
SuitWarningViewAction = class("SuitWarningViewAction",ViewBaseAction)

function SuitWarningViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function SuitWarningViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SuitWarningView_SetData, self.SetData)
end

---@return SuitWarningView
function SuitWarningViewAction:View()
    return self.view
end

function SuitWarningViewAction:SetData(param)
    if self:View() then
        self:View():SetData(param[1], param[2], param[3], param[4])
    end
end

return SuitWarningViewAction()