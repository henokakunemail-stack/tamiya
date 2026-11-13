---@class FriendChoosePropView : ViewBase
FriendChoosePropView = class("LabSelectPopView", ViewBase)

function FriendChoosePropView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "FriendChoosePropViewAction")

end

local FType

function FriendChoosePropView:Awake()
    self.selectItemID = 0
    self.selectTypeID = -1

    self.leftPartSVC = self:GetChildWightByParent("leftPartSVC", self.gameObject, typeof(MoreRowScrollView))
    self.TypeScroll = self:GetChildWightByParent("TypeScroll", self.gameObject, typeof(MoreRowScrollView))

    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
    end)

    CommonHelper:HButtonSetCallback("BtnLend", self.gameObject, function(data)
        local _lockTxt = CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendLendThisPart)
        local FriendID = RentAndLendDataManager:Get():GetChoosePartFriendID()
        local HeadIcon = RentAndLendDataManager:Get():GetChoosePartHeadIcon()
        local RoleName = RentAndLendDataManager:Get():GetChoosePartRoleName()
        local IconFrame = RentAndLendDataManager:Get():GetChoosePartIconFrame()
        local CurLevel = RentAndLendDataManager:Get():GetChoosePartCurLevel()

        local boxFunc = function()
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, _lockTxt)
            if ret == MessageBoxHelp.BtnType.OK then
                --print("--532, --请求租借配件 P2=好友rid P3=配件索引 P4=角色名 P5=headicon P6=iconframe P7=curlevel", FriendID, self.selectItemPartID, RoleName, HeadIcon, IconFrame, CurLevel)
                RentAndLendSubsystem:Get():SendMsg_BorrowPart(FriendID, self.selectItemPartID, RoleName, HeadIcon, IconFrame, CurLevel)
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
    end)

    self.BtnRent = CommonHelper:HButtonSetCallback("BtnRent", self.gameObject, function(data)
        local _lockTxt = CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendRentThisPart)
        local FriendID = RentAndLendDataManager:Get():GetChoosePartFriendID()

        local boxFunc = function()
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, _lockTxt)
            if ret == MessageBoxHelp.BtnType.OK then
                --print("--546, --请求雇佣配件 P2=好友rid P3=配件索引", FriendID, self.selectItemPartID)
                RentAndLendSubsystem:Get():SendMsg_HirePart(FriendID, self.selectItemPartID)
            end
        end

        MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
    end)


end

function FriendChoosePropView:OnOpen()
    self.selectItemID = 0
    self.selectTypeID = -1

    self:InitFriendChooseTypePart()

end

function FriendChoosePropView:InitFriendChooseTypePart()
    ---@type goodstype_config
    local goodstype_config = ClientDataManager:Get():GetDataTable(ConfigNames.goodstype_config)
    local _TypeData = {}
    table.insert(_TypeData, -1)
    local temp = goodstype_config.GetListType2(GoodsType1.Part)
    for i = 1, #temp do
        table.insert(_TypeData, temp[i].type2)
    end

    CommonHelper:InitMoreRowScrollView(self.TypeScroll, #_TypeData, 1, function(index, itemObj, scroll)
        local tog = CommonHelper:HButtonSetCallback("TagBtn", itemObj, function(btnData)
            if self.selectTypeID ~= _TypeData[btnData.intData + 1] then
                self:SetChoosePartType(FType, _TypeData[btnData.intData + 1])
            end
        end, index)

        if _TypeData[index + 1] ~= -1 then
            local typeName = CommonHelper:GetGoodsTypeName(GoodsType1.Part, _TypeData[index + 1])
            local icon = CommonHelper:GetGoodsTypeIcon(GoodsType1.Part, _TypeData[index + 1])
            CommonHelper:SetText("hover/###text", itemObj, typeName)
            CommonHelper:SetText("normal/###text", itemObj, typeName)
            CommonHelper:GetComponentSetImage("typeImage", itemObj, icon, UIModuleID.FriendChooseProp)
        else
            local icon = CommonHelper:GetGoodsTypeIcon(GoodsType1.Part, _TypeData[index + 1])
            CommonHelper:GetComponentSetImage("typeImage", itemObj, icon, UIModuleID.FriendChooseProp)
            CommonHelper:SetText("hover/###text", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.BagPartALL))
            CommonHelper:SetText("normal/###text", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.BagPartALL))
        end
        CommonHelper:SetToggleState(tog, _TypeData[index + 1] == self.selectTypeID)
    end)


end

