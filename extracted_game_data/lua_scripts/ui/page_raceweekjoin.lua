


---@class Page_RaceWeekJoin
Page_RaceWeekJoin = class("Page_RaceWeekJoin")
function Page_RaceWeekJoin:initialize()

end

function Page_RaceWeekJoin:ClearData()

end

---@param data RaceWeekData
function Page_RaceWeekJoin:SetData(root, data)
    self.Param_Data = data
    self:SetDataBaseInfo(root, data)
    self:SetDataUIGroup(root, data)
    self:SetDataCostInfo(root, data)
    self:SetDataScrollView(root, data)

    CommonHelper:HButtonSetCallback("BtnJoin",root,function (hbtn)
        self:ClickBtnJoin()
    end)

    CommonHelper:HButtonSetCallback("BtnSelectCar",root,function (hbtn)
        self:ClickBtnChangeCar()
    end)
end

---@param data RaceWeekData
function Page_RaceWeekJoin:SetDataBaseInfo(root, data)
    local obj = UIUtil.GetChild("RaceWeekBaseInfo", root)
    local baseinfo = Pre_RaceWeekBaseInfo()
    baseinfo:SetData(obj, data, UIModuleID.RaceWeekDetail)
end

---@param data RaceWeekData
function Page_RaceWeekJoin:SetDataUIGroup(root, data)
    local notjoin = UIUtil.GetChildInputPath("JoinState1", root)
    local havejoin = UIUtil.GetChildInputPath("JoinState2", root)
    notjoin:SetActive(not data:GetIsJoin())
    havejoin:SetActive(data:GetIsJoin())
end

---@param data RaceWeekData
function Page_RaceWeekJoin:SetDataCostInfo(root, data)
    local cfg = data:GetCfg()
    local costdata = CommonHelper:Parse2StringToReward(cfg.cost)
    local str = "免费"
    if costdata then str = tostring(costdata.num) end
    CommonHelper:SetText("costvalue",root, str)
end

---@param data RaceWeekData
function Page_RaceWeekJoin:SetDataScrollView(root, data)
    local cfg = data:GetCfg()
    self.RewardList = {}
    local temp = stringSplit(cfg.reward, '|')
    for i = 1, #temp do
        local list = CommonHelper:ParseToReward2(temp[i])
        if list then
            table.insert(self.RewardList, {i, list})
        end
    end

    local scroll = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", root, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(scroll, #self.RewardList, 1,function(dataIndex, itemObj, scroll)
        self:UpdateScrollView(dataIndex, itemObj)
    end)

end

function Page_RaceWeekJoin:UpdateScrollView(dataIndex, itemObj)
    local data = self.RewardList[dataIndex + 1]
    local rank = data[1]
    ---@type table<number,RewardData>
    local list = data[2]

    for i = 1, 3 do
        local obj = CommonHelper:SetGameObjectActive("ArticleCompoent"..i, itemObj, i <= #list)
        if i <= #list then
            local param = Param_ArticleGroup()
            param.articleId = list[i].id
            param.moduleId = UIModuleID.RaceWeekDetail
            param.count = list[i].num
            CommonHelper:SetArticleGroup(obj, param)
        end
    end

    for i = 1, 6 do
        CommonHelper:SetGameObjectActive("rank"..i, itemObj, i == rank)
    end
end

function Page_RaceWeekJoin:ClickBtnJoin()
    UIManager:Get():OpenView("RaceWeekSelectCarView",CanvasType.MainCanvas,"RaceWeekSelectCarView")
    local param = {self.Param_Data, RaceWeekSelectCarType.Join}
    UINotify:Get():SendNotification(UINotifyEvent.RaceWeekSelectCarView_SetData, param)
end

function Page_RaceWeekJoin:ClickBtnChangeCar()
    UIManager:Get():OpenView("RaceWeekSelectCarView",CanvasType.MainCanvas,"RaceWeekSelectCarView")
    local param = {self.Param_Data, RaceWeekSelectCarType.ChangeCar}
    UINotify:Get():SendNotification(UINotifyEvent.RaceWeekSelectCarView_SetData, param)
end