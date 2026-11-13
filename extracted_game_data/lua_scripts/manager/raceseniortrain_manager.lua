---@class RaceSeniorTrainManager
RaceSeniorTrainManager = class("RaceSeniorTrainManager")

function RaceSeniorTrainManager:initialize()
    ---@type table<number, PVEChapterData>
    self.ChapterList = {}
end

function RaceSeniorTrainManager:Get()
    if self._instance == nil then
        self._instance = RaceSeniorTrainManager()
    end
    return self._instance
end

function RaceSeniorTrainManager:Init()
    self.ChapterList = {}
    ---@type mapnode_config
    local tabmap = ClientDataManager:Get():GetDataTable(ConfigNames.mapnode_config)
    local chapterDic = tabmap.GetChapterDic()
    for k,v in pairs(chapterDic)  do
        ---@type dcitchapter_config_cell
        local cfg= CommonHelper:GetTableDataByID(ConfigNames.dicthidechapter_config,k)
        if cfg and  cfg.chaptertype==PveType.RaceSeniorTrain then
            local data = PVEChapterData()
            data:SetData(k,v,PveType.RaceSeniorTrain)
            table.insert(self.ChapterList, data)
        end
    end
    table.sort(self.ChapterList,function (a, b)
        return a.id < b.id
    end)
end

function RaceSeniorTrainManager:GetChapterList()
    return self.ChapterList
end
---@param chapters SC_UserChapter[]
function RaceSeniorTrainManager:UpdateMsgChapterList(chapters)
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
function RaceSeniorTrainManager:UpdateMsgLevelList(msg)
    local data = self:GetChapterDataByID(msg.chapterid)
    local passNum=0
    for i = 1, #msg.copys do
        local levelid = msg.copys[i].copyid
        local star = msg.copys[i].star
        local time = msg.copys[i].fasttime
        local count = msg.copys[i].todynum
        local winSum=msg.copys[i].winsum
        for m = 1, #data.levels do
            if data.levels[m].id == levelid then
                data.levels[m]:UpdateLevelData(star,time,count,winSum)
                if data.levels[m].starNum>0 then
                    passNum=passNum+1
                end
                break
            end
        end
    end
    data.PassRate=math.modf(passNum/#data.levels*100)
end

---@param msg SC_FastCopyInfo
function RaceSeniorTrainManager:UpdateMsgRankInfo(msg)
    local data = self:GetLevelDataByLevelId(msg.copyid)
    if data then
        data:SetRackInfo(msg)
    end
end
---@return PVEChapterData
function RaceSeniorTrainManager:GetChapterDataByID(id)
    for i = 1, #self.ChapterList do
        if self.ChapterList[i].id == id then
            return self.ChapterList[i]
        end
    end
end
function RaceSeniorTrainManager:UpdateMsgChapterBoxState(msg)
    for m = 1, #self.ChapterList do
        if self.ChapterList[m].id == msg.chapterid then
            self.ChapterList[m]:SetAllBoxState(msg.awardno)
            break
        end
    end
end
---@return PVELevelData
function RaceSeniorTrainManager:GetLevelDataByLevelId(id)
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
function RaceSeniorTrainManager:SetCurLevelData(temp)
    self.CurLevelData=temp
end
---@return PVELevelData
function RaceSeniorTrainManager:GetCurLevelData()
    return  self.CurLevelData
end
function RaceSeniorTrainManager:SetIsMoreExp(temp)
    self.IsMoreExp=temp
end
---@return PVELevelData
function RaceSeniorTrainManager:GetIsMoreExp()
    return  self.IsMoreExp
end

function RaceSeniorTrainManager:UpdateMsgChapterData(levelid, allstar,unkockIds,star,count,winsum)

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
                        if self.ChapterList[m].levels[j].copytype==LevelType.GuideLevel and self.ChapterList[m].levels[j].starNum>0 then
                            self.ChapterList[m].levels[j].isLock=true
                        end
                        break
                    end
                end
            end
        end
    end

end
function RaceSeniorTrainManager:UpdateMsgChapterCount(levelid,count)
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


---@param data  PVEChapterRankData
function RaceSeniorTrainManager:BeginHistoryBattle(copyid,data)
    self.Queue = Queue()
    if #data.CarList>=1 then
        self.BattleCount=#data.CarList
        for i = 1, #data.CarList do
            local temp={}
            temp.copyId=copyid
            temp.carData=data
            temp.isHistory=true
            temp.seed=data.Seed
            temp.selfCarID=data.pid
            temp.idx=i
            self.Queue:EnQueueFront(temp)
        end
    end
    self:FightHistoryBattle()
end
function RaceSeniorTrainManager:FightHistoryBattle()
    if self.Queue:GetSize()>0 then
        local value= self.Queue:DeQueueBack()
        self.CurBattle=value
        BattleDataManager:Get():SetRoomData(value, RaceModel.RaceSeniorTrain,true)
        local scenename = BattleDataManager:Get():GetSceneName()
        local trackdata = BattleDataManager:Get():GetTrackData()
        SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceSeniorTrain)
    end
