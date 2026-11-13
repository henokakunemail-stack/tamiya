---分解
---@class Page_LabResolve:Page_LabViewBase
Page_LabResolve = class("Page_LabResolve", Page_LabViewBase)
local BtnCloseDropDownFlag = false
local SelectQuality = 3
local SelectType = -1
---@type table<number,number>
local _curSelectProp = {} --分解选择的配件的cellID的字典 key 和 value 都是 cellID
local _curSelectPropIdx = -1 --当前选择的道具索引，用来展示详细信息
local _curSelectPropCount = 0
function Page_LabResolve:Awake()
    Page_LabViewBase:Awake()
    self.BagScroll = self:GetChildWight("BagScroll", typeof(MoreRowScrollView))
    self.ArticleView = self:GetChild("ArticleViewCG")
    self.BagScrollCG = self:GetChildWight("BagScroll", typeof(CanvasGroup))
    self.TypeScroll = self:GetChildWight("TypeScroll", typeof(MoreRowScrollView))
    self.ResolveEnsureBtn = CommonHelper:HButtonSetCallback("ResolveEnsureBtn", self.gameObject, function()
        self:OnResolveBtnClick()
    end)
    self.SelectAllBtn = CommonHelper:HButtonSetCallback("SelectAllBtn", self.gameObject, function()
        self:OnSelectAllBtnClick()
    end)
    self.DropDown = self:GetChildWight("DropDown_H", typeof(UIDropDown))
end
function Page_LabResolve:OnResolveBtnClick()
    local curSelectProp = {}
    for _, cellId in pairs(_curSelectProp) do
        table.insert(curSelectProp, cellId)
    end
    LabDataManager:Get():SetResolveSelectProp(curSelectProp)
    UIManager:Get():OpenPopup("LabResolvePropView", CanvasType.MainCanvas, "LabResolvePropView")
end

function Page_LabResolve:OnSelectAllBtnClick()
    local limitCount = LabDataManager:Get():GetMaxResolveLimit()
    if _curSelectPropCount < limitCount then
        for k, v in pairs(self.partDataTab) do
            if v:GetPartQuality() <= SelectQuality and _curSelectPropCount < limitCount and _curSelectProp[v:GetCellID()] == nil then
                _curSelectProp[v:GetCellID()] = v:GetCellID()
                _curSelectPropCount = _curSelectPropCount + 1
            end
        end
    else
        CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.Lab_ResolveMax))
    end
    CommonHelper:MoreRowView_RefreshCurList(self.BagScroll, false)
end
function Page_LabResolve:OnOpen()
    local tagTable = self:GetTypeList()
    self:Clear()
    self:SetQualityDropDown()
    self:SetPartTypeScrollView(self.TypeScroll, tagTable, true, true, function(type)
        SelectType = type
        self:SetBagListView(SelectType)
    end)
end
function Page_LabResolve:Clear()
    _curSelectProp = {} --分解选择的配件的cellID的字典 key 和 value 都是 cellID
    _curSelectPropIdx = -1 --当前选择的道具索引，用来展示详细信息
    _curSelectPropCount = 0
    LabDataManager:Get():SetResolveSelectProp(_curSelectProp)
end
---@param articleCell ArticleCell
function Page_LabResolve:ResolveFilter(articleCell)
    if articleCell:IsChange() then
        return false
    end
    return true
end

