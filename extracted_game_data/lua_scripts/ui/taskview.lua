
---@class TaskView : ViewBase
TaskView = class("TaskView", ViewBase)
function TaskView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "TaskViewAction")
end
---@type TaskData[]
local _CurData=nil
local nowScheduleNum = -1
local _CurPage=nil
local _CurSubPage=-1
local _LastPage=nil
function TaskView:Awake()

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (data)
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnHome",self.gameObject,function (hbtn)
        local openType=TaskDataManager:Get():GetOpenModuleType()
        SkipModuleHelper:Get():BackToMainMenuView(openType==UIModuleID.RaceRank or openType==UIModuleID.SpecialTraining or openType==UIModuleID.Recruit)
    end)

    local Center=self:GetChild("Center")
    self.growup=self:GetChildByParent("growupview",Center)
    self.normal=self:GetChildByParent("normalview",Center)
    self.novice=self:GetChildByParent("noviceview",Center)
    self.toggleview=self:GetChildByParent("toggleview",Center)
    self.adtaskview=self:GetChildByParent("adtaskview",Center)
    self.buttomParentDaily=self:GetChildByParent("buttomParentDaily",Center)
    self.buttomParentNotice=self:GetChildByParent("buttomParentNotice",Center)
    self.downItem=self:GetChildByParent("zdownItem",Center)
    self.box=self:GetChildWightByParent("box",Center,typeof(RectTransform))

    self.noviceSVC=self:GetChildWightByParent("noviceSVC",Center,typeof(MoreRowScrollView))
    self.ScrollView=self:GetChildWightByParent("ScrollView",Center,typeof(MoreRowScrollView))

    self.Active=self:GetChildWightByParent("activearea",Center,typeof(CanvasGroup))
    self.ActiveObj=self:GetChildByParent("activearea",Center)

    self.TogDaily = CommonHelper:HButtonSetCallback("Toggle_Daily", self.gameObject, function(data)
        self:SendMsg(TaskType.Daily)
    end)

    self.TogNovice = CommonHelper:HButtonSetCallback("Toggle_Novice", self.gameObject, function(data)
        self:SendMsg(TaskType.Novice)
    end)
    self.Toggle_Rank = CommonHelper:HButtonSetCallback("Toggle_Rank", self.gameObject, function(data)

    end)
    self.Toggle_SpecialTrain = CommonHelper:HButtonSetCallback("Toggle_SpecialTrain", self.gameObject, function(data)
        self:SendMsg(TaskType.SpecialTraining)
    end)
    self.Toggle_RecruitShell = CommonHelper:HButtonSetCallback("Toggle_RecruitShell", self.gameObject, function(data)
        self:SendMsg(TaskType.Recruit)
    end)
    self.Toggle_RecruitCount = CommonHelper:HButtonSetCallback("Toggle_RecruitCount", self.gameObject, function(data)
        RecruitSubsystem:Get():SendMsg_GetRecruitCountInfo(TaskDataManager:Get():GetRecruitID())
    end)
    self.Toggle_S_CP = CommonHelper:HButtonSetCallback("Toggle_S_CP", self.gameObject, function(data)
        self:SendMsg(TaskType.Jcp)
    end)
    self.Toggle_X_CP = CommonHelper:HButtonSetCallback("Toggle_X_CP", self.gameObject, function(data)
        self:SendMsg(TaskType.Xcp)
    end)
    self.Toggle_Ad =CommonHelper:HButtonSetCallback("Toggle_Ad", self.gameObject, function(data)
        AdRewardSubsystem:Get():SendMsg_GetAdRewardList()
    end)
    self.Toggle_SuperBattle = CommonHelper:HButtonSetCallback("Toggle_SuperBattle", self.gameObject, function(data)

    end)


    self.Toggle_Page_RankDaily = CommonHelper:HButtonSetCallback("Toggle_Page_RankDaily", self.gameObject, function(data)
        self:SendMsg(TaskType.DailyRank)
    end)
    self.Toggle_Page_Rank = CommonHelper:HButtonSetCallback("Toggle_Page_Rank", self.gameObject, function(data)
        self:SendMsg(TaskType.Rank)
    end)
    self.Toggle_Page_Race1 = CommonHelper:HButtonSetCallback("Toggle_Page_Race1", self.gameObject, function(data)
        _CurSubPage = TaskSubType.SpecialTraining_Race1
    end)
    self.Toggle_Page_Race2 = CommonHelper:HButtonSetCallback("Toggle_Page_Race2", self.gameObject, function(data)
        _CurSubPage = TaskSubType.SpecialTraining_Race2
    end)


    --self.TogWeek=  CommonHelper:HButtonSetCallback("TogWeek",self.gameObject,function(data)
    --    self:SendMsg(TaskType.Week)
    --end)
    self.TogGrowUp = CommonHelper:HButtonSetCallback("Toggle_GrowUp", self.gameObject, function(data)
        self:SendMsg(TaskType.GrowUp)
    end)
    --self.TogSeasonOrder=CommonHelper:HButtonSetCallback("TogSeasonOrder",self.gameObject,function(data)
    --    self:SendMsg(TaskType.SeasonOrder)
    --end)
    CommonHelper:HButtonSetCallback("getAllBtn", self.gameObject, function(tempData)
        if _CurPage == TaskType.Novice then
            if _CurData[tempData.intData + 1] then
                TaskSubsystem:Get():SendMsg_GetReward(_CurData[tempData.intData + 1].questType, 0, nowScheduleNum)
            end
        else
            TaskSubsystem:Get():SendMsg_GetReward(_CurData[tempData.intData + 1].questType, 0, 0)
        end
    end)
    CommonHelper:HButtonSetCallback("BuyBtn", self.gameObject, function(tempData)
        if TaskDataManager:Get().AdIsBuy then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.SeasonOrderBuyed))
            return
        end
        CommonHelper:ChargeMoneyByID(2003)
    end)

    self.getTradeAllBtn= CommonHelper:HButtonSetCallback("getTradeAllBtn", self.gameObject, function(tempData)
        local currentData = TaskDataManager:Get():GetNoticeData(nowScheduleNum)
        if currentData.ifGift==ScheduleState.IsDoneNoGet then
            TaskSubsystem:Get():SendMsg_TradeAward(nowScheduleNum)
        end
    end)
    CommonHelper:HButtonSetCallback("leftBtn", self.gameObject, function(tempData)
        nowScheduleNum = nowScheduleNum - 1
        if nowScheduleNum < 1 then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TaskNoviceLeftTipsText))
            nowScheduleNum = 1
        end
        UINotify:Get():SendNotification(UINotifyEvent.RefreshCurView)

    end)

    CommonHelper:HButtonSetCallback("rightBtn", self.gameObject, function(tempData)
        if TaskDataManager:Get().TaskScheduleData[ nowScheduleNum + 1]==nil  then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TaskNoviceRightTipsText))
            return
        end
        if TaskDataManager:Get().TaskScheduleData[ nowScheduleNum + 1].ifGift<=ScheduleState.None then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TaskNoviceNoActive))
            return
        end
        nowScheduleNum= nowScheduleNum + 1
        UINotify:Get():SendNotification(UINotifyEvent.RefreshCurView)

    end)
    self.PointGroup = {}
    for i = 0, 5 do
        local temp = UIUtil.GetChild("BoxState"..i, self.ActiveObj)
        self.PointGroup[i]=temp
    end
    self.SliderStateGroup={}
    for i = 1, 6 do
        local temp = UIUtil.GetChild("SliderState"..i, self.ActiveObj)
        table.insert(self.SliderStateGroup, temp)
    end

    cs_coroutine.start(function()
        coroutine.yield()
        local AutoScrollView = UIUtil.GetTypeChildWightInputPath("AutoMoveScrollView1",self.gameObject,typeof(AutoMoveScrollView))
        CommonHelper:AutoScroll_BreakMove(AutoScrollView,true)
        CommonHelper:AutoScroll_SetValue(AutoScrollView,0)
        CommonHelper:SetGameObjectActive("AutoMoveScrollView1/cotent",self.gameObject,false)
        CommonHelper:SetGameObjectActive("AutoMoveScrollView1/cotent",self.gameObject,true)
        CommonHelper:AutoScroll_Init(AutoScrollView,true,0,function()

        end)
    end)