function FriendChoosePropView:SetChoosePartType(_FType, _type)
    local _partData = {}
    if _type == -1 then
        _partData = RentAndLendDataManager:Get():GetChoosePartData()
    else
        _partData = RentAndLendDataManager:Get():GetChoosePartDataByType(_type)
    end

    if #_partData > 0 then
        self.PartData = {}
        self.PartData = _partData
        self.PartData = CommonHelper:SortPart_1(self.PartData)
        self.selectTypeID = _type
        self.selectItemID = 0
        self.selectItemPartID = self.PartData[1].CellId
        CommonHelper:MoreRowView_RefreshCurList(self.TypeScroll, false)
        self:InitChoosePart()
        self:RefreshMessage()
    else
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendRentNoTypePart))
    end

    FType = _FType
    CommonHelper:SetGameObjectActive("BtnLend", self.gameObject, _FType == FriendRentAndLendType.Lend)
    CommonHelper:SetGameObjectActive("BtnRent", self.gameObject, _FType == FriendRentAndLendType.Rent)

    if _FType == FriendRentAndLendType.Rent then
        local RentCostNum = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.RentCostNum)
        local rentCostTxt = stringSplitToNumber(RentCostNum.varval, ':')

        local propCfg = CommonHelper:GetTableDataByID(ConfigNames.article_config, rentCostTxt[1])
        CommonHelper:GetComponentSetUITexture("rentBG/RawImage", self.gameObject, propCfg.NewIcon, UIModuleID.FriendChooseProp)
        CommonHelper:SetText("rentBG/###RentTxt", self.gameObject, rentCostTxt[2])
        CommonHelper:SetGameObjectActive("rentBG", self.gameObject, true)
    end

    if _FType == FriendRentAndLendType.Lend then
        CommonHelper:SetGameObjectActive("LendBG", self.gameObject, false)
        CommonHelper:SetGameObjectActive("rentBG", self.gameObject, false)
    end

end

function FriendChoosePropView:InitChoosePart()

    local UpdateFunc = function(dataIndex, itemObj, scroll)
        local obj = UIUtil.GetChild("ItemPart_138", itemObj)
        ---@type BorrowPartData
        local _data = self.PartData[dataIndex + 1]
        local param = Param_ItemPartParam()
        param.star = _data.Star
        param.lv = _data.Level
        param.awaken = _data.Awaken
        param.generation = _data.Generation
        CommonHelper:SetItemPartGroup(obj, UIModuleID.LabChooseProp, _data.CfgId, ItemPartUIType.Normal, param)

        CommonHelper:HButtonSetCallback("ItemBtn_L", itemObj, function(data)
            self.selectItemID = dataIndex
            self.selectItemPartID = _data.CellId
            print("选中的车壳索引 ****  ", self.selectItemPartID)
            self:InitChoosePart()
            self:RefreshMessage()
        end)

        CommonHelper:SetGameObjectActive("chooseLock", itemObj, false)
        CommonHelper:SetGameObjectActive("chooseShow", itemObj, self.selectItemID == dataIndex)

    end

    CommonHelper:InitMoreRowScrollView(self.leftPartSVC, #self.PartData, 6, UpdateFunc, true, nil, false)

end

function FriendChoosePropView:RefreshMessage()
    self.messageSVC = UIUtil.GetTypeChildWightInputPath("messageSVC", self.gameObject, typeof(CustomScrollView))

    local _mesData = self.PartData[self.selectItemID + 1]
    local _data, _svcData = self:SetMessageData(_mesData)

    CommonHelper:CustomView_Init(self.messageSVC, _data, function(index, itemObj, scroll)
        local _dataIndex = _data[index + 1]
        local _showData = _svcData[index + 1]

        if _dataIndex == 0 then
            CommonHelper:SetText("###titleText", itemObj, _showData)
        end

        if _dataIndex == 1 then
            CommonHelper:SetText("###key", itemObj, _showData[1])
            CommonHelper:SetText("###value", itemObj, _showData[2])
        end

        if _dataIndex == 2 then
            if _showData ~= -1 then
                for i = 1, 3 do
                    CommonHelper:SetGameObjectActive("icon" .. i, itemObj, (_showData.quality) == i)
                end
                CommonHelper:SetText("###iconText", itemObj, string.format("Lv %d/%d", _showData.lv, 20))

                local cfg = CommonHelper:GetDevelopByEntryId(_showData.id)
                CommonHelper:SetText("###iconName", itemObj, ClientDataManager:Get():GetTemplateString(cfg.name))

                CommonHelper:SetGameObjectActive("icon1", itemObj, true)
                CommonHelper:SetGameObjectActive("icon2", itemObj, true)
                CommonHelper:SetGameObjectActive("icon3", itemObj, true)
                CommonHelper:SetGameObjectActive("###iconText", itemObj, true)
                CommonHelper:SetGameObjectActive("###iconName", itemObj, true)
                CommonHelper:SetGameObjectActive("###NotText", itemObj, false)
            else
                CommonHelper:SetGameObjectActive("icon1", itemObj, false)
                CommonHelper:SetGameObjectActive("icon2", itemObj, false)
                CommonHelper:SetGameObjectActive("icon3", itemObj, false)
                CommonHelper:SetGameObjectActive("###iconText", itemObj, false)
                CommonHelper:SetGameObjectActive("###iconName", itemObj, false)
                CommonHelper:SetGameObjectActive("###NotText", itemObj, true)

                CommonHelper:SetText("###NotText", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.FriendChooseProp_4))
            end
        end

        if _dataIndex == 3 then
            if _showData ~= -1 then
                CommonHelper:SetText("###smalltitle", itemObj, _showData[1])
                CommonHelper:SetText("###smalltitleText", itemObj, _showData[2])
                CommonHelper:SetGameObjectActive("bg2", itemObj, true)
            else
                CommonHelper:SetGameObjectActive("bg2", itemObj, false)
                CommonHelper:SetText("###smalltitle", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.FriendChooseProp_5))
            end
        end

    end)

    CommonHelper:SetText("ShowPart/###articleName", self.gameObject, ClientDataManager:Get():GetTemplateString(_mesData.partConfig.partname))
    CommonHelper:GetComponentSetUITexture("ShowPart/PartItem/partIcon", self.gameObject, _mesData.partConfig.icon, UIModuleID.FriendChooseProp)
    CommonHelper:SetComponentPartStar("ShowPart/PartStar", self.gameObject, _mesData.Star)
    CommonHelper:SetGameObjectActive("ShowPart/PartStar", self.gameObject, not _mesData.Awaken)
    CommonHelper:SetComponentPartStar("ShowPart/PartStarAwake", self.gameObject, _mesData.Star)
    CommonHelper:SetGameObjectActive("ShowPart/PartStarAwake", self.gameObject, _mesData.Awaken)
    CommonHelper:SetText("ShowPart/PartItem/levelBg/###level", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.BagPartLevel, _mesData.Level))
    CommonHelper:SetText("ShowPart/scores/###value", self.gameObject, string.format("%0.0f", _mesData.Score))

