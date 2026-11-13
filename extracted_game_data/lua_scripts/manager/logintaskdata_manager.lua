---@class NoviceTaskData
NoviceTaskData = class("NoviceTaskData")
function NoviceTaskData:initialize()
    self.id = 0
    self.finshNum = 0
    self.status = 0  --0进行中 -- 1 可领取 2  完成已领取
end

---@param msg SC_NoviceTask4Client
function NoviceTaskData:SetData(msg)
    self.id = msg.id
    self.finshNum = msg.finshNum
    self.status = msg.status
    ---@type novicetask_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.novicetask_config, self.id)
    self.day = cfg.openday
    self.desc = CommonHelper:GetTempStr_Default(cfg.description)
    self.progress = cfg.progress
    self.point = cfg.taskpoint
    self.reward = CommonHelper:ParseToReward3(cfg.reward)
end
---@class NoviceTaskActiveData
NoviceTaskActiveData = class("NoviceTaskActiveData")
function NoviceTaskActiveData:initialize()
    self.num = -1
    self.reward = nil
    self.status = -1
end

---@param cfg novicetaskreward_config_cell
function NoviceTaskActiveData:SetData(cfg, point)
    self.num = cfg.taskPoint
    self.reward = CommonHelper:ParseToReward3(cfg.reward)
    if point >= self.num then
        self.status = 1
    else
        self.status = 0
    end
end

function NoviceTaskActiveData:UpdateStatus()
    self.status = 2
end

---@class LoginTaskDataManager
LoginTaskDataManager = class("LoginTaskDataManager")

---@return LoginTaskDataManager
function LoginTaskDataManager:Get()
    if self._instance == nil then
        self._instance = LoginTaskDataManager()
    end
    return self._instance
end

function LoginTaskDataManager:initialize()
    self.NoviceData = {}
    ---@type table<number,ActiveData>
    self.NoviceActive = {}
    self.NoviceDays = {}
    self.LeftTime = 0 ---新手任务剩余时间
    self.Day = 0 ---新手任务第几天
    self.NoviceActiveNum = 0

    self.btnFlag = nil--是否是游戏内点击

    self.IsCanSign = false--是否可以签到

    CacheClearTrigger:Get():RegisterEvent(self, self.Clear)
end

function LoginTaskDataManager:SetIsCanSign(isCanSign)
    self.IsCanSign = isCanSign
end

function LoginTaskDataManager:GetBtnFlag()
    if self.btnFlag==nil then
        return 1
    end
    return self.btnFlag
end

function LoginTaskDataManager:SetBtnFlag(flag)
    self.btnFlag = flag
end

---@param msg SC_TaskList
function LoginTaskDataManager:Init(msg)
    if msg.day7Endtime>0 then
        ---@type SC_UserTask[]
        self.msgList = msg.curTasks
        --新手任务持续九天
        --self.CurTime=(9*TimeSecond_Day)-(msg.day7Endtime-CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()))
        --self.SubTime=msg.day7Endtime-CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
        self.Day=msg.day7Endtime
        --self.Hour=math.abs(math.modf((self.CurTime-self.Day*TimeSecond_Day)/TimeSecond_Hour))
        --local day =math.abs(math.modf(self.SubTime/TimeSecond_Day))
        --local hour=math.abs(math.modf((self.SubTime-day*TimeSecond_Day)/TimeSecond_Hour))
        self.LeftTime = CommonHelper:GetTempStr_Default(TemplateStringID.LoginTaskDuration, 9-self.Day)
        self.NoviceActiveNum=msg.day7taskval
        self:ParseData()
        self:InitActive(msg.activeGifts)
    end
end
function LoginTaskDataManager:HasNoviceTask()
    return true
end
function LoginTaskDataManager:ParseData()
    ---@type TaskData[]
    self.NoviceData={}
    for i = 1, #self.msgList do
        local data = TaskData()
        data:SetData_Task(self.msgList[i])
        if self.NoviceData[data.day]==nil then
            self.NoviceData[data.day]={}
        end
        table.insert(self.NoviceData[data.day],data)
    end
    for k, v in pairs(self.NoviceData) do
        self.NoviceData[k]=self:TaskSortTaskByState(v)
    end
    self:UpdateRedPointData()
   -- self:CheckDailyTaskDone()
