
---@class TaskData
TaskData = class("TaskData")
function TaskData:initialize()
    self.taskId = 0 -- 任务id
    self.progress = 0 --总进度
    self.finshNum = 0 --当前进度
    self.status = 0 --任务状态 1 进行中 2完成未领取 3完成已领取
    self.active=0
    self.description = ""--任务描述
    self.taskname = "" --任务名称
    --奖励的图标和数量
    self.rewards={}
    self. questType=0--任务类型 1 日常 2 成就
    self.subType=0 --任务的子类型 1成长 2 收集 3玩法
    self.CompleteType=0 --任务的子类型 1成长 2 收集 3玩法
end

---@ param taskData SC_UserTask
function TaskData:SetData_Task(taskData)
    ---@type dictmission_config_cell
    local cfg=CommonHelper:GetTableDataByID(ConfigNames.task_config,taskData.missionid)
    if cfg~=nil then
        self.taskId = cfg.C_ID
        self.progress =cfg.succval
        self.finshNum =taskData.curval>self.progress and self.progress or taskData.curval
        self.status=taskData.curstatus
        if self.status==TaskStatus.IsDoneAndGet or self.status==TaskStatus.IsDoneNoGet  then self.finshNum=self.progress end
        self.taskname=cfg.missionname
        self.description=CommonHelper:GetTempStr_Default(cfg.missionmemo)
        self.day=taskData.dayno
        self.subType=taskData.tradeseq
        self.SkipParam=stringSplitToNumber(cfg.missionjump,":")
        self.CompleteType=cfg.condtionid
        self.rewards={}
        local awardids=stringSplitToNumber(cfg.awardids,':')
        local nums=stringSplitToNumber(cfg.awardnums,':')
        for i = 1, #awardids do
            local data=RewardData()
            data:SetDataIdNum(awardids[i],nums[i])
            table.insert(self.rewards,data)
        end
        CommonHelper:GetRewardByDictDownId(cfg.awardids)
        self.questType=cfg.missiontype
        self.active=cfg.pointval
        --if self.status==TaskStatus.IsDoneNoGet then
        --    local temp={ "角色","生涯","车辆","社交","涂装","财富"}
        --    QuickTa:Get():Track_TaskComplete(tostring(self.taskId),self.questType==TaskType.Daily and "日常" or "成长" ,temp[self.subType],-1,PlayerDataManager:Get():GetPlayerStamina())
        --end
    end
end
---@param award SC_Awards
function TaskData:SetData_Recruit(id,progress,finishNum,state,award,type)

    self.taskId = id
    self.progress =progress
    self.finshNum =finishNum>self.progress and self.progress or finishNum
    self.status=state+1
    if self.status==TaskStatus.IsDoneAndGet then self.finshNum=self.progress end
    self.taskname=CommonHelper:GetTempStr_Default(TemplateStringID.TaskRecruitCountName,progress)
    self.description=CommonHelper:GetTempStr_Default(TemplateStringID.TaskRecruitCountDesc,progress)
    self.day=0
    self.subType=0
    self.SkipParam={GameFunction.Recruit}
    self.CompleteType=0
    self.rewards={}
    for i = 1, #award.awardId do
        local data=RewardData()
        data:SetDataIdNum(award.awardId[i],award.awardNum[i])
        table.insert(self.rewards,data)
    end
    self.questType=type
    self.active=0
        --if self.status==TaskStatus.IsDoneNoGet then
        --    local temp={ "角色","生涯","车辆","社交","涂装","财富"}
        --    QuickTa:Get():Track_TaskComplete(tostring(self.taskId),self.questType==TaskType.Daily and "日常" or "成长" ,temp[self.subType],-1,PlayerDataManager:Get():GetPlayerStamina())
        --end
