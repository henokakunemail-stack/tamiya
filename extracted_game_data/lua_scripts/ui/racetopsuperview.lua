---@class RaceTopSuperView : ViewBase
RaceTopSuperView = class("RaceTopSuperView", ViewBase)

function RaceTopSuperView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceTopSuperViewAction")
end

function RaceTopSuperView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(hbtn)
        CommonHelper:ShowHelpView(PageDetailType.RaceTopSuper)
    end)
    self.BtnGarage1=CommonHelper:HButtonSetCallback("BtnGarage1",self.gameObject,function (hbtn)
        SkipModuleHelper:Get():ToGarage(UIModuleID.RaceTopSuper)
    end)
    self.BtnGarage2=CommonHelper:HButtonSetCallback("BtnGarage2",self.gameObject,function (hbtn)
        SkipModuleHelper:Get():ToGarage(UIModuleID.RaceTopSuper)
    end)
    self.BtnGroup=CommonHelper:HButtonSetCallback("BtnGroup",self.gameObject,function (hbtn)
        RaceTopSuperSubsystem:Get():SendMsg_GetRankListTop()
    end)
    self.BtnTopGroup=CommonHelper:HButtonSetCallback("BtnTopGroup",self.gameObject,function (hbtn)
        RaceTopSuperSubsystem:Get():SendMsg_GetRankListTop()
    end)
    self.BtnFight=CommonHelper:HButtonSetCallback("BtnFight",self.gameObject,function (hbtn)
       -- CommonHelper:CheckMini4wdRule(UIModuleID.RaceTop,function()
            if CarDataManager:Get():CheckCarCompleteness(self.Page_SelectCar:GetCurCar():GetID())  and RaceTopSuperManager:Get():GetCurNum()< RaceTopSuperManager:Get():GetMaxNum() then
                if RaceTopSuperManager:Get():GetStates()==RaceTopState.Audition then
                    RaceTopSuperSubsystem:Get():SendMsg_BeginBattleRaceTopAudition(self.Page_SelectCar:GetCurCar():GetID())
                elseif RaceTopSuperManager:Get():GetStates()==RaceTopState.RaceB then
                    RaceTopSuperSubsystem:Get():SendMsg_BeginBattleRaceTopB(self.Page_SelectCar:GetCurCar():GetID())
                else
                    if RaceTopSuperManager:Get():GetCanJoin() then
                        RaceTopSuperSubsystem:Get():SendMsg_BeginBattleRaceTopTop(self.Page_SelectCar:GetCurCar():GetID())
                    else
                        if not RaceTopSuperManager:Get():GetCanJoin() then
                            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopTopEliminate))
                        end
                    end
                end
            else
                if RaceTopSuperManager:Get():GetCurNum()>= RaceTopSuperManager:Get():GetMaxNum() then
                    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopTopNoCount))
                end
            end
       -- end)
    end)
    self.BtnTestRun=CommonHelper:HButtonSetCallback("BtnTestRun",self.gameObject,function (hbtn)
       -- CommonHelper:CheckMini4wdRule(UIModuleID.RaceTop,function()
            if CarDataManager:Get():CheckCarCompleteness(self.Page_SelectCar:GetCurCar():GetID()) then
                RaceTopSuperManager:Get():SetRaceType(RaceTopRaceType.Test)
                RaceTopSuperManager:Get():BeginBattle({ trackId= RaceTopSuperManager:Get():GetTrackData().id, scenceId= RaceTopSuperManager:Get():GetSceneID(), carId=self.Page_SelectCar:GetCurCar():GetID()})
            end
      --  end)

    end)
    self.BtnRanklist=CommonHelper:HButtonSetCallback("BtnRanklist",self.gameObject,function (hbtn)
        if RaceTopSuperManager:Get():GetStates()==RaceTopState.RaceB then
            RaceTopSuperSubsystem:Get():SendMsg_GetRankListB()
        else
            RaceTopSuperSubsystem:Get():SendMsg_GetRankListAudition()
        end
    end)
    self.BtnReward=CommonHelper:HButtonSetCallback("BtnReward",self.gameObject,function (hbtn)
        CommonHelper:ShowRankingListReward(RankingRewardType.RaceTopSuper32,true,false)
    end)
    self.Pre_SelectCar = UIUtil.GetChild("Page_SelectCar", self.gameObject)
    self.ObjCarIdx = UIUtil.GetChild("CaridxGroup", self.gameObject)
    self.items = {}
    for i = 1, 4 do
        self.items[i] = UIUtil.GetChild("SelfItem" .. i, self.gameObject)
    end
    self.PartsItem = { 4, 1, 2, 3 }
