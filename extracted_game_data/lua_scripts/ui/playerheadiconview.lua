---@class PlayerHeadIconView : ViewBase
PlayerHeadIconView = class("PlayerHeadIconView", ViewBase)
--头像和头像框发32位的
--玩家id发64位的


local _curSelectHeadIcon
local _curSelectHeadFrameIcon
local _curSelectBg
local _curSelectCup
local _curSelectType

---@field title
---@field page
---@class temp

---@type table<number,temp>
local allType
function PlayerHeadIconView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "PlayerHeadIconViewAction")
end

function PlayerHeadIconView:Awake()
    self:CacheHeadIconViewData()
    self:InitViewBtn()
    allType = {}
    allType[HeadIconAttrType.Head] = { page = CommonHelper:GetTempStr_Default(TemplateStringID.PlayerPageIconName), title = CommonHelper:GetTempStr_Default(TemplateStringID.HeadIconName) }
    allType[HeadIconAttrType.Frame] = { page = CommonHelper:GetTempStr_Default(TemplateStringID.PlayerPageFrameName), title = CommonHelper:GetTempStr_Default(TemplateStringID.HeadIconFarmName) }
    allType[HeadIconAttrType.BG] = { page = CommonHelper:GetTempStr_Default(TemplateStringID.PlayerPageBgName), title = CommonHelper:GetTempStr_Default(TemplateStringID.PlayerIconBgTitleName) }
    allType[HeadIconAttrType.Cup] = { page = CommonHelper:GetTempStr_Default(TemplateStringID.PlayerPageCupName), title = CommonHelper:GetTempStr_Default(TemplateStringID.PlayerIconCupTitleName) }
end

function PlayerHeadIconView:OnOpen()
    _curSelectType = HeadIconAttrType.Head
    self:OnPageClick()
    self:UpdateChooseBtn()
    IllustratedHandbookSubsystem:Get():SendMsg_CupCollectList()
    self.CupCollectList = nil
end

function PlayerHeadIconView:CacheHeadIconViewData()
    self.Page_HeadIcon = self:GetChild("Page_HeadIcon")
    self.Page_BgAndCup = self:GetChild("Page_BgAndCup")
    self.Page_PlayerSampleInfo = self:GetChild("Page_PlayerSampleInfo")
    self.headListScroll = self:GetChildWightByParent("HeadListScroll", self.Page_HeadIcon, typeof(MoreRowScrollView))
    self.BgListScroll = self:GetChildWightByParent("BgListScroll", self.Page_BgAndCup, typeof(MoreRowScrollView))
    self.CupListScroll = self:GetChildWightByParent("CupListScroll", self.Page_BgAndCup, typeof(MoreRowScrollView))
    self.ChooseBtnSVC = UIUtil.GetTypeChildWightByParent("ChooseBtnSVC", self.gameObject, typeof(MoreRowScrollView))
    ---@type table<number,dictheadicon_config_cell>
    self.headIconList = CommonHelper:GetHeadIconsByType(HeadIconType.PlayerIcon, HeadIconAttrType.Head)
    ---@type table<number,dictheadicon_config_cell>
    self.headFrameList = CommonHelper:GetHeadIconsByType(HeadIconType.PlayerIcon, HeadIconAttrType.Frame)
    ---@type dictarticle_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.article_config)

    ---@type table<number,dictarticle_config_cell>
    self.headBgList = tab.GetArticleListType2(GoodsType2.Article_HeadBg, GoodsType3.Article_HeadBg_Static)
    local dytab = tab.GetArticleListType2(GoodsType2.Article_HeadBg, GoodsType3.Article_HeadBg_Dynamic)
    for _, cell in pairs(dytab) do
        table.insert(self.headBgList, cell)
    end
    ---@type table<number,dictheadicon_config_cell>
    self.headBgIconDic = {}
    self.dynamicDic = {}
    local count = #self.headBgList
    for i = count, 1,-1 do
        ---@type dictheadicon_config_cell
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.headicon_config, tonumber(self.headBgList[i].propsadd))
        if cfg==nil then
            print("头像表空",self.headBgList[i].propsadd)
        end
        if cfg and   cfg.subtype==HeadIconAttrType.BG then
            self.headBgIconDic[self.headBgList[i].C_ID] = cfg
            local strlist = stringSplit(cfg.icon, "_")
            if strlist[1] == "prefab" then
                self.dynamicDic[cfg.icon] = true
            end
        else
            table.remove(self.headBgList,i)
        end
    end
    ---@type table<number,dictarticle_config_cell>
    self.headCupList = tab.GetArticleListType2(GoodsType2.Article_Exhibit, GoodsType3.Article_Exhibit_Cup)

    self.Page_PlayerSampleInfoView = PagePlayerSampleInfoView(self.Page_PlayerSampleInfo, UIModuleID.PlayerInfo)
    self.PlayerSampleInfoData = PlayerSampleInfoData()
    PlayerSampleInfoDataManager:Get():GetSelfSampleInfo():Clone(self.PlayerSampleInfoData)
