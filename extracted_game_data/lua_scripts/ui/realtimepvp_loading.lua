---@class RealTimePVPLoading:LoadingBase
RealTimePVPLoading = class("RealTimePVPLoading", LoadingBase)

function RealTimePVPLoading:OnEnter(scenename, trackdata, battletype, finishfun, finishfunclass, finishparam)
    print(debug.traceback())
    if self.IsLoading then
        logError("---   RealTimePVPLoading:重复loading...   lastscene = ", self.SceneName, "   curscene = ", scenename)
        return
    end

    self.IsLoading = true
    self.SceneName = scenename
    ---@type RaceTrackData
    self.TrackData = trackdata
    self.BattleType = battletype
    self.raceTrackAsset = nil
    self.FinishFun = finishfun
    self.FinishFunClass = finishfunclass
    self.FinishFunParam = finishparam

    self:SequenceLoading()
end

function RealTimePVPLoading:SequenceLoading()

    UIManager:Get():CloseAllViews()
    UIManager:Get():OpenView("EmptyView", CanvasType.MainCanvas, nil)

    CommonHelper:OpenLoading(false, function()
        self:OnComplete()
    end)

    --MeshCacheMgr:Get():ReleaseAllMesh()

    BattleDataManager:Get():SetStateLoading()

    ---@param param RealTimePVPLoading
    self.coroutine = cs_coroutine.start(function(param)
        try( function()
            coroutine.yield()
            SceneManager:Get():SetLoadingProcess(0)
            BattleDataManager:Get():LoadCars(param.BattleType)
            while not BattleDataManager:Get():IsLoadCarFinish() do
                local progress = 0.5 + SceneHomeManager:Get():ScreenCount() * 0.3
                UINotify:Get():SendNotification(UINotifyEvent.UpdateLoadingViewProgress, progress)
                coroutine.yield()
            end

            local sceneAsset = AssetsManager.LoadScene(param.SceneName, true, false)

            while not sceneAsset.isDone do
                SceneManager:Get():SetLoadingProcess(0.8 + sceneAsset.progress * 0.1)
                coroutine.yield()
            end

            param:LoadTrack()

            if param.raceTrackAsset then
                while not param.raceTrackAsset.isDone do
                    coroutine.yield()
                end
            end

            if SelfDefineTrack ~= nil then
                while not SelfDefineTrack:isDone() do
                    coroutine.yield()
                end
            end

            coroutine.yield(cs_coroutine.start(function()
                RaceBulider:Get():Builder()
            end))

            coroutine.yield()
            SceneManager:Get():SetLoadingProcess(1)
            coroutine.yield()

            UINotify:Get():SendNotification(UINotifyEvent.UpdateLoadingFinish)
        end).catch(function(error)
            logError(error)
            LoginFuncHelper:EnterGameError(error)
        end)
    end, self)
end

function RealTimePVPLoading:LoadTrack()
    if self.TrackData then
        self.raceTrackAsset = CommonHelper:LoadRaceTrack(self.TrackData)
    end
end

function RealTimePVPLoading:OnComplete()
    BattleDataManager:Get():SetStateLoadFinish()
    if self.FinishFun then
        if self.FinishFunClass then
            self.FinishFun(self.FinishFunParam)
        else
            self.FinishFun(self.FinishFunClass, self.FinishFunParam)
        end
    end

    self.IsLoading = false
    ---@type RaceTrackData
    self.TrackData = nil
    self.BattleType = nil
    self.FinishFun = nil
    self.FinishFunClass = nil
    self.FinishFunParam = nil
end

function RealTimePVPLoading:OnExit()
    if self.raceTrackAsset ~= nil then
        AssetsManager.Unload(self.raceTrackAsset)
    end
    AssetsManager.UnloadScene(self.SceneName)

    self.raceTrackAsset = nil
    self.SceneName = nil
end

function RealTimePVPLoading:OnBreak()
    LoadingBase:OnBreak()
    self.IsLoading = false
    ---@type RaceTrackData
    self.TrackData = nil
    self.BattleType = nil
    self.FinishFun = nil
    self.FinishFunClass = nil
    self.FinishFunParam = nil
    if self.coroutine ~= nil then
        cs_coroutine.stop(self.coroutine)
        self.coroutine = nil
    end
end

return RealTimePVPLoading