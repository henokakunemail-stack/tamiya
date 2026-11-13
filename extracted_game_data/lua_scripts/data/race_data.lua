


--{{{ 赛事时间数据
---@class RaceDataTime
RaceDataTime = class("RaceDataTime")

function RaceDataTime:initialize()
    self.Year = 0
    self.Month = 0
    self.Day = 0
    self.Hour = 0
    self.Minute = 0
    self.Week = 0


end
function RaceDataTime:AnalyseMsgData(data)
    local datetime = CommonHelper:ConvertIntToDataTime(data)
    self.Year = datetime.Year
    self.Month = datetime.Month
    self.Day = datetime.Day
    self.Hour = datetime.Hour
    self.Minute = datetime.Minute
    self.Week = CommonHelper:GetDayOfWeek(false, datetime)

end
--}}}

--{{{赛事数据，历史记录中玩家信息
---@class RaceHistoryPlayerData
RaceHistoryPlayerData = class("RaceHistoryPlayerData")
function RaceHistoryPlayerData:initialize()
    self.pid = -1
    self.name = ""
    self.icon = ""
    self.level = 0
    self.carplanname = ""
    ---@type table<number,string>
    self.attr = {}
    ---@type CarReviewData
    self.CarReviewData = nil
    self.trackId = -1
    self.rank = -1
    self.time = -1
    self.error = -1
    self.PVPScoreOld = -1
    self.PVPScoreDelta = -1
end
---@param msg SC_RcPlayer
function RaceHistoryPlayerData:SetData(msg, type)
    self.pid = msg.pid
    if msg.pid < 100000000 then -- pid小于1亿 npc
        self.name, self.icon = CommonHelper:AnalyseNPCNameAndIconById(msg.pid)
        self.CarReviewData = CarReviewData()
        self.CarReviewData:SetDataByNPC(msg.pid)
    else
        self.name = msg.name
        self.icon = CommonHelper:GetPlayerIconById(msg.icon)
        self.iconFrame = CommonHelper:GetPlayerIconById(msg.iconframe,nil,HeadIconAttrType.Frame)
        self.CarReviewData = CarReviewData()
        self.CarReviewData:SetDataByMsg(msg.partInfos)
    end
    ---@type table<number,number>
    self.attr = msg.attr
    self.trackId = msg.trackId
    self.rank = msg.rank
    self.time = msg.time
    self.error = msg.error
    if type == SerE_RaceHistoryModuleType.Rank then
        self.PVPScoreOld = -1
        self.PVPScoreDelta = tonumber(msg.para1)
        self.carplanname = msg.para2
    end

    --log("--------------   (((((((((((((((",self.pid ,self.name ,self.rank , self.error, self.PVPScoreDelta)
end
function RaceHistoryPlayerData:GetPid() return self.pid end
function RaceHistoryPlayerData:GetName() return self.name end
function RaceHistoryPlayerData:GetIcon() return self.icon end
function RaceHistoryPlayerData:GetIconFrame() return self.iconFrame end
function RaceHistoryPlayerData:GetRank() return self.rank end
function RaceHistoryPlayerData:GetClubName() return "" end
function RaceHistoryPlayerData:GetTrackIdx() return self.trackId end
function RaceHistoryPlayerData:GetTime() return self.time end
function RaceHistoryPlayerData:GetError() return self.error end
function RaceHistoryPlayerData:GetCarReviewData() return self.CarReviewData end
function RaceHistoryPlayerData:GetAttr() return self.attr end
function RaceHistoryPlayerData:GetShellId()
    local cfg = self.CarReviewData:GetShellCfg()
    return cfg.id
end
--}}}

--{{{赛事数据，历史记录
---@class RaceHistoryData
RaceHistoryData = class("RaceHistoryData")
function RaceHistoryData:initialize()
    self.ID = 0
    self.LeaderID = 0
    self.RoomName = ""
    self.NumMax = 0
    self.RaceType = 0
    self.Round = 0
    ---@type RaceTrackData
    self.TrackData = nil
    self.ModuleType = 0

    self.SceneID = 0
    self.Seed = 0
    ---@type table<number, RaceHistoryPlayerData>
    self.PlayerList = {}
end
---@param msg SC_RaceRecordInfo
function RaceHistoryData:SetData(msg, type)
    local temp = stringSplit(msg.paras, '@')
    self.ID = msg.id
    self.LeaderID = tonumber(temp[1])
    self.RoomName = temp[2]
    self.NumMax = msg.maxNum
    self.RaceType = msg.raceType
    self.ModuleType = type
    self.TrackID = msg.trackId
    self.Round = msg.allRound
    self.JoinTime = msg.time
    self.Seed = msg.seed

    self.SceneID = msg.sceneId

    self.PlayerList = {}
    for i = 1, #msg.rcPlayers do
        local data = RaceHistoryPlayerData()
        data:SetData(msg.rcPlayers[i], self.ModuleType)
        table.insert(self.PlayerList, data)
    end

    self.TrackData = CommonHelper:GetRacetrackData(msg.trackId, msg.trackInfo)

    table.sort(self.PlayerList,function (a, b)
        return a.rank < b.rank
    end)
end

function RaceHistoryData:GetPid() return self.ID end
function RaceHistoryData:GetPlayerList() return self.PlayerList end
---@return RaceHistoryPlayerData
function RaceHistoryData:GetPlayerByIdx(idx) return self.PlayerList[idx] end
function RaceHistoryData:GetPlayerNum() return #self.PlayerList end
function RaceHistoryData:GetTrackData() return self.TrackData end
---@return RaceHistoryPlayerData
function RaceHistoryData:GetMyPlayerData()
    local result = nil
    for i = 1, #self.PlayerList do
        local temp = self.PlayerList[i]
        if temp.pid == PlayerDataManager:Get():GetPlayerUID() then
            result = temp
            break
        end
    end
    return result
end
---@return RaceHistoryPlayerData
function RaceHistoryData:GetPlayerByPid(pid)
    local result = nil
    for i = 1, #self.PlayerList do
        local temp = self.PlayerList[i]
        if temp.pid == pid then
            result = temp
            break
        end
    end
    return result
end
--}}}

