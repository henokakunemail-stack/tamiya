local __instance
---@class RaceClub3V3Manager
RaceClub3V3Manager = class("RaceClub3V3Manager")
function RaceClub3V3Manager:initialize()
    ---@type RaceClub3V3Data
    self.RankData = RaceClub3V3Data()
    ---@type SC_RetGuildPVEStart
    self.CurBattle=nil
end
---@return RaceClub3V3Manager
function RaceClub3V3Manager:Get()
    if __instance == nil then
        __instance = RaceClub3V3Manager()
    end
    return __instance
end
---@type SC_ReqGuildPveInfo
function RaceClub3V3Manager:SetData(data)
    self.RankData:SetData(data)
end
function RaceClub3V3Manager:GetCurCount()
   return  self.RankData.CurNum
end
function RaceClub3V3Manager:GetMaxCount()
   return  self.RankData.MaxNum
end
function RaceClub3V3Manager:GetEndTime()
   return  self.RankData.EndTime
end
function RaceClub3V3Manager:GetClubScore()
   return  self.RankData.GuildScore
end
function RaceClub3V3Manager:GetSelfScore()
   return  self.RankData.SelfScore
end
function RaceClub3V3Manager:GetClubAward()
   return  self.RankData.GuildAward
end
function RaceClub3V3Manager:SetGuideAward(value)
   self.RankData.GuildAward=value
end
function RaceClub3V3Manager:GetSelfAward()
   return  self.RankData.SelfAward
end
function RaceClub3V3Manager:SetSelfAward(value)
   self.RankData.SelfAward=value
end
function RaceClub3V3Manager:GetSceneList()
   return  self.RankData.SceneId
end
function RaceClub3V3Manager:GetTrackList()
   return  self.RankData.TrackId
end
function RaceClub3V3Manager:SetReFight(value)
   self.reFight=value
end
function RaceClub3V3Manager:SetAddScore(value)
   self.AddScore=value
end
function RaceClub3V3Manager:GetAddScore()
   return self.AddScore
end
function RaceClub3V3Manager:GetCurBattleData()
   return self.CurBattle
end

function RaceClub3V3Manager:ReFight()
    local result = self.reFight==3
    if result then
       RaceClub3v3Subsystem:Get():SendMsg_Refight()
    end
    return result
end
---@param data SC_RetGuildPVEBegin
function RaceClub3V3Manager:BeginBattle(data)
    self.Queue = Queue()
    self.BattleCount=#data.starts
    for i = 1, #data.starts do
        if data.starts[i].runflag==0 then
            local temp=data.starts[i]
            temp.starttime=data.starttime
            temp.curlevel=data.curlevel
            self.Queue:EnQueueFront(temp)
        end
    end
    self:FightBattle()
end

function RaceClub3V3Manager:FightBattle()
    if self.Queue:GetSize()>0 then
       local value= self.Queue:DeQueueBack()
        self.CurBattle=value
        BattleDataManager:Get():SetRoomData(value, RaceModel.RaceClub3v3)
        local scenename = BattleDataManager:Get():GetSceneName()
        local trackdata = BattleDataManager:Get():GetTrackData()
        SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceClub3v3)
    end
end

function RaceClub3V3Manager:BattleFinish()
    if self.Queue:GetSize()>0 then
        BattleDataManager:Get():SetStateBattleExit()
        self:FightBattle()
    else
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToClub3V3)
        BattleDataManager:Get():SetStateBattleExit()
    end
end
