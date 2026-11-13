---@class ChatShortCutData
ChatShortCutData = class("ChatShortCutData")

function ChatShortCutData:initialize()

end

function ChatShortCutData:CacheViewData(parent, uiModuleID)
    self.parentPrefab = UIUtil.GetChild("ChatShortCutView", parent)
    self.ShortChatListScrollView = UIUtil.GetTypeChildWightByParent("ShortChatList", self.parentPrefab, typeof(MoreRowScrollView))

    self.ShortMsg = {}
    self.EmojiMsg = {}

    self.chatShortCutType = ChatShortCutType.None

    self.uiModuleID = uiModuleID

    self:InitShortMsg()
    self:InitViewBtn()
    self.chatType = ChatType.None

    self.extraIxnfo = nil--额外的参数，比如不同系统里发送的快捷消息，添加不同的标志位，用来显示,和msg一起发送出去
end

function ChatShortCutData:SetChatType(chatType)
    self.chatType = chatType
end
function ChatShortCutData:GetChatType()
    return self.chatType
end

function ChatShortCutData:SetExtraInfo(data)
    self.extraInfo = data
end

function ChatShortCutData:InitShortInfo()

    self.pageQuickChat = CommonHelper:InitQuickChat(ChatType.ShortCut, self.parentPrefab, self.uiModuleID)

    ChatDataManager:Get():ClearChatDataByChatType(ChatType.ShortCut, -1)
end

function ChatShortCutData:InitShortMsg()
    ---@type quickspeak_config
    local quickspeak_config = ClientDataManager:Get():GetDataTable(ConfigNames.quickspeak_config)
    quickspeak_config = quickspeak_config.GetConfigData()
    for id, msg in pairs(quickspeak_config) do
        if msg.type == ChatQuickType.Battle then
            table.insert(self.ShortMsg, CommonHelper:GetTempStr_Default(msg.content))
        end
    end
end

function ChatShortCutData:InitViewBtn()

    CommonHelper:HButtonSetCallback("BtnShortChat", self.parentPrefab, function()
        self:InitShortList(ChatShortCutType.Msg)
    end)

    CommonHelper:HButtonSetCallback("BtnEmoji", self.parentPrefab, function()
        self:InitShortList(ChatShortCutType.Emoji)
    end)
end

---@param chatShortCutType  ChatShortCutType
function ChatShortCutData:GetMsgByShortCutType(chatShortCutType)
    if chatShortCutType == ChatShortCutType.Msg then
        return self.ShortMsg
    elseif chatShortCutType == ChatShortCutType.Emoji then
        return self.EmojiMsg
    end
end

---@param chatShortCutType  ChatShortCutType
function ChatShortCutData:InitShortList(chatShortCutType)

    local msgList = self:GetMsgByShortCutType(chatShortCutType)

    local UpdateFunc = function(dataIndex, itemObj, scroll)

        local msgData = msgList[dataIndex + 1]

        CommonHelper:SetText("###Text", itemObj, CommonHelper:GetTempStr_Default(msgData))

        CommonHelper:HButtonSetCallback("ViewDetailBtn", itemObj, function(param)
            self:OnShortMsgBtnClick(msgData)
        end)
    end
    CommonHelper:InitMoreRowScrollView(self.ShortChatListScrollView, #msgList, 1, UpdateFunc, true)
end

function ChatShortCutData:OnShortMsgBtnClick(msgData)
    print("发送快捷用语", self.extraInfo == nil and msgData or self.extraInfo .. msgData)
    local battleType = BattleDataManager:Get():GetBattleType()
    if battleType == RaceModel.RaceRoom or battleType == RaceModel.RaceRank then
        local chatIntervalTime = ChatDataManager:Get():GetTimerIdOrTimeByChatType(ChatType.ShortCut, ChatTimeOrId.Time)
        local nowTime = CommonHelper:GetNowTime()
        local unixNowTime = CommonHelper:ConvertDateTimeToInt(nowTime)
        local chatLeftTime = chatIntervalTime - unixNowTime
        if chatLeftTime > 0 then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChatTooOften))
        else
            ChatDataManager:Get():SetTimerIdOrTimeByChatType(ChatType.ShortCut, ChatTimeOrId.Time)

           -- msgData = self.extraInfo == nil and msgData or string.format("2&%s|%s", self.extraInfo, CommonHelper:GetTempStr_Default(msgData))
            --ChatSubsystem:Get():SendMsg_RoomChat(ChatType.ShortCut, msgData, ChatOrLinkType.Chat)
            if battleType == RaceModel.RaceRoom then
                ChatSubsystem:Get():SendMsg_ChatData(ChatType.PVPRoom, msgData, RaceRoomManager:Get():GetID(),nil,2,self.extraInfo)
            end
            if battleType == RaceModel.RaceRank then
                ChatSubsystem:Get():SendMsg_ChatData(ChatType.PVPRoom, msgData, RaceRankManager:Get():GetRoomId(),nil,2,self.extraInfo)
            end

        end
    end
end

function ChatShortCutData:UpdateScrollList(userdata)
    self.pageQuickChat:UpdateChatScrollView(userdata.chatType, userdata.playerId)
end

function ChatShortCutData:Clear()
    ChatDataManager:Get():ClearChatDataByChatType(ChatType.ShortCut, -1)
    ChatDataManager:Get():ClearChatDataByChatType(ChatType.RaceRecord, -1)
    ChatDataManager:Get():ClearExplainData()
end

















