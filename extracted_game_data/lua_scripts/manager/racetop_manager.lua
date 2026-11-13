
local __instance
---@class RaceTopManager
RaceTopManager = class("RaceTopManager")
function RaceTopManager:initialize()
    ---@type RaceTopData
    self.RaceData = RaceTopData()
end
---@return RaceTopManager
function RaceTopManager:Get()
    if __instance == nil then
        __instance = RaceTopManager()
    end
    return __instance
end
---@param data SC_RetTopInfo
function RaceTopManager:Init(data)
    ---@type RaceTopData
    self.RaceData = RaceTopData()
    self.RaceData:SetData(data)
end
function RaceTopManager:GetSceneID()
    return self.RaceData.SceneId
end
function RaceTopManager:GetSeasonId()
    return self.RaceData.SeasonId
end
function RaceTopManager:GetCanJoin()
    return self.RaceData.CanJoin==1
end
function RaceTopManager:GetTrackData()
    return self.RaceData.TrackData
end
function RaceTopManager:GetOpenState()
    return self.RaceData.OpenState
end
function RaceTopManager:GetStates()
    return self.RaceData.Status
end
function RaceTopManager:GetRaceEndTime()
    return self.RaceData.RaceEndTime
end
function RaceTopManager:GetRaceStateEndTime()
    return self.RaceData.StateEndTime
end
function RaceTopManager:GetCurNum()
    return self.RaceData.CurNum
end
function RaceTopManager:GetMaxNum()
    return self.RaceData.MaxNum
end
function RaceTopManager:GetRaceType()
    return self.RaceType
end
function RaceTopManager:GetSelfFirst()
    return self.RaceData.SelfScore
end
function RaceTopManager:GetFirstRacer()
    return self.RaceData.FirstRacer
end
function RaceTopManager:SetRaceType(RaceType)
   self.RaceType=RaceType
end
---@param msg SC_RetStart
function RaceTopManager:BeginBattle(msg,isReplay)
    self.roomId=msg.roomid
    BattleDataManager:Get():SetRoomData(msg, RaceModel.RaceTop,isReplay)
    local scenename = BattleDataManager:Get():GetSceneName()
    local trackdata = BattleDataManager:Get():GetTrackData()
    SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceTop)
end

function RaceTopManager:FinishBattle(time,rank,error,sign,startTime,recordValue)
    if self:GetRaceType()==RaceTopRaceType.Test then
        self:BattleResult()
    elseif self:GetRaceType()==RaceTopRaceType.RaceTop then
        RaceTopSubsystem:Get():SendMsg_FinishBattleRaceTopTop(time,error,rank,startTime,recordValue)
    elseif self:GetRaceType()==RaceTopRaceType.Audition then
        RaceTopSubsystem:Get():SendMsg_FinishBattleRaceTopAudition(time,error,rank,startTime,recordValue)
    elseif self:GetRaceType()==RaceTopRaceType.RaceB then
        RaceTopSubsystem:Get():SendMsg_FinishBattleRaceTopB(time,error,rank,startTime,recordValue)
    elseif self:GetRaceType()==RaceTopRaceType.Record then
        self:BattleResult()
    end
    self.RaceType=nil
end
function RaceTopManager:BattleResult()
    BattleDataManager:Get():SetStateBattleResult()
end
function RaceTopManager:ClearData()

end
---@param msg SC_TopFightRank
function RaceTopManager:SetGroupData(msg)
    self.RaceGroupData=RaceTopGroup()
    self.RaceGroupData:SetData(msg)
end
function RaceTopManager:GetRaceGroupData()
    return self.RaceGroupData
end



function RaceTopManager:CheckBattle(value)
    self.refight=value
end

function RaceTopManager:ReEnterBattle()
    local result = self.refight==5
    if result then
        RaceTopSubsystem:Get():SendMsg_ReFight()
    end
    return result
end
