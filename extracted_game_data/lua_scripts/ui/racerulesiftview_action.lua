


---@class RaceRuleSiftViewAction:ViewBaseAction
RaceRuleSiftViewAction = class("RaceRuleSiftViewAction",ViewBaseAction)

function RaceRuleSiftViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceRuleSiftViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceRuleSiftView_SetData, self.SetData)
end

---@return RaceRuleSiftView
function RaceRuleSiftViewAction:View()
    return self.view
end

function RaceRuleSiftViewAction:SetData(param)
    if self:View() then
        self:View():SetData(param)
    end
end

return RaceRuleSiftViewAction()