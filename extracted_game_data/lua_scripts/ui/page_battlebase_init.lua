---@class Page_BattleBase
Page_BattleBase = class("Page_BattleBase")

function Page_BattleBase:CacheBaseData(parentPref, moduleId)

    self.parentPref = UIUtil.GetChild("Page_BattleRank", parentPref)

    self.moduleId = moduleId
    self:CacheRankItemData()

    self:InitBtnFunc()

    ---@type dictcalc_config
    local cell = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.MaxSpeedCfgID)

    local isNewShowHead = BattleDataManager:Get():IsNewShowHead()
    local HeadNewRoot =   UIUtil.GetChild("HeadNewRoot",self.parentPref)
    local HeadOldRoot =   UIUtil.GetChild("HeadOldRoot",self.parentPref)
    local newSlider = UIUtil.GetChild("ProtectGasSlider",HeadNewRoot)
    newSlider = newSlider==nil and UIUtil.GetChild("NewProtectGasSlider",HeadNewRoot) or newSlider
    local oldSlider = UIUtil.GetChild("ProtectGasSlider",HeadOldRoot)
    oldSlider = oldSlider==nil and UIUtil.GetChild("OldProtectGasSlider",HeadOldRoot) or oldSlider
    oldSlider.gameObject.name =isNewShowHead and "OldProtectGasSlider" or "ProtectGasSlider"
    newSlider.gameObject.name =isNewShowHead and "ProtectGasSlider" or "NewProtectGasSlider"
    CSLuaHelper.Get():SetBattleOutdoorViewGo(self.parentPref, tonumber(cell.varval),BattleDataManager:Get():GetTrackData():GetRaceNumber())--给c#传入战斗实时刷新的组件
    CSLuaHelper.Get():BattleViewOnAnimEnd(0.3,0.2,0.2,0)
    self:InitBaseData()

    self.isShowCanvas = false

    --self:AutoChangeCamera(5)
end

function Page_BattleBase:InitBaseData()

    self:InitInputSkillBtn()
    self:InitCameraData()

    self:InitRankGoData()

    self:CacheShortCutData()

    self:InitShortCutData()

    self:InitBaseViewByBattleType()

end

function Page_BattleBase:CacheRankItemData()
    self.rankIdGoDic = {}
    self.rankGoPositionList = {}--排名物体的初始位置
    self.fxTweenGroup = {}--动画组
    self.isPlayInitAni = true--是否正在播放初始动画
    self.talkList = {}
    self.RankParent=UIUtil.GetChild("TweenRankPos/rankgroup",self.parentPref)
    self.startTweenMoreGroup = UIUtil.GetTypeChildWightByParent("BattleRankList", self.parentPref, typeof(FXUITweenMoreGroup))

    for i = 0, BattleDyDataManager:Get():GetCarCount() - 1 do

        local tweenRankItemTrans = UIUtil.GetChild(string.format("tweenRank%d", i + 1), self.parentPref)
        local carData = BattleDyDataManager:Get():GetCarDataByIndex(i + 1)

        local battleRankItemViewTrans = UIUtil.GetGameobjectComponent(tweenRankItemTrans.gameObject, typeof(RectTransform))
        local anchoredPosition = battleRankItemViewTrans.anchoredPosition
        table.insert(self.rankGoPositionList, Vector3(540, anchoredPosition.y, 0))

        self.rankIdGoDic[carData:GetCarId()] = battleRankItemViewTrans
        self.fxTweenGroup[carData:GetCarId()] = UIUtil.GetGameobjectComponent(tweenRankItemTrans.gameObject, typeof(FXUITweenMoreGroup))

        local talkItemTweenMoreGroup = UIUtil.GetTypeChildWightByParent(string.format("Talk%d", i + 1), self.parentPref, typeof(FXUITweenMoreGroup))
        table.insert(self.talkList, talkItemTweenMoreGroup)
        print("--------初始化item时的carId", carData:GetCarId(), "------当前为空吗", self.rankIdGoDic[carData:GetCarId()] == nil, "-----当前位置", Vector3(anchoredPosition.x, anchoredPosition.y, 0))
    end
end