end

function RaceTopSuperView:OnOpen()
    --CommonHelper:IsOpenMini4wdRuleView(UIModuleID.RaceTop)
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRefitTable(port)
    self:SetCar()
end
function RaceTopSuperView:ReOpen()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRefitTable(port)
    self:SetCar()
    RaceTopSuperSubsystem:Get():SendMsg_EnterRaceTop()
end
function RaceTopSuperView:SetCar()
    if self.PreCarIdx == nil then
        self.PreCarIdx = PreGarageCarIdx()
        self:SetPreGarageCar()
    else
        self:SetPreGarageCar()
    end

end

function RaceTopSuperView:SetPreGarageCar()
    self.PreCarIdx:SetData(self.ObjCarIdx, UIModuleID.RaceTopSuper, PlayerPrefsHelper:GetValue_MainMenuViewCarIndex(), true, false, function(data, isautoselect)
        self:SetCarMesh(data)
        PlayerPrefsHelper:SetValue_MainMenuViewCarIndex(data:GetCarIdx())
    end)
end
function RaceTopSuperView:SetCarMesh(data)
    if self.Page_SelectCar == nil then
        self.Page_SelectCar = Page_SelectCar()
        self:SetPageSelectCar(data)
    else
        self:SetPageSelectCar(data)
    end

end
---@param data CarData
function RaceTopSuperView:SetPageSelectCar(data)
    if self.Page_SelectCar then
        self.Page_SelectCar:SetData(self.Pre_SelectCar, UIModuleID.RaceTopSuper, data:GetCarIdx(), false, SceneChangeID.RefitTable, false)
        self:SetCarGroup(data)
    end
end
---@param cardata CarData
function RaceTopSuperView:SetCarGroup(cardata)
    local partsList = cardata:GetPartDataList()
    for i = 1, 4 do
        ---@type parts_config_cell
        local parts = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partsList[self.PartsItem[i]].PartCfgID)
        CommonHelper:SetGameObjectActive("ItemPart_118",self.items[i],parts~=nil)
        CommonHelper:SetGameObjectActive("grooveopen",self.items[i],parts==nil)
        local grovveId= AssembleHelper:MsgIdxToGrooveID(self.PartsItem[i])
        local cfg= CommonHelper:GetTableDataByID(ConfigNames.grooveid_config,grovveId)
        CommonHelper:GetComponentSetUITexture("defaulticon",self.items[i],cfg.bgicon,UIModuleID.RaceTopSuper)
        if parts then
            CommonHelper:SetItemPartGroup(self.items[i], UIModuleID.RaceTopSuper, parts.C_ID)
        end
    end
end
--}}}

function RaceTopSuperView:SetData()
    self:SetRaceTopState()
    self:SetTrackData()
    self:SetFirstRacer()
    self:OpenUpView()
end
function RaceTopSuperView:SetTrackData()
    self.TrackData = RaceTopSuperManager:Get():GetTrackData()
    if self.TrackData then
        self.SceneId = RaceTopSuperManager:Get():GetSceneID()
        CommonHelper:GetComponentSetTrackIconByData("trackicon", self.gameObject, self.TrackData, UIModuleID.RaceTopSuper)
        CommonHelper:SetTrackFeatureByParent("trackfeature", self.gameObject, self.TrackData:GetFeature(), true)
        CommonHelper:SetGameObjectActive("trackfeature",self.gameObject,true)
        CommonHelper:SetGameObjectActive("BtnReview",self.gameObject,true)
        if self.SceneId ~= -1 then
            ---@type scene_config_cell
            local sceneCfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, self.SceneId)
            if sceneCfg then
                CommonHelper:GetComponentSetUITexture("chapterpic", self.gameObject, sceneCfg.icon, UIModuleID.RaceTopSuper)
            end
        end
        CommonHelper:HButtonSetCallback("BtnReview", self.gameObject, function(data)
            if self.TrackData:GetIsField() then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackFieldNoLook))
            else
                CommonHelper:LoadReviewTrack(nil, self.TrackData)
            end
        end)
    else
        CommonHelper:GetComponentSetUITexture("trackicon",self.gameObject,"uitex_sucai_default.png",UIModuleID.RaceTopSuper)
        CommonHelper:SetGameObjectActive("trackfeature",self.gameObject,false)
        CommonHelper:SetGameObjectActive("BtnReview",self.gameObject,false)

    end

