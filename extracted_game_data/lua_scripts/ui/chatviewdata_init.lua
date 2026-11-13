---@class ChatViewData
ChatViewData = class("ChatViewData")

function ChatViewData:initialize()
end

function ChatViewData:InitData(chatViewPrefab, uiModuleID, sendBtnFunc, param)
    self.parentPrefab = chatViewPrefab
    self.uiModuleID = uiModuleID
    self.sendBtnFunc = sendBtnFunc
    self:CacheChatViewData()
    self:InitChatViewBtn()

    --FriendSubsystem:Get():SendMsg_GetBlackFriends()
end

function ChatViewData:CacheChatViewData()
    self.LoopListView2 = UIUtil.GetTypeChildWightByParent("ChatListPreView", self.parentPrefab, typeof(LoopListView2))
    --self.ChatInputField = UIUtil.GetTypeChildWightByParent("InputChat", self.parentPrefab, typeof(TMP_InputField))
    self.ChatInputField = UIUtil.GetTypeChildWightByParent("InputChatWithEmoji", self.parentPrefab, typeof(InputField))
    self.LoopListView2Scroll = UIUtil.GetGameobjectComponent(self.LoopListView2.gameObject, typeof(ScrollRect))

    self.FriendListScrollView = UIUtil.GetTypeChildWightByParent("FriendPrivateList", self.parentPrefab, typeof(MoreRowScrollView))
    self.ChatViewPrivateCG = UIUtil.GetTypeChildWightByParent("ChatViewPrivateCG", self.parentPrefab, typeof(CanvasGroup))
    self.ChatListCanvasGroup = UIUtil.GetTypeChildWightByParent("ChatListCG", self.parentPrefab, typeof(CanvasGroup))
    --self.TogGroupCanvasGroup = UIUtil.GetTypeChildWightByParent("TogGroup", self.parentPrefab, typeof(CanvasGroup))
    self.BgCanvasGroup = UIUtil.GetTypeChildWightByParent("ChatViewCenterCG", self.parentPrefab, typeof(CanvasGroup))
    self.BottomCanvasGroup = UIUtil.GetTypeChildWightByParent("ChatViewBottomCG", self.parentPrefab, typeof(CanvasGroup))

    self.timeImage = CommonHelper:SetGameObjectActive("TimeImage", self.parentPrefab, false)

    self.ChatViewOtherParent = UIUtil.GetChild("ChatViewOtherParent", self.parentPrefab)

    self:CachePlayerInfoData()
    --CommonHelper:InputFieldSetCharacterValue(self.ChatInputField, ChatDataManager:Get():GetCharacterLimit())
end

