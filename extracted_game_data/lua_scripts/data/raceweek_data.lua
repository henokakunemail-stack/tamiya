

--{{{ 周赛本人结算结果
---@class RaceWeekDataResult
RaceWeekDataResult = class("RaceWeekDataResult")
function RaceWeekDataResult:initialize()
    self.ScoreTips = ""
end
function RaceWeekDataResult:SetData(tips)
    self.ScoreTips = tips
end
--}}}



--{{{ 周赛玩家数据
---@class RaceWeekDataPlayer
RaceWeekDataPlayer = class("RaceWeekDataPlayer")
function RaceWeekDataPlayer:initialize()
    ---@type RaceDataPlayer
    self.BasePlayerData = RaceDataPlayer()
    ---@type RaceDataFightGroup
    self.FirstGroup = nil --第一轮
    ---@type RaceDataFightGroup
    self.SecondGroup = nil --第二轮
    ---@type RaceDataFightGroup
    self.ThirdGroup = nil --第三轮
end
---@param msg SC_AgainstPlayer
function RaceWeekDataPlayer:SetData(msg)
    self.BasePlayerData:SetDataRaceWeek(msg)
end

function RaceWeekDataPlayer:GetPlayerData() return self.BasePlayerData end
function RaceWeekDataPlayer:GetFirstGroup() return self.FirstGroup end
function RaceWeekDataPlayer:GetSecondGroup() return self.SecondGroup end
function RaceWeekDataPlayer:GetThirdGroup() return self.ThirdGroup end


function RaceWeekDataPlayer:SetFirstGroup(group) self.FirstGroup = group end
function RaceWeekDataPlayer:SetSecondGroup(group) self.SecondGroup = group end
function RaceWeekDataPlayer:SetThirdGroup(group) self.ThirdGroup = group end
--}}}