end
function RaceTopSuperView:SetFirstRacer()
    local FirstRank=self:GetChild("FirstRank")
    local MyRank=self:GetChild("MyRank")

    if RaceTopSuperManager:Get():GetFirstRacer() then
        local player= RaceTopSuperManager:Get():GetFirstRacer()
        --时间
        CommonHelper:GetComponentTransferTime("###timevalue1", FirstRank, player.Time)
        --名字
        CommonHelper:SetText("###playername", FirstRank, player.Name)
      --  CommonHelper:SetText("###clubername", MyRank, player.PlayerName)
        --头像
        CommonHelper:SetPlayerIconById("PlayerIcon", FirstRank, player.HeadIcon, player.IconFrame, nil, UIModuleID.RaceTopSuper)
    else
        CommonHelper:SetText("###timevalue1", FirstRank, "--:--:--")
        CommonHelper:SetText("###playername", FirstRank, CommonHelper:GetTempStr_Default(TemplateStringID.RaceRankNoRank))
       -- CommonHelper:SetText("###clubername", MyRank, "")
        CommonHelper:SetPlayerIcon("PlayerIcon", FirstRank, "playericon_z_default.png", nil, nil, UIModuleID.RaceTopSuper)
    end
    if RaceTopSuperManager:Get():GetSelfFirst()>0 then
        --时间
        CommonHelper:GetComponentTransferTime("###timevalue1", MyRank, RaceTopSuperManager:Get():GetSelfFirst())
        --名字
        CommonHelper:SetText("###playername", MyRank, PlayerDataManager:Get():GetPlayerName())
       -- CommonHelper:SetText("###clubername", MyRank, PlayerDataManager:Get():GetGuildName())
        --头像
        CommonHelper:SetPlayerIconById("PlayerIcon", MyRank, PlayerDataManager:Get():GetPlayerIcon(), PlayerDataManager:Get():GetPlayerIconFrame(), nil, UIModuleID.RaceTopSuper)
    else
        CommonHelper:SetText("###timevalue1", MyRank, "--:--:--")
        CommonHelper:SetText("###playername", MyRank, PlayerDataManager:Get():GetPlayerName())
        --CommonHelper:SetText("###clubername", MyRank, PlayerDataManager:Get():GetGuildName())
        CommonHelper:SetPlayerIconById("PlayerIcon", MyRank, PlayerDataManager:Get():GetPlayerIcon(), PlayerDataManager:Get():GetPlayerIconFrame(), nil, UIModuleID.RaceTopSuper)
    end
end

