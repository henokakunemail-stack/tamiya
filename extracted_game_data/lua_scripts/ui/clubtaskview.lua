---@class ClubTaskView : ViewBase
ClubTaskView = class("ClubTaskView", ViewBase)
function ClubTaskView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ClubTaskViewAction")
end
function ClubTaskView:Awake()

    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(data)
        self:HideCloseTask()
    end)
    local Center = self:GetChild("Center")
    self.growup=self:GetChildByParent("growupview",Center)
    self.normal = self:GetChildByParent("normalview", Center)
    self.box = self:GetChildWightByParent("box", Center, typeof(RectTransform))
    self.ScrollView = self:GetChildWightByParent("ScrollView", Center, typeof(MoreRowScrollView))
    self.Active = self:GetChildWightByParent("activearea", Center, typeof(CanvasGroup))
    self.ActiveObj = self:GetChildByParent("activearea", Center)
    self.PointGroup = {}
    --for i = 0, 5 do
    --    local temp = UIUtil.GetChild("BoxState" .. i, self.ActiveObj)
    --    self.PointGroup[i] = temp
    --end
    self.SliderStateGroup = {}
    for i = 1, 6 do
        local temp = UIUtil.GetChild("SliderState" .. i, self.ActiveObj)
        table.insert(self.SliderStateGroup, temp)
    end
end
local _CurData = nil

function ClubTaskView:SendMsg(page)
    TaskSubsystem:Get():SendMsg_GetTaskList(page)
end

function ClubTaskView:TaskViewSetData(page)
    _CurData = TaskDataManager:Get():GetTaskList()
    self:SetActive()
    self:SetScrollView()
    CommonHelper:MoreRowView_EnterAniTask(self.ScrollView, 0)
end

function ClubTaskView:RefreshCurView()
    _CurData = TaskDataManager:Get():GetTaskList()
    self:SetActive()
    self:SetScrollView()
end

function ClubTaskView:SetActive()
    CommonHelper:SetGameObjectActive("task_bg_2", self.gameObject, true)
    UIUtil.ShowCanvasGroup(self.Active,false)
    CommonHelper:SetText("###refreshtime",self.gameObject,"")

end

function ClubTaskView:SetItemStatue(itemObj, taskStatus)
    CommonHelper:SetGameObjectActive("task_item_2", itemObj, taskStatus <= TaskStatus.IsRally)
    CommonHelper:SetGameObjectActive("task_item_1", itemObj, taskStatus == TaskStatus.IsDoneNoGet)
    CommonHelper:SetGameObjectActive("task_item_3", itemObj, taskStatus == TaskStatus.IsDoneAndGet)
end

function ClubTaskView:SetScrollView()
    UIUtil.SetParentTransform(self.growup,self.ScrollView,true,true)

    CommonHelper:InitMoreRowScrollView(self.ScrollView, #_CurData, 1, function(dataIndex, itemObj, scroll)
        ---@type TaskData
        local taskData = _CurData[dataIndex + 1]
        self:SetItemStatue(itemObj, taskData.status)
        local progress = ""
        progress = string.format(ClientDataManager:Get():GetTemplateString(TemplateStringID.TaskItemProgress), taskData.finshNum, taskData.progress)
        local value = 0
        if taskData.status ~= TaskStatus.IsDoneAndGet then
            value = taskData.finshNum / taskData.progress
        end
        CommonHelper:SetSlider("taskprogress", itemObj, value)
        CommonHelper:SetText("###taskdesc", itemObj, taskData.description)
        CommonHelper:SetText("###taskprogresscount", itemObj, progress)
        for i = 1, 3 do
            local tempObj = UIUtil.GetChild("reward" .. i, itemObj)
            if taskData.rewards[i] then
                CommonHelper:SetPropGroupByRewardData(tempObj, taskData.rewards[i], UIModuleID.Announcement)
            end
            CommonHelper:CSGameObjectSetActive(tempObj, taskData.rewards[i] ~= nil)
        end
        ---领取按钮
        local btnTask = CommonHelper:HButtonSetCallback("btntaskitem", itemObj, function(tempData)
            if _CurData[tempData.intData + 1].status == TaskStatus.IsDoneNoGet then
                TaskSubsystem:Get():SendMsg_GetReward(_CurData[tempData.intData + 1].questType, _CurData[tempData.intData + 1].taskId, 0)
            end
            if _CurData[tempData.intData + 1].status == TaskStatus.IsRally then
                if _CurData[tempData.intData+1].SkipParam[1]==GameFunction.Club then
                    self:HideCloseTask()
                else
                    UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_OnBtnClick,{function()
                        FunctionSkipManager:Get():SkipToFunction(_CurData[tempData.intData+1].SkipParam[1],_CurData[tempData.intData+1].SkipParam[2])
                    end,self})
                end

            end
        end, dataIndex)


        CommonHelper:SetHButtonClick(btnTask, true, true)



        local daily = self:GetChildByParent("daily", itemObj)
        local growup=self:GetChildByParent("growup",itemObj)

        CommonHelper:SetGameObjectActive("###activevalueisdone",itemObj,false)
        CommonHelper:SetGameObjectActive("###activevaluenormal",itemObj,false)
        CommonHelper:SetGameObjectActive("activebg1",itemObj,false)
        CommonHelper:SetGameObjectActive("activebg2",itemObj,false)
        UIUtil.SetParentTransform(growup,btnTask,true)
        CommonHelper:SetHButtonClick(btnTask,taskData.status==TaskStatus.IsDoneNoGet or taskData.status==TaskStatus.IsRally,false)
        CommonHelper:SetGameObjectActive("btntaskitem",itemObj,taskData.status~=TaskStatus.IsDoneAndGet)

        if taskData.status==TaskStatus.IsRally and  taskData.SkipParam[1]==0 then
            CommonHelper:SetHButtonClick(btnTask, false, true)
        end
        local groupValue = taskData.status == TaskStatus.IsDoneAndGet and 0.58 or 1
        UIUtil.SetCanvasGroupAlpha("rewardgroup",itemObj,groupValue,true)
        CommonHelper:SetToggleState(btnTask, taskData.status == TaskStatus.IsDoneNoGet)
        local btnBg = UIUtil.GetTypeChildWightByParent("Bg (2)", btnTask.gameObject, typeof(Image))
        CommonHelper:ImageSetGray(btnBg, taskData.status ~= TaskStatus.IsDoneNoGet)
    end)
