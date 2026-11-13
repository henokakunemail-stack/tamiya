---@class PageQuickChat
PageQuickChat = class("PageQuickChat")

function PageQuickChat:initialize()

end

function PageQuickChat:InitData(chatType, parentPref, uiModuleID)
    self.parentPref = parentPref
    self.uiModuleID = uiModuleID

    self.chatType = chatType

    self:CacheViewData()
    self:InitViewBtnFunc()
    self:InitChatScrollList(chatType, -1)
end

function PageQuickChat:CacheViewData()
    self.LoopListView2 = UIUtil.GetTypeChildWightByParent("ChatListPreView", self.parentPref, typeof(LoopListView2))
    self.LoopListView2Scroll = UIUtil.GetGameobjectComponent(self.LoopListView2.gameObject, typeof(ScrollRect))
end

function PageQuickChat:InitChatScrollList(chatType, playerId)
    local messageTotalCount = ChatDataManager:Get():GetChatListCountByChatType(chatType, playerId)
    --print("初始化是的消息数量" .. messageTotalCount)
    local funcUpdate = function(loopListView2, index)
        ---@type ChatData
        local messageData = ChatDataManager:Get():GetChatDataByIndexChatType(chatType, index + 1, playerId)

        if messageData:GetMessageType() ~= ChatPrefabType.Notification then
            --自己的永远是最新的，其他人的，永远拿最后一条的消息的玩家数据，更新之前消息的玩家数据，这个和写不写入都没问题
            if messageData:GetSendId() == PlayerDataManager:Get():GetPlayerRID() then
                messageData:SetSelfMsg()
            else
                local totalCount = ChatDataManager:Get():GetChatListCountByChatType(chatType, playerId)
                local lastMsgData = ChatDataManager:Get():GetChatDataByIndexChatType(chatType, totalCount, playerId)
                if lastMsgData:GetSendId() == messageData:GetSendId() then
                    messageData:SetPlayerData(lastMsgData:GetPlayerData())
                end
            end
        end

        local loopListViewItem2 = self:CreateChatPrefabByType(messageData:GetMessageType(), messageData, loopListView2)
        self:SetItemDataByType(messageData:GetMessageType(), loopListViewItem2.gameObject, messageData)
        return loopListViewItem2
    end
    CommonHelper:InitSuperScrollListView(self.LoopListView2, messageTotalCount, funcUpdate)
    if messageTotalCount > 0 then
        CommonHelper:MovePanelToItemIndex(self.LoopListView2, self.LoopListView2Scroll, messageTotalCount - 1)
    end
end

---@param playerId @如果没有就传-1
function PageQuickChat:UpdateChatScrollView(chatType, playerId)
    local messageCount = ChatDataManager:Get():GetChatListCountByChatType(chatType, playerId)
    print("消息的数量---------" .. messageCount)
    if messageCount ~= 0 then
        CommonHelper:SetListItemCount(self.LoopListView2, messageCount)
        CommonHelper:MovePanelToItemIndex(self.LoopListView2, self.LoopListView2Scroll, messageCount - 1)
    end
end

---@param messageData ChatData
---@param chatPrefabType ChatPrefabType  @创建聊天消息的prefab
function PageQuickChat:CreateChatPrefabByType(chatPrefabType, messageData, loopListView2)
    local loopListViewItem2
    if chatPrefabType == ChatPrefabType.Talk then
        if messageData:GetSendId() == PlayerDataManager:Get():GetPlayerRID() then
            loopListViewItem2 = loopListView2:NewListViewItem("ChatSelf")
        else
            loopListViewItem2 = loopListView2:NewListViewItem("ChatOther")
        end
    elseif chatPrefabType == ChatPrefabType.Notification then
        loopListViewItem2 = loopListView2:NewListViewItem("ClubNotification")
    elseif chatPrefabType == ChatPrefabType.RoomInvite then
        if messageData:GetSendId() == PlayerDataManager:Get():GetPlayerRID() then
            loopListViewItem2 = loopListView2:NewListViewItem("ChatRoomInviteSelf")
        else
            loopListViewItem2 = loopListView2:NewListViewItem("ChatRoomInviteOther")
        end
    end
    return loopListViewItem2
end

