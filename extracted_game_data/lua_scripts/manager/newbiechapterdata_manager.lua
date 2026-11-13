---@class NewBieChapterDataManager
NewBieChapterDataManager = class("NewBieChapterDataManager")

function NewBieChapterDataManager:initialize()
    ---@type table<number, PVEChapterData>
    self.ChapterList = {}
end

function NewBieChapterDataManager:Get()
    if self._instance == nil then
        self._instance = NewBieChapterDataManager()
    end
    return self._instance
end

function NewBieChapterDataManager:Init()
    self.ChapterList = {}
    self.ChapterId=1000
    ---@type mapnode_config
    local tabmap = ClientDataManager:Get():GetDataTable(ConfigNames.mapnode_config)
    local chapterDic = tabmap.GetChapterDic()

    for k,v in pairs(chapterDic)  do
        ---@type dcitchapter_config_cell
        local cfg= CommonHelper:GetTableDataByID(ConfigNames.dictchapter_config,k)
        if cfg and  cfg.chaptertype==PveType.NewBie then
            local data = PVEChapterData()
            data:SetData(k,v,PveType.NewBie)
            table.insert(self.ChapterList, data)
        end
    end
    table.sort(self.ChapterList,function (a, b)
        return a.id < b.id
    end)
end

function NewBieChapterDataManager:GetChapterList()
    return self.ChapterList
end
function NewBieChapterDataManager:GetChapterId()
    return self.ChapterId
end

---@param chapters SC_UserChapter[]
function NewBieChapterDataManager:UpdateMsgChapterList(chapters)
    for i = 1, #chapters do
        local chapterid = chapters[i].chapterId
        local process = chapters[i].starNum
        local states = chapters[i].rewards
        for m = 1, #self.ChapterList do
            if self.ChapterList[m].id == chapterid then
                self.ChapterList[m]:SetLock(false)
                self.ChapterList[m]:SetProcess(process)
                self.ChapterList[m]:SetAllBoxState(states)
                break
            end
        end
    end
end
---@param msg SC_UserCopy
function NewBieChapterDataManager:UpdateMsgLevelList(msg)
    local data = self:GetChapterDataByID(msg.chapterid)
    for i = 1, #msg.copys do
        local levelid = msg.copys[i].copyid
        local star = msg.copys[i].star
        local time = msg.copys[i].fasttime
        local count = msg.copys[i].todynum
        local winSum=msg.copys[i].winsum
        for m = 1, #data.levels do
            if data.levels[m].id == levelid then
                data.levels[m]:UpdateLevelData(star,time,count,winSum)
                break
            end
        end
    end
end

---@param msg SC_FastCopyInfo
function NewBieChapterDataManager:UpdateMsgRankInfo(msg)
    local data = self:GetLevelDataByLevelId(msg.copyid)
    if data then
        data:SetRackInfo(msg)
    end
end
---@return PVEChapterData
function NewBieChapterDataManager:GetChapterDataByID(id)
    for i = 1, #self.ChapterList do
        if self.ChapterList[i].id == id then
            return self.ChapterList[i]
        end
    end
end
function NewBieChapterDataManager:UpdateMsgChapterBoxState(msg)
    for m = 1, #self.ChapterList do
        if self.ChapterList[m].id == msg.chapterid then
            self.ChapterList[m]:SetAllBoxState(msg.awardno)
            break
        end
    end
end
---@return PVELevelData
function NewBieChapterDataManager:GetLevelDataByLevelId(id)
    for i = 1, #self.ChapterList do
        if self.ChapterList[i] then
            if self.ChapterList[i]:GetLevelDataById(id) then
                local temp= self.ChapterList[i]:GetLevelDataById(id)
                return temp
            end
        end
    end
    return nil
end
function NewBieChapterDataManager:SetCurLevelData(temp)
    self.CurLevelData=temp
end
---@return PVELevelData
function NewBieChapterDataManager:GetCurLevelData()
    return  self.CurLevelData
end
function NewBieChapterDataManager:SetIsMoreExp(temp)
    self.IsMoreExp=temp
end
---@return PVELevelData
function NewBieChapterDataManager:GetIsMoreExp()
    return  self.IsMoreExp
end

