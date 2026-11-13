


---@class RaceSelfDataResult
RaceSelfDataResult = class("RaceSelfDataResult")

function RaceSelfDataResult:initialize()
    self.ScoreTips = ""
end
---@param tips RaceSelfResultFlag
---@param data RaceSelfDataPlayer
function RaceSelfDataResult:SetData(data, tips)
    if data then
        self.ScoreTips = CommonHelper:GetTempStr_RaceSelfResultTips(tips, data:GetRank())
    else
        self.ScoreTips = CommonHelper:GetTempStr_RaceSelfResultTips(tips, nil)
    end
end


---@class RaceSelfDataFightGroup
RaceSelfDataFightGroup = class("RaceSelfDataFightGroup")
function RaceSelfDataFightGroup:initialize()
    self.GroupIdx = -1
    self.SortIdx = -1
    self.RecordID = -1
    ---@type table<number, RaceSelfDataPlayer>
    self.Players = {}
    self.WinerID = -1
end


---@class RaceSelfDataPlayer
RaceSelfDataPlayer = class("RaceSelfDataPlayer")
function RaceSelfDataPlayer:initialize()
    ---@type RaceDataPlayer
    self.BasePlayerData = RaceDataPlayer()
    ---@type RaceDataFightGroup
    self.KnockoutGroup = nil --晋级赛
    ---@type RaceDataFightGroup
    self.SemiFinalGroup = nil --半决赛
    ---@type RaceDataFightGroup
    self.FinalsGroup = nil --决赛
end
---@param msg SC_SC_AuditionResult
function RaceSelfDataPlayer:SetData(msg)
    self.BasePlayerData:SetDataRaceSelf(msg)
end

function RaceSelfDataPlayer:GetPlayerData() return self.BasePlayerData end
function RaceSelfDataPlayer:GetPlayerID() return self.BasePlayerData:GetPlayerID() end
function RaceSelfDataPlayer:GetName() return self.BasePlayerData:GetName() end
function RaceSelfDataPlayer:GetIcon() return self.BasePlayerData:GetIcon() end
function RaceSelfDataPlayer:GetRank() return self.BasePlayerData:GetRank() end
function RaceSelfDataPlayer:GetTimeValue() return self.BasePlayerData:GetTimeValue() end

function RaceSelfDataPlayer:SetKnockoutGroup(group) self.KnockoutGroup = group end
function RaceSelfDataPlayer:SetSemiFinalGroup(group) self.SemiFinalGroup = group end
function RaceSelfDataPlayer:SetFinalsGroup(group) self.FinalsGroup = group end
function RaceSelfDataPlayer:GetKnockoutGroup() return self.KnockoutGroup end
function RaceSelfDataPlayer:GetSemiFinalGroup() return self.SemiFinalGroup end
function RaceSelfDataPlayer:GetFinalsGroup() return self.FinalsGroup end


---@class RaceSelfData
RaceSelfData = class("RaceSelfData")

function RaceSelfData:initialize()
    ----------基础数据
    self.ID = -1
    self.Creater = ""
    self.CreaterIcon = ""
    self.Name = ""
    self.RaceType = RaceSelfRule.Type2To1 --赛制
    self.JoinerMax = -1 --参赛人数
    ---@type table<number, RaceDataTime>
    self.DateList = {}
    self.Flag = RaceSelfFlag.All
    self.JoinNum = 0
    self.CostID = 0


    ----------扩展数据
    self.IsJoin = false --是否参加过这个赛事
    self.CurState = RaceSelfState.None --赛事当前阶段
    ---@type RaceTrackData
    self.TrackData = nil
    ---@type RaceSelfDataPlayer
    self.Winer = nil  -- 赛事总冠军
    ---@type table<number, RaceSelfDataPlayer>
    self.PlayerList = {} --海选赛总人数
    ---@type table<number, RaceDataFightGroup>
    self.FightGroupKnockout = {} --晋级赛组
    ---@type table<number, RaceDataFightGroup>
    self.FightGroupSemiFinal = {} --半决赛组
    ---@type RaceDataFightGroup
    self.FightGroupFinals = nil --决赛组


    self.MyState = RaceSelfState.None --我在赛事中所处阶段
    ---@type RaceSelfDataResult
    self.ResultData = nil --本人在本赛事中的结算数据
    self.SiftLimit = 0 --海选成功的名次条件
end



