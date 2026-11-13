---@class TaskDataManager
TaskDataManager = class("TaskDataManager")
function TaskDataManager:Get()
    if self._instance == nil then
        self._instance = TaskDataManager()
    end
    return self._instance
end
function TaskDataManager:initialize()
    self.dailyActiveNum = 0
    self.weeklyActiveNum = 0
    ---@type dicttrademission_config_cell[]
    self.TradeMissionCfg = ClientDataManager:Get():GetDataTable(ConfigNames.tradetask_config).GetConfigData()
    ---@type table<number,ActiveData>
    CacheClearTrigger:Get():RegisterEvent(self, self.ClearData)
end

-- finshNum==1 未完成 finshNum==2 已完成未领取  fishNum==3 已完成已领取
---@param msg SC_TaskList
function TaskDataManager:OnInit(msg,type)
    ---@type SC_UserTask[]
    self.msgList=msg.curTasks
    self.dailyActiveNum = msg.daytaskval
    if type==TaskType.Novice then
        self:ParseNoviceTaskList(msg.curTradeSeq)
    else
        self:ParseData()
    end
    self.tradeMission = msg.curTradeMission
    self:ParseNoviceData()
    self:InitActive(msg.activeGifts)
    self.CurTradeSeq = msg.curTradeSeq


    --self:UpdateMsgList(msg.list)
    --self:ParseData()
    --UINotify:Get():SendNotification(UINotifyEvent.RefreshCurView)
end
---@param msg SC_UserRecruitCounts
function TaskDataManager:OnInitRecruit(msg,type)
    ---@type TaskData[]
    self.TaskList={}
    for i = 1, #msg.awardCount do
        local data = TaskData()
        data:SetData_Recruit(i-1,msg.awardCount[i],msg.curNum,msg.awardFlag[i],msg.awardList[i],type)
        table.insert(self.TaskList,data)
    end
    self.TaskList= self:TaskSortTaskByState(self.TaskList)
end
---@param msg SC_UserAdList
function TaskDataManager:OnInitAd(msg,type)
    self.AdIsBuy=false
    ---@type TaskData[]
    self.TaskList={}
    for i = 1, #msg.myAdInfo do
        local data = TaskData()
        if self.AdIsBuy==false then
            self.AdIsBuy=msg.myAdInfo[i].expTime==-1
        end
        data:SetData_Ad(msg.myAdInfo[i].adId,msg.myAdInfo[i].viewNum,type)
        table.insert(self.TaskList,data)
    end
    self.TaskList= self:TaskSortTaskByState(self.TaskList)
end
---@param msg SC_UserRecruitCounts
function TaskDataManager:OnInitSuperBattle(curNum,awards,type)
    ---@type TaskData[]
    self.TaskList={}
    local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.active_config)
    ---@type dictactive_config_cell[]
    local cfgList=cfg.GetConfigDataByType(TaskActiveType.SuperBattle)
    for i, v in pairs(cfgList) do
        local temp=v
        local data = TaskData()
        local state=TaskStatus.IsRally
        if curNum>=temp.activeval then
            state=TaskStatus.IsDoneNoGet
        end
        for j = 1, #awards do
            if temp.activeval==awards[j] then
                state=TaskStatus.IsDoneAndGet
                break
            end
        end
        data:SetData_SuperBattle(temp.activeval,temp.activeval,curNum,state,temp.awardids,temp.awardnums,type)
        table.insert(self.TaskList,data)
    end
    self.TaskList= self:TaskSortTaskByState(self.TaskList)
end


---@type SC_UserTask
function TaskDataManager:InitNoviceTask(myTradeTask)
    ---@type TaskData[]
    self.MainTaskList={}
    for i = 1, #myTradeTask do
        local data = TaskData()
        data:SetData_Task(myTradeTask[i])
        table.insert(self.MainTaskList,data)
    end
    self.MainTaskList= self:TaskSortTaskByState(self.MainTaskList)
    self:SaveNoviceMainTaskId(self.MainTaskList[1])
end

function TaskDataManager:ParseData()
    ---@type TaskData[]
    self.TaskList={}
    for i = 1, #self.msgList do
        local data = TaskData()
        data:SetData_Task(self.msgList[i])
        table.insert(self.TaskList,data)
    end
    self.TaskList= self:TaskSortTaskByState(self.TaskList)
