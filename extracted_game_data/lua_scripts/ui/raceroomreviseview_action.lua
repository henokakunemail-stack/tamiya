


---@class RaceRoomReviseViewAction:ViewBaseAction
RaceRoomReviseViewAction = class("RaceRoomReviseViewAction",ViewBaseAction)

function RaceRoomReviseViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceRoomReviseViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceRoomDetailView_ReviseViewAuto, self.AutoSelect)
end

---@return RaceRoomReviseView
function RaceRoomReviseViewAction:View()
    return self.view
end

function RaceRoomReviseViewAction:AutoSelect()
    if self:View() then
        self:View():AutoSelect()
    end
end

return RaceRoomReviseViewAction()