---@class FriendChoosePropViewAction:ViewBaseAction
FriendChoosePropViewAction = class("FriendChoosePropViewAction", ViewBaseAction)

function FriendChoosePropViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function FriendChoosePropViewAction:OnRegisterEvents()

    self:AddNotificationEvent(UINotifyEvent.InitFriendChoosePart, self.SetChoosePartType)
end

---@return FriendChoosePropView
function FriendChoosePropViewAction:View()
    return self.view
end

function FriendChoosePropViewAction:SetChoosePartType(data)
    if self:View() then
        self:View():SetChoosePartType(data[1],data[2])
    end
end

return FriendChoosePropViewAction()
