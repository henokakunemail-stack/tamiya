function Page_BattleBase:InitRankGoData()
    if  self.rankPlayerSampleList==nil then
        self.rankPlayerSampleList={}
    end
    self.IsInit=true
    for i = 1, 5 do
        local carDyData = BattleDyDataManager:Get():GetCarDataByIndex(i)
        if carDyData == -1 then
            CommonHelper:SetGameObjectActive(string.format("tweenRank%d/BattleRankItem", i), self.parentPref, false)
            CommonHelper:SetGameObjectActive(string.format("tweenRank%d/BattleRankItemOld", i), self.parentPref, false)
            CommonHelper:SetGameObjectActive(string.format("Talk%d", i), self.parentPref, false)
        else
            self:InitRankItemData(carDyData, nil, i)
            if self.talkList[i] then
                CommonHelper:CSGameObjectSetActive(self.talkList[i].gameObject, false)
            end
        end
    end
    local trackData = BattleDataManager:Get():GetTrackData()
    CommonHelper:SetGameObjectActive(string.format("PlayerGroup5"), self.parentPref, trackData:GetRaceNumber()==TrackSegmentNumbers.Five)
    CommonHelper:SetGameObjectActive(string.format("PlayerGroup3"), self.parentPref, trackData:GetRaceNumber()==TrackSegmentNumbers.Three)
    CommonHelper:TMG_SetTweenCallBackByIdx(self.startTweenMoreGroup, 0, function()
        self.isPlayInitAni = false

       -- print("--------排名条初始动画播放完毕---------")
        for i = 1, 5 do
            local carDyData = BattleDyDataManager:Get():GetCarDataByIndex(i)
            if carDyData ~= -1 then
                self:SetOneRank(carDyData:GetCarId(), carDyData:GetCarRankIndex(), carDyData:GetCarRank())
            end
        end
    end, 1)
    self.countParent = UIUtil.GetChild("countParent",  self.parentPref)
    self.isPlayInitAni = true
    self:SetPlayerData()
    self:SetBossData()
    self:UpdateAccelerateBtnState(true,true)
    self:SetBreakBtnState(true)
    self:UpdateProtectBtnState(false,true)
    self:UpdateRecoverState(false,  self.parentPref)
    self:SetBeanCount()
    self:SetSelfRank(0)
    CommonHelper:TMG_PlayAllTween(self.startTweenMoreGroup)
end

