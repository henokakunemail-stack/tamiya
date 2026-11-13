---@class BattlePauseView : ViewBase
BattlePauseView = class("BattlePauseView", ViewBase)

function BattlePauseView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "BattlePauseViewAction")
end

function BattlePauseView:InitBtnInfo()
    local bgBtn = self:GetChild("BgBtn")
    CommonHelper:HButtonSetCallback("ExitBtn", bgBtn, function(param)
        self: OnExitBtnClick()
    end)
    CommonHelper:HButtonSetCallback("ContinueBtn", bgBtn, function(param)
        self:OnContinueBtnClick()
    end)
end
function BattlePauseView:OnExitBtnClick()
    UIManager:Get():HidePersistentView("BattlePauseView")
    UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_UpdateProtectBtnState, false)
    local BattleType = BattleDataManager:Get():GetBattleType()
    if BattleType == RaceModel.Battle  then
        PVEChapterDataManager:Get().Queue:Clear()
        PVEChapterDataManager:Get():BattleFinish()
    elseif BattleType == RaceModel.NewBieChapter  then
        NewBieChapterDataManager:Get().Queue:Clear()
        NewBieChapterDataManager:Get():BattleFinish()
    elseif BattleType == RaceModel.Challenge then
        SceneManager:Get():LoadingMainCity( LoadingMainCityType.BattleToWeekRank)
    elseif BattleType == RaceModel.ClubTrain then
        SceneManager:Get():LoadingMainCity( LoadingMainCityType.BattleToClubTrain)
    elseif BattleType == RaceModel.RaceSelf then
        SceneManager:Get():LoadingMainCity( LoadingMainCityType.BattleToRaceSelf)
    elseif BattleType == RaceModel.SelfChallenge then
        SceneManager:Get():LoadingMainCity( LoadingMainCityType.BattleToSelfChallenge)
    elseif BattleType == RaceModel.RaceSelfChapter then
        SceneManager:Get():LoadingMainCity( LoadingMainCityType.BattleToRaceSelfChapter)
    elseif BattleType == RaceModel.RaceSelfLevel then
        SceneManager:Get():LoadingMainCity( LoadingMainCityType.BattleToRaceSelfLevel)
    elseif BattleType == RaceModel.RaceAssemble then
        SceneManager:Get():LoadingMainCity( LoadingMainCityType.BattleToRaceAssemble)
    elseif BattleType == RaceModel.ClubRaceSelfChapter then
        SceneManager:Get():LoadingMainCity( LoadingMainCityType.BattleToClubRaceSelfChapter)
    elseif BattleType == RaceModel.ClubRaceSelfLevel then
        SceneManager:Get():LoadingMainCity( LoadingMainCityType.BattleToClubRaceSelfLevel)
    elseif BattleType == RaceModel.RaceRank  then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToPVPRank)
    elseif BattleType == RaceModel.RaceReplay_Pve then
        PVEChapterDataManager:Get().Queue:Clear()
        PVEChapterDataManager:Get():BattleHistoryFinish()
    elseif BattleType == RaceModel.GuideBattle then
        if PveLevelTestBattleDataManager:Get().LevelDataQueue.Size>0 then
            PveLevelTestBattleDataManager:Get():PopLevelData()
        else
            SceneManager:Get():LoadingMainCity(LoadingMainCityType.GuideBattleDone)
        end
    elseif BattleType == RaceModel.RaceReplay_Rank then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToPVPRank)
    elseif BattleType == RaceModel.RaceJcp then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToJcp)
    elseif BattleType == RaceModel.RaceXcp then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToXcp)
    elseif BattleType == RaceModel.CustomTestBattle then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.CustomTrackTestRunDone)
    elseif BattleType == RaceModel.RaceTrot then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceTrot)
    elseif BattleType == RaceModel.RaceClub3v3 then
        RaceClub3V3Manager:Get().Queue:Clear()
        RaceClub3V3Manager:Get():BattleFinish()
    elseif BattleType == RaceModel.RaceTop then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceTop)
    elseif BattleType == RaceModel.RaceTopSuper then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceTopSuper)
    elseif BattleType == RaceModel.RaceRoom then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceRoom)
    elseif BattleType == RaceModel.RaceSeniorTrain then
        RaceSeniorTrainManager:Get().Queue:Clear()
        RaceSeniorTrainManager:Get():BattleFinish()
    elseif BattleType == RaceModel.RaceCarGod then
        RaceCarGodDataManager:Get().Queue:Clear()
        RaceCarGodDataManager:Get():BattleFinish()
    elseif BattleType == RaceModel.RaceSuperBattle then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceSuperBattle)
    elseif BattleType == RaceModel.RaceAssembleTest then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceAssembleTest)
    end
    BattleDataManager:Get():SetStateBattleExit()
end



function BattlePauseView:OnContinueBtnClick()
    CSLuaHelper.BattleContinue()
    UIManager:Get():HidePersistentView("BattlePauseView")
    local trackType = BattleDataManager:Get():GetTrackType()
    if trackType == TrackType.Free then
        UINotify:Get():SendNotification(UINotifyEvent.BattleNewOutdoorView_SetSkillTweenIsPause, false)
    end
end


function BattlePauseView:OnOpen()
    self:InitBtnInfo()
end