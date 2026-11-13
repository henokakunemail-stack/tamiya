--{{{ 排位赛数据
---@class RaceRankListPlayerData
RaceRankListPlayerData=class("RaceRankListPlayerData")
---@param data SC_RaceInfo
function RaceRankListPlayerData:initialize(data)
    self.PlayerId=data.rid
    self.PlayerName=data.rolename
    self.position=data.position
    self.Time=data.score
    self.car=CarData()
    if data.car then
        self.car:SetData(data.car)
    end
    self.testrace=data.testrace
    self.headicon=data.headicon
    self.iconframe=data.iconframe
end

---@class RaceRankData
RaceRankData = class("RaceRankData")

function RaceRankData:initialize()
    ---@type RaceRankRoomData
    self.RoomData = nil
    ---@type globalseason_config_cell
    self.SessionCfg = nil
    self.IsCloseSeason = false

    self.Score = -1
    ---@type table<number, RaceRankScoreRewardData>
    self.ScoreRewardList = {}
    ---@type table<table<number, RaceRankSpeedRankData>>
    self.SpeedRankList = {}
    ---@type table<number, RaceRankSpeedRankData>
    self.SelfSpeedRank = {}
    self.CurNum = 0 --当前挑战次数
    self.CurRlNum = 0 --当前挑战次数
    self.MaxNum = 0 --当前挑战次数
    self.CurTestNum = 0 --当前挑战次数
    self.MaxTestNum = 0 --当前挑战次数
    self.SelectPositionNum = 0 --选择出发赛道数
    self.SelectPositionMaxNum = 0 --选择出发赛道最大次数
    self.BeginTime=0
    self.EndTime=0
    ---@type table<number, RaceTrackData>
    self.TrackList = {}

    self.FightTime = -1
    self.ReadyEndTime = -1

    self.IsAgreeJoin = false
end
---@param msg SC_ReqSeasonInfo
function RaceRankData:SetData(msg)
    local seasonid = math.abs(msg.seasonid)
    local globalSeason=ClientDataManager:Get():GetDataTable(ConfigNames.globalseason_config)
    self.SessionCfg = globalSeason.GetDataBuyServerIdAndId(PlayerDataManager:Get():GetPlayerServerID(), seasonid)
    self.IsCloseSeason=self.SessionCfg==nil
    if self.SessionCfg == nil then
        logError("---   error:赛事配置表空，赛季id = ", seasonid)
        return
    end
    self.SessionList={}
    for i = seasonid, seasonid+4 do
      local cfg= globalSeason.GetDataBuyServerIdAndId(PlayerDataManager:Get():GetPlayerServerID(), i)
        if cfg and cfg.showflag==1 and seasonid==cfg.seasonid then
            table.insert(self.SessionList,cfg)
        end
    end
    self.curChallengeNum = msg.num

    self:SetTrackData(msg.trackid)
    self.SceneID=msg.scenceid
    self.RankIdx=msg.rankidx
    self.Score = msg.score
    self.CurNum=msg.curnum
    self.CurRlNum=msg.currlnum
    self.MaxNum=msg.maxnum
    self.CurTestNum=msg.testnum
    self.MaxTestNum=msg.maxtest
    self.BeginTime=msg.btime
    self.EndTime=msg.etime
    self.SelectPositionNum=msg.paynum
    self.SelectPositionMaxNum=msg.maxpaynum
    if msg.firstRacer then
        self.FastPlayerData=RaceRankListPlayerData(msg.firstRacer)
    end
    if msg.firstRLRacer then
        self.FastRlPlayerData=RaceRankListPlayerData(msg.firstRLRacer)
    end

   -- self:SetScoreRewardList(msg.rewardState)
end
function RaceRankData:SetTrackData(trackId)
    self.TrackData = CommonHelper:GetRacetrackData(trackId)
end

function RaceRankData:SetScoreRewardList(state)
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
function RaceRankData:UpdateScoreRewardState(idx, state)
    for i = 1, #self.ScoreRewardList do
        local data = self.ScoreRewardList[i]
        if data:GetIdx() == idx + 1 then
            data:UpdateState(self.Score, state)
            break
        end
    end
end

function RaceRankData:SetRoomData(msg, state)
    self.RoomData = RaceRankRoomData()
    self.RoomData:SetData(msg, state)
end
function RaceRankData:ClearRoomData()
    self.RoomData = nil
end
function RaceRankData:SetFightTime(time)
    self.FightTime = time
end
function RaceRankData:SetReadyEndTime(time)
    self.ReadyEndTime = time
end

---@param msg SC_GetGlobalRankRankInfoRes
function RaceRankData:SetSpeedRank(msg)
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
function RaceRankData:GetSpeedRank(trackid)
    if trackid and self.SpeedRankList[trackid] then
        return self.SpeedRankList[trackid]
    end
    return {}
end
function RaceRankData:GetSelfSpeedRank(trackid)
    if trackid and self.SelfSpeedRank[trackid] then
        return self.SelfSpeedRank[trackid]
    end
end
--}}}



