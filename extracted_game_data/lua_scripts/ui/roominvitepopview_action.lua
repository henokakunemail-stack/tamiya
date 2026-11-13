
---@class RoomInvitePopViewAction:ViewBaseAction
RoomInvitePopViewAction = class("RoomInvitePopViewAction",ViewBaseAction)

function RoomInvitePopViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@return RoomInvitePopView
function RoomInvitePopViewAction:View()
    return self.view
end

function RoomInvitePopViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RoomInvitePopView_InitViewInfo, self.InitViewInfo)
end

function RoomInvitePopViewAction:InitViewInfo()
    self:View():InitViewInfo()
end




return RoomInvitePopViewAction()