local curSelectPlayerId = -1
---@class ClubMainMenuView : ViewBase
ClubMainMenuView = class("ClubMainMenuView", ViewBase)

function ClubMainMenuView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ClubMainMenuViewAction")
end

function ClubMainMenuView:Awake()
    self:CacheBaseData()
    self:InitBtnFunc()
end

function ClubMainMenuView:OnOpen()
    curSelectPlayerId = -1
    self.isEdit = false
    self.curPage = -1

    self:InitTogState(true, false, false, 1)
    self:InitViewInfo()

    ChatDataManager:Get():SetChatType(ChatType.Club)
end

function ClubMainMenuView:CacheBaseData()

    self.MainMenuCG = self:GetChildWight("MainMenuCG", typeof(CanvasGroup))
    self.MainMenuTG = UIUtil.GetGameobjectComponent(self.MainMenuCG.gameObject, typeof(FXUITweenMoreGroup))

    self.OtherCG = self:GetChildWight("OtherCG", typeof(CanvasGroup))
    self.OtherTG = UIUtil.GetGameobjectComponent(self.OtherCG.gameObject, typeof(FXUITweenMoreGroup))

    self.MemberList = self:GetChildWight("MemberList", typeof(MoreRowScrollView))

    self.pageSingleChat = CommonHelper:InitSingleChannelChat(ChatType.Club, self.MainMenuCG.gameObject, UIModuleID.Club)

    ---@type ClubData
    self. clubData = nil

    self.togIdx = nil

    self:CacheEditData()

    self.clubViewData = ClubMainMenuViewData()
    self.clubViewData:InitData(self.OtherCG.gameObject, UIModuleID.Club)

end

function ClubMainMenuView:UpdateSlider()

    local level = ClubDataManager:Get():GetGuildLevelByExp()
    self.clubData:SetLevel(level)
    CommonHelper:SetText("ClubNameBg/###ClubLvText", self.MainMenuCG.gameObject, tostring(level))
    --经验段止
    local cfgCurr = ClubDataManager:Get():GetGuildConfigByLevel(level).guildexpe
    --经验开始
    local cfgLast = 0

    if level > 1 then
        cfgLast = ClubDataManager:Get():GetGuildConfigByLevel(level - 1).guildexpe
    end
    local per = 1
    local str = ClientDataManager:Get():GetTemplateString(TemplateStringID.PartReforLimitFormat)
    local coin = ClubDataManager:Get():GetCurSelectClubData():GetCoin()
    per = (coin - cfgLast) / (cfgCurr - cfgLast)
    str = string.format(str, coin - cfgLast, cfgCurr - cfgLast)

    CommonHelper:SetSlider("SliderBaseColor", self.MainMenuCG.gameObject, per)

    CommonHelper:SetText("###processvalue", self.MainMenuCG.gameObject, str)
end