--{{{ 排位赛房间数据
---@class RaceRankRoomData
RaceRankRoomData = class("RaceRankRoomData")

function RaceRankRoomData:initialize()
    self.State = SerE_RaceRankState.None
    self.SceneID = -1
    ---@type RaceTrackData
    self.TrackData = nil
    ---@type table<number, RaceRankPlayerData>
    self.PlayerList = {}
end
---@param msg SC_RankRoomInfo
function RaceRankRoomData:SetData(msg, state)
    self.TrackData = CommonHelper:GetRacetrackData(msg.trackId)
    self.SceneID = msg.sceneId
    self:SetPlayerList(msg, msg.carIdx)
    self.State = state
end

---@param msg SC_RankRoomInfo
function RaceRankRoomData:SetPlayerList(msg, selfCarid)
    self.PlayerList = {}
    for i = 1, #msg.playerInfos do
        local data = RaceRankPlayerData()
        data:SetData(msg.playerInfos[i], selfCarid)
        table.insert(self.PlayerList, data)
    end
    for i = 1, #msg.npcIds do
        local data = RaceRankPlayerData()
        data:SetNPC(msg.npcIds[i])
        table.insert(self.PlayerList, data)
    end
end
---@param msg table<number, SC_PartInfo>
function RaceRankRoomData:SetCarData(pid, msg)
    for i = 1, #self.PlayerList do
        local player = self.PlayerList[i]
        if player:GetPid() == pid then
            player:SetPlayerCarData(msg)
        end
    end
end
function RaceRankRoomData:SetPlayerReady(pid, ready)
    for i = 1, #self.PlayerList do
        local player = self.PlayerList[i]
        if player:GetPid() == pid then
            player:SetReady(ready)
        end
    end
end
function RaceRankRoomData:SetSelfCarId(caridx)
    local data = self:GetSelfPlayer()
    data:SetSelfCarId(caridx)
end
function RaceRankRoomData:GetTrackData()
    return self.TrackData
end
function RaceRankRoomData:GetSceneID()
    return self.SceneID
end
---@return table<number, RaceRankPlayerData>
function RaceRankRoomData:GetPlayerList()
    return self.PlayerList
end
---@return RaceRankPlayerData
function RaceRankRoomData:GetPlayerByIdx(idx)
    return self.PlayerList[idx]
end
---@return RaceRankPlayerData
function RaceRankRoomData:GetSelfPlayer()
    return self:GetPlayerById(PlayerDataManager:Get():GetPlayerUID())
end
---@return RaceRankPlayerData
function RaceRankRoomData:GetPlayerById(pid)
    for i = 1, #self.PlayerList do
        if self.PlayerList[i]:GetPid() == pid then
            return self.PlayerList[i]
        end
    end
    return nil
end
--}}}



