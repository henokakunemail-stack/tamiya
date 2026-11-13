



local __CostList = {}
local __RewardList = {}

function RaceSelfCreateView:SetStep4(default)
    self:SetPageGroup(4)


    self.Param_CostID = 0

    CommonHelper:SetInputFieldText("InputName", self.Page4, PlayerDataManager:Get():GetPlayerName().."创建的赛事")
    self.Step4_TogCost = {}
    for i = 1, 5 do
        self.Step4_TogCost[i] = CommonHelper:HButtonSetCallback("TogCost"..i,self.Page4,function (hbtn)
            UINotify:Get():SendNotification(UINotifyEvent.RaceSelfCreateView_Step4_ClickTogCost, hbtn.intData)
        end, i)
    end
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))

    self:Step4_SetCostTog()

    if default then
        self:Step4_ClickTogCost(1)
    end
end

function RaceSelfCreateView:Step4_ClickTogCost(idx)
    for i = 1, #self.Step4_TogCost do
        CommonHelper:SetToggleState(self.Step4_TogCost[i], i == idx, true)
    end

    self.Param_CostID = __CostList[idx]

    self:Step4_SetScrollView()
end

function RaceSelfCreateView:Step4_SetCostTog()
    __CostList = {}
    local cfg = JsonData_Race:Get()
    local temp = cfg.pamgroup[self.Param_RuleType - 1]
    for i = 1, #temp do
        table.insert(__CostList, temp[i])
    end

    for i = 1, #self.Step4_TogCost do
        local obj = self.Step4_TogCost[i].gameObject
        obj:SetActive(i <= #__CostList)
        if i <= #__CostList then
            self:Step4_SetCostInfo(obj, i)
        end
    end
end

function RaceSelfCreateView:Step4_SetCostInfo(obj, idx)
    ---@type pamgroup_config_cell
    local costcfg = CommonHelper:GetTableDataByID(ConfigNames.pamgroup_config, __CostList[idx])
    if costcfg then
        local cost = CommonHelper:Parse2StringToReward(costcfg.joinCost)
        CommonHelper:SetGameObjectActive("nocost", obj, cost == nil)
        local articleobj = CommonHelper:SetGameObjectActive("ArticleCompoent", obj, cost ~= nil)
        if cost then
            local param = Param_ArticleGroup()
            param.articleId = cost.id
            param.moduleId = UIModuleID.RaceSelfCreate
            param.count = cost.num
            CommonHelper:SetArticleGroup(articleobj, param)
        end
    end
end

function RaceSelfCreateView:Step4_SetScrollView()

    ---@type pamgroup_config_cell
    local costcfg = CommonHelper:GetTableDataByID(ConfigNames.pamgroup_config, self.Param_CostID)
    if costcfg then
        __RewardList = {}
        local temp = stringSplit(costcfg.rankReward, '|')
        for i = 1, #temp do
            local list = CommonHelper:ParseToReward2(temp[i])
            if list then
                table.insert(__RewardList, {i, list})
            end
        end

        local joinreward = CommonHelper:ParseToReward2(costcfg.joinReward)
        if joinreward then
            table.insert(__RewardList, {6, joinreward})
        end

    end


    CommonHelper:InitMoreRowScrollView(self.ScrollView, #__RewardList, 1,function(dataIndex, itemObj, scroll)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfCreateView_Step4_UpdateScrollView, { dataIndex, itemObj})
    end)

end

function RaceSelfCreateView:Step4_UpdateScrollView(dataIndex, itemObj)
    local data = __RewardList[dataIndex + 1]
    local rank = data[1]
    ---@type table<number,RewardData>
    local list = data[2]


    for i = 1, 3 do
        local obj = CommonHelper:SetGameObjectActive("ArticleCompoent"..i, itemObj, i <= #list)
        if i <= #list then
            local param = Param_ArticleGroup()
            param.articleId = list[i].id
            param.moduleId = UIModuleID.RaceSelfCreate
            param.count = list[i].num
            param.ClickShowTips = true
            CommonHelper:SetArticleGroup(obj, param)
        end
    end


    for i = 1, 6 do
        CommonHelper:SetGameObjectActive("rank"..i, itemObj, i == rank)
    end
end