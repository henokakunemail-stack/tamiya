---@class ClubRaceSelfChapterDataManager
ClubRaceSelfChapterDataManager =class("ClubRaceSelfChapterDataManager")
function ClubRaceSelfChapterDataManager:Get()
    if self._instance==nil then
        self._instance=ClubRaceSelfChapterDataManager()
    end
    return self._instance
end
function ClubRaceSelfChapterDataManager:initialize()

end

---@param msg SC_SC_Chapter_GetGamesRes
function ClubRaceSelfChapterDataManager:SetAllInfo(msg)
    self.AllRace={}
    for i = 1, #msg.gameInfos do
        local data=ClubRaceSelfChapterData()
        data:SetMiniData(msg.gameInfos[i],false)
        table.insert(self.AllRace,data)
    end
end

---@param msg SC_SC_Chapter_GetGamesRes
function ClubRaceSelfChapterDataManager:SetAllJoinedInfo(msg)
    self.AllJoinedRace={}
    for i = 1, #msg.gameInfos do
        local data=ClubRaceSelfChapterData()
        data:SetMiniData(msg.gameInfos[i],true)
        table.insert(self.AllJoinedRace,data)
    end
end

function ClubRaceSelfChapterDataManager:GetAllRace()
    return self.AllRace
end
function ClubRaceSelfChapterDataManager:GetAllJoinedRace()
    return self.AllJoinedRace
end
---@param data SC_SC_ChapterFinishRaceRes
function ClubRaceSelfChapterDataManager:RecBattleData(data)

    BattleDataManager:Get():SetRoomData(data.raceInfo, RaceModel.ClubRaceSelfChapter)
    local scenename = BattleDataManager:Get():GetSceneName()
    local trackdata = BattleDataManager:Get():GetTrackData()
    SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.ClubRaceSelfChapter)

end

---@param data SC_GUILD_SC_CreateChapterRes
function ClubRaceSelfChapterDataManager:SetChapterData(data)
    self.chapterData=ClubRaceSelfChapterData()
    self.chapterData:SetDetailData(data)
end

---@param data ClubRaceSelfChapterData
function ClubRaceSelfChapterDataManager:GetChapterData()
    return self.chapterData
end


function ClubRaceSelfChapterDataManager:GetPageIndex()
    return self.PageIndex
end

function ClubRaceSelfChapterDataManager:SetPageIndex(num)
    self.PageIndex=num
end