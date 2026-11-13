


---@class CommonInputViewAction:ViewBaseAction
CommonInputViewAction = class("CommonInputViewAction",ViewBaseAction)

function CommonInputViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function CommonInputViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.CommonInputView_SetData, self.SetData)
end

---@return CommonInputView
function CommonInputViewAction:View()
    return self.view
end

function CommonInputViewAction:SetData(param)
    if self:View() then
        self:View():SetData(param)
    end
end

return CommonInputViewAction()