function Page_BattleBase:InitBtnFunc()
    self.BtnPause = CommonHelper:HButtonSetCallback("BtnPause", self.parentPref, function(param)
        if BattleDyDataManager:Get():GetProtectBtnState()==false or BattleDyDataManager:Get():GetProtectBtnState()==nil then
            CSLuaHelper.BattlePause()
            UIManager:Get():ShowPersistentView("BattlePauseView", CanvasType.MainCanvas, "BattlePauseView")
        end
    end)
    self.BtnSkillDetail = CommonHelper:HButtonSetCallback("BtnSkillDetail", self.parentPref, function(param)
        if BattleDyDataManager:Get():GetProtectBtnState()==false or BattleDyDataManager:Get():GetProtectBtnState()==nil then
            CSLuaHelper.BattlePause()
            UIManager:Get():ShowPersistentView("SkillDetailView", CanvasType.MainCanvas, "SkillDetailView")
        end

    end)
    self.BtnSkip = CommonHelper:HButtonSetCallback("BtnSkip", self.parentPref, function(param)
        if BattleDataManager:Get():GetBattleState()==BattleState.Fighting  then
            CSLuaHelper.Get():JumpQuickExecuteGame()
            self:SetSkipBtn(false,false)
        end
    end)
    self.TogDoubleSpeed = CommonHelper:HButtonSetCallback("TogDoubleSpeed", self.parentPref, function(param)
        BattleDataManager:Get():EnableDoubleSpeed(not BattleDataManager:Get().IsDoubleSpeed,true,true)
        CommonHelper:SetToggleState(self.TogDoubleSpeed,BattleDataManager:Get().IsDoubleSpeed)
    end)
    BattleDataManager:Get():EnableDoubleSpeed(false,false,false)
    CommonHelper:SetToggleState(self.TogDoubleSpeed,BattleDataManager:Get().IsDoubleSpeed)
    self:SetDoubleSpeedBtn(false,true)
    self.BtnSet = CommonHelper:HButtonSetCallback("BtnSet", self.parentPref, function(param)

    end)

    self.BtnQuickChat = CommonHelper:HButtonSetCallback("BtnQuickChat", self.parentPref, function(param)
        UIUtil.ShowCanvasGroup(self.ShortCutCanvasGroup, true)

        if not self.isShowCanvas then
            CommonHelper:TweenGroupScale("TweenShortBgScale", self.ShortCutCanvasGroup.gameObject, 0)
        else
            CommonHelper:TweenGroupScale("TweenShortBgScale", self.ShortCutCanvasGroup.gameObject, 1)
        end
        self.isShowCanvas = not self.isShowCanvas

        self.chatShortCutData:InitShortList(ChatShortCutType.Msg)
    end)
    self.cameraTog = {}
    self:OpenGameTools()
    for i = 1, 4 do
        local tog = CommonHelper:HButtonSetCallback("Tog" .. i, self.parentPref, function(param)
            self:OnCameraTypeBtnClick(i)
            self:StopAutoChangeCamera()
        end)
        table.insert(self.cameraTog, tog)
    end
    self.BrakeBtn = UIUtil.GetTypeChildWightByParent("BrakeBtn",self.parentPref, typeof(HButton))
    self.ProtectBtn = UIUtil.GetTypeChildWightByParent("ProtectBtn",self.parentPref, typeof(HButton))
    self.BrakeBtn_TMG = UIUtil.GetTypeChildWightByParent("BrakeBtn",self.parentPref, typeof(FXUITweenMoreGroup))
    self.BuffScrollView = UIUtil.GetTypeChildWightByParent("MoreRowScrollView_BuffList",self.parentPref, typeof(MoreRowScrollView))
    self.CostAttrSlider = UIUtil.GetChild("TweenSpeedPos/Attr",self.parentPref)
    CommonHelper:RegisterBtnOnPointDown(self.BrakeBtn, function(param)
        self.TempAccelerateBtnState=self.AccelerateBtnState
        if self.AccelerateBtnState then
            self:UpdateAccelerateBtnState(false,false)
        end
        CSLuaHelper.Get():OnPressSkillSlotDown(0)
        CommonHelper:SetShaderBoolValue("BtnPressImage", self.gameObject, "_BLUEYELLLOW_ON", false)
        CommonHelper:TMG_SetPlayTweenGroup(self.BrakeBtn_TMG, 0, 0)
        CommonHelper:TMG_PlayAllTween(self.BrakeBtn_TMG, 0)

    end)

    CommonHelper:RegisterBtnOnPointUp(self.BrakeBtn, function(param)
        if self.TempAccelerateBtnState then
            self:UpdateAccelerateBtnState(true,false)
        end
        CSLuaHelper.Get():OnPressSkillSlotUp(0)
        CommonHelper:SetShaderBoolValue("BtnPressImage", self.gameObject, "_BLUEYELLLOW_ON", false)
        CommonHelper:TMG_SetPlayTweenGroup(self.BrakeBtn_TMG, 0, 0)
        CommonHelper:TMG_PlayAllTween(self.BrakeBtn_TMG, 0)
    end)
    self.AccelerateBtn= CommonHelper:HButtonSetCallback("TweenBtnAcceleratePos/AccelerateBtn",self.parentPref,function(hbtn)
        self:SetBreakBtnState(false)
        if BattleDyDataManager:Get():GetSelfCarData():CheckClickCount() then
            BattleDyDataManager:Get():GetSelfCarData():SetClickCount(1)
            MonoHelper:ClickAccelBeanBtn(1)
        end
    end)
    self.AccelerateBtn2= CommonHelper:HButtonSetCallback("TweenBtnAcceleratePos2/AccelerateBtn",self.parentPref,function(hbtn)
        self:SetBreakBtnState(false)
        if BattleDyDataManager:Get():GetSelfCarData():CheckClickCount() then
            BattleDyDataManager:Get():GetSelfCarData():SetClickCount(1)
            MonoHelper:ClickAccelBeanBtn(1)
        end
    end)
    --local battleType=BattleDataManager:Get():GetBattleType()
    local isNewShowHead = BattleDataManager:Get():IsNewShowHead()
    local HeadRoot = isNewShowHead and UIUtil.GetChild("HeadNewRoot",self.parentPref) or  UIUtil.GetChild("HeadOldRoot",self.parentPref)
     self.BeanScrollView= UIUtil.GetTypeChildWightByParent("ScrollView_Boost",HeadRoot, typeof(InfinityScrollView))
     --self.BeanScrollView= UIUtil.GetTypeChildWightByParent("ScrollView_Boost",self.parentPref, typeof(InfinityScrollView))
end

