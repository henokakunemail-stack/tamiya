---@class RaceRankView : ViewBase
RaceRankView = class("RaceRankView", ViewBase)
local _RaceType=nil
function RaceRankView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceRankViewAction")

    ---@type Page_SelectCar
    self.Page_SelectCar = nil
    ---@type PreGarageCarIdx
    self.PreCarIdx = nil
    self.ObjCarIdx = nil
end

function RaceRankView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHome",self.gameObject,function (hbtn)
        SkipModuleHelper:Get():BackToMainMenuView(true)
    end)
    self.BtnReward= CommonHelper:HButtonSetCallback("BtnReward",self.gameObject,function (hbtn)
        TaskSubsystem:Get():SendMsg_GetTaskList(TaskType.DailyRank,UIModuleID.RaceRank)
    end)
    self.ToggleSelect= CommonHelper:HButtonSetCallback("ToggleSelect",self.gameObject,function (hbtn)
        local value= PlayerPrefsHelper:GetValue_RaceRankSelectPosition()
        PlayerPrefsHelper:SetValue_RaceRankSelectPosition(value==1 and 0 or 1)
        CommonHelper:SetToggleState(self.ToggleSelect, PlayerPrefsHelper:GetValue_RaceRankSelectPosition()==1)
    end)
    self.Toggle_Type1= CommonHelper:HButtonSetCallback("Toggle_Type1",self.gameObject,function (hbtn)
        _RaceType=RaceProtectType.Protect
        self:SetToggleState()
        self:SetView()
    end)
    self.Toggle_Type2=CommonHelper:HButtonSetCallback("Toggle_Type2",self.gameObject,function (hbtn)
        _RaceType=RaceProtectType.Normal
        self:SetToggleState()
        self:SetView()
    end)

    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(hbtn)
        CommonHelper:ShowHelpView(PageDetailType.RaceRank)
    end)
    self.BtnRankList=CommonHelper:HButtonSetCallback("BtnRankList", self.gameObject, function(hbtn)
        RankingListSubsystem:Get():SendMsg_RankingListInfo(RankingListType.Speed,0)
        RaceRankSubsystem:Get().RankingListFlag = RankingListOpenType.RaceRankListOpen
    end)
    self.BtnRankList2=CommonHelper:HButtonSetCallback("BtnRankList2", self.gameObject, function(hbtn)
        RankingListSubsystem:Get():SendMsg_RankingListInfo(RankingListType.RlSpeed,0)
        RaceRankSubsystem:Get().RankingListFlag = RankingListOpenType.RaceRankListOpen
    end)

    self.BtnNotOpen = CommonHelper:HButtonSetCallback("BtnNotOpen", self.gameObject, function(hbtn)
        CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceRankSeasonNotOpen))
    end)
    self.BtnMatch = CommonHelper:HButtonSetCallback("BtnEnter", self.gameObject, function(hbtn)
        if RaceRankManager:Get():GetCurRaceRankRlTime() >=RaceRankManager:Get():GetMaxRaceRankTime() then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceRankNoTime))
        else
            if not RaceRankManager:Get():IsMatching() then
                RaceRankManager:Get():SetMatchAgree(false)
                if CarDataManager:Get():CheckCarCompleteness(self.Page_SelectCar:GetCurCar():GetID()) then
                    self:OnBtnEnterClick(RaceProtectType.Protect)
                end
            end
        end
    end)
    self.BtnMatch2 = CommonHelper:HButtonSetCallback("BtnEnter2", self.gameObject, function(hbtn)
        if RaceRankManager:Get():GetCurRaceRankTime() >=RaceRankManager:Get():GetMaxRaceRankTime() then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceRankNoTime))
        else
            if not RaceRankManager:Get():IsMatching() then
                RaceRankManager:Get():SetMatchAgree(false)
                if CarDataManager:Get():CheckCarCompleteness(self.Page_SelectCar:GetCurCar():GetID()) then
                    CommonHelper:CheckMini4wdRule(UIModuleID.RaceRank,function()
                        self:OnBtnEnterClick(RaceProtectType.Normal)
                    end)
                end
            end
        end
    end)

    self.BtnTestEnter = CommonHelper:HButtonSetCallback("BtnTestEnter", self.gameObject, function(hbtn)
        --if RaceRankManager:Get():GetCurRaceRankTestTime() >=RaceRankManager:Get():GetMaxTestRaceRankTime() then
        --    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceRankChallengeNoCount))
        --else
        if CarDataManager:Get():CheckCarCompleteness(self.Page_SelectCar:GetCurCar():GetID()) then

            if PlayerPrefsHelper:GetValue_RaceRankSelectPosition()==1  then
                RaceRankManager:Get():SetRaceType(RaceRankRaceType.Test)
                RaceRankManager:Get():SetProtectType(RaceProtectType.Normal)
                local data= {trackId=RaceRankManager:Get():GetTrackData():GetId(),scenceId=RaceRankManager:Get():GetScenes(),carId=self.Page_SelectCar:GetCurCar():GetID()}
                BattleDataManager:Get():SetRoomData(data, RaceModel.RaceRank,false)
                local scenename = BattleDataManager:Get():GetSceneName()
                local trackdata = BattleDataManager:Get():GetTrackData()
                SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceRank)
            else
                CommonHelper:TrackSelectDepartPosition(RaceRankManager:Get():GetTrackData():GetRaceNumber(),function(position)
                    RaceRankManager:Get():SetRaceType(RaceRankRaceType.Test)
                    RaceRankManager:Get():SetProtectType(RaceProtectType.Normal)
                    local data= {trackId=RaceRankManager:Get():GetTrackData():GetId(),scenceId=RaceRankManager:Get():GetScenes(),carId=self.Page_SelectCar:GetCurCar():GetID(),position=position}
                    BattleDataManager:Get():SetRoomData(data, RaceModel.RaceRank,false)
                    local scenename = BattleDataManager:Get():GetSceneName()
                    local trackdata = BattleDataManager:Get():GetTrackData()
                    SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceRank)
                end,TrackPositionViewType.None)
            end

        end
        --end
    end)


    CommonHelper:HButtonSetCallback("BtnGarage", self.gameObject, function(data)
        if not RaceRankManager:Get():IsMatching() then
            SkipModuleHelper:Get():ToGarage(UIModuleID.RaceRank)
        end
    end)
    CommonHelper:HButtonSetCallback("BtnLeft", self.gameObject, function(data)
        CommonHelper:InitCarouselScrollView_MoveLastPage(self.BannerScroll)
    end)
    CommonHelper:HButtonSetCallback("BtnRight", self.gameObject, function(data)
        CommonHelper:InitCarouselScrollView_MoveNextPage(self.BannerScroll)
    end)

    self.ScrollLoop = UIUtil.GetTypeChildWightInputPath("CarouselScrollView_Loop", self.gameObject, typeof(CarouselScrollView))
    self.RewardView = UIUtil.GetTypeChildWightInputPath("RewardScrollView", self.gameObject, typeof(MoreRowScrollView))
    self.RankView = UIUtil.GetTypeChildWightInputPath("RankScrollView", self.gameObject, typeof(MoreRowScrollView))

    self.PageRoot = UIUtil.GetChild("pageroot", self.gameObject)
    self.Pre_SelectCar = UIUtil.GetChild("Page_SelectCar", self.gameObject)
    self.ObjCarIdx = UIUtil.GetChild("CaridxGroup", self.gameObject)
    self.CarAttrRecommend = UIUtil.GetChild("carAttrRecommend", self.gameObject)
    self.items = {}
    for i = 1, 4 do
        self.items[i] = UIUtil.GetChild("SelfItem" .. i.."/ItemPart_118", self.gameObject)
    end
    self.PartsItem = { 4, 1, 2, 3 }