---@param partType PartType
function Page_LabResolve:SetBagListView(partType)
    local partList = KnapsackDataManager:Get():GetEquipmentList()
    if partType ~= -1 then
        partList = KnapsackDataManager:Get():GetEquipmentsByType(partType)
    end
    ---@type table<number, ArticleCell>
    self.partDataTab = {}
    for k, v in pairs(partList) do
        if self:ResolveFilter(v) then
            table.insert(self.partDataTab, v)
        end
    end
    CommonHelper:SetGameObjectActive("BagEmpty", self.gameObject, #self.partDataTab <= 0)
    UIUtil.ShowCanvasGroup(self.BagScrollCG, #self.partDataTab > 0)
    if #self.partDataTab <= 0 then
        self:SetArticleViewByArticleCell(self.ArticleView, nil)
        return
    end
    self.partDataTab = CommonHelper:SortPart_1(self.partDataTab)
    local UpdateFunc = function(dataIndex, itemObj, scroll)
        ---@type ArticleCell
        local _partData = self.partDataTab[dataIndex + 1]
        local obj = UIUtil.GetChild("ItemPart_138", itemObj)
        local param = Param_ItemPartParam()
        param.star = _partData:GetStar()
        param.lv = _partData:GetPartLV()
        param.awaken = _partData:GetAwaken()
        param.generation = _partData:GetGeneration()
        CommonHelper:SetItemPartGroup(obj, self:GetUIModuleID(), _partData:GetID(), ItemPartUIType.Normal, param, function()
            self:SetArticleViewByArticleCell(self.ArticleView, _partData)
        end)

        local tog = self:GetChildWightByParent("TogSelectRed", itemObj, typeof(HButton))
        CommonHelper:SetToggleState(tog, _curSelectProp[_partData:GetCellID()] ~= nil)

        CommonHelper:HButtonSetCallback("TogSelectRed", itemObj, function(data)
            if _curSelectProp[_partData:GetCellID()] == nil and _curSelectPropCount >= LabDataManager:Get():GetMaxResolveLimit() then
                CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.Lab_ResolveMax))
            else
                _curSelectPropCount = _curSelectProp[_partData:GetCellID()] == nil and _curSelectPropCount + 1 or _curSelectPropCount - 1
                _curSelectProp[_partData:GetCellID()] = _curSelectProp[_partData:GetCellID()] == nil and _partData:GetCellID() or nil
                CommonHelper:SetToggleState(tog, _curSelectProp[_partData:GetCellID()] ~= nil)
                _curSelectPropIdx = dataIndex + 1
                self:SetArticleViewByArticleCell(self.ArticleView, _partData)
            end
        end)
    end
    CommonHelper:InitMoreRowScrollView(self.BagScroll, #self.partDataTab, 6, UpdateFunc)
    self:SetArticleViewByArticleCell(self.ArticleView, nil)
end
function Page_LabResolve:OnClose()

end
function Page_LabResolve:SetQualityDropDown()
    BtnCloseDropDownFlag = false
    SelectQuality = 3
    BtnCloseDropDownFlag = false
    CommonHelper:SetGameObjectActive("BtnCloseDropDown", self.gameObject, false)
    CommonHelper:InitDropDown(self.DropDown, 6, function(uiDropDown, item, index)
        for i = 1, 6 do
            CommonHelper:SetGameObjectActive("quality" .. i, item, index + 1 == i)
        end
    end, function(index)
        BtnCloseDropDownFlag = not BtnCloseDropDownFlag
        CommonHelper:SetGameObjectActive("BtnCloseDropDown", self.gameObject, BtnCloseDropDownFlag)
        SelectQuality = index + 1
        self:SetSelectQuality()
    end, SelectQuality - 1, true, function()
        BtnCloseDropDownFlag = not BtnCloseDropDownFlag
        CommonHelper:SetGameObjectActive("BtnCloseDropDown", self.gameObject, BtnCloseDropDownFlag)
    end)
    self:SetSelectQuality()
end
function Page_LabResolve:SetSelectQuality()
    for i = 1, 6 do
        CommonHelper:SetGameObjectActive("selectquality/quality" .. i, self.gameObject, SelectQuality == i)
    end
end
function Page_LabResolve:GetTypeList()
    local result = {}
    local partList = KnapsackDataManager:Get():GetEquipmentList()
    local seen = {}
    for k, v in pairs(partList) do
        if self:ResolveFilter(v) then
            if not seen[v:GetPartType()] then
                seen[v:GetPartType()] = true
                table.insert(result, v:GetPartType())
            end
        end
    end
    table.sort(result)
    return result
end
function Page_LabResolve:Refresh()
    self:Clear()
    local tagTable = self:GetTypeList()
    self:SetPartTypeScrollView(self.TypeScroll, tagTable, true, true, function(type)
        SelectType = type
        self:SetBagListView(SelectType)
    end, SelectType)
end