end
-- 根据任务完成的状态进行排序
---@param list table<number,NoviceTaskData>
function LoginTaskDataManager:TaskSortTaskByState(list)
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
function LoginTaskDataManager:UpdateTask(missionIds,day7taskval,daytaskval)
    self.NoviceActiveNum = day7taskval
    local result =false
    for i = 1, #self.NoviceActive do
        if self.NoviceActiveNum>= self.NoviceActive[i].activeNum and self.NoviceActive[i].state==0 then
            self.NoviceActive[i].state=1
        end
    end
    for i = 1, #missionIds do
        for k, v in pairs(self.NoviceData) do
            for j = 1, #v do
                if missionIds[i]==v[j].taskId then
                    result=true
                    v[j].status=TaskStatus.IsDoneAndGet
                    QuickTaHelper:Get():TrackTaskEvent(v[j],2,self.NoviceActiveNum)
                    break
                end
            end
        end
    end
    for k, v in pairs(self.NoviceData) do
        self.NoviceData[k]= self:TaskSortTaskByState(v)
    end
    self:UpdateRedPointData()
   return result
end
function LoginTaskDataManager:UpdateRedPointData()
    self.NoviceDays = {}
    for k, v in pairs(self.NoviceData) do
        if k>self.Day then
            self.NoviceDays[k]=false
        else
            for i = 1, #v do
                if self.NoviceDays[k]==nil or self.NoviceDays[k]==false then
                    self.NoviceDays[k]=v[i].status==TaskStatus.IsDoneNoGet
                    if self.NoviceDays[k] then
                        break
                    end
                end
            end
        end
    end
end
---@param msg SC_TaskActiveGift[]
function LoginTaskDataManager:InitActive(msg)
    self.NoviceActive = {}
    for i = 1, #msg do
        if msg[i].activetype==4 then
            local temp = ActiveData()
            temp:SetData(msg[i])
            table.insert(self.NoviceActive, temp)
        end
    end
end



function LoginTaskDataManager:UpdateActiveData()
    for k, v in pairs(self.NoviceActive) do
        if v.num <= self.NoviceActiveNum and v.status == 0 then
            v.status = 1
        end
    end
end

function LoginTaskDataManager:GetTaskIsDone()
    local value = false
    local tab = self.NoviceData
    for i = 1, #tab do
        local data = tab[i]
        if data.status == TaskStatus.IsDoneNoGet then
            value = true
            break
        end
    end
    if value==false then
        for i = 1, #self.NoviceActive do
            if self.NoviceActive[i].state==1 then
                value = true
                break
            end
        end
    end

    return value
end



function LoginTaskDataManager:UpdateActive(activeId)
    for i = 1, #self.NoviceActive do
        if activeId == self.NoviceActive[i].activeNum then
            self.NoviceActive[i].state = 2
        end
    end
    UINotify:Get():SendNotification(UINotifyEvent.LoginNoviceTaskView_RefreshCurView)
end

function LoginTaskDataManager:IsHaveRedPoint_Sign()
    return self.IsCanSign
end

function LoginTaskDataManager:IsHaveRedPoint_NoviceTask()
    return self:GetNoviceTaskRedPoint()
end
function LoginTaskDataManager:GetNoviceTaskRedPoint()
    local value = false
    for i = 1, #self.NoviceDays do
        if self.NoviceDays[i] then
            value=true
            break
        end
    end
    return value
end

function LoginTaskDataManager:Clear()
    self.NoviceData = {}
    ---@type table<number,NoviceTaskActiveData>
    self.NoviceActive = {}
    self.NoviceDays = {}
    self.LeftTime = 0 ---新手任务剩余时间
    self.Day = 0 ---新手任务第几天
    self.NoviceActiveNum = 0
    self.msgList = nil
    self.btnFlag = nil
end