end
function RaceRankView:OnBtnEnterClick(type)
    if RaceRankManager:Get():GetSelectPositionNum()>=RaceRankManager:Get():GetSelectPositionMaxNum() or CommonHelper:CheckPlayerIsNewGuide() or PlayerPrefsHelper:GetValue_RaceRankSelectPosition()==1 then
        RaceRankSubsystem:Get():SendMsg_Match(self.Page_SelectCar:GetCurCar():GetID(),0, type,0)
    else
        local articleType= stringSplitToNumber(CommonHelper:GetDictCalcData(CommonCfgKey.RaceRankSelectPositionCost,true),':')
        CommonHelper:TrackSelectDepartPosition(RaceRankManager:Get():GetTrackData():GetRaceNumber(),function(position)
            if position~=0 then
                local boxFunc = function()
                    local tips=CommonHelper:GetTempStr_Default(TemplateStringID.RaceRankSelectPositionTips,CommonHelper:GetPartOrArticleName(articleType[1]),articleType[2],position)
                    local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, tips, CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotEnter_Tittle), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), true,nil,nil,nil,nil,CanvasType.FrontCanvas)
                    if ret == MessageBoxHelp.BtnType.OK then
                        cs_coroutine.start(function()
                            RaceRankSubsystem:Get():SendMsg_Match(self.Page_SelectCar:GetCurCar():GetID(),0, type,position)
                        end)
                    end
                end
                MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
            else
                RaceRankSubsystem:Get():SendMsg_Match(self.Page_SelectCar:GetCurCar():GetID(),0, type,0)
            end
        end,TrackPositionViewType.CostAndCount,{{RaceRankManager:Get():GetSelectPositionNum(),RaceRankManager:Get():GetSelectPositionMaxNum()},articleType})
    end