end

function TaskDataManager:ParseNoviceTaskList(curTradeSeq)
    ---@type TaskData[][]
    self.NoviceTaskList={}
    for i = 1, #self.msgList do
        local data = TaskData()
        data:SetData_Task(self.msgList[i])
        if self.NoviceTaskList[data.subType]==nil then
            self.NoviceTaskList[data.subType]={}
        end
        table.insert(self.NoviceTaskList[data.subType],data)
    end
    for k, v in pairs(self.NoviceTaskList) do
        self.NoviceTaskList[k]= self:TaskSortTaskByState(v)
    end
    self.TaskList= self.NoviceTaskList[curTradeSeq]
    if self.TaskList and self.TaskList[1] and(self.TaskList[1].status==TaskStatus.IsRally or self.TaskList[1].status==TaskStatus.IsDoneNoGet) then
        self:SaveNoviceMainTaskId(self.TaskList[1])
    else
        if self.NoviceTaskList[curTradeSeq+1] then
            self:SaveNoviceMainTaskId(self.NoviceTaskList[curTradeSeq+1][1])
        else
            self:SaveNoviceMainTaskId()
        end
    end
end



-- 根据任务完成的状态进行排序
function TaskDataManager:TaskSortTaskByState(list)
    local tempDic = {}
    if list == nil then
        return
    end
    for i = 1, #list do
        if tempDic[list[i].status] == nil then
            tempDic[list[i].status] = {}
        end
        table.insert(tempDic[list[i].status], list[i])
    end
    if tempDic[TaskStatus.IsRally] ~= nil and #tempDic[TaskStatus.IsRally] > 0 then
            table.sort(tempDic[TaskStatus.IsRally], function(a, b)
                if a.finshNum / a.progress > b.finshNum / b.progress then return true end
                if a.finshNum / a.progress < b.finshNum / b.progress then return false end
                return a.taskId < b.taskId
            end)
    end



    if tempDic[TaskStatus.IsDoneNoGet] ~= nil then
        local temp = tempDic[TaskStatus.IsRally]
        tempDic[TaskStatus.IsRally] = tempDic[TaskStatus.IsDoneNoGet]
        tempDic[TaskStatus.IsDoneNoGet] = temp
    end
    local result = {}
    for k, v in pairs(tempDic) do
        for j = 1, #v do
            table.insert(result, v[j])
        end
    end
    return result
end

function  TaskDataManager:GetTaskList(type,page)
    if type==TaskType.Novice then
        if page==nil then page=self.CurTradeSeq end
        self.CurShowTrade=page
        self.TaskList=self.NoviceTaskList[page]
    end
    return self.TaskList
end

---@param msg SC_TaskActiveGift[]
function TaskDataManager:InitActive(msg)
    --self.dailyActiveNum = 0
    self.dailyActiveState = {}
    for i = 1, #msg do
        if msg[i].activetype==1 then
            local temp = ActiveData()
            temp:SetData(msg[i])
            --if temp.state>=1 then
            --    self.dailyActiveNum=self.dailyActiveNum+temp.activeNum
            --end
            table.insert(self.dailyActiveState, temp)
        end
    end
end

function TaskDataManager:UpdateTask(missionIds,day7taskval,daytaskval)
    self.dailyActiveNum = daytaskval
    local result =false
    if self.dailyActiveState then
        for i = 1, #self.dailyActiveState do
            if self.dailyActiveNum>= self.dailyActiveState[i].activeNum and self.dailyActiveState[i].state==0 then
                self.dailyActiveState[i].state=1
            end
        end
    end
    if self.TaskList then
        for i = 1, #missionIds do
            for j = 1, #self.TaskList do
                if missionIds[i]==self.TaskList[j].taskId then
                    result=true
                    QuickTaHelper:Get():TrackTaskEvent(self.TaskList[j],self.TaskList[j].questType == 1 and 1 or 0,self.dailyActiveNum)
                    break
                end
            end
        end
    end
    return result
end
function TaskDataManager:UpdateTaskById(missionId)
    if self.TaskList then
        for j = 1, #self.TaskList do
            if missionId==self.TaskList[j].taskId then
                self.TaskList[j].status=TaskStatus.IsDoneAndGet
                break
            end
        end
        self.TaskList= self:TaskSortTaskByState(self.TaskList)
    end