function RaceTopSuperView:SetRaceTopState()
    self.OpenState= RaceTopSuperManager:Get():GetOpenState()
    self.States= RaceTopSuperManager:Get():GetStates()
    if self.OpenState==RaceTopOpenState.Open and self.States>RaceTopState.None  then
        CommonHelper:SetGameObjectActive("openrace",self.gameObject,true)
        CommonHelper:SetGameObjectActive("unopenrace",self.gameObject,false)
        CommonHelper:SetHButtonClick(self.BtnTestRun,true,false)
        CommonHelper:SetHButtonClick(self.BtnFight,true,false)
        CommonHelper:SetToggleState(self.BtnTestRun,false)
        CommonHelper:SetToggleState(self.BtnFight,false)
        if RaceTopSuperManager:Get():GetCanJoin() or self.States==RaceTopState.RaceB or self.States==RaceTopState.Audition then
            CommonHelper:SetText("hover/###fightcount",self.BtnFight.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopBeginFight, RaceTopSuperManager:Get():GetCurNum(), RaceTopSuperManager:Get():GetMaxNum()))
            CommonHelper:SetText("bg/###fightcount",self.BtnFight.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopBeginFight, RaceTopSuperManager:Get():GetCurNum(), RaceTopSuperManager:Get():GetMaxNum()))
        elseif self.States==RaceTopState.Select32 or self.States==RaceTopState.Select16 or self.States==RaceTopState.Select8  or self.States==RaceTopState.Select4 or self.States==RaceTopState.Select2  or self.States==RaceTopState.RaceTop1  then
            CommonHelper:SetText("hover/###fightcount",self.BtnFight.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopUping))
            CommonHelper:SetText("bg/###fightcount",self.BtnFight.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopUping))
        else
            CommonHelper:SetText("hover/###fightcount",self.BtnFight.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopOutSeason))
            CommonHelper:SetText("bg/###fightcount",self.BtnFight.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopOutSeason))
        end
        if self.States==RaceTopState.Audition then
                CommonHelper:SetText("###statetittle",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopRaceAudition))
                CommonHelper:SetHButtonClick(self.BtnGarage1,true,true)
                CommonHelper:SetHButtonClick(self.BtnGarage2,false,true)
                CommonHelper:SetHButtonClick(self.BtnGroup,false,true)
                CommonHelper:SetHButtonClick(self.BtnTopGroup,false,true)
                CommonHelper:SetHButtonClick(self.BtnRanklist,true,true)
                CommonHelper:SetHButtonClick(self.BtnReward,false,true)
                CommonHelper:SetToggleState(self.BtnFight, RaceTopSuperManager:Get():GetCurNum()>= RaceTopSuperManager:Get():GetMaxNum() )
                CommonHelper:SetGameObjectActive("AuditionRaceState",self.gameObject,true)
                CommonHelper:SetGameObjectActive("TopRaceState",self.gameObject,false)
                CommonHelper:SetGameObjectActive("BRaceState",self.gameObject,false)
                CommonHelper:SetGameObjectActive("AuditionDone",self.gameObject,false)
        elseif self.States==RaceTopState.RaceB then
                CommonHelper:SetText("###statetittle",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopRaceB))
                CommonHelper:SetHButtonClick(self.BtnGarage1,false,true)
                CommonHelper:SetHButtonClick(self.BtnGarage2,true,true)
                CommonHelper:SetHButtonClick(self.BtnGroup,false,true)
                CommonHelper:SetHButtonClick(self.BtnTopGroup,true,true)
                CommonHelper:SetHButtonClick(self.BtnRanklist,true,true)
                CommonHelper:SetHButtonClick(self.BtnReward,false,true)
                CommonHelper:SetGameObjectActive("AuditionRaceState",self.gameObject,false)
                CommonHelper:SetGameObjectActive("TopRaceState",self.gameObject,false)
                CommonHelper:SetGameObjectActive("BRaceState",self.gameObject,true)
                CommonHelper:SetGameObjectActive("AuditionDone",self.gameObject,false)
        elseif self.States==RaceTopState.Race32 or self.States==RaceTopState.Race16 or self.States==RaceTopState.Race8  or self.States==RaceTopState.Race4 or self.States==RaceTopState.Race2 then
                CommonHelper:SetText("###statetittle",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopRaceTop))
                CommonHelper:SetText("TopRaceState/###topracestate",self.gameObject,CommonHelper:GetTempStr_Default(CommonHelper:GetRaceTopStateByState(self.States)))
                CommonHelper:SetHButtonClick(self.BtnGarage1,false,true)
                CommonHelper:SetHButtonClick(self.BtnGarage2,true,true)
                CommonHelper:SetHButtonClick(self.BtnGroup,true,true)
                CommonHelper:SetHButtonClick(self.BtnTopGroup,false,true)
                CommonHelper:SetGameObjectActive("AuditionRaceState",self.gameObject,false)
                CommonHelper:SetGameObjectActive("TopRaceState",self.gameObject,true)
                CommonHelper:SetGameObjectActive("BRaceState",self.gameObject,false)
                CommonHelper:SetGameObjectActive("AuditionDone",self.gameObject,false)
                CommonHelper:SetHButtonClick(self.BtnTestRun,true,false)
                CommonHelper:SetHButtonClick(self.BtnFight, RaceTopSuperManager:Get():GetCanJoin(),false)
                CommonHelper:SetHButtonClick(self.BtnRanklist,false,true)
                CommonHelper:SetHButtonClick(self.BtnReward,true,true)
                CommonHelper:SetToggleState(self.BtnTestRun,false)
                CommonHelper:SetToggleState(self.BtnFight,not RaceTopSuperManager:Get():GetCanJoin())
        elseif self.States==RaceTopState.Select32 or self.States==RaceTopState.Select16 or self.States==RaceTopState.Select8  or self.States==RaceTopState.Select4 or self.States==RaceTopState.Select2  or self.States==RaceTopState.RaceTop1 then
                CommonHelper:SetText("###statetittle",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopRaceTop))
                CommonHelper:SetText("TopRaceState/###topracestate",self.gameObject,CommonHelper:GetTempStr_Default(CommonHelper:GetRaceTopStateByState(self.States)))
                CommonHelper:SetHButtonClick(self.BtnGarage1,false,true)
                CommonHelper:SetHButtonClick(self.BtnGarage2,true,true)
                CommonHelper:SetHButtonClick(self.BtnGroup,true,true)
                CommonHelper:SetHButtonClick(self.BtnTopGroup,false,true)
                CommonHelper:SetHButtonClick(self.BtnTestRun,false,false)
                CommonHelper:SetHButtonClick(self.BtnFight,false,false)
                CommonHelper:SetHButtonClick(self.BtnRanklist,false,true)
                CommonHelper:SetHButtonClick(self.BtnReward,true,true)
                CommonHelper:SetToggleState(self.BtnTestRun,true)
                CommonHelper:SetToggleState(self.BtnFight,true)
                CommonHelper:SetGameObjectActive("AuditionRaceState",self.gameObject,false)
                CommonHelper:SetGameObjectActive("TopRaceState",self.gameObject,true)
                CommonHelper:SetGameObjectActive("BRaceState",self.gameObject,false)
                CommonHelper:SetGameObjectActive("AuditionDone",self.gameObject,false)
        elseif self.States==RaceTopState.Settlement then
                CommonHelper:SetText("###statetittle",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopRaceTop))
                CommonHelper:SetText("TopRaceState/###topracestate",self.gameObject,CommonHelper:GetTempStr_Default(CommonHelper:GetRaceTopStateByState(self.States)))
                CommonHelper:SetHButtonClick(self.BtnGarage1,false,true)
                CommonHelper:SetHButtonClick(self.BtnGarage2,true,true)
                CommonHelper:SetHButtonClick(self.BtnGroup,true,true)
                CommonHelper:SetHButtonClick(self.BtnTopGroup,false,true)
                CommonHelper:SetHButtonClick(self.BtnTestRun,false,false)
                CommonHelper:SetHButtonClick(self.BtnFight,false,false)
                CommonHelper:SetHButtonClick(self.BtnRanklist,false,true)
                CommonHelper:SetHButtonClick(self.BtnReward,true,true)
                CommonHelper:SetToggleState(self.BtnTestRun,true)
                CommonHelper:SetToggleState(self.BtnFight,true)
                CommonHelper:SetGameObjectActive("AuditionRaceState",self.gameObject,false)
                CommonHelper:SetGameObjectActive("TopRaceState",self.gameObject,true)
                CommonHelper:SetGameObjectActive("BRaceState",self.gameObject,false)
                CommonHelper:SetGameObjectActive("AuditionDone",self.gameObject,false)
        end
        if self.States==RaceTopState.Select32 then
            CommonHelper:SetHButtonClick(self.BtnReward,false,true)
            CommonHelper:SetHButtonClick(self.BtnRanklist,true,true)
        end
            self:SetTimer()
    else
        CommonHelper:SetText("###statetittle",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopUnOpenRace))
        CommonHelper:SetGameObjectActive("openrace",self.gameObject,false)
        CommonHelper:SetGameObjectActive("unopenrace",self.gameObject,true)
        CommonHelper:SetHButtonClick(self.BtnGarage1,true,true)
        CommonHelper:SetHButtonClick(self.BtnGarage2,false,true)
        CommonHelper:SetHButtonClick(self.BtnGroup,false,true)
        CommonHelper:SetHButtonClick(self.BtnTopGroup,false,true)
        CommonHelper:SetHButtonClick(self.BtnTestRun,false,false)
        CommonHelper:SetHButtonClick(self.BtnFight,false,false)
        CommonHelper:SetHButtonClick(self.BtnReward,false,true)
        CommonHelper:SetHButtonClick(self.BtnRanklist,false,true)
        CommonHelper:SetToggleState(self.BtnTestRun,true)
        CommonHelper:SetToggleState(self.BtnFight,true)
        CommonHelper:SetText("hover/###fightcount",self.BtnFight.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopUnOpen))
        CommonHelper:SetText("bg/###fightcount",self.BtnFight.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopUnOpen))
        CommonHelper:SetText("###opentime",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopUnOpen))
    end
