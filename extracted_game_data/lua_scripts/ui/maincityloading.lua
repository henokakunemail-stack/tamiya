---@class MainCityLoading:LoadingBase
MainCityLoading = class("MainCityLoading", LoadingBase)

function MainCityLoading:initialize()
    self.coroutine = nil
end

function MainCityLoading:OnEnter(sceneid, isreload, type, param, clearuitrack, isFirstLoading)
    log("MainCityLoading:OnEnter", isreload, type, param, clearuitrack)
    self.sceneid = sceneid
    self:SequenceLoading(isFirstLoading, isreload, type, param, clearuitrack)
end

function MainCityLoading:OnEnterFirst(sceneid, isreload)
    log("MainCityLoading:OnEnterFirst")
end

function MainCityLoading:SequenceLoading(isFirstLoading, isreload, type, param, clearuitrack)
    if clearuitrack == nil then
        clearuitrack = true
    end

    self.coroutine = cs_coroutine.start(function()
       try( function()
            CommonHelper:OpenLoading()

            --加载scene
            if isreload then
                local sceneAsset = AssetsManager.LoadScene(self.sceneid, true, false)
                while not sceneAsset.isDone do
                    local progress = sceneAsset.progress * 0.3
                    UINotify:Get():SendNotification(UINotifyEvent.UpdateLoadingViewProgress, progress)
                    coroutine.yield()
                end
            end
            --加载场景prefab
            if isFirstLoading then
                SceneHomeManager:Get():SetMainCitySceneValue()
                self:TrackEventFirstGameEnter()
            end
            --while SceneHomeManager:Get():IsFistLoginLoading() do
            --    local progress = 0.8 + (0.1*SceneHomeManager:Get():ScreenCount())
            --    UINotify:Get():SendNotification(UINotifyEvent.UpdateLoadingViewProgress, progress)
            --    coroutine.yield()
            --end
           while not PrefabCacheMgr:Get():AdvanceLoadProgress() do
                coroutine.yield()
            end

            self:ChangeScene(SceneChangeID.None)

           while TeamCacheManager:Get():GetMainCarLoadProcess() < 1 do
                local progress = 0.9 +(0.09*TeamCacheManager:Get():GetMainCarLoadProcess())
                UINotify:Get():SendNotification(UINotifyEvent.UpdateLoadingViewProgress, progress)
                coroutine.yield()
            end
           
            if GameProperties.PlayerIdEntityIsKickOff == false then
                --UIManager:Get():HidePersistentView("LoginView")
            end


            if clearuitrack then
                UIManager:Get():CloseAllViews()
                LoginFuncHelper:FirstEnterMainCityDone()
            end

           mono.ForceDoGarbageCollect()
           CS.UnityEngine.Resources.UnloadUnusedAssets()
           UINotify:Get():SendNotification(UINotifyEvent.UpdateLoadingFinish)
            -- CommonHelper:InitSound()
            ---@type string LastLoginPlayerId
            CameraStackHelper:SetUIDefaultGroup()

            self:OnComplete(isFirstLoading, type, param)
        end).catch(function(error)
           logError(error)
            LoginFuncHelper:EnterGameError(error)
        end)

    end)
end

function MainCityLoading:OnUpdate()


end

function MainCityLoading:TrackEventFirstGameEnter()
    QuickTa:Get():TrackEvent(TrackEventNames.FirstGameEnter,nil,TrackEventType.First)
end

