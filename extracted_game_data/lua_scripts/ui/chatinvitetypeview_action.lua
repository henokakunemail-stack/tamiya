---@class ChatInviteTypeViewAction:ViewBaseAction
ChatInviteTypeViewAction = class("ChatInviteTypeViewAction", ViewBaseAction)

function ChatInviteTypeViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@return ChatInviteTypeView
function ChatInviteTypeViewAction:View()
    return self.view
end

function ChatInviteTypeViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ChatShareTypeView_InitViewInfo, self.InitViewInfo)
end

function ChatInviteTypeViewAction:InitViewInfo(userData)
    self:View():InitViewInfo(userData[1], userData[2],userData[3])
end

return ChatInviteTypeViewAction()