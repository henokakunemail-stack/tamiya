function ClubNoView:CacheCreateData()
    local page_clubCreatGo = self:GetChild("Page_ClubCreate")
    self.page_clubCreat = PageClubCreate(page_clubCreatGo)

    self.allBadge = CommonHelper:GetHeadIconsByType(HeadIconType.ClubIcon, HeadIconAttrType.Head)
    self.TrackView = UIUtil.GetTypeChildWightByParent("TrackScrollView", self.gameObject, typeof(FilmScrollView))

    self.clubNameInputField = UIUtil.GetTypeChildWightByParent("ClubNameInput", self.gameObject, typeof(InputField))

    self:InitBtnFunc()
end

function ClubNoView:InitCreateInfo()
    self:Page_InitViewInfo(#self.allBadge > 0 and self.allBadge[1].C_ID )

    ---@type dictcalc_config_cell
    local consumeDiamond = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.CreateClubCost)
    CommonHelper:SetText("###ConsumeCountText", self.gameObject, tostring(consumeDiamond.varval))

    CommonHelper:InputFieldSetValue(self.page_clubCreat.clubLevelInput, "1")
end

function ClubNoView:InitCreateBtnFunc()
    CommonHelper:HButtonSetCallback("CreateBtn", self.gameObject, function(param)
        self:OnCreateBtnClick()
    end)
end

function ClubNoView:OnCreateBtnClick()

    if CommonHelper:IsNullOrEmpty(CommonHelper:InputFieldGetValue(self.clubNameInputField)) then
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ClubNameCharacterLimit))
        return
    end

    if CommonHelper:GetUtf8StrLen(CommonHelper:InputFieldGetValue(self.page_clubCreat.clubNotificationInput)) < 4 then
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ClubDescriptionCharacterLimit))
        return
    end

    --local playerDiamond = PlayerDataManager:Get():GetCurrency(CurrencyType.Diamond)

    --local consumeDiamond = tonumber(CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.CreateClubCost).varval)

    --if playerDiamond >= consumeDiamond then
    if true then
        local guildName = CommonHelper:InputFieldGetValue(self.clubNameInputField)
        --local describe = CommonHelper:InputFieldGetValue(self.page_clubCreat.clubNotificationInput)
        local describe = ""
        if not CommonHelper:ReviewNicknameV2(guildName) then
            return
        end

        local isRightDescribe, message = CommonHelper:ReviewWordsV2(tostring(PlayerDataManager:Get():GetPlayerLV()), tostring(ChatType.Club), describe)
        if isRightDescribe then
            ClubSubsystem:Get():SendMsg_GuildCreate(guildName, describe, self.page_clubCreat.clubJoinType, tonumber(CommonHelper:InputFieldGetValue(self.page_clubCreat.clubLevelInput)), self:GetCurSelectId())
        end
    else
        self:PurchaseDiamondPop()
    end
end

function ClubNoView:PurchaseDiamondPop()
    local boxFunc = function()
        local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Orange, CommonHelper:GetTempStr_Default(TemplateStringID.ClubPurchaseDiamond), "")
        if ret == MessageBoxHelp.BtnType.OK then
            CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.StaminaPurchaseNotOpen))
        end
    end
    MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
end

function ClubNoView:Page_InitViewInfo(curSelectId)
    self.curSelectId = curSelectId
    self:SetHeadListView()
end

function ClubNoView:SetHeadListView()
    local UpdateFunc = function(dataIndex, itemObj, scroll)
        local GrayImage = UIUtil.GetTypeChildWightByParent("GrayImage", itemObj, typeof(Image))
        local iconData = self.allBadge[dataIndex + 1]
        CommonHelper:GetComponentSetUITexture("HeadIcon", itemObj, iconData.icon .. ".png", UIModuleID.Club)

    end
    CommonHelper:FilmView_Init(self.TrackView, #self.allBadge, UpdateFunc)
end

function ClubNoView:GetCurSelectId()
    --return 1
    local idx = CommonHelper:FilmView_GetCurItem(self.TrackView)
    return self.allBadge[idx + 1].C_ID
end







