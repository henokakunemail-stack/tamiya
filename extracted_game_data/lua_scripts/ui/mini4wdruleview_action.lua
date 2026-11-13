
---@class Mini4wdRuleViewAction:ViewBaseAction
Mini4wdRuleViewAction = class("Mini4wdRuleViewAction",ViewBaseAction)

function Mini4wdRuleViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function Mini4wdRuleViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.Mini4wdRuleView_SetData, self.SetData)
end

---@return Mini4wdRuleView
function Mini4wdRuleViewAction:View()
    return self.view
end
function Mini4wdRuleViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data[1],data[2])
    end
end

return Mini4wdRuleViewAction()