end

local CurActiveState = nil
---@param boxstate table<number,ActiveData>
function ClubTaskView:SetBoxState(boxstate)
    CurActiveState = boxstate
    local BoxSlider = {}
    for i = 1, #boxstate do
        local num = math.modf((boxstate[i].activeNum / boxstate[#boxstate].activeNum) * 100)
        table.insert(BoxSlider, num * 0.01)
    end
    CommonHelper:SetBoxStateSlider("BoxSlider", self.gameObject, BoxSlider, function(item, index, BoxSlider)
        CommonHelper:SetBoxState("BoxState", item, boxstate[index + 1].state)
        CommonHelper:SetText("###value", item, boxstate[index + 1].activeNum)
        CommonHelper:HButtonSetCallback("BoxBtn", item, function(hbtn)
            self:ClickBoxBtn(index + 1)
        end, index)
    end)
end

function ClubTaskView:SetSliderStateGroup(num)
    CommonHelper:SetSlider("SliderBaseColor", self.ActiveObj, num / 100)
    for i = 1, #self.SliderStateGroup do
        CommonHelper:SetGameObjectActive("state1", self.SliderStateGroup[i], num >= 20 * (i - 1))
        CommonHelper:SetGameObjectActive("state2", self.SliderStateGroup[i], num < 20 * (i - 1))
    end
end

function ClubTaskView:ClickBoxBtn(i)
    if CurActiveState[i].state == 1 then
        TaskSubsystem:Get():SendMsg_GetActiveReward(CurActiveState[i].activeType, CurActiveState[i].activeNum)
    elseif CurActiveState[i].state == 0 then
        CommonHelper:ShowRewardPopup(CurActiveState[i].activeReward, ClientDataManager:Get():GetTemplateString(TemplateStringID.RewardPreview))
    else
        CommonHelper:ShowRewardPopup(CurActiveState[i].activeReward, ClientDataManager:Get():GetTemplateString(TemplateStringID.RewardGeted))
    end
end

function ClubTaskView:SetBoxPosition()
    local width = UIUtil.GetUIWidth(self.box) / 5
    for i = 0, 5 do
        UIUtil:GameobjectLocalPositionX(self.PointGroup[i], i * width)
    end
end

function ClubTaskView:HideCloseTask()
    UIManager:Get():HidePersistentView("ClubTaskView")
    UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_SetLuaViewInfo,{"ClubTaskView",false})
    UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_UpdateSlider)
    local curSelectClubId = ClubDataManager:Get():GetCurSelectClubId()
    ClubSubsystem:Get():SendMsg_GuildInfo(ClubInfoType.Self, curSelectClubId)
end
function ClubTaskView:OnOpen()
    self:SendMsg(TaskType.Club)
end

function ClubTaskView:OnClose()

end


