---@class RaceCarGodDataManager
RaceCarGodDataManager = class("RaceCarGodDataManager")

-------------------------------------------------------------------------------------
---@class CarGodInfoData
CarGodInfoData = class("CarGodRankInfoData")
function CarGodInfoData:initialize()
    self.RankInfo = {}
    self.SeasonId = 0
    self.SceneId = 0
    self.TrackId = 0
    self.Speed = -1
    self.Awards = { }
end

---@param rankInfo SC_SeasonRanks
---
function CarGodInfoData:InitData(rankInfo, SelfInfo)

    local _msgJson = Dll_JSON.decode(rankInfo.rankinfo)
    self.RankInfo = RankingData()
    self.RankInfo:SetRankScoreData(_msgJson[1], _msgJson[2], _msgJson[3], _msgJson[4], _msgJson[5], _msgJson[6], _msgJson[7], _msgJson[8], _msgJson[9])
    self.SeasonId = rankInfo.seasonid
    self.SceneId = rankInfo.scenceid
    self.TrackId = rankInfo.trackid

    if SelfInfo ~= nil then
        for i, v in pairs(SelfInfo) do
            self.Speed = -1
            self.Awards = { }
            if v.seasonid == rankInfo.seasonid then
                self.Speed = tonumber(v.speed)
                self.Awards = stringSplitToNumber(v.awards, ':')
                break
            end
        end
    end

end

---@class OneCarGodInfoData
OneCarGodInfoData = class(" OneCarGodInfoData")
function OneCarGodInfoData:initialize()
    self.RankInfo = {}
    self.GodAwards = {}
    self.SeasonId = 0
    self.SceneId = 0
    self.Speed = -1
    self.Awards = { }
end

---@class GodAwardData
GodAwardData = class(" GodAwardData")
function GodAwardData:initialize()
    self.AwardID = 0
    self.RankID = 0
    self.Speed = 0
end

function GodAwardData:InitData(award)
    self.AwardID = award.awardid
    self.RankID = award.rankid
    self.Speed = award.speed
end


-------------------------------------------------------------------------------------

function RaceCarGodDataManager:initialize()
    self.GodInfoList = {}
end

---@return RaceCarGodDataManager
function RaceCarGodDataManager:Get()
    if self._instance == nil then
        self._instance = RaceCarGodDataManager()
    end
    return self._instance
end

---@param msg SC_GodInfo
function RaceCarGodDataManager:InitGodInfoData(msg)
    self.GodInfoList = {}

    for i = 1, #msg.ranks do
        local temp = CarGodInfoData()
        temp:InitData(msg.ranks[i], msg.mygods)
        table.insert(self.GodInfoList, temp)
    end

end

function RaceCarGodDataManager:GetGodInfoList()
    return self.GodInfoList
end

function RaceCarGodDataManager:GetGodInfoBySeasonId(seasonID)
    for i, v in pairs(self.GodInfoList) do
        if v.SeasonId == seasonID then
            return v
        end
    end

    return nil
end

function RaceCarGodDataManager:SetOneGodFinishAwardData(msg)
    self.FinshAwards = {}
    if msg.awards ~= nil then
        self.FinshAwards = stringSplitToNumber(msg.awards, ':')
    end
end

function RaceCarGodDataManager:GetOneGodFinishAwardData()
    return self.FinshAwards
end

---@param msg SC_OneGodInfo
function RaceCarGodDataManager:InitOneGodInfoData(msg)

    self.OneGodRankInfo = {}
    self.OneGodAwards = {}

    local _msgJson = Dll_JSON.decode(msg.ranks.rankinfo)
    for i, v in pairs(_msgJson) do
        local RankInfo = RankingData()
        RankInfo:SetRankScoreData(v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9])
        table.insert(self.OneGodRankInfo, RankInfo)
    end

    self.OneGodSeasonId = msg.seasonid
    self.OneGodSceneId = msg.ranks.scenceid
    self.OneGodTrackId = msg.ranks.trackid

    for i, v in pairs(msg.godawards) do
        local GodAwards = GodAwardData()
        GodAwards:InitData(v)
        table.insert(self.OneGodAwards, GodAwards)
    end

    self.OneGodSpeed = msg.mygod == nil and -1 or msg.mygod.speed
    self.OneGodMyAwards = msg.mygod == nil and 0 or msg.mygod.awards
