---@class Page_LabViewBase
Page_LabViewBase = class("Page_LabViewBase")
function Page_LabViewBase:initialize(parentPref)
    self.gameObject = parentPref
    self.canvasGroup = UIUtil.GetGameobjectComponent(self.gameObject, typeof(CanvasGroup))
    self:SetCanvasGroup(false)
    self:Awake()
end
function Page_LabViewBase:Awake()

end
function Page_LabViewBase:SendOpen()
    UINotify:Get():SendNotification(UINotifyEvent.LabMainMenu_OpenCurView)
end

function Page_LabViewBase:OnOpen()

end
function Page_LabViewBase:GetChildWightByParent(controlName, parent, ctype, isDirectChild)
    -- body
    return UIUtil.GetTypeChildWightByParent(controlName, parent, ctype, isDirectChild or false)
end

function Page_LabViewBase:GetChildWight(controlName, ctype, isDirectChild)
    -- body
    return UIUtil.GetTypeChildWightByParent(controlName, self.gameObject, ctype, isDirectChild or false)
end
function Page_LabViewBase:GetChild(controlName, isDirectChild)
    -- body
    return UIUtil.GetChildInputPath(controlName, self.gameObject, isDirectChild or false)
end

function Page_LabViewBase:OnClose()

end
function Page_LabViewBase:Refresh()

end
function Page_LabViewBase:GetUIModuleID()
    return UIModuleID.Lab
end

function Page_LabViewBase:Open()
    self:SetCanvasGroup(true)
    self.IsOpen = true
    self:OnOpen()
end

function Page_LabViewBase:Close()
    self.IsOpen = false
    self:SetCanvasGroup(false)
    self:OnClose()
end

function Page_LabViewBase:SetCanvasGroup(active)
    UIUtil.ShowCanvasGroup(self.canvasGroup, active)
end
local _TypeData = nil
local _SelectType = -1
local _CurPartTypeScrollView = -1

function Page_LabViewBase:SetPartTypeScrollView(scrollView, TypeList, check, flag, clickFunc, defaultSelectType)
    if flag == nil then
        flag = true
    end
    if check then
        if #TypeList == 0 then
            _SelectType = nil  -- 或报错
        else
            local found = false
            for i = 1, #TypeList do
                if defaultSelectType == TypeList[i] then
                    flag=false
                    _SelectType = defaultSelectType
                    found = true
                    break
                end
            end
            if not found or defaultSelectType == nil then
                _SelectType = TypeList[1]
            end
        end
        _TypeData = TypeList
    end
    _CurPartTypeScrollView = scrollView
    CommonHelper:InitMoreRowScrollView(_CurPartTypeScrollView, #_TypeData, 1, function(index, itemObj, scroll)
        local tog = CommonHelper:HButtonSetCallback("TagBtn", itemObj, function(btnData)
            if _SelectType ~= _TypeData[btnData.intData + 1] then
                _SelectType = _TypeData[btnData.intData + 1]
                CommonHelper:MoreRowView_RefreshCurList(_CurPartTypeScrollView, false)
                if clickFunc then
                    clickFunc(_SelectType)
                end
            end
        end, index)
        if _TypeData[index + 1] ~= -1 then
            local typeName = CommonHelper:GetGoodsTypeName(GoodsType1.Part, _TypeData[index + 1])
            local icon = CommonHelper:GetGoodsTypeIcon(GoodsType1.Part, _TypeData[index + 1])
            CommonHelper:SetText("hover/###text", itemObj, typeName)
            CommonHelper:SetText("normal/###text", itemObj, typeName)
            CommonHelper:GetComponentSetImage("typeImage", itemObj, icon, self:GetUIModuleID())
        else
            local icon = CommonHelper:GetGoodsTypeIcon(GoodsType1.Part, _TypeData[index + 1])
            CommonHelper:GetComponentSetImage("typeImage", itemObj, icon, self:GetUIModuleID())
            CommonHelper:SetText("hover/###text", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.BagPartALL))
            CommonHelper:SetText("normal/###text", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.BagPartALL))
        end
        CommonHelper:SetToggleState(tog, _TypeData[index + 1] == _SelectType)
    end, nil, nil, flag)
    if clickFunc then
        clickFunc(_SelectType)
    end