end
function RaceRankView:OnOpenAnimEnd()
    self:CheckNewBieGuide()
end
function RaceRankView:OnOpen()
    self:SetCar()
    self:ViewFixScreen()
    self:SetCupIcon()
    RedPointManager:Get():UpdateValue(RedPointID.S_TaskRank,true)
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRaceRank(port)
end
function RaceRankView:ReOpen()
    self:SetCar()
    self:SetCupIcon()
    UINotify:Get():SendNotification(UINotifyEvent.RaceRankView_SetData)
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRaceRank(port)
end
function RaceRankView:SetCupIcon()
    CupBuilderTexture:BuilderTexture("item_cup_gold_01.prefab",function(icon)
        CommonHelper:GetComponentSetUITextureByTexture("cupicon",self.gameObject, icon)
    end, {"num1","num2","num3" },tostring(RaceRankManager:Get():GetSessionCfg().C_ID))
end


function RaceRankView:SetScreenBg(type)
    local obj = SceneManager:Get():GetMainCityScenePrefab(SceneChangeID.RaceRank,true)
    CommonHelper:SetGameObjectActive("scn_qualifying_beijing_01",obj,type==RaceProtectType.Protect)
    CommonHelper:SetGameObjectActive("scn_qualifying_beijing_02",obj,type==RaceProtectType.Normal)
end


--{{{  设置车
function RaceRankView:SetCar()
    if self.PreCarIdx == nil then
        self.PreCarIdx = PreGarageCarIdx()
        self:SetPreGarageCar()
    else
        self:SetPreGarageCar()
    end

end

function RaceRankView:SetPreGarageCar()
    self.PreCarIdx:SetData(self.ObjCarIdx, UIModuleID.RaceRank, PlayerPrefsHelper:GetValue_MainMenuViewCarIndex(), true, false, function(data, isautoselect)
        self:SetCarMesh(data)
        PlayerPrefsHelper:SetValue_MainMenuViewCarIndex(data:GetCarIdx())
    end)
end
function RaceRankView:SetCarMesh(data)
    if self.Page_SelectCar == nil then
        self.Page_SelectCar = Page_SelectCar()
        self:SetPageSelectCar(data)
    else
        self:SetPageSelectCar(data)
    end

end
---@param data CarData
function RaceRankView:SetPageSelectCar(data)
    if self.Page_SelectCar then
        self.Page_SelectCar:SetData(self.Pre_SelectCar, UIModuleID.RaceRank, data:GetCarIdx(), false, SceneChangeID.RaceRank, false)
        self:SetCarGroup(data)
        self:SetCarAttrRecommend(data:GetCarIdx())
    end
end
---@param cardata CarData
function RaceRankView:SetCarGroup(cardata)
    local partsList = cardata:GetPartDataList()
    for i = 1, 4 do
        ---@type dictparts_config_cell
        local parts = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partsList[self.PartsItem[i]].PartCfgID)
        if parts then
            CommonHelper:SetItemPartGroup(self.items[i], UIModuleID.RaceRank, parts.C_ID)
        end
    end
end
--}}}

