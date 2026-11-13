function ClubNoView:CacheListData()
    self. clubListScrollView = self:GetChildWightByParent("ClubList", self.ListCG.gameObject, typeof(MoreRowScrollView))
    self. searchInputField = self:GetChildWightByParent("SearchInputField/Input75", self.ListCG.gameObject, typeof(InputField))

    self.clubInfoCG = self:GetChildWightByParent("ClubInfo", self.ListCG.gameObject, typeof(CanvasGroup))
    self.clubListCG = self:GetChildWightByParent("ClubList", self.ListCG.gameObject, typeof(CanvasGroup))
end

function ClubNoView:InitListBtnFunc()
    self. timeImage = CommonHelper:SetGameObjectActive("RefreshImage", self.ListCG.gameObject, false)

    self.BtnSearch = CommonHelper:HButtonSetCallback("BtnSearch", self.ListCG.gameObject, function(data)
        self:OnSearchClubBtnClick()
    end)

    self.BtnRefresh = CommonHelper:HButtonSetCallback("BtnRefresh", self.ListCG.gameObject, function(param)
        self:OnBtnRefreshClick()
    end)

    self.BtnApply = CommonHelper:HButtonSetCallback("BtnApply", self.ListCG.gameObject, function(param)
        if ClubDataManager:Get():GetCurSelectClubData() then
            if PlayerDataManager:Get():GetPlayerLV() < ClubDataManager:Get():GetCurSelectClubData():GetLimitLv() then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ClubLimitLv))
            else
                ClubSubsystem:Get():SendMsg_GuildJoin(ClubDataManager:Get():GetCurSelectClubId(), ClubApplyType.Apply)
            end
        end
    end)

    self.BtnCancelApply = CommonHelper:HButtonSetCallback("BtnCancelApply", self.ListCG.gameObject, function(param)
        ClubSubsystem:Get():SendMsg_GuildJoin(ClubDataManager:Get():GetCurSelectClubId(), ClubApplyType.CancelApply)
    end)

    CommonHelper:InputFieldOnEndEdit(self.searchInputField, function(str)
        if CommonHelper:IsNullOrEmpty(str) then
            local clubData = ClubDataManager:Get():GetClubDataByIdxType(1, ClubListType.Recommend)
            if clubData ~= nil then
                ClubDataManager:Get():SetCurSelectClubId(clubData:GetId())
            end
            ClubDataManager:Get():SetClubListType(ClubListType.Recommend)
            self:InitClubList(ClubListType.Recommend, true)
        end
    end)
end

function ClubNoView:InitListViewInfo()
   ClubSubsystem:Get():SendMsg_GetAllClub()
end

function ClubNoView:InitCanvasGroup(IsClubListShow, IsClubInfoShow, IsSearchResultShow)
    UIUtil.ShowCanvasGroup(self.clubListCG, IsClubListShow)
    UIUtil.ShowCanvasGroup(self.clubInfoCG, IsClubInfoShow)
    CommonHelper:SetGameObjectActive("TweenTemp_ClubInfoBtn/BtnApply", self.ListCG.gameObject, IsClubInfoShow)
    CommonHelper:SetGameObjectActive("TweenTemp_ClubInfoBtn/BtnCancelApply", self.ListCG.gameObject, IsClubInfoShow)
    -- CommonHelper:SetGameObjectActive("TweenTemp_SubTittle/RefreshImage", self.ListCG.gameObject, false)
    CommonHelper:SetGameObjectActive("SearchResultText", self.ListCG.gameObject,  IsSearchResultShow)
    CommonHelper:SetHButtonClick(self.BtnRefresh, IsSearchResultShow or IsClubListShow, true)
end

