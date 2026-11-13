


---@class RaceSelfMapViewAction:ViewBaseAction
RaceSelfMapViewAction = class("RaceSelfMapViewAction",ViewBaseAction)

function RaceSelfMapViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSelfMapViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceSelfMapView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfMapView_ClickTog, self.ClickTog)
end

---@return RaceSelfMapView
function RaceSelfMapViewAction:View()
    return self.view
end

function RaceSelfMapViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data)
    end
end

function RaceSelfMapViewAction:ClickTog(idx)
    if self:View() then
        self:View():OnClickTog(idx)
    end
end

return RaceSelfMapViewAction()