function MainCityLoading:OnComplete(isFirstLoading, type, param)
    if type == LoadingMainCityType.BattleToChapter then
        SkipModuleHelper:Get():Loading_BattleToPVEChapter(param,type,self.OnBackDone)
    elseif type == LoadingMainCityType.BattleToRaceRoom then
        SkipModuleHelper:Get():Loading_BattleToRaceRoom(param,self.OnBackDone)
    elseif type == LoadingMainCityType.BattleToNewBieChapter then
        SkipModuleHelper:Get():Loading_BattleToNewbieChapter(param,self.OnBackDone)
    elseif type == LoadingMainCityType.BattleToRaceAssembleTest then
        SkipModuleHelper:Get():Loading_BattleToRaceAssembleTest(param,self.OnBackDone)
    elseif type == LoadingMainCityType.BattleToPVPRank then
        SkipModuleHelper:Get():Loading_BattleToPVPRank(param,self.OnBackDone)
    elseif type == LoadingMainCityType.BattleToWeekRank then
        SkipModuleHelper:Get():Loading_BattleToWeekRank(param,self.OnBackDone)
    elseif type == LoadingMainCityType.BattleToClubTrain then
        SkipModuleHelper:Get():Loading_BattleToClubTrain(param,self.OnBackDone)
    elseif type == LoadingMainCityType.BattleToRaceSelf then
        SkipModuleHelper:Get():Loading_BattleToRaceSelf(param,self.OnBackDone)
    elseif type == LoadingMainCityType.BattleToSelfChallenge then
        SkipModuleHelper:Get():Loading_BattleToSelfChallenge(param,self.OnBackDone)
    elseif type == LoadingMainCityType.BattleToRaceSelfLevel then
        SkipModuleHelper:Get():Loading_BattleToRaceSelfLevel(param,self.OnBackDone)
  elseif type == LoadingMainCityType.BattleToRaceAssemble then
        SkipModuleHelper:Get():Loading_BattleToRaceAssemble(param,self.OnBackDone)
    elseif type == LoadingMainCityType.BattleToRaceSelfChapter then
        SkipModuleHelper:Get():Loading_BattleToRaceSelfChapter(param,self.OnBackDone)
    elseif type == LoadingMainCityType.BattleToGameStart then
        SkipModuleHelper:Get():Loading_BattleToGameStart(param,self.OnBackDone)
    elseif type == LoadingMainCityType.StartToRaceRank then
        SkipModuleHelper:Get():Loading_StartToRaceRank(param,self.OnBackDone)
    elseif type == LoadingMainCityType.StartToRaceRoom then
        SkipModuleHelper:Get():Loading_StartToRaceRoom(param,self.OnBackDone)
    elseif type == LoadingMainCityType.ReviewTrackToMainCity then
        SkipModuleHelper:Get():Loading_ReviewClose(param,self.OnBackDone)
    elseif type == LoadingMainCityType.GuideBattleDone then
        SkipModuleHelper:Get():Loading_GuideBattleToMainMenu(param,self.OnBackDone)
    elseif type == LoadingMainCityType.CustomTrackTestRunDone then
        SkipModuleHelper:Get():Loading_TestRunToMainMenu(param,self.OnBackDone)
    elseif type == LoadingMainCityType.BattleToRaceView then
        SkipModuleHelper:Get():Loading_BattleErrorToRaceView(param,self.OnBackDone)
    elseif type == LoadingMainCityType.BattleToRaceTrot then
        SkipModuleHelper:Get():Loading_BattleToRaceTrot(param,self.OnBackDone)
    elseif type == LoadingMainCityType.BattleToJcp then
        SkipModuleHelper:Get():Loading_BattleToRaceJcp(param,self.OnBackDone)
    elseif type == LoadingMainCityType.BattleToClub3V3 then
        SkipModuleHelper:Get():Loading_BattleToRaceClub3V3(param,self.OnBackDone)
    elseif type == LoadingMainCityType.BattleToRaceTop then
        SkipModuleHelper:Get():Loading_BattleToRaceTop(param,self.OnBackDone)
    elseif type == LoadingMainCityType.BattleToRaceTopSuper then
        SkipModuleHelper:Get():Loading_BattleToRaceTopSuper(param,self.OnBackDone)
    elseif type == LoadingMainCityType.BattleToRaceGVG then
        SkipModuleHelper:Get():Loading_BattleToRaceGVG(param,self.OnBackDone)
    elseif type == LoadingMainCityType.BattleToRaceSeniorTrain then
        SkipModuleHelper:Get():Loading_BattleStateRaceSeniorTrain(param,type,self.OnBackDone)
    elseif type == LoadingMainCityType.BattleToRaceCarGod then
        SkipModuleHelper:Get():Loading_BattleToRaceCarGod(param,type,self.OnBackDone)
    elseif type == LoadingMainCityType.BattleToRaceSuperBattle then
        SkipModuleHelper:Get():Loading_BattleToRaceSuperBattle(param,type,self.OnBackDone)
    end
    if isFirstLoading then
        if UIManager:Get():IsPopViewShow("SelectServerView") then
            UIManager:Get():ClosePopup()
        end
        PopupManager:Get():AddAllFirstInitPopupView()
    else
        PopUpGiftDataManager:Get():DelayPopUpShow()
    end
    BattleDataManager:Get():ClearData()
    collectgarbage()
end

function MainCityLoading:OnExit()
    cs_coroutine.start(function()
        SceneHomeManager:Get():RecycleScenePrefab()
        coroutine.yield()
        AssetsManager.UnloadScene(self.sceneid)
        HVersionManager:UnloadAsset()
    end)

end
function MainCityLoading:OnBackDone()
  print("返回战斗完成")
end
function MainCityLoading:LoadScenePrefab()
    SceneHomeManager:Get():LoadScenePrefab()
end


function MainCityLoading:RecycleScenePrefab()
    SceneHomeManager:Get():RecycleScenePrefab()
end

function MainCityLoading:ChangeScene(type)
    SceneHomeManager:Get():ChangeScene(type)
end

function MainCityLoading:GetScenePrefab(type,load)
  return SceneHomeManager:Get():GetScenePrefab(type,load)
end

function MainCityLoading:OnBreak()
    LoadingBase:OnBreak()
    if self.coroutine ~= nil then
        cs_coroutine.stop(self.coroutine)
        self.coroutine = nil
    end
end
function MainCityLoading:Clear()
    SceneHomeManager:Get():Clear()
end
return MainCityLoading