end

function PlayerHeadIconView:UpdateChooseBtn()

    local UpdateFunc = function(dataIndex, itemObj, scroll)
        local type = dataIndex + 1
        CommonHelper:SetGameObjectActive("choose", itemObj, _curSelectType == type)
        CommonHelper:SetGameObjectActive("common", itemObj, _curSelectType ~= type)

        CommonHelper:SetText("choose/###Text", itemObj, allType[type].page)
        CommonHelper:SetText("common/###Text", itemObj, allType[type].page)
        CommonHelper:SetGameObjectActive("lineup" ,itemObj,dataIndex==0)
        CommonHelper:HButtonSetCallback("ItemBtn", itemObj, function(btn)
            _curSelectType = type
            self:OnPageClick()
            self:UpdateChooseBtn()
        end)
    end
    CommonHelper:HButtonSetCallback("ItemBtn1", self.Page_PlayerSampleInfo, function()
        if _curSelectType == HeadIconAttrType.Cup then
            self:UpdateCupBtnState(1)
        end
    end)
    CommonHelper:HButtonSetCallback("ItemBtn2", self.Page_PlayerSampleInfo, function()
        if _curSelectType == HeadIconAttrType.Cup then
            self:UpdateCupBtnState(2)
        end
    end)
    CommonHelper:HButtonSetCallback("ItemBtn3", self.Page_PlayerSampleInfo, function()
        if _curSelectType == HeadIconAttrType.Cup then
            self:UpdateCupBtnState(3)
        end
    end)
    CommonHelper:InitMoreRowScrollView(self.ChooseBtnSVC, #allType, 1, UpdateFunc, true, nil, false)

end

function PlayerHeadIconView:UpdateCupBtnState(cupIndex)
    _curSelectCup = cupIndex
    CommonHelper:SetGameObjectActive("ItemBtn1/SelectImage", self.Page_PlayerSampleInfo, _curSelectCup == 1)
    CommonHelper:SetGameObjectActive("ItemBtn2/SelectImage", self.Page_PlayerSampleInfo, _curSelectCup == 2)
    CommonHelper:SetGameObjectActive("ItemBtn3/SelectImage", self.Page_PlayerSampleInfo, _curSelectCup == 3)
    self:UpdateListCup()
end

function PlayerHeadIconView:UpdateListCup()
    if self.CupCollectList == nil then
        self.CupCollectList = IllustratedHandbookDataManager:Get():GetIllustratedHandbookDataList(IllustratedHandbookType.Cup)
    end

    CommonHelper:CSGameObjectSetActive(self.BgListScroll.gameObject, _curSelectType == HeadIconAttrType.BG)
    CommonHelper:CSGameObjectSetActive(self.CupListScroll.gameObject, _curSelectType == HeadIconAttrType.Cup)
    local UpdateFunc = function(dataIndex, itemObj, scroll)
        local data = self.CupCollectList[dataIndex]
        local SelectImageTrans = self:GetChildByParent("SelectImage", itemObj)
        local iconName = 'playerbg_z_default.png'
        if dataIndex ~= 0 then
            ---@type dictarticle_config_cell
            local articleCfg = CommonHelper:GetTableDataByID(ConfigNames.article_config, data.cupid)
            iconName = articleCfg.NewIcon
            CommonHelper:GetComponentSetUITexture("Icon", itemObj, iconName, self:GetUIModuleID())
        end
        CommonHelper:SetGameObjectActive("default", itemObj, dataIndex == 0)
        CommonHelper:SetGameObjectActive("Icon", itemObj, dataIndex ~= 0)
        local tempId = self.PlayerSampleInfoData.cups[_curSelectCup]
        SelectImageTrans.gameObject:SetActive(data == nil and dataIndex == tempId or (data and data:GetCupCollectConfig().C_ID == tempId))
        CommonHelper:SetGameObjectActive("normal", itemObj, data==nil or data:GetCupCollectConfig().C_ID ~= tempId)
        CommonHelper:SetGameObjectActive("lock", itemObj,  data and not data:IsActive())
        CommonHelper:HButtonSetCallback("ItemBtn", itemObj, function(param)
            local id = data == nil and 0 or data:GetCupCollectConfig().C_ID
            if _curSelectCup == 1 then

                if id ~= 0 and( id == self.PlayerSampleInfoData.cups[2] or id == self.PlayerSampleInfoData.cups[3] )then
                    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CupAlreadyChosen))
                else
                    self.PlayerSampleInfoData.cups[1] = id
                end
            elseif _curSelectCup == 2 then
                if id ~= 0 and (id == self.PlayerSampleInfoData.cups[1] or id == self.PlayerSampleInfoData.cups[3]) then
                    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CupAlreadyChosen))
                else
                    self.PlayerSampleInfoData.cups[2] = id
                end
            elseif _curSelectCup == 3 then
                if id ~= 0 and (id == self.PlayerSampleInfoData.cups[1] or id == self.PlayerSampleInfoData.cups[2]) then
                    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CupAlreadyChosen))
                else
                    self.PlayerSampleInfoData.cups[3] = id
                end
            end
            CommonHelper:MoreRowView_RefreshCurList(self.CupListScroll, false)
            self.Page_PlayerSampleInfoView:Refresh(self.PlayerSampleInfoData, true)
            if _curSelectType == HeadIconAttrType.Cup then
                CommonHelper:SetGameObjectActive("CupBg1", self.gameObject, self.PlayerSampleInfoData.cups[1] == nil or self.PlayerSampleInfoData.cups[1] == 0)
                CommonHelper:SetGameObjectActive("CupBg2", self.gameObject, self.PlayerSampleInfoData.cups[2] == nil or self.PlayerSampleInfoData.cups[2] == 0)
                CommonHelper:SetGameObjectActive("CupBg3", self.gameObject, self.PlayerSampleInfoData.cups[3] == nil or self.PlayerSampleInfoData.cups[3] == 0)
            end

        end, dataIndex)
    end
    CommonHelper:InitMoreRowScrollView(self.CupListScroll, #self.CupCollectList + 1, 6, UpdateFunc, true)
end

function PlayerHeadIconView:UpdateListBg()
    ---@type table<number,dictarticle_config_cell>

    local IconList = self.headBgList
    local curSelectId = _curSelectBg
    CommonHelper:CSGameObjectSetActive(self.BgListScroll.gameObject, _curSelectType == HeadIconAttrType.BG)
    CommonHelper:CSGameObjectSetActive(self.CupListScroll.gameObject, _curSelectType == HeadIconAttrType.Cup)
    self:UpdateCupBtnState(0)
    local UpdateFunc = function(dataIndex, itemObj, scroll)

        local SelectImageTrans = self:GetChildByParent("SelectImage", itemObj)
        local Icon = self:GetChildWightByParent("bgIcon", itemObj, typeof(RawImage))
        local iconData = IconList[dataIndex]
        local icon = 'playerbg_z_default.png'
        if iconData then
            if self.dynamicDic[self.headBgIconDic[iconData.C_ID].icon] then
                icon = string.format("%s.png", string.gsub(self.headBgIconDic[iconData.C_ID].icon, "prefab_", ""))
            else
                icon = string.format("%s.png", self.headBgIconDic[iconData.C_ID].icon)
            end
            local isNotLock = KnapsackDataManager:Get():GetArticleCountByCfgid(iconData.C_ID) > 0
            CommonHelper:SetGameObjectActive("lock", itemObj, not isNotLock)
        else
            CommonHelper:SetGameObjectActive("lock", itemObj, false)
        end
        CommonHelper:SetUITexture(Icon, icon, UIModuleID.PlayerInfo)
        SelectImageTrans.gameObject:SetActive(curSelectId == dataIndex or (iconData and iconData.C_ID == curSelectId))
        CommonHelper:SetGameObjectActive("normal", itemObj, curSelectId == dataIndex or (iconData and iconData.C_ID ~= curSelectId))
        CommonHelper:HButtonSetCallback("ItemBtn", itemObj, function(param)
            curSelectId = iconData == nil and 0 or iconData.C_ID
            CommonHelper:MoreRowView_RefreshCurList(self.BgListScroll, false)
            self.PlayerSampleInfoData:SetBgId(curSelectId)
            self.Page_PlayerSampleInfoView:Refresh(self.PlayerSampleInfoData, true)
            _curSelectBg = curSelectId
        end, dataIndex)
    end
    CommonHelper:InitMoreRowScrollView(self.BgListScroll, #IconList + 1, 6, UpdateFunc, true)
end

function PlayerHeadIconView:UpdateListIconAndFrame()
    local IconList = {}
    local curSelectId = nil
    if _curSelectType == HeadIconAttrType.Head then
        IconList = self.headIconList
        curSelectId = _curSelectHeadIcon
    elseif _curSelectType == HeadIconAttrType.Frame then
        IconList = self.headFrameList
        curSelectId = _curSelectHeadFrameIcon
    else
        return
    end

    local UpdateFunc = function(dataIndex, itemObj, scroll)
        local SelectImageTrans = self:GetChildByParent("SelectImage", itemObj)
        local HeadIcon = self:GetChildWightByParent("HeadIcon", itemObj, typeof(RawImage))
        --local GrayImage = self:GetChildWightByParent("GrayImage", itemObj, typeof(Image))
        ---@type dictheadicon_config_cell
        local iconData = IconList[dataIndex + 1]
        if _curSelectType == HeadIconAttrType.Head then
            ---@type hero_config_cell
            local hero_config_cell = CommonHelper:GetTableDataByID(ConfigNames.hero_config, tonumber(iconData.icon))
            CommonHelper:SetUITexture(HeadIcon, hero_config_cell.NewIcon, UIModuleID.PlayerInfo)
            CommonHelper:SetGameObjectActive("lock", itemObj, false)
        else
            CommonHelper:SetUITexture(HeadIcon, iconData.icon .. ".png", UIModuleID.PlayerInfo)
            CommonHelper:SetGameObjectActive("lock", itemObj, not PlayerDataManager:Get():CheckHasIconFrame(iconData.C_ID))
        end

        SelectImageTrans.gameObject:SetActive(iconData.C_ID == curSelectId)
        CommonHelper:SetGameObjectActive("normal", itemObj, iconData.C_ID ~= curSelectId)
        CommonHelper:HButtonSetCallback("ItemBtn", itemObj, function(param)
            curSelectId = IconList[param.intData + 1].C_ID
            CommonHelper:MoreRowView_RefreshCurList(self.headListScroll, false)
            self:UpdateBaseInfo(iconData, _curSelectType)
        end, dataIndex)
    end
    CommonHelper:InitMoreRowScrollView(self.headListScroll, #IconList, 6, UpdateFunc, true)
end

function PlayerHeadIconView:InitViewBtn()
    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(param)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnClose2", self.gameObject, function(param)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnChange", self.Page_HeadIcon, function(param)
        self:OnChangeBtnClick()
    end)
    CommonHelper:HButtonSetCallback("BtnChange", self.Page_BgAndCup, function(param)
        self:OnChangeBtnClick()
    end)
end

---@param iconData dictheadicon_config_cell
function PlayerHeadIconView:UpdateBaseInfo(iconData, type)
    if iconData == nil then
        return
    end
    if type == HeadIconAttrType.Head then
        _curSelectHeadIcon = iconData.C_ID
    elseif type == HeadIconAttrType.Frame then
        _curSelectHeadFrameIcon = iconData.C_ID
    end
    if type == HeadIconAttrType.Head then
        ---@type hero_config_cell
        local hero_config_cell = CommonHelper:GetTableDataByID(ConfigNames.hero_config, tonumber(iconData.icon))
        CommonHelper:SetText("###HeadNameText", self.Page_HeadIcon, iconData.name == -1 and CommonHelper:GetTempStr_Default(TemplateStringID.HeadIconDefault) or ClientDataManager:Get():GetTemplateString(hero_config_cell.name))
        -- CommonHelper:SetText("###DeadlineText", self.center, iconData.endTime == -1 and CommonHelper:GetTempStr_Default(TemplateStringID.HeadIconOnly) or tostring(iconData.endTime))

        CommonHelper:SetPlayerIcon("RoleIconGourp1", self.gameObject, hero_config_cell.NewIcon, nil, nil, UIModuleID.PlayerInfo)
    elseif type == HeadIconAttrType.Frame then
        CommonHelper:SetText("###HeadNameText", self.Page_HeadIcon, CommonHelper:GetTempStr_Default(iconData.name))
        -- CommonHelper:SetText("###DeadlineText", self.center, iconData.endTime == -1 and CommonHelper:GetTempStr_Default(TemplateStringID.HeadIconOnly) or tostring(iconData.endTime))
        CommonHelper:SetPlayerIcon("RoleIconGourp1", self.gameObject, nil, iconData.icon .. ".png", nil, UIModuleID.PlayerInfo)
    end

    local desc = ""
    if iconData.unlocktype == HeadUnlockType.Level then
        desc = iconData.term == "-1" and string.format("%s%d", CommonHelper:GetTempStr_Default(TemplateStringID.HeadIconLevelTo), tonumber(iconData.cond)) or ClientDataManager:Get():GetTemplateString(iconData.term)
        CommonHelper:SetText("###HeadUnlockConditionText", self.Page_HeadIcon, desc)
    elseif iconData.unlocktype == HeadUnlockType.Diamond then
        desc = iconData.term == "-1" and string.format("%s%d%s", CommonHelper:GetTempStr_Default(TemplateStringID.HeadIconPay), tonumber(iconData.cond), CommonHelper:GetTempStr_Default(TemplateStringID.HeadIconOnlyDiamond)) or ClientDataManager:Get():GetTemplateString(iconData.term)
        CommonHelper:SetText("###HeadUnlockConditionText", self.Page_HeadIcon, desc)
    elseif iconData.unlocktype == HeadUnlockType.Coin then
        desc = iconData.term == "-1" and string.format("%s%d%s", CommonHelper:GetTempStr_Default(TemplateStringID.HeadIconPay), tonumber(iconData.cond), CommonHelper:GetTempStr_Default(TemplateStringID.HeadIconOnlyGold)) or ClientDataManager:Get():GetTemplateString(iconData.term)
        CommonHelper:SetText("###HeadUnlockConditionText", self.Page_HeadIcon, desc)
    else
        CommonHelper:SetText("###HeadUnlockConditionText", self.Page_HeadIcon, iconData.term)
    end
    CommonHelper:SetText("###HeadUnlockConditionText", self.Page_HeadIcon, CommonHelper:GetTempStr_Default(TemplateStringID.HeadIconNone))
end

function PlayerHeadIconView:PageUpdateData()

    if _curSelectType > HeadIconAttrType.Frame then
        PlayerSampleInfoDataManager:Get():GetSelfSampleInfo():Clone(self.PlayerSampleInfoData)
        self.Page_PlayerSampleInfoView:Refresh(self.PlayerSampleInfoData, true)
        if _curSelectType == HeadIconAttrType.Cup then
            CommonHelper:SetGameObjectActive("CupBg1", self.gameObject, self.PlayerSampleInfoData.cups[1] == nil or self.PlayerSampleInfoData.cups[1] == 0)
            CommonHelper:SetGameObjectActive("CupBg2", self.gameObject, self.PlayerSampleInfoData.cups[2] == nil or self.PlayerSampleInfoData.cups[2] == 0)
            CommonHelper:SetGameObjectActive("CupBg3", self.gameObject, self.PlayerSampleInfoData.cups[3] == nil or self.PlayerSampleInfoData.cups[3] == 0)
        end
    else
        local cfgIcon = CommonHelper:GetTableDataByID(ConfigNames.headicon_config, PlayerDataManager:Get():GetPlayerIcon())
        local cfgIconFrame = nil
        if PlayerDataManager:Get():GetPlayerIconFrame() <= 1000 then
            cfgIconFrame = CommonHelper:GetTableDataByID(ConfigNames.headicon_config, 1000)
        else
            cfgIconFrame = CommonHelper:GetTableDataByID(ConfigNames.headicon_config, PlayerDataManager:Get():GetPlayerIconFrame())
        end
        if _curSelectType == HeadIconAttrType.Head then
            self:UpdateBaseInfo(cfgIconFrame, HeadIconAttrType.Frame)
            self:UpdateBaseInfo(cfgIcon, HeadIconAttrType.Head)
        else
            self:UpdateBaseInfo(cfgIcon, HeadIconAttrType.Head)
            self:UpdateBaseInfo(cfgIconFrame, HeadIconAttrType.Frame)
        end
    end
end
function PlayerHeadIconView:OnPageClick()
    _curSelectHeadFrameIcon = PlayerDataManager:Get():GetPlayerIconFrame()
    _curSelectHeadIcon = PlayerDataManager:Get():GetPlayerIcon()
    _curSelectBg = PlayerDataManager:Get():GetBgId()
    self:PageUpdateData()
    CommonHelper:CSGameObjectSetActive(self.Page_HeadIcon, _curSelectType < HeadIconAttrType.BG)
    CommonHelper:CSGameObjectSetActive(self.Page_BgAndCup, _curSelectType > HeadIconAttrType.Frame)

    if _curSelectType < HeadIconAttrType.BG then
        self:UpdateListIconAndFrame()
    elseif _curSelectType == HeadIconAttrType.BG then
        self:UpdateListBg()
    elseif _curSelectType == HeadIconAttrType.Cup then
        self:UpdateCupBtnState(1)
    end
    CommonHelper:SetText("###HeadTitleText", self.gameObject, allType[_curSelectType].title)
end

function PlayerHeadIconView:OnChangeBtnClick()
    if _curSelectHeadFrameIcon ~= PlayerDataManager:Get():GetPlayerIconFrame() then
        if PlayerDataManager:Get():CheckHasIconFrame(_curSelectHeadFrameIcon) then
            PlayerInfoSubsystem:Get():SendMsg_ChangeHeadIconFrame(PlayerDataManager:Get():GetPlayerIcon(), _curSelectHeadFrameIcon)
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NotHasIconFrame))
        end
    end
    if _curSelectHeadIcon ~= PlayerDataManager:Get():GetPlayerIcon() then
        PlayerInfoSubsystem:Get():SendMsg_ChangeHeadIconFrame(_curSelectHeadIcon, PlayerDataManager:Get():GetPlayerIconFrame())
    end

    if _curSelectType == HeadIconAttrType.BG then
        if self.PlayerSampleInfoData.bgIcon ~= PlayerSampleInfoDataManager:Get():GetSelfSampleInfo().bgIcon then
            if _curSelectBg == 0 or KnapsackDataManager:Get():GetArticleCountByCfgid(_curSelectBg) > 0 then
                PlayerInfoSubsystem:Get():SendMsg_ChangePlayerBG(_curSelectBg)
            else
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.BackGroundIsLock))
            end
        end
    end

    if _curSelectType == HeadIconAttrType.Cup then
        if self.PlayerSampleInfoData.cups[1] ~= PlayerSampleInfoDataManager:Get():GetSelfSampleInfo().cups[1] or
                self.PlayerSampleInfoData.cups[2] ~= PlayerSampleInfoDataManager:Get():GetSelfSampleInfo().cups[2] or
                self.PlayerSampleInfoData.cups[3] ~= PlayerSampleInfoDataManager:Get():GetSelfSampleInfo().cups[3]
        then
            if IllustratedHandbookDataManager:Get():CheckCupsNotLock(self.PlayerSampleInfoData.cups) then
                PlayerInfoSubsystem:Get():SendMsg_ChangePlayerCups(self.PlayerSampleInfoData.cups)
            else
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CupIsLock))
            end
        end
    end
