function ClubMainMenuView:CacheEditData()
    self.clubNotificationInput = UIUtil.GetTypeChildWightByParent("ClubNotificationInput", self.MainMenuCG.gameObject, typeof(InputField))
    self.clubLevelInput = UIUtil.GetTypeChildWightByParent("ClubLevelInput", self.MainMenuCG.gameObject, typeof(InputField))
    self.allBadge = CommonHelper:GetHeadIconsByType(HeadIconType.ClubIcon, HeadIconAttrType.Head)
    self.headListScroll = UIUtil.GetTypeChildWightByParent("CarouselScrollView_Loop", self.MainMenuCG.gameObject, typeof(CarouselScrollView))
    self.curPage = -1
end

function ClubMainMenuView:InitEditInfo()
    self.curSelectIdx = nil
    self.clubJoinType = self.clubData:GetJoinType()
    self:InitBadgeScroll()
end

function ClubMainMenuView:InitEditDetailInfo()
    self.isEdit = not self.isEdit
    CommonHelper:SetToggleState(self.TogEdit, self.isEdit == true)
    CommonHelper:SetHButtonClick(self.EditChatBtn, self.isEdit == true, true)
    CommonHelper:SetGameObjectActive("EditPlane", self.MainMenuCG.gameObject, self.isEdit == false)
    CommonHelper:SetHButtonClick(self.BtnLeft, self.isEdit == true and self.clubData:GetSelfPosition() == ClubMemberPosition.President, true)
    CommonHelper:SetHButtonClick(self.BtnRight, self.isEdit == true and self.clubData:GetSelfPosition() == ClubMemberPosition.President, true)
end

function ClubMainMenuView:OnEditBtnClick()
    self:InitEditDetailInfo()
    if not self.isEdit then
        local boxFunc = function()
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Yellow, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.ClubIsSave)))
            if ret == MessageBoxHelp.BtnType.OK then
                self:OnEditBtnEnsure()
            else
                self:InitBadgeScroll()
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
    end
end

function ClubMainMenuView:OnEditBtnEnsure()
    local notifyStr = CommonHelper:InputFieldGetValue(self.clubNotificationInput)
    if notifyStr ~= self.clubData:GetDeclaration() and CommonHelper:GetUtf8StrLen(notifyStr) < 4 then
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ClubDescriptionCharacterLimit))
        self:InitViewInfo()
        return
    end

    local isRightDescribe, message = CommonHelper:ReviewWordsV2(tostring(PlayerDataManager:Get():GetPlayerLV()), tostring(ChatType.Club), notifyStr)
    if  isRightDescribe then
        ClubSubsystem:Get():SendMsg_GuildChangeInfoReq(CommonHelper:InputFieldGetValue(self.clubNotificationInput), CommonHelper:GetToggleState(self.ClubApproveTog) and ClubJoinType.NeedAudit or ClubJoinType.FreeJoin, CommonHelper:InputFieldGetValue(self.clubLevelInput), self:GetCurSelectId())
    end

end

function ClubMainMenuView:InitEditFunc()
    self.ClubApproveTog = CommonHelper:HButtonSetCallback("ClubApproveTog", self.MainMenuCG.gameObject, function(param)
        self.clubJoinType = self.clubJoinType == ClubJoinType.NeedAudit and ClubJoinType.FreeJoin or ClubJoinType.NeedAudit
        CommonHelper:SetToggleState(self.ClubApproveTog, self.clubJoinType == ClubJoinType.NeedAudit)
    end)

    self.BtnLeft = CommonHelper:HButtonSetCallback("BtnLeft", self.MainMenuCG.gameObject, function(param)
        CommonHelper:InitCarouselScrollView_MoveLastPage(self.headListScroll)
        self.curPage = CommonHelper:InitCarouselScrollView_GetCurPage(self.headListScroll)
    end)

    self.BtnRight = CommonHelper:HButtonSetCallback("BtnRight", self.MainMenuCG.gameObject, function(param)
        CommonHelper:InitCarouselScrollView_MoveNextPage(self.headListScroll)
        self.curPage = CommonHelper:InitCarouselScrollView_GetCurPage(self.headListScroll)
    end)
    self.MoreRowScrollView= self:GetChildWight("MoreRowScrollView_V",typeof(MoreRowScrollView))
end

function ClubMainMenuView:InitBadgeScroll()

    for i = 1, #self.allBadge do
        if self.allBadge[i].C_ID == self.clubData:GetIcon() then
            self.curSelectIdx = i - 1
        end
    end
    print(self.curSelectIdx)

    if self.curPage ~= self.curSelectIdx then
        local UpdateFunc = function(dataIndex, itemObj, scroll)
            local iconData = self.allBadge[dataIndex + 1]
            CommonHelper:GetComponentSetUITexture("HeadIcon", itemObj, iconData.icon .. ".png", UIModuleID.Club)
        end
        CommonHelper:InitCarouselScrollView(self.headListScroll, #self.allBadge, nil, UpdateFunc)

        CommonHelper:InitCarouselScrollView_MoveToPage(self.headListScroll, self.curSelectIdx)

        self.curPage = self.curSelectIdx
    end
end

function ClubMainMenuView:GetCurSelectId()
    local idx = CommonHelper:InitCarouselScrollView_GetCurPage(self.headListScroll)
    return self.allBadge[idx + 1].C_ID
end

function ClubMainMenuView:InitChatScrollList()
    self.pageSingleChat:InitChatScrollList(ChatType.Club, -1)
end

function ClubMainMenuView:UpdateChatScrollView()
    self.pageSingleChat:UpdateChatScrollView(ChatType.Club, -1)
end


