--{{{ 排位赛玩家数据
---@class RaceRankPlayerData
RaceRankPlayerData = class("RaceRankPlayerData")
function RaceRankPlayerData:initialize()
    --基础数据
    self.Pid = -1
    self.Name = ""
    self.Icon = ""
    self.LV = -1

    self.Robot = false

    self.Ready = false

    ---@type CarReviewData
    self.CarData = nil

    self.SelfCarId = -1

    self.LoadingPreocess = 0

    self.RankScore = 0
end
function RaceRankPlayerData:IsRobot()
    return self.Robot
end
function RaceRankPlayerData:IsReady()
    return self.Ready
end
function RaceRankPlayerData:GetName()
    return self.Name
end
function RaceRankPlayerData:GetLV()
    return self.LV
end
function RaceRankPlayerData:GetIcon()
    return self.Icon
end
function RaceRankPlayerData:GetPid()
    return self.Pid
end
function RaceRankPlayerData:GetSelfCarId()
    return self.SelfCarId
end
function RaceRankPlayerData:GetRankScore()
    return self.RankScore
end
---@return CarReviewData
function RaceRankPlayerData:GetCarData()
    return self.CarData
end

---@param msg SC_RankRoomPlayerInfo
function RaceRankPlayerData:SetData(msg, selfCarid)
    self.Robot = false
    self.Pid = msg.playerInfo.pid
    self.Name = msg.playerInfo.name
    self.LV = msg.playerInfo.lv
    self.RankScore = msg.playerInfo.score
    self.Icon = CommonHelper:GetPlayerIconById(msg.playerInfo.head)
    self.Ready = msg.ready
    self.SelfCarId = selfCarid

    if PlayerDataManager:Get():GetPlayerUID() == msg.playerInfo.pid and selfCarid > -1 then
        local cardata = CarDataManager:Get():GetCarDataByCarID(selfCarid)
        self.CarData = CarReviewData()
        self.CarData:SetDataByCarData(cardata)
    else
        self.CarData = CarReviewData()
        self.CarData:SetDataByMsg(msg.partInfos)
    end

end
function RaceRankPlayerData:SetNPC(npcid)
    self.Pid = npcid
    self.Robot = true
    self.Ready = true

    ---@type npc_config_cell
    local npccfg = CommonHelper:GetTableDataByID(ConfigNames.npc_config, npcid)
    if npccfg then
        self.LV = npccfg.level
        self.RankScore = npccfg.scorce
    end

    self.Name, self.Icon = CommonHelper:AnalyseNPCNameAndIconById(npcid)
    self.CarData = CarReviewData()
    self.CarData:SetDataByNPC(npcid)
end
---@param msg table<number, SC_PartInfo>
function RaceRankPlayerData:SetPlayerCarData(msg)
    self.CarData = CarReviewData()
    self.CarData:SetDataByMsg(msg)
end
function RaceRankPlayerData:SetReady(state)
    self.Ready = state
end
function RaceRankPlayerData:SetSelfCarId(caridx)
    self.SelfCarId = caridx
end
--}}}







--{{{ 排位赛积分奖励
---@class RaceRankScoreRewardData
RaceRankScoreRewardData = class("RaceRankScoreRewardData")
function RaceRankScoreRewardData:initialize()
    self.State = -1 -- 0不能领    1可以领    2已领取
    self.Idx = -1
    self.Score = -1
    ---@type table<number, RewardData>
    self.RewardList = {}
end
function RaceRankScoreRewardData:InitData(myscore, state, cfgdata, idx)
    self.Idx = idx
    self.Score = cfgdata[1]
    self.RewardList = CommonHelper:ParseToReward2(cfgdata[2])

    local temp = CommonHelper:MathBitUtil_BitTrueInt(state, idx - 1)

    if myscore >= self.Score then
        if temp then
            self.State = 2
        else
            self.State = 1
        end
    else
        self.State = 0
    end
end
function RaceRankScoreRewardData:UpdateState(myscore, state)
    local temp = CommonHelper:MathBitUtil_BitTrueInt(state, self.Idx - 1)

    if myscore >= self.Score then
        if temp then
            self.State = 2
        else
            self.State = 1
        end
    else
        self.State = 0
    end
end
function RaceRankScoreRewardData:GetScore()
    return self.Score
end
function RaceRankScoreRewardData:GetState()
    return self.State
end
function RaceRankScoreRewardData:GetIdx()
    return self.Idx
end
---@return table<number, RewardData>
function RaceRankScoreRewardData:GetRewardList()
    return self.RewardList
end
--}}}




--{{{ 排位赛速度排行数据
---@class RaceRankSpeedRankData
RaceRankSpeedRankData = class("RaceRankSpeedRankData")
function RaceRankSpeedRankData:initialize()
    self.Rank = -1
    self.Pid = -1
    self.Name = ""
    self.Icon = ""
    self.Time = -1
    self.RecordId = 0
end
function RaceRankSpeedRankData:InitData(idx, msg)
    --msg由 socre,pid,icon,name拼接成
    local strs = stringSplit(msg, ',')
    self.Rank = idx
    self.Time = tonumber(strs[1])
    self.Pid = tonumber(strs[2])
    self.Icon = CommonHelper:GetPlayerIconById(tonumber(strs[3]))
    self.Name = strs[4]
    self.RecordId = tonumber(strs[5])
end

function RaceRankSpeedRankData:SetSelfData(rank, time)
    self.Rank = rank
    self.Time = time
    self.Pid = PlayerDataManager:Get():GetPlayerUID()
    self.Icon = CommonHelper:GetPlayerIconById(PlayerDataManager:Get():GetPlayerIcon())
    self.Name = PlayerDataManager:Get():GetPlayerName()
end
function RaceRankSpeedRankData:GetRank()
    return self.Rank
end
function RaceRankSpeedRankData:GetName()
    return self.Name
end
function RaceRankSpeedRankData:GetIcon()
    return self.Icon
end
function RaceRankSpeedRankData:GetTime()
    return self.Time
end
function RaceRankSpeedRankData:GetPid()
    return self.Pid
end
--}}}