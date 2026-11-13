


---@class RaceSelfView : ViewBase
RaceSelfView = class("RaceSelfView", ViewBase)

function RaceSelfView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceSelfViewAction")
end

function RaceSelfView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnHistory",self.gameObject,function (hbtn)
        UIManager:Get():OpenView("RaceSelfHistoryView",CanvasType.MainCanvas,"RaceSelfHistoryView")
        RaceSelfSubsystem:Get():SendMsg_History()
    end)

    CommonHelper:HButtonSetCallback("BtnSearch",self.gameObject,function (hbtn)
        UIManager:Get():OpenPopup("CommonInputView", CanvasType.FrontCanvas, "CommonInputView")
        local param = CommonInputViewParam()
        param.UIColor = UIColor.Red
        param.TitleName = "搜索赛事"
        param.DefaultValue = "请输入赛事ID"
        param.Func = self.SearchRaceCB
        param.FuncClass = self
        UINotify:Get():SendNotification(UINotifyEvent.CommonInputView_SetData, param)
    end)

    CommonHelper:HButtonSetCallback("BtnShop",self.gameObject,function (hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.Shop,ShopID.Diamond)
    end)


    self.JoinBlank = UIUtil.GetChildInputPath("join/blank", self.gameObject)
    self.JoinInfo = UIUtil.GetChildInputPath("join/info", self.gameObject)
    self.CreateBlank = UIUtil.GetChildInputPath("create/blank", self.gameObject)
    self.CreateInfo = UIUtil.GetChildInputPath("create/info", self.gameObject)

    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))

    CommonHelper:HButtonSetCallback("BtnCreate",self.CreateBlank,function (hbtn)
        RaceSelfCacheManager:Get():CreateCache()
        UIManager:Get():OpenView("RaceSelfCreateView",CanvasType.MainCanvas,"RaceSelfCreateView")

    end)

    CommonHelper:HButtonSetCallback("BtnInfo",self.JoinInfo,function (hbtn)
        RaceSelfManager:Get():TryOpenRaceInfo(RaceSelfManager:Get():GetJoinRaceID(), RaceSelfUIFlag.Joiner)
    end)
    CommonHelper:HButtonSetCallback("BtnInfo",self.CreateInfo,function (hbtn)
        RaceSelfManager:Get():TryOpenRaceInfo(RaceSelfManager:Get():GetCreateRaceID(), RaceSelfUIFlag.Creater)
    end)
end

function RaceSelfView:OnOpen()

end

function RaceSelfView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceSelf)
end

function RaceSelfView:ReOpen()
    RaceSelfSubsystem:Get():SendMsg_GetAllList()
end

---@param msg SC_SC_GetAllGameRes
function RaceSelfView:SetData(msg)
    self:SetJoinInfo()
    self:SetCreateInfo()
    self:SetRaceList(msg)
end

function RaceSelfView:SetJoinInfo()
    local data = RaceSelfManager:Get():GetJoinData()
    self.JoinBlank:SetActive(data == nil)
    self.JoinInfo:SetActive(data ~= nil)
    if data then
        CommonHelper:SetText("playername", self.JoinInfo, data.Creater)
        CommonHelper:SetText("racename", self.JoinInfo, data.Name)
        CommonHelper:SetText("state", self.JoinInfo, CommonHelper:GetTempStr_RaceSelfState(data:GetRaceState()))

        CommonHelper:GetComponentSetUITexture("RawIcon", self.JoinInfo, data.CreaterIcon,UIModuleID.RaceSelf)
    end
end

function RaceSelfView:SetCreateInfo()
    local data = RaceSelfManager:Get():GetCreateData()
    self.CreateBlank:SetActive(data == nil)
    self.CreateInfo:SetActive(data ~= nil)
    if data then
        CommonHelper:SetText("racename", self.CreateInfo, data.Name)
        CommonHelper:SetText("state", self.CreateInfo, CommonHelper:GetTempStr_RaceSelfState(data:GetRaceState()))

        CommonHelper:GetComponentSetUITexture("RawIcon", self.CreateInfo, data.CreaterIcon,UIModuleID.RaceSelf)
    end
