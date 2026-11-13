---@class BattleResultPlayerData
BattleResultPlayerData = class("BattleResultPlayerData")

function BattleResultPlayerData:initialize()
    self.Pid = -1
    self.Rank = -1
    self.Name = ""
    self.Icon = ""
    self.IconFrame = ""
    self.ClubName = ""
    self.TrackIdx = -1
    self.Error = -1
    self.Time = -1
    self.CarPlanName = ""

    ---@type CarReviewData
    self.CarReviewData = nil

    self.RankScore = -1
end

function BattleResultPlayerData:GetPid()
    return self.Pid
end
function BattleResultPlayerData:GetRank()
    return self.Rank
end
function BattleResultPlayerData:GetName()
    return self.Name
end
function BattleResultPlayerData:GetPlayerType()
    return self.PlayerType
end

function BattleResultPlayerData:GetClubName()
    return self.ClubName
end
function BattleResultPlayerData:GetIcon()
    return self.Icon
end
function BattleResultPlayerData:GetIconFrame()
    if CommonHelper:IsNullOrEmpty(self.IconFrame) then
        return "player_kuangicon_1.png"
    end
    return self.IconFrame
end
function BattleResultPlayerData:GetTrackIdx()
    return self.TrackIdx
end
function BattleResultPlayerData:GetError()
    return self.Error
end
function BattleResultPlayerData:GetTime()
    return self.Time
end
function BattleResultPlayerData:GetCarReview()
    return self.CarReviewData
end
function BattleResultPlayerData:GetRankScore()
    return self.RankScore
end
function BattleResultPlayerData:GetCarPlanName()
    return self.CarPlanName
end

---@param data RaceHistoryPlayerData
function BattleResultPlayerData:SetDataByHistory(data)
    self.Pid = data:GetPid()
    self.Rank = data:GetRank()
    self.Name = data:GetName()
    self.Icon = data:GetIcon()
    self.IconFrame = data:GetIconFrame()
    self.ClubName = data:GetClubName()
    self.TrackIdx = data:GetTrackIdx()
    self.Error = data:GetError()
    self.Time = data:GetTime()

    self.CarReviewData = data:GetCarReviewData()

    self.RankScore = RaceRankManager:Get():GetScore()
end
---@param data Lua_PlayerInitData
function BattleResultPlayerData:SetDataByRackRankResult(pid, rank, trackidx, error, time, data)
    self.Pid = pid
    self.Rank = rank
    self.Name = data.Name
    self.Icon = data.Icon
    self.IconFrame = data.IconFrame
    self.PlayerType=data.PlayerType
    self.ClubName = ""
    self.TrackIdx = trackidx
    self.Error = error
    self.Time = time
    self.RankScore = RaceRankManager:Get():GetScore()
    self.CarReviewData = CarReviewData()
    self.CarReviewData:SetDataByLuaCarInitData(data.CarList[1])

    if pid == PlayerDataManager:Get():GetPlayerUID() then
        local temp = BattleDataManager:Get():GetPlayerData(PlayerDataManager:Get():GetPlayerUID())
        self.CarReviewData = CarReviewData()
        self.CarReviewData:SetDataByLuaCarInitData(temp.CarList[1])
    end

end
---@return BattleResultPlayerData
function BattleResultPlayerData:Copy()
    local temp=BattleResultPlayerData()
    temp.Pid = self.Pid
    temp.Rank = self.Rank
    temp.Name = self.Name
    temp.Icon = self.Icon
    temp.IconFrame = self.IconFrame
    temp.ClubName = ""
    temp.TrackIdx = self.TrackIdx
    temp.Error = self.Error
    temp.Time = self.Time
    temp.PlayerType=self.PlayerType
    temp.RankScore = RaceRankManager:Get():GetScore()
    temp.CarReviewData = self.CarReviewData
    return temp
end

---@class BattleResultData
BattleResultData = class("BattleResultData")

function BattleResultData:initialize()
    ---@type table<number, BattleResultPlayerData>
    self.PlayerList = {}--房间里面的玩家数据

    ---@type OtherResultData
    self.OtherResultData = nil  --如果战斗结束之后除了玩家数据，有额外的数据，设置这个，这个根据协议定,比如关卡的掉落

end

---@return table<number, BattleResultPlayerData>
function BattleResultData:GetPlayerList()
    return self.PlayerList
end

function BattleResultData:SortPlayerList()
    table.sort(self.PlayerList, function(a, b)
        return a:GetRank() < b:GetRank()
    end)
end

---@param data RaceHistoryData
function BattleResultData:AnalyseHistoryData(data)
    local list = data:GetPlayerList()
    for i = 1, #list do
        local temp = list[i]
        local player = BattleResultPlayerData()
        player:SetDataByHistory(temp)
        table.insert(self.PlayerList, player)
    end
end

function BattleResultData:AnalyseRaceResultData(data)
    for i = 0, data.Length - 1 do
        local temp = data[i]
        local pid = temp.pid
        local rank = temp.rank
        local time = temp.time
        local error = temp.error
        local trackidx = temp.trackidx
        local playerdata = BattleDataManager:Get():GetPlayerData(pid)
        local player = BattleResultPlayerData()
        if playerdata then
            player:SetDataByRackRankResult(pid, rank, trackidx, error, time, playerdata)
            table.insert(self.PlayerList, player)
        end
    end
end

---@param dropDown SC_SomeDown
function BattleResultData:SetOtherResultData(data, dropDown)
    --self.OtherResultData = data
    self.OtherResultData = {
        data = data,
        items = dropDown
    }
end
---@return OtherResultData
function BattleResultData:GetOtherResultData()
    return self.OtherResultData
end

---@param data @这里是c#传过来的结算数据，拿过来组装成了一份lua数据，如果有额外的数据，设置OtherResultData
function BattleResultData:SetPlayerListData(data)
    --if BattleDataManager:Get():IsReplay() then
    --    self:AnalyseHistoryData(data)
    --else
        self:AnalyseRaceResultData(data)
   -- end
    self:SortPlayerList()
end
---@param data @这里是c#传过来的结算数据，拿过来组装成了一份lua数据，如果有额外的数据，设置OtherResultData
function BattleResultData:Copy()
    local result=BattleResultData()
    for i = 1, #self.PlayerList do
        local temp=self.PlayerList[i]:Copy()
        table.insert(result.PlayerList,temp)
    end

        return result
end




















