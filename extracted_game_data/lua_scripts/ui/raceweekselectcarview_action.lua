


---@class RaceWeekSelectCarViewAction:ViewBaseAction
RaceWeekSelectCarViewAction = class("RaceWeekSelectCarViewAction",ViewBaseAction)

function RaceWeekSelectCarViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceWeekSelectCarViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceWeekSelectCarView_SetData, self.SetData)
end

---@return RaceWeekSelectCarView
function RaceWeekSelectCarViewAction:View()
    return self.view
end

function RaceWeekSelectCarViewAction:SetData(param)
    if self:View() then
        self:View():SetData(param)
    end
end

return RaceWeekSelectCarViewAction()