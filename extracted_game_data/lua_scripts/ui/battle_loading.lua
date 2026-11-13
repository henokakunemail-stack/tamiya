---@class BattleLoading:LoadingBase
BattleLoading = class("BattleLoading", LoadingBase)

function BattleLoading:OnEnter(scenename, trackdata, battletype, finishfun, finishfunclass, finishparam)
    if self.IsLoading then
        logError("---   BattleLoading:重复loading...   lastscene = ", self.SceneName, "   curscene = ", scenename)
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

function BattleLoading:SequenceLoading()

    UIManager:Get():CloseAllViews()
    UIManager:Get():OpenView("EmptyView", CanvasType.MainCanvas, nil)

    CommonHelper:OpenLoading(true, function()
        self:OnComplete()
    end)

    --MeshCacheMgr:Get():ReleaseAllMesh()

    BattleDataManager:Get():SetStateLoading()

    ---@param param BattleLoading
    self.coroutine = cs_coroutine.start(function(param)
        try( function()
            coroutine.yield()
            UINotify:Get():SendNotification(UINotifyEvent.UpdateLoadingViewProgress, 0)

            BattleDataManager:Get():LoadCars(param.BattleType)
            while not BattleDataManager:Get():IsLoadCarFinish() do
                local progress = BattleDataManager:Get():GetProgress() * 0.3
                UINotify:Get():SendNotification(UINotifyEvent.UpdateLoadingViewProgress, progress)
                coroutine.yield()
            end
            local sceneAsset = AssetsManager.LoadScene(param.SceneName, true, false)

            while not sceneAsset.isDone do
                UINotify:Get():SendNotification(UINotifyEvent.UpdateLoadingViewProgress, 0.7 + sceneAsset.progress * 0.2)
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

            UINotify:Get():SendNotification(UINotifyEvent.UpdateLoadingFinish)

            SceneHomeManager:Get():OnInit()
        end).catch(function(error)
            logError(error)
            LoginFuncHelper:EnterGameError(error)
        end)
    end, self)
end

function BattleLoading:LoadTrack()
    if self.TrackData then
        self.raceTrackAsset = CommonHelper:LoadRaceTrack(self.TrackData,false)
    end
end

function BattleLoading:OnComplete()
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

function BattleLoading:OnExit()
    if self.raceTrackAsset ~= nil then
        AssetsManager.Unload(self.raceTrackAsset)
    end
    if RaceTrackDataManager:Get().TrackObj then
        GameObject.Destroy(RaceTrackDataManager:Get().TrackObj)
        RaceTrackDataManager:Get().TrackObj=nil
    end
    AssetsManager.UnloadScene(self.SceneName)

    self.raceTrackAsset = nil
    self.SceneName = nil
end

function BattleLoading:OnBreak()
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

return BattleLoading