------------------根据消息的类型，设置不同prefab的数据
---@param chatPrefabType ChatPrefabType
function PageQuickChat:SetItemDataByType(chatPrefabType, messagePrefabGo, messageData)
    if chatPrefabType == ChatPrefabType.Talk then
        self:SetTalkPrefabData(messagePrefabGo, messageData)
        --elseif chatPrefabType == ChatPrefabType.Time then
        --    self:SetChatTimePrefabData(messagePrefabGo, messageData)
    end
end

---@param messageData ChatData
function PageQuickChat:SetTalkPrefabBaseData(talkPrefabGo, messageData)
    CommonHelper:GetComponentSetUITexture("icon", talkPrefabGo, CommonHelper:GetPlayerIconById(messageData:GetPlayerIcon()), self.uiModuleID)
    CommonHelper:GetComponentSetUITexture("iconframe", talkPrefabGo, CommonHelper:GetPlayerIconById(messageData:GetPlayerIconFrame(),nil,HeadIconAttrType.Frame), self.uiModuleID)

    CommonHelper:SetText("PlayerNameText", talkPrefabGo, messageData:GetName())
    CommonHelper:SetText("PlayerClubNameText", talkPrefabGo, messageData:GetClubName())

    CommonHelper:SetGameObjectActive("ChatTime", talkPrefabGo, false)

    CommonHelper:SetRankLvGroup("RankLvSmall", talkPrefabGo, 1, messageData:GetRankScore(), self.uiModuleID)
end

---@param messageData ChatData @设置聊天的prefab信息
function PageQuickChat:SetTalkPrefabData(talkPrefabGo, messageData)
    self:SetTalkPrefabBaseData(talkPrefabGo, messageData)
    local XText = UIUtil.GetTypeChildWightByParent("ChatContentText", talkPrefabGo, typeof(XText))
    local shareData = messageData:GetPShareInfo()
    if #shareData > 0 then
        --CommonHelper:InitInputFieldText(XText, shareData)
        --local actionList = {}
        -----@param param ChatShareParam
        --local onClick = function(param)
        --    print("这是点击分享链接的内容-------------------" .. param.shareName)
        --end
        --table.insert(actionList, onClick)
        --CommonHelper:RegisterEventForHyperlinks(XText, actionList, shareData)
    else
        XText.text = messageData:GetChatContent()
    end

    local ContentSizeFitter = UIUtil.GetTypeChildWightByParent("ChatContentText", talkPrefabGo, typeof(ContentSizeFitter))
    ContentSizeFitter:SetLayoutVertical()

    local sizeDelta = CommonHelper:GetRectSizeData("ChatContentText", talkPrefabGo)
    local ImageChangeSize = UIUtil.GetTypeChildWightByParent("BgImage", talkPrefabGo, typeof(ImageChangeSize))
    ImageChangeSize:ChangeSize(0, sizeDelta.y + 5, ImageChangeSizeType.High)

    CommonHelper:SetRectSizeDeltaByGo(talkPrefabGo, Vector2(770, 110 + sizeDelta.y))

    CommonHelper:SetRectPosByName("Center", talkPrefabGo, nil, -20)
end

---@param messageData ChatData
function PageQuickChat:SetChatTimePrefabData(chatTimePrefab, messageData)
    local chatTime = math.floor(messageData:GetSendTimeUnix() * 0.001)
    local date = CommonHelper:UnixTimeConvertTime(chatTime)
    local Hour = tostring(date.Hour)
    if date.Hour < 10 then
        Hour = string.format("0%d", date.Hour)
    end

    local Minute = tostring(date.Minute)
    if date.Minute < 10 then
        Minute = string.format("0%d", date.Minute)
    end

    local time = string.format("%s:%s", Hour, Minute)
    CommonHelper:SetText("###ChatTimeText", chatTimePrefab, time)
end

function PageQuickChat:InitViewBtnFunc()
    self.ChatBtn = CommonHelper:HButtonSetCallback("ChatBtn", self.parentPref, function(hbtn)
        UIManager:Get():ShowPersistentView("ChatView", CanvasType.MainCanvas, "ChatView")
        UINotify:Get():SendNotification(UINotifyEvent.ChatView_InitTogState, ChatType.PVPRoom)
    end)

    CommonHelper:SetHButtonClick(self.ChatBtn, self.chatType ~= ChatType.ShortCut, true)
end

function PageQuickChat:ClearData()
    CommonHelper:ReleasePool(self.uiModuleID)
end