end
function TaskView:SendMsg(page)
    if _CurPage~=page then
        TaskSubsystem:Get():SendMsg_GetTaskList(page,TaskDataManager:Get():GetOpenModuleType(),TaskDataManager:Get():GetRecruitID())
    end
end

function TaskView:TaskViewSetData(page)
    _CurPage = page
    CommonHelper:SetToggleState(self.TogDaily, _CurPage == TaskType.Daily)
    CommonHelper:SetToggleState(self.TogNovice, _CurPage == TaskType.Novice)
    --CommonHelper:SetToggleState(self.TogWeek,_CurPage==TaskType.Week)
    CommonHelper:SetToggleState(self.TogGrowUp, _CurPage == TaskType.GrowUp)
    CommonHelper:SetToggleState(self.Toggle_Rank, _CurPage == TaskType.Rank or _CurPage == TaskType.DailyRank)
    CommonHelper:SetToggleState(self.Toggle_SpecialTrain, _CurPage == TaskType.SpecialTraining)
    CommonHelper:SetToggleState(self.Toggle_RecruitShell, _CurPage == TaskType.Recruit)
    CommonHelper:SetToggleState(self.Toggle_RecruitCount, _CurPage == TaskType.RecruitCount)
    CommonHelper:SetToggleState(self.Toggle_S_CP, _CurPage == TaskType.Jcp)
    CommonHelper:SetToggleState(self.Toggle_X_CP, _CurPage == TaskType.Xcp)
    CommonHelper:SetToggleState(self.Toggle_SuperBattle, _CurPage == TaskType.SuperBattle)
    --CommonHelper:SetToggleState(self.Toggle_Page_Rank, false)
    CommonHelper:SetToggleState(self.Toggle_Page_Rank, _CurPage == TaskType.Rank)
    CommonHelper:SetToggleState(self.Toggle_Page_RankDaily, _CurPage == TaskType.DailyRank)
    CommonHelper:SetToggleState(self.Toggle_Ad, _CurPage == TaskType.AD)
    CommonHelper:SetToggleState(self.Toggle_Page_Race1, _CurSubPage == TaskSubType.SpecialTraining_Race1)
    CommonHelper:SetToggleState(self.Toggle_Page_Race2, _CurSubPage == TaskSubType.SpecialTraining_Race2)

    --CommonHelper:SetToggleState(self.TogSeasonOrder,_CurPage==TaskType.SeasonOrder)
    _CurData = TaskDataManager:Get():GetTaskList(_CurPage)
    nowScheduleNum=TaskDataManager:Get():GetCurTradeSeq()
    self:SetActive()
    self:SetScrollView()
    self:RefreshNoviceView()
    if _LastPage == -1 then
        CommonHelper:MoreRowView_EnterAniTask(self.ScrollView, 0.28)
    else
        CommonHelper:MoreRowView_EnterAniTask(self.ScrollView, 0)
    end
    _LastPage = _CurPage