function ChatViewData:InitChatViewBtn()
    self.PageEmoji = PageEmoji()
    self.PageEmoji:InitData(self.ChatInputField.gameObject, self.ChatInputField)
    self.PageChatQuick = PageChatQuick()
    self.PageChatQuick:InitData(self.BottomCanvasGroup.gameObject, function()
        local chatType = ChatDataManager:Get():GetChatType()
        ChatDataManager:Get():SetTimerIdOrTimeByChatType(chatType, ChatTimeOrId.Time)
        self:SetChatRefreshTime()
    end)

    self.SendBtn = CommonHelper:HButtonSetCallback("SendBtn", self.parentPrefab, function(param)
        self:OnSendBtnClick()
    end)

    self.NewMsgBtn = CommonHelper:HButtonSetCallback("NewMsgBtn", self.parentPrefab, function(param)
        self:OnNewMsgBtnClick()
    end)

    self.WorldTog = CommonHelper:HButtonSetCallback("WorldTog", self.parentPrefab, function()
        CommonHelper:SetUnlockFunc({ GameFunction.Chat }, function()
            self:InitTogState(ChatType.World)
        end)
    end)

    self.InviteTog = CommonHelper:HButtonSetCallback("InviteTog", self.parentPrefab, function()
        CommonHelper:SetUnlockFunc({ GameFunction.Chat }, function()
            self:InitTogState(ChatType.Invite)
        end)
    end)

    self.SystemTog = CommonHelper:HButtonSetCallback("SystemTog", self.parentPrefab, function()
        CommonHelper:SetUnlockFunc({ GameFunction.Chat }, function()
            self:InitTogState(ChatType.System)
        end)
    end)

    self.LocalTog = CommonHelper:HButtonSetCallback("LocalTog", self.parentPrefab, function()
        CommonHelper:SetUnlockFunc({ GameFunction.Chat }, function()
            self:InitTogState(ChatType.Local)
        end)
    end)

    self.PrivateTog = CommonHelper:HButtonSetCallback("PrivateTog", self.parentPrefab, function()
        CommonHelper:SetUnlockFunc({ GameFunction.Chat }, function()
            self:InitTogState(ChatType.Private)
            self:InitPrivateList(-1)
        end)
    end)
    --CommonHelper:CSGameObjectSetActive(self.PrivateTog.gameObject,false)--屏蔽私聊分页
    self.ClubTog = CommonHelper:HButtonSetCallback("ClubTog", self.parentPrefab, function()
        CommonHelper:SetUnlockFunc({ GameFunction.Club }, function()
            self:InitTogState(ChatType.Club)
        end)
    end)

    self.RoomTog = CommonHelper:HButtonSetCallback("RoomTog", self.parentPrefab, function()
        CommonHelper:SetUnlockFunc({ GameFunction.RaceRoom, GameFunction.PVPRank }, function()
            self:InitTogState(ChatType.PVPRoom)
        end)

    end)

    CommonHelper:HButtonSetCallback("BgBtn", self.parentPrefab, function()
        self:OnBackBtnClick()
    end)

    CommonHelper:HButtonSetCallback("BtnClose", self.parentPrefab, function()
        self:OnBackBtnClick()
    end)

    CommonHelper:HButtonSetCallback("BtnDelete", self.parentPrefab, function()
        self:OnDeleteBtnClick()
    end)

    CommonHelper:HButtonSetCallback("BtnPlayerInfo", self.pagePlayerInfoCG.gameObject, function()
        UIUtil.ShowCanvasGroup(self.pagePlayerInfoCG, false)
        self:ChangeChildToOri()
    end)

    CommonHelper:InitScrollEvent(self.LoopListView2Scroll, function(vector2value)
        if vector2value.y < 0.001 then
            CommonHelper:SetHButtonClick(self.NewMsgBtn, false, true)
        end
    end)
    CommonHelper:HButtonSetCallback("SpeakBtn", self.parentPrefab, function()
        self:SmallSpeak()
    end)
    --CommonHelper:InputFieldOnValueChanged(self.ChatInputField, function(str)
    --    if CommonHelper:GetUtf8StrLen(str) >= ChatDataManager:Get():GetCharacterLimit() then
    --        CommonTipsHelper:ShowCenterTips(TemplateStringID.CharacterLimit)
    --    end
    --end)
end

function ChatViewData:OnSendBtnClick()
    ---todo 禁言时间暂时屏蔽
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
    --        local str = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrComStr), CommonHelper:GetTempStr_Default(TemplateStringID.ChatBan), dateStr)
    --        CommonTipsHelper:ShowCenterTips(str)
    --        CommonHelper:InputFieldSetValue(self.ChatInputField, "")
    --        return
    --    end
    --end

    self:ChatInputFieldEvent()
    CommonHelper:InputFieldSetValue(self.ChatInputField, "")
end

function ChatViewData:InitScrollEvent(vector2value)
    if vector2value ~= nil then
        if vector2value.y < 0.001 then
            CommonHelper:SetHButtonClick(self.NewMsgBtn, false, true)
        end
    end
end