end

function RaceCarGodDataManager:GetOneGodInfoRankData()
    return self.OneGodRankInfo
end

function RaceCarGodDataManager:GetOneGodInfoAwardData()
    return self.OneGodAwards
end

function RaceCarGodDataManager:GetOneGodInfoSeasonId()
    return self.OneGodSeasonId
end

function RaceCarGodDataManager:GetOneGodInfoSceneId()
    return self.OneGodSceneId
end

function RaceCarGodDataManager:GetOneGodInfoTrackId()
    return self.OneGodTrackId
end

---@param data  SC_BeginPve
function RaceCarGodDataManager:BeginBattle(data, isReplay)
    self.PlayerTime=0
    self.Queue = Queue()
    self.BattleResult = {}
    if #data.cars >= 1 then
        self.BattleCount = #data.cars
        for i = 1, #data.cars do
            local temp = {}
            temp.car = data.cars[i]
            temp.copyid = data.copyid
            temp.carid = data.carids[i]
            temp.starttime = data.starttime
            temp.curlevel = data.curlevel
            temp.idx = i
            self.Queue:EnQueueFront(temp)
        end
    else
        self.BattleCount = 1
        local temp = {}
        temp.car = data.car
        temp.copyid = data.copyid
        temp.carid = data.carid
        temp.starttime = data.starttime
        temp.curlevel = data.curlevel
        temp.idx = 1
        self.Queue:EnQueueFront(temp)
    end

    self:FightBattle()
end
function RaceCarGodDataManager:FightBattle()
    if self.Queue:GetSize() > 0 then
        local value = self.Queue:DeQueueBack()
        self.CurBattle = value
        BattleDataManager:Get():SetRoomData(value, RaceModel.RaceCarGod)
        local scenename = BattleDataManager:Get():GetSceneName()
        local trackdata = BattleDataManager:Get():GetTrackData()
        SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceCarGod)
    end
end

function RaceCarGodDataManager:BattleFinish()
    if self.Queue:GetSize() > 0 then
        BattleDataManager:Get():SetStateBattleExit()
        self:FightBattle()
    else
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceCarGod, BattleDataManager:Get():GetLevelId())
        BattleDataManager:Get():SetStateBattleExit()
    end
end
---@param result BattleResultData
function RaceCarGodDataManager:AddBattleResult(levelid, carid, isWin, time, curerror, result, starttime, recordValue)
    self.PlayerTime=self.PlayerTime+time
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
    self.lastFlag = RaceCarGodDataManager:Get().Queue:GetSize() == 0
    if self.lastFlag or isWin == 0 then
        local caridx = ""
        local time = ""
        local error = ""
        local starttime = ""
        local rank = ""
        local recordValue = ""
        for i = 1, self.BattleCount do
            local temp = self.BattleResult[i]
            if i < self.BattleCount then
                if temp then
                    caridx = caridx .. temp.carid .. ":"
                    time = time .. temp.time .. ":"
                    error = error .. temp.error .. ":"
                    starttime = starttime .. temp.starttime .. ":"
                    recordValue = recordValue .. temp.recordValue .. ":"
                    local playerList = temp.result:GetPlayerList()
                    local tempRank = 0
                    for i, v in ipairs(playerList) do
                        if PlayerDataManager:Get():GetPlayerRID() == playerList[i].Pid then
                            tempRank = playerList[i].Rank
                            rank = rank .. tempRank .. ":"
                            break
                        end
                    end
                else
                    caridx = caridx .. "0:"
                    time = time .. "0:"
                    error = error .. "0:"
                    starttime = starttime .. "0:"
                    rank = rank .. "0:"
                    recordValue = recordValue .. "0:"
                end
            else
                if temp then
                    caridx = caridx .. temp.carid
                    time = time .. temp.time
                    error = error .. temp.error
                    starttime = starttime .. temp.starttime
                    recordValue = recordValue .. temp.recordValue
                    local playerList = temp.result:GetPlayerList()
                    local tempRank = 0
                    for i, v in ipairs(playerList) do
                        if PlayerDataManager:Get():GetPlayerRID() == playerList[i].Pid then
                            tempRank = playerList[i].Rank
                            rank = rank .. tempRank
                            break
                        end
                    end
                else
                    caridx = caridx .. "0"
                    time = time .. "0"
                    error = error .. "0"
                    starttime = starttime .. "0"
                    recordValue = recordValue .. "0"
                    rank = rank .. "0"
                end
            end

        end
        RaceCarGodDataManager:Get().Queue:Clear()
        RaceCarGodSubsystem:Get():SendMsg_GodFinish(levelid, caridx, isWin, time, curerror, starttime, rank, recordValue)
    else
        BattleDataManager:Get():SetStateBattleResult()
    end