function ClubNoView:OnSearchClubBtnClick()
    local searchClubName = CommonHelper:InputFieldGetValue(self.searchInputField)
    if CommonHelper:IsNullOrEmpty(searchClubName) then
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ClubInputSearchClubName))
    else
        ClubSubsystem:Get():SendMsg_GuildSearchGuilds(searchClubName)
    end
    CommonHelper:SetBtnDelayClick(self.BtnSearch, 0.3, false)
end

----刷新按钮
function ClubNoView:OnBtnRefreshClick()
    ClubSubsystem:Get():SendMsg_GetAllClub()
    ClubDataManager:Get():SetRefreshListTime(5)
    self:SetRefreshListTimeFunc(ClubDataManager:Get():GetRefreshListTime())
end

----搜索按钮之后
---@param msg SC_GuildInfo
function ClubNoView:AfterSearch(msg)
    if msg then
        ClubDataManager:Get():SetClubListType(ClubListType.Search)
        self:InitClubList(ClubListType.Search, true)
    else
        self:InitCanvasGroup(false, false, true)
    end
    CommonHelper:InputFieldSetValue(self.searchInputField,"")
end
---- 一个工会都没有
---@param msg SC_GuildInfo
function ClubNoView:NoClub(msg)
    self:InitCanvasGroup(false, false, false)
end

function ClubNoView:InitClubInfo()
    local IsClubInfoShow  = ClubDataManager:Get():GetServerHaveClub()
    self:InitCanvasGroup(true, IsClubInfoShow, false)
    local clubData = ClubDataManager:Get():GetClubDataById(ClubDataManager:Get():GetCurSelectClubId())

    CommonHelper:GetComponentSetUITexture("clubIcon", self.clubInfoCG.gameObject, CommonHelper:GetPlayerIconById(clubData:GetIcon(), HeadIconType.ClubIcon)..".png", UIModuleID.Club)

    --CommonHelper:SetPlayerIcon("ClubInfo/ClubHeadIcon", self.ListCG.gameObject, CommonHelper:GetPlayerIconById(ClubDataManager:Get():GetClubDataById(clubData:GetPresidentId()):GetIcon()), nil, nil, UIModuleID.Club)

    CommonHelper:SetText("ClubInfo/###ClubPresidentNameText", self.ListCG.gameObject, clubData:GetPresidentName())

    CommonHelper:SetText("ClubInfo/###ClubNameText", self.ListCG.gameObject, clubData:GetName())

    CommonHelper:SetInputFieldText("ClubLevelInput", self.ListCG.gameObject, tostring(clubData:GetLimitLv()))

    CommonHelper:SetText("ClubInfo/###ClubNotificationText", self.ListCG.gameObject, clubData:GetDeclaration())

    local BtnApply = CommonHelper:SetGameObjectActive("TweenTemp_ClubInfoBtn/BtnApply", self.ListCG.gameObject, not clubData:GetHasApplyFor())

    CommonHelper:SetGameObjectActive("TweenTemp_ClubInfoBtn/BtnCancelApply", self.ListCG.gameObject, clubData:GetHasApplyFor())

    CommonHelper:SetText("###text", BtnApply, clubData:GetJoinType() == ClubJoinType.FreeJoin and CommonHelper:GetTempStr_Default(TemplateStringID.ClubJoin)  or CommonHelper:GetTempStr_Default(TemplateStringID.ClubApplications))
end

