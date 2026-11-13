function ChatViewData:InitChatScrollList(chatType, playerId, isUpdate,refreshIndex)
    local messageTotalCount = ChatDataManager:Get():GetChatListCountByChatType(chatType, playerId)
    print("初始化是的消息数量" .. messageTotalCount)
    local isMoveToBottom = ChatDataManager:Get():IsNeedAutoScroll(self.LoopListView2Scroll, chatType, playerId)
    local funcUpdate = function(loopListView2, index)

        local _chatType = ChatDataManager:Get():GetChatType()

        if _chatType == ChatType.Private then
            local _selectPrivateId = ChatDataManager:Get():GetCurSelectPrivateId()
            local _selectPrivateData = ChatDataManager:Get():GetChatDataByIndexChatType(_chatType, index + 1, _selectPrivateId)
            local loopListViewItem2Script = self:CreateChatPrefabByType(_selectPrivateData:GetMessageType(), _selectPrivateData, loopListView2)
            self:SetItemDataByType(_selectPrivateData:GetMessageType(), loopListViewItem2Script, _selectPrivateData, nil)
            return loopListViewItem2Script
        else
            ---@type ChatData
            local messageData = ChatDataManager:Get():GetChatDataByIndexChatType(chatType, index + 1, playerId)
            local preMsgData = index > 0 and ChatDataManager:Get():GetChatDataByIndexChatType(chatType, index, playerId) or nil
            local totalCount = ChatDataManager:Get():GetChatListCountByChatType(chatType, playerId)
            if messageData == nil then
                logError("messageData == nil", debug.traceback())
                return nil
            else
                if messageData:GetMessageType() ~= ChatPrefabType.Notification then
                    --自己的永远是最新的，其他人的，永远拿最后一条的消息的玩家数据，更新之前消息的玩家数据，因为最后一条永远是最新的，这个和写不写入都没问题
                    if messageData:GetSendId() == PlayerDataManager:Get():GetPlayerRID() then
                        messageData:SetSelfMsg()
                    else
                        local lastMsgData = ChatDataManager:Get():GetChatDataByIndexChatType(chatType, totalCount, playerId)
                        if lastMsgData:GetSendId() == messageData:GetSendId() then
                            messageData:SetPlayerData(lastMsgData:GetPlayerData())
                        end
                    end
                end
                if totalCount == index + 1 then
                    CommonHelper:SetHButtonClick(self.NewMsgBtn, false, true)
                end
                local loopListViewItem2Script = self:CreateChatPrefabByType(messageData:GetMessageType(), messageData, loopListView2)
                self:SetItemDataByType(messageData:GetMessageType(), loopListViewItem2Script, messageData, preMsgData)
                return loopListViewItem2Script
            end
        end
    end
    if not isUpdate or isMoveToBottom then
        CommonHelper:InitSuperScrollListView(self.LoopListView2, messageTotalCount, funcUpdate)
        CommonHelper:MovePanelToItemIndex(self.LoopListView2, self.LoopListView2Scroll, messageTotalCount - 1, true)
    end

    if not isMoveToBottom and refreshIndex==nil then
        CommonHelper:SetHButtonClick(self.NewMsgBtn, true, true)
    end
    if isUpdate and refreshIndex==nil then
        CommonHelper:SetListItemCount(self.LoopListView2, messageTotalCount)
    end
    if refreshIndex~=nil then
        CommonHelper:RefreshAllShownItem(self.LoopListView2)
        --CommonHelper:MovePanelToItemIndex(self.LoopListView2, self.LoopListView2Scroll,refreshIndex)
    end
end

function ChatViewData:ScrollMoveToBottom()
    local chatType = ChatDataManager:Get():GetChatType()
    local messageTotalCount = ChatDataManager:Get():GetChatListCountByChatType(chatType, -1)
    CommonHelper:MovePanelToItemIndex(self.LoopListView2, self.LoopListView2Scroll, messageTotalCount - 1)
end

---@param playerId @如果没有就传-1
function ChatViewData:UpdateChatScrollView(chatType, playerId,refreshIndex)
    if not UIUtil.IsCanvasGroupShow(self.BgCanvasGroup) then
        --聊天框没显示，是不是需要显示最新消息
    else

        self:InitChatScrollList(chatType, playerId, true,refreshIndex)

        --local messageCount = ChatDataManager:Get():GetChatListCountByChatType(chatType, playerId)
        --print("消息的数量---------" .. messageCount)
        --if messageCount ~= 0 then
        --    CommonHelper:SetListItemCount(self.LoopListView2, messageCount)
        --    if ChatDataManager:Get():IsNeedAutoScroll(self.LoopListView2Scroll, chatType, playerId) then
        --        CommonHelper:MovePanelToItemIndex(self.LoopListView2, self.LoopListView2Scroll, messageCount - 1)
        --    else
        --        CommonHelper:SetHButtonClick(self.NewMsgBtn, true, true)
        --    end
        --end
    end
