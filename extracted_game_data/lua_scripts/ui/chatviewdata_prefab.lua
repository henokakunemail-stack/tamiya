---@param messageData ChatData
---@param chatPrefabType ChatPrefabType  @创建聊天消息的prefab
function ChatViewData:CreateChatPrefabByType(chatPrefabType, messageData, loopListView2)
    local loopListViewItem2
    if chatPrefabType == ChatPrefabType.Talk then
        if messageData:GetSendId() == PlayerDataManager:Get():GetPlayerRID() then
            loopListViewItem2 = loopListView2:NewListViewItem("ChatSelf")
        else
            loopListViewItem2 = loopListView2:NewListViewItem("ChatOther")
        end
    elseif chatPrefabType == ChatPrefabType.Notification then
        loopListViewItem2 = loopListView2:NewListViewItem("ClubNotification")
        --elseif chatPrefabType == ChatPrefabType.Time then
        --    loopListViewItem2 = loopListView2:NewListViewItem("ChatTime")
    elseif chatPrefabType == ChatPrefabType.RoomInvite then
        if messageData:GetSendId() == PlayerDataManager:Get():GetPlayerRID() then
            loopListViewItem2 = loopListView2:NewListViewItem("ChatRoomInviteSelf")
        else
            loopListViewItem2 = loopListView2:NewListViewItem("ChatRoomInviteOther")
        end
    elseif chatPrefabType == ChatPrefabType.ClubInvite then
        if messageData:GetSendId() == PlayerDataManager:Get():GetPlayerRID() then
            loopListViewItem2 = loopListView2:NewListViewItem("ChatClubInviteSelf")
        else
            loopListViewItem2 = loopListView2:NewListViewItem("ChatClubInviteOther")
        end
    elseif chatPrefabType == ChatPrefabType.ChallengeMatchInvite then
        if messageData:GetSendId() == PlayerDataManager:Get():GetPlayerRID() then
            loopListViewItem2 = loopListView2:NewListViewItem("ChatChallengeMatchInviteSelf")
        else
            loopListViewItem2 = loopListView2:NewListViewItem("ChatChallengeMatchInviteOther")
        end
    end
    return loopListViewItem2
end

------------------根据消息的类型，设置不同prefab的数据
---@param chatPrefabType ChatPrefabType
function ChatViewData:SetItemDataByType(chatPrefabType, loopListViewItem2Script, messageData, preMsgData)
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
        self:SetChallengeMatchInvitePrefabData(loopListViewItem2Script, messageData, preMsgData)
    end
end

local lastSelectPInfoCG = nil
---@param messageData ChatData
function ChatViewData:SetTalkPrefabBaseData(talkPrefabGo, messageData, preMsgData)

    CommonHelper:SetPlayerIcon("PlayerIcon100", talkPrefabGo, CommonHelper:GetPlayerIconById(messageData:GetPlayerIcon()), CommonHelper:GetPlayerIconById(messageData:GetPlayerIconFrame(),nil,HeadIconAttrType.Frame), nil, self.uiModuleID)

    CommonHelper:SetText("###PlayerNameText", talkPrefabGo, messageData:GetName())

    ---@type qualifyingrank_config_cell
    local cfg = CommonHelper:GetRankCfgByScore(messageData:GetRankScore())
    CommonHelper:SetRankIconGroup("rankicon_s_1", talkPrefabGo, cfg)

    self:SetChatTimePrefabData(talkPrefabGo, messageData)

    local playerInfoCG, AddFriendBtn, BlackBtn ,BannedBtn = self:SetTalkPrefabBaseFunc(messageData, talkPrefabGo)

    local chatType = ChatDataManager:Get():GetChatType()
    local playerInfoBtn = CommonHelper:HButtonSetCallback("PlayerInfoBtn", talkPrefabGo, function(param)
        if messageData:GetSendId() == PlayerDataManager:Get():GetPlayerRID() then

        else
            if chatType == ChatType.World or chatType == ChatType.Local then
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
                        CommonHelper:SetObjRectPos(playerInfoCG.gameObject, 98 + pageCenterSizeDelta.x * 0.5, pos)
                    end
                else
                    self:ChangeChildToOri()
                end
            end
        end
    end)
    CommonHelper:SetHButtonClick(BannedBtn, HotfixHelper:IsWhite(), true)

    CommonHelper:SetHButtonClick(playerInfoBtn, not RaceRoomManager:Get():IsInRoom(), true)