end
function RaceTopSuperView:SetTimer()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
    end
    self.RaceSubTime = RaceTopSuperManager:Get():GetRaceEndTime() - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    self.StateSubTime = RaceTopSuperManager:Get():GetRaceStateEndTime() - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    self.TimeId = TimerManager:Get():CreateTimerLoop(1, function(class)
        if self.RaceSubTime <= 0 then
            UIManager:Get():CloseView()
            TimerManager:Get():StopTimer(self.TimeId)
            return
        end
        self:SetRaceTime()
        self:SetStateTime()

    end, self)
end

function RaceTopSuperView:SetRaceTime()
    local day = math.modf(self.RaceSubTime / TimeSecond_Day)
    local hour = math.modf((self.RaceSubTime - (day * TimeSecond_Day)) / TimeSecond_Hour)
    local minute = math.modf((self.RaceSubTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour)) / TimeSecond_Minute)
    local second = self.RaceSubTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour) - (minute * TimeSecond_Minute)
    self.RaceSubTime = self.RaceSubTime - 1

    if day >= 1 then
        CommonHelper:SetText("###opentime", self.gameObject,
                CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopOpenDayTime, day, hour, minute))
    else
        CommonHelper:SetText("###opentime", self.gameObject,
                CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopOpenTime, hour, minute, second))
    end
