
---@class RaceInviteFriendViewAction:ViewBaseAction
RaceInviteFriendViewAction = class("RaceInviteFriendViewAction",ViewBaseAction)

function RaceInviteFriendViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@return RaceInviteFriendView
function RaceInviteFriendViewAction:View()
    return self.view
end

function RaceInviteFriendViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceInviteFriendView_InitViewInfo, self.InitFriendList)
end

function RaceInviteFriendViewAction:InitFriendList(shareType)
    self:View():InitFriendList(shareType)
end




return RaceInviteFriendViewAction()