end

function FriendChoosePropView:SetMessageData(mesData)
    local _data = {}
    local _svcData = {}

    table.insert(_data, 0)
    table.insert(_svcData, CommonHelper:GetTempStr_Default(TemplateStringID.FriendChooseProp_1)) --TemplateStringID
    local SecondAttrs = mesData:GetPartSecondAttrs()
    if #SecondAttrs > 0 then
        for i, v in pairs(SecondAttrs) do
            table.insert(_data, 1)
            local type = CommonHelper:GetAttrName(v.type)
            local value = CommonHelper:GetAttrValue(v.type, v.value)
            table.insert(_svcData, { type, value })
        end
    end

    table.insert(_data, 0)
    table.insert(_svcData, CommonHelper:GetTempStr_Default(TemplateStringID.FriendChooseProp_2)) --TemplateStringID
    local Entry = mesData:GetPartReformList()
    if #Entry > 0 and Entry[1].quality > 0 then
        for i, v in pairs(Entry) do
            if v.quality > 0 then
                table.insert(_data, 2)
                table.insert(_svcData, v)

            end
        end
    else
        table.insert(_data, 2)
        table.insert(_svcData, -1)
    end

    table.insert(_data, 0)
    table.insert(_svcData, CommonHelper:GetTempStr_Default(TemplateStringID.FriendChooseProp_3)) --TemplateStringID
    if mesData:GetPartType() == PartType.Shell then
        local bufflist = mesData:GetPartShellBuffs()
        if #bufflist > 0 then
            for i, v in pairs(bufflist) do
                table.insert(_data, 3)
                local buffName = CommonHelper:GetTempStr_Default(v.BuffCfg.name)
                local buffDesc = CommonHelper:GetTempStr_Default(v.BuffCfg.desc)
                table.insert(_svcData, { buffName, buffDesc })
            end

        end
    else
        table.insert(_data, 3)
        table.insert(_svcData, -1)
    end

    return _data, _svcData
end

function FriendChoosePropView:OnClose()

end