end

---@param chatData ChatData
function ChatViewData:SetTalkPrefabBaseFunc(chatData, itemObj)
    if chatData:GetSendId() ~= PlayerDataManager:Get():GetPlayerRID() then

        local playerInfoCG = UIUtil.GetTypeChildWightByParent("PlayerInfoCG", itemObj, typeof(CanvasGroup))
        if playerInfoCG ~= nil then
            UIUtil.ShowCanvasGroup(playerInfoCG, false)
        end

        CommonHelper:HButtonSetCallback("InfoBtn", itemObj, function(param)
            UIUtil.ShowCanvasGroup(playerInfoCG, false)
            --if true  then
            --    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.LevelUnlock))
            --else
            --    FriendSubsystem:Get():SendMsg_GetPlayerInfo(chatData:GetSendId())
            --end
            UIManager:Get():ClosePopup()--关闭chatview
            PersonalHomeSubsystem:Get():SendLookHomeInfo(chatData:GetSendId())
            self:ChangeChildToOri()
        end)

        local AddFriendBtn = CommonHelper:HButtonSetCallback("AddFriendBtn", itemObj, function(param)
            CommonHelper:SetUnlockFunc({ GameFunction.Friend }, function()
                local level= CommonHelper:GetUnlockLevelByFunId(GameFunction.Friend)
                if chatData:GetPlayerLevel() < level then
                    CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.OtherFriendLocked))
                else
                    FriendSubsystem:Get():SendMsg_AddFriends(chatData:GetSendId())
                end
            end)
            self:ChangeChildToOri()
            UIUtil.ShowCanvasGroup(self.pagePlayerInfoCG, false)
        end)

        local BlackBtn = CommonHelper:HButtonSetCallback("BlackBtn", itemObj, function(param)
            if false    then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.LevelUnlock))
            else
                self:OnBlackBtnClick(chatData:GetSendId(),chatData:GetName(),chatData:GetPlayerIcon(),chatData:GetPlayerIconFrame())
            end
            self:ChangeChildToOri()
            UIUtil.ShowCanvasGroup(self.pagePlayerInfoCG, false)
        end)

       local BannedBtn = CommonHelper:HButtonSetCallback("BannedBtn", itemObj, function(param)

            self:ChangeChildToOri()
            UIUtil.ShowCanvasGroup(self.pagePlayerInfoCG, false)
        end)

        return playerInfoCG, AddFriendBtn, BlackBtn ,BannedBtn
    end
end

function ChatViewData:OnDelFriendBtnClick(playerId)
    local boxFunc = function()
        local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, CommonHelper:GetTempStr_Default(TemplateStringID.IsDelFriend), CommonHelper:GetTempStr_Default(TemplateStringID.DeleteFriend), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), true)
        if ret == MessageBoxHelp.BtnType.OK then
            FriendDataManager:Get():SetFriendType(FriendType.DelFriendInChatPlayerInfo)
            FriendSubsystem:Get():SendMsg_DelFriends(playerId)
        end
    end
    MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
end

function ChatViewData:OnBlackBtnClick(playerId,nickName,icon,iconframe)
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

