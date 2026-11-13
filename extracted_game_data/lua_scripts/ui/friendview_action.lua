---@class FriendListViewAction:ViewBaseAction
FriendListViewAction = class("FriendListViewAction", ViewBaseAction)

-- Action必加1
function FriendListViewAction:initialize()
    ViewBaseAction.initialize(self)
end



-- Action必加2
function FriendListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.FriendListView_InitFriendList, self.InitFriendList)
    self:AddNotificationEvent(UINotifyEvent.FriendListView_InitFriendInfo, self.InitFriendInfo)
    self:AddNotificationEvent(UINotifyEvent.FriendListView_InitRedPointInfo, self.InitRedPointInfo)
    self:AddNotificationEvent(UINotifyEvent.FriendListView_SetLuaViewInfo, self.SetLuaViewInfo)
    self:AddNotificationEvent(UINotifyEvent.FriendListView_ClearLuaViewInfo, self.ClearLuaViewInfo)
    self:AddNotificationEvent(UINotifyEvent.FriendListView_RefreshRentHaveInfo, self.RefreshFriendRentAndLendCostData)

end

---@return FriendListView
function FriendListViewAction:View()
    return self.view
end

function FriendListViewAction:InitFriendList(param)
    if self:View() then
        self:View():InitFriendList(param[1],param[2])

    end
end

function FriendListViewAction:InitFriendInfo(friendManagerType)
    if self:View() then
        self:View():InitFriendInfo(friendManagerType)

    end
end

function FriendListViewAction:InitRedPointInfo()
    if self:View() then
        self:View():InitRedPointInfo()

    end
end

function FriendListViewAction:SetLuaViewInfo(param)
    if self:View() then
        self:View():SetLuaViewInfo(param[1],param[2])
    end
end

function FriendListViewAction:ClearLuaViewInfo()
    if self:View() then
        self:View():ClearLuaViewInfo()
    end
end


function FriendListViewAction:RefreshFriendRentAndLendCostData()
    if self:View() then
        self:View():RefreshFriendRentAndLendCostData()
    end
end

return FriendListViewAction()