function RaceRankView:OnClose()
    self.Page_SelectCar:Release()
    CommonHelper:ReleasePool(UIModuleID.RaceRank)
    CommonHelper:GetComponentSetUITexture("rankicon", self.gameObject, "uitex_sucai_default.png", UIModuleID.None)
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
        self.TimeId = nil
    end
end
function RaceRankView:OnAutoClose()
    self.Page_SelectCar:Release()
    CommonHelper:ReleasePool(UIModuleID.RaceRank)
    CommonHelper:GetComponentSetUITexture("rankicon", self.gameObject, "uitex_sucai_default.png", UIModuleID.None)
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
        self.TimeId = nil
    end
end
function RaceRankView:SetToggleState()
    if _RaceType==RaceProtectType.Normal then
        CommonHelper:IsOpenMini4wdRuleView(UIModuleID.RaceRank)
    end
    CommonHelper:SetToggleState(self.Toggle_Type1,_RaceType==RaceProtectType.Protect)
    CommonHelper:SetToggleState(self.Toggle_Type2,_RaceType==RaceProtectType.Normal)
    self:SetScreenBg(_RaceType)
    PlayerPrefsHelper:SetValue_RaceRankRaceType(_RaceType)
end


function RaceRankView:SetData()
    if RaceRankManager:Get():GetSessionCfg() == nil then
        logError("---   error:赛事配置表空")
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.RaceRankSessionCfgNil))
        return
    end
    _RaceType=PlayerPrefsHelper:GetValue_RaceRankRaceType()
    self:SetToggleState()
    self:SetView()
    CommonHelper:SetToggleState(self.ToggleSelect, PlayerPrefsHelper:GetValue_RaceRankSelectPosition()==1)
    --self:SetRewardScrollView()

end
function RaceRankView:SetView()
    local IsCloseSeason=RaceRankManager:Get():IsCloseSeason()
    if IsCloseSeason then
        CommonHelper:SetText("###text",self.BtnNotOpen.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceRankSeasonNotOpen))
    end
    CommonHelper:SetHButtonClick(self.BtnMatch, not IsCloseSeason and _RaceType==RaceProtectType.Protect, true)
    CommonHelper:SetHButtonClick(self.BtnMatch2,not IsCloseSeason and _RaceType==RaceProtectType.Normal, true)
    CommonHelper:SetHButtonClick(self.BtnTestEnter,not IsCloseSeason and _RaceType==RaceProtectType.Normal, true)
    CommonHelper:SetHButtonClick(self.BtnNotOpen,  IsCloseSeason, true)
    CommonHelper:SetHButtonClick(self.BtnRankList2,  _RaceType==RaceProtectType.Protect, true)
    CommonHelper:SetHButtonClick(self.BtnReward,  _RaceType==RaceProtectType.Protect, true)
    CommonHelper:SetHButtonClick(self.BtnRankList,  _RaceType==RaceProtectType.Normal, true)


    self:SetSeasonInfo()
    self:SetPersonScore()
    self:SetTrackData()
    self:SetFirstRank()
