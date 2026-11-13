---@class PageMainChat
PageMainChat = class("PageMainChat")

function PageMainChat:initialize()

end

function PageMainChat:InitData(chatType, parentPref, uiModuleID)
    self.parentPref = parentPref
    self.uiModuleID = uiModuleID

    self.chatType = -1

    self:CacheData()
    self:InitViewBtnFunc()
end

function PageMainChat:CacheData()
    self.chatTog = {}

    for i = 1, 3 do
        local tog = CommonHelper:HButtonSetCallback("TogChat" .. i, self.parentPref, function()
            self:OnChatTogClick(i)
        end)
        table.insert(self.chatTog, tog)
    end

    self.chatSysList = UIUtil.GetTypeChildWightByParent("ChatList", self.parentPref, typeof(MoreRowScrollView))

    self:OnChatTogClick(1)

    CommonHelper:CSGameObjectSetActive(self.chatTog[3].gameObject, ClubDataManager:Get():IsHadClub())
    CommonHelper:CSGameObjectSetActive(self.chatTog[3].gameObject, false)
end

function PageMainChat:OnChatTogClick(idx)
    for i = 1, #self.chatTog do
        local text = UIUtil.GetTypeChildWightByParent("TogText", self.chatTog[i].gameObject, typeof(Text))
        CommonHelper:SetTextColor(text, idx == i and "feca2f" or "cccccc")
        CommonHelper:SetTextSize(text, idx == i and 30 or 28)
    end

    local chatType = self:GetChatTypeByIdx(idx)

    self.chatType = chatType
    self:InitChatList(chatType, -1)
end

function PageMainChat:InitChatList(chatType, playerId)
    if chatType ~= self.chatType then
        return
    end

    local count = ChatDataManager:Get():GetChatListCountByChatType(chatType, playerId)

    local UpdateFunc = function(dataIndex, itemObj, scroll)
        ---@type ChatData
        local chatData = ChatDataManager:Get():GetChatDataByIndexChatType(chatType, dataIndex + 1)
        if chatData==nil then
            print("PageMainChat:InitChatList   ",debug.traceback())
        else
            local content=nil
            if  chatData:GetMessageType()==ChatPrefabType.RoomInvite then
                content= CommonHelper:GetTempStr_Default(TemplateStringID.RoomInviteChatInfo)
            elseif chatData:GetMessageType()==ChatPrefabType.ClubInvite then
                content= CommonHelper:GetTempStr_Default(TemplateStringID.ClubInvite)
            elseif chatData:GetMessageType()==ChatPrefabType.ChallengeMatchInvite then
                content = CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatchInvite)
            else
                content = chatData:GetChatImageSpanContent() or chatData:GetChatContent()
            end

            if chatData:GetChatOrLinkType() == ChatOrLinkType.Link then
                local shareType = ChatDataManager:Get():GetChatShareType(content)
                if shareType == ShareType.ClubInvite then
                    content = CommonHelper:GetTempStr_Default(TemplateStringID.ClubInvite)
                elseif shareType == ShareType.RoomInvite then
                    content = CommonHelper:GetTempStr_Default(TemplateStringID.RoomInvite)
                elseif shareType == ShareType.ChallengeMatchInvite then
                    content = CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeMatchInvite)
                end
            end

            if chatData:GetMessageType() ~= ChatPrefabType.Notification then
                local title = self:GetTitleByChatType(chatType)
                content = string.format("<color=#E5AF23>[%s]</color>%s：%s", title, chatData:GetName(), content)
            end
            CommonHelper:SetTextMesh("###ChatText", itemObj,content,true)
            --local proText = UIUtil.GetTypeChildWightByParent("###ChatText", itemObj, typeof(TextMeshProUGUI))
            --proText.text = content
        end
    end
    CommonHelper:InitMoreRowScrollView(self.chatSysList, count, 1, UpdateFunc, true)
    CommonHelper:MoreRowView_ScrollToItem(self.chatSysList, count - 1)
end

function PageMainChat:InitViewBtnFunc()
    CommonHelper:HButtonSetCallback("ChatBtn", self.parentPref, function(hbtn)
        CommonHelper:SetUnlockFunc({ GameFunction.Chat }, function()
            UIManager:Get():ShowPersistentView("ChatView", CanvasType.MainCanvas, "ChatView")
            UINotify:Get():SendNotification(UINotifyEvent.ChatView_InitTogState, self.chatType)
        end)
    end)
end

function PageMainChat:GetChatTypeByIdx(idx)
    if idx == 1 then
        return ChatType.World
    elseif idx == 2 then
        return ChatType.Local
    elseif idx == 3 then
        return ChatType.Club
    end
end

function PageMainChat:GetTitleByChatType(chatType)
    if chatType == ChatType.World then
        return CommonHelper:GetTempStr_Default(TemplateStringID.ChatTypeWord)
    elseif chatType == ChatType.Local then
        return CommonHelper:GetTempStr_Default(TemplateStringID.ChatTypeLocal)
    elseif chatType == ChatType.Club then
        return CommonHelper:GetTempStr_Default(TemplateStringID.ChatTypeClub)
    end
end

function PageMainChat:ClearData()
    CommonHelper:ReleasePool(self.uiModuleID)
end


