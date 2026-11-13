---@class PageChatPlayerInfo
PageChatPlayerInfo = class("PageChatPlayerInfo")

function PageChatPlayerInfo:initialize()

end

function PageChatPlayerInfo:InitData(parentPref, uiModuleID)
    self.parentPref = parentPref
    self.uiModuleID = uiModuleID

    self:CacheViewData()
    self:InitViewBtnFunc()
end

function PageChatPlayerInfo:CacheViewData()
    ---@type ChatData
    self.chatData = nil
end

---@param child @child 就是玩家信息,playerInfoCG，originalParent 就是聊天的itemObj
function PageChatPlayerInfo:ChangeChildToSelf(originalParent, child)
    self.originalParent = originalParent
    self.child = child
    UIUtil.ShowCanvasGroup(self.child, true)
    UIUtil.SetParentGameObject(self.parentPref, child.gameObject, false)
end

function PageChatPlayerInfo:ChangeChildToOri()
    if self.originalParent ~= nil then
        UIUtil.ShowCanvasGroup(self.child, false)
        UIUtil.SetParentGameObject(self.originalParent, self.child.gameObject)
    end
end

---@param chatData ChatData
function PageChatPlayerInfo:InitViewInfo(chatData, posY)

    self.chatData = chatData

    CommonHelper:SetRectPosByName("PageCenter", self.parentPref, 98, posY)

    --CommonHelper:SetText("PlayerNameText", self.parentPref, chatData:GetName())
    ----CommonHelper:SetText("PlayerClubText", self.parentPref, CommonHelper:IsNullOrEmpty(chatData:GetClubName())==true and TemplateStringID.ClubNo or chatData:GetClubName())
    --CommonHelper:SetText("PlayerServerText", self.parentPref, chatData:GetServerName())
    --CommonHelper:SetText("PlayerLevelText", self.parentPref, tostring(chatData:GetPlayerLevel()))

    -----@type qualifyingrank_config_cell
    --local qualifyRankData = CommonHelper:GetRankCfgByScore(chatData:GetRankScore())
    --CommonHelper:GetComponentSetUITexture("PlayerGradeImage", self.parentPref, qualifyRankData.icon, self.uiModuleID)

    CommonHelper:SetHButtonClick(self.AddFriendBtn, FriendDataManager:Get():GetFriendDataByID(self.chatData:GetSendId()) == nil, true)
    CommonHelper:SetHButtonClick(self.BlackBtn, FriendDataManager:Get():IsBlackListPlayer(self.chatData:GetSendId()) == nil, true)

    --CommonHelper:SetHButtonClick(self.DelFriendBtn, FriendDataManager:Get():GetFriendDataByID(self.chatData:GetSendId()) ~= nil, true)
    --CommonHelper:SetHButtonClick(self.InviteClubBtn, ClubDataManager:Get():IsHadClub() and chatData:GetClubId() == 0, true)
end

function PageChatPlayerInfo:SetBtnInfo()
    if self.chatData == nil then
        return
    end
    CommonHelper:SetHButtonClick(self.AddFriendBtn, FriendDataManager:Get():GetFriendDataByID(self.chatData:GetSendId()) == nil, true)
    --CommonHelper:SetHButtonClick(self.DelFriendBtn, FriendDataManager:Get():GetFriendDataByID(self.chatData:GetSendId()) ~= nil, true)
    CommonHelper:SetHButtonClick(self.BlackBtn, FriendDataManager:Get():IsBlackListPlayer(self.chatData:GetSendId()) == nil, true)
end

function PageChatPlayerInfo:InitViewBtnFunc()
    --self.InfoBtn = CommonHelper:HButtonSetCallback("InfoBtn", self.parentPref, function(param)
    --    UIManager:Get():ClosePopup()--关闭chatview
    --    FriendSubsystem:Get():SendMsg_GetPlayerInfo(self.chatData:GetSendId())
    --end)

    --self.ChatBtn = CommonHelper:HButtonSetCallback("ChatBtn", self.parentPref, function(param)
    --    self:OnChatBtnClick()
    --end)

    --self.AddFriendBtn = CommonHelper:HButtonSetCallback("AddFriendBtn", self.parentPref, function(param)
    --    if self.chatData:GetPlayerLevel() < CommonHelper:GetTableDataByID(ConfigNames.functionlist_config, UnlockID.Friend).level then
    --        CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.OtherFriendLocked))
    --    else
    --        FriendSubsystem:Get():SendMsg_AddFriends(self.chatData:GetSendId())
    --    end
    --end)

    --self.DelFriendBtn = CommonHelper:HButtonSetCallback("DelFriendBtn", self.parentPref, function(param)
    --    self:OnDelFriendBtnClick(self.chatData:GetSendId())
    --end)

    --self.BlackBtn = CommonHelper:HButtonSetCallback("BlackBtn", self.parentPref, function(param)
    --    self:OnBlackBtnClick(self.chatData:GetSendId())
    --end)

    --self.InviteClubBtn = CommonHelper:HButtonSetCallback("InviteClubBtn", self.parentPref, function(param)
    --
    --end)

    --self.BtnClose = CommonHelper:HButtonSetCallback("BtnClose", self.parentPref, function(param)
    --    UIManager:Get():ClosePopup()
    --end)
end

function PageChatPlayerInfo:OnChatBtnClick()

    UINotify:Get():SendNotification(UINotifyEvent.ChatView_InitTogState, ChatType.Private)

    local chatPlayerData = ChatDataManager:Get():AddPlayerData(self.chatData:GetPlayerData())
    ChatDataManager:Get():SetCurSelectPrivateId(chatPlayerData:GetPlayerId())

    UINotify:Get():SendNotification(UINotifyEvent.ChatView_InitPrivateList, chatPlayerData:GetPlayerId())

    local userdata = {}
    userdata.chatType = ChatType.Private
    userdata.playerId = chatPlayerData:GetPlayerId()

    UINotify:Get():SendNotification(UINotifyEvent.ChatView_InitChatScrollList, userdata)
end

function PageChatPlayerInfo:OnDelFriendBtnClick(playerId)
    local boxFunc = function()
        local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, CommonHelper:GetTempStr_Default(TemplateStringID.IsDelFriend), CommonHelper:GetTempStr_Default(TemplateStringID.DeleteFriend), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), true)
        if ret == MessageBoxHelp.BtnType.OK then
            FriendDataManager:Get():SetFriendType(FriendType.DelFriendInChatPlayerInfo)
            FriendSubsystem:Get():SendMsg_DelFriends(playerId)
        end
    end
    MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
end

function PageChatPlayerInfo:OnBlackBtnClick(playerId,nickName,icon,iconframe)
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

function PageChatPlayerInfo:ClearData()
    CommonHelper:ReleasePool(self.uiModuleID)
end