end
function RaceRankView:SetSeasonInfo()

    local starttime = CommonHelper:ConvertIntToDataTime(RaceRankManager:Get():GetBeginTime()*1000)
    local endtime = CommonHelper:ConvertIntToDataTime(RaceRankManager:Get():GetEndTime()*1000)

    local temp = ClientDataManager:Get():GetTemplateString(CommonHelper:GetTempStr_Default(TemplateStringID.RaceRankDateFromat))
    local str1 = string.format(temp, starttime.Year, starttime.Month, starttime.Day)
    local str2 = string.format(temp, endtime.Year, endtime.Month, endtime.Day)
    CommonHelper:SetText("###pvpstarttime", self.gameObject, str1)
    CommonHelper:SetText("###pvpendtime", self.gameObject, str2)
    CommonHelper:SetText("###pvpidx", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RaceRankNameFromat, RaceRankManager:Get():GetSessionCfg().seasonid))
    if _RaceType==RaceProtectType.Normal then
        CommonHelper:SetText("###challengeNumText", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RaceRankChallengeCount, RaceRankManager:Get():GetCurRaceRankTime(), RaceRankManager:Get():GetMaxRaceRankTime()))
    end
    if _RaceType==RaceProtectType.Protect then
        CommonHelper:SetText("###challengeNumText", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RaceRankChallengeCount, RaceRankManager:Get():GetCurRaceRankRlTime(), RaceRankManager:Get():GetMaxRaceRankTime()))
    end
    CommonHelper:SetText("###selectrackcount", self.gameObject, CommonHelper:GetTempStr_Default( TemplateStringID.RaceRankSelectPositionCount, RaceRankManager:Get():GetSelectPositionNum(), RaceRankManager:Get():GetSelectPositionMaxNum()))
    CommonHelper:SetText("###TestText", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.NumComNum, RaceRankManager:Get():GetCurRaceRankTestTime(), RaceRankManager:Get():GetMaxTestRaceRankTime()))
end

function RaceRankView:SetPersonScore()

    local score = RaceRankManager:Get():GetScore()
    ---@type qualifyingrank_config_cell
    local curcfg, minscore, maxscore = CommonHelper:GetRankCfgByScore(score)
    local process = (score - minscore) / (maxscore - minscore)
    if score > maxscore then
        CommonHelper:SetSlider("scoreslider", self.gameObject, 1)
        CommonHelper:SetText("###scoreprocess", self.gameObject, score)
    else
        CommonHelper:SetSlider("scoreslider", self.gameObject, process)
        CommonHelper:SetText("###scoreprocess", self.gameObject, (score - minscore) .. "/" .. (maxscore - minscore))
    end

    CommonHelper:SetRankIconGroup("rankicon_l", self.gameObject, curcfg)
    CommonHelper:SetRankIconGroup("rankicon_s_4", self.gameObject, curcfg)
end

function RaceRankView:SetTrackData()
    ---@type dictseason_config_cell[]
    self.SessionList = RaceRankManager:Get():GetSessionList()
    self.ScrollPoint = UIUtil.GetTypeChildWightByParent("ScrollPoint",self.gameObject, typeof(ScrollPoint))
    self.BannerScroll = UIUtil.GetTypeChildWightByParent("CarouselScrollView",self.gameObject, typeof(CarouselScrollView))
    CommonHelper:InitCarouselScrollView(self.BannerScroll,  #self.SessionList, 0,function(dataIndex, itemObj, scroll)
        self.ScrollPoint:SetPoint(dataIndex)
        self:SetOpenTime(dataIndex)
        local SceneId = self.SessionList[dataIndex+1].sceneid
        local trackData=  CommonHelper:GetRacetrackData(self.SessionList[dataIndex+1].trackid)
        self.TrackId=self.SessionList[dataIndex+1].trackid
        if self.Page_SelectCar and self.Page_SelectCar:GetCurCar() then
            self:SetCarAttrRecommend(self.Page_SelectCar:GetCurCar():GetCarIdx())
        end
        CommonHelper:GetComponentSetTrackIconByData("trackicon", itemObj, trackData, UIModuleID.RaceRank)
        CommonHelper:SetTrackFeatureByParent("trackfeature",itemObj, trackData:GetFeature(), true)
        if SceneId ~= -1 then
            ---@type scene_config_cell
            local sceneCfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, SceneId)
            if sceneCfg then
                CommonHelper:GetComponentSetUITexture("chapterpic", itemObj, sceneCfg.icon, UIModuleID.RaceRank)
            end
        end
        CommonHelper:HButtonSetCallback("BtnReview", itemObj, function(data)
            local trackData=  CommonHelper:GetRacetrackData(data.intData)
            if trackData:GetIsField() then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackFieldNoLook))
            else
                CommonHelper:LoadReviewTrack(nil, trackData)
            end
        end,self.SessionList[dataIndex+1].trackid)
    end)
    self:SetLastOpenTime()