function NewBieChapterDataManager:UpdateMsgChapterData(levelid, allstar,unkockIds,star,count,winsum)

    local chpaterid = CommonHelper:AnalyseChapterId(levelid)
    for m = 1, #self.ChapterList do
        if self.ChapterList[m].id == chpaterid then
            self.ChapterList[m]:SetProcess(allstar)
            break
        end
    end
    for m = 1, #self.ChapterList do
        if self.ChapterList[m].id == chpaterid then
            for j=1, #self.ChapterList[m].levels do
                if self.ChapterList[m].levels[j].id==levelid then
                    self.ChapterList[m].levels[j]:UpdateLevelDataStar(star)
                    self.ChapterList[m].levels[j]:UpdateLevelDataCount(count)
                    self.ChapterList[m].levels[j]:UpdateLevelDataWinSum(winsum)
                end
            end
        end
    end
    if unkockIds~=nil then
        for i = 1, #unkockIds do
            for m = 1, #self.ChapterList do
                for j = 1, #self.ChapterList[m].levels do
                    if self.ChapterList[m].levels[j].id == unkockIds[i] then
                        self.ChapterList[m].levels[j].isLock=false
                        break
                    end
                end
            end
        end
    end

end
function NewBieChapterDataManager:UpdateMsgChapterCount(levelid,count)
    local chpaterid = CommonHelper:AnalyseChapterId(levelid)
    for m = 1, #self.ChapterList do
        if self.ChapterList[m].id == chpaterid then
            for j=1, #self.ChapterList[m].levels do
                if self.ChapterList[m].levels[j].id==levelid then
                    self.ChapterList[m].levels[j]:UpdateLevelDataCount(count)
                end
            end
        end
    end
end

---@param data  SC_BeginPve
function NewBieChapterDataManager:BeginBattle(data)
    self.Queue = Queue()
    self.BattleResult={}
    self.battleCarIdx=""
    if #data.cars>=1 then
        self.BattleCount=#data.cars
        for i = 1, #data.cars do
            local temp={}
            temp.car=data.cars[i]
            temp.copyid=data.copyid
            temp.carid=data.carids[i]
            if i==#data.cars then
                self.battleCarIdx=self.battleCarIdx..temp.carid
            else
                self.battleCarIdx=self.battleCarIdx..temp.carid..":"
            end
            temp.starttime=data.starttime
            temp.curlevel=data.curlevel
            temp.idx=i
            self.Queue:EnQueueFront(temp)
        end
    else
        self.BattleCount=1
        local temp={}
        temp.car=data.car
        temp.copyid=data.copyid
        temp.carid=data.carid
        self.battleCarIdx=data.carid
        temp.starttime=data.starttime
        temp.curlevel=data.curlevel
        temp.idx=1
        self.Queue:EnQueueFront(temp)
    end
    print("init battle car id",self.battleCarIdx)
    self:FightBattle()
end
function NewBieChapterDataManager:GetBattleCarIdx()
    return self.battleCarIdx
end

function NewBieChapterDataManager:FightBattle()
    if self.Queue:GetSize()>0 then
        local value= self.Queue:DeQueueBack()
        self.CurBattle=value
        BattleDataManager:Get():SetRoomData(value, RaceModel.NewBieChapter)
        local scenename = BattleDataManager:Get():GetSceneName()
        local trackdata = BattleDataManager:Get():GetTrackData()
        SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.NewBieChapter)
    end
end

function NewBieChapterDataManager:BattleFinish()
    if self.Queue:GetSize()>0 then
        BattleDataManager:Get():SetStateBattleExit()
        self:FightBattle()
    else
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToNewBieChapter,BattleDataManager:Get():GetLevelId())
        BattleDataManager:Get():SetStateBattleExit()
    end
