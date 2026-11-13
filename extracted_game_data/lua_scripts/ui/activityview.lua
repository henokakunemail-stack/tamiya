---@class ActivityView : ViewBase
ActivityView = class("ActivityView", ViewBase)
function ActivityView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ActivityViewAction")
end

function ActivityView:Awake()
    self.activityList = self:GetChildWightByParent("ActivityList", self.gameObject, typeof(MoreRowScrollView))
    ---@type  Page_ActivityBase
    self.pageActivity = nil
    self:CachePageInfo()

    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function()
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnHome", self.gameObject, function(hbtn)
        SkipModuleHelper:Get():BackToMainMenuView(false)
    end)

    self.PageConfig = { 1, 2, 3, 4, 5, 6, 50, 51, 100,101, 200 }
    self.pageCGTab = {}
    ---@type act_activity_config
    local activityTab = ActivityDataManager:Get():GetActivityList()
    for i = 1, #activityTab do
        local pageCG = self:GetChildWightByParent("Activity" .. activityTab[i].C_ID, self.gameObject, typeof(CanvasGroup))
        self.pageCGTab[activityTab[i].C_ID] = pageCG
    end
end

local List = nil
local _SelectIdx = -1
function ActivityView:OnOpen()
    self:ViewFixScreen()

end

function ActivityView:SetData()
    _SelectIdx = 0
    self:InitViewInfo()
end

function ActivityView:CacheData()

end

function ActivityView:CachePageInfo()

end

function ActivityView:InitBtnFunc()

end
function ActivityView:InitViewInfo()
    List = ActivityDataManager:Get():GetActivityList()

    for k, v in pairs(self.PageConfig) do
        local flag = false
        for i = 1, #List do
            if List[i].C_ID == v then
                flag = true
                break
            end
        end
        CommonHelper:SetGameObjectActive("Activity" .. v, self.gameObject, flag)
    end
    local updateFunc = function(dataIndex, itemObj, scroll)
        ---@type act_activity_config_cell
        local data = List[dataIndex + 1]
        CommonHelper:SetText("hovergroup/tweenhover/###text", itemObj, CommonHelper:GetTempStr_Default(data.tab))
        CommonHelper:SetText("normalgroup/normalgroup/###text", itemObj, CommonHelper:GetTempStr_Default(data.tab))

        local tog = CommonHelper:HButtonSetCallback("ItemBtn", itemObj, function(param)
            if _SelectIdx == param.intData then
                return
            end
            _SelectIdx = param.intData
            self:RefreshCurList()
            if self.pageActivity then
                self.pageActivity:OnChangeBase()
            end
            ActivitySubsystem:Get():SendMsg_GetActivity(List[_SelectIdx + 1].giftid, true)
        end, dataIndex)

        CommonHelper:SetToggleState(tog, _SelectIdx == dataIndex)
        CommonHelper:SetGameObjectActive("selectImg", itemObj, false)
        if data.C_ID == ActivityType.WeekCard then
            CommonHelper:SetGameObjectActive("RedPoint1ActivityPay", itemObj,
                    RedPointManager:Get():GetValue(RedPointID.S_WeekCardGet) or
                            RedPointManager:Get():GetValue(RedPointID.S_MonthCardGet))
        elseif data.C_ID == ActivityType.ActCharge then
            CommonHelper:SetGameObjectActive("RedPoint1ActivityPay", itemObj,
                    RedPointManager:Get():GetValue(RedPointID.S_ActCharge))
        else
            CommonHelper:SetGameObjectActive("RedPoint1ActivityPay", itemObj, false)
        end
    end
    CommonHelper:InitMoreRowScrollView(self.activityList, #List, 1, updateFunc, true)

end
function ActivityView:RefreshChargeState()
    ActivitySubsystem:Get():SendMsg_GetActivity(List[_SelectIdx + 1].giftid, false)
end
function ActivityView:RefreshCurList()
    CommonHelper:MoreRowView_RefreshCurList(self.activityList, false)
end

function ActivityView:InitCG(id)
    for k, v in pairs(self.pageCGTab) do
        UIUtil.ShowCanvasGroup(v, k == id)
    end
end
function ActivityView:SetPageDataById(id, msg, isreset)
    if id == ActivityType.MonthCard then

    elseif id == ActivityType.BigBag then
        self.pageActivity = Page_ActivitySuperPack()
    elseif id == ActivityType.NewPlayerBag then
        self.pageActivity = Page_ActivityNewBieGift()
    elseif id == ActivityType.DailyBag then
        self.pageActivity = Page_PreferentialBag()
    elseif id == ActivityType.Purchase then
        self.pageActivity = Page_RechargeView()
    elseif id == ActivityType.PurchaseDiamond then
        self.pageActivity = Page_RechargeDiamondView()
    elseif id == ActivityType.WeekCard then
        self.pageActivity = Page_ActivityWeekCardView() --周月卡
    elseif id == ActivityType.SpecialGift then
        self.pageActivity = Page_ActivitySpecialGift()
    elseif id == ActivityType.GrowthAward then
        self.pageActivity = Page_ActivityGrowthAwardView() --成长战令
    elseif id == ActivityType.GrowthAwardMax then
        self.pageActivity = Page_ActivityGrowthAwardMaxView() --成长战令
    elseif id == ActivityType.RookiePackage then
        self.pageActivity = Page_ActivityRookiePackage() --新手礼包
    elseif id == ActivityType.Decals then
        self.pageActivity = Page_ActivityDecalsBag() --新手礼包
    elseif id == ActivityType.ActCharge then
        self.pageActivity = Page_ActChargeView() --活动充值
    end
    if self.pageActivity ~= nil then
        local parent = self.pageCGTab[id]
        self.pageActivity:InitViewInfo(parent.gameObject, id, msg, isreset)
    end
end

function ActivityView:InitPageInfo(msg, isreset)
    self:InitCG(List[_SelectIdx + 1].C_ID)
    self:SetPageDataById(List[_SelectIdx + 1].C_ID, msg, isreset)
end

---@param msg SC_PlayerActivityInfoRes
function ActivityView:InitPageViewInfo(msg)
    if self.pageActivity ~= nil then
        ---@type activity_config_cell
        local cell = CommonHelper:GetTableDataByID(ConfigNames.activity_config, msg.activityId)

        local parent = self.pageCGTab[cell.id]

        self.pageActivity:InitViewInfo(parent.gameObject, cell.activityType, msg)
    end
end

function ActivityView:OnClose()
    if self.pageActivity then
        self.pageActivity:OnBaseClose()
    end
    CommonHelper:ReleasePool(UIModuleID.Activity)
end