end

---@param msg table<number, SC_SC_MiniGameInfo>
function RaceSelfView:SetRaceList(msg)
    if msg == nil then return end

    ---@type table<number, RaceSelfData>
    self.RaceList = {}

    for i = 1, #msg do
        local data = RaceSelfData()
        data:SetMiniBaseData(msg[i])
        table.insert(self.RaceList, data)
    end

    CommonHelper:InitMoreRowScrollView(self.ScrollView, #self.RaceList, 1,function(dataIndex, itemObj, scroll)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfView_UpdateScrollView, {dataIndex, itemObj})
    end)
end

function RaceSelfView:UpdateScrollView(dataIndex, itemObj)
    local data = self.RaceList[dataIndex + 1]

    CommonHelper:SetText("playername", itemObj, data.Creater)
    CommonHelper:SetText("racename", itemObj, data.Name)
    CommonHelper:SetText("rulename", itemObj, CommonHelper:GetTempStr_RaceSelfRule(data.RaceType))

    CommonHelper:GetComponentSetUITexture("RawIcon", itemObj, data.CreaterIcon,UIModuleID.RaceSelf)

    CommonHelper:SetGameObjectActive("friendflag", itemObj, data.Flag == RaceSelfFlag.Friend)
    CommonHelper:SetGameObjectActive("clubflag", itemObj, data.Flag == RaceSelfFlag.Club)

    local endtime = data:GetEndDateTime()
    local str = string.format("%04d-%02d-%02d %02d:%02d",endtime.Year, endtime.Month, endtime.Day, endtime.Hour, endtime.Minute)
    CommonHelper:SetText("time", itemObj, str)


    ---@type pamgroup_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.pamgroup_config, data.CostID)
    if cfg then
        local costdata = CommonHelper:Parse2StringToReward(cfg.joinCost)
        CommonHelper:SetGameObjectActive("free", itemObj, costdata == nil)
        CommonHelper:SetGameObjectActive("cost", itemObj, costdata ~= nil)
        if costdata then
            CommonHelper:SetText("costvalue",itemObj, tostring(costdata.num))
            local costArticle = UIUtil.GetChild("costarticle", itemObj)
            local param = Param_ArticleGroup()
            param.articleId = costdata.id
            param.moduleId = UIModuleID.RaceSelf
            CommonHelper:SetArticleGroup(costArticle, param)
        end


        local tempstr = stringSplit(cfg.rankReward,'|')
        local list = CommonHelper:ParseToReward2(tempstr[1])
        if list then
            local rankdata = list[1]
            local rankArticle = UIUtil.GetChild("rewardarticle", itemObj)
            local param = Param_ArticleGroup()
            param.articleId = rankdata.id
            param.moduleId = UIModuleID.RaceSelf
            param.count = rankdata.num
            CommonHelper:SetArticleGroup(rankArticle, param)
        end
    end







    CommonHelper:HButtonSetCallback("BtnJoin",itemObj,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfView_ClickItem, hbtn.intData)
    end, dataIndex)
end

function RaceSelfView:ClickBtnScrollViewItem(dataIndex)
    local data = self.RaceList[dataIndex + 1]

    RaceSelfManager:Get():TryOpenRaceInfo(data.ID, RaceSelfUIFlag.Unknown)
end


function RaceSelfView:SearchRaceCB(param, value)
    print("---   ID = ",value)
    for i = 1, #self.RaceList do
        local data = self.RaceList[i]
        if data.ID == tonumber(value) then
            self:SetSearchResult(data)
            return
        end
    end

    CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfNoFindRace))
end

---@param data RaceSelfData
function RaceSelfView:SetSearchResult(data)
    self.RaceList = {}
    table.insert(self.RaceList, data)

    CommonHelper:InitMoreRowScrollView(self.ScrollView, #self.RaceList, 1,function(dataIndex, itemObj, scroll)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfView_UpdateScrollView, {dataIndex, itemObj})
    end)
end