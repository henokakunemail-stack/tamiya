
local __instance
---@class RaceTopSuperManager
RaceTopSuperManager = class("RaceTopSuperManager")
function RaceTopSuperManager:initialize()
    ---@type RaceTopData
    self.RaceData = RaceTopData()
end
---@return RaceTopSuperManager
function RaceTopSuperManager:Get()
    if __instance == nil then
        __instance = RaceTopSuperManager()
    end
    return __instance
end
---@param data SC_RetTopInfo
function RaceTopSuperManager:Init(data)
    ---@type RaceTopData
    self.RaceData = RaceTopData()
    self.RaceData:SetData(data)
end
function RaceTopSuperManager:GetSceneID()
    return self.RaceData.SceneId
end
function RaceTopSuperManager:GetSeasonId()
    return self.RaceData.SeasonId
end
function RaceTopSuperManager:GetCanJoin()
    return self.RaceData.CanJoin==1
end
function RaceTopSuperManager:GetTrackData()
    return self.RaceData.TrackData
end
function RaceTopSuperManager:GetOpenState()
    return self.RaceData.OpenState
end
function RaceTopSuperManager:GetStates()
    return self.RaceData.Status
end
function RaceTopSuperManager:GetRaceEndTime()
    return self.RaceData.RaceEndTime
end
function RaceTopSuperManager:GetRaceStateEndTime()
    return self.RaceData.StateEndTime
end
function RaceTopSuperManager:GetCurNum()
    return self.RaceData.CurNum
end
function RaceTopSuperManager:GetMaxNum()
    return self.RaceData.MaxNum
end
function RaceTopSuperManager:GetRaceType()
    return self.RaceType
end
function RaceTopSuperManager:GetSelfFirst()
    return self.RaceData.SelfScore
end
function RaceTopSuperManager:GetFirstRacer()
    return self.RaceData.FirstRacer
end
function RaceTopSuperManager:SetRaceType(RaceType)
    self.RaceType=RaceType
end
---@param msg SC_RetStart
function RaceTopSuperManager:BeginBattle(msg, isReplay)
    self.roomId=msg.roomid
    BattleDataManager:Get():SetRoomData(msg, RaceModel.RaceTopSuper,isReplay)
    local scenename = BattleDataManager:Get():GetSceneName()
    local trackdata = BattleDataManager:Get():GetTrackData()
    SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceTopSuper)
end

function RaceTopSuperManager:FinishBattle(time, rank, error, sign, startTime, recordValue)
    if self:GetRaceType()==RaceTopRaceType.Test then
        self:BattleResult()
    elseif self:GetRaceType()==RaceTopRaceType.RaceTop then
        RaceTopSuperSubsystem:Get():SendMsg_FinishBattleRaceTopTop(time,error,rank,startTime,recordValue)
    elseif self:GetRaceType()==RaceTopRaceType.Audition then
        RaceTopSuperSubsystem:Get():SendMsg_FinishBattleRaceTopAudition(time,error,rank,startTime,recordValue)
    elseif self:GetRaceType()==RaceTopRaceType.RaceB then
        RaceTopSuperSubsystem:Get():SendMsg_FinishBattleRaceTopB(time,error,rank,startTime,recordValue)
    elseif self:GetRaceType()==RaceTopRaceType.Record then
        self:BattleResult()
    end
    self.RaceType=nil
end
function RaceTopSuperManager:BattleResult()
    BattleDataManager:Get():SetStateBattleResult()
end
function RaceTopSuperManager:ClearData()

end
---@param msg SC_TopFightRank
function RaceTopSuperManager:SetGroupData(msg)
    self.RaceGroupData=RaceTopGroup()
    self.RaceGroupData:SetData(msg)
end
function RaceTopSuperManager:GetRaceGroupData()
    return self.RaceGroupData
end



function RaceTopSuperManager:CheckBattle(value)
    self.refight=value
end

function RaceTopSuperManager:ReEnterBattle()
    local result = self.refight==7
    if result then
        RaceTopSuperSubsystem:Get():SendMsg_ReFight()
    end
    return result
end