end
function RaceRankView:SetLastOpenTime()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
    end
    self.TimeId = TimerManager:Get():CreateTimerLoop(1, function(class)
        local dataIndex=CommonHelper:InitCarouselScrollView_GetCurPage(self.BannerScroll)
        self:SetOpenTime(dataIndex)

    end, self)
end
function RaceRankView:SetOpenTime(dataIndex)
    if self.SessionList==nil or self.SessionList[dataIndex+1]==nil then
        CommonHelper:SetText("###opentime",self.gameObject,"")
        return
    end
    local string=TemplateStringID.RaceRankOpenTime
    if self.SessionList[dataIndex+1].seasonid==RaceRankManager:Get():GetSessionCfg().seasonid then
        local HourMin=stringSplitToNumber(self.SessionList[dataIndex+1].start2,':')
        local startTime=ClientDataManager:Get():GetServerStartTime()+(self.SessionList[dataIndex+1].eday*TimeSecond_Day)+HourMin[1]*TimeSecond_Hour+HourMin[2]*TimeSecond_Minute
        string=TemplateStringID.RaceRankSeasonDownTime
        self.subTime=CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) - startTime
        if self.subTime>=0 then
            if self.TimeId then
                TimerManager:Get():StopTimer(self.TimeId)
                self.TimeId = nil
            end
        end
    else
        local HourMin=stringSplitToNumber(self.SessionList[dataIndex+1].start1,':')
        local startTime=ClientDataManager:Get():GetServerStartTime()+(self.SessionList[dataIndex+1].bday*TimeSecond_Day)+HourMin[1]*TimeSecond_Hour+HourMin[2]*TimeSecond_Minute
        self.subTime=startTime - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
        if self.subTime<=0 then
            if self.TimeId then
                TimerManager:Get():StopTimer(self.TimeId)
                self.TimeId = nil
            end
        end
    end

    local day,hour,minute,second =CommonHelper:GetConvertSecond(math.abs(self.subTime))
    if day >= 1 then
        CommonHelper:SetText("###opentime", self.gameObject,
                CommonHelper:GetTempStr_Default(string,CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTime, day, hour, minute)))
    else
        CommonHelper:SetText("###opentime", self.gameObject,
                CommonHelper:GetTempStr_Default(string,CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTimeSecond, hour, minute, second)))
    end

end





function RaceRankView:SetFirstRank()
    local player = RaceRankManager:Get():GetFastRank()
    if _RaceType==RaceProtectType.Protect then
        player= RaceRankManager:Get():GetFastRLRank()
    end


    local obj = UIUtil.GetChild("MyRank", self.gameObject)

    if player then
        --时间
        CommonHelper:GetComponentTransferTime("###timevalue1", obj, player.Time)
        --名字
        CommonHelper:SetText("###playername", obj, player.PlayerName)
        --头像
        CommonHelper:SetPlayerIconById("PlayerIcon", obj, player.headicon, player.iconframe, nil, UIModuleID.RaceRank)
    else
        CommonHelper:SetText("###timevalue1", obj, "--:--:--")
        CommonHelper:SetText("###playername", obj, CommonHelper:GetTempStr_Default(TemplateStringID.RaceRankNoRank))
        CommonHelper:SetPlayerIcon("PlayerIcon", obj, "playericon_z_default.png", nil, nil, UIModuleID.RaceRank)

    end
end

