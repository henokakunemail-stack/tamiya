---@class SceneManager
SceneManager = class("SceneManager")

function SceneManager:initialize()

    ---@type table<string, LoadingBase>
    self.allLoadingStates = {}

    self.lastSceneId = 0
    self.currentSceneId = 0

    --CacheClearTrigger:Get():RegisterEvent(self,self.Clear)
end

function SceneManager:Get()
    if self._instance == nil then
        self._instance = SceneManager()
    end
    return self._instance
end

function SceneManager:FirstLoadingMainCity()
    self:LoadingMainCity(nil, nil, nil, true)
    QuickTa:Get():TrackEvent(TrackEventNames.FirstLoadingMainCity, nil,TrackEventType.First,AnalysisType.FirstLoadingMainCity)
end

function SceneManager:LoadingMainCity(type, param, clearuitrack, isFirstLoading)

    local sceneId = MainCityRes
    local isreload = self:IsReloadScene(sceneId)
    self:ExitVerify(sceneId, isreload)
    self:EnterVerify(sceneId)

    local loadingState = self.allLoadingStates[sceneId]
    if loadingState == nil then
        loadingState = MainCityLoading()
        self.allLoadingStates[sceneId] = loadingState
    end

    loadingState:OnEnter(sceneId, isreload, type, param, clearuitrack, isFirstLoading)
end

function SceneManager:LoadingBattleScene(scenename, trackdata, battletype, fun, funclass, funparam)
    local isreload = self:IsReloadScene(BattleSceneFlag)
    self:ExitVerify(BattleSceneFlag, isreload)
    self:EnterVerify(BattleSceneFlag)
    local loadingState = self.allLoadingStates[BattleSceneFlag]
    if loadingState == nil then
        loadingState = BattleLoading()
        self.allLoadingStates[BattleSceneFlag] = loadingState
    end

    loadingState:OnEnter(scenename, trackdata, battletype, fun, funclass, funparam)
end

function SceneManager:LoadingRealTimePVPScene(scenename, trackdata, battletype, fun, funclass, funparam)
    print(debug.traceback())
    local isreload = self:IsReloadScene(RealTimePVPSceneFlag)
    self:ExitVerify(RealTimePVPSceneFlag, isreload)
    self:EnterVerify(RealTimePVPSceneFlag)
    local loadingState = self.allLoadingStates[RealTimePVPSceneFlag]
    if loadingState == nil then
        loadingState = RealTimePVPLoading()
        self.allLoadingStates[RealTimePVPSceneFlag] = loadingState
    end

    loadingState:OnEnter(scenename, trackdata, battletype, fun, funclass, funparam)
end

function SceneManager:LoadingMINIGameScene(type, param, clearuitrack, isFirstLoading)
    local sceneId = MINIGameSceneRes
    local isreload = self:IsReloadScene(sceneId)
    self:ExitVerify(sceneId, isreload)
    self:EnterVerify(sceneId)

    local loadingState = self.allLoadingStates[sceneId]
    if loadingState == nil then
        loadingState = MINIGameLoading()
        self.allLoadingStates[sceneId] = loadingState
    end

    loadingState:OnEnter(sceneId, isreload, type, param, clearuitrack, isFirstLoading)
end


function SceneManager:ExitVerify(sceneId, isreload)
    self.lastSceneId = self.currentSceneId
    self.currentSceneId = sceneId

    AudioManager:Clear()

    if isreload then
        local scene = self.allLoadingStates[self.lastSceneId]
        if scene then
            scene:OnExit()
        end
    end
    mono.ForceDoGarbageCollect()
end

function SceneManager:EnterVerify(sceneId)

end

function SceneManager:UnloadScene(sceneId)
    AssetsManager.UnloadScene(sceneId)
end

function SceneManager:GetCurScene()
    return self.currentSceneId
end

function SceneManager:MainCityChangeScene(type)
    ---@type MainCityLoading
    local state = self.allLoadingStates[MainCityRes]
    if state then
        state:ChangeScene(type)
    end
end

function SceneManager:GetMainCityScenePrefab(type,load)
    ---@type MainCityLoading
    local state = self.allLoadingStates[MainCityRes]
    if state then
        return state:GetScenePrefab(type,load)
    end
    return nil
end

function SceneManager:SetLoadingProcess(value)
    if self.currentSceneId then
        local scene = self.allLoadingStates[self.currentSceneId]
        if scene then
            scene.LoadingProcess = value
            UINotify:Get():SendNotification(UINotifyEvent.UpdateLoadingViewProgress, value)
        end
    end
end

function SceneManager:GetLoadingProcess()
    local result = 0
    if self.currentSceneId then
        local scene = self.allLoadingStates[self.currentSceneId]
        if scene then
            result = scene.LoadingProcess
        end
    end
    return result
end

function SceneManager:GetCurrentSceneId()
    return self.currentSceneId
end

function SceneManager:IsReloadScene(sceneid)
    log("---   SceneManager:IsReloadScene()   ", self.currentSceneId, sceneid)
    if self.currentSceneId then
        if sceneid == self.currentSceneId then
            return false
        end
    end
    return true
end

function SceneManager:BreakLoading()
    if self.currentSceneId then
        local scene = self.allLoadingStates[self.currentSceneId]
        if scene then
            scene:OnBreak()
        end
    end
end

function SceneManager:Clear()
    ---@type table<string, LoadingBase>
    self.allLoadingStates = {}

    self.lastSceneId = 0
    self.currentSceneId = 0
end