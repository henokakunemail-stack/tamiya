local __instance
---@class RaceGVGManager
RaceGVGManager = class("RaceGVGManager")
function RaceGVGManager:initialize()
    ---@type RaceGVGData
    self.RankData = RaceGVGData()
end
---@return RaceGVGManager
function RaceGVGManager:Get()
    if __instance == nil then
        __instance = RaceGVGManager()
    end
    return __instance
end
---@param data SC_RetGvgPointInfo
function RaceGVGManager:SetData(data)
    self.RankData = RaceGVGData()
    self.RankData:SetData(data)
end

function RaceGVGManager:GetCurNum()
    return self.RankData.CurNum
end
function RaceGVGManager:GetMaxNum()
    return self.RankData.MaxNum
end
function RaceGVGManager:GetState()
    return self.RankData.State
end
function RaceGVGManager:SetState(state)
    if self.RankData==nil then
        self.RankData=RaceGVGData()
    end
    self.RankData.State=state
end

function RaceGVGManager:GetTrack()
    return self.RankData.TrackData
end
function RaceGVGManager:GetTrackId()
    return self.RankData.TrackId
end
function RaceGVGManager:GetSceneId()
    return self.RankData.SceneId
end
function RaceGVGManager:GetOpenSate()
    return self.RankData.OpenSate
end
function RaceGVGManager:GetBeginTime()
    return self.RankData.BeginTime
end
function RaceGVGManager:GetEndTime()
    return self.RankData.EndTime
end

function RaceGVGManager:GetCBeginTime()
    return self.RankData.CBeginTime
end
function RaceGVGManager:GetCEndTime()
    return self.RankData.CEndTime
end
function RaceGVGManager:GetScore()
    return self.RankData.Score
end
function RaceGVGManager:GetFastTime()
    return self.RankData.FastTime
end
function RaceGVGManager:GetSeasonId()
    return self.RankData.SeasonId
end
function RaceGVGManager:GetGuildId()
    return self.RankData.GuildId
end
function RaceGVGManager:GetGuildName()
    return self.RankData.GuildName
end
function RaceGVGManager:GetGuildIcon()
    return self.RankData.GuildIcon
end
function RaceGVGManager:GetGuildScore()
    return self.RankData.GuildScore
end
function RaceGVGManager:SetGuildScore(value)
    self.RankData.GuildScore=value
end
function RaceGVGManager:GetFGuildId()
    return self.RankData.FGuildId
end
function RaceGVGManager:GetFGuildName()
    return self.RankData.FGuildName
end
function RaceGVGManager:GetFGuildIcon()
    return self.RankData.FGuildIcon
end
function RaceGVGManager:GetFGuildScore()
    return self.RankData.FGuildScore
end
function RaceGVGManager:SetFGuildScore(value)
    self.RankData.FGuildScore=value
end
---是否可以报名
function RaceGVGManager:GetCanSign()
    return self.RankData.CanJoin==1
end
---是否已经报名
function RaceGVGManager:GetIsSign()
    return self.RankData.CanJoin==2 or self.RankData.CanJoin==3
end
function RaceGVGManager:GetMatchSuccess()
    return self.RankData.MatchSuccess
end
function RaceGVGManager:SetCanJoin(value)
    self.RankData.CanJoin=value
end
function RaceGVGManager:SetAddScore(value)
    self.AddScore=value
end
function RaceGVGManager:GetAddScore()
    return self.AddScore
end
function RaceGVGManager:SetRaceType(RaceType)
    self.RaceType=RaceType
end
function RaceGVGManager:GetRaceType()
    return self.RaceType
end
function RaceGVGManager:GetSigned()
    return self.RankData.MatchSuccess>0
end
function RaceGVGManager:NoSign()
    return self.RankData.CanJoin==4
end


---@param msg SC_RetGvgPointStart
function RaceGVGManager:BeginBattle(msg,isReplay)
    self.CurBattle=msg
    BattleDataManager:Get():SetRoomData(msg, RaceModel.RaceGVG,isReplay)
    local scenename = BattleDataManager:Get():GetSceneName()
    local trackdata = BattleDataManager:Get():GetTrackData()
    SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceGVG)
end
function RaceGVGManager:GetCurBattle()
    return self.CurBattle
end
function RaceGVGManager:FinishBattle(time,rank,error,sign)
        RaceGVGSubsystem:Get():SendMsg_FinishRace(time,error,rank)
end
function RaceGVGManager:BattleResult()
    BattleDataManager:Get():SetStateBattleResult()
end

function RaceGVGManager:CheckBattle(value)
    self.refight=value
end

function RaceGVGManager:ReFight()
    local result = self.refight==6
    if result then
        RaceGVGSubsystem:Get():SendMsg_ReFight()
    end
    return result
end