---@param battleType RaceModel
function Page_BattleBase:InitBaseViewByBattleType(battleType)
    battleType = battleType or BattleDataManager:Get():GetBattleType()
    local isNewShowHead = BattleDataManager:Get():IsNewShowHead()
    local HeadRoot = isNewShowHead and UIUtil.GetChild("HeadNewRoot",self.parentPref) or  UIUtil.GetChild("HeadOldRoot",self.parentPref)

    CommonHelper:SetText("###LAPTotalCountText", self.parentPref, tostring(BattleDataManager:Get():GetRound()))

    ---@type dictlevelup_config_cell
    local cfg=CommonHelper:GetTableDataByID(ConfigNames.levelup_config,PlayerDataManager:Get():GetPlayerLV())
    local maxvalue= CommonHelper:GetTableDataByID(ConfigNames.minicarvalue_config,MiniCarValue.MaxProtect).value
    local minvalue= CommonHelper:GetTableDataByID(ConfigNames.minicarvalue_config,MiniCarValue.MinProtect).value
    if cfg then
        CommonHelper:SetSlider("ProtectGasMax",HeadRoot,(minvalue+cfg.energymax)/maxvalue)
    end

    ---@type miniskill_config_cell
    local cell = CommonHelper:GetTableDataByID(ConfigNames.miniskill_config, BattleDyDataManager:Get():GetSelfCarData():GetBuffers()[1])
    CommonHelper:SetGameObjectActive("BuffInfo", self.parentPref, false)
    CommonHelper:SetGameObjectActive("ProtectStage", self.parentPref, false)
    CommonHelper:SetGameObjectActive("bufflist", self.parentPref, not GameProperties.AssetBundleMode)
    if cell ~= nil then
        CommonHelper:SetText("###buffName", self.parentPref, CommonHelper:GetTempStr_Default(cell.name))
    end
    CommonHelper:SetSlider("InfoSlider", self.parentPref, 1)
    CommonHelper:SetToggleState(self.TogDoubleSpeed,BattleDataManager:Get().IsDoubleSpeed)

    --CommonHelper:SetHButtonClick(self.BrakeBtn, (battleType == RaceModel.Battle or battleType == RaceModel.RaceSeniorTrain) and (not BattleDataManager:Get():IsPlayAgain() and not BattleDataManager:Get():IsReplay() and not CommonHelper:CheckPlayerIsNewGuide()), true)
    if ((battleType == RaceModel.RaceRoom  and RaceRoomManager:Get():GetRaceType()==RaceRoomBattleType.Join) or
            (battleType == RaceModel.RaceRank and  RaceRankManager:Get():GetRaceType()==RaceRankRaceType.Battle) or
            (battleType == RaceModel.RaceClub3v3) or
            battleType == RaceModel.RaceTrot or
            battleType == RaceModel.RaceGVG or
            (battleType == RaceModel.RaceJcp and  RaceJcpManager:Get():GetRaceType()==RaceJcpRaceType.Battle) or
            (battleType == RaceModel.RaceXcp and  RaceXCupManager:Get():GetRaceType()==RaceJcpRaceType.Battle) or
            (battleType == RaceModel.RaceTop and  (RaceTopManager:Get():GetRaceType()==RaceTopRaceType.Audition or RaceTopManager:Get():GetRaceType()==RaceTopRaceType.RaceTop or RaceTopManager:Get():GetRaceType()==RaceTopRaceType.RaceB)) or
            (battleType == RaceModel.RaceTopSuper and  (RaceTopSuperManager:Get():GetRaceType()==RaceTopRaceType.Audition or RaceTopSuperManager:Get():GetRaceType()==RaceTopRaceType.RaceTop or RaceTopSuperManager:Get():GetRaceType()==RaceTopRaceType.RaceB))
       )
            and BattleDataManager:Get():IsReplay()==false then
        self:SetPauseBtn(false,true)
        CommonHelper:SetHButtonClick(self.BtnQuickChat, false, true)
        CommonHelper:SetGameObjectActive("ChatPart", self.parentPref, false)
    else
        self:SetPauseBtn(battleType~= RaceModel.NewBieChapter,true)
        CommonHelper:SetHButtonClick(self.BtnQuickChat, false, true)
        --CommonHelper:SetGameObjectActive("ChatPart", self.parentPref, false)
    end
    --for i = 1, 4 do
    --    CommonHelper:SetHButtonClick(self.cameraTog[i],not CommonHelper:CheckPlayerIsNewGuide(),true)
    --end
    local levelId = BattleDataManager:Get():GetLevelId()
    local levelData =nil
    if battleType== RaceModel.Battle then
        levelData= PVEChapterDataManager:Get():GetLevelDataByLevelId(levelId)
    end
    if battleType== RaceModel.NewBieChapter then
        levelData= NewBieChapterDataManager:Get():GetLevelDataByLevelId(levelId)
    end
    if battleType== RaceModel.RaceSeniorTrain then
        levelData= RaceSeniorTrainManager:Get():GetLevelDataByLevelId(levelId)
    end
    if battleType== RaceModel.Challenge then
        levelData= SpecialTrainingDataManager:Get():GetSelectCopyMsg()
    end
    self:SetBattleIsProtect(battleType,BattleDataManager:Get():IsReplay() or BattleDataManager:Get():IsPlayAgain() or  (battleType==RaceModel.RaceJcp and RaceJcpManager:Get():GetRaceType()==RaceJcpRaceType.Record) or  (battleType==RaceModel.RaceXcp and RaceXCupManager:Get():GetRaceType()==RaceJcpRaceType.Record) or (battleType==RaceModel.RaceTop and RaceTopManager:Get():GetRaceType()==RaceTopRaceType.Record) or (battleType==RaceModel.RaceTopSuper and RaceTopSuperManager:Get():GetRaceType()==RaceTopRaceType.Record) )
    print("Page_BattleBase",battleType == RaceModel.Battle and levelData.starNum > 0 and not CommonHelper:CheckPlayerIsNewGuide())
    print("Page_BattleBase",battleType == RaceModel.RaceSeniorTrain and levelData.starNum > 0 and not CommonHelper:CheckPlayerIsNewGuide())
    print("Page_BattleBase",battleType == RaceModel.RaceReplay_Pve)
    print("Page_BattleBase",BattleDataManager:Get():IsReplay())
    print( "Page_BattleBase",BattleDataManager:Get():IsPlayAgain())
    print( "Page_BattleBase",BattleDataManager:Get():IsPlayAgain())
    print( "Page_BattleBase",(battleType == RaceModel.RaceJcp and  RaceJcpManager:Get():GetRaceType()==RaceJcpRaceType.Record))
    print( "Page_BattleBase",(battleType == RaceModel.RaceXcp and  RaceXCupManager:Get():GetRaceType()==RaceJcpRaceType.Record))
    print(  "Page_BattleBase",(battleType == RaceModel.RaceTop and  RaceTopManager:Get():GetRaceType()==RaceTopRaceType.Record))
    print(  "Page_BattleBase",(battleType == RaceModel.RaceTopSuper and  RaceTopSuperManager:Get():GetRaceType()==RaceTopRaceType.Record))
   self:SetSkipBtn((battleType == RaceModel.Battle and levelData.starNum > 0 and not CommonHelper:CheckPlayerIsNewGuide() ) or
            (battleType == RaceModel.RaceSeniorTrain and levelData.starNum > 0 and not CommonHelper:CheckPlayerIsNewGuide()) or
            (battleType == RaceModel.NewBieChapter and levelData.starNum > 0 and not CommonHelper:CheckPlayerIsNewGuide()) or
            (battleType == RaceModel.Challenge and levelData.winsum > 0 and not CommonHelper:CheckPlayerIsNewGuide()) or
            (battleType == RaceModel.RaceReplay_Pve) or
            (battleType == RaceModel.RaceClub3v3) or
            (battleType == RaceModel.RaceGVG) or
            (battleType == RaceModel.RaceAssembleTest) or
            (battleType == RaceModel.RaceRank and RaceRankManager:Get():GetProtectType()~= RaceProtectType.Protect) or
            (battleType == RaceModel.RaceJcp and  (RaceJcpManager:Get():GetRaceType()==RaceJcpRaceType.Record or RaceJcpManager:Get():GetRaceType()==RaceJcpRaceType.Test)) or
            (battleType == RaceModel.RaceXcp and  (RaceXCupManager:Get():GetRaceType()==RaceJcpRaceType.Record or RaceXCupManager:Get():GetRaceType()==RaceJcpRaceType.Test)) or
            (battleType == RaceModel.RaceTop and  (RaceTopManager:Get():GetRaceType()==RaceTopRaceType.Record or RaceTopManager:Get():GetRaceType()==RaceTopRaceType.Test)) or
            (battleType == RaceModel.RaceTopSuper and  (RaceTopSuperManager:Get():GetRaceType()==RaceTopRaceType.Record or RaceTopSuperManager:Get():GetRaceType()==RaceTopRaceType.Test)) or
            BattleDataManager:Get():IsReplay() or
            BattleDataManager:Get():IsPlayAgain()
            ,true)

    UIUtil.ShowCanvasGroup(self.ShortCutCanvasGroup, false)
