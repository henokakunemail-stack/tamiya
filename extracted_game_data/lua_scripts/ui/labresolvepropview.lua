local _curSelectProp = {}--当前选择的 key 和 value 都是 cellId ,这个才是最终的
local _curSelectPropCount = 0

---@class LabResolvePropView : ViewBase
LabResolvePropView = class("LabResolvePropView", ViewBase)

function LabResolvePropView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "LabResolvePropViewAction")
end

function LabResolvePropView:Awake()
    self:CacheViewData()
    self:InitBtnFunc()
end

function LabResolvePropView:OnOpen()
    self:InitViewInfo()
end

function LabResolvePropView:CacheViewData()
    self.PropScroll = self:GetChildWight("PropScroll", typeof(MoreRowScrollView))
    self.PropScrollCG = self:GetChildWight("PropScroll", typeof(CanvasGroup))
end

function LabResolvePropView:InitBtnFunc()
    self. EnsureResolveBtn = CommonHelper:HButtonSetCallback("EnsureResolveBtn", self.gameObject, function(data)
        self:OnResolveBtnClick()
    end)

    self. BtnClose = CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
    end)
end

function LabResolvePropView:InitViewInfo()
    _curSelectProp = {}
    local articleDataIdTab = LabDataManager:Get():GetResolveSelectProp()

    for i = 1, #articleDataIdTab do
        _curSelectProp[articleDataIdTab[i]] = articleDataIdTab[i]
    end

    _curSelectPropCount = #articleDataIdTab

    CommonHelper:SetText("###SelectCountText", self.gameObject, tostring(_curSelectPropCount))
    CommonHelper:SetHButtonClick(self.EnsureResolveBtn, _curSelectPropCount > 0, true)

    self:InitSelectScroll(articleDataIdTab)
end

function LabResolvePropView:InitSelectScroll(articleDataIdTab)

    if #articleDataIdTab > 0 then
        self:SortArticleList(articleDataIdTab)
    end

    CommonHelper:SetGameObjectActive("BagEmpty", self.gameObject, #articleDataIdTab <= 0)

    UIUtil.ShowCanvasGroup(self.PropScrollCG, #articleDataIdTab > 0)

    local UpdateFunc = function(dataIndex, itemObj, scroll)
        ---@type ArticleCell
        local _partData = KnapsackDataManager:Get():GetArticleByCellID(articleDataIdTab[dataIndex + 1])

        local obj = UIUtil.GetChild("ItemPart_138", itemObj)
        local param = Param_ItemPartParam()
        param.star = _partData:GetStar()
        param.lv = _partData:GetPartLV()
        param.awaken = _partData:GetAwaken()
        param.generation = _partData:GetGeneration()
        CommonHelper:SetItemPartGroup(obj, UIModuleID.Lab, _partData:GetID(), ItemPartUIType.Normal, param)

        local tog = self:GetChildWightByParent("TogSelectRed", itemObj, typeof(HButton))
        CommonHelper:SetToggleState(tog, _curSelectProp[_partData:GetCellID()] ~= nil)

        CommonHelper:HButtonSetCallback("TogSelectRed", itemObj, function(data)
            _curSelectPropCount = _curSelectProp[_partData:GetCellID()] == nil and _curSelectPropCount + 1 or _curSelectPropCount - 1
            _curSelectProp[_partData:GetCellID()] = _curSelectProp[_partData:GetCellID()] == nil and _partData:GetCellID() or nil

            CommonHelper:SetText("###SelectCountText", self.gameObject, tostring(_curSelectPropCount))
            CommonHelper:SetToggleState(tog, _curSelectProp[_partData:GetCellID()] ~= nil)
        end)
    end

    CommonHelper:InitMoreRowScrollView(self.PropScroll, #articleDataIdTab, 6, UpdateFunc)
end

function LabResolvePropView:SortArticleList(articleCellIds)
    table.sort(articleCellIds, function(a, b)
        a = KnapsackDataManager:Get():GetArticleByCellID(a)
        b = KnapsackDataManager:Get():GetArticleByCellID(b)

        --配件二级分类
        if a:GetPartType() > b:GetPartType() then
            return false
        end
        if a:GetPartType() < b:GetPartType() then
            return true
        end

        --配件三级分类
        if a:GetPartSubType() > b:GetPartSubType() then
            return true
        end
        if a:GetPartSubType() < b:GetPartSubType() then
            return false
        end
        --配件代
        if a:GetGeneration() > b:GetGeneration() then
            return true
        end
        if a:GetGeneration() < b:GetGeneration() then
            return false
        end
        --配件觉醒
        if not a:GetAwaken() and b:GetAwaken() then
            return true
        end
        if a:GetAwaken() and not b:GetAwaken() then
            return false
        end
        --配件星级
        if a:GetStar() > b:GetStar() then
            return true
        end
        if a:GetStar() < b:GetStar() then
            return false
        end

        --配件cellid
        return a:GetCellID() > b:GetCellID()
    end)
end

function LabResolvePropView:OnResolveBtnClick()
    local curSelectProp = ""
    local isHaveThreeStar = false

    for key, cellId in pairs(_curSelectProp) do
        --table.insert(curSelectProp, cellId)
        curSelectProp = curSelectProp .. cellId .. ":"
        if not isHaveThreeStar then
            isHaveThreeStar = KnapsackDataManager:Get():GetArticleByCellID(cellId):GetPartQuality() > 3
        end
    end

    curSelectProp = curSelectProp.sub(curSelectProp, 1, -2)

    if isHaveThreeStar then
        local boxFunc = function()
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Yellow, CommonHelper:GetTempStr_Default(TemplateStringID.Lab_ResolveEnsure), "")
            if ret == MessageBoxHelp.BtnType.OK then
                self:EnsureResolve(curSelectProp)
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
    else
        self:EnsureResolve(curSelectProp)
    end
end

function LabResolvePropView:EnsureResolve(curSelectProp)
    if #curSelectProp <= 0 then
        CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.Lab_ResolveNoSelect))
    else
        LabDataManager:Get():SetResolveSelectProp(curSelectProp)
        LabSubsystem:Get():SendMsg_LabResolveReq(curSelectProp)
        UIManager:Get():ClosePopup()
    end
end