function ClubMainMenuView:InitBtnFunc()
    self.TogMainMenu = CommonHelper:HButtonSetCallback("TogMainMenu", self.gameObject, function(param)
        self:InitTogState(true, false, false, 1, function()
            self:InitViewInfo()
            CommonHelper:TMG_PlayAllTween(self.MainMenuTG)
        end)
    end)
    self.BtnCheck = CommonHelper:HButtonSetCallback("BtnCheck", self.gameObject, function(param)
        self:OnBtnClick(function()
            ClubSubsystem:Get():SendMsg_GuildBtnSign()
        end)
    end)

    self.TogMember = CommonHelper:HButtonSetCallback("TogMember", self.gameObject, function(param)
        self:OnBtnClick(self.OnTogMemberClick, self)
    end)

    self.TogApply = CommonHelper:HButtonSetCallback("TogApply", self.gameObject, function(param)
        self:OnBtnClick(function()
            self:InitTogState(false, false, true, 3, function()
                ClubSubsystem:Get():SendMsg_GuildApplyList()
                CommonHelper:TMG_PlayAllTween(self.OtherTG)
            end)
        end)
    end)

    self.BtnRace = CommonHelper:HButtonSetCallback("BtnRace", self.gameObject, function(param)
        self:OnBtnClick(function()
            if RaceActManager:Get():GetRaceInfo(RaceActId.RaceClub3V3,true) then
                RaceClub3v3Subsystem:Get():SendMsg_GetInfo()
            end
        end)
    end)

    self.BtnPVP = CommonHelper:HButtonSetCallback("BtnPVP", self.gameObject, function(param)
        self:OnBtnClick(function()
            if RaceActManager:Get():GetRaceInfo(RaceActId.RaceGVG,true) then
                RaceGVGSubsystem:Get():SendMsg_GetInfo()
            end
        end)
    end)

    self.BtnTruck = CommonHelper:HButtonSetCallback("BtnTruck", self.gameObject, function(param)
        self:OnBtnClick(function()
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.FunctionNoWait))
        end)
    end)

    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(param)
        CommonHelper:ShowHelpView(PageDetailType.Club)
    end)

    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(param)
        self:OnBtnClick(function()
            UIManager:Get():CloseView()
        end)
    end)

    CommonHelper:HButtonSetCallback("BtnExit", self.OtherCG.gameObject, function(param)
        self:OnExitBtnClick()
    end)

    self.EditChatBtn = CommonHelper:HButtonSetCallback("EditChatBtn", self.MainMenuCG.gameObject, function(param)
        self:OnBtnClick()
    end)

    self.TogEdit = CommonHelper:HButtonSetCallback("BtnEdit", self.MainMenuCG.gameObject, function(param)
        self:OnEditBtnClick(self.isEdit)
    end)

    CommonHelper:HButtonSetCallback("BtnCopy", self.MainMenuCG.gameObject, function(param)
        self:OnBtnClick(function()
            CommonHelper:WriteClipboart(self.clubData:GetName())
        end)
    end)

    self.BtnChangeName = CommonHelper:HButtonSetCallback("BtnChangeName", self.MainMenuCG.gameObject, function(param)
        UIManager:Get():OpenPopup("ClubRenameView",CanvasType.FrontCanvas,"ClubRenameView")
    end)

    CommonHelper:HButtonSetCallback("BtnChat", self.gameObject, function(hbtn)
        UIManager:Get():ShowPersistentView("ChatView", CanvasType.MainCanvas, "ChatView")
        UINotify:Get():SendNotification(UINotifyEvent.ChatView_InitTogState, ChatType.Club)
    end)

    self.BtnShare = CommonHelper:HButtonSetCallback("BtnShare", self.MainMenuCG.gameObject, function(param)
        self:OnBtnClick(function()
            local clubData = ClubDataManager:Get():GetCurSelectClubData()
            if clubData ~= nil then
                local userdata = {
                    id = clubData:GetId(),
                    icon = clubData:GetIcon(),
                    name = clubData:GetName(),
                    count = clubData:GetMemberCount(),
                    maxCount = clubData:GetMemberMaxCount(),
                }
                CommonHelper:CloseShareInviteView()
                CommonHelper:ShareToChat(ShareType.ClubInvite, userdata)
            end
        end)
    end)

    self.BtnTask = CommonHelper:HButtonSetCallback("BtnTask", self.MainMenuCG.gameObject, function(param)
        self:OnBtnClick(function()
            if not UIManager:Get():IsPersistentViewShow("ClubTaskView") then
                UIManager:Get():ShowPersistentView("ClubTaskView", CanvasType.MainCanvas, "ClubTaskView")
                UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_SetLuaViewInfo,{"ClubTaskView",true})
            end
        end)
    end)

    self.BtnShop = CommonHelper:HButtonSetCallback("BtnShop", self.MainMenuCG.gameObject, function(param)
        self:OnBtnClick(function()
            FunctionSkipManager:Get():SkipToFunction(GameFunction.Shop,ShopID.Guild)
        end)
    end)

    self.BtnCloseMask2 = CommonHelper:HButtonSetCallback("BtnCloseMask2", self.clubViewData.pageMemberInfoCG.gameObject, function(param)
        self:OnBtnClick(function()
            UIUtil.ShowCanvasGroup(self.clubViewData.pageMemberInfoCG, false)
        end)
    end)

    self:InitEditFunc()
end