end

function Page_BattleBase:OnBattleFinished(finishedData)
    local carId = finishedData[1]
    local battleFailError = finishedData[4]

    --self:OnPvPFailed(carId, battleFailError)

    local rankItem = self.rankIdGoDic[carId]
    if rankItem == nil then
        print("------------->rankItem为空 carId", carId)
        return
    end
    local finishedImageGo = nil
    if battleFailError == BattleFailError.None then
        finishedImageGo = UIUtil.GetTypeChildWightByParent("FinishedImage", rankItem.gameObject, typeof(FXUITweenMoreGroup))
        CommonHelper:CSGameObjectSetActive(finishedImageGo.gameObject, true)
        CommonHelper:TMG_PlayAllTween(finishedImageGo)
    else
        CommonHelper:SetGameObjectActive("HeadBlackBg", rankItem.gameObject, true)
        CommonHelper:SetGameObjectActive("HeadBlackBg2", rankItem.gameObject, true)
    end
    if carId == BattleDyDataManager:Get():GetSelfCarData():GetCarId() then
        BattleDataManager:Get().BattleTime=CommonHelper:SubTimeByDateTime(BattleDataManager:Get().BattleStartTime)
        self:UpdateAccelerateBtnState(false,nil,false)
        self:SetBreakBtnState(false)
        self:UpdateProtectBtnState(false,nil,false)
        print("44444444444444444------->>>",BattleDataManager:Get().BattleTime)
    end



    self:SelfComplete(carId == BattleDyDataManager:Get():GetSelfCarData():GetCarId())
    if carId == BattleDyDataManager:Get():GetSelfCarData():GetCarId() and not RaceRoomManager:Get():IsLeader() then
        BattleDyDataManager:Get():SetIsSelfFinished(true)
        self:SetSkipBtn(true,true)
        self:InitBattleExplainState(BattleExplainState.Closed)
    end
end

function Page_BattleBase:OnPvPFailed(carId, battleFailError)
    local battleType = BattleDataManager:Get():GetBattleType()
    if battleType == RaceModel.RaceRank or battleType == RaceModel.RaceRoom then
        if BattleDyDataManager:Get():GetSelfCarData():GetCarId() == carId and battleFailError ~= BattleFailError.None then
            local boxFunc = function()
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(nil, CommonHelper:GetTempStr_Default(TemplateStringID.IsShowBattle))
                if ret == MessageBoxHelp.BtnType.OK then
                else
                    self:OnBtnBackFunc(battleType)
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
        end
    end
