

--车库右侧，涂装入口

---@class PageGarageReformSelect
PageGarageReformSelect = class("PageGarageReformSelect")

function PageGarageReformSelect:initialize()
    self.SelectIdx = -1
    self.Root = nil
    ---@type ArticleCell
    self.Article = nil
    self.ReformPos = -1

end

function PageGarageReformSelect:SetData(root, article,pos, funback, funsure)
    self.SelectIdx = -1
    self.Root = root
    self.Article = article
    self.ReformPos = pos
    CommonHelper:HButtonSetCallback("BtnBack",root,function (hbtn)
        if funback then funback() end
    end)

    self.BtnProb=CommonHelper:HButtonSetCallback("BtnProb",root,function (hbtn)
        CommonHelper:ShowHelpView(PageDetailType.ReformProb,nil,HelpStyleType.BlueStyle)
    end)
    CommonHelper:SetHButtonClick(self.BtnProb,HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.BtnProb),true)
    CommonHelper:HButtonSetCallback("BtnSure",root,function (hbtn)
        if self.SelectIdx == -1 then
            CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.GarageNotSelectReformID))
        elseif self.ReformList[self.SelectIdx + 1].isLock then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.GarageNotSelectMaxStar))
        else
            local reform = self.ReformList[self.SelectIdx + 1].cfg
            if funsure then funsure(self.Article, self.ReformPos, reform.C_ID) end
        end

    end)

    self:SetScrollView()
end

function PageGarageReformSelect:SetScrollView()
    self.ReformList = {}
    ---@type dictpartstar_config
    local partstar= ClientDataManager:Get():GetDataTable(ConfigNames.dictpartstar_config)
    ---@type dictpartsdevelop_config
    local develop= ClientDataManager:Get():GetDataTable(ConfigNames.dictpartsdevelop_config)
    local list=partstar.GetCfgDataByIdAndStar(self.Article:GetPartBaseCfg().C_ID,self.Article:GetPartBaseCfg().maxstar)
    local listCur=partstar.GetCfgDataByIdAndStar(self.Article:GetPartBaseCfg().C_ID,self.Article:GetStar())
    local entries=stringSplitToNumber(list.entries,":")
    local entriesCur=stringSplitToNumber(listCur.entries,":")
    for k, v in pairs(entries) do
        local reformcfg =develop.GetDevelopPartByEntryId(v)
        local isLock=true
        for i = 1, #entriesCur do
            if v==entriesCur[i] then
                isLock=false
            end
        end
        if self.Article:GetPartReformTypeCount(reformcfg.entryid)>0 then

        else
            table.insert(self.ReformList, {cfg=reformcfg,isLock=isLock})
        end
    end
    table.sort(self.ReformList,function(a, b)
        return a.cfg.entryid<b.cfg.entryid
    end)
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.Root, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #self.ReformList, 1,function(dataIndex, itemObj, scroll)
        self:UpdateScrollView(dataIndex, itemObj)
    end)
end

function PageGarageReformSelect:UpdateScrollView(dataIndex, itemObj)

    ---@type dictpartsdevelop_config_cell
    local cfg = self.ReformList[dataIndex + 1].cfg
    local isLock = self.ReformList[dataIndex + 1].isLock

    CommonHelper:SetText("###reformname", itemObj, ClientDataManager:Get():GetTemplateString(cfg.name))

    CommonHelper:HButtonSetCallback("BtnItem",itemObj,function (hbtn)
        if  self.SelectIdx == dataIndex then return end
        self.SelectIdx = dataIndex
        CommonHelper:MoreRowView_RefreshCurList(self.ScrollView, false)
    end)
    CommonHelper:SetGameObjectActive("select", itemObj, self.SelectIdx == dataIndex)
    if isLock then
        CommonHelper:SetText("###strongenable", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.ReformSelectNotReform))
    else
        CommonHelper:SetText("###strongenable", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.ReformSelectCanReform))
    end

    --{{{详细
    CommonHelper:HButtonSetCallback("BtnDetail",itemObj,function (hbtn)
        CommonHelper:ShowGarageTipsView(GarageTipsTpye.Reform, cfg.entryid)
    end)
    --}}}


    --{{{概率
    local rate=stringSplitToNumber(cfg.rate,':')
    local str = CommonHelper:GetTempStr_Default(TemplateStringID.PartReforChangeFormat, (rate[2] + rate[3] + rate[4])* 0.01)
    CommonHelper:SetText("###rate", itemObj, str)
    --}}}


    --{{{改造次数
    CommonHelper:SetText("###num", itemObj, 1 - self.Article:GetPartReformTypeCount(cfg.entryid))
    --}}}

    CommonHelper:SetGameObjectActive("strongenable", itemObj, self.Article:GetPartReformTypeCount(cfg.entryid)<1)

    --{{{属性
    local attrs = cfg.NewAttr
    table.sort(attrs,function(a,b) return a.increase > b.increase end)
    local flag = 0
    for i = 1, 3 do
        local data = attrs[i]
        local attrobj = CommonHelper:SetGameObjectActive("attr"..i, itemObj, data ~= nil)
        if data ~= nil then
            local state1 = CommonHelper:SetGameObjectActive("feature1", attrobj, data.increase == 1)
            local state2 = CommonHelper:SetGameObjectActive("feature2", attrobj, data.increase == -1)

            local tempobj = (data.increase == 1) and state1 or state2
            CommonHelper:SetGameObjectActive("flag", tempobj, flag ~= data.increase)
            if flag ~= data.increase then flag = data.increase end

            CommonHelper:SetText("###name", tempobj, CommonHelper:GetAttrName(data.type))

            for i = 1, 3 do CommonHelper:SetGameObjectActive("featurelv"..i, tempobj, 1 == i) end
        end
    end

    --}}}



    --{{{材料消耗

    ---@type dictconsume_config_cell[]
    local costs = CommonHelper:GetConsumeGroup(cfg.costids)
    for i = 1, 3 do
        ---@type dictconsume_config_cell
        local data=costs[i]

        if data and  data.propsid==CurrencyType.Gold then
            data=nil
        end
        local obj = CommonHelper:SetGameObjectActive("ItemCost"..i, itemObj, data ~= nil)
        if data then
            local param = Param_ItemArticleParam()
            CommonHelper:SetItemArticleGroup(obj,UIModuleID.Garage,data.propsid, param,function(data)

            end,data.propsid)

            local count = data.propsnum
            local cur = KnapsackDataManager:Get():GetArticleCountByCfgid(data.propsid)
            local str = ""
            if cur >= count then
                str = CommonHelper:GetTempStr_Default(TemplateStringID.ReformCostFormatYes, cur,count)
            else
                str = CommonHelper:GetTempStr_Default(TemplateStringID.ReformCostFormatNo,  cur,count)
            end
            CommonHelper:SetText("###count", obj, str)
        end
    end
   -- }}}




end