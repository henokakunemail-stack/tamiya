---@class RaceSelfChapterDataManager
RaceSelfChapterDataManager =class("RaceSelfChapterDataManager")
function RaceSelfChapterDataManager:Get()
    if self._instance==nil then
        self._instance=RaceSelfChapterDataManager()
    end
    return self._instance
end
function RaceSelfChapterDataManager:initialize()

end

---@param msg SC_UserChapter
function RaceSelfChapterDataManager:SetAllInfo(msg)
    ---@type RaceSelfChapterData[]
    self.AllRace={}
    self.AllRaceDic={}
    for i = 1, #msg.chapters do
          local data=RaceSelfChapterData()
          local result= data:SetMiniData(msg.chapters[i])
          if result then
            table.insert(self.AllRace,data)
          end
        self.AllRaceDic[data.id]=data
    end
    table.sort(self.AllRace,function(a, b)
        return a.id<b.id
    end)
end
function RaceSelfChapterDataManager:IsHasCopy(data)
    if  data.Cops and  data.Cops[1] then
        local mapNode=CommonHelper:GetTableDataByID(ConfigNames.mapnode_config,data.Cops[1].copyid)
        if mapNode then
           return true
        else
            return false
        end
    else
        return false
    end
end
function RaceSelfChapterDataManager:GetAllRace()
    return self.AllRace
end
---@return RaceSelfChapterData
function RaceSelfChapterDataManager:GetRaceByIndex(index)
    ---@type RaceSelfChapterData
    self.CurChapterData=self.AllRace[index]
    return self.CurChapterData
end
function RaceSelfChapterDataManager:GetRaceByID(id)
    ---@type RaceSelfChapterData
    self.CurChapterData=self.AllRaceDic[id]
    return self.CurChapterData
end


---@return RaceSelfChapterData
function RaceSelfChapterDataManager:GetCurChapterData()
    return self.CurChapterData
end

---@param msg SC_ChapterAward
function RaceSelfChapterDataManager:UpdateCurBoxData(msg)
    self.CurChapterData:SetAllBoxState(msg.awardno)
end

---@param msg SC_CopyStarAward
function RaceSelfChapterDataManager:UpdateCurTaskState(msg)
    self.CurChapterData:UpdateCurTaskState(msg)
end


function RaceSelfChapterDataManager:SetCurLevel(levelData)
    self.CurLevel=levelData
end
function RaceSelfChapterDataManager:GetCurLevel()
    return self.CurLevel
end
function RaceSelfChapterDataManager:GetCurCopyData()
   return self.CurChapterData:GetCurCopy()
end

function RaceSelfChapterDataManager:SetBattleCar(carIdx)
    self.CurCar=table.concat(carIdx,":")
end
function RaceSelfChapterDataManager:GetBattleCar()
    return self.CurCar
end
function RaceSelfChapterDataManager:GetHasRedPoint()
    local flag=false
    for i = 1, #self.AllRace do
        if self.AllRace[i]:GetSelfChapterHasRedPoint() then
            flag=true
            break
        end
    end
    return flag
end


---@param data SC_BeginPve
function RaceSelfChapterDataManager:RecBattleData(data)

    BattleDataManager:Get():SetRoomData(data, RaceModel.RaceSelfChapter)
    local scenename = BattleDataManager:Get():GetSceneName()
    local trackdata = BattleDataManager:Get():GetTrackData()
    SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceSelfChapter)
   -- SdkAd:Get():SdkAdjust_JoinChallengeGame(data.raceInfo.trackId)
end










-----@param msg SC_SC_Chapter_GetGamesRes
--function RaceSelfChapterDataManager:SetAllJoinedInfo(msg)
--    self.AllJoinedRace={}
--    for i = 1, #msg.gameInfos do
--          local data=RaceSelfChapterData()
--          data:SetMiniData(msg.gameInfos[i],true)
--          table.insert(self.AllJoinedRace,data)
--    end
--end
--
--
--function RaceSelfChapterDataManager:GetAllJoinedRace()
--    return self.AllJoinedRace
--end
--
-----@param data SC_UserCopy
--function RaceSelfChapterDataManager:SetChapterData(data)
--    self.chapterData=RaceSelfChapterData()
--    self.chapterData:SetDetailData(data)
--end
--
-----@param data RaceSelfChapterData
--function RaceSelfChapterDataManager:GetChapterData()
--    return self.chapterData
--end
--
--
--function RaceSelfChapterDataManager:GetPageIndex()
--    return self.PageIndex
--end
--
--function RaceSelfChapterDataManager:SetPageIndex(num)
--     self.PageIndex=num
--end