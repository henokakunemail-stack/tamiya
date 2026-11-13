---@class PageSingleChannelChat_2
PageSingleChannelChat_2 = class("PageSingleChannelChat_2")

function PageSingleChannelChat_2:initialize()

end

function PageSingleChannelChat_2:InitData(chatType, parentPref, uiModuleID, idColorTab)
    self.parentPref = parentPref
    self.uiModuleID = uiModuleID

    ChatDataManager:Get():SetChatType(chatType)

    self.idColorTab = idColorTab

    self:CacheData()
    self:InitViewBtnFunc()
end

function PageSingleChannelChat_2:CacheData()
    self.chatSysList = UIUtil.GetTypeChildWightByParent("ChatList", self.parentPref, typeof(MoreRowScrollView))

    --self.ChatInputField = UIUtil.GetTypeChildWightByParent("InputChat", self.parentPref, typeof(TMP_InputField))
    self.ChatInputField = UIUtil.GetTypeChildWightByParent("InputChat", self.parentPref, typeof(InputField))
    self.timeImage = CommonHelper:SetGameObjectActive("TimeImage", self.parentPref, false)
end

function PageSingleChannelChat_2:InitChatList(chatType, playerId)

    local count = ChatDataManager:Get():GetChatListCountByChatType(chatType, playerId)

    local UpdateFunc = function(dataIndex, itemObj, scroll)
        ---@type ChatData
        local chatData = ChatDataManager:Get():GetChatDataByIndexChatType(chatType, dataIndex + 1)

        local content = chatData:GetChatContent()

        local color = self.idColorTab ~= nil and self.idColorTab[chatData:GetSendId()] or "ffffff"

        content = string.format("<color=#%s>[%s]</color>：%s", color, chatData:GetName(), content)

        CommonHelper:SetText("###ChatText", itemObj, content)
    end
    CommonHelper:InitMoreRowScrollView(self.chatSysList, count, 1, UpdateFunc, true)
    CommonHelper:MoreRowView_ScrollToItem(self.chatSysList, count - 1)
end

function PageSingleChannelChat_2:InitViewBtnFunc()
    self.SendBtn = CommonHelper:HButtonSetCallback("SendBtn", self.parentPref, function(param)
        self:OnSendBtnClick()
    end)
end

--{{{聊天按钮功能
function PageSingleChannelChat_2:OnSendBtnClick()
   -- local banTalkTime = PlayerDataManager:Get():GetBanTalkLeftTimeDl()

    --if banTalkTime == ChatBanTime.BanForever then
    --    CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChatBanForever))
    --    CommonHelper:InputFieldSetValue(self.ChatInputField, "")
    --    return
    --else
    --    if CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) < banTalkTime then
    --        local date = CommonHelper:ConvertIntToDataTime(banTalkTime * 1000)
    --        local dateStr = date:ToString("yyyy:MM:dd HH:mm:ss")
    --        local str = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrComStr),CommonHelper:GetTempStr_Default(TemplateStringID.YouBanChatTo), dateStr)
    --        CommonTipsHelper:ShowCenterTips(str)
    --        CommonHelper:InputFieldSetValue(self.ChatInputField, "")
    --        return
    --    end
    --end

    self:ChatInputFieldEvent()
    CommonHelper:InputFieldSetValue(self.ChatInputField, "")
end

function PageSingleChannelChat_2:ChatInputFieldEvent()
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

function PageSingleChannelChat_2:HandleShareInput(inputField)
    --local TextMeshProUGUI = inputField.gameObject:GetComponentsInChildren(typeof(TextMeshProUGUI))
    --local linkCount = TextMeshProUGUI[1].textInfo.linkCount
    --if linkCount > 0 then
    --    for i = 1, linkCount do
    --        local shareData = ShareDataManager:Get():GetShareDataByIndex(i)
    --        ChatSubsystem:Get():SendMsg_ChatShareInfoReq(shareData)
    --    end
    --else
        local isRightDescribe = CommonHelper:ReviewWordsV2(tostring(PlayerDataManager:Get():GetPlayerLV()), tostring(ChatDataManager:Get():GetChatType()), inputField.text)
        if  isRightDescribe then
            self:OnSendBtnFunc(inputField.text)
        end
    --end
end

function PageSingleChannelChat_2:OnSendBtnFunc(inputText)
    local chatType = ChatDataManager:Get():GetChatType()
    if chatType == ChatType.Private then
        --FriendSubsystem:Get():SendMsg_PrivateChatToOther(ChatDataManager:Get():GetCurSelectPrivateId(), inputText, ChatOrLinkType.Chat)
        ChatSubsystem:Get():SendMsg_ChatData(chatType, inputText, ChatDataManager:Get():GetCurSelectPrivateId())
    elseif chatType == ChatType.PVPRoom then
        --ChatSubsystem:Get():SendMsg_RoomChat(ChatDataManager:Get():GetChatType(), inputText, ChatOrLinkType.Chat)
        ChatSubsystem:Get():SendMsg_ChatData(chatType, inputText, RaceRoomManager:Get():GetID(),nil,1)
    elseif chatType == ChatType.Club then
        --ChatSubsystem:Get():SendMsg_ClubChat(ChatDataManager:Get():GetChatType(), inputText, ChatOrLinkType.Chat)
        ChatSubsystem:Get():SendMsg_ChatData(chatType, inputText, 0)
    else
        --ChatSubsystem:Get():SendMsg_PlayerChatReq(chatType, inputText, ChatOrLinkType.Chat)
        ChatSubsystem:Get():SendMsg_ChatData(chatType, inputText, 0)
    end
end

function PageSingleChannelChat_2:SetChatRefreshTime()
    local chatType = ChatDataManager:Get():GetChatType()
    local chatIntervalTime = ChatDataManager:Get():GetTimerIdOrTimeByChatType(chatType, ChatTimeOrId.Time)
    local unixNowTime = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    local chatLeftTime = chatIntervalTime - unixNowTime
    if chatLeftTime > 0 then
        CommonHelper:SetText("Text", self.timeImage, string.format("%d", chatLeftTime))
        CommonHelper:SetHButtonClick(self.SendBtn, false, false)

        self:StopTimer(chatType)
        local timeId = TimerManager:Get():CreateTimerLoop(1, function()
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
                    CommonHelper:SetText("Text", self.timeImage, string.format("%d", chatLeftTime))
                end
            end
        end)
        ChatDataManager:Get():SetTimerIdOrTimeByChatType(chatType, ChatTimeOrId.TimeId, timeId)
        print("chatType:" .. tostring(chatType) .. "创建了一个计时器,timeId是:" .. ChatDataManager:Get():GetTimerIdOrTimeByChatType(chatType, ChatTimeOrId.TimeId))
    else
        CommonHelper:CSGameObjectSetActive(self.timeImage, false)
        CommonHelper:SetHButtonClick(self.SendBtn, true, false)
    end
end

function PageSingleChannelChat_2:StopTimer(chatType)
    chatType = chatType or ChatDataManager:Get():GetChatType()
    local timeId = ChatDataManager:Get():GetTimerIdOrTimeByChatType(chatType, ChatTimeOrId.TimeId)
    if timeId ~= -1 then
        print("chatType:" .. tostring(chatType) .. "停止了了一个计时器,timeId是:" .. timeId)
        TimerManager:Get():StopTimer(timeId)
        ChatDataManager:Get():RemoveTimeIdByChatType(chatType, ChatTimeOrId.TimeId)
    end
end
--}}}


function PageSingleChannelChat_2:ClearData()
    CommonHelper:ReleasePool(self.uiModuleID)
end


