function Page_BattleBase:CacheShortCutData()
    if self.chatShortCutData == nil then
        self.chatShortCutData = ChatShortCutData()

        self.chatShortCutData:CacheViewData(self.parentPref, self.moduleId)

        self.chatShortCutData:SetExtraInfo(BattleDyDataManager:Get():GetSelfCarData():GetCarId())

        self.ShortCutCanvasGroup = UIUtil.GetTypeChildWightByParent("ChatShortCutView", self.parentPref, typeof(CanvasGroup))
    end

    self:CacheChatSysData()
end

function Page_BattleBase:InitShortCutData()
    self.chatShortCutData:InitShortInfo()
end

function Page_BattleBase:UpdateScrollList(userdata)
    self.chatShortCutData:UpdateScrollList(userdata)
end

function Page_BattleBase:ClearShortCutData()
    if self.chatShortCutData ~= nil then
        self.chatShortCutData:Clear()
        self.chatShortCutData = nil
    end
end

function Page_BattleBase:CacheChatSysData()
    self.chatTog = {}

    for i = 1, 3 do
        local tog = CommonHelper:HButtonSetCallback("TogChat" .. i, self.parentPref, function()
            self:OnChatTogClick(i)
        end)
        table.insert(self.chatTog, tog)
    end

    self.chatSysList = UIUtil.GetTypeChildWightByParent("ChatList", self.parentPref, typeof(MoreRowScrollView))

    self:OnChatTogClick(2)
end

function Page_BattleBase:OnChatTogClick(idx)
    for i = 1, #self.chatTog do
        local text = UIUtil.GetTypeChildWightByParent("TogText", self.chatTog[i].gameObject, typeof(Text))
        CommonHelper:SetTextColor(text, idx == i and "FFFF00" or "FFFFFF")
    end
    self:GetChatTypeByIdx(idx)
    self:InitChatList(self.chatShortCutData:GetChatType())
end

function Page_BattleBase:GetChatTypeByIdx(idx)
    if idx == 1 then
        self.chatShortCutData:SetChatType(ChatType.ShortCut)
    elseif idx == 2 then
        self.chatShortCutData:SetChatType(ChatType.Explain)
    elseif idx == 3 then

    end
end

function Page_BattleBase:InitChatList(chatType)
    if self.chatShortCutData == nil then
        return
    end
    if chatType == self.chatShortCutData:GetChatType() then
        local count = chatType == ChatType.ShortCut and ChatDataManager:Get():GetChatListCountByChatType(chatType, -1) or ChatDataManager:Get():GetExplainDataCount()

        local UpdateFunc = function(dataIndex, itemObj, scroll)
            ---@type ChatData
            local chatData = chatType == ChatType.ShortCut and ChatDataManager:Get():GetChatDataByIndexChatType(chatType, dataIndex + 1) or ChatDataManager:Get():GetExplainByIdx(dataIndex + 1)

            local content = chatType == ChatType.ShortCut and chatData:GetChatContent() or chatData
            if chatType == ChatType.ShortCut then
                local carDyData = BattleDyDataManager:Get():GetCarDataById(chatData:GetChatIndex())
                local color = CommonHelper:GetTrackColorByTrackIdx(carDyData:GetCarTrackId())
                content = string.format("<color=#%s>[%d]%s</color>：%s", color, carDyData:GetCarTrackId(), carDyData:GetPlayerName(), content)
            elseif chatType == ChatType.Explain then

            end
            CommonHelper:SetText("###ChatText", itemObj, content)
        end
        CommonHelper:InitMoreRowScrollView(self.chatSysList, count, 1, UpdateFunc, true)
        CommonHelper:MoreRowView_ScrollToItem(self.chatSysList, count - 1)
    end
end