function ClubMainMenuView:InitViewInfo()
    ClubDataManager:Get():SetClubListType(ClubListType.Recommend)
    curSelectPlayerId = -1

    self. clubData = ClubDataManager:Get():GetCurSelectClubData()

    CommonHelper:SetGameObjectActive("EditPlane", self.MainMenuCG.gameObject, self.isEdit == false or self.clubData:GetSelfPosition() ~= ClubMemberPosition.President)
    CommonHelper:SetHButtonClick(self.BtnLeft, false, true)
    CommonHelper:SetHButtonClick(self.BtnRight, false, true)
    CommonHelper:SetHButtonClick(self.EditChatBtn, self.isEdit == true, true)

    --CommonHelper:GetComponentSetUITexture("clubIcon", self.MainMenuCG.gameObject, CommonHelper:GetPlayerIconById(self.clubData:GetIcon()), UIModuleID.Club)

    --CommonHelper:SetText("###ClubPresidentNameText", self.MainMenuCG.gameObject, clubData:GetPresidentName())
    --CommonHelper:SetText("###ClubNumText", self.MainMenuCG.gameObject, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.NumComNum), clubData:GetMemberCount(), clubData:GetMemberMaxCount()))


    local notifyText = CommonHelper:GetTempStr_Default(TemplateStringID.ClubNotifyLimit, 4, 40)
    if self.clubData:GetDeclaration() == notifyText then
        CommonHelper:InputFieldSetValue(self.clubNotificationInput, notifyText)
    else
        CommonHelper:InputFieldSetValue(self.clubNotificationInput, self.clubData:GetDeclaration())
    end
    CommonHelper:InputFieldSetValue(self.clubLevelInput, self.clubData:GetLimitLv())
    CommonHelper:SetText("ClubNameBg/###ClubNameText", self.MainMenuCG.gameObject, self.clubData:GetName())
    CommonHelper:SetText("ClubNameBg/###ClubLvText", self.MainMenuCG.gameObject, tostring(self.clubData:GetLevel()))
    CommonHelper:SetText("ClubId/###ClubIdText", self.MainMenuCG.gameObject, tostring(self.clubData:GetId()))
    local flag1,data1 = RaceActManager:Get():GetRaceInfo(RaceActId.RaceGVG,false,true)
    local flag2,data2 =RaceActManager:Get():GetRaceInfo(RaceActId.RaceClub3V3,false,true)
    if data1 then
        CommonHelper:SetText("Bg/###pvptime", self.BtnPVP.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceActTimeFormat,data1.BeginTime.Year,data1.BeginTime.Month,data1.BeginTime.Day,data1.BeginTime.Hour,data1.BeginTime.Second,data1.EndTime.Year,data1.EndTime.Month,data1.EndTime.Day,data1.EndTime.Hour,data1.EndTime.Second))
    else
        CommonHelper:SetText("Bg/###pvptime", self.BtnPVP.gameObject,"")
    end
    if data2 then
        CommonHelper:SetText("Bg/###pvetime", self.BtnRace.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceActTimeFormat,data2.BeginTime.Year,data2.BeginTime.Month,data2.BeginTime.Day,data2.BeginTime.Hour,data2.BeginTime.Second,data2.EndTime.Year,data2.EndTime.Month,data2.EndTime.Day,data2.EndTime.Hour,data2.EndTime.Second))
    else
        CommonHelper:SetText("Bg/###pvetime", self.BtnRace.gameObject,"")
    end


    CommonHelper:SetToggleState(self.ClubApproveTog, self.clubData:GetJoinType() == ClubJoinType.NeedAudit)
    CommonHelper:SetToggleState(self.TogEdit, self.isEdit == true)

    ---@type dictguildprivilege_config
    local cell = CommonHelper:GetTableDataByID(ConfigNames.dictguildprivilege_config, self.clubData:GetSelfPosition())
    local list = stringSplitToNumber(cell.privs, ':')
    local isRight = false
    for i = 1, #list do
        if tonumber(list[i]) == ClubMemAuthorId.Approval then
            isRight = true
        end
    end
    CommonHelper:SetHButtonClick(self.TogApply, isRight, true)
    CommonHelper:SetHButtonClick(self.BtnShare, true, true)
    -- CommonHelper:SetHButtonClick(self.BtnShare, isRight, true)  --开启
    CommonHelper:SetHButtonClick(self.TogEdit, self.clubData:GetSelfPosition() == ClubMemberPosition.President, true)
    CommonHelper:SetHButtonClick(self.BtnChangeName, self.clubData:GetSelfPosition() == ClubMemberPosition.President, true)
    --local param = ShareDataManager:Get():GetShareData()
    --CommonHelper:InitInputFieldText(self.ChatInputField, param)
    CommonHelper:SetHButtonClick(self.BtnTask, true, true)
    self:InitEditInfo()

    self:InitChatScrollList()
    self:UpdateSlider()
    local UpdateFuncRight = function(dataIndex, itemObj, scroll)

    end
    CommonHelper:InitMoreRowScrollView(self.MoreRowScrollView, 1, 1, UpdateFuncRight, true)
