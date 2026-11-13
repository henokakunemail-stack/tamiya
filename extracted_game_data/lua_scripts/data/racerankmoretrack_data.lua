--{{{ 排位赛数据
---@class RaceRankMoreTrackRankData
RaceRankMoreTrackRankData=class("RaceRankMoreTrackRankData")
---@param msg SC_NewRaceInfo
function RaceRankMoreTrackRankData:initialize(msg,rank)
    if msg then
        self.Rank=rank
        self.Rid=msg.rid
        self.Name=msg.rolename
        self.Position=msg.position
        self.Time=msg.score
        if msg.car then
            self.Car=CarReviewData
            self.Car:SetDataByMsg(msg.car)
        end
        self.TestRace=msg.testrace
        self.HeadIcon=msg.headicon
        self.IconFrame=msg.iconframe
        self.Op = msg.op
        self.Level = msg.curlev
        self.TittleBack = msg.titleback
        self.TitleCup = msg.titlecup
        self.TrackId = msg.trackid
    end
end
---@class RaceRankMoreTrackTrackData
RaceRankMoreTrackTrackData=class("RaceRankMoreTrackTrackData")
function RaceRankMoreTrackTrackData:initialize(type,msg,Index,trackdata)
   local strs= stringSplitToNumber(msg,':')
    self.RaceType=type
   self.TrackData= CommonHelper:GetRacetrackData(strs[1])
   self.RaceStyleType= strs[2]
   self.CarNum=trackdata[strs[1]][3]
   self.Index= Index
end


---@class RaceRankMoreTrackData
RaceRankMoreTrackData = class("RaceRankMoreTrackData")

function RaceRankMoreTrackData:initialize()
    ---@type dictrankseason_config_cell
    self.SessionCfg = nil
    self.IsCloseSeason = false
    self.Score = -1
    self.BeginTime=0
    self.EndTime=0
    ---@type table<number, RaceTrackData>
    self.RLTrackList = {}
    ---@type table<number, RaceTrackData>
    self.NormalTrackList = {}
    self.SceneID = 0
    self.SelectPositionNum = 0
    self.SelectPositionMaxNum = 0
    ---@type RaceRankMoreTrackRankData[][]
    self.FirstRacers={}
    ---@type RaceRankMoreTrackRankData[]
    self.TrackTimes={}
end
---@param msg SC_ReqSeasonInfo
function RaceRankMoreTrackData:SetData(msg)
    local seasonid = math.abs(msg.seasonid)
    self.SessionCfg = CommonHelper:GetTableDataByID(ConfigNames.dictrankseason_config,seasonid)
    self.IsCloseSeason=self.SessionCfg==nil
    if self.SessionCfg == nil then
        logError("---   error:赛事配置表空，赛季id = ", seasonid)
        return
    end
    self.Score = msg.score
    self.BeginTime=msg.btime
    self.EndTime=msg.etime
    self.SceneID = msg.scenceid
    self.SelectPositionNum = msg.paynum
    self.SelectPositionMaxNum = msg.maxpaynum
    self.TempTrackData={}
    local normalTrackIds=stringSplit(self.SessionCfg.trackids,';')
    local rlTrackIds=stringSplit(self.SessionCfg.rltrackids,';')
    for k, v in pairs(normalTrackIds) do
        local data= stringSplitToNumber(v,':')
        self.TempTrackData[data[1]]= data
    end
    for k, v in pairs(rlTrackIds) do
        local data= stringSplitToNumber(v,':')
        self.TempTrackData[data[1]]= data
    end
    for k, v in pairs(msg.nonrltrackids) do
        local temp=RaceRankMoreTrackTrackData(RaceProtectType.Normal,v,k,self.TempTrackData)
        table.insert(self.NormalTrackList,temp)
        self:AddSelfTrackData(temp.TrackData:GetId())
    end
    for k, v in pairs(msg.rltrackids) do
        local temp=RaceRankMoreTrackTrackData(RaceProtectType.Protect,v,#msg.nonrltrackids+k,self.TempTrackData)
        table.insert(self.RLTrackList,temp)
        self:AddSelfTrackData(temp.TrackData:GetId())
    end
    for k, v in pairs(msg.firstRacers) do
        local trackid=tonumber(v.trackid)
        if self.FirstRacers[trackid]==nil then
            self.FirstRacers[trackid]={}
        end
        table.insert(self.FirstRacers[trackid],RaceRankMoreTrackRankData(v,#self.FirstRacers[trackid]+1))
    end
    for k, v in pairs(msg.goodtracks) do
        if msg.goodtimes[tonumber(k)] and self.TrackTimes[tonumber(v)] then
            self.TrackTimes[tonumber(v)].Time=tonumber(msg.goodtimes[tonumber(k)])
        end
    end
end
function RaceRankMoreTrackData:SetTrackData(trackId)
    self.TrackData = CommonHelper:GetRacetrackData(trackId)
end
function RaceRankMoreTrackData:AddSelfTrackData(v)
    self.TrackTimes[v]=RaceRankMoreTrackRankData()
    self.TrackTimes[v].Rid=PlayerDataManager:Get():GetPlayerRID()
    self.TrackTimes[v].Name=PlayerDataManager:Get():GetPlayerName()
    self.TrackTimes[v].Position=0
    self.TrackTimes[v].Score=self.Score
    self.TrackTimes[v].HeadIcon=PlayerDataManager:Get():GetPlayerIcon()
    self.TrackTimes[v].IconFrame=PlayerDataManager:Get():GetPlayerIconFrame()
    self.TrackTimes[v].Level = PlayerDataManager:Get():GetPlayerLV()
    self.TrackTimes[v].TittleBack = PlayerDataManager:Get():GetBgId()
    self.TrackTimes[v].TitleCup = PlayerDataManager:Get():GetCups()
    self.TrackTimes[v].TrackId = v
end

function RaceRankMoreTrackData:SetScoreRewardList(state)
    self.ScoreRewardList = {}
    if self.SessionCfg then
        for i = 1, #self.SessionCfg.NewScoreReward do
            local cfg = self.SessionCfg.NewScoreReward[i]
            local data = RaceRankScoreRewardData()
            data:InitData(self.Score, state, cfg, i)
            table.insert(self.ScoreRewardList, data)
        end
    end
end
function RaceRankMoreTrackData:UpdateScoreRewardState(idx, state)
    for i = 1, #self.ScoreRewardList do
        local data = self.ScoreRewardList[i]
        if data:GetIdx() == idx + 1 then
            data:UpdateState(self.Score, state)
            break
        end
    end
end

function RaceRankMoreTrackData:SetRoomData(msg, state)
    self.RoomData = RaceRankRoomData()
    self.RoomData:SetData(msg, state)
end
function RaceRankMoreTrackData:ClearRoomData()
    self.RoomData = nil
end
function RaceRankMoreTrackData:SetFightTime(time)
    self.FightTime = time
end
function RaceRankMoreTrackData:SetReadyEndTime(time)
    self.ReadyEndTime = time
end

---@param msg SC_GetGlobalRankRankInfoRes
function RaceRankMoreTrackData:SetSpeedRank(msg)
    if msg == nil then
        return
    end
    ---@type table<number, RaceRankSpeedRankData>
    local list = {}
    for i = 1, #msg.rankInfos do
        local data = RaceRankSpeedRankData()
        data:InitData(i, msg.rankInfos[i])
        table.insert(list, data)
    end
    self.SpeedRankList[msg.trackId] = list

    local temp = true
    for i = 1, #list do
        if list[i]:GetPid() == PlayerDataManager:Get():GetPlayerUID() then
            self.SelfSpeedRank[msg.trackId] = list[i]
            temp = false
            break
        end
    end
    if temp then
        local data = RaceRankSpeedRankData()
        data:SetSelfData(msg.myRank, msg.myScore)
        self.SelfSpeedRank[msg.trackId] = data
    end
end
---@return table<number, RaceRankSpeedRankData>
function RaceRankMoreTrackData:GetSpeedRank(trackid)
    if trackid and self.SpeedRankList[trackid] then
        return self.SpeedRankList[trackid]
    end
    return {}
end
function RaceRankMoreTrackData:GetSelfSpeedRank(trackid)
    if trackid and self.SelfSpeedRank[trackid] then
        return self.SelfSpeedRank[trackid]
    end
end
--}}}