function ChatViewData:SmallSpeak()
    print("PlayerNoticeDefaultID.LittleTrumpet    ", PlayerNoticeDefaultID.LittleTrumpet)
    local articleCount = KnapsackDataManager:Get():GetArticleCountByCfgid(PlayerNoticeDefaultID.LittleTrumpet)
    ---@type article_config_cell
    --local articleData = CommonHelper:GetTableDataByID(ConfigNames.article_config, PlayerNoticeDefaultID.LittleTrumpet)  --12040104	体力药剂
    CommonHelper:SetText("###PropCountText", self.gameObject, tostring(articleCount))
    if articleCount > 0 then
        UIManager:Get():OpenPopup("UseBroadcastView", CanvasType.FrontCanvas, "UseBroadcastView", true)
        UINotify:Get():SendNotification(UINotifyEvent.SetBroadcastType, NoticeLittleType.SmallSpeak)
    else
        CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.SmallSpeakNumNotEnough))
    end
end

function ChatViewData:OnNewMsgBtnClick()
    local messageCount = ChatDataManager:Get():GetChatListCountByChatType(ChatDataManager:Get():GetChatType(), ChatDataManager:Get():GetCurSelectPrivateId())
    print("消息的数量---------" .. messageCount)
    if messageCount ~= 0 then
        CommonHelper:MovePanelToItemIndex(self.LoopListView2, self.LoopListView2Scroll, messageCount - 1)
        CommonHelper:SetHButtonClick(self.NewMsgBtn, false, true)
    end
end

function ChatViewData:OnBackBtnClick()
    if UIUtil.IsCanvasGroupShow(self.pagePlayerInfoCG) then
        UIUtil.ShowCanvasGroup(self.pagePlayerInfoCG, false)
    end
    if RaceRoomManager:Get():IsInRoom() then
        ChatDataManager:Get():SetChatType(ChatType.None)
    end
    if  UIManager:Get():IsPersistentViewShow("ChatView") then
        UIManager:Get():HidePersistentView("ChatView")
    end

end

function ChatViewData:OnDeleteBtnClick()
    local boxFunc = function()
        local ret = MessageBoxHelp:Get():OpenBox_OKCancel(nil, CommonHelper:GetTempStr_Default(TemplateStringID.ChatPriDel))
        if ret == MessageBoxHelp.BtnType.OK then
            self:DeletePrivate(ChatDataManager:Get():GetCurSelectPrivateId())
        end
    end
    MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
end

function ChatViewData:DeletePrivate(privateId)
    ChatDataManager:Get():DeletePrivateChat(privateId)
    if ChatDataManager:Get():GetCurSelectPrivateId() == -1 then
        UINotify:Get():SendNotification(UINotifyEvent.ChatView_SetPrivateShowData, ChatType.Private)
    end
    UINotify:Get():SendNotification(UINotifyEvent.ChatView_InitPrivateList, -1)
end

---初始化按钮的状态
function ChatViewData:InitTogState(chatType)
    if ChatDataManager:Get():GetChatType() ~= chatType then
        ChatDataManager:Get():SetChatType(chatType)

        CommonHelper:SetToggleState(self.WorldTog, chatType == ChatType.World)
        CommonHelper:SetToggleState(self.LocalTog, chatType == ChatType.Local)
        CommonHelper:SetToggleState(self.PrivateTog, chatType == ChatType.Private)
        CommonHelper:SetToggleState(self.ClubTog, chatType == ChatType.Club)
        CommonHelper:SetToggleState(self.RoomTog, chatType == ChatType.PVPRoom)
        CommonHelper:SetToggleState(self.InviteTog, chatType == ChatType.Invite)
        CommonHelper:SetToggleState(self.SystemTog, chatType == ChatType.System)

        self:SetPrivateShowData(chatType)
        self:ScrollMoveToBottom()
        self:SetBaseData(chatType)
    end
end