---@return RaceSelfDataPlayer
function RaceSelfData:GetPlayerData(pid) return self.PlayerList[pid] end
---@return RaceSelfDataPlayer
function RaceSelfData:GetMyPlayerData() return self.PlayerList[PlayerDataManager:Get():GetPlayerID()] end
---@return RaceTrackData
function RaceSelfData:GetTrackData() return self.TrackData end
---@return table<number, RaceSelfDataPlayer>
function RaceSelfData:GetPlayerList() return self.PlayerList end
---@return table<number, RaceDataFightGroup>
function RaceSelfData:GetFightGroupKnockout() return self.FightGroupKnockout end
---@return table<number, RaceDataFightGroup>
function RaceSelfData:GetFightGroupSemiFinal() return self.FightGroupSemiFinal end
---@return RaceDataFightGroup
function RaceSelfData:GetFightGroupFinals() return self.FightGroupFinals end
---@return RaceDataTime
function RaceSelfData:GetDateTime(idx) return self.DateList[idx] end
---@return RaceDataTime
function RaceSelfData:GetEndDateTime() return self.DateList[5] end
function RaceSelfData:GetSiftLimit() return self.SiftLimit end

function RaceSelfData:GetIsJoin() return self.IsJoin end
function RaceSelfData:GetRaceState() return self.CurState end
function RaceSelfData:GetWiner() return self.Winer end
function RaceSelfData:GetMyState() return self.MyState end
function RaceSelfData:GetResultScoreTips()
    if self.ResultData then
        return self.ResultData.ScoreTips
    end
    return ""
end



---@param msg SC_SC_MiniGameInfo
function RaceSelfData:SetMiniBaseData(msg)
    self.ID = msg.id
    self.Creater = msg.masterName
    self.CreaterIcon = CommonHelper:GetPlayerIconById(msg.icon)
    self.Name = msg.name
    self.JoinerMax = msg.maxNum --最大参赛人数

    self.RaceType = msg.enterNum --赛制
    self.SiftLimit = msg.enterNum * msg.enterNum * msg.enterNum
    self.Flag = msg.raceType
    self.CurState = msg.state
    self.JoinNum = msg.JoinNum --实际参赛人数
    self.CostID = msg.configId

    self:AnalyseTimes(msg.times)
end

---@param msg SC_SC_GameInfo
function RaceSelfData:SetData(msg)
    self.ID = msg.miniInfo.id
    self.Creater = msg.miniInfo.masterName
    self.CreaterIcon = CommonHelper:GetPlayerIconById(msg.miniInfo.icon)
    self.Name = msg.miniInfo.name
    self.JoinerMax = msg.miniInfo.maxNum --参赛人数
    self.JoinNum = msg.miniInfo.JoinNum --实际参赛人数
    self.CostID = msg.miniInfo.configId

    self.RaceType = msg.miniInfo.enterNum --赛制
    self.SiftLimit = msg.miniInfo.enterNum * msg.miniInfo.enterNum * msg.miniInfo.enterNum
    self.Flag = msg.miniInfo.raceType
    self.CurState = msg.miniInfo.state
    self.IsJoin = msg.isJoin
    self.TrackData = CommonHelper:GetRacetrackData(msg.trackId, msg.trackInfo)

    self:AnalyseTimes(msg.miniInfo.times)



end

function RaceSelfData:AnalyseTimes(times)
    local temp = {}
    table.insert(temp, times.num1)
    table.insert(temp, times.num2)
    table.insert(temp, times.num3)
    table.insert(temp, times.num4)
    table.insert(temp, times.num5)
    self.DateList = {}
    for i = 1, #temp do
        local data = RaceDataTime()
        data:AnalyseMsgData(temp[i])
        table.insert(self.DateList, data)
    end
end



---@param msg SC_SC_GetGameStageInfoRes
function RaceSelfData:AnalyseMsg(msg)

    ---------------------解析总人数
    self:AnalysePlayerList(msg)

    ---------------------解析晋级赛
    self:AnalyseGroupKnockout(msg)

    ---------------------解析半决赛
    self:AnalyseGroupSemiFinal(msg)

    ---------------------解析决赛
    self:AnalyseGroupFinals(msg)

    ---------------------解析赛事结果
    self:AnalyseRaceResult()

    self:AnalyseMyResult()
end

---@param msg SC_SC_GetGameStageInfoRes
function RaceSelfData:AnalysePlayerList(msg)---------------------解析总人数
    self.PlayerList = {}
    for i = 1, #msg.results do
        local player = msg.results[i]
        local playerdata = RaceSelfDataPlayer()
        self.PlayerList[player.result.pid] = playerdata
        playerdata:SetData(player)
    end
end

---@param msg SC_SC_GetGameStageInfoRes
function RaceSelfData:AnalyseGroupKnockout(msg)---------------------解析晋级赛
    self.FightGroupKnockout = {}
    for i = 1, #msg.againsInfos do
        local group = msg.againsInfos[i]
        local groupdata = RaceDataFightGroup()
        for m = 1, #group.players do
            local pid = group.players[m].pid
            local player = self:GetPlayerData(pid)
            groupdata:AddPlayer(player:GetPlayerData())
            player:SetKnockoutGroup(groupdata)
        end

        groupdata:SetDataRaceSelf(i,-1,  msg.gameInfo.miniInfo.enterNum, group.recordId, group.winId)
        self.FightGroupKnockout[i] = groupdata
    end
