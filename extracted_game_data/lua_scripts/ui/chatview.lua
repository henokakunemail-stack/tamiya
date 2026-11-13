---@class ChatView:ViewBase
ChatView = class("ChatView", ViewBase)

function ChatView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ChatViewAction")
end

function ChatView:Awake()
    self:CacheViewData()
end

function ChatView:CacheViewData()
    self.chatViewData = CommonHelper:InitChatViewData(ChatType.World, self.gameObject, UIModuleID.ChatView, self.OnSendBtnFunc)
end

function ChatView:OnSendBtnFunc(inputText)
    local chatType = ChatDataManager:Get():GetChatType()
    if chatType == ChatType.Private then
        --FriendSubsystem:Get():SendMsg_PrivateChatToOther(ChatDataManager:Get():GetCurSelectPrivateId(), inputText, ChatOrLinkType.Chat)
        if FriendDataManager:Get():IsBlackListPlayer(ChatDataManager:Get():GetCurSelectPrivateId()) then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.InBackListCannotPrivateChat))
        else
            ChatSubsystem:Get():SendMsg_ChatData(chatType, inputText, ChatDataManager:Get():GetCurSelectPrivateId())
        end
    elseif chatType == ChatType.PVPRoom then
        --ChatSubsystem:Get():SendMsg_RoomChat(ChatDataManager:Get():GetChatType(), inputText, ChatOrLinkType.Chat)
        ChatSubsystem:Get():SendMsg_ChatData(chatType, inputText, 0)
    elseif chatType == ChatType.Club then
        --ChatSubsystem:Get():SendMsg_ClubChat(ChatDataManager:Get():GetChatType(), inputText, ChatOrLinkType.Chat)
        ChatSubsystem:Get():SendMsg_ChatData(chatType, inputText, 0)
    else
        --ChatSubsystem:Get():SendMsg_PlayerChatReq(chatType, inputText, ChatOrLinkType.Chat)
        ChatSubsystem:Get():SendMsg_ChatData(chatType, inputText, 0)
    end
end

function ChatView:TranslateContent(index,count)---翻译
    local chatType = ChatDataManager:Get():GetChatType()
    local targetLand = ClientDataManager:Get():TranslateTargetLand()
    local alreadyTranslateCount = 0
    local needCount = count
    local chatList =  ChatDataManager:Get():GetChatListByChatType(chatType)
    local refreshIndex = (index + count-1) ~= #chatList and index or nil
    local TranslateOver = function(translateContent,sLang,_chatData)

        alreadyTranslateCount=alreadyTranslateCount+1
        print(alreadyTranslateCount.. "needCount:"..needCount.."translateContent"..translateContent)
        if sLang==targetLand then
            translateContent="SameLand"
        end
        _chatData:SetChatTranslateContent(translateContent)
        if alreadyTranslateCount==needCount then
            ---刷新UI
            self.chatViewData:UpdateChatScrollView(chatType, -1,refreshIndex)
        end
    end
    if chatType == ChatType.World then
        for i = index, index + count-1 do
            ---@type ChatData
            local chatData=chatList[i]
            if i<=#chatList then
                if not chatData:IsTranslate() then
                    local data = TranslateData()
                    data.targetLand = targetLand
                    data.textInput = chatData:GetChatContent()
                    data.callBack = function(translateContent,sLang)
                        TranslateOver(translateContent,sLang,chatData)
                    end
                    UnifySDKManager:Get():IDevice():Translate(data)
                else
                    needCount=needCount-1
                end
            else
                needCount = needCount-1
                logError("  TranslateContent   ChatList not have index  ",i)
            end
        end
    end
end

function ChatView:InitPrivateList(playerId)
    self.chatViewData:InitPrivateList(playerId)
end

function ChatView:UpdatePrivateList()
    if ChatDataManager:Get():GetChatType() == ChatType.Private then
        self.chatViewData:UpdatePrivateList()
    end
end

function ChatView:UpdateChatScrollView(userdata)
    self.chatViewData:UpdateChatScrollView(userdata.chatType, userdata.playerId)
end

function ChatView:InitChatScrollList(userdata)
    self.chatViewData:InitChatScrollList(userdata.chatType, userdata.playerId)
end

function ChatView:InitTogState(chatType)
    self.chatViewData:InitTogState(chatType)
end

function ChatView:InitPageViewInfo(chatData)
    self.chatViewData:InitPageViewInfo(chatData)
end
function ChatView:SetBtnInfo()
    self.chatViewData:SetBtnInfo()
end

function ChatView:SetPrivateShowData(chatType)
    self.chatViewData:SetPrivateShowData(chatType)
end

function ChatView:OnClose()
    self.chatViewData:Clear()
    CommonHelper:ReleasePool(UIModuleID.ChatView)
end