end
---@param articleData ArticleCell
function Page_LabViewBase:SetArticleViewByArticleCell(parent, articleData)
    CommonHelper:CSGameObjectSetActive(parent, articleData ~= nil)
    if articleData == nil then
        return
    end
    local cfg = articleData:GetPartConfig()
    CommonHelper:SetText("###articleName", parent, ClientDataManager:Get():GetTemplateString(cfg.partname))
    CommonHelper:GetComponentSetUITexture("PartItem/partIcon", parent, cfg.icon, self:GetUIModuleID())
    CommonHelper:SetComponentPartStar("partview/PartStar", parent, articleData:GetStar())
    CommonHelper:SetComponentPartStar("partview/PartStarAwake", parent, articleData:GetStar())
    CommonHelper:SetGameObjectActive("partview/PartStarAwake", parent, articleData:GetAwaken())
    CommonHelper:SetGameObjectActive("partview/PartStar", parent, not articleData:GetAwaken())
    CommonHelper:SetComponentPartGeneration("partview/generation/generation_", parent, articleData:GetGeneration())
    CommonHelper:SetText("scores/###value", parent, string.format("%0.0f", articleData:GetPartScore()))
    CommonHelper:SetText("###level", parent, CommonHelper:GetTempStr_Default(TemplateStringID.BagPartLevel, articleData:GetPartLV()))
    --{{{ 属性
    ---@type table<number, PartAttrData>
    local attrlist = {}
    local templist = articleData:GetPartSecondAttrs()
    for i = 1, #templist do
        if not CommonHelper:PartAttrShowValueEqualZero(templist[i].value) then
            table.insert(attrlist, templist[i])
        end
    end
    for i = 1, 8 do
        local temp = attrlist[i]
        local obj = CommonHelper:SetGameObjectActive("grid/attr" .. i, parent, temp ~= nil)
        if temp then
            CommonHelper:SetText("key", obj, CommonHelper:GetAttrName(temp.type))
            CommonHelper:SetText("value", obj, CommonHelper:GetAttrValue(temp.type, temp.value))
            CommonHelper:HButtonSetCallback("BtnAttr", obj, function(hbtn)
                CommonHelper:ShowAttrInfoView(temp.type)
            end)
        end
    end
    --}}}
end
function Page_LabViewBase:SetArticleViewById(parent, id)
    --{{{二级属性
    local partData = CommonHelper:GetPartAgeCfg(id, 1)
    local attrs = partData.NewAttr
    local sortlist = {}
    ---@type table<number, table<number, PartAttrData>>
    local secondAttrs = {}

    for i, v in pairs(attrs) do
        local attrs_type = CommonHelper:GetTableDataByID(ConfigNames.attrtype_config, v.type)
        local typename = CommonHelper:GetTempStr_Default(attrs_type.tagName)
        if secondAttrs[typename] == nil then
            secondAttrs[typename] = {}
            table.insert(sortlist, { attrs_type.tag, typename })
        end
        table.insert(secondAttrs[typename], attrs[i])
    end

    table.sort(sortlist, function(a, b)
        return a[1] < b[1]
    end)

    local temp = {}
    for i, v in pairs(sortlist) do
        local key = sortlist[i][2]
        table.sort(secondAttrs[key], function(a, b)
            return a.type < b.type
        end)
        table.insert(temp, key)
        table.insert(temp, #secondAttrs[key])
    end

    local ScrollView = UIUtil.GetTypeChildWightInputPath("TitleScrollView", parent, typeof(TitleScrollView))
    CommonHelper:InitTitleScrollView(ScrollView, temp, 1, function(title, itemObj, dataIndex, scroll)
        local datalist = secondAttrs[title]

        if dataIndex == -1 then
            CommonHelper:SetText("###name", itemObj, title)
        else
            local data = datalist[dataIndex + 1]
            CommonHelper:SetText("###name", itemObj, CommonHelper:GetAttrName(data.type))
            CommonHelper:SetText("###value", itemObj, CommonHelper:GetAttrValue(data.type, data.value))

            CommonHelper:HButtonSetCallback("BtnItem", itemObj, function(hbtn)
                CommonHelper:ShowGarageTipsView(GarageTipsTpye.SecondAttr, data.type, CommonHelper:GetAttrValue(data.type, data.value))
            end)
        end
    end)
    --}}}
end
---@param data LabComposeData
function Page_LabViewBase:SetArticleInfoViewByLabComposeData(parent, data)
    local partCfg = data.PartCfg
    --新合成展示Item
    local obj = UIUtil.GetChild("ItemCom_202", parent)
    local param = Param_ItemPartParam()
    CommonHelper:SetItemComGroup(obj, self:GetUIModuleID(), data.TargetId, param, function(btnData)
        CommonHelper:ShowPartInfoByCfgId(data.TargetId, self:GetUIModuleID())
    end)
    --nametxt
    CommonHelper:SetText("###nametxt", parent, CommonHelper:GetTempStr_Default(partCfg.partname))
    CommonHelper:SetText("###showtxt", parent, CommonHelper:GetTempStr_Default(partCfg.partdesc))
    CommonHelper:SetText("###exptxt", parent, CommonHelper:GetTempStr_Default(TemplateStringID.LabMainCompoundExp, string.format("%d%%", data.AddExp)))
    CommonHelper:SetText("###probabilitytxt", parent, CommonHelper:GetTempStr_Default(TemplateStringID.LabMainComAwakingExp, string.format("%d%%", data.BreakRand)))
    CommonHelper:SetText("###needtxt", parent, data.CostCurrency.num)
end