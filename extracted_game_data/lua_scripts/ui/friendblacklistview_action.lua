---@class FriendBlackListViewAction:ViewBaseAction
FriendBlackListViewAction = class("FriendBlackListViewAction", ViewBaseAction)

-- Action必加1
function FriendBlackListViewAction:initialize()
    ViewBaseAction.initialize(self)
end



-- Action必加2
function FriendBlackListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.FriendBlackListView_InitFriendList, self.InitFriendList)
end

---@return FriendBlackListView
function FriendBlackListViewAction:View()
    return self.view
end

function FriendBlackListViewAction:InitFriendList()
    if self:View() then
        self:View():InitFriendList()
    end
end

return FriendBlackListViewAction()
