---@class BattleResultView : ViewBase
BattleResultView = class("BattleResultView", ViewBase)

function BattleResultView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "BattleResultViewAction")
end

function BattleResultView:Awake()
    self.pagePlayerSampleInfoView=PagePlayerSampleInfoView(UIUtil.GetChild("Page_PlayerSampleInfoView",self.gameObject), UIModuleID.BattleResult)
    self:InitBtnFunc()
end

function BattleResultView:OnOpen()
    self.pageBattleResult = PageBattleResult(self.gameObject, UIModuleID.BattleResult,self)
    self.pageBattleResult:InitViewInfo()
    self:CheckNewBieGuide()

    local battleType = BattleDataManager:Get():GetBattleType()
    local isNewShowHead =BattleDataManager:Get():IsNewShowHead()
    CommonHelper:SetGameObjectActive("Page_PlayerSampleInfoView",self.gameObject,isNewShowHead)
    local data = SpecialTrainingDataManager:Get():GetCurChallengeTeam()
    if battleType == RaceModel.RaceRoom  or (data ~= nil and data.id == 4) then
        CommonHelper:SetHButtonClick(self.BtnPlayBack, false, true)
    else
        CommonHelper:SetHButtonClick(self.BtnPlayBack, true, true)
    end

    if (battleType==RaceModel.RaceClub3v3 and RaceClub3V3Manager:Get().Queue and RaceClub3V3Manager:Get().Queue:GetSize()>0) or
       (battleType==RaceModel.Battle  and PVEChapterDataManager:Get().Queue and PVEChapterDataManager:Get().Queue:GetSize()>0) or
       (battleType==RaceModel.NewBieChapter  and NewBieChapterDataManager:Get().Queue and NewBieChapterDataManager:Get().Queue:GetSize()>0) or
       (battleType==RaceModel.RaceReplay_Pve  and PVEChapterDataManager:Get().Queue and PVEChapterDataManager:Get().Queue:GetSize()>0) or
       (battleType==RaceModel.RaceSeniorTrain  and RaceSeniorTrainManager:Get().Queue and RaceSeniorTrainManager:Get().Queue:GetSize()>0) or
       (battleType==RaceModel.RaceJcp  and RaceJcpManager:Get().Queue and RaceJcpManager:Get().Queue:GetSize()>0) or
       (battleType==RaceModel.RaceXcp  and RaceXCupManager:Get().Queue and RaceXCupManager:Get().Queue:GetSize()>0) or
       (battleType==RaceModel.RaceCarGod  and RaceCarGodDataManager:Get().Queue:GetSize()>0)
    then
        CommonHelper:SetHButtonClick(self.BtnNext, true, true)
        CommonHelper:SetHButtonClick(self.BtnBack, false, true)
        CommonHelper:SetHButtonClick(self.BtnReport, false, true)
    else
        CommonHelper:SetHButtonClick(self.BtnNext, false, true)
        CommonHelper:SetHButtonClick(self.BtnBack, true, true)
        CommonHelper:SetHButtonClick(self.BtnReport, RankListTestVerifyDataManager:Get().Recording, true)
    end

    local sampleInfoData = BattleDyDataManager:Get():GetSelfCarData():GetSampleInfo() --BattleDataManager:Get():GetFirstPlaySampleData()
    CommonHelper:SetGameObjectActive("Page_PlayerSampleInfoView",self.gameObject,isNewShowHead and sampleInfoData~=nil)
    if sampleInfoData then
        self.pagePlayerSampleInfoView:Refresh(sampleInfoData)
    end
    local PlayerData=BattleDataManager:Get():GetDefaultPlayerBattleResultData()
    CommonHelper:SetHButtonClick(self.BtnHelpError,PlayerData:GetError() and PlayerData:GetError()~=BattleFailError.None,true)
end

function BattleResultView:InitBtnFunc()
    self.BtnBack=CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(hbtn)
        self:OnBtnBackFunc(BattleDataManager:Get():GetBattleType())
    end)
    self.BtnNext=CommonHelper:HButtonSetCallback("BtnNext", self.gameObject, function(hbtn)
        self:OnClickNext(BattleDataManager:Get():GetBattleType())
    end)
    self.BtnHelpError= CommonHelper:HButtonSetCallback("BtnError", self.gameObject, function()
        local PlayerData=BattleDataManager:Get():GetDefaultPlayerBattleResultData()
        CommonHelper:ShowHelpView(PlayerData:GetError())
    end)
     self.BtnPlayBack = CommonHelper:HButtonSetCallback("BtnPlayBack", self.gameObject, function(hbtn)
        UIManager:Get():CloseAllViews()
        BattleDyDataManager:Get():ResetPlayAni()
        BattleDataManager:Get():PlayAgain()
    end)
     self.BtnReport = CommonHelper:HButtonSetCallback("BtnReport", self.gameObject, function(hbtn)
         local boxFunc = function()
             local ret = MessageBoxHelp:Get():OpenBox_OKCancel(nil,CommonHelper:GetTempStr_Default(TemplateStringID.ReportHit,BattleDyDataManager:Get():GetSelfCarData().playerName))
             if ret == MessageBoxHelp.BtnType.OK then
                 RankListTestVerifyDataManager:Get():Report()
                 CommonHelper:SetHButtonClick(self.BtnReport, false, true)
                 CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ReportSuccess))
             end
         end
         MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
    end)