---------------------------------设置单个排名的头像背景图
---@param carDyData CarDyData
function Page_BattleBase:InitRankItemData(carDyData, tweenRankItemTrans, initRank)

    tweenRankItemTrans = tweenRankItemTrans or self.rankIdGoDic[carDyData:GetCarId()]
    if tweenRankItemTrans==nil then return end
    local isNewShowHead = BattleDataManager:Get():IsNewShowHead()
    CommonHelper:SetGameObjectActive("BattleRankItem",tweenRankItemTrans.gameObject, isNewShowHead)
    CommonHelper:SetGameObjectActive("BattleRankItemOld",tweenRankItemTrans.gameObject,not isNewShowHead)
    tweenRankItemTrans = isNewShowHead and UIUtil.GetChild("BattleRankItem",tweenRankItemTrans.gameObject) or UIUtil.GetChild("BattleRankItemOld",tweenRankItemTrans.gameObject)



    CommonHelper:SetGameObjectActive("FinishedImage", tweenRankItemTrans.gameObject, false)
    --CommonHelper:SetGameObjectActive("CrackImage", tweenRankItemTrans.gameObject, false)
    --CommonHelper:SetGameObjectActive("FlyOutImage", tweenRankItemTrans.gameObject, false)

    CommonHelper:SetGameObjectActive("HeadBlackBg", tweenRankItemTrans.gameObject, false)
    CommonHelper:SetGameObjectActive("HeadBlackBg2", tweenRankItemTrans.gameObject, false)
    CommonHelper:SetGameObjectActive("Talk", tweenRankItemTrans.gameObject, false)

    if carDyData ~= -1 then



        CommonHelper:SetGameObjectActive("Page_PlayerSampleInfoView",tweenRankItemTrans.gameObject, isNewShowHead)
        CommonHelper:SetGameObjectActive("PlayerIcon80",tweenRankItemTrans.gameObject,not isNewShowHead)
        CommonHelper:SetGameObjectActive("bg",tweenRankItemTrans.gameObject,not isNewShowHead)
        CommonHelper:SetGameObjectActive("###PlayerNameText",tweenRankItemTrans.gameObject,not isNewShowHead)
        CommonHelper:SetGameObjectActive("SelfHeadBgImage",tweenRankItemTrans.gameObject, (not isNewShowHead )and carDyData:GetPlayerID() == BattleDataManager:Get():GetDefaultPlayerId())
        if isNewShowHead then
            if self.rankPlayerSampleList[initRank]==nil then
                local playerSampleInfo=UIUtil.GetChild("Page_PlayerSampleInfoView",tweenRankItemTrans.gameObject)
                self.rankPlayerSampleList[initRank] = PagePlayerSampleInfoView(playerSampleInfo,self.moduleId)
            end
            self.rankPlayerSampleList[initRank]:Refresh(carDyData:GetSampleInfo())
        else
            CommonHelper:SetGameObjectActive("SelfHeadBgImage", tweenRankItemTrans.gameObject, carDyData:GetPlayerID() == BattleDataManager:Get():GetDefaultPlayerId())
            CommonHelper:SetPlayerIcon("PlayerIcon80", tweenRankItemTrans.gameObject, carDyData:GetPlayerIcon(), carDyData:GetIconFrame(), nil, self.moduleId)
            CommonHelper:SetText("###PlayerNameText", tweenRankItemTrans.gameObject, carDyData:GetPlayerName())
        end

        local trackImgName = CommonHelper:GetBattleTrackIcon(carDyData:GetCarTrackId(),BattleDataManager:Get():GetTrackData():GetRaceNumber())
        CommonHelper:GetComponentSetImage("trackNumImg", tweenRankItemTrans.gameObject, trackImgName)

        CommonHelper:GetComponentSetImage("rankImg", tweenRankItemTrans.gameObject, CommonHelper:GetBattleRankIcon(initRank))
       -- CommonHelper:SetText("###rank", tweenRankItemTrans.gameObject, initRank)
    end
end

function Page_BattleBase:SetTalkContent(content,idx)

    local emptyIdx = BattleDyDataManager:Get():GetEmptyItemIdx()

    if emptyIdx then
        local talkItemTweenMoreGroup = self.talkList[emptyIdx]
        CommonHelper:CSGameObjectSetActive(talkItemTweenMoreGroup.gameObject, true)

        local carDyData = BattleDyDataManager:Get():GetCarDataById(tonumber(idx))
        CommonHelper:GetComponentSetUITexture("icon", talkItemTweenMoreGroup.gameObject, carDyData:GetPlayerIcon(), UIModuleID.Battle)
        CommonHelper:GetComponentSetUITexture("iconframe", talkItemTweenMoreGroup.gameObject, carDyData:GetIconFrame(), UIModuleID.Battle)
        CommonHelper:SetText("###talkText", talkItemTweenMoreGroup.gameObject, content)

        BattleDyDataManager:Get():SetChatItemFlag(emptyIdx, 1)

        CommonHelper:TMG_SetTweenCallBackByIdx(talkItemTweenMoreGroup, 0, function()
            BattleDyDataManager:Get():SetChatItemFlag(emptyIdx, 0)
        end, 1)

        CommonHelper:TMG_PlayAllTween(talkItemTweenMoreGroup)
    end
end

