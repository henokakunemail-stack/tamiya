---@class PageSingleChannelChat
PageSingleChannelChat = class("PageSingleChannelChat")

function PageSingleChannelChat:initialize()
end

function PageSingleChannelChat:InitData(chatType, parentPref, uiModuleID,parentRoot)
    self.parentPref = parentPref
    self.uiModuleID = uiModuleID
    self.parentRoot = parentRoot

    ChatDataManager:Get():SetChatType(chatType)

    self:CachePlayerInfoData()

    self:CacheViewData()
    self:InitViewBtnFunc()
    self:InitChatScrollList(chatType, -1)
end

function PageSingleChannelChat:CacheViewData()
    self.LoopListView2 = UIUtil.GetTypeChildWightByParent("ChatListPreView", self.parentPref, typeof(LoopListView2))
    self.LoopListView2Scroll = UIUtil.GetGameobjectComponent(self.LoopListView2.gameObject, typeof(ScrollRect))
    --self.ChatInputField = UIUtil.GetTypeChildWightByParent("InputChat", self.parentPref, typeof(TMP_InputField))
    self.ChatInputField = UIUtil.GetTypeChildWightByParent("InputChatWithEmoji", self.parentPref, typeof(InputField))
    self.timeImage = CommonHelper:SetGameObjectActive("TimeImage", self.parentPref, false)
    self.PageEmoji = PageEmoji()
    self.PageEmoji:InitData(self.ChatInputField.gameObject, self.ChatInputField)
end