end

function TaskView:RefreshCurView()
    if _CurPage==TaskType.Novice and not TaskDataManager:Get():GetNoviceFlag() then
        self:SendMsg(TaskType.Daily)
    else
        _CurData=TaskDataManager:Get():GetTaskList(_CurPage,nowScheduleNum)
    end
    self:RefreshNoviceView()
    self:SetActive()
    self:SetScrollView()
end

function TaskView:SetActive()
    CommonHelper:SetGameObjectActive("task_bg_1",self.gameObject,_CurPage==TaskType.Daily)
    CommonHelper:SetGameObjectActive("task_bg_2",self.gameObject, _CurPage==TaskType.GrowUp)
    if _CurPage==TaskType.Daily then
        UIUtil.ShowCanvasGroup(self.Active,true)
        CommonHelper:SetText("###refreshtime",self.gameObject,ClientDataManager:Get():GetTemplateString(TemplateStringID.TaskTimeDaily))
        CommonHelper:SetText("###activehit",self.ActiveObj,ClientDataManager:Get():GetTemplateString(TemplateStringID.TaskDailyActive))
        CommonHelper:SetText("###curactive",self.ActiveObj,TaskDataManager:Get().dailyActiveNum)
        cs_coroutine.start(function()
            coroutine.yield()
            coroutine.yield()
            self:SetBoxState(TaskDataManager:Get().dailyActiveState)
            self:SetSliderStateGroup(TaskDataManager:Get().dailyActiveNum)
        end)
    elseif _CurPage==TaskType.Week then
        UIUtil.ShowCanvasGroup(self.Active,true)
        CommonHelper:SetText("###refreshtime",self.gameObject,ClientDataManager:Get():GetTemplateString(TemplateStringID.TaskTimeWeek))
        CommonHelper:SetText("###activehit",self.ActiveObj,ClientDataManager:Get():GetTemplateString(TemplateStringID.TaskWeekActive))
        CommonHelper:SetText("###curactive",self.ActiveObj,TaskDataManager:Get().weeklyActiveNum)
        self:SetBoxState(TaskDataManager:Get().weekActiveState)
        self:SetSliderStateGroup(TaskDataManager:Get().weeklyActiveNum)
    elseif _CurPage==TaskType.GrowUp then
        UIUtil.ShowCanvasGroup(self.Active,false)
        CommonHelper:SetText("###refreshtime",self.gameObject,"")
    elseif _CurPage==TaskType.AD then
        UIUtil.ShowCanvasGroup(self.Active,false)
        CommonHelper:SetText("###refreshtime",self.gameObject,"")
    elseif _CurPage==TaskType.Recruit then
        UIUtil.ShowCanvasGroup(self.Active,false)
        CommonHelper:SetText("###refreshtime",self.gameObject,"")
   elseif _CurPage==TaskType.RecruitCount then
        UIUtil.ShowCanvasGroup(self.Active,false)
        CommonHelper:SetText("###refreshtime",self.gameObject,"")
    elseif _CurPage==TaskType.SeasonOrder then
        UIUtil.ShowCanvasGroup(self.Active,false)
        CommonHelper:SetText("###refreshtime",self.gameObject,"")
    elseif _CurPage==TaskType.Novice then
        UIUtil.ShowCanvasGroup(self.Active,false)
        CommonHelper:SetText("###refreshtime",self.gameObject,"")
    elseif _CurPage==TaskType.Rank then
        UIUtil.ShowCanvasGroup(self.Active,false)
        CommonHelper:SetText("###refreshtime",self.gameObject,"")
    elseif _CurPage==TaskType.Jcp then
        UIUtil.ShowCanvasGroup(self.Active,false)
        CommonHelper:SetText("###refreshtime",self.gameObject,"")
    elseif _CurPage==TaskType.Xcp then
        UIUtil.ShowCanvasGroup(self.Active,false)
        CommonHelper:SetText("###refreshtime",self.gameObject,"")
    elseif _CurPage==TaskType.SuperBattle then
        UIUtil.ShowCanvasGroup(self.Active,false)
        CommonHelper:SetText("###refreshtime",self.gameObject,"")
    elseif _CurPage==TaskType.DailyRank then
        UIUtil.ShowCanvasGroup(self.Active,false)
        CommonHelper:SetText("###refreshtime",self.gameObject,ClientDataManager:Get():GetTemplateString(TemplateStringID.TaskTimeDaily))
    elseif _CurPage==TaskType.SpecialTraining then
        UIUtil.ShowCanvasGroup(self.Active,false)
        CommonHelper:SetText("###refreshtime",self.gameObject,ClientDataManager:Get():GetTemplateString(TemplateStringID.TaskTimeWeek))
    end