end

--function PlayerHeadIconView:InitBtnShow(isChangeBtnShow, isUnlockBtnShow)
--    CommonHelper:SetHButtonClick(self.BtnChange, isChangeBtnShow, true)
--    CommonHelper:SetHButtonClick(self.BtnUnlock, isUnlockBtnShow, true)
--end

---@param iconData headicon_config_cell
function PlayerHeadIconView:IsSatisfyLockCondition(iconData)
    local condition = string.find(iconData.cond, ',')
    local items = {}
    local isHave = false
    if condition then
        items = stringSplit(iconData.cond, ',')
    else
        items = stringSplit(iconData.cond, ';')
    end
    for i = 1, #items do
        if condition then
            if KnapsackDataManager:Get():GetArticleCountByCfgid(tonumber(items[i])) > 0 then
                isHave = true
                break
            end
        else
            isHave = true
            if KnapsackDataManager:Get():GetArticleCountByCfgid(tonumber(items[i])) <= 0 then
                isHave = false
                break
            end
        end
    end
    return isHave
end

---@param iconData headicon_config_cell
function PlayerHeadIconView:InitPlayerIcon(iconData, GrayImage)
    if iconData.style == HeadUnlockType.Level then
        if PlayerDataManager:Get():GetPlayerLV() >= tonumber(iconData.class) then
            GrayImage.gameObject:SetActive(false)
        else
            GrayImage.gameObject:SetActive(true)
        end
    end
    if iconData.style == HeadUnlockType.Pic then
        if self:IsSatisfyLockCondition(iconData) then
            GrayImage.gameObject:SetActive(false)
        else
            GrayImage.gameObject:SetActive(true)
        end
    end
end

function PlayerHeadIconView:GetUIModuleID()
    return UIModuleID.PlayerInfo
end

function PlayerHeadIconView:OnClose()
    self.Page_PlayerSampleInfoView:Clear()
    PersonalHomeHelper.SetIsCanOperationSign(true)
end