-----c#通知设置单个排名条的动画
function Page_BattleBase:SetOneRank(carId, rankIndex, toRank)
    if self.IsInit==false then
        self:InitRankGoData()
    end
    if self.rankIdGoDic==nil  or carId==nil or self.rankIdGoDic[carId]==nil  then return end
    local fromGoRectTrans = self.rankIdGoDic[carId]
    if fromGoRectTrans == nil or CommonHelper:GameObjectIsNull(fromGoRectTrans) then return end

    local carData = BattleDyDataManager:Get():GetCarDataById(carId)
    self:SetSelfRank(BattleDyDataManager:Get():GetSelfCarData():GetCarRank())

    --print("更新排名 toRank----carID", carData:GetCarId(), "---toRank---", toRank, "-------carRank:", carData:GetCarRank(), "----初始动画isPlayInitAni", self.isPlayInitAni, "-----fromGoRectTrans,name:", fromGoRectTrans.name)

    --CommonHelper:GetComponentSetImage("rankImg", fromGoRectTrans.gameObject, string.format("battle_icon_rank_%d_dt", carData:GetCarRank()))

    if not self.isPlayInitAni then
        self:PlayRankAni(carData, fromGoRectTrans)
    end

    return fromGoRectTrans
end
function Page_BattleBase:ResetIsInit()
    self.isReset=true
   self.IsInit=false
end
---@param carData CarDyData
function Page_BattleBase:PlayRankAni(carData, fromGoRectTrans)

    local latestRankIdx = carData:GetLatestRankIdx()

--    print("---carID", carData:GetCarId(), "---latestRankIdx", latestRankIdx, "----carData:GetCarRankIndex()", carData:GetCarRankIndex(), "------carData:GetIsPlayAni()", carData:GetIsPlayAni())

    if latestRankIdx ~= 0 and latestRankIdx ~= carData:GetCarRankIndex() and not carData:GetIsPlayAni() then
        local toPos = Vector2(self.rankGoPositionList[latestRankIdx].x, self.rankGoPositionList[latestRankIdx].y)

        carData:SetIsPlayAni(true)

        fromGoRectTrans.anchoredPosition = toPos

        fromGoRectTrans.transform:SetSiblingIndex(latestRankIdx - 1)

        CommonHelper:TMG_SetTweenPosValue(self.fxTweenGroup[carData:GetCarId()], { Vector3(toPos.x, toPos.y, 0), Vector3(toPos.x + 160, toPos.y, 0) }, { Vector3(1400, toPos.y, 0), Vector3(toPos.x, toPos.y, 0) })

        CommonHelper:TMG_SetAllTweenCallBack(self.fxTweenGroup[carData:GetCarId()], function()
            local battleType=BattleDataManager:Get():GetBattleType()
            local isNewShowHead = BattleDataManager:Get():IsNewShowHead()
            if isNewShowHead then
                CommonHelper:GetComponentSetImage("BattleRankItem/HeadBg/rankImg", fromGoRectTrans.gameObject, string.format("battle_icon_rank_%d_dt", carData:GetLatestRank()))
                CommonHelper:SetText("BattleRankItem/HeadBg/###rank", fromGoRectTrans.gameObject, carData:GetLatestRank())
            else
                CommonHelper:GetComponentSetImage("BattleRankItemOld/HeadBg/rankImg", fromGoRectTrans.gameObject, string.format("battle_icon_rank_%d_dt", carData:GetLatestRank()))
                CommonHelper:SetText("BattleRankItemOld/HeadBg/###rank", fromGoRectTrans.gameObject, carData:GetLatestRank())
            end

            carData:SetIsPlayAni(false)

            carData:SetCarRankIndex(latestRankIdx)

          --  print("播放完动画---carID", carData:GetCarId(), "------latestRankIdx---", latestRankIdx, "---pos", toPos)

            self:PlayRankAni(carData, fromGoRectTrans)
        end, 4)

        CommonHelper:TMG_PlayAllTween(self.fxTweenGroup[carData:GetCarId()], 1)
    end
