function ChatViewData:InitPrivateList(playerId)

    if playerId ~= -1 then
        ChatDataManager:Get():SetCurSelectPrivateId(playerId)
    end
    local lastSelectImage = nil
    local count = ChatDataManager:Get():GetPlayerDataCount()

    local UpdateFunc = function(dataIndex, itemObj, scroll)

        ---@type ChatPlayerData
        local chatPlayerData = ChatDataManager:Get():GetPlayerDataByIndex(dataIndex + 1)

        local FriendInfoSelectImage = CommonHelper:SetGameObjectActive("FriendSelectImage", itemObj, chatPlayerData:GetPlayerId() == ChatDataManager:Get():GetCurSelectPrivateId())

        if chatPlayerData:GetPlayerId() == ChatDataManager:Get():GetCurSelectPrivateId() then
            lastSelectImage = FriendInfoSelectImage
            CommonHelper:SetText("PrivateImage/###playerNameText", self.parentPrefab, chatPlayerData:GetPlayerName())
            self:InitChatScrollList(ChatDataManager:Get():GetChatType(), chatPlayerData:GetPlayerId())
            ChatDataManager:Get():UpdateRedDicAndRefresh(chatPlayerData:GetPlayerId(), false)
        end
        local icon= CommonHelper:GetPlayerIconById(chatPlayerData:GetPlayerIcon())
        local frame = CommonHelper:GetPlayerIconById(chatPlayerData:GetPlayerIconFrame(),nil,HeadIconAttrType.Frame)
        CommonHelper:SetPlayerIcon("PlayerIcon100", itemObj, icon,frame, nil, self.uiModuleID, chatPlayerData:GetLeaveTimeUnix() > 0)

        CommonHelper:SetText("###PlayerNameText", itemObj, tostring(chatPlayerData:GetPlayerName()))
        local PlayerOnlineText = CommonHelper:SetText("###PlayerOnlineText", itemObj, chatPlayerData:GetLeaveTimeUnix() > 0 and CommonHelper:GetTempStr_Default(TemplateStringID.OutLine) or CommonHelper:GetTempStr_Default(TemplateStringID.OnLine))
        CommonHelper:SetTextColor(PlayerOnlineText, online and "00FF00" or "FFFFFF")

        local image = UIUtil.GetTypeChildWightByParent("FriendOnlineImage", itemObj, typeof(Image))
        CommonHelper:SetImageColor(image, chatPlayerData:GetLeaveTimeUnix() < 0 and "00FF00" or "FFFFFF")

        local score = chatPlayerData:GetRankScore() == nil and 0 or chatPlayerData:GetRankScore()
        ---@type qualifyingrank_config_cell
        local cfg = CommonHelper:GetRankCfgByScore(score)
        CommonHelper:SetRankIconGroup("rankicon_s_1", itemObj, cfg)

        CommonHelper:SetGameObjectActive("RedPointModule", itemObj, ChatDataManager:Get():GetRedById(chatPlayerData:GetPlayerId()) ~= nil)

        CommonHelper:HButtonSetCallback("ViewDetailBtn", itemObj, function(param)
            if lastSelectImage ~= nil then
                CommonHelper:CSGameObjectSetActive(lastSelectImage, false)
            end
            CommonHelper:CSGameObjectSetActive(FriendInfoSelectImage, true)
            lastSelectImage = FriendInfoSelectImage
            local chatType = ChatDataManager:Get():GetChatType()

            ChatDataManager:Get():SetCurSelectPrivateId(chatPlayerData:GetPlayerId())

            CommonHelper:SetGameObjectActive("TipText", self.parentPrefab, false)

            CommonHelper:SetGameObjectActive("PrivateImage", self.parentPrefab, true)
            CommonHelper:SetText("PrivateImage/###playerNameText", self.parentPrefab, chatPlayerData:GetPlayerName())

            UIUtil.ShowCanvasGroup(self.ChatListCanvasGroup, true)
            UIUtil.ShowCanvasGroup(self.BottomCanvasGroup, true)
            CommonHelper:SetListItemCount(self.LoopListView2, 0)
            self:InitChatScrollList(chatType, chatPlayerData:GetPlayerId())

            ChatDataManager:Get():UpdateRedDic(chatPlayerData:GetPlayerId())
        end)

    end
    CommonHelper:InitMoreRowScrollView(self.FriendListScrollView, count, 1, UpdateFunc, true)
end

function ChatViewData:UpdatePrivateList()
    CommonHelper:MoreRowView_RefreshCurList(self.FriendListScrollView, false)
end
