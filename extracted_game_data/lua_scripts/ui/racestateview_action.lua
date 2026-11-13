
---@class RaceStateViewAction:ViewBaseAction
RaceStateViewAction = class("RaceStateViewAction",ViewBaseAction)

function RaceStateViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceStateViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceState_SetData, self.SetData)
end

---@return RaceStateView
function RaceStateViewAction:View()
    return self.view
end

function RaceStateViewAction:SetData(type)
    if self:View() then
        self:View():SetData(type)
    end
end

return RaceStateViewAction()