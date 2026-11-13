---@class BoxAwardHelpView : ViewBase
BoxAwardHelpView = class("BoxAwardHelpView", ViewBase)

function BoxAwardHelpView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "BoxAwardHelpViewAction")
end

function BoxAwardHelpView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose_1", self.gameObject, function(hbtn)
        UIManager:Get():HidePersistentView("BoxAwardHelpView")
    end)

    self.ScrollView = UIUtil.GetTypeChildWightByParent("TitleScrollView", self.gameObject, typeof(MoreRowScrollViewTittle))
    self.ScrollViewCG = UIUtil.GetTypeChildWightByParent("TitleScrollView", self.gameObject, typeof(CanvasGroup))

    self:InitBtnFunc()
end

function BoxAwardHelpView:OnOpen()
    self:InitTogState(true, false)
    self:InitDicList()
end

function BoxAwardHelpView:InitBtnFunc()

    self.TogProbability = CommonHelper:HButtonSetCallback("TogProbability", self.gameObject, function()
        self:InitTogState(true, false)
        self:InitDicList()
    end)

    --self.TogRule = CommonHelper:HButtonSetCallback("TogRule", self.gameObject, function()
    --    self:InitTogState(false, true)
    --    self:InitRuleInfo()
    --end)

    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(hbtn)
        UIManager:Get():HidePersistentView("BoxAwardHelpView")
    end)

end

function BoxAwardHelpView:InitDicList(btn)
    local _BoxTypeData = WelfareBoxDataManager:Get():GetBoxTypeData()
    local _ItemPackage={}
    local data = {}
    for i = 1, #_BoxTypeData do
        local d1 = MoreRowScrollViewTittleGroup()
        d1.tittle = _BoxTypeData[i]
        local partTable = {}
        if _BoxTypeData[i] ~= nil then
            partTable = ClientDataManager:Get():GetDataTable(ConfigNames.dictpackage_config).GetListById(_BoxTypeData[i])
            table.sort(partTable, function(a, b)
                local a_grade = 0
                local b_grade = 0

                ---@type dictparts_config_cell
                local a_partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, tonumber(a.propsid))
                local b_partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, tonumber(b.propsid))
                if a_partCfg or b_partCfg then
                    ---@type dictpartbase_config_cell
                    a_grade = CommonHelper:GetPartBaseCfg(a_partCfg.baseid).fabric
                    ---@type dictpartbase_config_cell
                    b_grade = CommonHelper:GetPartBaseCfg(b_partCfg.baseid).fabric
                end

                ---@type dictarticle_config_cell
                local a_articleCfg = CommonHelper:GetTableDataByID(ConfigNames.article_config, tonumber(a.propsid))
                local b_articleCfg = CommonHelper:GetTableDataByID(ConfigNames.article_config, tonumber(b.propsid))
                if a_articleCfg or b_articleCfg then
                    a_grade = a_articleCfg.propsgrade
                    b_grade = b_articleCfg.propsgrade
                end

                if a_grade == b_grade then
                    return a.randval > b.randval
                end
                if a_grade > b_grade then
                    return true
                end
            end)
            _ItemPackage[_BoxTypeData[i]]=partTable
            d1.totle = #partTable
            d1.groupIndex = i
            table.insert(data, d1)
        end
    end

    CommonHelper:MoreRowTitle_Init(self.ScrollView, data, 11, function(title, tittleIdx, itemObj, type, index, scroll)
        if type == TittleItemType.Title then
            ---@type dictarticle_config_cell
            local article = CommonHelper:GetTableDataByID(ConfigNames.article_config, tonumber(title))
            CommonHelper:SetText("###dec", itemObj,
                    string.format(CommonHelper:GetTempStr_Default(TemplateStringID.BoxAwardTitle), CommonHelper:GetTempStr_Default(article.name)))
            local titleBg = self:GetChildWightByParent("titleBg", itemObj, typeof(Image))
            CommonHelper:SetImageColor(titleBg, CommonHelper:GetColorStringByQuality(article.propsgrade))
        end
        if type == TittleItemType.Item then
            local _itemData = _ItemPackage[tonumber(title)][index + 1]
            local obj = UIUtil.GetChild("ItemCom_118", itemObj)
            local param = Param_ItemArticleParam()
            param.count = _itemData.propsnum
            CommonHelper:SetItemComGroup(obj, UIModuleID.Welfare, _itemData.propsid, param,function(id)
                CommonHelper:ShowPartInfoByCfgId(id, UIModuleID.Welfare)
            end,_itemData.propsid)
            local probabilityTxt = tostring(_itemData.randval / 100) .. "%"
            CommonHelper:SetText("###probabilityTxt", itemObj, probabilityTxt)

        end
    end)
end


function BoxAwardHelpView:InitTogState(TogProbability, TogRule)
    CommonHelper:SetToggleState(self.TogProbability, TogProbability)

    UIUtil.ShowCanvasGroup(self.ScrollViewCG, TogProbability)
    CommonHelper:SetGameObjectActive("###RuleText", self.gameObject, TogRule)
end