----------------------------------------------初始化俱乐部列表信息
---@param clubListType ClubListType
function ClubNoView:InitClubList(clubListType, isPlayAni)
    local IsClubInfoShow  = ClubDataManager:Get():GetServerHaveClub()
    self:InitCanvasGroup(true, IsClubInfoShow, false)
    clubListType = ClubDataManager:Get():GetClubListType()
    local itemCount = ClubDataManager:Get():GetMemberCountByType(clubListType)
    local lastSelectImage = nil
    local UpdateFunc = function(dataIndex, itemObj, scroll)
        local clubViewData = ClubDataManager:Get():GetClubDataByIdxType(dataIndex + 1, clubListType)

        CommonHelper:GetComponentSetUITexture("clubIcon", itemObj, CommonHelper:GetPlayerIconById(clubViewData:GetIcon(), HeadIconType.ClubIcon)..".png", UIModuleID.Club)
        CommonHelper:SetText("###ClubNameText", itemObj, clubViewData:GetName())
        CommonHelper:SetText("###ClubLevelText", itemObj, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrStr), "Lv", tostring(clubViewData:GetLevel())))
        CommonHelper:SetText("###ClubNumText", itemObj, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.NumComNum), clubViewData:GetMemberCount(), clubViewData:GetMemberMaxCount()))
        CommonHelper:SetGameObjectActive("ClubAdultText", itemObj, clubViewData:GetJoinType() == ClubJoinType.NeedAudit and not clubViewData:GetHasApplyFor())
        CommonHelper:SetGameObjectActive("ClubHaveApply", itemObj, clubViewData:GetHasApplyFor())

        local selectClubImage = CommonHelper:SetGameObjectActive("ClubSelectBg", itemObj, ClubDataManager:Get():GetCurSelectClubId() == clubViewData:GetId())

        if ClubDataManager:Get():GetCurSelectClubId() == clubViewData:GetId() then
            lastSelectImage = selectClubImage
            --ClubSubsystem:Get():SendMsg_GuildInfo(ClubInfoType.Other, clubViewData:GetId())
            --这块直接刷新数据
            UINotify:Get():SendNotification(UINotifyEvent.ClubNoView_List_InitClubInfo)
        end

        CommonHelper:HButtonSetCallback("ViewDetailBtn", itemObj, function(param)
            ClubDataManager:Get():SetCurSelectClubId(clubViewData:GetId())
            if lastSelectImage ~= nil then
                CommonHelper:CSGameObjectSetActive(lastSelectImage, false)
            end
            CommonHelper:CSGameObjectSetActive(selectClubImage, true)
            lastSelectImage = selectClubImage

            CommonHelper:TMG_PlayAllTween(self.ListTG)
            --这块直接刷新数据
            UINotify:Get():SendNotification(UINotifyEvent.ClubNoView_List_InitClubInfo)
        end)
    end
    CommonHelper:InitMoreRowScrollView(self.clubListScrollView, itemCount, 1, UpdateFunc, true)
    if isPlayAni then
        CommonHelper:MoreRowView_EnterAniTask(self.clubListScrollView, 0.12)
    end
end

----------------------------------------------------------设置刷新列表的时间计时器
function ClubNoView:SetRefreshListTimeFunc(refreshListTime)
    local unixNowTime = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    local chatLeftTime = refreshListTime - unixNowTime
    CommonHelper:CSGameObjectSetActive(self.timeImage, chatLeftTime > 0)
    CommonHelper:SetHButtonClick(self.BtnRefresh, chatLeftTime <= 0)

    if chatLeftTime > 0 then
        CommonHelper:SetText("Text", self.timeImage, tostring(chatLeftTime))
        self:StopTimer(ClubDataManager:Get():GetRefreshTimeId())
        local timeId = TimerManager:Get():CreateTimerLoop(1, function()
            unixNowTime = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
            chatLeftTime = refreshListTime - unixNowTime
            if chatLeftTime <= 0 then
                CommonHelper:CSGameObjectSetActive(self.timeImage, false)
                CommonHelper:SetHButtonClick(self.BtnRefresh, true)
                self:StopTimer(ClubDataManager:Get():GetRefreshTimeId())
            else
                CommonHelper:SetText("Text", self.timeImage, tostring(chatLeftTime))
            end
        end)
        ClubDataManager:Get():SetRefreshTimeId(timeId)
    end
end

function ClubNoView:StopTimer(timeId)
    if timeId ~= -1 then
        TimerManager:Get():StopTimer(timeId)
        ClubDataManager:Get():SetRefreshTimeId(-1)
    end
end



