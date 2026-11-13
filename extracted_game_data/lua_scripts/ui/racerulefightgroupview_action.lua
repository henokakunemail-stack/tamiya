


---@class RaceRuleFightGroupViewAction:ViewBaseAction
RaceRuleFightGroupViewAction = class("RaceRuleFightGroupViewAction",ViewBaseAction)

function RaceRuleFightGroupViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceRuleFightGroupViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceRuleFightGroupView_SetData, self.SetData)
end

---@return RaceRuleFightGroupView
function RaceRuleFightGroupViewAction:View()
    return self.view
end

function RaceRuleFightGroupViewAction:SetData(param)
    if self:View() then
        self:View():SetData(param)
    end
end

return RaceRuleFightGroupViewAction()