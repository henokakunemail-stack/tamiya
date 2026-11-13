---@class WarehouseView : ViewBase
WarehouseView = class("WarehouseView", ViewBase)

local _SelectItem = -1
local _Data = nil
local _SelectType = -1
local _TypeData = nil

local __AddNum = -1

local __TAddNum = -1

local WareHouseDecomposeMax
local WareHouseAllDecomposeMax

function WarehouseView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "WarehouseViewAction")
end

function WarehouseView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(hbtn)
        UIManager:Get():CloseView()
    end)

    self.TypeScroll = self:GetChildWight("TypeScroll", typeof(MoreRowScrollView))
    self.ScrollView = self:GetChildWight("MoreRowScrollView_V", typeof(MoreRowScrollView))

    self.ArticleView = self:GetChildWight("articleView", typeof(CanvasGroup))
    self.articleViewObj = self:GetChild("articleView")

    UIUtil.ShowCanvasGroup(self.ArticleView, false)

    self.DisassembleView = self:GetChildWight("DisassembleView", typeof(CanvasGroup))
    self.DisassembleView.gameObject:SetActive(false)

end

function WarehouseView:OnOpen()
    _SelectType = -1
    self:ViewFixScreen()
    ---@type goodstype_config
    local goodstype_config = ClientDataManager:Get():GetDataTable(ConfigNames.goodstype_config)
    _TypeData = {}
    table.insert(_TypeData, -1)
    local temp = goodstype_config.GetListType2(GoodsType1.Part)
    for i = 1, #temp do
        table.insert(_TypeData, temp[i].type2)
    end

    WareHouseDecomposeMax = tonumber(CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.WareHouseDecomposeMax).varval)
    WareHouseAllDecomposeMax = tonumber(CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.WareHouseAllDecomposeMax).varval)

    self:SetScrollViewPart(true)
end

function WarehouseView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.AccessoryWarehouse)
end

function WarehouseView:SetScrollViewPart(ischeck,flag)
    local check = ischeck

    _SelectItem = 0

    if _SelectType == -1 then
        _Data = WarehouseDataManager:Get():GetAllData()
    else
        _Data = WarehouseDataManager:Get():GetDataByType(_SelectType)
    end

    print("_SelectType   _SelectType---", _SelectType)

    if check then
        _TypeData = {}
        ---@type goodstype_config
        local goodstype_config = ClientDataManager:Get():GetDataTable(ConfigNames.goodstype_config)
        table.insert(_TypeData, -1)
        local temp = goodstype_config.GetListType2(GoodsType1.Part)
        for i = 1, #temp do
            table.insert(_TypeData, temp[i].type2)
        end
        self:SetTypeScroll(flag)
    end

    if #_Data > 0 then
        _Data = WarehouseView:SortPart_1(_Data)
    end

    self:SetData(flag)

    if #_Data > 0 then
        _SelectItem = 0
        self:SetArticleView()
    end

    self:TipsComponent()
end

function WarehouseView:SetTypeScroll()
    CommonHelper:InitMoreRowScrollView(self.TypeScroll, #_TypeData, 1, function(index, itemObj, scroll)
        local tog = CommonHelper:HButtonSetCallback("TagBtn", itemObj, function(btnData)
            if _SelectType ~= _TypeData[btnData.intData + 1] then
                _SelectType = _TypeData[btnData.intData + 1]
                self:SetScrollViewPart(false)
                CommonHelper:MoreRowView_RefreshCurList(self.TypeScroll, false)
            end
        end, index)
        if _TypeData[index + 1] ~= -1 then
            local typeName = CommonHelper:GetGoodsTypeName(GoodsType1.Part, _TypeData[index + 1])
            local icon = CommonHelper:GetGoodsTypeIcon(GoodsType1.Part, _TypeData[index + 1])
            CommonHelper:SetText("hover/###text", itemObj, typeName)
            CommonHelper:SetText("normal/###text", itemObj, typeName)
            CommonHelper:GetComponentSetImage("typeImage", itemObj, icon, UIModuleID.AccessoryWarehouse)
        else
            local icon = CommonHelper:GetGoodsTypeIcon(GoodsType1.Part, _TypeData[index + 1])
            CommonHelper:GetComponentSetImage("typeImage", itemObj, icon, UIModuleID.AccessoryWarehouse)
            CommonHelper:SetText("hover/###text", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.BagPartALL))
            CommonHelper:SetText("normal/###text", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.BagPartALL))
        end
        CommonHelper:SetToggleState(tog, _TypeData[index + 1] == _SelectType)
    end)


