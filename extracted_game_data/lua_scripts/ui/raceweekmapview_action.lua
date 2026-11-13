


---@class RaceWeekMapViewAction:ViewBaseAction
RaceWeekMapViewAction = class("RaceWeekMapViewAction",ViewBaseAction)

function RaceWeekMapViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceWeekMapViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceWeekMapView_SetData, self.SetData)
end

---@return RaceWeekMapView
function RaceWeekMapViewAction:View()
    return self.view
end

function RaceWeekMapViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data)
    end
end

return RaceWeekMapViewAction()