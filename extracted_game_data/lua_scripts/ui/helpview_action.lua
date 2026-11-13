


---@class HelpViewAction:ViewBaseAction
HelpViewAction = class("HelpViewAction",ViewBaseAction)

function HelpViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function HelpViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.HelpView_SetData, self.SetData)
end

---@return HelpView
function HelpViewAction:View()
    return self.view
end

function HelpViewAction:SetData(param)
    if self:View() then
        self:View():SetData(param[1], param[2],param[3])
    end
end

return HelpViewAction()