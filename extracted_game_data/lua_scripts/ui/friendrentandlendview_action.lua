---@class FriendRentAndLendViewAction:ViewBaseAction
FriendRentAndLendViewAction = class("FriendRentAndLendViewAction", ViewBaseAction)

-- Action必加1
function FriendRentAndLendViewAction:initialize()
    ViewBaseAction.initialize(self)
end



-- Action必加2
function FriendRentAndLendViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.InitRentOrLendInfoByType, self.InitRentOrLendInfoByType)
end

---@return FriendRentAndLendView
function FriendRentAndLendViewAction:View()
    return self.view
end

function FriendRentAndLendViewAction:InitRentOrLendInfoByType(data)
    if self:View() then
        self:View():InitRentOrLendInfoByType(data[1],data[2])
    end
end

return FriendRentAndLendViewAction()