--{{{聊天列表功能

function PageSingleChannelChat:InitChatScrollList(chatType, playerId)
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
function PageSingleChannelChat:UpdateChatScrollView(chatType, playerId)

    self:InitChatScrollList(chatType, playerId)
    --local messageCount = ChatDataManager:Get():GetChatListCountByChatType(chatType, playerId)
    --print("消息的数量---------" .. messageCount)
    --if messageCount ~= 0 then
    --    CommonHelper:SetListItemCount(self.LoopListView2, messageCount)
    --    CommonHelper:MovePanelToItemIndex(self.LoopListView2, self.LoopListView2Scroll, messageCount - 1)
    --end
end

---@param messageData ChatData
---@param chatPrefabType ChatPrefabType  @创建聊天消息的prefab
function PageSingleChannelChat:CreateChatPrefabByType(chatPrefabType, messageData, loopListView2)
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
function PageSingleChannelChat:SetItemDataByType(chatPrefabType, loopListViewItem2Script, messageData, preMsgData)
    if chatPrefabType == ChatPrefabType.Talk then
        self:SetTalkPrefabData(loopListViewItem2Script, messageData, preMsgData)
    elseif chatPrefabType == ChatPrefabType.Notification then
        self:SetNotifyPrefabData(loopListViewItem2Script, messageData, preMsgData)
        --elseif chatPrefabType == ChatPrefabType.Time then
        --    self:SetChatTimePrefabData(messagePrefabGo, messageData)
    elseif chatPrefabType == ChatPrefabType.RoomInvite then
        self:SetRoomInvitePrefabData(loopListViewItem2Script, messageData, preMsgData)
    elseif chatPrefabType == ChatPrefabType.ClubInvite then
        self:SetClubInvitePrefabData(loopListViewItem2Script, messageData, preMsgData)
    elseif chatPrefabType == ChatPrefabType.ChallengeMatchInvite then
        self:SetChallengeMatchPrefabData(loopListViewItem2Script, messageData, preMsgData)
    end
end

---@param messageData ChatData
function PageSingleChannelChat:SetChatTimePrefabData(chatTimePrefab, messageData)
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

function PageSingleChannelChat:InitViewBtnFunc()
    self.SendBtn = CommonHelper:HButtonSetCallback("SendBtn", self.parentPref, function(param)
        self:OnSendBtnClick()
    end)

    CommonHelper:HButtonSetCallback("BtnPlayerInfo", self.pagePlayerInfoCG.gameObject, function()
        UIUtil.ShowCanvasGroup(self.pagePlayerInfoCG, false)
        self:ChangeChildToOri()
    end)
end

---@param messageData ChatData
function PageSingleChannelChat:SetTalkPrefabBaseData(talkPrefabGo, messageData)
    CommonHelper:SetPlayerIcon("PlayerIcon100", talkPrefabGo, CommonHelper:GetPlayerIconById(messageData:GetPlayerIcon()), CommonHelper:GetPlayerIconById(messageData:GetPlayerIconFrame(),nil,HeadIconAttrType.Frame), nil, self.uiModuleID)

    CommonHelper:SetText("###PlayerNameText", talkPrefabGo, messageData:GetName())

    ---@type qualifyingrank_config_cell
    local cfg = CommonHelper:GetRankCfgByScore(messageData:GetRankScore())
    CommonHelper:SetRankIconGroup("rankicon_s_1", talkPrefabGo, cfg)

    self:SetChatTimePrefabData(talkPrefabGo, messageData)

    local playerInfoCG,AddFriendBtn, BlackBtn = self:SetTalkPrefabBaseFunc(messageData, talkPrefabGo)

    local chatType = ChatDataManager:Get():GetChatType()
    local playerInfoBtn = CommonHelper:HButtonSetCallback("PlayerInfoBtn", talkPrefabGo, function(param)
        if messageData:GetSendId() == PlayerDataManager:Get():GetPlayerRID() then

        else
            if chatType == ChatType.World or chatType == ChatType.Local or chatType == ChatType.Club then
                local isShow = UIUtil.IsCanvasGroupShow(self.pagePlayerInfoCG)
                UIUtil.ShowCanvasGroup(self.pagePlayerInfoCG, not isShow)

                if not isShow then
                    CommonHelper:SetHButtonClick(AddFriendBtn, FriendDataManager:Get():GetFriendDataByID(messageData:GetSendId()) == nil, true)
                    CommonHelper:SetHButtonClick(BlackBtn, FriendDataManager:Get():IsBlackListPlayer(messageData:GetSendId()) == nil, true)

                    local infoParent = UIUtil.GetChild("InfoParent", talkPrefabGo.gameObject)
                    self:ChangeChildToSelf(infoParent, playerInfoCG)

                    local pos = CommonHelper:GetObjRectPos(playerInfoCG.gameObject)
                    local pageCenterSizeDelta = CommonHelper:GetObjSizeData(playerInfoCG.gameObject)
                    local pageSizeDeltaY = CSScreen.height
                    if pageCenterSizeDelta.y - pos.y > pageSizeDeltaY then
                        pos = pageCenterSizeDelta.y * 0.5 - pageSizeDeltaY
                        CommonHelper:SetObjRectPos(playerInfoCG.gameObject, 1263 + pageCenterSizeDelta.x * 0.5, pos)
                    end
                else
                    self:ChangeChildToOri()
                end
            end
        end
    end)
    CommonHelper:SetHButtonClick(playerInfoBtn, not RaceRoomManager:Get():IsInRoom(), true)
end

---@param messageData ChatData @设置聊天的prefab信息
function PageSingleChannelChat:SetTalkPrefabData(loopListViewItem2Script, messageData, preMsgData)

    local talkPrefabGo = loopListViewItem2Script.gameObject

    self:SetTalkPrefabBaseData(talkPrefabGo, messageData)

    CommonHelper:SetGameObjectActive("line",talkPrefabGo,false)
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
        CommonHelper:SetTextMesh("###ChatContentText", talkPrefabGo,messageData:GetChatImageSpanContent(),true)
    end

    ------------设置padding 和time 的关闭 和content的位置-----------

    CommonHelper:SetGameObjectActive("TranslateBtn",talkPrefabGo,false)
    CommonHelper:SetGameObjectActive("###ChatTranslateContentText",talkPrefabGo,false)
    CommonHelper:SetGameObjectActive("line",talkPrefabGo,false)

    local isShowTime = self:GetIsTimeShow(talkPrefabGo, messageData, preMsgData)

    CommonHelper:ImageChangeSizeByGo(talkPrefabGo)

    local sizeDelta = CommonHelper:GetRectSizeData("###ChatContentText", talkPrefabGo)

    sizeDelta = isShowTime == true and Vector2(770, 200 + sizeDelta.y) or Vector2(770, 110 + sizeDelta.y)
    CommonHelper:SetObjRectSizeDelta(talkPrefabGo, sizeDelta)

    sizeDelta = isShowTime == true and -106 or -20  --106 是有时间显示的时候和顶部的距离，-20是没有时间显示的时候和顶部的距离
    CommonHelper:SetRectPosByName("Center", talkPrefabGo, nil, sizeDelta)
end


---@param chatData ChatData
function PageSingleChannelChat:SetTalkPrefabBaseFunc(chatData, itemObj)
    if chatData:GetSendId() ~= PlayerDataManager:Get():GetPlayerRID() then

        local playerInfoCG = UIUtil.GetTypeChildWightByParent("PlayerInfoCG", itemObj, typeof(CanvasGroup))
        if playerInfoCG~=nil then
            UIUtil.ShowCanvasGroup(playerInfoCG, false)
        end

        CommonHelper:HButtonSetCallback("InfoBtn", itemObj, function(param)
            --UIManager:Get():ClosePopup()--关闭chatView
            UIUtil.ShowCanvasGroup(playerInfoCG, false)
            FriendSubsystem:Get():SendMsg_GetPlayerInfo(chatData:GetSendId())
            self:ChangeChildToOri()
        end)

        local AddFriendBtn = CommonHelper:HButtonSetCallback("AddFriendBtn", itemObj, function(param)
            local cfg = nil
            if ClientDataManager:Get().IsConfig2 then
                cfg=CommonHelper:GetTableDataByID(ConfigNames.functionlist2_config, GameFunction.Friend)
            else
                cfg=CommonHelper:GetTableDataByID(ConfigNames.functionlist_config, GameFunction.Friend)
            end
            if chatData:GetPlayerLevel() < cfg.level then
                CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.OtherFriendLocked))
            else
                FriendSubsystem:Get():SendMsg_AddFriends(chatData:GetSendId())
            end
            self:ChangeChildToOri()
            UIUtil.ShowCanvasGroup(self.pagePlayerInfoCG, false)
        end)

        local BlackBtn = CommonHelper:HButtonSetCallback("BlackBtn", itemObj, function(param)
            self:OnBlackBtnClick(chatData:GetSendId(),chatData:GetName(),chatData:GetPlayerIcon(),chatData:GetPlayerIconFrame())
            self:ChangeChildToOri()
            UIUtil.ShowCanvasGroup(self.pagePlayerInfoCG, false)
        end)

        return playerInfoCG, AddFriendBtn, BlackBtn
    end
end

function PageSingleChannelChat:OnBlackBtnClick(playerId,nickName,icon,iconframe)
    local tips = FriendDataManager:Get():GetFriendDataByID(playerId) == nil and CommonHelper:GetTempStr_Default(TemplateStringID.BlackStranger) or CommonHelper:GetTempStr_Default(TemplateStringID.BlackFriend)

    local boxFunc = function()
        local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, tips)
        if ret == MessageBoxHelp.BtnType.OK then
            FriendDataManager:Get():SetFriendType(FriendType.BlackFriendInChatPlayerInfo)
            FriendSubsystem:Get():SendMsg_AddBlacklist(playerId,nickName,icon,iconframe)
        end
    end
    MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