--{{{赛事数据，对战组
---@class RaceDataFightGroup
RaceDataFightGroup = class("RaceDataFightGroup")
function RaceDataFightGroup:initialize()
    self.ModuleType = nil

    self.AreaIdx = -1
    self.GroupIdx = -1
    self.Idx = -1

    self.ID = -1  -- 唯一ID
    self.RecordID = -1 -- 录像ID
    ---@type table<number, RaceDataPlayer>
    self.Players = {}
    self.WinerList = {}

    self.JoinCount = -1--赛制参数
    self.WinerCount = -1--赛制参数

    self.State = RaceFightGroupState.Fighting
end

function RaceDataFightGroup:GetPlayerList() return self.Players end
function RaceDataFightGroup:GetJoinCount() return self.JoinCount end
function RaceDataFightGroup:GetWinerCount() return self.WinerCount end

function RaceDataFightGroup:SetBaseData(recordid)
    self.RecordID = recordid
end

function RaceDataFightGroup:SetGroup(idx, idx2)
    local joinnum = self.JoinCount
    if idx > 0 then
        local temp = idx % joinnum
        if temp == 0 then temp = joinnum end
        self.Idx = temp
        self.GroupIdx = math.ceil(idx / joinnum)
    end

    if idx2 > 0 then
        self.Idx = 1
        self.GroupIdx = idx2
    end
end

function RaceDataFightGroup:SetDataRaceSelf(idx, idx2, racetype, recordid, winid)
    self:SetBaseData(recordid)
    self.WinerList = {winid}
    self.JoinCount = racetype
    self.WinerCount = 1

    self:SetGroup(idx, idx2)

    if winid > 0 then
        self.State = RaceFightGroupState.End
    else
        self.State = RaceFightGroupState.Fighting
    end
end

function RaceDataFightGroup:SetDataRaceWeek(idx, rule, recordid, winlist)
    self:SetBaseData(recordid)
    self.WinerList = winlist

    local temp = stringSplitToNumber(rule, ',')
    self.JoinCount = temp[1]--赛制
    self.WinerCount = temp[2]--赛制

    self:SetGroup(idx, 999)
end

---@param data RaceDataPlayer
function RaceDataFightGroup:AddPlayer(data)
    table.insert(self.Players, data)
end

---@return RaceDataPlayer
function RaceDataFightGroup:GetWiner()
    if self.WinerList and #self.WinerList == 1 then
        for i = 1, #self.Players do
            if self.Players[i].PlayerID == self.WinerList[1] then
                return self.Players[i]
            end
        end
    end
    return nil
end

---@return table<number, RaceDataPlayer>
function RaceDataFightGroup:GetWinerList()
    local result = {}
    if self.WinerList then
        for i = 1, #self.Players do
            local player = self.Players[i]
            for m = 1, #self.WinerList do
                local winid = self.WinerList[m]
                if player.PlayerID == winid then
                    table.insert(result, player)
                end
            end
        end
    end
    return result
end
--}}}

--{{{赛事数据，对战组内玩家基础数据
---@class RaceDataPlayer
RaceDataPlayer = class("RaceDataPlayer")
function RaceDataPlayer:initialize()
    self.PlayerID = 0
    self.Name = ""
    self.ClubName = ""
    self.Icon = ""
    self.Rank = 0
    self.TimeValue = 0
    self.ScoreTips = ""
end
function RaceDataPlayer:GetPlayerID() return self.PlayerID end
function RaceDataPlayer:GetName() return self.Name end
function RaceDataPlayer:GetClubName() return self.ClubName end
function RaceDataPlayer:GetIcon() return self.Icon end
function RaceDataPlayer:GetRank() return self.Rank end
function RaceDataPlayer:GetTimeValue() return self.TimeValue end
function RaceDataPlayer:GetScoreTips() return self.ScoreTips end


---@param msg SC_SC_AuditionResult
function RaceDataPlayer:SetDataRaceSelf(msg)
    self.PlayerID = msg.result.pid
    self.Name = msg.name
    self.Icon = msg.icon
    self.Rank = msg.result.raceResult.rank
    self.TimeValue = msg.result.raceResult.time
end
---@param msg SC_AgainstPlayer
function RaceDataPlayer:SetDataRaceWeek(msg)
    self.PlayerID = msg.pid
    self.Name = msg.name
    self.Icon = msg.icon
end
function RaceDataPlayer:SetRaceWeekRank(rank)
    self.Rank = rank
end
--}}}