
---@class RaceTopGroupViewAction:ViewBaseAction
RaceTopGroupViewAction = class("RaceTopGroupViewAction",ViewBaseAction)

function RaceTopGroupViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceTopGroupViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceTopGroup_SetData, self.SetData)
end

---@return RaceTopGroupView
function RaceTopGroupViewAction:View()
    return self.view
end
function RaceTopGroupViewAction:SetData(value)
    if self:View() then
        self:View():SetData(value)
    end
end


return RaceTopGroupViewAction()