---@class RaceSelfLevelDataManager
RaceSelfLevelDataManager =class("RaceSelfLevelDataManager")
function RaceSelfLevelDataManager:Get()
    if self._instance==nil then
        self._instance=RaceSelfLevelDataManager()
    end
    return self._instance
end
function RaceSelfLevelDataManager:initialize()
    ---@type table<number,RaceSelfLevelData>
    self.AllJoinedRace={}
    ---@type table<number,RaceSelfLevelData>
    self.AllRace={}
end

function RaceSelfLevelDataManager:OnInit()

end
---@param msg SC_SC_Level_GetGamesRes
function RaceSelfLevelDataManager:SetAllInfo(msg)
    self.AllRace={}
    for i = 1, #msg.gameInfos do
        local data=RaceSelfLevelData()
        data:SetMiniData(msg.gameInfos[i],false)
        table.insert(self.AllRace,data)
    end
end

---@param msg SC_SC_Level_GetGamesRes
function RaceSelfLevelDataManager:SetAllJoinedInfo(msg)
    self.AllJoinedRace={}
    for i = 1, #msg.gameInfos do
        local data=RaceSelfLevelData()
        data:SetMiniData(msg.gameInfos[i],true)
        table.insert(self.AllJoinedRace,data)
    end
end
function RaceSelfLevelDataManager:GetAllRace()
    return self.AllRace
end
function RaceSelfLevelDataManager:GetAllJoinedRace()
    return self.AllJoinedRace
end
function RaceSelfLevelDataManager:GetPageIndex()
    return self.PageIndex
end

function RaceSelfLevelDataManager:SetPageIndex(num)
    self.PageIndex=num
end

function RaceSelfLevelDataManager:GetLevelData()
    return self.LevelData
end
function RaceSelfLevelDataManager:SetLevelData(data)
    self.LevelData=data
end
---@param data SC_SC_ChapterBeginRaceRes
function RaceSelfLevelDataManager:RecBattleData(data)

    BattleDataManager:Get():SetRoomData(data.raceInfo, RaceModel.RaceSelfLevel)
    local scenename = BattleDataManager:Get():GetSceneName()
    local trackdata = BattleDataManager:Get():GetTrackData()
    SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceSelfLevel)


end


---@param data SC_SC_CreateLevelRes
function RaceSelfLevelDataManager:UpdateSelfLevelData(data)
    local temp=self:GetLevelDataByIdJoined(data.gameInfo.id)
    if temp==nil then
        temp=self:GetLevelDataByIdNoJoin(data.gameInfo.id)
    end
    local selfLevel=RaceSelfLevelData()
    selfLevel:SetDetailData(data,temp.isJoin)
    SkipModuleHelper:Get():ToSelectCarView(RaceModel.RaceSelfLevel,selfLevel)
end

---@return RaceSelfLevelData
function RaceSelfLevelDataManager:GetLevelDataByIdJoined(id)

    local result=nil
    for i = 1, #self.AllJoinedRace do
        if id==self.AllJoinedRace[i].id then
           result=self.AllJoinedRace[i]
           break
        end
    end
    return result
end

---@return RaceSelfLevelData
function RaceSelfLevelDataManager:GetLevelDataByIdNoJoin(id)
    local result=nil
    for i = 1, #self.AllRace do
        if id==self.AllRace[i].id then
            result=self.AllRace[i]
            break
        end
    end
    return result
end


