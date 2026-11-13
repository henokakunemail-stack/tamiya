


---@class RaceRuleFightGroupListViewAction:ViewBaseAction
RaceRuleFightGroupListViewAction = class("RaceRuleFightGroupListViewAction",ViewBaseAction)

function RaceRuleFightGroupListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceRuleFightGroupListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceRuleFightGroupListView_SetData, self.SetData)
end

---@return RaceRuleFightGroupListView
function RaceRuleFightGroupListViewAction:View()
    return self.view
end

function RaceRuleFightGroupListViewAction:SetData(param)
    if self:View() then
        self:View():SetData(param)
    end
end

return RaceRuleFightGroupListViewAction()