end
---@param award SC_Awards
function TaskData:SetData_Ad(id,progress,type)
    ---@type dictadlist_config_cell
    local cfg=CommonHelper:GetTableDataByID(ConfigNames.dictadlist_config,id)
    self.taskId = id
    self.progress =cfg.viewnum
    self.finshNum =progress
    if self.finshNum<cfg.viewnum then
        self.status=TaskStatus.IsRally
    else
        self.status=TaskStatus.IsDoneAndGet
    end
    self.taskname=CommonHelper:GetTempStr_Default(cfg.missionname)
    self.description=CommonHelper:GetTempStr_Default(cfg.missionmemo)
    self.day=0
    self.subType=0
    self.SkipParam={GameFunction.PlayAd,AdType.Task}
    self.CompleteType=0
    self.rewards=CommonHelper:SetDataByStrIdAndNum(cfg.awardids,cfg.awardnum)
    self.questType=type
    self.active=0
        --if self.status==TaskStatus.IsDoneNoGet then
        --    local temp={ "角色","生涯","车辆","社交","涂装","财富"}
        --    QuickTa:Get():Track_TaskComplete(tostring(self.taskId),self.questType==TaskType.Daily and "日常" or "成长" ,temp[self.subType],-1,PlayerDataManager:Get():GetPlayerStamina())
        --end
end
---@param award SC_Awards
function TaskData:SetData_SuperBattle(id,progress,finishNum,state,awardids,awardsnums,type)

    self.taskId = id
    self.progress =progress
    self.finshNum =finishNum>self.progress and self.progress or finishNum
    self.status=state
    if self.status==TaskStatus.IsDoneAndGet then self.finshNum=self.progress end
    self.taskname=CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleTaskName,progress)
    self.description=CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleTaskDesc,progress)
    self.day=0
    self.subType=0
    self.SkipParam={GameFunction.RaceSuper}
    self.CompleteType=0
    self.rewards={}
    self.rewards=CommonHelper:SetDataByStrIdAndNum(awardids,awardsnums)
    self.questType=type
    self.active=id
        --if self.status==TaskStatus.IsDoneNoGet then
        --    local temp={ "角色","生涯","车辆","社交","涂装","财富"}
        --    QuickTa:Get():Track_TaskComplete(tostring(self.taskId),self.questType==TaskType.Daily and "日常" or "成长" ,temp[self.subType],-1,PlayerDataManager:Get():GetPlayerStamina())
        --end
end

---@class ActiveData
ActiveData = class("ActiveData")
function ActiveData:initialize()
   self.state=0
   self.activeNum=0
   self.activeType=0
   self.activeReward={}
end
---@param cfg SC_TaskActiveGift
function ActiveData:SetData(cfg)
    self.id=cfg.activetype
    self.state=cfg.ifgift
    self.activeNum=cfg.activeval
    self.activeType=cfg.activetype
    ---@type dictactive_config
    local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.active_config)
    ---@type dictactive_config_cell
    local data=cfg.GetDataByTypeAndValue(self.activeType,self.activeNum)
    self.activeReward= {}
    local ids=stringSplitToNumber(data.awardids,':')
    local nums=stringSplitToNumber(data.awardnums,':')
    for i = 1, #ids do
        local reward=RewardData()
        reward:SetDataIdNum(ids[i],nums[i])
        table.insert(self.activeReward,reward)
    end

    local actId=  CommonFestivalDataManager:Get():GetActivityDataIDByType(CommonFestivalType.ActLuckRotaryTable)
    if actId  and self.activeType==1 then
        ---@type dictactluckytask_config
        local dictactluckytask=ClientDataManager:Get():GetDataTable(ConfigNames.dictactluckytask_config)
        ---@type dictactluckytask_config_cell
        local cfg= dictactluckytask.GetDataByActIdAndValue(actId, self.activeNum)
        if cfg then
            local reward=RewardData()
            reward:SetDataIdNum(cfg.propsid,cfg.propnum)
            table.insert(self.activeReward,reward)
        end
    end
end


---@class ScheduleData
ScheduleData = class("ScheduleData")
function ScheduleData:initialize()
    self.tradeSeq = -1 --
    self.ifGift = -1 --是否领取0未激活1激活2可领3已领
    self.curVal = -1 --本章当前进度
    self.sumVal = -1 --总数
    ---@type dicttrademission_config_cell
    self.cfg=nil
end

function ScheduleData:SetData_ScheduleData(msg)
    self.tradeSeq = msg.tradeseq
    self.ifGift = msg.ifgift
    self.curVal = msg.curval
    self.sumVal = msg.sumval
    self.cfg=CommonHelper:GetTableDataByID(ConfigNames.tradetask_config,self.tradeSeq)
end