end

function WarehouseView:SetData(flag)
    CommonHelper:SetGameObjectActive("BagEmpty", self.gameObject, #_Data <= 0)

    UIUtil.ShowCanvasGroup(self.ArticleView, #_Data > 0)

    local scrollNum = WarehouseDataManager:Get():GetAllDataLength()

    CommonHelper:InitMoreRowScrollView(self.ScrollView, #_Data, 6, function(index, itemObj, scroll)

        ---@type WarehouseCell
        local temp = _Data[index + 1]
        local param = Param_PropSquareParam()
        param.id = temp:GetID()
        param.moduleId = UIModuleID.AccessoryWarehouse
        param.count = temp:GetCount()
        param.quality = temp:GetPartBaseConfig().fabric
        param.showname = false
        CommonHelper:SetPropSquareGroupWareHouse(itemObj, param)

        CommonHelper:HButtonSetCallback("BtnItem", itemObj, function(data)
            _SelectItem = data.intData
            self:SetArticleView()
            CommonHelper:MoreRowView_RefreshCurList(scroll, false)
        end, index)
        CommonHelper:SetGameObjectActive("selctBg", itemObj, _SelectItem == index)
    end,false,nil,flag)
end

function WarehouseView:SetArticleView()

    UIUtil.ShowCanvasGroup(self.ArticleView, _SelectItem ~= -1)

    if _SelectItem ~= -1 then
        local part = CommonHelper:SetGameObjectActive("partview", self.articleViewObj, true)

        ---@type WarehouseCell
        local data = _Data[_SelectItem + 1]
        ---@type dictarticle_config_cell
        ---@type dictparts_config_cell
        local propType, cfg = CommonHelper:GetPropTypeById(data:GetID())

        CommonHelper:SetText("###articleName", part, ClientDataManager:Get():GetTemplateString(cfg.partname))
        CommonHelper:GetComponentSetUITexture("partIcon", part, cfg.icon, UIModuleID.AccessoryWarehouse)
        CommonHelper:SetText("scroes/###value", part, string.format("%0.0f", data:GetPartConfig().score))
        --{{{ 属性
        local attValueList = {}
        for i, v in pairs(data:GetPartAgeConfig().NewAttr) do
            table.insert(attValueList, { v.type, v.value })
        end

        for i = 1, 8 do
            local temp = attValueList[i]
            local obj = CommonHelper:SetGameObjectActive("grid/attr" .. i, part, temp ~= nil)
            if temp then
                CommonHelper:SetText("###key", obj, CommonHelper:GetAttrName(tonumber(temp[1])))
                CommonHelper:SetText("###value", obj, CommonHelper:GetAttrValue(temp[1], temp[2]))
            end
        end
        --}}}

        --取出
        self.BtnTakeOut = CommonHelper:HButtonSetCallback("BtnTakeOut", part, function(hbtn)
            local IDStr = tostring(data:GetID())
            local IDCount = tostring(__AddNum)
            WarehouseSubsystem:Get():SendMsg_GetPullPart(IDStr, IDCount)
        end)

        --分解
        self.BtnDecompose = CommonHelper:HButtonSetCallback("BtnDecompose", part, function(hbtn)
            --local IDStr = tostring(data:GetID())
            --local IDCount = tostring(__AddNum)
            --WarehouseSubsystem:Get():SendMsg_GetStoreDesc(IDStr, IDCount)
            self:RefreshTipsData(data)

            self.DisassembleView.gameObject:SetActive(true)
        end)

        __AddNum = 1
        self:SetUseNum()

        local _MaxAddNum = WareHouseDecomposeMax

        if WareHouseDecomposeMax > data:GetCount() then
            _MaxAddNum = data:GetCount()
        end
        if _MaxAddNum < data:GetCount() then
            if data:GetCount() <= WareHouseDecomposeMax then
                _MaxAddNum = data:GetCount()
            else
                _MaxAddNum = WareHouseDecomposeMax
            end
        end

        CommonHelper:HButtonSetCallback("BtnEditorAdd", part, function(data)
            __AddNum = __AddNum + 1
            if __AddNum >= _MaxAddNum then
                __AddNum = _MaxAddNum
            end
            self:SetUseNum()
        end)

        CommonHelper:HButtonSetCallback("BtnEditorRemove", part, function(data)
            __AddNum = __AddNum - 1
            if __AddNum <= 1 then
                __AddNum = 1
            end
            self:SetUseNum()
        end)

    end
end

function WarehouseView:SetUseNum()
    if __AddNum > WareHouseDecomposeMax then
        __AddNum = WareHouseDecomposeMax
    end

    CommonHelper:SetInputFieldText("###InputText", self.gameObject, __AddNum)


end

---@param list table<number, ArticleCell>
function WarehouseView:SortPart_1(list)
    ---@type table<number, ArticleCell>
    table.sort(list, function(a, b)

        --配件品质
        if a:GetPartBaseConfig().fabric > b:GetPartBaseConfig().fabric then
            return true
        end
        if a:GetPartBaseConfig().fabric < b:GetPartBaseConfig().fabric then
            return false
        end

        --配件二级分类
        if a:GetPartBaseConfig().parttype > b:GetPartBaseConfig().parttype then
            return false
        end
        if a:GetPartBaseConfig().parttype < b:GetPartBaseConfig().parttype then
            return true
        end

        --配件三级分类
        if a:GetPartBaseConfig().subtype > b:GetPartBaseConfig().subtype then
            return true
        end
        if a:GetPartBaseConfig().subtype < b:GetPartBaseConfig().subtype then
            return false
        end

        return a:GetID() > b:GetID()
    end)
    return list
end

local TipsData = nil

function WarehouseView:RefreshTipsData(_ReData)

    TipsData = _ReData

    __TAddNum = 1

    local obj = UIUtil.GetChild("ItemCom_220", self.DisassembleView.gameObject)
    local param = Param_ItemArticleParam()
    param.count = _ReData.cellNum
    CommonHelper:SetItemComGroup(obj, UIModuleID.AccessoryWarehouse, _ReData.cellId, param, function()
    end)

    local propType, cfg = CommonHelper:GetPropTypeById(_ReData.cellId)
    local _name = nil
    local _desc = nil
    if propType == PropType.Part then
        _name = cfg.partname
        _desc = cfg.partdesc
    else
        _name = cfg.name
        _desc = cfg.desc
    end

    CommonHelper:SetText("###IntroduceName", self.DisassembleView.gameObject, CommonHelper:GetTempStr_Default(_name))
    CommonHelper:SetText("###goodsdesctext", self.DisassembleView.gameObject, CommonHelper:GetTempStr_Default(_desc))
    CommonHelper:SetText("###playerHoldNum", self.DisassembleView.gameObject, _ReData.cellNum)
    self:SetTipsUseNum()
end

function WarehouseView:TipsComponent()

    CommonHelper:HButtonSetCallback("TBtnEditorRemove", self.DisassembleView.gameObject, function(data)
        __TAddNum = __TAddNum - 1
        if __TAddNum <= 1 then
            __TAddNum = 1
        end
        self:SetTipsUseNum()
    end)
    CommonHelper:HButtonSetCallback("TBtnEditorAdd", self.DisassembleView.gameObject, function(data)
        __TAddNum = __TAddNum + 1

        if __TAddNum >= TipsData.cellNum then
            __TAddNum = TipsData.cellNum
        end

        self:SetTipsUseNum()
    end)

    CommonHelper:HButtonSetCallback("TBtnEditorMax", self.DisassembleView.gameObject, function(data)
        __TAddNum = TipsData.cellNum
        self:SetTipsUseNum()
    end)

    CommonHelper:HButtonSetCallback("TBtnClose", self.DisassembleView.gameObject, function(data)
        self.DisassembleView.gameObject:SetActive(false)
    end)

    self.TipsBtnUse = CommonHelper:HButtonSetCallback("TipsBtnUse", self.DisassembleView.gameObject, function(hbtn)
        local IDStr = tostring(TipsData.cellId)
        local IDCount = tostring(__TAddNum)
        --print("--198 分解配件  P2=配件ID串  P3=配件数量串  ", IDStr, IDCount)
        WarehouseSubsystem:Get():SendMsg_GetStoreDesc(IDStr, IDCount)
        self.DisassembleView.gameObject:SetActive(false)

    end)

    self.TipsBtnCancel = CommonHelper:HButtonSetCallback("TipsBtnCancel", self.DisassembleView.gameObject, function(hbtn)
        self.DisassembleView.gameObject:SetActive(false)
    end)
end

function WarehouseView:SetTipsUseNum()
    CommonHelper:SetInputFieldText("UseNumInput", self.DisassembleView.gameObject, __TAddNum)
end