function RaceRankView:SetCarAttrRecommend(idx)
    local partIdx={PartGrooveID.Motor,PartGrooveID.Gears}
    ---@type CarData
    local carData = CarDataManager:Get():GetCarDataByIndex(idx)
    for i = 1, 2 do
        local item=UIUtil.GetChild("Item"..i,self.CarAttrRecommend)
        if carData.assembleMgr:GetNodeByGrooveID(partIdx[i]) and carData.assembleMgr:GetNodeByGrooveID(partIdx[i]).PartId~=0 then
            ---@type parts_config_cell
            local parts=CommonHelper:GetTableDataByID(ConfigNames.parts_config,carData.assembleMgr:GetNodeByGrooveID(partIdx[i]).PartId)
            if parts then
                local articleCell=carData.assembleMgr:GetNodeByGrooveID(partIdx[i]).ArticleCell
                local param = Param_ItemPartParam()
                param.quality = articleCell:GetPartQuality()
                param.star = articleCell:GetStar()
                param.lv = articleCell:GetPartLV()
                param.using = articleCell:GetCarId()
                param.lock = articleCell:GetPartLock()
                param.awaken=articleCell:GetAwaken()
                param.generation=articleCell:GetGeneration()
                param.downType=articleCell:GetPartDownType()
                param.source = articleCell:GetPartSource()
                param.expireTime = articleCell:GetPartExpTime()
                CommonHelper:SetItemPartGroup(item,UIModuleID.SelectTeam,parts.C_ID,ItemPartUIType.Simple,param,function(id)
                    CommonHelper:ShowPartInfoByCfgId(id, UIModuleID.SelectTeam)
                end,parts.C_ID)
            end
        end
        CommonHelper:SetGameObjectActive("ItemPart_118", item,carData.assembleMgr:GetNodeByGrooveID(partIdx[i])~=nil and carData.assembleMgr:GetNodeByGrooveID(partIdx[i]).PartId~=0)
    end

    local data= CarAttrRecommendManager:Get():GetDataByTrackId_MotorId_GearId(self.TrackId,carData.assembleMgr:GetNodeByGrooveID(partIdx[1]).PartId,carData.assembleMgr:GetNodeByGrooveID(partIdx[2]).PartId)
    for i = 1, 3 do
        CommonHelper:SetGameObjectActive("attr"..i,self.CarAttrRecommend,data~=nil)
    end
    CommonHelper:HButtonSetCallback("BtnCarAttrRecommend",self.CarAttrRecommend,function (hbtn)
        CommonHelper:ShowHelpView(PageDetailType.CarAttrRecommend)
    end)
    if data~=nil then
        local selfStabilize=CommonHelper:FloatRound( carData:GetAttrValueById(CarAttrType.Stabilize).value/1000,100)
        local selfCushion= CommonHelper:FloatRound(carData:GetAttrValueById(CarAttrType.Cushion).value/1000,100)
        local selfDownforce=  CommonHelper:FloatRound(carData:GetAttrValueById(CarAttrType.Downforce).value/1000,100)
        CommonHelper:SetText("attr1/value",self.CarAttrRecommend,selfStabilize>=data.stabilizeMin and data.stabilizeMin or CommonHelper:GetTempStr_Default(TemplateStringID.CarAttrCompareLow,data.stabilizeMin))
        --CommonHelper:SetText("attr1/comparevalue",self.CarAttrRecommend,CommonHelper:GetAttrCompareString(data.stabilizeMin,selfStabilize))
        CommonHelper:SetText("attr2/value",self.CarAttrRecommend,selfCushion>=data.cushionMin and data.cushionMin or CommonHelper:GetTempStr_Default(TemplateStringID.CarAttrCompareLow,data.cushionMin))
        -- CommonHelper:SetText("attr2/comparevalue",self.CarAttrRecommend,CommonHelper:GetAttrCompareString(data.cushionMin,selfCushion))
        CommonHelper:SetText("attr3/value",self.CarAttrRecommend,selfDownforce>=data.downforceMin and data.downforceMin or CommonHelper:GetTempStr_Default(TemplateStringID.CarAttrCompareLow,data.downforceMin))
        --CommonHelper:SetText("attr3/comparevalue",self.CarAttrRecommend,CommonHelper:GetAttrCompareString(data.downforceMin,selfDownforce))
    end
    CommonHelper:SetGameObjectActive("nocarinfo",self.CarAttrRecommend,data==nil)
end
