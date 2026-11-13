


---@class RaceSelfJoinView : ViewBase
RaceSelfJoinView = class("RaceSelfJoinView", ViewBase)

function RaceSelfJoinView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceSelfJoinViewAction")
end

function RaceSelfJoinView:Awake()
    self.JoinState1 = UIUtil.GetChildInputPath("JoinState1", self.gameObject)
    self.JoinState2 = UIUtil.GetChildInputPath("JoinState2", self.gameObject)

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnJoin",self.gameObject,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfJoinView_ClickBtnJoin)
    end)

    CommonHelper:HButtonSetCallback("BtnSelectCar",self.gameObject,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfJoinView_ClickBtnChangeCar)
    end)

    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))

    ---@type RaceSelfData
    self.SelectRace = nil

    self.RewardList = {}
end

function RaceSelfJoinView:OnOpen()

end

function RaceSelfJoinView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceSelfJoin)
end

---@param data RaceSelfData
function RaceSelfJoinView:SetData(data)
    if data == nil then
        return
    end

    self.SelectRace = data




    self:SetBaseData()

    self:SetUIGroup()

    self:SetCostInfo()

    self:SetScrollView()
end

function RaceSelfJoinView:SetBaseData()
    local obj = UIUtil.GetChild("BaseInfo", self.gameObject)
    local baseinfo = Pre_RaceRuleBaseInfo()
    baseinfo:SetRaceSelfData(obj, self.SelectRace, UIModuleID.RaceSelfJoin)

    CommonHelper:SetText("TitleCompoentRed/title1", self.gameObject, self.SelectRace.Name)
end

function RaceSelfJoinView:SetUIGroup()
    local id = RaceSelfManager:Get():GetJoinRaceID()
    local none = id < 0
    local jointhis = self.SelectRace:GetIsJoin() and id == self.SelectRace.ID
    local joinother = self.SelectRace:GetIsJoin() and id ~= self.SelectRace.ID
    self.JoinState1:SetActive(none)
    self.JoinState2:SetActive(jointhis)
    CommonHelper:SetGameObjectActive("cost", self.gameObject, not joinother)
end

function RaceSelfJoinView:SetCostInfo()
    ---@type pamgroup_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.pamgroup_config, self.SelectRace.CostID)
    if cfg then
        local costdata = CommonHelper:Parse2StringToReward(cfg.joinCost)
        local str = "免费"
        if costdata then str = tostring(costdata.num) end
        CommonHelper:SetText("costvalue",self.gameObject, str)
    end
end

function RaceSelfJoinView:SetScrollView()
    ---@type pamgroup_config_cell
    local costcfg = CommonHelper:GetTableDataByID(ConfigNames.pamgroup_config, self.SelectRace.CostID)
    if costcfg then
        self.RewardList = {}
        local temp = stringSplit(costcfg.rankReward, '|')
        for i = 1, #temp do
            local list = CommonHelper:ParseToReward2(temp[i])
            if list then
                table.insert(self.RewardList, {i, list})
            end
        end

        local joinreward = CommonHelper:ParseToReward2(costcfg.joinReward)
        if joinreward then
            table.insert(self.RewardList, {6, joinreward})
        end

    end
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #self.RewardList, 1,function(dataIndex, itemObj, scroll)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfJoinView_UpdateScrollView, {dataIndex, itemObj})
    end)

end

function RaceSelfJoinView:UpdateScrollView(dataIndex, itemObj)
    local data = self.RewardList[dataIndex + 1]
    local rank = data[1]
    ---@type table<number,RewardData>
    local list = data[2]

    for i = 1, 3 do
        local obj = CommonHelper:SetGameObjectActive("ArticleCompoent"..i, itemObj, i <= #list)
        if i <= #list then
            local param = Param_ArticleGroup()
            param.articleId = list[i].id
            param.moduleId = UIModuleID.RaceSelfJoin
            param.count = list[i].num
            CommonHelper:SetArticleGroup(obj, param)
        end
    end

    for i = 1, 6 do
        CommonHelper:SetGameObjectActive("rank"..i, itemObj, i == rank)
    end
end





function RaceSelfJoinView:ClickBtnJoin()
    UIManager:Get():OpenView("RaceSelfSelectCarView",CanvasType.MainCanvas,"RaceSelfSelectCarView")
    local param = {self.SelectRace, RaceSelfSelectCarType.Join}
    UINotify:Get():SendNotification(UINotifyEvent.RaceSelfSelectCarView_SetData, param)
end

function RaceSelfJoinView:ClickBtnChangeCar()
    UIManager:Get():OpenView("RaceSelfSelectCarView",CanvasType.MainCanvas,"RaceSelfSelectCarView")
    local param = {self.SelectRace, RaceSelfSelectCarType.ChangeCar}
    UINotify:Get():SendNotification(UINotifyEvent.RaceSelfSelectCarView_SetData, param)
end