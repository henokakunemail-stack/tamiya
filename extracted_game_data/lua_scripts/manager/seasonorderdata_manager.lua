local __instance
---@class SeasonOrderDataManager
SeasonOrderDataManager = class("SeasonOrderDataManager")
function SeasonOrderDataManager:initialize()
    ---@type table<number, RaceWeekData>
    self.RaceList = {}
end
---@return SeasonOrderDataManager
function SeasonOrderDataManager:Get()
    if __instance == nil then
        __instance = SeasonOrderDataManager()
    end
    return __instance
end
function SeasonOrderDataManager:SetTokenData(data)
    self.TokenData=data
    self:UpdateGetRed()
end
function SeasonOrderDataManager:SetDay(day)
  self.Day=day
end
function SeasonOrderDataManager:SetLevelMax(level)
  self.LevelMax=level
end
function SeasonOrderDataManager:GetTokenData()
  return self.TokenData
end
function SeasonOrderDataManager:GetTaskData()
  return self.TaskData
end
function SeasonOrderDataManager:GetDay()
  return self.Day
end
function SeasonOrderDataManager:GetLevelMax()
  return self.LevelMax
end
function SeasonOrderDataManager:UpdateGetRed()
    local flag=false
    for k, v in pairs(self.TokenData.ifgift) do
        if tonumber(v)==0 then
            flag=true
            break
        end
    end
    RedPointManager:Get():UpdateValue(RedPointID.S_SeasonOrderGet,flag)
end
---@param msg SC_TaskList
function SeasonOrderDataManager:SetTaskData(msg)
    ---@type SC_UserTask[]
    self.msgList = msg.curTasks
    self:ParseData()
end
function SeasonOrderDataManager:ParseData()
    ---@type TaskData[]
    self.TaskData={}
    for i = 1, #self.msgList do
        local data = TaskData()
        data:SetData_Task(self.msgList[i])
        table.insert(self.TaskData,data)
    end
    self.TaskData=self:TaskSortTaskByState(self.TaskData)
end
function SeasonOrderDataManager:TaskSortTaskByState(list)
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
            return a.finshNum / a.progress > b.finshNum / b.progress
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
function SeasonOrderDataManager:UpdateTaskList(msg,del)
    local temp={}
    for i = 1, #del do
        for j = 1, #self.TaskData do
            if del[i]==self.TaskData[j].taskId then
                temp.missionid=self.TaskData[j].taskId
                temp.curval=self.TaskData[j].progress
                temp.curstatus=TaskStatus.IsDoneAndGet
                break
            end
        end
    end
    table.insert(msg,temp)
    self:UpdateMsgList(msg)
    self:ParseData()
end
function SeasonOrderDataManager:UpdateMsgList(msg)
    local count = {}
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

function SeasonOrderDataManager:UpdateTask(missionIds,day7taskval,daytaskval)
    local result =false
    if self.TaskData then
        for i = 1, #missionIds do
            for j = 1, #self.TaskData do
                if missionIds[i]==self.TaskData[j].taskId then
                    self.TaskData[j].status=-1
                    QuickTaHelper:Get():TrackTaskEvent(self.TaskData[j],3,0)
                    result=true
                    break
                end
            end
        end
    end
    return result
end

function SeasonOrderDataManager:GetTaskIsDone()
    local value = false
    local tab = self.TaskData
    for i = 1, #tab do
        local data = tab[i]
        if data.status == TaskStatus.IsDoneNoGet then
            value = true
            break
        end
    end
    return value
end

