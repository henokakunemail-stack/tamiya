---@class ClubRaceSelfLevelDataManager
ClubRaceSelfLevelDataManager =class("ClubRaceSelfLevelDataManager")
function ClubRaceSelfLevelDataManager:Get()
    if self._instance==nil then
        self._instance=ClubRaceSelfLevelDataManager()
    end
    return self._instance
end
function ClubRaceSelfLevelDataManager:initialize()
    ---@type table<number,ClubRaceSelfLevelData>
    self.AllJoinedRace={}
    ---@type table<number,ClubRaceSelfLevelData>
    self.AllRace={}
end

function ClubRaceSelfLevelDataManager:OnInit()

end
---@param msg SC_SC_Level_GetGamesRes
function ClubRaceSelfLevelDataManager:SetAllInfo(msg)
    self.AllRace={}
    for i = 1, #msg.gameInfos do
        local data=ClubRaceSelfLevelData()
        data:SetMiniData(msg.gameInfos[i],false)
        table.insert(self.AllRace,data)
    end
end

---@param msg SC_SC_Level_GetGamesRes
function ClubRaceSelfLevelDataManager:SetAllJoinedInfo(msg)
    self.AllJoinedRace={}
    for i = 1, #msg.gameInfos do
        local data=ClubRaceSelfLevelData()
        data:SetMiniData(msg.gameInfos[i],true)
        table.insert(self.AllJoinedRace,data)
    end
end
function ClubRaceSelfLevelDataManager:GetAllRace()
    return self.AllRace
end
function ClubRaceSelfLevelDataManager:GetAllJoinedRace()
    return self.AllJoinedRace
end
function ClubRaceSelfLevelDataManager:GetPageIndex()
    return self.PageIndex
end

function ClubRaceSelfLevelDataManager:SetPageIndex(num)
    self.PageIndex=num
end

function ClubRaceSelfLevelDataManager:GetLevelData()
    return self.LevelData
end
function ClubRaceSelfLevelDataManager:SetLevelData(data)
    self.LevelData=data
end
---@param data SC_SC_ChapterBeginRaceRes
function ClubRaceSelfLevelDataManager:RecBattleData(data)

    BattleDataManager:Get():SetRoomData(data.raceInfo, RaceModel.ClubRaceSelfLevel)
    local scenename = BattleDataManager:Get():GetSceneName()
    local trackdata = BattleDataManager:Get():GetTrackData()
    SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.ClubRaceSelfLevel)


end


---@param data SC_GUILD_SC_CreateLevelRes
function ClubRaceSelfLevelDataManager:UpdateSelfLevelData(data)
    local temp=self:GetLevelDataByIdJoined(data.gameInfo.id)
    if temp==nil then
        temp=self:GetLevelDataByIdNoJoin(data.gameInfo.id)
    end
    local selfLevel=ClubRaceSelfLevelData()
    selfLevel:SetDetailData(data,temp.isJoin)
    SkipModuleHelper:Get():ToSelectCarView(RaceModel.ClubRaceSelfLevel,selfLevel)
end

---@return ClubRaceSelfLevelData
function ClubRaceSelfLevelDataManager:GetLevelDataByIdJoined(id)

    local result=nil
    for i = 1, #self.AllJoinedRace do
        if id==self.AllJoinedRace[i].id then
            result=self.AllJoinedRace[i]
            break
        end
    end
    return result
end

---@return ClubRaceSelfLevelData
function ClubRaceSelfLevelDataManager:GetLevelDataByIdNoJoin(id)
    local result=nil
    for i = 1, #self.AllRace do
        if id==self.AllRace[i].id then
            result=self.AllRace[i]
            break
        end
    end
    return result
end