end

---@param BattleType RaceModel
function Page_BattleBase:OnBtnBackFunc(BattleType)
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
    elseif BattleType == RaceModel.RaceRank then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToPVPRank)
    elseif BattleType == RaceModel.RaceSelf then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceSelf)
    elseif BattleType == RaceModel.SelfChallenge then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToSelfChallenge)
    elseif BattleType == RaceModel.RaceSelfChapter then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.RaceSelfChapter)
    elseif BattleType == RaceModel.RaceSelfLevel then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.RaceSelfLevel)
    elseif BattleType == RaceModel.RaceAssemble then
        SceneManager:Get():LoadingMainCity( LoadingMainCityType.BattleToRaceAssemble)
    elseif BattleType == RaceModel.ClubRaceSelfChapter then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.RaceSelfChapter)
    elseif BattleType == RaceModel.ClubRaceSelfLevel then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.RaceSelfLevel)
    elseif BattleType == RaceModel.RaceTrot then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceTrot)
    elseif BattleType == RaceModel.RaceClub3v3 then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToClub3V3)
    elseif BattleType == RaceModel.RaceTop then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceTop)
    elseif BattleType == RaceModel.RaceTopSuper then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToRaceTopSuper)
    end
    BattleDataManager:Get():SetStateBattleExit()
end

