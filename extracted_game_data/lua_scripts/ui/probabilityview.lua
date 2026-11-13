---@class ProbabilityView : ViewBase
ProbabilityView = class("ProbabilityView", ViewBase)

function ProbabilityView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ProbabilityViewAction")
end

function ProbabilityView:Awake()

    self.ScrollView = UIUtil.GetTypeChildWightByParent("TitleScrollView", self.gameObject, typeof(MoreRowScrollViewTittle))
    self.ScrollViewCG = UIUtil.GetTypeChildWightByParent("TitleScrollView", self.gameObject, typeof(CanvasGroup))

    self:InitBtnFunc()
end

function ProbabilityView:OnOpen()
    self:InitTogState(true, false)
    self:InitDicList()
end

function ProbabilityView:InitBtnFunc()

    self.TogProbability = CommonHelper:HButtonSetCallback("TogProbability", self.gameObject, function()
        self:InitTogState(true, false)
        self:InitDicList()
    end)

    self.TogRule = CommonHelper:HButtonSetCallback("TogRule", self.gameObject, function()
        self:InitTogState(false, true)
        self:InitRuleInfo()
    end)

    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(hbtn)
        UIManager:Get():ClosePopup()
    end)

end

function ProbabilityView:InitTogState(TogProbability, TogRule)
    CommonHelper:SetToggleState(self.TogProbability, TogProbability)
    CommonHelper:SetToggleState(self.TogRule, TogRule)

    UIUtil.ShowCanvasGroup(self.ScrollViewCG, TogProbability)
    CommonHelper:SetGameObjectActive("###RuleText", self.gameObject, TogRule)
end

function ProbabilityView:InitRuleInfo()
    local recruitId = RecruitDataManager:Get():GetCurSelectRecruitId()

    local recruitData = RecruitDataManager:Get():GetDataById(recruitId)
    CommonHelper:SetNewLineText("###RuleText", self.gameObject, CommonHelper:GetTempStr_Default(recruitData:GetDesc()))
end

function ProbabilityView:InitDicList()

    local recruitId = RecruitDataManager:Get():GetCurSelectRecruitId()
    local recruitData = RecruitDataManager:Get():GetDataById(recruitId)
    CommonHelper:SetText("###recruitTitle", self.gameObject, ClientDataManager:Get():GetTemplateString(recruitData:GetDescTitle()))

    local data = {}
    ---@type table<number,number> title-fabric
    local titleColor = {}
    local startIndex=1
    ---@type dictrecruitlab_config_cell[]
    local titleTab = recruitData.probability
    if recruitData:GetRecruitViewType() == RecruitViewType.Divination then
        titleColor[0] = titleTab[1].showFabric
        local d1 = MoreRowScrollViewTittleGroup()
        d1.tittle = CommonHelper:GetTempStr_Default(titleTab[1].recruitlabDesc)
        d1.totle = 5
        d1.groupIndex = 0
        startIndex=2
        table.insert(data, d1)
    end
    ---@type dictaward_config
    local awardTab = ClientDataManager:Get():GetDataTable(ConfigNames.dictaward_config)


    for i = startIndex, #titleTab do
        local d1 = MoreRowScrollViewTittleGroup()
        d1.tittle = CommonHelper:GetTempStr_Default(titleTab[i].recruitlabDesc)
        local partTable = awardTab.GetPropTableByIdIdx(titleTab[i].awardid)

        d1.totle = #partTable
        d1.groupIndex = i
        table.insert(data, d1)
        titleColor[i] = titleTab[i].showFabric
    end

    CommonHelper:MoreRowTitle_Init(self.ScrollView, data, 8, function(title, tittleIdx, itemObj, type, index, scroll)
        if type == TittleItemType.Title then
            CommonHelper:SetText("###dec", itemObj, title)

            local titleBg = self:GetChildWightByParent("titleBg", itemObj, typeof(Image))

            CommonHelper:SetImageColor(titleBg, self:GetColorByFabric(titleColor[tonumber(tittleIdx)]))
            -- CommonHelper:SetText("Text",itemObj, title .."_"..tittleIdx)
        end
        if type == TittleItemType.Item then
            if tittleIdx==0  then
                CommonHelper:SetGameObjectActive("RowItem0",itemObj,false)
                for i = 1, 5 do
                    CommonHelper:SetGameObjectActive("Image"..i,itemObj,i==index+1)
                end
                if index==0 then
                    CommonHelper:SetText("###problem", itemObj, string.format("%.2f%%",CommonHelper:GetDictCalcData(193)))
                else
                    CommonHelper:SetText("###problem", itemObj, string.format("%.2f%%",CommonHelper:GetDictCalcData(194)))
                end
            else
                CommonHelper:SetGameObjectActive("RowItem0",itemObj,true)
                ---@type dictaward_config_cell
                local award_config= awardTab.GetPropTableByIdIdx(titleTab[tittleIdx].awardid)
                local partId=award_config[index+1].propsid
                local param= Param_ItemArticleParam()
                param.count=award_config[index+1].propsnum
                CommonHelper:SetItemComGroup(itemObj,UIModuleID.Probability,partId,param,function(id)
                    CommonHelper:ShowPartInfoByCfgId(id, UIModuleID.Probability)
                end,partId,ItemPartUIType.Simple)
                CommonHelper:SetText("Text",itemObj,"i_"..index)
                CommonHelper:SetText("###problem", itemObj, string.format("%.2f%%",award_config[index+1].prize/100))

            end
        end
    end)
end

---@param fabric QualityType
function ProbabilityView:GetColorByFabric(fabric)
    if fabric == QualityType.White then
        return "B3B3B3"
    elseif fabric == QualityType.Gold then
        return "FED061"
    elseif fabric == QualityType.Blue then
        return "4C8DE2"
    elseif fabric == QualityType.Green then
        return "5AB26C"
    elseif fabric == QualityType.Purple then
        return "8A63DE"
    end
end

function ProbabilityView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.Probability)
end
