


---@class BoxAwardHelpViewAction:ViewBaseAction
BoxAwardHelpViewAction = class("BoxAwardHelpViewAction",ViewBaseAction)

function BoxAwardHelpViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function BoxAwardHelpViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.WelfareBoxAwardHelp, self.SetData)
end

---@return HelpView
function BoxAwardHelpViewAction:View()
    return self.view
end

function BoxAwardHelpViewAction:SetData(param)
    if self:View() then
        self:View():SetData(param[1], param[2],param[3])
    end
end

return BoxAwardHelpViewAction()