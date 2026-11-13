---@class FriendExchangeViewAction:ViewBaseAction
FriendExchangeViewAction = class("FriendExchangeViewAction", ViewBaseAction)

function FriendExchangeViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function FriendExchangeViewAction:OnRegisterEvents()

    self:AddNotificationEvent(UINotifyEvent.RefreshFriendExchangeData, self.RefreshSVCData)
end

---@return FriendExchangeView
function FriendExchangeViewAction:View()
    return self.view
end

function FriendExchangeViewAction:RefreshSVCData()
    if self:View() then
        self:View():RefreshSVCData()
    end
end

return FriendExchangeViewAction()