end
---@param missions table<number,SC_MyAd>
function TaskDataManager:UpdateAdTaskById(missions)
    if self.TaskList then
        for k, v in pairs(missions) do
            for j = 1, #self.TaskList do
                if v.adId==self.TaskList[j].taskId then
                    self.TaskList[j]:SetData_Ad(v.adId,v.viewNum,TaskType.AD)
                end
            end
        end
        self.TaskList= self:TaskSortTaskByState(self.TaskList)
    end
end
function TaskDataManager:UpdateTaskByIds(missionIds)
    if self.TaskList then
        for i = 1, #missionIds do
            for j = 1, #self.TaskList do
                if missionIds[i]==self.TaskList[j].taskId then
                    self.TaskList[j].status=TaskStatus.IsDoneAndGet
                    break
                end
            end
        end
        self.TaskList= self:TaskSortTaskByState(self.TaskList)
    end
end

---@param msg SC_UserTask[]
function TaskDataManager:UpdateTaskList(msg,del,curTradeSeq)
    ---@type dictmission_config_cell
    local taskData = CommonHelper:GetTableDataByID(ConfigNames.task_config, del[1])

    if taskData.missiontype==TaskType.GrowUp or  taskData.missiontype == TaskType.Rank then
        local temp={}
        temp.missionid=del[1]
        temp.curval=0
        temp.curstatus=-1
        table.insert(msg,temp)
    else
        if taskData.missiontype==TaskType.Daily or
                taskData.missiontype==TaskType.Club or
                taskData.missiontype==TaskType.DailyRank or
                taskData.missiontype==TaskType.Recruit or
                taskData.missiontype==TaskType.SpecialTraining or
                taskData.missiontype==TaskType.Jcp or
                taskData.missiontype==TaskType.Xcp or
                taskData.missiontype==TaskType.Novice
        then
            for i = 1, #del do
                for j = 1, #self.msgList do
                    if del[i]==self.msgList[j].missionid then
                        local temp={}
                        temp.missionid=self.msgList[j].missionid
                        temp.curval=self.msgList[j].curval
                        temp.curstatus=TaskStatus.IsDoneAndGet
                        temp.tradeseq=self.msgList[j].tradeseq
                        table.insert(msg,temp)
                    end
                end
            end
            if taskData.missiontype==TaskType.Novice then
                if curTradeSeq>self.CurTradeSeq then
                    self.CurTradeSeq=curTradeSeq
                    self.TaskScheduleData[curTradeSeq].ifGift=ScheduleState.IsRally
                end
            end
        end
    end
    self:UpdateMsgList(msg)
    if taskData.missiontype==TaskType.Novice then
        self:ParseNoviceTaskList(self.CurShowTrade)
    else
        self:ParseData()
    end
    self:ParseData()
end

function TaskDataManager:UpdateMsgList(msg)
    local count = {}
    if self.msgList then
        for i = 1, #msg do
            local flag = -1
            local contain = 0
            for j = 1, #self.msgList do
                if msg[i].missionid == self.msgList[j].missionid then
                    flag = j
                    break
                else
                    contain = contain + 1
                end
            end
            if flag ~= -1 then
                self.msgList[flag] = msg[i]
                if msg[i].curstatus == -1 then
                    table.remove(self.msgList, flag)
                end
            end
            if contain >= #self.msgList then
                table.insert(count, i)
            end
        end
        if #count > 0 then
            for i = 1, #count do
                table.insert(self.msgList, msg[i])
            end
        end
    end
end

function TaskDataManager:UpdateActive(activeId)
    --for i = 1, #self.weekActiveState do
    --    if activeId == self.weekActiveState[i].id then
    --        self.weekActiveState[i].state = 2
    --    end
    --end
    for i = 1, #self.dailyActiveState do
        if activeId == self.dailyActiveState[i].activeNum then
            self.dailyActiveState[i].state = 2
        end
    end
    UINotify:Get():SendNotification(UINotifyEvent.RefreshCurView)
end

function TaskDataManager:CheckTaskDone()
    local temp = self.TaskList
    self.TaskGetCount = 0
    for i = 1, #temp do
        if temp[i].status == TaskStatus.IsDoneNoGet then
            self.TaskGetCount = self.TaskGetCount + 1
        end
    end
    return self.TaskGetCount>0