end

---@param clubMainMenuType ClubMainMenuType
function ClubMainMenuView:InitMemberList(clubMainMenuType)

    CommonHelper:SetText("###DecText", self.OtherCG.gameObject, clubMainMenuType == ClubMainMenuType.MemberList and CommonHelper:GetTempStr_Default(TemplateStringID.MemberNumber) or CommonHelper:GetTempStr_Default(TemplateStringID.NumberOfApplications))

    local clubData = ClubDataManager:Get():GetCurSelectClubData()

    local count = clubMainMenuType == ClubMainMenuType.MemberList and clubData:GetMemberCount() or clubData:GetApplyMemCount()

    local countStr = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.NumComNum), count, clubData:GetMemberMaxCount())
    CommonHelper:SetText("###MemberCountText", self.OtherCG.gameObject, clubMainMenuType == ClubMainMenuType.MemberList and countStr or tostring(count))
    CommonHelper:SetGameObjectActive("BtnExit", self.OtherCG.gameObject, clubMainMenuType == ClubMainMenuType.MemberList)

    local lastSelectImg = nil
    local UpdateFunc = function(dataIndex, itemObj, scroll)
        local memberInfo = clubMainMenuType == ClubMainMenuType.MemberList and clubData:GetMemberByIndex(dataIndex + 1) or clubData:GetApplyMemberByIdx(dataIndex + 1)

        CommonHelper:SetPlayerIcon("PlayerIcon100", itemObj, CommonHelper:GetPlayerIconById(memberInfo:GetHeadIcon()),  CommonHelper:GetPlayerIconById(memberInfo:GetIconFrame(),nil,HeadIconAttrType.Frame), nil, UIModuleID.Club)

        CommonHelper:SetText("###PlayerLevelText", itemObj, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrStr), "Lv", tostring(memberInfo:GetLevel())))
        CommonHelper:SetText("###PlayerNameText", itemObj, tostring(memberInfo:GetName()))
        --todo  改成读表
        CommonHelper:SetText("###PlayerPosText", itemObj, ClubDataManager:Get():GetPositionName(memberInfo:GetPosition()))
        CommonHelper:SetGameObjectActive("Pos", itemObj, clubMainMenuType == ClubMainMenuType.MemberList)

        CommonHelper:SetText("###TContriText", itemObj, tostring(memberInfo:GetDonationSum()))
        CommonHelper:SetGameObjectActive("TotalContribution", itemObj, clubMainMenuType == ClubMainMenuType.MemberList)

        CommonHelper:SetText("###WContriText", itemObj, tostring(memberInfo:GetWeekPoint()))
        CommonHelper:SetGameObjectActive("WeekContribution", itemObj, clubMainMenuType == ClubMainMenuType.MemberList)

        --local serverText = CommonHelper:SetText("###PlayerServerText", itemObj, memberInfo:)
        --CommonHelper:CSGameObjectSetActive(posText.gameObject, clubMainMenuType == ClubMainMenuType.MemberList)

        local score = memberInfo:GetRankScore() == nil and 0 or memberInfo:GetRankScore()
        ---@type qualifyingrank_config_cell
        local cfg = CommonHelper:GetRankCfgByScore(score)
        CommonHelper:SetRankIconGroup("rankicon_s_1", itemObj, cfg)

        local selectBg = CommonHelper:SetGameObjectActive("SelectBg", itemObj, curSelectPlayerId == memberInfo:GetPlayerId())
        if curSelectPlayerId == memberInfo:GetPlayerId() then
            lastSelectImg = selectBg
        end

        CommonHelper:SetGameObjectActive("TogOnLine/hover", itemObj, memberInfo:GetLeaveTime() == -1)

        local leaveTime = CommonHelper:SetText("###LeaveTimeText", itemObj, CommonHelper:SetLeaveTime(memberInfo:GetLeaveTime()))
        CommonHelper:SetTextColor(leaveTime, memberInfo:GetLeaveTime() == -1 and "37a872" or "9fa8b1")

        local AgreeBtn = CommonHelper:HButtonSetCallback("AgreeBtn", itemObj, function(param)
            ClubSubsystem:Get():SendMsg_GuildAuditMember(memberInfo:GetPlayerId(), ClubAuditType.Agree)
        end)

        local RefuseBtn = CommonHelper:HButtonSetCallback("RefuseBtn", itemObj, function(param)
            ClubSubsystem:Get():SendMsg_GuildAuditMember(memberInfo:GetPlayerId(), ClubAuditType.Refuse)
        end)

        local BtnSetManager = CommonHelper:HButtonSetCallback("BtnSetManager", itemObj, function(param)
            ClubSubsystem:Get():SendMsg_GuildChangePosition(memberInfo:GetPlayerId(), ClubMemberPosition.Manager)
        end)
        local BtnSetOrdinary = CommonHelper:HButtonSetCallback("BtnSetOrdinary", itemObj, function(param)
            ClubSubsystem:Get():SendMsg_GuildChangePosition(memberInfo:GetPlayerId(), ClubMemberPosition.RankAndFile)
        end)

        local BtnSetPresident = CommonHelper:HButtonSetCallback("BtnSetPresident", itemObj, function(param)
            local boxFunc = function()
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(nil, CommonHelper:GetTempStr_Default(TemplateStringID.ClubSetPresident))
                if ret == MessageBoxHelp.BtnType.OK then
                    --ClubSubsystem:Get():SendMsg_GuildChangePosition(memberInfo:GetPlayerId(), ClubMemberPosition.President)

                    ClubSubsystem:Get():SendMsg_GuildChangePresident(memberInfo:GetPlayerId(), ClubMemberPosition.President)
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
        end)

        local BtnKick = CommonHelper:HButtonSetCallback("BtnKick", itemObj, function(param)
            local boxFunc = function()
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(nil, CommonHelper:GetTempStr_Default(TemplateStringID.ClubKickMem))
                if ret == MessageBoxHelp.BtnType.OK then
                    ClubSubsystem:Get():SendMsg_GuildKickMember(memberInfo:GetPlayerId())
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
        end)
        local BtnOperate = CommonHelper:HButtonSetCallback("BtnOperate", itemObj, function(btn)
            local isShow = UIUtil.IsCanvasGroupShow(self.clubViewData.pageMemberInfoCG)
            UIUtil.ShowCanvasGroup(self.clubViewData.pageMemberInfoCG, not isShow)
            if not isShow and clubMainMenuType == ClubMainMenuType.MemberList then
                local pos = btn.transform.position
                self.clubViewData:InitPageViewInfo(clubData,memberInfo, pos)
            end
        end)

        CommonHelper:SetHButtonClick(AgreeBtn, clubMainMenuType == ClubMainMenuType.ApplyList, true)
        CommonHelper:SetHButtonClick(RefuseBtn, clubMainMenuType == ClubMainMenuType.ApplyList, true)
        ---@type dictguildprivilege_config

        local cell = CommonHelper:GetTableDataByID(ConfigNames.dictguildprivilege_config, ClubDataManager:Get():GetCurSelectClubData():GetSelfPosition())
        local list = stringSplitToNumber(cell.privs, ':')
        local isChangeMemPos = false
        local isKickClubMember = false
        for i = 1, #list do
            if tonumber(list[i]) == ClubMemAuthorId.ChangeMemPos then
                isChangeMemPos = true
            elseif tonumber(list[i]) == ClubMemAuthorId.KickClubMember then
                isKickClubMember = true
            end
        end

        -- 会长      0 转让会长 1设置副会长 3查看详情  4加好友 5 踢出工会
        -- 副会长    0 查看详情 1加好友 2踢出工会
        -- 成员      0 查看详情 1加好友
        --操作按钮
        CommonHelper:SetHButtonClick(BtnOperate, clubMainMenuType == ClubMainMenuType.MemberList and memberInfo:GetPlayerId() ~= tostring(PlayerDataManager:Get():GetPlayerRID()), true)

        CommonHelper:HButtonSetCallback("ViewDetailBtn", itemObj, function(param)
            --FriendSubsystem:Get():SendMsg_GetPlayerInfo(memberInfo:GetPlayerId())

            if curSelectPlayerId ~= nil and curSelectPlayerId ~= memberInfo:GetPlayerId() then
                CommonHelper:CSGameObjectSetActive(lastSelectImg, false)
            end
            CommonHelper:CSGameObjectSetActive(selectBg, true)
        end)
    end
    CommonHelper:InitMoreRowScrollView(self.MemberList, count, 1, UpdateFunc, true)
    CommonHelper:MoreRowView_EnterAniTask(self.MemberList, 0.12)
