


---@class RaceWeekView : ViewBase
RaceWeekView = class("RaceWeekView", ViewBase)

function RaceWeekView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceWeekViewAction")
end

function RaceWeekView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnHistory",self.gameObject,function (hbtn)
        UIManager:Get():OpenView("RaceWeekHistoryViewAction",CanvasType.MainCanvas,"RaceWeekHistoryViewAction")
        RaceWeekSubsystem:Get():SendMsg_History()
    end)

    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
end

function RaceWeekView:OnOpen()
    self:SetData()
end

function RaceWeekView:OnClose()

end

function RaceWeekView:SetData()
    local list = RaceWeekManager:Get():GetRaceList()
    ---@type table<number, RaceWeekData>
    self.RaceList = {}
    for k,v in pairs(list) do
        table.insert(self.RaceList, v)
    end
    self:SortList()

    CommonHelper:InitMoreRowScrollView(self.ScrollView, #self.RaceList, 1,function(dataIndex, itemObj, scroll)
        self:UpdateScrollView(dataIndex, itemObj)
    end)
end

function RaceWeekView:SortList()
    table.sort(self.RaceList,function (a,b)
        if a:GetIsJoin() and not b:GetIsJoin() then
            return true
        end
        if not a:GetIsJoin() and b:GetIsJoin() then
            return false
        end
        return a:GetServerID() < b:GetServerID()
    end)
end

function RaceWeekView:UpdateScrollView(dataIndex, itemObj)
    local data = self.RaceList[dataIndex + 1]
    if data == nil then
        return
    end

    CommonHelper:SetText("racename", itemObj, data:GetName())
    CommonHelper:SetText("rulename", itemObj, data:GetRuleName())
    CommonHelper:SetText("joinnum", itemObj, "参与人数:"..data:GetJoinNum())

    CommonHelper:SetGameObjectActive("havejoin", itemObj, data:GetIsJoin())
    local endtime = data:GetStartTime()
    local str = string.format("%04d-%02d-%02d %02d:%02d",endtime.Year, endtime.Month, endtime.Day, endtime.Hour, endtime.Minute)
    CommonHelper:SetText("time", itemObj, str)


    local btnjoin = CommonHelper:HButtonSetCallback("BtnJoin",itemObj,function (hbtn)
        self:OnClickBtnDetail(hbtn.intData)
    end, dataIndex)
    CommonHelper:SetHButtonClick(btnjoin, not data:GetIsJoin(), true)


    local btndetail = CommonHelper:HButtonSetCallback("BtnDetail",itemObj,function (hbtn)
        self:OnClickBtnDetail(hbtn.intData)
    end, dataIndex)
    CommonHelper:SetHButtonClick(btndetail, data:GetIsJoin(), true)


    local cfg = data:GetCfg()

    CommonHelper:GetComponentSetUITexture("RawIcon", itemObj, cfg.icon,UIModuleID.RaceWeekDetail)

    local costdata = CommonHelper:Parse2StringToReward(cfg.cost)
    CommonHelper:SetGameObjectActive("nocost", itemObj, costdata == nil)
    CommonHelper:SetGameObjectActive("cost", itemObj, costdata ~= nil)
    if costdata then
        CommonHelper:SetText("costvalue",itemObj, tostring(costdata.num))
        local costArticle = UIUtil.GetChild("costarticle", itemObj)
        local param = Param_ArticleGroup()
        param.articleId = costdata.id
        param.moduleId = UIModuleID.RaceWeekDetail
        CommonHelper:SetArticleGroup(costArticle, param)
    end


    local tempstr = stringSplit(cfg.reward,'|')
    local list = CommonHelper:ParseToReward2(tempstr[1])
    if list then
        local rankdata = list[1]
        local rankArticle = UIUtil.GetChild("rewardarticle", itemObj)
        local param = Param_ArticleGroup()
        param.articleId = rankdata.id
        param.moduleId = UIModuleID.RaceWeekDetail
        param.count = rankdata.num
        CommonHelper:SetArticleGroup(rankArticle, param)
    end


    if cfg.condition == "-1" then
        CommonHelper:SetText("limit",itemObj, "无其他限制")
    else
        CommonHelper:SetText("limit",itemObj, cfg.condition)
    end
end

function RaceWeekView:OnClickBtnDetail(dataIndex)
    local data = self.RaceList[dataIndex + 1]
    if data == nil then
        return
    end

    RaceWeekManager:Get():TryOpenRaceInfo(data:GetServerID())
end