end

---@param messageData ChatData @设置系统通知的prefab信息
function PageSingleChannelChat:SetNotifyPrefabData(loopListViewItem2Script, messageData)
    CommonHelper:SetText("###ContentText", loopListViewItem2Script.gameObject, messageData:GetChatContent())
end

---@param messageData ChatData
function PageSingleChannelChat:SetChatTimePrefabData(chatTimePrefab, messageData)
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

---@param messageData ChatData
function PageSingleChannelChat:SetRoomInvitePrefabData(loopListViewItem2Script, messageData, preMsgData)
    local roomInvitePrefab = loopListViewItem2Script.gameObject

    self:SetTalkPrefabBaseData(roomInvitePrefab, messageData)
    ---@type RaceRoomShareData
    local invitation = messageData:GetInvitation()

    CommonHelper:SetText("###RoomNameText", roomInvitePrefab, invitation.name)
    CommonHelper:SetText("###RoomNumText", roomInvitePrefab, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.NumComNum), invitation.joinNum, invitation.maxNum))
    --CommonHelper:SetText("RaceTypeText", roomInvitePrefab, invitation[4] == 5 and "五赛道" or "三赛道")
    CommonHelper:SetGameObjectActive("RoomPwImage", roomInvitePrefab, invitation.pwd == "true")

    ------------设置padding 和time 的关闭 和content的位置-----------

    local isShowTime = self:GetIsTimeShow(roomInvitePrefab, messageData, preMsgData)
    if isShowTime then
        CommonHelper:SetObjRectSizeDelta(roomInvitePrefab, Vector2(770, 310))
    else
        CommonHelper:SetObjRectSizeDelta(roomInvitePrefab, Vector2(770, 200))
    end

    local JoinBtn = CommonHelper:HButtonSetCallback("JoinBtn", roomInvitePrefab, function()
        if RaceRoomManager:Get():GetPlayerDataByID(PlayerDataManager:Get():GetPlayerRID()) ~= nil then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceRoomHaveInRoom))
        elseif CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) - math.floor(messageData:GetSendTimeUnix() * 0.001) >= 180 then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.LinkFail))
        else
            UIManager:Get():ClosePopup()
            invitation.id = tonumber(invitation.id)
            invitation.pwd = invitation.pwd == "true"
            SkipModuleHelper:Get():ToRaceRoomDetail(invitation.id, invitation.pwd)
        end
    end)