end

---@param msg SC_SC_GetGameStageInfoRes
function RaceSelfData:AnalyseGroupSemiFinal(msg)---------------------解析半决赛
    self.FightGroupSemiFinal = {}
    local count = #msg.PromotionInfos
    if count > msg.gameInfo.miniInfo.enterNum then count = msg.gameInfo.miniInfo.enterNum end

    for i = 1, count do
        local group = msg.PromotionInfos[i]
        local groupdata = RaceDataFightGroup()
        for m = 1, #group.playerIds do
            local pid = group.playerIds[m]
            local player = self:GetPlayerData(pid)
            groupdata:AddPlayer(player:GetPlayerData())
            player:SetSemiFinalGroup(groupdata)
        end

        groupdata:SetDataRaceSelf(-1, i, msg.gameInfo.miniInfo.enterNum, group.recordId, group.winId)
        self.FightGroupSemiFinal[i] = groupdata
    end
end

---@param msg SC_SC_GetGameStageInfoRes
function RaceSelfData:AnalyseGroupFinals(msg)---------------------解析决赛
    self.FightGroupFinals = nil
    local group = msg.PromotionInfos[msg.gameInfo.miniInfo.enterNum + 1]
    if group then
        local groupdata = RaceDataFightGroup()
        for m = 1, #group.playerIds do
            local pid = group.playerIds[m]
            local player = self:GetPlayerData(pid)
            groupdata:AddPlayer(player:GetPlayerData())
            player:SetFinalsGroup(groupdata)
        end

        groupdata:SetDataRaceSelf(-1,-1,msg.gameInfo.miniInfo.enterNum, group.recordId, group.winId)
        self.FightGroupFinals = groupdata
    end
end

function RaceSelfData:AnalyseRaceResult()
    local temp = nil
    local group = self:GetFightGroupFinals()
    if group then
        local winer = group:GetWiner()
        if winer then
            temp = winer
        end
    end
    self.Winer = temp
end

function RaceSelfData:AnalyseMyResult()

    if self.IsJoin == false then
        self.MyState = RaceSelfState.None
        return
    end

    if self.CurState == RaceSelfState.Join then
        self.MyState = RaceSelfState.Join
        return
    end

    if self.CurState == RaceSelfState.Select then
        self.MyState = RaceSelfState.Select
        return
    end

    local playerdata = self:GetMyPlayerData()
    if playerdata == nil then
        self.MyState = RaceSelfState.Result
        self.ResultData = RaceSelfDataResult()
        self.ResultData:SetData(nil, RaceSelfResultFlag.Fail_Knockout)
        return
    end


    if self.CurState == RaceSelfState.Result then
        self.MyState = RaceSelfState.Result
        self.ResultData = RaceSelfDataResult()
        self.ResultData:SetData(playerdata, RaceSelfResultFlag.Rank)
        if playerdata.KnockoutGroup == nil then self.ResultData:SetData(playerdata, RaceSelfResultFlag.Fail_Knockout)
        elseif playerdata.SemiFinalGroup == nil then self.ResultData:SetData(playerdata, RaceSelfResultFlag.Fail_SemiFinal)
        elseif playerdata.FinalsGroup == nil then self.ResultData:SetData(playerdata, RaceSelfResultFlag.Fail_Finals)
        end
        return
    end


    if self.CurState == RaceSelfState.Knockout then
        local group = playerdata.KnockoutGroup
        if group then
            self.MyState = RaceSelfState.Knockout
        else
            self.MyState = RaceSelfState.Result
            self.ResultData = RaceSelfDataResult()
            self.ResultData:SetData(playerdata, RaceSelfResultFlag.Fail_Knockout)
        end
        return
    end


    if self.CurState == RaceSelfState.SemiFinal then
        local group = playerdata.SemiFinalGroup
        if group then
            self.MyState = RaceSelfState.SemiFinal
        else
            self.MyState = RaceSelfState.Result
            self.ResultData = RaceSelfDataResult()
            self.ResultData:SetData(playerdata, RaceSelfResultFlag.Fail_SemiFinal)
        end
        return
    end


    if self.CurState == RaceSelfState.Finals then
        local group = playerdata.FinalsGroup
        if group then
            self.MyState = RaceSelfState.Finals
        else
            self.MyState = RaceSelfState.Result
            self.ResultData = RaceSelfDataResult()
            self.ResultData:SetData(playerdata, RaceSelfResultFlag.Fail_Finals)
        end
        return
    end
end