end
function RaceCarGodDataManager:GetLastFlag()
    if self.lastFlag == nil then
        return true
    end
    return self.lastFlag
end
function RaceCarGodDataManager:GetBattleResult()
    return self.BattleResult
end

---@param data  PVEChapterRankData
function RaceCarGodDataManager:BeginHistoryBattle(copyid, data)
    self.Queue = Queue()
    if #data.CarList >= 1 then
        self.BattleCount = #data.CarList
        for i = 1, #data.CarList do
            local temp = {}
            temp.copyId = copyid
            temp.carData = data
            temp.isHistory = true
            temp.seed = data.Seeds[i]
            temp.selfCarID = data.pid
            temp.StartTime = data.StarTimes[i]
            if data.Stops then
                temp.Stop = data.Stops[i]
            end
            temp.idx = i
            self.Queue:EnQueueFront(temp)
        end
    end
    self:FightHistoryBattle()
end
function RaceCarGodDataManager:FightHistoryBattle()
    if self.Queue:GetSize() > 0 then
        local value = self.Queue:DeQueueBack()
        self.CurBattle = value
        PlayerPrefsHelper:SetValue_SelfCountDownBtnUpTime(self.CurBattle.StartTime)
        if self.CurBattle.Stop == "0" or CommonHelper:IsNullOrEmpty(self.CurBattle.Stop) then
            PlayerPrefsHelper:SetValue_ReplayInputInfos("")
        else
            PlayerPrefsHelper:SetValue_ReplayInputInfos(self.CurBattle.Stop)
        end
        BattleDataManager:Get():SetRoomData(value, RaceModel.RaceCarGod, true)
        local scenename = BattleDataManager:Get():GetSceneName()
        local trackdata = BattleDataManager:Get():GetTrackData()
        SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceCarGod)
    end
end
function RaceCarGodDataManager:BattleHistoryFinish()
    self.lastFlag = RaceCarGodDataManager:Get().Queue:GetSize() == 0
    if self.Queue:GetSize() > 0 then
        BattleDataManager:Get():SetStateBattleExit()
        self:FightHistoryBattle()
    else
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceCarGod, BattleDataManager:Get():GetLevelId())
        BattleDataManager:Get():SetStateBattleExit()
    end
end



































-------   PVE   ------------------------------------------------------------------------------------

---@class NewCarGodInfoData
NewCarGodInfoData = class("NewCarGodInfoData")

function NewCarGodInfoData:initialize()
    self.copyid = 0    --已经解锁关卡id
    self.star = {}
    self.fasttime = 0 --时间
    self.todynum = 0    --今日通关次数
    self.winsum = 0
    self.unlock = 0 --副本是否解锁
    self.btime = 0
    self.awards = {}
    self.titleID = 0    --已经解锁关卡id