end

---@param messageData ChatData
function PageSingleChannelChat:SetClubInvitePrefabData(loopListViewItem2Script, messageData, preMsgData)
    local clubInvitePrefab = loopListViewItem2Script.gameObject

    self:SetTalkPrefabBaseData(clubInvitePrefab, messageData)
    ---@type ClubShareData
    local invitation = messageData:GetInvitation()

    CommonHelper:SetPlayerIcon("ClubIcon", clubInvitePrefab, CommonHelper:GetPlayerIconById(tonumber(invitation.icon), HeadIconType.ClubIcon) .. ".png", nil, nil, self.uiModuleID)
    CommonHelper:SetText("###ClubNameText", clubInvitePrefab, messageData:GetClubName())
    CommonHelper:SetText("###ClubNumText", clubInvitePrefab, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.NumComNum), invitation.count, invitation.maxCount))

    ------------设置padding 和time 的关闭 和content的位置-----------

    local isShowTime = self:GetIsTimeShow(clubInvitePrefab, messageData, preMsgData)
    if isShowTime then
        CommonHelper:SetObjRectSizeDelta(clubInvitePrefab, Vector2(770, 310))
    else
        CommonHelper:SetObjRectSizeDelta(clubInvitePrefab, Vector2(770, 200))
    end

    CommonHelper:HButtonSetCallback("JoinBtn", clubInvitePrefab, function()
        ClubSubsystem:Get():SendMsg_GuildJoin(tonumber(messageData:GetClubId()), ClubApplyType.Apply)
    end)
end

---@param messageData ChatData
function PageSingleChannelChat:SetChallengeMatchPrefabData(loopListViewItem2Script, messageData, preMsgData)
    local clubInvitePrefab = loopListViewItem2Script.gameObject

    self:SetTalkPrefabBaseData(clubInvitePrefab, messageData)
    ---@type ClubShareData
    local invitation = messageData:GetInvitation()
    CommonHelper:SetPlayerIcon("ClubIcon", clubInvitePrefab, CommonHelper:GetPlayerIconById(tonumber(invitation.icon), HeadIconType.ClubIcon) .. ".png", nil, nil, self.uiModuleID)
    CommonHelper:SetText("###ClubNameText", clubInvitePrefab, messageData:GetClubName())
    CommonHelper:SetText("###ChallengeMatchIDText", clubInvitePrefab, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.NumComNum), invitation.count, invitation.maxCount))

    ------------设置padding 和time 的关闭 和content的位置-----------

    local isShowTime = self:GetIsTimeShow(clubInvitePrefab, messageData, preMsgData)
    if isShowTime then
        CommonHelper:SetObjRectSizeDelta(clubInvitePrefab, Vector2(770, 310))
    else
        CommonHelper:SetObjRectSizeDelta(clubInvitePrefab, Vector2(770, 200))
    end

    CommonHelper:HButtonSetCallback("JoinBtn", clubInvitePrefab, function()
        ClubSubsystem:Get():SendMsg_GuildJoin(tonumber(messageData:GetClubId()), ClubApplyType.Apply)
    end)
end