end

function ClubMainMenuView:UpdateMemberList()
    CommonHelper:MoreRowView_RefreshCurList(self.MemberList, false)
end

function ClubMainMenuView:OnExitBtnClick()
    local curSelectClubId = ClubDataManager:Get():GetCurSelectClubId()
    local clubData = ClubDataManager:Get():GetClubDataById(curSelectClubId)

    local condition = clubData:GetSelfPosition() == ClubMemberPosition.President and clubData:GetMemberCount() > 1
    local str = condition and CommonHelper:GetTempStr_Default(TemplateStringID.ClubDismiss) or CommonHelper:GetTempStr_Default(TemplateStringID.ClubExit)

    local boxFunc = function()
        local ret = MessageBoxHelp:Get():OpenBox_OKCancel(nil, str, "")
        if ret == MessageBoxHelp.BtnType.OK then
            if condition then
                self:OnTogMemberClick()
            else
                ClubSubsystem:Get():SendMsg_GuildExit()
            end
        end
    end
    MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
end

function ClubMainMenuView:OnTogMemberClick()
    self:InitTogState(false, true, false, 2, function()
        --local curSelectClubId = ClubDataManager:Get():GetCurSelectClubId()
        --ClubSubsystem:Get():SendMsg_GuildMemberList(curSelectClubId)

        UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_InitMemberList, ClubMainMenuType.MemberList)

        CommonHelper:TMG_PlayAllTween(self.OtherTG)
    end)
