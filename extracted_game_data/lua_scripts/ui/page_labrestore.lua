---还原
---@class Page_LabRestore:Page_LabViewBase
Page_LabRestore = class("Page_LabRestore", Page_LabViewBase)
local SelectType = -1
local _curSelectPropIdx = -1
function Page_LabRestore:Awake()
    Page_LabViewBase:Awake()
    self.TypeScroll = self:GetChildWight("TypeScroll", typeof(MoreRowScrollView))
    self.BagScroll = self:GetChildWight("BagScroll", typeof(MoreRowScrollView))
    self.BagScrollCG = self:GetChildWight("BagScroll", typeof(CanvasGroup))
    self.ArticleView = self:GetChild("ArticleViewCG")
    self.RestoreEnsureBtn = CommonHelper:HButtonSetCallback("RestoreEnsureBtn", self.gameObject, function()
        self:OnRestoreBtnClick()
    end)
    self.RestoreAwakenEnsureBtn = CommonHelper:HButtonSetCallback("RestoreAwakenEnsureBtn", self.gameObject, function()
        self:OnRestoreBtnClick(true)
    end)
end
function Page_LabRestore:OnOpen()
    local tagTable = self:GetTypeList()
    self:Clear()
    self:SetPartTypeScrollView(self.TypeScroll, tagTable, true, true, function(type)
        SelectType = type
        self:SetBagListView(SelectType)
    end)
end
function Page_LabRestore:Clear()

end
---@param articleCell ArticleCell
function Page_LabRestore:ResolveFilter(articleCell)
    if articleCell:IsChangeNoUsing() then
        return true
    end
    return false
end

---@param partType PartType
function Page_LabRestore:SetBagListView(partType)
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
    _curSelectPropIdx = self.partDataTab[1]:GetCellID()
    local UpdateFunc = function(dataIndex, itemObj, scroll)
        ---@type ArticleCell
        local _partData = self.partDataTab[dataIndex + 1]
        local obj = UIUtil.GetChild("ItemPart_138", itemObj)
        local param = Param_ItemPartParam()
        param.star = _partData:GetStar()
        param.lv = _partData:GetPartLV()
        param.awaken = _partData:GetAwaken()
        param.generation = _partData:GetGeneration()
        param.using = _partData:GetCarId()
        CommonHelper:SetItemPartGroup(obj, self:GetUIModuleID(), _partData:GetID(), ItemPartUIType.Normal, param, function(id)
            self:SetArticleViewByArticleCell(self.ArticleView, _partData)
            _curSelectPropIdx = _partData:GetCellID()
            CommonHelper:MoreRowView_RefreshCurList(self.BagScroll, false)
        end, _partData)
        CommonHelper:SetGameObjectActive("selctBg", itemObj, _curSelectPropIdx == _partData:GetCellID())
    end
    CommonHelper:InitMoreRowScrollView(self.BagScroll, #self.partDataTab, 6, UpdateFunc)
    self:SetArticleViewByArticleCell(self.ArticleView, self.partDataTab[1])
end
function Page_LabRestore:GetTypeList()
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
function Page_LabRestore:Refresh()
    local tagTable = self:GetTypeList()
    self:Clear()
    self:SetPartTypeScrollView(self.TypeScroll, tagTable, true, true, function(type)
        SelectType = type
        self:SetBagListView(SelectType)
    end, SelectType)
end
function Page_LabRestore:OnRestoreBtnClick(isAwakeRestore)
    isAwakeRestore = isAwakeRestore == nil and 0 or 1
    if _curSelectPropIdx > 0 then
        local cfgCost = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.PartReturnCost)
        local list = stringSplitToNumber(cfgCost.varval, ':')
        local token, costNum = list[1], list[2]
        local tokenNum = PlayerDataManager:Get():GetCurrency(token)
        --if PlayerDataManager:Get():CheckCurrencyEnough(token,costNum) then
        local boxFunc = function()
            --local str = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.PartReturnCostCostTip),costNum)
            local str = isAwakeRestore == 0 and CommonHelper:GetTempStr_Default(TemplateStringID.PartReturnCostErrorTip) or CommonHelper:GetTempStr_Default(TemplateStringID.PartReturnAwakeCostErrorTip)
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, str)
            if ret == MessageBoxHelp.BtnType.OK then
                LabSubsystem:Get():SendMsg_PartReturn(_curSelectPropIdx, isAwakeRestore)
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
        --end
    end
end