---@param messageData ChatData
function PageSingleChannelChat:GetIsTimeShow(talkPrefabGo, messageData, preMsgData)
    local isShowTime = false
    if preMsgData == nil then
        isShowTime = messageData:GetChatType() == ChatType.Private
    else
        local chatTime = math.floor((messageData:GetSendTimeUnix() - preMsgData:GetSendTimeUnix()) * 0.001)
        isShowTime = chatTime >= ChatDataManager:Get():GetChatTimeInterval()
    end
    CommonHelper:SetGameObjectActive("ChatTime", talkPrefabGo, isShowTime)

    return isShowTime
end
--}}}


--{{{聊天按钮功能
function PageSingleChannelChat:OnSendBtnClick()
    --local banTalkTime = PlayerDataManager:Get():GetBanTalkLeftTimeDl()
    --
    --if banTalkTime == ChatBanTime.BanForever then
    --    CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChatBanForever))
    --    CommonHelper:InputFieldSetValue(self.ChatInputField, "")
    --    return
    --else
    --    if CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) < banTalkTime then
    --        local date = CommonHelper:ConvertIntToDataTime(banTalkTime * 1000)
    --        local dateStr = date:ToString("yyyy:MM:dd HH:mm:ss")
    --        local str = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrComStr), "您被禁言到", dateStr)
    --        CommonTipsHelper:ShowCenterTips(str)
    --        CommonHelper:InputFieldSetValue(self.ChatInputField, "")
    --        return
    --    end
    --end

    self:ChatInputFieldEvent()
    CommonHelper:InputFieldSetValue(self.ChatInputField, "")
end

function PageSingleChannelChat:ChatInputFieldEvent()
    local isNull = CommonHelper:IsNullOrEmpty(CommonHelper:InputFieldGetValue(self.ChatInputField))
    if not isNull then
        self:HandleShareInput(self.ChatInputField)
        CommonHelper:CSGameObjectSetActive(self.timeImage, true)
        local chatType = ChatDataManager:Get():GetChatType()
        ChatDataManager:Get():SetTimerIdOrTimeByChatType(chatType, ChatTimeOrId.Time)
        self:SetChatRefreshTime()
    else
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ClubChatMessageCanNotNull))
    end
end

function PageSingleChannelChat:HandleShareInput(inputField)
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
            self:OnSendBtnFunc(inputField.text)
        end
   -- end
end

function PageSingleChannelChat:OnSendBtnFunc(inputText)
    local chatType = ChatDataManager:Get():GetChatType()
    if chatType == ChatType.Private then
        --FriendSubsystem:Get():SendMsg_PrivateChatToOther(ChatDataManager:Get():GetCurSelectPrivateId(), inputText, ChatOrLinkType.Chat)
        ChatSubsystem:Get():SendMsg_ChatData(chatType, inputText, ChatDataManager:Get():GetCurSelectPrivateId())
    elseif chatType == ChatType.PVPRoom then
        --ChatSubsystem:Get():SendMsg_RoomChat(chatType, inputText, ChatOrLinkType.Chat)
        ChatSubsystem:Get():SendMsg_ChatData(chatType, inputText, 0)
    elseif chatType == ChatType.Club then
        --ChatSubsystem:Get():SendMsg_ClubChat(chatType, inputText, ChatOrLinkType.Chat)
        ChatSubsystem:Get():SendMsg_ChatData(chatType, inputText, 0)
    else
        --ChatSubsystem:Get():SendMsg_PlayerChatReq(chatType, inputText, ChatOrLinkType.Chat)
        ChatSubsystem:Get():SendMsg_ChatData(chatType, inputText, 0)
    end
end

function PageSingleChannelChat:SetChatRefreshTime()
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

function PageSingleChannelChat:StopTimer(chatType)
    chatType = chatType or ChatDataManager:Get():GetChatType()
    local timeId = ChatDataManager:Get():GetTimerIdOrTimeByChatType(chatType, ChatTimeOrId.TimeId)
    if timeId ~= -1 then
        print("chatType:" .. tostring(chatType) .. "停止了了一个计时器,timeId是:" .. timeId)
        TimerManager:Get():StopTimer(timeId)
        ChatDataManager:Get():RemoveTimeIdByChatType(chatType, ChatTimeOrId.TimeId)
    end
end
--}}}


function PageSingleChannelChat:ClearData()
    CommonHelper:ReleasePool(self.uiModuleID)
end