end

function ClubMainMenuView:InitTogState(MainMenuTog, MemberTog, ApplyTog, togIdx, func)

    if self.togIdx ~= togIdx then

        UIUtil.ShowCanvasGroup(self.MainMenuCG, MainMenuTog)
        UIUtil.ShowCanvasGroup(self.OtherCG, MemberTog or ApplyTog)

        CommonHelper:SetToggleState(self.TogMainMenu, MainMenuTog)
        CommonHelper:SetToggleState(self.TogMember, MemberTog)
        CommonHelper:SetToggleState(self.TogApply, ApplyTog)

        self.togIdx = togIdx

        if func then
            func()
        end
    end
end

function ClubMainMenuView:OnExitSuccess()
    UIManager:Get():CloseView()
    PlayerDataManager:Get():SetGuildId(0)
    PlayerDataManager:Get():SetGuildName("")

    NetManager:Get():DisconnectGuildServer(false)
    ClubDataManager:Get():Clear()

    SkipModuleHelper:Get():ToMainMenuView(true)
end

function ClubMainMenuView:OnBtnClick(okFunc, class)
    if self.isEdit then
        local boxFunc = function()
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Yellow, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.ClubIsSave)))
            if ret == MessageBoxHelp.BtnType.OK then
                self:InitEditDetailInfo()
                self:OnEditBtnEnsure()
            else
                self:InitEditDetailInfo()
                self:InitBadgeScroll()
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
    else
        if okFunc ~= nil then
            if class ~= nil then
                okFunc(class)
            else
                okFunc(self)
            end
        end
    end
end

function ClubMainMenuView:OnClose()
    self.togIdx = nil
    CommonHelper:ReleasePool(UIModuleID.Club)
end

function ClubMainMenuView:ReOpen()
    self:UpdateSlider()
    local curSelectClubId = ClubDataManager:Get():GetCurSelectClubId()
    ClubSubsystem:Get():SendMsg_GuildInfo(ClubInfoType.Self, curSelectClubId)
    if self:GetLuaViewInfo("ClubTaskView") then
        UIManager:Get():ShowPersistentView("ClubTaskView", CanvasType.MainCanvas, "ClubTaskView")
        UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_SetLuaViewInfo,{"ClubTaskView",true})
    end

end