end
function Page_BattleBase:SetPlayerData()
    local battleType=BattleDataManager:Get():GetBattleType()
    local isNewShowHead = BattleDataManager:Get():IsNewShowHead()
    local PlayerObj = UIUtil.GetChild("BattlePlayerInfo",self.parentPref)
    CommonHelper:SetGameObjectActive("HeadOldRoot",PlayerObj,not isNewShowHead)
    CommonHelper:SetGameObjectActive("HeadNewRoot",PlayerObj, isNewShowHead)
    if isNewShowHead then
        if self.leftPlayerSampleInfoView==nil then
            self.leftPlayerSampleInfoView = PagePlayerSampleInfoView( UIUtil.GetChild("BattlePlayerInfo/HeadNewRoot/Page_PlayerSampleInfoView",self.parentPref),UIModuleID.Battle)
        end
        self.leftPlayerSampleInfoView:Refresh(BattleDyDataManager:Get():GetSelfCarData():GetSampleInfo())
    else
         CommonHelper:SetText("###PlayerName",PlayerObj,BattleDyDataManager:Get():GetSelfCarData().playerName)
         CommonHelper:SetPlayerIcon("PlayerIcon100",PlayerObj,BattleDyDataManager:Get():GetSelfCarData().playerHeadIcon,BattleDyDataManager:Get():GetSelfCarData().playerIconFrame,nil,UIModuleID.Battle)
    end

end
function Page_BattleBase:SetBossData()
    local battleType=BattleDataManager:Get():GetBattleType()
    local bossIcon=""
    local bossName=""
    local show=false
    if battleType==RaceModel.Battle then
       local levelData= PVEChapterDataManager:Get().CurBattle
        ---@type dictcopy_config_cell
        local levelCfg=CommonHelper:GetTableDataByID(ConfigNames.pvelevel_config,levelData.copyid)
        show=levelCfg.copytype==LevelType.Boss and levelCfg.BattleInfoList[levelData.idx].NpcIds[1]>0
        bossName,bossIcon=CommonHelper:AnalyseNPCNameAndIconById(levelCfg.BattleInfoList[levelData.idx].NpcIds[1])
    elseif battleType==RaceModel.NewBieChapter then
       local levelData= NewBieChapterDataManager:Get().CurBattle
        ---@type dictcopy_config_cell
        local levelCfg=CommonHelper:GetTableDataByID(ConfigNames.pvelevel_config,levelData.copyid)
        show=levelCfg.copytype==LevelType.Boss and levelCfg.BattleInfoList[levelData.idx].NpcIds[1]>0
        bossName,bossIcon=CommonHelper:AnalyseNPCNameAndIconById(levelCfg.BattleInfoList[levelData.idx].NpcIds[1])
    elseif battleType==RaceModel.Challenge then
        ---@type dictcopy_config_cell
        local levelCfg= SpecialTrainingDataManager:Get():GetSelectCopy()
        show=levelCfg.BattleInfoList[1].NpcIds[1]
        show=false
        bossName,bossIcon=CommonHelper:AnalyseNPCNameAndIconById(levelCfg.BattleInfoList[1].NpcIds[1])
    elseif battleType==RaceModel.RaceSelfChapter then
        local levelData= RaceSelfChapterDataManager:Get():GetCurCopyData()
        ---@type dictactivitycopy_config_cell
        local levelCfg=CommonHelper:GetTableDataByID(ConfigNames.dictactivitycopy_config,levelData.copyid)
        show=levelCfg.copytype==LevelType.Boss and levelCfg.BattleInfoList[1].NpcIds[1]
        bossName,bossIcon=CommonHelper:AnalyseNPCNameAndIconById(levelCfg.BattleInfoList[1].NpcIds[1])
    elseif battleType==RaceModel.RaceSeniorTrain then
        local levelData= RaceSeniorTrainManager:Get().CurBattle
        ---@type dictactivitycopy_config_cell
        local levelCfg=CommonHelper:GetTableDataByID(ConfigNames.dicthidecopy_config,levelData.copyid)
        show=levelCfg.copytype==LevelType.Boss and levelCfg.BattleInfoList[levelData.idx].NpcIds[1]
        bossName,bossIcon=CommonHelper:AnalyseNPCNameAndIconById(levelCfg.BattleInfoList[levelData.idx].NpcIds[1])
    end
    local BossObj= CommonHelper:SetGameObjectActive("BattleBossInfo",self.parentPref,show)
    if show then
        CommonHelper:GetComponentSetUITexture("icon",BossObj,bossIcon,UIModuleID.Battle)
        CommonHelper:SetText("###BossName",BossObj,bossName)
    end