---------镜头设置
function Page_BattleBase:InitCameraData()
    self.cameraData = {}


    ---@type cameratype_config
    local cameratype_config = ClientDataManager:Get():GetDataTable(ConfigNames.cameratype_config)

    cameratype_config = cameratype_config.GetConfigData()

    ---@param cell cameratype_config_cell
    for k, cell in pairs(cameratype_config) do
        local id=cell.C_ID
        local pointTableStr = stringSplit(cell.slots, ',')
        local pointTable = {}

        for i = 1, #pointTableStr do
            table.insert(pointTable, tonumber(pointTableStr[i]))
        end

        self.cameraData[id] = pointTable
    end
    self.cameraType = PlayerPrefsHelper:GetValue_CameraType()
    if self.cameraData and self.cameraData[self.cameraType] then
        self.pointIndex = PlayerPrefsHelper:GetValue_PointIndex(self.cameraType,#self.cameraData[self.cameraType])
    end
    self:InitCameraBtnInfo(self.cameraType)

    if self.cameraData[self.cameraType] and self.cameraData[self.cameraType][self.pointIndex] then
        print("------当前的视角:---cameraType:", self.cameraType, "----pointIndex:", self.pointIndex, "--------镜头组：", self.cameraData[self.cameraType][self.pointIndex])
    else
        self.cameraType=1
        self.pointIndex=1
        self:SaveCameraData()
    end
    LuaHelper.ChangeRaceInitCameraView(self.cameraData[self.cameraType][self.pointIndex])
    --CSLuaHelper.ChangeRaceInitCameraView(self.cameraData[self.cameraType][self.pointIndex])
end

function Page_BattleBase:InitCameraBtnInfo(togIdx)

    for i = 1, #self.cameraTog do
        CommonHelper:SetToggleState(self.cameraTog[i], togIdx == i)
    end
    if togIdx == 1 then
        CommonHelper:SetText("###PointCountText", self.cameraTog[1].gameObject, tostring(self.pointIndex))
    end

    if togIdx == 2 then
        CommonHelper:SetText("###PointCountText", self.parentPref, tostring(self.pointIndex))
    end

    print("cameraType------", self.cameraType, "pointIndex------", self.pointIndex)
end

function Page_BattleBase:InitInputSkillBtn()

    local btn = UIUtil.GetTypeChildWightInputPath("PressSkillBtn", self.parentPref, typeof(HButton))

    CommonHelper:RegisterBtnOnPointDown(btn, function(param)
        CSLuaHelper.Get():OnPressSkillSlotDown(0);
    end)

    CommonHelper:RegisterBtnOnPointUp(btn, function(param)
        CSLuaHelper.Get():OnPressSkillSlotUp(0);
    end)
end

function Page_BattleBase:OnCameraTypeBtnClick(togIdx)
    if self.cameraType == togIdx then
        self.pointIndex = self.pointIndex + 1
    else
        self.cameraType = togIdx
        self.pointIndex = PlayerPrefsHelper:GetValue_PointIndex(self.cameraType,1)
    end

    local pointType = self.cameraData[self.cameraType][self.pointIndex]
    self.pointIndex = pointType == nil and 1 or self.pointIndex
    self:SaveCameraData()
    self:InitCameraBtnInfo(togIdx)

    --[[local followModel = CSCameraManager.Get().followModel2
    followModel.followLengthRatio = 1.2941
    followModel.followRotationRatio = 1.13
    followModel.forwardOffset = 3.55
    followModel.rotationDamping = 28.9

    followModel.followLengthRatio = 1
    followModel.followRotationRatio = 1
    followModel.rotationDamping = 20.0
    followModel.forwardOffset = 0]]--

    LuaHelper.ChangeRaceRunCameraView(self.cameraData[self.cameraType][self.pointIndex])
    --CSLuaHelper.ChangeRaceRunCameraView(self.cameraData[self.cameraType][self.pointIndex])
end


function Page_BattleBase:OnCameraTypeRandom(togIdx)
    if self.cameraType == togIdx then
        self.pointIndex = self.pointIndex + 1
    else
        self.cameraType = togIdx
        self.pointIndex = 1
    end

    local pointType = self.cameraData[self.cameraType][self.pointIndex]
    self.pointIndex = pointType == nil and 1 or self.pointIndex

    self:InitCameraBtnInfo(togIdx)
    CSLuaHelper.ChangeRaceRunCameraViewRandom(self.cameraData[self.cameraType][self.pointIndex])
end

function Page_BattleBase:InitBattleExplainState(battleExplainState)
    if battleExplainState == BattleExplainState.CanOpen then
        CommonHelper:SetGameObjectActive("SpeedDesc", self.parentPref, false)
        BattleDyDataManager:Get():SetExplainState(BattleExplainState.Opened)
    elseif battleExplainState == BattleExplainState.Closed then
        CommonHelper:SetGameObjectActive("SpeedDesc", self.parentPref, false)
        BattleDyDataManager:Get():SetExplainState(BattleExplainState.Opened)
    end
end

--3镜头切1镜头 5秒  1切3 3秒
local curBtnIndex = 1
function Page_BattleBase:AutoChangeCamera(time)
    if false then return end
    self.changeCameraTimeId = TimerManager:Get():CreateTimerLoop(time, function()
        self:OnCameraTypeRandom(curBtnIndex)
        self:StopAutoChangeCamera()
        curBtnIndex = curBtnIndex == 1 and 3 or 1
        self:AutoChangeCamera(curBtnIndex == 3 and 3 or 5)
    end, self, false)
end

function Page_BattleBase:StopAutoChangeCamera()
    if self.changeCameraTimeId ~= -1 then
        TimerManager:Get():StopTimer(self.changeCameraTimeId)
        self.changeCameraTimeId = -1
    end
end

function Page_BattleBase:SaveCameraData()
    print("------当前的视角:---cameraType:",self.cameraType,self.pointIndex)
    PlayerPrefsHelper:SetValue_CameraType(self.cameraType)
    PlayerPrefsHelper:SetValue_PointIndex(self.cameraType,self.pointIndex)
end
function Page_BattleBase:OpenGameTools()
    CommonHelper:SetGameObjectActive("Tog2", self.parentPref,GameProperties.GMEnable)
    CommonHelper:SetGameObjectActive("Tog3", self.parentPref,GameProperties.GMEnable)
end
function Page_BattleBase:OpenBattleBreakButton(flag)
    CommonHelper:SetHButtonClick(self.BrakeBtn, flag,true)
end

function Page_BattleBase:ProtectStageStart(duration)
    if self.ProtectStateTimer then
        cs_coroutine.stop(self.ProtectStateTimer)
    end
    local ProtectStage=  CommonHelper:SetGameObjectActive("ProtectStage", self.parentPref, true)
    local text=UIUtil.GetTypeChildWightByParent("###time",ProtectStage,typeof(Text))
   self.ProtectStateTimer= cs_coroutine.start(function()
        while duration>0 do
            duration=duration-CSTime.deltaTime
            local showTime=string.format("%04d",math.floor(duration*1000))
            CommonHelper:SetTextByGo(text,CommonHelper:GetTempStr_Default(TemplateStringID.ProtectTimeFormat,string.sub(showTime, 1, 1),string.sub(showTime, 2, 2),string.sub(showTime, 3, 3),string.sub(showTime, 4, 4)))
            coroutine.yield()
        end
       self.ProtectStateTimer=nil
        CommonHelper:SetGameObjectActive("ProtectStage", self.parentPref, false)
    end)
end
local DefaultCount=5
local _ShowBuffList={}
function Page_BattleBase:UpdateBuffList(type,id,opType,state,value,duration)
    if self.BuffList==nil then
        ---@type CarBuffData[]
        self.BuffList={}
        self.BuffIdxList={}
        self.IsBuffListRefresh=false
    else
        self.IsBuffListRefresh=true
    end
    if opType==BattleBuffOpType.Clear then
        self.BuffList=nil
        self.BuffIdxList={}
    elseif self.BuffList[id] and self.BuffIdxList[self.BuffList[id].Idx]  and opType==BattleBuffOpType.Remove then
       -- table.remove(self.BuffIdxList,self.BuffList[id].Idx)
        self.BuffList[id]=nil
    else
        if self.BuffList[id]==nil then
            local carBuffData=CarBuffData(id,#self.BuffIdxList+1,state,value,type,duration)
            self.BuffIdxList[#self.BuffIdxList+1]=id
            self.BuffList[id]=carBuffData
        else
            self.BuffIdxList[self.BuffList[id].Idx]=id
            self.BuffList[id]=CarBuffData(id,self.BuffList[id].Idx,state,value,type,duration)
        end
    end
    _ShowBuffList={}
    for i = 1, #self.BuffIdxList do
        if self.BuffList and self.BuffIdxList[i] and self.BuffList[self.BuffIdxList[i]]~=nil and self.BuffList[self.BuffIdxList[i]].State then
            table.insert(_ShowBuffList,self.BuffIdxList[i])
        end
    end
    if self.BuffList==nil then
        CommonHelper:CSGameObjectSetActive(self.BuffScrollView.gameObject,false)
    else
        CommonHelper:CSGameObjectSetActive(self.BuffScrollView.gameObject,true)
    end
    if self.BuffList and self.BuffIdxList and  not self.IsBuffListRefresh then
        local count=#_ShowBuffList>5 and #_ShowBuffList or DefaultCount
        CommonHelper:InitMoreRowScrollView(self.BuffScrollView,count,1,function(index, itemObj,scroll)
            local buffId=_ShowBuffList[index+1]
            CommonHelper:SetGameObjectActive("coustom",itemObj,self.BuffList and buffId and self.BuffList[buffId]~=nil)
            if self.BuffList and buffId then
                if self.BuffList[buffId] then
                    -----@type miniskill_config_cell
                    local cfg=CommonHelper:GetTableDataByID(ConfigNames.miniskill_config,buffId)
                    if cfg then
                        CommonHelper:GetComponentSetUITexture("bufficon",itemObj,cfg.bigIcon,UIModuleID.Battle)
                        if self.BuffList[buffId].Value then
                            CommonHelper:SetGameObjectActive("valuebg",itemObj,self.BuffList[buffId].Value>0)
                            CommonHelper:SetText("###buffvalue",itemObj,self.BuffList[buffId].Value)
                        else
                            CommonHelper:SetGameObjectActive("valuebg",itemObj,false)
                        end
                    end
                end
            end
        end)
    else
        CommonHelper:MoreRowView_RefreshCurList(self.BuffScrollView, false)
    end

end
function Page_BattleBase:SetBattleCostImage(type)
    CommonHelper:GetComponentSetImage("Fill",self.CostAttrSlider,string.format("battle_%d_endurance_bar_dt",type),UIModuleID.Battle)
    CommonHelper:GetComponentSetImage("attricon",self.CostAttrSlider,string.format("battle_%d_attr_endurance_dt",type),UIModuleID.Battle)
end

function Page_BattleBase:ClearRank()
    self:StopAutoChangeCamera()
    self.allRankBgImageTransList = {}
    self.BuffList=nil
    self.rankIdGoDic = {}
    self.fxTweenGroup = {}
    self.talkList = {}
    self.isPlayInitAni = true
    if self.ProtectStateTimer then
        cs_coroutine.stop(self.ProtectStateTimer)
    end
    self:ClearShortCutData()
    CommonHelper:ReleasePool(self.moduleId)
    if self.leftPlayerSampleInfoView ~= nil then
        self.leftPlayerSampleInfoView:Clear()
        self.leftPlayerSampleInfoView = nil
    end
end

function Page_BattleBase:SetBattleIsProtect(battleType,replay)
    local isNewShowHead = BattleDataManager:Get():IsNewShowHead()

    CommonHelper:SetGameObjectActive("HeadOldRoot",self.parentPref,not isNewShowHead)
    CommonHelper:SetGameObjectActive("HeadNewRoot",self.parentPref, isNewShowHead)
    if not replay and (battleType==RaceModel.Battle or
            battleType==RaceModel.RaceSeniorTrain or
            battleType==RaceModel.NewBieChapter or
            battleType==RaceModel.Challenge or
            battleType==RaceModel.RaceSelfChapter or
            battleType==RaceModel.RaceTrot or
            battleType==RaceModel.RaceClub3v3 or
            (battleType==RaceModel.RaceRank and RaceRankManager:Get():GetProtectType()== RaceProtectType.Protect) or
            (battleType==RaceModel.RaceAssembleTest and RaceAssembleAddManager:Get():GetRaceType()== RaceProtectType.Protect) or
            (battleType == RaceModel.RaceTop and  (RaceTopManager:Get():GetRaceType()==RaceTopRaceType.Test or RaceTopManager:Get():GetRaceType()==RaceTopRaceType.Audition or RaceTopManager:Get():GetRaceType()==RaceTopRaceType.RaceTop or RaceTopManager:Get():GetRaceType()==RaceTopRaceType.RaceB)) or
            (battleType == RaceModel.RaceTopSuper and  (RaceTopSuperManager:Get():GetRaceType()==RaceTopRaceType.Test or RaceTopSuperManager:Get():GetRaceType()==RaceTopRaceType.Audition or RaceTopSuperManager:Get():GetRaceType()==RaceTopRaceType.RaceTop or RaceTopSuperManager:Get():GetRaceType()==RaceTopRaceType.RaceB))
    ) then
       CommonHelper:SetGameObjectActive("TweenBtnProtectPos",self.parentPref,true)
       CommonHelper:SetGameObjectActive("TweenBtnAcceleratePos",self.parentPref,true)
       CommonHelper:SetGameObjectActive("TweenBtnAcceleratePos2",self.parentPref,true)
        if PlayerPrefsHelper:GetValue_GameBrakeSetting()==0 then
            CommonHelper:SetGameObjectActive("TweenBrakePos",self.parentPref,false)
            CommonHelper:SetGameObjectActive("TweenBtnAcceleratePos2",self.parentPref,false)
            CommonHelper:SetGameObjectActive("TweenBtnAcceleratePos",self.parentPref,true)
        else
            if battleType==RaceModel.Battle or battleType==RaceModel.Challenge or battleType==RaceModel.RaceSelfChapter or battleType==RaceModel.NewBieChapter then
                CommonHelper:SetGameObjectActive("TweenBrakePos",self.parentPref,true)
                CommonHelper:SetGameObjectActive("TweenBtnAcceleratePos2",self.parentPref,true)
                CommonHelper:SetGameObjectActive("TweenBtnAcceleratePos",self.parentPref,false)
                if battleType==RaceModel.NewBieChapter then
                    self:SetBreakBtnState(false)
                else
                    self:SetBreakBtnState(true)
                end
            else
                CommonHelper:SetGameObjectActive("TweenBrakePos",self.parentPref,false)
                CommonHelper:SetGameObjectActive("TweenBtnAcceleratePos2",self.parentPref,false)
                CommonHelper:SetGameObjectActive("TweenBtnAcceleratePos",self.parentPref,true)
            end
        end

       CommonHelper:SetGameObjectActive("tweenBattleTipsInfo",self.parentPref,true)
       --CommonHelper:SetGameObjectActive("PlayerProtectionQi",self.parentPref,true )
        CommonHelper:SetGameObjectActive("HeadOldRoot/PlayerProtectionQi",self.parentPref, true)
        CommonHelper:SetGameObjectActive("HeadNewRoot/PlayerProtectionQi",self.parentPref, true)
        CommonHelper:SetGameObjectActive("BattlePlayerInfo/Page_PlayerSampleInfoView",self.parentPref,true)
        CommonHelper:SetGameObjectActive("HeadOldRoot/PlayerBattleRankInfo",self.parentPref, false)
        CommonHelper:SetGameObjectActive("HeadNewRoot/PlayerBattleRankInfo",self.parentPref, false)
        local  BattlePveRank=CommonHelper:SetGameObjectActive("BattlePvpRank",self.parentPref,(battleType==RaceModel.RaceRank and RaceRankManager:Get():GetProtectType()== RaceProtectType.Protect))
        local obj = UIUtil.GetChildInputPath("ProtectRankGroup", self.parentPref)
        UIUtil.SetParentTransform(obj,BattlePveRank,true)
    else
        CommonHelper:SetGameObjectActive("TweenBtnProtectPos",self.parentPref,false)
        CommonHelper:SetGameObjectActive("TweenBtnAcceleratePos",self.parentPref,false)
        CommonHelper:SetGameObjectActive("TweenBtnAcceleratePos2",self.parentPref,false)
        CommonHelper:SetGameObjectActive("TweenBrakePos",self.parentPref,false)
        CommonHelper:SetGameObjectActive("tweenBattleTipsInfo",self.parentPref,false)
        CommonHelper:SetGameObjectActive("HeadOldRoot/PlayerProtectionQi",self.parentPref, false)
        CommonHelper:SetGameObjectActive("HeadNewRoot/PlayerProtectionQi",self.parentPref, false)
        local  BattlePveRank=CommonHelper:SetGameObjectActive("BattlePvpRank",self.parentPref,true)
        local obj = UIUtil.GetChildInputPath("NormalRankGroup", self.parentPref)
        UIUtil.SetParentTransform(obj,BattlePveRank,true)
        local rankInfoActive= battleType==RaceModel.RaceRank
        --local rankInfoActive= battleType==RaceModel.RaceTrot or (battleType==RaceModel.RaceRank and RaceRankManager:Get():GetProtectType()== RaceProtectType.Normal)
        CommonHelper:SetGameObjectActive("PlayerBattleRankInfo",self.parentPref, rankInfoActive)
        CommonHelper:SetGameObjectActive("HeadOldRoot/PlayerBattleRankInfo",self.parentPref, rankInfoActive)
        local rankInfo = CommonHelper:SetGameObjectActive("HeadNewRoot/PlayerBattleRankInfo",self.parentPref, rankInfoActive)
        if rankInfoActive then
            CommonHelper:SetGameObjectActive("BattlePlayerInfo/Page_PlayerSampleInfoView",self.parentPref,true)
        end
        if battleType==RaceModel.RaceRank then
            local score = RaceRankManager:Get():GetScore()
            ---@type qualifyingrank_config_cell
            local curcfg, minscore, maxscore = CommonHelper:GetRankCfgByScore(score)
            local process = (score - minscore) / (maxscore - minscore)
            if score > maxscore then
                CommonHelper:SetText("###scoreprocess", rankInfo, score)
            else
                CommonHelper:SetText("###scoreprocess", rankInfo, (score - minscore) .. "/" .. (maxscore - minscore))
            end

            CommonHelper:SetRankIconGroup("rankicon_s_6", rankInfo, curcfg)
        end
        if battleType==RaceModel.RaceTrot then
            local cfg,minscore, maxscore= CommonHelper:GetTrotCfgByScore(RaceTrotManager:Get():GetCurScore(),true)
            CommonHelper:SetTrotIconGroup("rankicon_s_6",rankInfo,cfg )
        end
    end
end
function Page_BattleBase:SetSkipBtn(state,isApply)
    CommonHelper:SetHButtonClick(self.BtnSkip, state, isApply)
    if isApply then
        CommonHelper:SetGameObjectActive("TweenTemp_Skip",self.parentPref,state)
    end
end

function Page_BattleBase:SetDoubleSpeedBtn(state,isApply)
    CommonHelper:SetHButtonClick(self.TogDoubleSpeed, state, isApply)
    if isApply then
        CommonHelper:SetGameObjectActive("TweenTemp_Quick",self.parentPref,state)
    end

end

function Page_BattleBase:SetPauseBtn(state,isApply)
    CommonHelper:SetHButtonClick(self.BtnPause, state, isApply)
    if isApply then
        CommonHelper:SetGameObjectActive("TweenTemp_Pause",self.parentPref,state)
    end
end

function Page_BattleBase:SelfComplete(isSelf)
    if isSelf then
        local battleType= BattleDataManager:Get():GetBattleType()
        local replay= BattleDataManager:Get():IsReplay()
        if not replay and (battleType==RaceModel.Battle or battleType==RaceModel.NewBieChapter or battleType==RaceModel.RaceSeniorTrain or battleType==RaceModel.Challenge or battleType==RaceModel.RaceSelfChapter or battleType==RaceModel.RaceClub3v3) then
            if BattleDataManager:Get():GetBattleState()==BattleState.Fighting  then
                CSLuaHelper.Get():JumpQuickExecuteGame()
                self:SetSkipBtn(false,false)
            end
        end
    end
end