end
function RaceSeniorTrainManager:BattleHistoryFinish()
    if self.Queue:GetSize()>0 then
        BattleDataManager:Get():SetStateBattleExit()
        self:FightBattle()
    else
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToChapter,RaceSeniorTrainManager:Get():GetCurLevelData().id)
        BattleDataManager:Get():SetStateBattleExit()
    end
end


---@param data  SC_BeginPve
function RaceSeniorTrainManager:BeginBattle(data)
    self.Queue = Queue()
    self.BattleResult={}
    if data.cars and #data.cars>=1 then
        self.BattleCount=#data.cars
        for i = 1, #data.cars do
            local temp={}
            temp.car=data.cars[i]
            temp.copyid=data.copyid
            temp.carid=data.carids[i]
            temp.starttime=data.starttime
            temp.curlevel=data.curlevel
            temp.idx=i
            self.Queue:EnQueueFront(temp)
        end
    else
        local temp={}
        temp.car=data.car
        temp.copyid=data.copyid
        temp.carid=data.carid
        temp.starttime=data.starttime
        temp.curlevel=data.curlevel
        temp.idx=1
        self.Queue:EnQueueFront(temp)
    end

    self:FightBattle()
end
function RaceSeniorTrainManager:FightBattle()
    if self.Queue:GetSize()>0 then
        local value= self.Queue:DeQueueBack()
        self.CurBattle=value
        BattleDataManager:Get():SetRoomData(value, RaceModel.RaceSeniorTrain)
        local scenename = BattleDataManager:Get():GetSceneName()
        local trackdata = BattleDataManager:Get():GetTrackData()
        SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceSeniorTrain)
    end
end

function RaceSeniorTrainManager:BattleFinish()
    if self.Queue:GetSize()>0 then
        BattleDataManager:Get():SetStateBattleExit()
        self:FightBattle()
    else
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceSeniorTrain,BattleDataManager:Get():GetLevelId())
        BattleDataManager:Get():SetStateBattleExit()
    end
end
---@param result BattleResultData
function RaceSeniorTrainManager:AddBattleResult(levelid,carid,isWin,time,curerror,result,starttime)
    local temp={}
    temp.levelid=levelid
    temp.carid=carid
    temp.isWin=isWin
    temp.time=time
    temp.error=curerror
    temp.result=result:Copy()
    temp.starttime=starttime
    table.insert(self.BattleResult,temp)
    self.lastFlag=RaceSeniorTrainManager:Get().Queue:GetSize()==0
    if self.lastFlag or isWin==0 then
        local caridx=""
        local time=""
        local error=""
        local starttime=""
        for i = 1, self.BattleCount do
            local temp=self.BattleResult[i]
            if i<self.BattleCount then
                if temp then
                    caridx=caridx..temp.carid..":"
                    time=time..temp.time..":"
                    error=error..temp.error..":"
                    starttime=starttime..temp.starttime..":"
                else
                    caridx=caridx.."0:"
                    time=time.."0:"
                    error=error.."0:"
                    starttime=starttime.."0:"
                end
            else
                if temp then
                    caridx=caridx..temp.carid
                    time=time..temp.time
                    error=error..temp.error
                    starttime=starttime..temp.starttime
                else
                    caridx=caridx.."0"
                    time=time.."0"
                    error=error.."0"
                    starttime=starttime.."0"
                end
            end

        end
        RaceSeniorTrainManager:Get().Queue:Clear()
        RaceSeniorTrainSubsystem:Get():SendMsg_BattleFinish(levelid,caridx,isWin,time,curerror,starttime)
    else
        BattleDataManager:Get():SetStateBattleResult()
    end
end
function RaceSeniorTrainManager:GetLastFlag()
    return self.lastFlag
end
function RaceSeniorTrainManager:GetBattleResult()
    return self.BattleResult
end