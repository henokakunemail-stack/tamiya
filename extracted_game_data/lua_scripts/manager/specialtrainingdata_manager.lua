---@class SpecialTrainingDataManager
SpecialTrainingDataManager = class("SpecialTrainingDataManager")
function SpecialTrainingDataManager:Get()
    if self._instance == nil then
        self._instance = SpecialTrainingDataManager()
    end
    return self._instance
end
function SpecialTrainingDataManager:initialize()
    ---@type table<number,challengeteam_config_cell>
    self.challengeTeamCfg = nil
    ---@type table<number,table<challenge_config_cell>>
    self.challengeData = nil
    ---@field challengeteam_config_cell
    self.curChallengeTeam = nil
    ---@field challenge_config_cell
    self.CurChallengeData = nil
    ---@type table<number,SpecialTrainingData>
    self.specialTrainingData = {}
    ---@field SpecialTrainingData
    self.curSpecialTraining = nil
    self.CurLevel = nil
    ---@type CarData
    self.CurSelectCarData = nil
end
---@param msg SC_UserChapter
function SpecialTrainingDataManager:Init(msg)
    for i = 1, #msg.chapters do
        local data = SpecialTrainingData()
        data:SetData(msg.chapters[i])
        self.specialTrainingData[data.id] = data
    end
end
---@return table<number,SpecialTrainingData>
function SpecialTrainingDataManager:GetSpecialTrainings()
    return self.specialTrainingData
end
function SpecialTrainingDataManager:SetCurChallenge(id)
    self.curChallengeTeam = self.specialTrainingData[id]
end
---@return SpecialTrainingData
function SpecialTrainingDataManager:GetCurChallengeTeam()
    return self.curChallengeTeam
end
function SpecialTrainingDataManager:GetCurChallengeTeamAllUnLockLevel()
    if self.curChallengeTeam.CopyData then
        local level1 = self.curChallengeTeam.CopyData[SpecialTrainingLevel.low].cfg.needlevel
        local level2 = self.curChallengeTeam.CopyData[SpecialTrainingLevel.middle].cfg.needlevel
        local level3 = self.curChallengeTeam.CopyData[SpecialTrainingLevel.high].cfg.needlevel
        return level1, level2, level3
    end

end

function SpecialTrainingDataManager:SetSelectCopy(level)
    self.CurLevel = level
    self.CurCopy = self.curChallengeTeam.CopyData[level].cfg
    self.CurCopyMsg = self.curChallengeTeam.CopyData[level].msg
end
---@return  string
---@return  string
function SpecialTrainingDataManager:GetCurRewardByLv(level)
    local reward1 = CommonHelper:GetRewardByDictDownId(self.curChallengeTeam.CopyData[level].cfg.firstdown)
    local reward2 ={}
    local copydowns=stringSplitToNumber(self.curChallengeTeam.CopyData[level].cfg.copydowns,':')
    for i = 1, #copydowns do
        table.insert(reward2,CommonHelper:GetRewardByDictDownId(copydowns[i]))
    end

    return reward1, reward2
end
function SpecialTrainingDataManager:GetCurPowerByLv(level)
    return self.curChallengeTeam.CopyData[level].cfg.paypower
end
---@return dictcopy_config_cell
function SpecialTrainingDataManager:GetSelectCopy()
    return self.CurCopy
end
---@return SC_CopyInfo
function SpecialTrainingDataManager:GetSelectCopyMsg()
    return self.CurCopyMsg
end














function SpecialTrainingDataManager:LoadConfig()
    if self.challengeData == nil then
        self.challengeData = {}
        local challengeteam_config = ClientDataManager:Get():GetDataTable(ConfigNames.challengeteam_config)
        self.challengeTeamCfg = challengeteam_config.GetConfigData()
        local challenge_config = ClientDataManager:Get():GetDataTable(ConfigNames.challenge_config)
        for i, v in pairs(challenge_config.GetConfigData()) do
            if self.challengeData[v.team] == nil then
                self.challengeData[v.team] = {}
            end
            table.insert(self.challengeData[v.team], v)
        end
        for i, v in pairs(self.challengeData) do
            table.sort(v, function(a, b)
                return a.id < b.id
            end)
        end
    end
end



function SpecialTrainingDataManager:GetCurChallengeUnLockLevel(lv)
    local level = self.challengeData[self.curChallengeTeam.id][lv].unlocklevel
    return level
end


---@return SpecialTrainingData
function SpecialTrainingDataManager:GetSpecialTraining()
    return self.curSpecialTraining
end


function SpecialTrainingDataManager:ClearData()

    self.challengeTeamCfg = nil
    if self.challengeData ~= nil then
        for i, v in pairs(self.challengeData) do
            v = nil
        end
    end
    self.challengeData = nil
    self.curChallengeTeam = nil
end

---@param data SC_BeginPve
function SpecialTrainingDataManager:RecBattleData(data)
    BattleDataManager:Get():SetRoomData(data, RaceModel.Challenge)
    local scenename = BattleDataManager:Get():GetSceneName()
    local trackdata = BattleDataManager:Get():GetTrackData()
    SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.Challenge)
end
---@param data PVEChapterRankData
function SpecialTrainingDataManager:RaceBattleDataHistory(copyid,data)
    local temp={}
    temp.copyId=copyid
    temp.carData=data
    temp.isHistory=true
    temp.seed=data.Seed
    temp.selfCarID=data.pid
    temp.StartTime=data.StarTimes[1]
    if data.Stops then
        temp.Stop=data.Stops[1]
    end
    temp.idx=1
    BattleDataManager:Get():SetRoomData(temp, RaceModel.Challenge,true)
    local scenename = BattleDataManager:Get():GetSceneName()
    local trackdata = BattleDataManager:Get():GetTrackData()
    SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.Challenge)
end

function SpecialTrainingDataManager:UpdateCurChallenge(id, lastNum, maxNum)

end
function SpecialTrainingDataManager:SetCurSelectCarData(CarData)
    self.CurSelectCarData = CarData
end
function SpecialTrainingDataManager:GetCurSelectCarData()
    return tostring(self.CurSelectCarData)
end