end
function TaskDataManager:CheckNoviceTaskDone()
    local temp = self.NoviceTaskList
    self.TaskGetCount = 0
    for k, v in pairs(temp) do
        for i = 1, #v do
            if v[i].status == TaskStatus.IsDoneNoGet then
                self.TaskGetCount = self.TaskGetCount + 1
            end
        end
    end

    if self.TaskGetCount > 0 then
        --SdkAd:Get():SdkAdjust_Task(self.TaskGetCount == #temp)
    end

end

function TaskDataManager:GetAllGet()
    return self.TaskGetCount>0
end
-- 根据是日常或者是成就提取所有任务
---@return table<number,TaskData>
function TaskDataManager:GetDailyInfoByQuestType(questType)
    if self.TaskDicByQuestType[questType] == nil then
        self.TaskDicByQuestType[questType] = {}
    end
    local result = {}
    for i = 1, #self.TaskDicByQuestType[questType] do
        if self.TaskDicByQuestType[questType][i].status ~= -1 then
            table.insert(result, self.TaskDicByQuestType[questType][i])
        end
    end
    return result
end
function TaskDataManager:GetTaskIsDone(type)
    local value = false
    local tab = self.TaskList
    for i = 1, #tab do
        local data = tab[i]
        if data.status == TaskStatus.IsDoneNoGet then
            value = true
            break
        end
    end
    if value==false and type==TaskType.Daily then
        for i = 1, #self.dailyActiveState do
            if self.dailyActiveState[i].state==1 then
                value = true
                break
            end
        end
    end
    return value
end
function TaskDataManager:GetNoviceTaskIsDone()
    local value = false
    local tab = self.NoviceTaskList
    for k, v in pairs(tab) do
        for i = 1, #v do
            if v[i].status == TaskStatus.IsDoneNoGet and v[i].subType<=self.CurTradeSeq then
                value=true
                break
            end
        end
        if value then
            break
        end
    end
    return value
end
function TaskDataManager:GetNoviceTradeIsDone()
    local value = false
    local tab = self.TaskScheduleData
    for k, v in pairs(tab) do
        if v.ifGift==ScheduleState.IsDoneNoGet and v.tradeSeq<=self.CurTradeSeq then
            value=true
            break
        end
    end
    return value
end


function TaskDataManager:ParseNoviceData()
    ---@type ScheduleData[]
    self.TaskScheduleData = {}
    for i, v in pairs(self.tradeMission) do
        local data = ScheduleData()
        data:SetData_ScheduleData(self.tradeMission[i])
        table.insert(self.TaskScheduleData, data)
    end

end
function TaskDataManager:UpdateScheduleData(page,state)
    self.TaskScheduleData[self.ShowTradeSeq].ifGift=state
end
function TaskDataManager:GetTaskNoviceScheduleData()
    return self.TaskScheduleData
end
function TaskDataManager:GetCurTradeSeq()
    return self.CurTradeSeq
end
function TaskDataManager:GetNoticeData(page)
    self.ShowTradeSeq=page
    return self.TaskScheduleData[page]
end
function TaskDataManager:SetNoviceFlag(value)
    self.NoviceFlag=value==0
end
function TaskDataManager:GetNoviceFlag()
    return self.NoviceFlag
end

function TaskDataManager:GetMainMenuViewTaskId()
   return self.MainTaskId
end

---@param taskData TaskData
function TaskDataManager:SaveNoviceMainTaskId(taskData)
    self.MainTaskId=0
    if taskData and (taskData.status==TaskStatus.IsRally or taskData.status==TaskStatus.IsDoneNoGet) then
        self.MainTaskId=taskData.taskId
    end
end


function TaskDataManager:ClearData()
    self.msgList = nil
    self.TaskDicByQuestType = nil
end

function TaskDataManager:SetOpenModuleType(type)
    self.OpenType=type
end
function TaskDataManager:SetRecruitID(id)
    self.RecruitID=id
end
function TaskDataManager:GetRecruitID()
    if self.RecruitID then
        return self.RecruitID
    end
    return 0
end

function TaskDataManager:GetOpenModuleType()
    return self.OpenType
end


