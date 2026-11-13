---@class  RaceSelfChapterData
RaceSelfChapterData=class("RaceSelfChapterData")
function RaceSelfChapterData:initialize()
    ---@type dictactivitychapter_config_cell
    self.cfg=nil
    self.endTime=nil
end

---@param msg SC_ChapterInfo
function RaceSelfChapterData:SetMiniData(msg)
    self.id=msg.chapterId
    self.BeginTime=msg.btime
    self.EndTime=msg.etime
    self.EndTaskTime=msg.starOver
    self.FinishPeople=msg.finishsum
    self.NeedLv=msg.needlev
    self.cfg=CommonHelper:GetTableDataByID(ConfigNames.dictactivitychapter_config,self.id)
    self.isJoin=false
    self.isDone=false
    self.subTime = math.abs(CommonHelper:SubTime(self.EndTime * 1000))
    self.subTaskTime =CommonHelper:SubTime(self.EndTaskTime * 1000)
    -- self.IsNew= self.cfg.duration*TimeMilliSecond_Day-self.subTime<TimeMilliSecond_Day
    self.subDay,self.subHour,self.subMinute,self.subSecond =  CommonHelper:GetConvertMillSecond(self.subTime)
    self.subTaskDay,self.subTaskHour,self.subTaskMinute,self.subTaskSecond =  CommonHelper:GetConvertMillSecond(math.abs(self.subTaskTime))
    ---@type SC_CopyInfo[]
    self.Cops ={}
    self.CurLevel=0
    self.HasTask=true
    local  reward= CommonHelper:GetTableDataByID(ConfigNames.dictsectionaward_config,self.id)
    ---@type PVEChapterBoxData[]
    self.BoxState={}
    if reward and self.subTaskTime< 0then
        self.starNums=stringSplitToNumber(reward.starsum,':')
        local rewards=stringSplit(reward.dropid,':')
        for i = 1, #self.starNums do
            self.BoxState[i]=PVEChapterBoxData({self.starNums[i], rewards[i]})
        end
        local process = msg.starNum
        local states = msg.rewards
        self:SetProcess(process)
        self:SetAllBoxState(states)
    else
        self.HasTask=false
    end
    ---@type mapnode_config_cell[]
    local  chapterDic={}
    ---@type mapnode_config
    local tabmap = ClientDataManager:Get():GetDataTable(ConfigNames.mapnode_config)
    local mapnodelist = tabmap.GetConfigData()
    for k,v in pairs(mapnodelist)  do
        if v.chapterid==self.id then
            table.insert(chapterDic,v)
        end
    end
    table.sort(chapterDic,function(a, b) return a.C_ID <b.C_ID end)
    for k, v in pairs(chapterDic) do
        if msg.copys[k] then
            local temp={}
            temp.copyid=msg.copys[k].copyid
            temp.unlock=msg.copys[k].unlock
            temp.winsum=msg.copys[k].winsum
            temp.btime=msg.copys[k].btime
            temp.taskList,temp.isDone=self:SetTaskData(msg.copys[k].star,msg.copys[k].awards,self:GetTaskList(temp.copyid))
            if CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())<temp.btime then temp.unlock=0 end
            table.insert(self.Cops,temp)
            if temp.unlock==1 and temp.winsum>0 then
                self.CurLevel=self.CurLevel+1
            end
        else
            local temp={}
            temp.copyid=v.C_ID
            temp.unlock=0
            temp.winsum=0
            temp.btime=0
            temp.taskList,temp.isDone=self:SetTaskData({},{},self:GetTaskList(temp.copyid))
            table.insert(self.Cops, temp )
        end
    end
    table.sort(self.Cops,function(a, b) return a.copyid <b.copyid end)
    for i = 1,#self.Cops  do
        if i>1  and self.Cops[i].unlock==1 then
            self.isJoin=true
            break
        end
    end
    local index= #self.Cops
    if index>0 then
        self.isDone=self.Cops[#self.Cops].winsum>0
        return true
    else
        return false
    end

end
---@class RaceSelfChapterTaskData
---@field State 1  get 2rally 3done
---@field Cfg dictactivecopytask_config_cell
---@return RaceSelfChapterTaskData[]
function RaceSelfChapterData:SetTaskData(star,awards,tasklist,time)
    if tasklist==nil then return{} end
    ---@type RaceSelfChapterData[]
    local result={}
    local count=0
    for i = 1, #tasklist do
        ---@type RaceSelfChapterData
        local temp={}
        temp.State=RaceSelfChapterTaskState.Rally
        temp.Cfg=tasklist[i]
        for j = 1, #star do
            if i==star[j] then
              temp.State=RaceSelfChapterTaskState.Get
                break
            end
        end
        table.insert(result,temp)
    end
    for i = 1, #result do
        for j = 1, #awards do
            if i==awards[j] then
                result[i].State=RaceSelfChapterTaskState.Done
                break
            end
        end
        if result[i].State==RaceSelfChapterTaskState.Done then
            count=count+1
        end
    end
    result=self:SortTaskList(result)
    return result,count==#tasklist
end

function RaceSelfChapterData:GetTaskList(copyid)
    ---@type dictactivecopytask_config
    local cfg=ClientDataManager:Get():GetDataTable(ConfigNames.dictactivecopytask_config,copyid)
    return cfg.GetTaskListByCopyId(copyid)
end

function RaceSelfChapterData:SetProcess(value)
    self.process = value
end

---@param value number[]
function RaceSelfChapterData:SetAllBoxState(value)

    local count=#self.BoxState
    for i = 1,count  do
        if self.process>=self.BoxState[i].star then
            self.BoxState[i].state =LevelBoxState.CanReceive
        end
        local flag=false
        for j = 1, #value do
            if self.BoxState[i].star==value[j] then
                flag=true
                break
            end
        end
        if flag then
            self.BoxState[i].state=LevelBoxState.ReceiveCompleted
        else
            self.BoxState[i].state=self.BoxState[i].state
        end
    end
end
---@param msg SC_CopyStarAward
function RaceSelfChapterData:UpdateCurTaskState(msg)
    if msg.star then
        for m = 1, #self.Cops do
            if msg.copyid==self.Cops[m].copyid then
                for i = 1, #self.Cops[m].taskList do
                    for j = 1, #msg.star do
                        if self.Cops[m].taskList[i].Cfg.starid==msg.star[j] and self.Cops[m].taskList[i].State==RaceSelfChapterTaskState.Rally then
                            self.Cops[m].taskList[i].State=RaceSelfChapterTaskState.Get
                            break
                        end
                    end
                end
                self.Cops[m].taskList=self:SortTaskList(self.Cops[m].taskList)
                break
            end
        end
    end

    if msg.awardno then
        for m = 1, #self.Cops do
            if msg.copyid==self.Cops[m].copyid then
                local count=0
                for i = 1, #self.Cops[m].taskList do
                    for j = 1, #msg.awardno do
                        if self.Cops[m].taskList[i].Cfg.starid==msg.awardno[j] and  self.Cops[m].taskList[i].State==RaceSelfChapterTaskState.Get then
                            self.Cops[m].taskList[i].State=RaceSelfChapterTaskState.Done
                            break
                        end
                    end
                    if self.Cops[m].taskList[i].State==RaceSelfChapterTaskState.Done then
                        count=count+1
                    end
                end
                self.Cops[m].taskList=self:SortTaskList(self.Cops[m].taskList)
                self.Cops[m].isDone=count==#self.Cops[m].taskList
                break
            end
        end
    end
end

function RaceSelfChapterData:SortTaskList(taskList)
    table.sort(taskList,function(a, b)
        if a.State<b.State then
            return true
        end
        if a.State>b.State then
            return false
        end
        return a.Cfg.difficultylevel<b.Cfg.difficultylevel
    end)
    return taskList
end

---@param msg SC_CopyStarAward
function RaceSelfChapterData:GetCurCopy()
   return self.Cops[self.CurLevel]
end

function RaceSelfChapterData:GetSelfChapterHasRedPoint()
    local flag=false
    for i = 1, #self.Cops do
        if self:GetCopyHasRedPoint(i) then
            flag=true
            break
        end
    end
    if not flag then
        for i = 1, #self.BoxState do
            if self.BoxState[i].state==LevelBoxState.CanReceive then
                flag=true
                break
            end
        end
    end
    return flag
end
function RaceSelfChapterData:GetCopyHasRedPoint(idx)
    local flag=false
    for j = 1, #self.Cops[idx].taskList do
        if self.Cops[idx].taskList[j].State==RaceSelfChapterTaskState.Get then
            flag=true
            break
        end
    end
    return flag
end

