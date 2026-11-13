---@class PveLevelTestBattleDataManager
PveLevelTestBattleDataManager = class("PveLevelTestBattleDataManager")
function PveLevelTestBattleDataManager:initialize()
    ---@type Queue
    self.LevelDataQueue = Queue()
end

---@return PveLevelTestBattleDataManager
function PveLevelTestBattleDataManager:Get()
    if self._instance == nil then
        self._instance = PveLevelTestBattleDataManager()
    end
    return self._instance
end

function PveLevelTestBattleDataManager:AddLevelData(raceLoadData)
    self.LevelDataQueue:EnQueueFront(raceLoadData)
end
function PveLevelTestBattleDataManager:Break()
    SceneManager:Get():LoadingMainCity(LoadingMainCityType.GuideBattleDone)
    self.LevelDataQueue:Clear()
end
function PveLevelTestBattleDataManager:PopLevelData()
    local battleData=self.LevelDataQueue:DeQueueFront()
    if battleData then
        self.CurBattleData=battleData
        UINotify:Get():SendNotification(UINotifyEvent.DebugViewShowLogView_SetAttrs,self.CurBattleData)
        BattleDataManager:Get():SetRoomData(battleData, RaceModel.GuideBattle)
        local scenename = battleData:GetSceneName()
        local trackdata = battleData:GetTrackData()
        SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.GuideBattle)
    end
end
---@param result table<number, BattleResultPlayerData>
function PveLevelTestBattleDataManager:WriteTime(result)
    local time={}
    local error={}
    local id={}
    for i = 1, #result do
        --if result[i]:GetPid()==self.CurBattleData.Default then
            time[i]=result[i]:GetTime()
            error[i]=result[i]:GetError()
            id[i]=result[i]:GetPid()
        --end
    end
    print("LEVELRESULT",self.CurBattleData.LevelId,self.CurBattleData.Default,time)
    if self.CurBattleData.LevelId==nil then
        self.CurBattleData.LevelId=1
    end
    for i = 1, #time do
        CS.MonoHelper.AppendToLevelTime(string.format("LevelResult:id- %s Npc- %d Time- %d Error-%s\r\n",self.CurBattleData.LevelId,id[i],time[i],CommonHelper:GetTempStr_BattleFailErrorTips(error[i])))
    end
end

function PveLevelTestBattleDataManager:Clear()
    self.LevelDataQueue:Clear()
end