end
function Page_BattleBase:SetSelfRank(selfRank)
    for i = 1, 5 do
        CommonHelper:SetGameObjectActive(string.format("rank%d",i),self.RankParent,selfRank==i)
    end
end
function Page_BattleBase:UpdateAccelerateBtnState(state,defaultParent,check)
    if (state~=self.AccelerateBtnState or check)  then
        self.AccelerateBtnState=state
        if self.AccelerateBtn==nil then
            self.AccelerateBtn = UIUtil.GetTypeChildWightByParent("AccelerateBtn",defaultParent, typeof(HButton))
        end
        if self.AccelerateBtn2==nil then
            self.AccelerateBtn2 = UIUtil.GetTypeChildWightByParent("AccelerateBtn",defaultParent, typeof(HButton))
        end
        CommonHelper:SetToggleState(self.AccelerateBtn,self.AccelerateBtnState)
        CommonHelper:SetHButtonClick(self.AccelerateBtn,self.AccelerateBtnState,false)
        CommonHelper:SetToggleState(self.AccelerateBtn2,self.AccelerateBtnState)
        CommonHelper:SetHButtonClick(self.AccelerateBtn2,self.AccelerateBtnState,false)
    end
end
function Page_BattleBase:SetBreakBtnState(state)
    if BattleDataManager:Get():GetBattleType()==RaceModel.NewBieChapter then
        state=false
    end
    CommonHelper:SetHButtonClick(self.BrakeBtn, state,false)
    CommonHelper:SetGameObjectActive("BrakeBtnGray",self.BrakeBtn.gameObject, not state)
end

function Page_BattleBase:SkillCardCdFinish(index)
    if index==2 then
        self:SetBreakBtnState(true)
    end
end

function Page_BattleBase:UpdateProtectBtnState(state,defaultParent,check)
    BattleDyDataManager:Get():SetProtectBtnState(state)
    if state~=self.ProtectBtnState or check then
        self.ProtectBtnState=state
        if self.ProtectBtn==nil then
            self.ProtectBtn = UIUtil.GetTypeChildWightByParent("ProtectBtn",defaultParent, typeof(HButton))
        end
        CommonHelper:SetToggleState(self.ProtectBtn,self.ProtectBtnState)
        CommonHelper:SetHButtonClick(self.ProtectBtn,self.ProtectBtnState,false)
        self:SetBattleTipsInfo(state,1,TemplateStringID.BattleProtectEnable1,TemplateStringID.BattleProtectEnable2)
    end
end

function Page_BattleBase:UpdateRecoverState(state, defaultParent)
    local  battleTips=CommonHelper:SetGameObjectActive("RecoverTipsInfo",defaultParent,state)
    --CommonHelper:SetText("######RecoverTips1",ProtectTips1,CommonHelper:GetTempStr_Default(text1))
    CommonHelper:SetText("###RecoverTips1", defaultParent, CommonHelper:GetTempStr_Default(TemplateStringID.RaceRecoverTips))
end


function Page_BattleBase:SetBeanCount()
    if self.BeanScrollView then
        local maxCount=BattleDyDataManager:Get():GetSelfCarData():GetMaxShellBean()
        local beanCount=BattleDyDataManager:Get():GetSelfCarData():GetCurShellBean()
        if maxCount==beanCount then
            self:SetBeanScrollView(beanCount,maxCount)
        else
            self:SetBeanScrollView(beanCount,maxCount)
        end

    end
end
function Page_BattleBase:PlayBeanEffect(targetPos)
    if self.BeanScrollView then
        CommonHelper:PlayFlyPeasEffect(self.BeanScrollView.gameObject, targetPos,true,function()
        end,GameProperties:GetAccelOutDuration())
    end