---@param messageData ChatData @设置聊天的prefab信息
function ChatViewData:SetTalkPrefabData(loopListViewItem2Script, messageData, preMsgData)
    local talkPrefabGo = loopListViewItem2Script.gameObject

    self:SetTalkPrefabBaseData(talkPrefabGo, messageData, preMsgData)

    local shareData = messageData:GetPShareInfo()
    if #shareData > 0 then
        --CommonHelper:InitInputFieldText(xText, shareData)
        --local actionList = {}
        -----@param param ChatShareParam
        --local onClick = function(param)
        --    print("这是点击分享链接的内容-------------------" .. param.shareName)
        --end
        --table.insert(actionList, onClick)
        --CommonHelper:RegisterEventForHyperlinks(xText, actionList, shareData)
    else
        CommonHelper:SetTextMesh("###ChatContentText", talkPrefabGo,messageData:GetChatImageSpanContent(),true)
        if messageData:IsTranslate() and messageData:IsShow() then
            CommonHelper:SetTextMesh("###ChatTranslateContentText", talkPrefabGo,messageData:GetChatTranslateContent(),true)
        end
    end
    CommonHelper:HButtonSetCallback("TranslateBtn", talkPrefabGo, function(param)
        local index = loopListViewItem2Script.ParentListView:GetCurItemIndex()+1
        local count = loopListViewItem2Script.ParentListView.ShownItemCount
        UINotify:Get():SendNotification(UINotifyEvent.ChatView_Word_Translate,{ index,count})
    end)
    CommonHelper:SetGameObjectActive("TranslateBtn",talkPrefabGo,HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.ChatTranslate))
    ------------设置padding 和time 的关闭 和content的位置-----------
    local isShowTime = self:GetIsTimeShow(talkPrefabGo, messageData, preMsgData)
    CommonHelper:SetGameObjectActive("###ChatTranslateContentText",talkPrefabGo,messageData:IsTranslate()and messageData:IsShow())
    --CommonHelper:SetGameObjectActive("line",talkPrefabGo,messageData:IsTranslate())
    CommonHelper:ImageChangeSizeByGo(talkPrefabGo)

    local sizeDelta = CommonHelper:GetRectSizeData("###ChatContentText", talkPrefabGo)
    local translateSizeDelta =Vector2.zero

    if messageData:IsTranslate() and messageData:IsShow() then
        translateSizeDelta =  CommonHelper:GetRectSizeData("###ChatTranslateContentText", talkPrefabGo)
    end
    sizeDelta = isShowTime == true and Vector2(770, 200 + sizeDelta.y+translateSizeDelta.y) or Vector2(770, 110 + sizeDelta.y+translateSizeDelta.y)
    CommonHelper:SetObjRectSizeDelta(talkPrefabGo, sizeDelta)

    sizeDelta = isShowTime == true and -106 or -20  --106 是有时间显示的时候和顶部的距离，-20是没有时间显示的时候和顶部的距离
    CommonHelper:SetRectPosByName("Center", talkPrefabGo, nil, sizeDelta)
end

---@param messageData ChatData @设置系统通知的prefab信息
function ChatViewData:SetNotifyPrefabData(loopListViewItem2Script, messageData)
    CommonHelper:SetText("###ContentText", loopListViewItem2Script.gameObject, messageData:GetChatContent())
end

---@param messageData ChatData
function ChatViewData:SetChatTimePrefabData(chatTimePrefab, messageData)
    local chatTime = math.floor(messageData:GetSendTimeUnix() )
    local date = CommonHelper:UnixTimeConvertTime(chatTime)
    local Day = tostring(date.Day)
    local Month = tostring(date.Month)
    local Year = tostring(date.Year)
    local Hour = tostring(date.Hour)
    if date.Hour < 10 then
        Hour = string.format("0%d", date.Hour)
    end

    local Minute = tostring(date.Minute)
    if date.Minute < 10 then
        Minute = string.format("0%d", date.Minute)
    end

    local time = string.format("%s.%s.%s %s:%s",Year,Month,Day, Hour, Minute)
    CommonHelper:SetText("###ChatTimeText", chatTimePrefab, time)
end

---@param messageData ChatData
function ChatViewData:SetRoomInvitePrefabData(loopListViewItem2Script, messageData, preMsgData)
    local roomInvitePrefab = loopListViewItem2Script.gameObject

    self:SetTalkPrefabBaseData(roomInvitePrefab, messageData)
    ---@type RaceRoomShareData
    local invitation = messageData:GetInvitation()
    log("  invitation.mapIcon      ",invitation.mapIcon)
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
            --elseif CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) - math.floor(messageData:GetSendTimeUnix() * 0.001) >= 180 then
            --    CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.LinkFail))
        else
            CommonHelper:SetUnlockFunc({ GameFunction.RaceRoom }, function()
                UIManager:Get():ClosePopup()
                invitation.id = tonumber(invitation.id)
                invitation.pwd = invitation.pwd == "true"
                SkipModuleHelper:Get():ToRaceRoomDetail(invitation.id, invitation.pwd)
            end, function()
                CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RoomInviteLevelNotEnough))
            end)
        end
    end)
end

