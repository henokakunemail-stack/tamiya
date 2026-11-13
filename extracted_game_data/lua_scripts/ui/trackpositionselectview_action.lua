---@class TrackPositionSelectViewAction:ViewBaseAction
TrackPositionSelectViewAction = class("TrackPositionSelectViewAction", ViewBaseAction)

function TrackPositionSelectViewAction:initialize()
    ViewBaseAction.initialize(self)
end
function TrackPositionSelectViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.TrackPositionSelectView_SetData, self.SetData)
end

---@return TrackPositionSelectView
function TrackPositionSelectViewAction:View()
    return self.view
end

function TrackPositionSelectViewAction:SetData(date)
    if self:View() then
        self:View():SetData(date[1],date[2],date[3],date[4])
    end
end

return TrackPositionSelectViewAction()