end

function ChatViewData:SetChatRefreshTime()
    local chatType = ChatDataManager:Get():GetChatType()
    local chatIntervalTime = ChatDataManager:Get():GetTimerIdOrTimeByChatType(chatType, ChatTimeOrId.Time)
    local unixNowTime = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    local chatLeftTime = chatIntervalTime - unixNowTime
    if chatLeftTime > 0 then
        CommonHelper:SetText("###TimeImageText", self.timeImage, string.format("%d", chatLeftTime))
        CommonHelper:SetHButtonClick(self.SendBtn, false, false)

        self:StopTimer(chatType)
        local update=function()
            unixNowTime = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
            chatLeftTime = chatIntervalTime - unixNowTime
            if chatLeftTime <= 0 then
                if chatType == ChatDataManager:Get():GetChatType() then
                    --当时的类型和现在的类型一致才可以
                    CommonHelper:CSGameObjectSetActive(self.timeImage, false)
                    CommonHelper:SetHButtonClick(self.SendBtn, true, false)
                end
                self:StopTimer(chatType)
            else
                if chatType == ChatDataManager:Get():GetChatType() then
                    CommonHelper:CSGameObjectSetActive(self.timeImage, true)
                    CommonHelper:SetText("###TimeImageText", self.timeImage, string.format("%d", chatLeftTime))
                end
            end
        end
        local timeId = TimerManager:Get():CreateTimerLoop(1, update)
        update()
        ChatDataManager:Get():SetTimerIdOrTimeByChatType(chatType, ChatTimeOrId.TimeId, timeId)
        print("chatType:" .. tostring(chatType) .. "创建了一个计时器,timeId是:" .. ChatDataManager:Get():GetTimerIdOrTimeByChatType(chatType, ChatTimeOrId.TimeId))
    else
        CommonHelper:CSGameObjectSetActive(self.timeImage, false)
        CommonHelper:SetHButtonClick(self.SendBtn, true, false)
    end
end

---@param inputField
function ChatViewData:HandleShareInput(inputField)
    --local TextMeshProUGUI = inputField.gameObject:GetComponentsInChildren(typeof(TextMeshProUGUI))
    --local linkCount = TextMeshProUGUI[1].textInfo.linkCount
    --if linkCount > 0 then
    --    for i = 1, linkCount do
    --        local shareData = ShareDataManager:Get():GetShareDataByIndex(i)
    --        ChatSubsystem:Get():SendMsg_ChatShareInfoReq(shareData)
    --    end
    --else
    local isRightDescribe = CommonHelper:ReviewWordsV2(tostring(PlayerDataManager:Get():GetPlayerLV()), tostring(ChatDataManager:Get():GetChatType()), inputField.text)
    if isRightDescribe then
        if self.sendBtnFunc ~= nil then
            self.sendBtnFunc(self, inputField.text)
        end
    end
    --end
end

function ChatViewData:ChatInputFieldEvent()
    local isNull = CommonHelper:IsNullOrEmpty(CommonHelper:InputFieldGetValue(self.ChatInputField))
    if not isNull then
        print("编辑完成当前的")
        self:HandleShareInput(self.ChatInputField)
        CommonHelper:CSGameObjectSetActive(self.timeImage, true)
        local chatType = ChatDataManager:Get():GetChatType()
        ChatDataManager:Get():SetTimerIdOrTimeByChatType(chatType, ChatTimeOrId.Time)
        self:SetChatRefreshTime()
    else
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ClubChatMessageCanNotNull))
    end
end

function ChatViewData:StopTimer(chatType)
    chatType = chatType or ChatDataManager:Get():GetChatType()
    local timeId = ChatDataManager:Get():GetTimerIdOrTimeByChatType(chatType, ChatTimeOrId.TimeId)
    if timeId ~= -1 then
        TimerManager:Get():StopTimer(timeId)
        ChatDataManager:Get():RemoveTimeIdByChatType(chatType, ChatTimeOrId.TimeId)
    end
end