end

function Page_BattleBase:SetBeanScrollView(beanCount,maxCount)
    CommonHelper:InitScroll_OneRow(self.BeanScrollView, maxCount, function(dataIndex, itemObj, scroll)
        CommonHelper:SetGameObjectActive("normal",itemObj,(dataIndex+1)>beanCount)
        CommonHelper:SetGameObjectActive("hover",itemObj,(dataIndex+1)<=beanCount)
    end,nil,true)
end



function Page_BattleBase:ResetRankGoData()
    for key, tweenGroup in pairs(self.fxTweenGroup) do
        CommonHelper:TMG_StopAllTween(tweenGroup, 1)
    end

    for i = 1, #self.rankGoPositionList do
        local battleRankItemViewTrans = CommonHelper:SetRectPosByName(string.format("tweenRank%d", i), self.parentPref, self.rankGoPositionList[i].x, self.rankGoPositionList[i].y)
        battleRankItemViewTrans.transform:SetSiblingIndex(i - 1)
    end
    for i = 1, #self.rankPlayerSampleList do
        self.rankPlayerSampleList[i]:Clear()
    end
end

function Page_BattleBase:SetBattleTipsInfo(state,type,text1,text2)
    local  battleTips=CommonHelper:SetGameObjectActive("BattleTipsInfo",self.parentPref,state)
    if state then
        local  ProtectTips1=CommonHelper:SetGameObjectActive("ProtectTips",self.parentPref,type==1)
        local  DefaultTips=CommonHelper:SetGameObjectActive("DefaultTips",self.parentPref,type==0)
        if type==1 then
            CommonHelper:SetText("###ProtectTips1",ProtectTips1,CommonHelper:GetTempStr_Default(text1))
            CommonHelper:SetText("###ProtectTips2",ProtectTips1,CommonHelper:GetTempStr_Default(text2))
        end
        if type==0 then
            CommonHelper:SetText("###Default",DefaultTips,CommonHelper:GetTempStr_Default(text1))
        end
    end
end


function Page_BattleBase:RecoverCountDown(view, countTime)

    self.glowdi = view:GetChildByParent("glowdi", self.countParent)
    self.glow =  view:GetChildByParent("glow",self.countParent)
    self.timeCountImg1 = view:GetChildWightByParent("timeCountImg", self.countParent, typeof(RawImage))
    self.lightImg = view:GetChildWightByParent("LightImg", self.countParent, typeof(RawImage))

    print("RecoverCountDown = ", countTime)

    if countTime == 0 then
        CommonHelper:SetUITexture(self.lightImg, "uitex_sucai_battlestart_lightstate_2.png", UIModuleID.BattleStart)
        CommonHelper:SetGameObjectActive("fx_ui_timeCountImg", view.gameObject, true);

        CommonHelper:SetUITexture(self.lightImg, "uitex_sucai_battlestart_lightstate_3.png", UIModuleID.BattleStart)
        CommonHelper:SetUITexture(self.timeCountImg1, "uitex_sucai_battlestart_num_go.png", UIModuleID.BattleStart)
    else
        CommonHelper:SetUITexture(self.timeCountImg1, string.format("uitex_sucai_battlestart_num_%d.png", countTime), UIModuleID.BattleStart)
    end
        --CommonHelper:SetUITexture(self.lightImg, "uitex_sucai_battlestart_lightstate_3.png", UIModuleID.BattleStart)
        --CommonHelper:SetUITexture(self.timeCountImg1, "uitex_sucai_battlestart_num_go.png", UIModuleID.BattleStart)

    if not CommonHelper:GameObjectIsNull(self.glowdi) then
        self.glowdi:SetActive(false)
        self.glow:SetActive(false)

        self.glowdi:SetActive(true)
        self.glow:SetActive(true)
        local animator = UIUtil.GetGameobjectComponent(self.timeCountImg1.gameObject, typeof(CS.UnityEngine.Animator))
        animator:Play("animation_timecountImg", 0, 0)
    end



end






