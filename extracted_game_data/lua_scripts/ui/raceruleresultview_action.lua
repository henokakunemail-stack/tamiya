


---@class RaceRuleResultViewAction:ViewBaseAction
RaceRuleResultViewAction = class("RaceRuleResultViewAction",ViewBaseAction)

function RaceRuleResultViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceRuleResultViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceRuleResultView_SetData, self.SetData)
end

---@return RaceRuleResultView
function RaceRuleResultViewAction:View()
    return self.view
end

function RaceRuleResultViewAction:SetData(param)
    if self:View() then
        self:View():SetData(param)
    end
end

return RaceRuleResultViewAction()