end

function NewCarGodInfoData:InitData(msg,i)
    self.copyid = msg.copyid
    self.star = msg.star
    self.fasttime = msg.fasttime
    self.todynum = msg.todynum
    self.winsum = msg.winsum
    self.unlock = msg.unlock
    self.btime = msg.btime
    self.awards = msg.awards
    self.titleID = i   --关卡名称id
end

-----@class NewOneCarGodInfoData
NewOneCarGodInfoData = class("NewOneCarGodInfoData")

function NewOneCarGodInfoData:initialize()
    self.copyID = 0
    self.goods = {}
    self.trackID = nil
    self.sceneID = nil
    self.fastTime = 0
end

function NewOneCarGodInfoData:InitData(levelData, taskData)
    if levelData then
        self.copyID = levelData.C_ID
        ---@type dictcopy_config_cell
        self.LevelData=levelData
        for i, v in pairs(taskData) do
            local goodsIDs = stringSplitToNumber(v.goodsids, ':')
            local goodsNums = stringSplitToNumber(v.goodsnums, ':')
            table.insert(self.goods, { ids = goodsIDs, nums = goodsNums, succVal = tonumber(v.succval) })
        end
        ---@type PVELevelBattleData[]
        self.BattleInfoList= self.LevelData.BattleInfoList
    end
end

function RaceCarGodDataManager:InitPVEGodInfoData(msg)

    self.NewGodInfoList = {}
    self.chapterid = msg.chapterid

    for i, v in pairs(msg.copys) do
        local temp = NewCarGodInfoData()
        temp:InitData(v,i)
        table.insert(self.NewGodInfoList, temp)
    end

end

function RaceCarGodDataManager:GetPVEGodInfoData()
    return self.NewGodInfoList
end

function RaceCarGodDataManager:GetPVEGodInfoDataByCopyID(ID)
    for i, v in pairs(self.NewGodInfoList) do
        if v.copyid == ID then
            return v
        end
    end
end

function RaceCarGodDataManager:InitPVEGodSectionData()
    ---@type NewOneCarGodInfoData[]
    self.SectionData = {}

    for i, v in pairs(self.NewGodInfoList) do
        local levelData = CommonHelper:GetTableDataByID(ConfigNames.pvelevel_config, v.copyid)
        local taskData = ClientDataManager:Get():GetDataTable(ConfigNames.dictactivecopytask_config).GetTaskListByCopyId(v.copyid)
        local temp = NewOneCarGodInfoData()
        temp:InitData(levelData, taskData)
        table.insert(self.SectionData, temp)
    end
end

function RaceCarGodDataManager:GetPVEGodSectionData()
    return self.SectionData
end

function RaceCarGodDataManager:GetPVEGodSectionDataByID(id)
    for i, v in pairs(self.SectionData) do
        if v.copyID == id then
            return v
        end
    end
end

function RaceCarGodDataManager:SetNewOneGodRankInfo(msg)
    self.NewOneGodRankInfo = {}

    local _msgJson = Dll_JSON.decode(msg.rankjson)
    for i, v in pairs(_msgJson) do
        local RankInfo = RankingData()
        RankInfo:SetRankScoreData(v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9])
        table.insert(self.NewOneGodRankInfo, RankInfo)
    end

end

function RaceCarGodDataManager:GetNewOneGodRankInfo()
    return self.NewOneGodRankInfo
end

function RaceCarGodDataManager:SetNewOneGodRankCopyID(dataID)
    self.NewOneGodRankCopyID = dataID
end

function RaceCarGodDataManager:GetNewOneGodRankCopyID()
    return self.NewOneGodRankCopyID
end

function RaceCarGodDataManager:SetNewOneGodCopyID(CopyID)
    self.NewOneGodCopyID = CopyID
end

function RaceCarGodDataManager:GetNewOneGodCopyID()
    return self.NewOneGodCopyID
end