end

---@param BattleType RaceModel
function BattleResultView:OnBtnBackFunc(BattleType)
    UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_UpdateProtectBtnState, false)
    if BattleType == RaceModel.Battle then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToChapter, BattleDataManager:Get():GetLevelId())
    elseif BattleType == RaceModel.NewBieChapter then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToNewBieChapter, BattleDataManager:Get():GetLevelId())
    elseif BattleType == RaceModel.Challenge then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToWeekRank)
    elseif BattleType == RaceModel.ClubTrain then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToClubTrain)
    elseif BattleType == RaceModel.RaceRoom then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceRoom)
    elseif BattleType == RaceModel.RaceRank or BattleType ==RaceModel.RaceReplay_Rank then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToPVPRank)
    elseif BattleType == RaceModel.RaceSelf then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceSelf)
    elseif BattleType == RaceModel.SelfChallenge then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToSelfChallenge)
    elseif BattleType == RaceModel.RaceSelfChapter then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceSelfChapter)
    elseif BattleType == RaceModel.RaceSelfLevel then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceSelfLevel)
    elseif BattleType == RaceModel.RaceAssemble then
        SceneManager:Get():LoadingMainCity( LoadingMainCityType.BattleToRaceAssemble)
    elseif BattleType == RaceModel.ClubRaceSelfChapter then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToClubRaceSelfChapter)
    elseif BattleType == RaceModel.RaceAssembleTest then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceAssembleTest)
    elseif BattleType == RaceModel.ClubRaceSelfLevel then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.RaceSelfLevel)
    elseif BattleType == RaceModel.RaceJcp then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToJcp)
    elseif BattleType == RaceModel.RaceXcp then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToXcp)
    elseif BattleType == RaceModel.RaceReplay_Pve then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToChapter, PVEChapterDataManager:Get():GetCurLevelData().id)
    elseif BattleType == RaceModel.CustomTestBattle then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.CustomTrackTestRunDone)
    elseif BattleType == RaceModel.RaceTrot then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceTrot)
    elseif BattleType == RaceModel.RaceClub3v3 then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToClub3V3)
    elseif BattleType == RaceModel.RaceTop then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceTop)
    elseif BattleType == RaceModel.RaceTopSuper then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceTopSuper)
    elseif BattleType == RaceModel.RaceGVG then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceGVG)
   elseif BattleType == RaceModel.RaceSeniorTrain then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceSeniorTrain,RaceSeniorTrainManager:Get():GetCurLevelData().id)
   elseif BattleType == RaceModel.RaceCarGod then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceCarGod)
   elseif BattleType == RaceModel.RaceSuperBattle then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceSuperBattle)
    end
    BattleDataManager:Get():SetStateBattleExit()
    CommonHelper:OpenLevelUpView()
end

function BattleResultView:OnBackKey()

end
function BattleResultView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.BattleResult)
end

function BattleResultView:OnClickNext(battleType)
    if battleType==RaceModel.RaceClub3v3 then
        RaceClub3V3Manager:Get():BattleFinish()
    end
    if battleType==RaceModel.Battle then
        PVEChapterDataManager:Get():BattleFinish()
    end
    if battleType==RaceModel.NewBieChapter then
        NewBieChapterDataManager:Get():BattleFinish()
    end
    if battleType==RaceModel.RaceReplay_Pve then
        PVEChapterDataManager:Get():BattleHistoryFinish()
    end
    if battleType==RaceModel.RaceCarGod then
        if BattleDataManager:Get():IsReplay() then
            RaceCarGodDataManager:Get():BattleHistoryFinish()
        else
            RaceCarGodDataManager:Get():BattleFinish()
        end
    end
    if battleType==RaceModel.RaceJcp then
        RaceJcpManager:Get():BattleFinish()
    end
    if battleType==RaceModel.RaceXcp then
        RaceXCupManager:Get():BattleFinish()
    end
    if battleType==RaceModel.RaceSeniorTrain then
        if BattleDataManager:Get():IsReplay() then
            RaceSeniorTrainManager:Get():BattleHistoryFinish()
        else
            RaceSeniorTrainManager:Get():BattleFinish()
        end
    end
end