end
function RaceTopSuperView:SetStateTime()
    local day = math.modf(self.StateSubTime / TimeSecond_Day)
    local hour = math.modf((self.StateSubTime - (day * TimeSecond_Day)) / TimeSecond_Hour)
    local minute = math.modf((self.StateSubTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour)) / TimeSecond_Minute)
    local second = self.StateSubTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour) - (minute * TimeSecond_Minute)
    self.StateSubTime = self.StateSubTime - 1
    if self.StateSubTime<=0 then
        RaceTopSuperSubsystem:Get():SendMsg_EnterRaceTop()
    end
    local objName=""
    if self.States==RaceTopState.Audition then
        objName="AuditionRaceState/###auditiondonetime"
    elseif self.States==RaceTopState.RaceB then
        objName="BRaceState/###donetime"
    else
        objName="TopRaceState/###donetime"
    end
    if day >= 1 then
        CommonHelper:SetText(objName, self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopDayTime, day, hour, minute))
    else
        CommonHelper:SetText(objName, self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopStateTime, hour, minute, second))
    end
end

function RaceTopSuperView:OnClose()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
    end
    CommonHelper:ReleasePool(UIModuleID.RaceTopSuper)
end

function RaceTopSuperView:OnAutoClose()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
    end
end

function RaceTopSuperView:OpenUpView()
    local state= RaceTopSuperManager:Get():GetStates()
    if (state==RaceTopState.Race32
       or  state==RaceTopState.Race16
       or  state==RaceTopState.Race8
       or  state==RaceTopState.Race4
       or  state==RaceTopState.Race2)
       and  RaceTopSuperManager:Get():GetCanJoin()
    then
        if  PlayerPrefsHelper:GetValue_RaceTopSuperUpShow()==false then
            CommonHelper:PlayScreenEffectNull(true)
            cs_coroutine.start(function()
                coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
                CommonHelper:PlayScreenEffectNull(false)
                PlayerPrefsHelper:SetValue_RaceTopSuperUpShow(1)
                UIManager:Get():ShowPersistentView("RaceTopSuperUpShowView",CanvasType.MainCanvas,"RaceTopSuperUpView")
            end)
        end

    end

end

