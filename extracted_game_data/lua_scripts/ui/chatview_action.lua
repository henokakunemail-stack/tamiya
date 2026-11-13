
---@class ChatViewAction:ViewBaseAction
ChatViewAction = class("ChatViewAction",ViewBaseAction)

function ChatViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@return ChatView
function ChatViewAction:View()
    return self.view
end

function ChatViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ChatView_InitPrivateList, self.InitPrivateList)
    self:AddNotificationEvent(UINotifyEvent.ChatView_UpdatePrivateList, self.UpdatePrivateList)
    self:AddNotificationEvent(UINotifyEvent.ChatView_UpdateChatScrollView, self.UpdateChatScrollView)
    self:AddNotificationEvent(UINotifyEvent.ChatView_InitChatScrollList, self.InitChatScrollList)
    self:AddNotificationEvent(UINotifyEvent.ChatView_InitTogState, self.InitTogState)

    self:AddNotificationEvent(UINotifyEvent.ChatView_SetPrivateShowData, self.SetPrivateShowData)

    self:AddNotificationEvent(UINotifyEvent.ChatView_PlayerInfo_InitPageViewInfo, self.InitPageViewInfo)
    self:AddNotificationEvent(UINotifyEvent.ChatView_PlayerInfo_SetBtnInfo, self.SetBtnInfo)
    self:AddNotificationEvent(UINotifyEvent.ChatView_Word_Translate,self.TranslateContent)
end

function ChatViewAction:InitPrivateList(playerId)
    if self:View() then
        self:View():InitPrivateList(playerId)
    end
end

function ChatViewAction:UpdatePrivateList()
    if self:View() then

        self:View():UpdatePrivateList()

    end
end

function ChatViewAction:UpdateChatScrollView(userdata)
    if self:View() then

        self:View():UpdateChatScrollView(userdata)

    end
end

function ChatViewAction:InitChatScrollList(userdata)
    if self:View() then

        self:View():InitChatScrollList(userdata)

    end
end

function ChatViewAction:InitTogState(chatType)
    if self:View() then

        self:View():InitTogState(chatType)

    end
end


function ChatViewAction:InitPageViewInfo(chatData)
    if self:View() then

        self:View():InitPageViewInfo(chatData)

    end
end
function ChatViewAction:SetBtnInfo()
    if self:View() then

        self:View():SetBtnInfo()

    end
end

function ChatViewAction:SetPrivateShowData(chatType)
    if self:View() then

        self:View():SetPrivateShowData(chatType)

    end
end

function ChatViewAction:TranslateContent(data)
    if self:View() then
        self:View():TranslateContent(data[1],data[2])
    end
end

return ChatViewAction()