---@param messageData ChatData
function ChatViewData:SetClubInvitePrefabData(loopListViewItem2Script, messageData, preMsgData)
    local clubInvitePrefab = loopListViewItem2Script.gameObject

    self:SetTalkPrefabBaseData(clubInvitePrefab, messageData)
    ---@type ClubShareData
    local invitation = messageData:GetInvitation()

    CommonHelper:GetComponentSetUITexture("clubIcon", clubInvitePrefab, CommonHelper:GetPlayerIconById(tonumber(invitation.icon), HeadIconType.ClubIcon) .. ".png", self.uiModuleID)
    CommonHelper:SetText("###ClubNameText", clubInvitePrefab, invitation.name)
    CommonHelper:SetText("###ClubNumText", clubInvitePrefab, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.NumComNum), invitation.count, invitation.maxCount))

    ------------设置padding 和time 的关闭 和content的位置-----------

    local isShowTime = self:GetIsTimeShow(clubInvitePrefab, messageData, preMsgData)
    if isShowTime then
        CommonHelper:SetObjRectSizeDelta(clubInvitePrefab, Vector2(770, 310))
    else
        CommonHelper:SetObjRectSizeDelta(clubInvitePrefab, Vector2(770, 200))
    end

    CommonHelper:HButtonSetCallback("JoinBtn", clubInvitePrefab, function()
        --if PlayerDataManager:Get():GetPlayerRID()~=messageData:GetSendId() then
            ClubSubsystem:Get():SendMsg_GuildJoin(messageData:GetClubId(), ClubApplyType.Apply)
        --end
    end)
end

---@param messageData ChatData  ---对抗赛预制体位置
function ChatViewData:SetChallengeMatchInvitePrefabData(loopListViewItem2Script, messageData, preMsgData)
    local challengeMatchPrefab = loopListViewItem2Script.gameObject

    self:SetTalkPrefabBaseData(challengeMatchPrefab, messageData)
    ---@type ChallengeMatchShareData
    local invitation = messageData:GetInvitation()

    CommonHelper:SetText("###ChallengeMatchIDText", challengeMatchPrefab,tostring(invitation.id) )
    --CommonHelper:SetText("###ClubNumText", challengeMatchPrefab, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.NumComNum), invitation.count, invitation.maxCount))

    ------------设置padding 和time 的关闭 和content的位置-----------

    local isShowTime = self:GetIsTimeShow(challengeMatchPrefab, messageData, preMsgData)
    if isShowTime then
        CommonHelper:SetObjRectSizeDelta(challengeMatchPrefab, Vector2(770, 310))
    else
        CommonHelper:SetObjRectSizeDelta(challengeMatchPrefab, Vector2(770, 200))
    end

    CommonHelper:HButtonSetCallback("JoinBtn", challengeMatchPrefab, function()
        --print("    这里添加加入挑战房间消息  invitation.id：  "..invitation.id)
        --print("    这里添加加入挑战房间消息  invitation.awardID：  "..invitation.awardID)
        --print("    这里添加加入挑战房间消息  invitation.awardID：  "..invitation.resultTime)
        local resultTime = CommonHelper:UnixTimeConvertTime(invitation.resultTime);
        local nowTime = CommonHelper:GetNowTime()
        local subTime = resultTime:Subtract(nowTime)
        if subTime.TotalMinutes<10 then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatchInviteOutTime))
        else
            UIManager:Get():ClosePopup()
            ChallengeMatchSubsystem:SendMsg_BattleDetail(invitation.id)
        end
    end)
end

---@param messageData ChatData
function ChatViewData:GetIsTimeShow(talkPrefabGo, messageData, preMsgData)
    local isShowTime = false
    if preMsgData == nil then
        isShowTime = messageData:GetChatType() == ChatType.Private
    else
        local chatTime = math.floor((messageData:GetSendTimeUnix() - preMsgData:GetSendTimeUnix()) * 0.001)
        isShowTime = chatTime >= ChatDataManager:Get():GetChatTimeInterval()
    end
    CommonHelper:SetGameObjectActive("ChatTime", talkPrefabGo, isShowTime)

    local pos = messageData:GetChatType() == ChatType.Private and 378 or 455
    local x = messageData:GetChatType() == ChatType.Private and 250 or 350

    pos = messageData:GetSendId() == PlayerDataManager:Get():GetPlayerRID() and -pos or pos

    CommonHelper:SetRectPosByName("ChatTime", talkPrefabGo, pos, nil)
    CommonHelper:SetRectSizeDeltaByName("Lline", talkPrefabGo, x, nil)
    CommonHelper:SetRectSizeDeltaByName("Rline", talkPrefabGo, x, nil)

    return isShowTime
end