end
---@param result BattleResultData
function NewBieChapterDataManager:AddBattleResult(levelid,carid,isWin,time,curerror,result,starttime,recordValue)
    local flag=true
    for k, v in pairs(self.BattleResult) do
        if carid==v.carid then
            flag=false
            break
        end
    end
    if flag then
        local temp = {}
        temp.levelid = levelid
        temp.carid = carid
        temp.isWin = isWin
        temp.time = time
        temp.error = curerror
        temp.result = result:Copy()
        temp.starttime = starttime
        temp.recordValue = recordValue
        table.insert(self.BattleResult, temp)
    end
    self.lastFlag=NewBieChapterDataManager:Get().Queue:GetSize()==0
    if self.lastFlag or isWin==0 then
        local caridx=""
        local time=""
        local error=""
        local starttime=""
        local rank=""
        local recordValue=""
        for i = 1, self.BattleCount do
            local temp=self.BattleResult[i]
            if i<self.BattleCount then
                if temp then
                    caridx=caridx..temp.carid..":"
                    time=time..temp.time..":"
                    error=error..temp.error..":"
                    starttime=starttime..temp.starttime..":"
                    recordValue=recordValue..temp.recordValue..":"
                    local playerList= temp.result:GetPlayerList()
                    local tempRank=0
                    for i, v in ipairs(playerList) do
                        if PlayerDataManager:Get():GetPlayerRID()==playerList[i].Pid then
                            tempRank=playerList[i].Rank
                            rank=rank..tempRank..":"
                            break
                        end
                    end
                else
                    caridx=caridx.."0:"
                    time=time.."0:"
                    error=error.."0:"
                    starttime=starttime.."0:"
                    rank=rank.."0:"
                    recordValue=recordValue.."0:"
                end
            else
                if temp then
                    caridx=caridx..temp.carid
                    time=time..temp.time
                    error=error..temp.error
                    starttime=starttime..temp.starttime
                    recordValue=recordValue..temp.recordValue
                    local playerList= temp.result:GetPlayerList()
                    local tempRank=0
                    for i, v in ipairs(playerList) do
                        if PlayerDataManager:Get():GetPlayerRID()==playerList[i].Pid then
                            tempRank=playerList[i].Rank
                            rank=rank..tempRank
                            break
                        end
                    end
                else
                    caridx=caridx.."0"
                    time=time.."0"
                    error=error.."0"
                    starttime=starttime.."0"
                    recordValue=recordValue.."0"
                    rank=rank.."0"
                end
            end

        end
        NewBieChapterDataManager:Get().Queue:Clear()
        ChapterSubsystem:Get():SendMsg_BattleFinish(levelid,self:GetBattleCarIdx(),isWin,time,curerror,starttime,rank,recordValue)
    else
        BattleDataManager:Get():SetStateBattleResult()
    end
end
function NewBieChapterDataManager:GetLastFlag()
    if self.lastFlag==nil then
        return true
    end
    return self.lastFlag
end
function NewBieChapterDataManager:GetBattleResult()
    return self.BattleResult
end
---@param data  PVEChapterRankData
function NewBieChapterDataManager:BeginHistoryBattle(copyid,data)
    self.Queue = Queue()
    if #data.CarList>=1 then
        self.BattleCount=#data.CarList
        for i = 1, #data.CarList do
            local temp={}
            temp.copyId=copyid
            temp.carData=data
            temp.isHistory=true
            temp.seed=data.Seeds[i]
            temp.selfCarID=data.pid
            temp.StartTime=data.StarTimes[i]
            if data.Stops then
                temp.Stop=data.Stops[i]
            end
            temp.idx=i
            self.Queue:EnQueueFront(temp)
        end
    end
    self:FightHistoryBattle()
end
function NewBieChapterDataManager:FightHistoryBattle()
    if self.Queue:GetSize()>0 then
        local value= self.Queue:DeQueueBack()
        self.CurBattle=value
        PlayerPrefsHelper:SetValue_SelfCountDownBtnUpTime(self.CurBattle.StartTime)
        if self.CurBattle.Stop=="0" or CommonHelper:IsNullOrEmpty(self.CurBattle.Stop) then
            PlayerPrefsHelper:SetValue_ReplayInputInfos("")
        else
            PlayerPrefsHelper:SetValue_ReplayInputInfos(self.CurBattle.Stop)
        end
        BattleDataManager:Get():SetRoomData(value, RaceModel.NewBieChapter_RePlay)
        local scenename = BattleDataManager:Get():GetSceneName()
        local trackdata = BattleDataManager:Get():GetTrackData()
        SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.NewBieChapter_RePlay)
    end
end
function NewBieChapterDataManager:BattleHistoryFinish()
    if self.Queue:GetSize()>0 then
        BattleDataManager:Get():SetStateBattleExit()
        self:FightHistoryBattle()
    else
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToNewBieChapter,NewBieChapterDataManager:Get():GetCurLevelData().id)
        BattleDataManager:Get():SetStateBattleExit()
    end
end