--{{{ 周赛数据
---@class RaceWeekData
RaceWeekData = class("RaceWeekData")

function RaceWeekData:initialize()
    --基础数据
    self.ServerID = -1
    ---@type championships_config_cell
    self.Cfg = nil
    self.JoinNum = -1
    ---@type table<number, RaceDataTime>
    self.DateList = {}
    self.IsJoin = false

    --扩展数据
    self.BuyNum = -1
    self.LastNum = -1
    self.CurState = RaceWeekState.None
    self.MyState = RaceWeekState.None
    ---@type RaceTrackData
    self.TrackData = nil
    ---@type RaceWeekDataPlayer
    self.Winer = nil  -- 赛事总冠军
    ---@type table<number, RaceWeekDataPlayer>
    self.PlayerList = {} --所有参赛者
    ---@type table<number, RaceDataFightGroup>
    self.FirstGroup = {} --第一轮
    ---@type table<number, RaceDataFightGroup>
    self.SecondGroup = {} --第二轮
    ---@type table<number, RaceDataFightGroup>
    self.ThirdGroup = {} --第三轮
    ---@type RaceWeekDataResult
    self.ResultData = nil --本人在本赛事中的结算数据
end


---@return table<number, RaceDataFightGroup>
function RaceWeekData:GetFirstGroup() return self.FirstGroup end
---@return table<number, RaceDataFightGroup>
function RaceWeekData:GetSecondGroup() return self.SecondGroup end
---@return RaceDataFightGroup
function RaceWeekData:GetFightGroupFinals() return self.ThirdGroup[1] end
---@return RaceWeekDataPlayer
function RaceWeekData:GetPlayerData(pid) return self.PlayerList[pid] end
---@return RaceWeekDataPlayer
function RaceWeekData:GetMyPlayerData() return self.PlayerList[PlayerDataManager:Get():GetPlayerUID()] end
function RaceWeekData:GetIsJoin() return self.IsJoin end
function RaceWeekData:GetServerID() return self.ServerID end
function RaceWeekData:GetName() return ClientDataManager:Get():GetTemplateString(self.Cfg.name) end
function RaceWeekData:GetRuleName() return ClientDataManager:Get():GetTemplateString(self.Cfg.rulename) end
function RaceWeekData:GetJoinNum() return self.JoinNum end
function RaceWeekData:GetEndTime() return self.DateList[3] end
function RaceWeekData:GetStartTime() return self.DateList[1] end
function RaceWeekData:GetDateTime(idx) return self.DateList[idx] end
function RaceWeekData:GetCfg() return self.Cfg end
function RaceWeekData:GetMyState() return self.MyState end
function RaceWeekData:GetCurState() return self.CurState end
function RaceWeekData:GetTrackData() return self.TrackData end
function RaceWeekData:GetWiner() return self.Winer end




function RaceWeekData:SetBaseData(id,isjoin, num)
    self.ServerID = id
    self.IsJoin = isjoin
    self.JoinNum = num

    self:AnalyseCfg()

end
function RaceWeekData:AnalyseCfg()

    local time = math.modf(self.ServerID * 0.01)
    local type = self.ServerID - time * 100
    --log("---   RaceWeekData:AnalyseCfg   ", self.ServerID, time, type)
    local datetime = CommonHelper:ConvertIntToDataTime(time)
    local hour = datetime.Hour
    local week = CommonHelper:GetDayOfWeekChina(false, datetime)
    ---@type championships_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.championships_config)
    if tab then
        self.Cfg = tab.GetWeekData(type, week, hour)
    end

    if self.Cfg then
        self:AnalyseDateList(time, self.Cfg.duration)
    else
        logError("---   error:championships_config = nil", type, week, hour)
    end
end
function RaceWeekData:AnalyseDateList(time, duration)
    local temp = {}
    table.insert(temp, time)
    table.insert(temp, time + duration * 60 * 1000)
    table.insert(temp, time + duration * 60 * 1000 * 2)
    self.DateList = {}
    for i = 1, #temp do
        local data = RaceDataTime()
        data:AnalyseMsgData(temp[i])
        table.insert(self.DateList, data)
    end
end
---@param msg SC_GetChampionshipsDetailRes
function RaceWeekData:SetDetailData(msg)
    if self.ServerID ~= msg.id then
        logError("---   error:SetDetailData   周赛id不一致", self.ServerID, msg.id)
        return
    end

    self.CurState = msg.state
    self.BuyNum = msg.buyNum
    self.LastNum = msg.lastNum

    self:AnalysePlayerList(msg)

    self:AnalyseGroup(1, msg.result1, self.FirstGroup)
    self:AnalyseGroup(2, msg.result2, self.SecondGroup)
    self:AnalyseGroup(3, msg.result3, self.ThirdGroup)

    self:AnalyseRaceResult()

    self:AnalyseMyResult()
end

---@param msg SC_GetChampionshipsDetailRes
function RaceWeekData:AnalysePlayerList(msg)
    self.PlayerList = {}
    for i = 1, #msg.result1 do
        local group = msg.result1[i]
        for m = 1, #group.players do
            local player = group.players[m]
            local playerdata = RaceWeekDataPlayer()
            self.PlayerList[player.pid] = playerdata
            playerdata:SetData(player)
        end
    end

    for i = 1, #msg.result2 do
        local group = msg.result2[i]
        for m = 1, #group.players do
            local player = group.players[m]
            local playerdata = RaceWeekDataPlayer()
            self.PlayerList[player.pid] = playerdata
            playerdata:SetData(player)
        end
    end

    for i = 1, #msg.result3 do
        local group = msg.result3[i]
        for m = 1, #group.players do
            local player = group.players[m]
            local playerdata = RaceWeekDataPlayer()
            self.PlayerList[player.pid] = playerdata
            playerdata:SetData(player)
        end
    end
end

---@param msg table<number,SC_AgainstInfo2>
function RaceWeekData:AnalyseGroup(idx, msg, Group)
    Group = {}
    for i = 1, #msg do
        local group = msg[i]
        local groupdata = RaceDataFightGroup()
        for m = 1, #group.players do
            local pid = group.players[m].pid
            local player = self:GetPlayerData(pid)
            groupdata:AddPlayer(player:GetPlayerData())
            if idx == 1 then player:SetFirstGroup(groupdata) end
            if idx == 2 then player:SetSecondGroup(groupdata) end
            if idx == 3 then player:SetThirdGroup(groupdata) end
        end

        groupdata:SetDataRaceWeek(i,  self.Cfg.NewRules[idx], group.recordId, group.winIds)
        Group[i] = groupdata
    end
end

function RaceWeekData:AnalyseRaceResult()
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

function RaceWeekData:AnalyseMyResult()

    --if self.IsJoin == false then
    --    self.MyState = RaceWeekState.None
    --    return
    --end

    if self.CurState == RaceWeekState.Join or self.CurState == RaceWeekState.First then
        self.MyState = self.CurState
        return
    end

    local playerdata = self:GetMyPlayerData()
    if playerdata == nil then
        logError("---   error:AnalyseMyResult   找不到自身玩家数据")
        return
    end


    if self.CurState == RaceWeekState.Result then
        self.MyState = RaceWeekState.Result
        self.ResultData = RaceWeekDataResult()

        if playerdata:GetSecondGroup() == nil then self.ResultData:SetData(playerdata, "第一轮被淘汰")
        elseif playerdata:GetThirdGroup() == nil then self.ResultData:SetData(playerdata, "第二轮被淘汰")
        else self.ResultData:SetData( "名次"..playerdata:GetPlayerData():GetRank())
        end
        return
    end


    if self.CurState == RaceWeekState.Second then
        local group = playerdata:GetSecondGroup()
        if group then
            self.MyState = RaceWeekState.Second
        else
            self.MyState = RaceWeekState.Result
            self.ResultData = RaceWeekDataResult()
            self.ResultData:SetData("第一轮被淘汰")
        end
        return
    end


    if self.CurState == RaceWeekState.Third then
        local group = playerdata:GetThirdGroup()
        if group then
            self.MyState = RaceWeekState.Third
        else
            self.MyState = RaceWeekState.Result
            self.ResultData = RaceWeekDataResult()
            self.ResultData:SetData("第二轮被淘汰")
        end
        return
    end


end

--}}}