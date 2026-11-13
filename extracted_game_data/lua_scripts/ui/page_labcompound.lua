---@class Page_LabCompound:Page_LabViewBase
Page_LabCompound = class("Page_LabCompound", Page_LabViewBase)
local _SelectType = -1
function Page_LabCompound:Awake()
    Page_LabViewBase:Awake()
    self.PartsScrollView = self:GetChildWight("LeftCompoundSVC", typeof(MoreRowScrollView))
    self.CostArticleScrollView = self:GetChildWight("CenterCompoundSVC", typeof(MoreRowScrollView))
    self.PartAttrView = self:GetChild("RightShow")
    self.PartInfoView = self:GetChild("DownShow")
    self.TypeScroll = self:GetChildWight("TypeScroll", typeof(MoreRowScrollView))
    self.SortPanelDropDown = self:GetChildWight("SortPanel", typeof(UIDropDown))
    CommonHelper:HButtonSetCallback("BtnCompound", self.gameObject, function(data)
        local playerDataMgr = PlayerDataManager:Get()
        if not playerDataMgr:CheckCurrencyEnough(self.CurCompoundPart.CostCurrency.id, self.CurCompoundPart.CostCurrency.num) then
            return
        end
        -- 检查所有消耗材料
        for _, costItem in ipairs(self.CurCompoundPart.CostArticle) do
            if not playerDataMgr:CheckCurrencyEnough(costItem.id, costItem.num) then
                return
            end
        end
        LabSubsystem:Get():SendMsg_ReqCompose(self.CurCompoundPart.ComposeId)
    end)
end
function Page_LabCompound:OnOpen()
    self:SetCompoundLevelInfo()
    local tagTable = LabDataManager:Get():GetComposeTypes()
    self:SetPartTypeScrollView(self.TypeScroll, tagTable, true, true, function(type)
        _SelectType = type
        ---@type LabComposeData[]
        self.CurPartList = LabDataManager:Get():GetComposeListByType(_SelectType)
        ---@type LabComposeData
        self.CurCompoundPart = self.CurPartList[1]
        self:SetCurPartData()
        self:SetPartList(_SelectType)
    end)
end
function Page_LabCompound:SetPartList()
    CommonHelper:InitMoreRowScrollView(self.PartsScrollView, #self.CurPartList, 1, function(index, itemObj, scroll)
        ---@type LabComposeData
        local data = self.CurPartList[index + 1]
        CommonHelper:SetText("###compart", itemObj, CommonHelper:GetTempStr_Default(data.PartCfg.partname))
        CommonHelper:HButtonSetCallback("ItemBtn", itemObj, function(hBtn)
            if self.CurPartList[hBtn.intData + 1].ComposeId ~= self.CurCompoundPart.ComposeId then
                self.CurCompoundPart = self.CurPartList[hBtn.intData + 1]
                self:SetCurPartData()
                CommonHelper:MoreRowView_RefreshCurList(self.PartsScrollView, false)
            end
        end, index)
        CommonHelper:SetGameObjectActive("lightbg", itemObj, data.ComposeId == self.CurCompoundPart.ComposeId)
        CommonHelper:SetTextColorByName("###compart", itemObj, data.ComposeId == self.CurCompoundPart.ComposeId and "FFFFFF" or "826F6F")
    end)
end
function Page_LabCompound:SetCompoundLevelInfo()
    local lv = LabDataManager:Get():GetCompositorLv()
    local exp = LabDataManager:Get():GetCompositorExp()
    local nextExp = LabDataManager:Get():GetCompositorUpLvExp()
    local sliderValue = exp / nextExp
    CommonHelper:SetSlider("com_ExpSlider", self.gameObject, sliderValue)
    CommonHelper:SetText("###ExpText", self.gameObject, string.format("%d/%d", exp, nextExp))
    local dictBuilderLev = ClientDataManager:Get():GetDataTable(ConfigNames.dictbuilderlev_config)
    ---@type dictbuilderlev_config_cell[]
    local levDatas = dictBuilderLev.GetConfigData()
    CommonHelper:SetText("###roottext", self.SortPanelDropDown.gameObject, CommonHelper:GetTempStr_Default(levDatas[lv].roficiencyname))
    CommonHelper:InitDropDown(self.SortPanelDropDown, #levDatas, function(uiDropDown, item, index)
        CommonHelper:SetText("Text", item, CommonHelper:GetTempStr_Default(levDatas[index + 1].roficiencyname))
    end, function(intData)
        LabDataManager:Get():SetBuilderDataByLV(levDatas[intData + 1].C_ID)
        CommonHelper:SetText("###roottext", self.SortPanelDropDown.gameObject, CommonHelper:GetTempStr_Default(levDatas[intData + 1].roficiencyname))
        local tagTable = LabDataManager:Get():GetComposeTypes()
        self:SetPartTypeScrollView(self.TypeScroll, tagTable, true, true, function(type)
            _SelectType = type
            self.CurPartList = LabDataManager:Get():GetComposeListByType(_SelectType)
            self.CurCompoundPart = self.CurPartList[1]
            self:SetCurPartData()
            self:SetPartList(_SelectType)
        end)
    end)
end

function Page_LabCompound:SetCurPartData()
    self:SetCostArticle()
    self:SetArticleViewById(self.PartAttrView, self.CurCompoundPart.TargetId)
    self:SetArticleInfoViewByLabComposeData(self.PartInfoView, self.CurCompoundPart)
end
function Page_LabCompound:SetCostArticle()
    CommonHelper:InitMoreRowScrollView(self.CostArticleScrollView, #self.CurCompoundPart.CostArticle, 4, function(index, itemObj, scroll)
        local temp = self.CurCompoundPart.CostArticle[index + 1]
        local item = UIUtil.GetChild("ItemCom_118", itemObj)
        local param = Param_ItemArticleParam()
        CommonHelper:SetItemComGroup(item, self:GetUIModuleID(), temp.id, param, function(btnData)
            CommonHelper:ShowPartInfoByCfgId(btnData, self:GetUIModuleID(), true)
        end, temp.id)
        local haveNum = PlayerDataManager:Get():GetCurrency(temp.id)
        CommonHelper:SetText("###haveCount", itemObj, string.format("%d/%d", haveNum, temp.num))
    end)
end
function Page_LabCompound:OnClose()

end
function Page_LabCompound:SendOpen()
    LabSubsystem:Get():SendMsg_ReqComposeList()
end
function Page_LabCompound:Refresh()
    self:SetCurPartData()
end