end
-- 三种状态的Item的颜色和底纹的颜色
-- 已完成已领取 bg alpha 0.2 custom=0.7
---[[
function TaskView:SetItemStatue(itemObj,taskStatus)
    CommonHelper:SetGameObjectActive("task_item_2",itemObj,taskStatus<=TaskStatus.IsRally)
    CommonHelper:SetGameObjectActive("task_item_1",itemObj,taskStatus==TaskStatus.IsDoneNoGet)
    CommonHelper:SetGameObjectActive("task_item_3",itemObj,taskStatus==TaskStatus.IsDoneAndGet)
end

function TaskView:SetScrollView()
    if _CurPage == TaskType.Week or _CurPage == TaskType.Daily then
        UIUtil.SetParentTransform(self.normal, self.ScrollView, true, true)
        UIUtil.SetParentTransform(self.buttomParentDaily, self.downItem, true, true)

        CommonHelper:SetGameObjectActive("zdownItem", self.gameObject, true)
        CommonHelper:SetGameObjectActive("zdownadItem", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownItem/tanHaoImage", self.gameObject, TaskDataManager:Get():CheckTaskDone())
        CommonHelper:SetGameObjectActive("zdownItem/getAllBtn", self.gameObject, TaskDataManager:Get():CheckTaskDone())
        CommonHelper:SetGameObjectActive("timebg", self.gameObject, true)
        CommonHelper:SetGameObjectActive("noviceview", self.gameObject, false)
        CommonHelper:SetGameObjectActive("LeftShow", self.gameObject, false)
        CommonHelper:SetGameObjectActive("toggleview", self.gameObject, false)
    elseif _CurPage == TaskType.GrowUp or _CurPage == TaskType.SeasonOrder then
        UIUtil.SetParentTransform(self.growup, self.ScrollView, true, true)

        CommonHelper:SetGameObjectActive("zdownItem", self.gameObject, false)
        CommonHelper:SetGameObjectActive("noviceview", self.gameObject, false)
        CommonHelper:SetGameObjectActive("LeftShow", self.gameObject, false)
        CommonHelper:SetGameObjectActive("toggleview", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownadItem", self.gameObject, false)
    elseif  _CurPage == TaskType.AD then
        UIUtil.SetParentTransform(self.adtaskview, self.ScrollView, true, true)
        CommonHelper:SetGameObjectActive("BuyBtn",self.gameObject,not TaskDataManager:Get().AdIsBuy)
        CommonHelper:SetText("BuyBtn/###price", self.gameObject, CommonHelper:GetChargeCfgByAreaAndItemId(2003).pricename)
        CommonHelper:SetGameObjectActive("zdownItem", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownadItem", self.gameObject, true)
        CommonHelper:SetGameObjectActive("noviceview", self.gameObject, false)
        CommonHelper:SetGameObjectActive("LeftShow", self.gameObject, false)
        CommonHelper:SetGameObjectActive("toggleview", self.gameObject, false)
    elseif _CurPage == TaskType.Novice then
        UIUtil.SetParentTransform(self.novice, self.ScrollView, true, true)
        UIUtil.SetParentTransform(self.buttomParentNotice, self.downItem, true, true)
        CommonHelper:SetGameObjectActive("zdownItem", self.gameObject, true)
        CommonHelper:SetGameObjectActive("zdownItem/tanHaoImage", self.gameObject, TaskDataManager:Get():CheckTaskDone())
        CommonHelper:SetGameObjectActive("zdownItem/getAllBtn", self.gameObject, TaskDataManager:Get():CheckTaskDone())
        CommonHelper:SetGameObjectActive("zdownItem/timebg", self.gameObject, false)
        CommonHelper:SetGameObjectActive("noviceview", self.gameObject, true)
        CommonHelper:SetGameObjectActive("LeftShow", self.gameObject, true)
        CommonHelper:SetGameObjectActive("toggleview", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownadItem", self.gameObject, false)
    elseif _CurPage == TaskType.SpecialTraining then
        UIUtil.SetParentTransform(self.toggleview, self.ScrollView, true, true)
        UIUtil.SetParentTransform(self.buttomParentDaily, self.downItem, true, true)
        CommonHelper:SetGameObjectActive("zdownItem", self.gameObject, true)
        CommonHelper:SetGameObjectActive("toggleview", self.gameObject, true)
        CommonHelper:SetGameObjectActive("noviceview", self.gameObject, false)
        CommonHelper:SetGameObjectActive("LeftShow", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownItem/timebg", self.gameObject, true)
        CommonHelper:SetGameObjectActive("zdownItem/getAllBtn", self.gameObject, TaskDataManager:Get():CheckTaskDone())
        CommonHelper:SetGameObjectActive("zdownItem/tanHaoImage", self.gameObject, TaskDataManager:Get():CheckTaskDone())
        CommonHelper:SetGameObjectActive("zdownadItem", self.gameObject, false)
    elseif _CurPage == TaskType.Recruit then
        UIUtil.SetParentTransform(self.toggleview, self.ScrollView, true, true)
        UIUtil.SetParentTransform(self.buttomParentDaily, self.downItem, true, true)
        CommonHelper:SetGameObjectActive("zdownItem", self.gameObject, true)
        CommonHelper:SetGameObjectActive("toggleview", self.gameObject, true)
        CommonHelper:SetGameObjectActive("noviceview", self.gameObject, false)
        CommonHelper:SetGameObjectActive("LeftShow", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownItem/timebg", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownItem/getAllBtn", self.gameObject, TaskDataManager:Get():CheckTaskDone())
        CommonHelper:SetGameObjectActive("zdownItem/tanHaoImage", self.gameObject, TaskDataManager:Get():CheckTaskDone())
        CommonHelper:SetGameObjectActive("zdownadItem", self.gameObject, false)
   elseif _CurPage == TaskType.RecruitCount then
        UIUtil.SetParentTransform(self.toggleview, self.ScrollView, true, true)
        UIUtil.SetParentTransform(self.buttomParentDaily, self.downItem, true, true)
        CommonHelper:SetGameObjectActive("zdownItem", self.gameObject, true)
        CommonHelper:SetGameObjectActive("toggleview", self.gameObject, true)
        CommonHelper:SetGameObjectActive("noviceview", self.gameObject, false)
        CommonHelper:SetGameObjectActive("LeftShow", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownItem/timebg", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownItem/getAllBtn", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownItem/tanHaoImage", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownadItem", self.gameObject, false)
  elseif _CurPage == TaskType.Jcp then
        UIUtil.SetParentTransform(self.toggleview, self.ScrollView, true, true)
        UIUtil.SetParentTransform(self.buttomParentDaily, self.downItem, true, true)
        CommonHelper:SetGameObjectActive("zdownItem", self.gameObject, true)
        CommonHelper:SetGameObjectActive("toggleview", self.gameObject, true)
        CommonHelper:SetGameObjectActive("noviceview", self.gameObject, false)
        CommonHelper:SetGameObjectActive("LeftShow", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownItem/timebg", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownItem/getAllBtn", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownItem/tanHaoImage", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownadItem", self.gameObject, false)
    elseif _CurPage == TaskType.Xcp then
        UIUtil.SetParentTransform(self.toggleview, self.ScrollView, true, true)
        UIUtil.SetParentTransform(self.buttomParentDaily, self.downItem, true, true)
        CommonHelper:SetGameObjectActive("zdownItem", self.gameObject, true)
        CommonHelper:SetGameObjectActive("toggleview", self.gameObject, true)
        CommonHelper:SetGameObjectActive("noviceview", self.gameObject, false)
        CommonHelper:SetGameObjectActive("LeftShow", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownItem/timebg", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownItem/getAllBtn", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownItem/tanHaoImage", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownadItem", self.gameObject, false)
  elseif _CurPage == TaskType.SuperBattle then
        UIUtil.SetParentTransform(self.toggleview, self.ScrollView, true, true)
        UIUtil.SetParentTransform(self.buttomParentDaily, self.downItem, true, true)
        CommonHelper:SetGameObjectActive("zdownItem", self.gameObject, true)
        CommonHelper:SetGameObjectActive("toggleview", self.gameObject, true)
        CommonHelper:SetGameObjectActive("noviceview", self.gameObject, false)
        CommonHelper:SetGameObjectActive("LeftShow", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownItem/timebg", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownItem/getAllBtn", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownItem/tanHaoImage", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownadItem", self.gameObject, false)
    elseif _CurPage == TaskType.DailyRank or _CurPage == TaskType.Rank then
        UIUtil.SetParentTransform(self.toggleview, self.ScrollView, true, true)
        UIUtil.SetParentTransform(self.buttomParentDaily, self.downItem, true, true)
        CommonHelper:SetGameObjectActive("zdownItem", self.gameObject, _CurPage == TaskType.DailyRank)
        CommonHelper:SetGameObjectActive("toggleview", self.gameObject, true)
        CommonHelper:SetGameObjectActive("zdownItem/timebg", self.gameObject, _CurPage == TaskType.DailyRank)
        CommonHelper:SetGameObjectActive("noviceview", self.gameObject, false)
        CommonHelper:SetGameObjectActive("LeftShow", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownItem/getAllBtn", self.gameObject, TaskDataManager:Get():CheckTaskDone())
        CommonHelper:SetGameObjectActive("zdownItem/tanHaoImage", self.gameObject, TaskDataManager:Get():CheckTaskDone())
        CommonHelper:SetGameObjectActive("zdownadItem", self.gameObject, false)
    else
        UIUtil.SetParentTransform(self.growup, self.ScrollView, true, true)
        UIUtil.SetParentTransform(self.buttomParentDaily, self.downItem, true, true)
        CommonHelper:SetGameObjectActive("zdownItem", self.gameObject, false)
        CommonHelper:SetGameObjectActive("noviceview", self.gameObject, false)
        CommonHelper:SetGameObjectActive("LeftShow", self.gameObject, false)
        CommonHelper:SetGameObjectActive("zdownItem/getAllBtn", self.gameObject, TaskDataManager:Get():CheckTaskDone())
        CommonHelper:SetGameObjectActive("zdownItem/tanHaoImage", self.gameObject, TaskDataManager:Get():CheckTaskDone())
        CommonHelper:SetGameObjectActive("zdownadItem", self.gameObject, false)
    end
    CommonHelper:InitMoreRowScrollView(self.ScrollView,#_CurData,1,function(dataIndex,itemObj,scroll)
        ---@type TaskData
        local taskData=_CurData[dataIndex+1]
        self:SetItemStatue(itemObj,taskData.status)

        local progress=""
        --  if taskData.status==TaskStatus.IsRally or taskData.status==TaskStatus.IsDoneNoGet then
        -- local progress=string.format("(<color=#D6AF11>%d</color>/%d)",taskData.finshNum,taskData.progress)
        progress=string.format(ClientDataManager:Get():GetTemplateString(TemplateStringID.TaskItemProgress),taskData.finshNum,taskData.progress)
        local value=taskData.finshNum/taskData.progress
        --if taskData.status~=TaskStatus.IsDoneAndGet then
        --
        --end
        CommonHelper:SetSlider("taskprogress",itemObj,value)
        -- end
        CommonHelper:SetText("###taskdesc", itemObj, taskData.description)
        CommonHelper:SetText("###taskname", itemObj, ClientDataManager:Get():GetTemplateString(taskData.taskname))
        if taskData.CompleteType== TaskCompleteType.Time then
            local time=CommonHelper:GetSelfTransferTimeStr(taskData.progress)
            local second=string.format("%s'%s'%s",time.minute,time.second,time.milliSecond)
            CommonHelper:SetText("###taskprogresscount", itemObj, second)
        else
            CommonHelper:SetText("###taskprogresscount", itemObj, progress)
        end

        for i = 1, 3 do
            local tempObj = UIUtil.GetChild("reward" .. i, itemObj)
            if taskData.rewards[i] then
                local param = Param_ItemArticleParam()
                param.count = tonumber(taskData.rewards[i].num)
                CommonHelper:SetItemComGroup(tempObj, UIModuleID.Task, taskData.rewards[i].id, param,function(id)
                    CommonHelper:ShowPartInfoByCfgId(id, UIModuleID.Task)
                end,taskData.rewards[i].id)
            end
            CommonHelper:CSGameObjectSetActive(tempObj, taskData.rewards[i] ~= nil)
        end

        local btnTask=CommonHelper:HButtonSetCallback("btntaskitem",itemObj,function(tempData)
            if _CurData[tempData.intData+1].status==TaskStatus.IsDoneNoGet then
                if _CurData[tempData.intData+1].questType==TaskType.RecruitCount then
                    RecruitSubsystem:Get():SendMsg_GetRecruitCountReward(TaskDataManager:Get():GetRecruitID(),_CurData[tempData.intData+1].taskId)
                elseif _CurData[tempData.intData+1].questType==TaskType.SuperBattle then
                    RaceSuperBattleSubsystem:Get():SendMsg_RaceAward(_CurData[tempData.intData+1].taskId)
                else
                    TaskSubsystem:Get():SendMsg_GetReward(_CurData[tempData.intData+1].questType,_CurData[tempData.intData+1].taskId,0)
                end
            end
            if _CurData[tempData.intData+1].status==TaskStatus.IsRally then
                if _CurData[tempData.intData+1].questType==TaskType.AD then
                    AdRewardSubsystem:Get():SendMsg_StartAdReward( _CurData[tempData.intData+1].taskId)
                else
                    FunctionSkipManager:Get():SkipToFunction(_CurData[tempData.intData+1].SkipParam[1],_CurData[tempData.intData+1].SkipParam[2])
                end

            end
        end,dataIndex)
        CommonHelper:SetHButtonClick(btnTask,true,true)
        local daily=self:GetChildByParent("daily",itemObj)
        local growup=self:GetChildByParent("growup",itemObj)
        if _CurPage == TaskType.Daily or _CurPage == TaskType.Week then
            CommonHelper:SetGameObjectActive("###activevalueisdone",itemObj,true)
            CommonHelper:SetGameObjectActive("###activevaluenormal",itemObj,true)
            CommonHelper:SetText("###activevalueisdone", itemObj, "+"..taskData.active)
            CommonHelper:SetText("###activevaluenormal", itemObj, "+"..taskData.active)
            CommonHelper:SetGameObjectActive("###taskprogresscount", itemObj, true)
            CommonHelper:SetGameObjectActive("taskprogress", itemObj, true)
            CommonHelper:SetGameObjectActive("activebg1",itemObj,true)
            CommonHelper:SetGameObjectActive("activebg2",itemObj,true)
            UIUtil.SetParentTransform(daily,btnTask,true)
            CommonHelper:SetGameObjectActive("###activevalueisdone",itemObj,taskData.status==TaskStatus.IsDoneNoGet)
            CommonHelper:SetGameObjectActive("###activevaluenormal",itemObj,true)
            CommonHelper:SetHButtonClick(btnTask,taskData.status==TaskStatus.IsDoneNoGet or taskData.status == TaskStatus.IsRally,taskData.status==TaskStatus.IsDoneAndGet)
        elseif _CurPage == TaskType.Novice then
            CommonHelper:SetGameObjectActive("###activevalueisdone", itemObj, false)
            CommonHelper:SetGameObjectActive("###activevaluenormal", itemObj, false)
            CommonHelper:SetGameObjectActive("###taskprogresscount", itemObj, false)
            CommonHelper:SetGameObjectActive("taskprogress", itemObj, false)
            CommonHelper:SetGameObjectActive("activebg1", itemObj, true)
            CommonHelper:SetGameObjectActive("activebg2", itemObj, true)
            CommonHelper:SetText("###taskname", itemObj, string.format("%s %s",ClientDataManager:Get():GetTemplateString(taskData.taskname),progress))
            UIUtil.SetParentTransform(daily, btnTask, true)
            CommonHelper:SetHButtonClick(btnTask, taskData.status == TaskStatus.IsDoneNoGet or taskData.status == TaskStatus.IsRally, taskData.status == TaskStatus.IsDoneAndGet)

        else
            CommonHelper:SetGameObjectActive("###activevalueisdone",itemObj,false)
            CommonHelper:SetGameObjectActive("###activevaluenormal",itemObj,false)
            CommonHelper:SetGameObjectActive("###taskprogresscount", itemObj, true)
            CommonHelper:SetGameObjectActive("taskprogress", itemObj, true)
            CommonHelper:SetGameObjectActive("activebg1",itemObj,false)
            CommonHelper:SetGameObjectActive("activebg2",itemObj,false)
            UIUtil.SetParentTransform(growup,btnTask,true)
            if taskData.status==TaskStatus.IsDoneNoGet or taskData.status==TaskStatus.IsRally then
                CommonHelper:SetHButtonClick(btnTask,taskData.status==TaskStatus.IsDoneNoGet or taskData.status == TaskStatus.IsRally ,false)
            else
                CommonHelper:SetHButtonClick(btnTask,false,true)
            end

        end
        local groupValue=taskData.status==TaskStatus.IsDoneAndGet and 0.58 or 1
        UIUtil.SetCanvasGroupAlpha("rewardgroup",itemObj,groupValue,true)
        CommonHelper:SetToggleState(btnTask,taskData.status==TaskStatus.IsDoneNoGet)
        local  btnBg=UIUtil.GetTypeChildWightByParent("Bg_2",btnTask.gameObject,typeof(Image))
        CommonHelper:ImageSetGray(btnBg,taskData.status~=TaskStatus.IsDoneNoGet)
        CommonHelper:SetGameObjectActive("TextDone", itemObj, taskData.status==TaskStatus.IsDoneNoGet)
        CommonHelper:SetGameObjectActive("Bg_2", itemObj, taskData.status==TaskStatus.IsDoneNoGet)
        CommonHelper:SetGameObjectActive("Bg_3", itemObj,  taskData.status==TaskStatus.IsRally)
        CommonHelper:SetGameObjectActive("TextAdRally", itemObj,false)
        CommonHelper:SetGameObjectActive("TextRally", itemObj, taskData.questType~=TaskType.AD and taskData.status==TaskStatus.IsRally)
        if taskData.questType==TaskType.AD and taskData.status==TaskStatus.IsRally then
            if TaskDataManager:Get().AdIsBuy then
                CommonHelper:SetGameObjectActive("TextAdRally", itemObj,false)
                CommonHelper:SetGameObjectActive("Bg_3", itemObj,  false)
                CommonHelper:SetGameObjectActive("Bg_2", itemObj, true)
                CommonHelper:ImageSetGray(btnBg,false)
                CommonHelper:SetGameObjectActive("TextDone", itemObj, true)
            else
                CommonHelper:SetGameObjectActive("TextAdRally", itemObj,true)
            end
        end

    end)
end


local CurActiveState=nil
---@param boxstate table<number,ActiveData>
function TaskView:SetBoxState(boxstate)
    if boxstate==nil then
        return
    end
    CurActiveState=boxstate
    local BoxSlider = {}
    for i = 1, #boxstate do
        local num=math.modf((boxstate[i].activeNum/boxstate[#boxstate].activeNum)*100)
        table.insert( BoxSlider,num*0.01)
    end

    self.BoxSlider = CommonHelper:SetBoxStateSlider("BoxSlider", self.gameObject, BoxSlider, function(item, index, BoxSlider)
        CommonHelper:SetBoxState("BoxState", item, boxstate[index + 1].state)
        CommonHelper:SetText("###value", item, boxstate[index + 1].activeNum)
        CommonHelper:HButtonSetCallback("BoxBtn", item, function(hbtn)
            self:ClickBoxBtn(index + 1)
        end, index)

        CommonHelper:SetText("###fullText", item, boxstate[index + 1].activeNum)
        CommonHelper:SetGameObjectActive("full", item, boxstate[index + 1].state>0)
        CommonHelper:SetGameObjectActive("Hemisphere_2", item, boxstate[index + 1].activeNum ~= boxstate[#boxstate].activeNum)
        CommonHelper:SetGameObjectActive("rightHemisphere", item, boxstate[index + 1].activeNum == boxstate[#boxstate].activeNum)
    end)

end

function TaskView:SetSliderStateGroup(num)
    CommonHelper:SetSlider("SliderBaseColor",self.ActiveObj,num/100)
    for i=1, #self.SliderStateGroup do
        CommonHelper:SetGameObjectActive("state1",self.SliderStateGroup[i],num>=20*(i-1))
        CommonHelper:SetGameObjectActive("state2",self.SliderStateGroup[i],num<20*(i-1))
    end
end


function TaskView:ClickBoxBtn(i)
    if CurActiveState[i].state==1 then
        TaskSubsystem:Get():SendMsg_GetActiveReward( CurActiveState[i].activeType,CurActiveState[i].activeNum)
    elseif CurActiveState[i].state==0 then
        CommonHelper:ShowRewardPopup(CurActiveState[i].activeReward,ClientDataManager:Get():GetTemplateString(TemplateStringID.RewardPreview))
    else
        CommonHelper:ShowRewardPopup(CurActiveState[i].activeReward,ClientDataManager:Get():GetTemplateString(TemplateStringID.RewardGeted))
    end
end

function TaskView:SetBoxPosition()
    local width=UIUtil.GetUIWidth(self.box)/5
    for i = 0, 5 do
        UIUtil:GameobjectLocalPositionX(self.PointGroup[i],i*width)
    end
end

function TaskView:RefreshNoviceView()
    local openType=TaskDataManager:Get():GetOpenModuleType()
    ---@type RecruitData
    local recruitData=nil
    if openType==UIModuleID.Recruit then
        local recruitid=TaskDataManager:Get():GetRecruitID()
        recruitData=RecruitDataManager:Get():GetDataById(recruitid)
    end
    CommonHelper:SetHButtonClick(self.TogNovice,TaskDataManager:Get():GetNoviceFlag() and openType==UIModuleID.MainMenu,true)
    CommonHelper:SetHButtonClick(self.TogDaily,openType==UIModuleID.MainMenu,true)
    CommonHelper:SetHButtonClick(self.TogGrowUp,openType==UIModuleID.MainMenu,true)
    CommonHelper:SetHButtonClick(self.Toggle_Ad,openType==UIModuleID.MainMenu and HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.BtnAdReward),true)
    CommonHelper:SetHButtonClick(self.Toggle_SpecialTrain,openType==UIModuleID.SpecialTraining ,true)
    CommonHelper:SetHButtonClick(self.Toggle_RecruitShell,openType==UIModuleID.Recruit and recruitData and recruitData:GetTaskShellTask() ,true)
    CommonHelper:SetHButtonClick(self.Toggle_RecruitCount,openType==UIModuleID.Recruit and recruitData and recruitData:GetTaskCountTask(),true)
    CommonHelper:SetHButtonClick(self.Toggle_S_CP,openType==UIModuleID.RaceJCP,true)
    CommonHelper:SetHButtonClick(self.Toggle_X_CP,openType==UIModuleID.RaceXCP,true)
    CommonHelper:SetHButtonClick(self.Toggle_SuperBattle,openType==UIModuleID.RaceSuperBattle,true)
    CommonHelper:SetHButtonClick(self.Toggle_Page_Race1,false,true)
    CommonHelper:SetHButtonClick(self.Toggle_Page_Race2,false,true)
    CommonHelper:SetHButtonClick(self.Toggle_Rank,openType==UIModuleID.RaceRank  ,true)
    CommonHelper:SetHButtonClick(self.Toggle_Page_RankDaily,(openType==UIModuleID.RaceRank ) and (_CurPage == TaskType.Rank or _CurPage == TaskType.DailyRank),true)
    CommonHelper:SetHButtonClick(self.Toggle_Page_Rank,(openType==UIModuleID.RaceRank ) and (_CurPage == TaskType.Rank or _CurPage == TaskType.DailyRank),true)
    --CommonHelper:SetHButtonClick(self.Toggle_Page_Rank,(openType==UIModuleID.RaceRank ) and false,true)
    if _CurPage ~= TaskType.Novice then return end
    self:ScheduleShowData()
end

function TaskView:ScheduleShowData()
    local currentData = TaskDataManager:Get():GetNoticeData(nowScheduleNum)
    if currentData==nil then return end
    for i = 1, 3 do
        local tempObj = UIUtil.GetChild("noviceReward" .. i, self.gameObject)
        if currentData.cfg.awardids[i] then
            local param = Param_ItemArticleParam()
            param.count = tonumber(currentData.cfg.awardnums[i])
            CommonHelper:SetItemComGroup(tempObj, UIModuleID.Task, currentData.cfg.awardids[i], param)
        end
        CommonHelper:CSGameObjectSetActive(tempObj, currentData.cfg.awardnums[i] ~= nil)
    end


    local curval = currentData.curVal
    local sumval = currentData.sumVal

    local TaskSlider = UIUtil.GetTypeChildWightByParent("TaskSlider", self.gameObject, typeof(CircleSlider))
    TaskSlider:SetValue(curval / sumval)

   CommonHelper:SetHButtonClick(self.getTradeAllBtn,currentData.ifGift==ScheduleState.IsDoneNoGet ,false)
    local  btnBg=UIUtil.GetTypeChildWightByParent("Bg_2",self.getTradeAllBtn.gameObject,typeof(Image))
    CommonHelper:ImageSetGray(btnBg,currentData.ifGift~=ScheduleState.IsDoneNoGet)
    CommonHelper:SetGameObjectActive("TextDone", self.getTradeAllBtn.gameObject, currentData.ifGift==ScheduleState.IsDoneNoGet)
    CommonHelper:SetGameObjectActive("TextRally", self.getTradeAllBtn.gameObject, currentData.ifGift==ScheduleState.IsRally)
    CommonHelper:SetGameObjectActive("TextGeted", self.getTradeAllBtn.gameObject, currentData.ifGift==ScheduleState.IsDoneAndGet)
    CommonHelper:SetGameObjectActive("TextNoActive", self.getTradeAllBtn.gameObject, currentData.ifGift==ScheduleState.None)
    CommonHelper:SetText("###schedule", self.gameObject, curval .. " / " .. sumval)
    CommonHelper:SetText("###titleText", self.gameObject, CommonHelper:GetTempStr_Default(currentData.cfg.trademissionname))

end

function TaskView:OnOpen()
    _LastPage=-1
    if _CurSubPage==-1 then
        _CurSubPage=TaskSubType.SpecialTraining_Race1
    end
    if TaskDataManager:Get():GetOpenModuleType()==UIModuleID.MainMenu then
        UINotify:Get():SendNotification(UINotifyEvent.TaskViewSetData, TaskType.Daily)
    end
    self:CheckNewBieGuide()
    -- self:SetBoxPosition()
end
function TaskView:ReOpen()
    TaskSubsystem:Get():SendMsg_GetTaskList(_CurPage,TaskDataManager:Get():GetOpenModuleType(),TaskDataManager:Get():GetRecruitID())
end

function TaskView:OnClose()
    _CurPage=-1
    _CurSubPage=-1

    CommonHelper:ReleasePool(UIModuleID.Task)
end
function TaskView:OnOpenAnimEnd()
    self:CheckNewBieGuide()
end