----设置私聊时，第一次进私聊，要读取离线信息和本地数据，可能会慢，要不要提前读取
function ChatViewData:SetPrivateData()
    if not ChatDataManager:Get():GetIsReadAllLocalMsg() then
        --ChatDataManager:Get():ReadAllChatMsgFromLocal() ---关闭客户端保存私聊信息
        ChatDataManager:Get():SetIsReadAllLocalMsg(true)
    end

    --CommonHelper:SetText("PrivateCountText", self.parentPrefab, string.format(TemplateStringID.StrStr, "私聊：", tostring(ChatDataManager:Get():GetChatListCountByChatType(ChatType.Private, -1))))
end

----设置基本的聊天界面信息
function ChatViewData:SetBaseData(chatType)
    UIUtil.ShowCanvasGroup(self.ChatViewPrivateCG, chatType == ChatType.Private)
    UIUtil.ShowCanvasGroup(self.pagePlayerInfoCG, false)

    --CommonHelper:SetHButtonClick(self.RoomTog, RaceRoomManager:Get():IsInRoom(), true)
    --CommonHelper:SetHButtonClick(self.ClubTog, ClubDataManager:Get():IsHadClub(), true)
    CommonHelper:SetHButtonClick(self.NewMsgBtn, false, true)
    self:SetChatRefreshTime()
end

----设置聊天框显示还是不显示，私聊如果选择了好友就显示，没有选择就不显示
function ChatViewData:SetPrivateShowData(chatType)
    if ChatDataManager:Get():GetChatType() ~= chatType then
        return
    end
    local isShow = true
    local qucikChatActive=false
    CommonHelper:SetListItemCount(self.LoopListView2, 0)
    local TipTextStr = ""
    local TipTextActive = false
    local chatDataTable = ChatDataManager:Get():GetChatListByChatType(chatType, -1)
    if chatType == ChatType.Private then
        isShow = ChatDataManager:Get():GetCurSelectPrivateId() ~= -1 and isShow
        TipTextActive = not isShow
        self:SetPrivateData()
        UIUtil.SetParentGameObject(self.ChatListCanvasGroup.gameObject, self.LoopListView2.gameObject, true, true)
        TipTextStr = CommonHelper:GetTempStr_Default(TemplateStringID.ChatTipPrivate)
    elseif chatType == ChatType.System then
        isShow = false
    elseif chatType == ChatType.Club then
        TipTextStr = CommonHelper:GetTempStr_Default(TemplateStringID.ChatTipClub)
        TipTextActive = PlayerDataManager:Get():GetGuildId() == 0
        isShow = not TipTextActive
    elseif chatType == ChatType.Invite then
        isShow = false
        TipTextStr = CommonHelper:GetTempStr_Default(TemplateStringID.ChatTipInvite)
        TipTextActive = #chatDataTable == 0
    elseif chatType == ChatType.World then
        TipTextStr = CommonHelper:GetTempStr_Default(TemplateStringID.ChatTipWorld)
        TipTextActive = #chatDataTable == 0
        ---@type dictcalc_config_cell
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.UnlimitedChatLevel)
        qucikChatActive = PlayerDataManager:Get():GetPlayerLV() < tonumber(cfg.varval)
    end
    if chatType ~= ChatType.Private then
        UIUtil.SetParentGameObject(self.ChatViewOtherParent, self.LoopListView2.gameObject, true, true)
        self:InitChatScrollList(chatType, -1)
    end
    CommonHelper:SetGameObjectActive("quickspeakbtn", self.parentPrefab, qucikChatActive)
    UIUtil.ShowCanvasGroup(self.ChatListCanvasGroup, isShow)
    CommonHelper:SetGameObjectActive("###TipText", self.parentPrefab, TipTextActive)
    CommonHelper:SetText("###TipText", self.parentPrefab, TipTextStr)
    CommonHelper:SetGameObjectActive("PrivateImage", self.parentPrefab, chatType == ChatType.Private and ChatDataManager:Get():GetCurSelectPrivateId() ~= -1)

    UIUtil.ShowCanvasGroup(self.BottomCanvasGroup, isShow)
end

function ChatViewData:Clear()
    self:ClearPlayInfoData()
    ChatDataManager:Get():SetChatType(ChatType.None)
end

