---@class RaceGVGView : ViewBase
RaceGVGView = class("RaceGVGView", ViewBase)

function RaceGVGView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceGVGViewAction")
end

function RaceGVGView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(hbtn)
        CommonHelper:ShowHelpView(PageDetailType.RaceGVG)
    end)
    self.BtnGarage=CommonHelper:HButtonSetCallback("BtnGarage",self.gameObject,function (hbtn)
        SkipModuleHelper:Get():ToGarage(UIModuleID.RaceGVG)
    end)

    self.BtnSign=CommonHelper:HButtonSetCallback("BtnSign",self.gameObject,function (hbtn)
        if RaceGVGManager:Get():GetCanSign() then
            RaceGVGSubsystem:Get():SendMsg_JoinRace()
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceGVGNoSignRight))
        end

    end)
    CommonHelper:HButtonSetCallback("BtnRaceLook",self.gameObject,function (hbtn)
        CommonHelper:ShowRaceStateView(UIModuleID.RaceGVG)
    end)
    CommonHelper:HButtonSetCallback("BtnRewardClub",self.gameObject,function (hbtn)
        CommonHelper:ShowRankingListReward(RankingRewardType.RaceGVGGroup,true,false)
    end)
    CommonHelper:HButtonSetCallback("BtnRewardSelf",self.gameObject,function (hbtn)
        CommonHelper:ShowRankingListReward(RankingRewardType.RaceGVGPoint,true,false)
    end)
    CommonHelper:HButtonSetCallback("BtnGroup",self.gameObject,function (hbtn)
         RaceGVGSubsystem:Get():SendMsg_GetBattleScore()
    end)
    CommonHelper:HButtonSetCallback("BtnRanklist",self.gameObject,function (hbtn)
       if self.State==RaceGVGState.Race1Battle or self.State==RaceGVGState.Race1Calc then
            RaceGVGSubsystem:Get():SendMsg_RankList(0,RaceGVGState.Race1Battle,RaceGVGManager:Get():GetMatchSuccess())
            return
        end
       if self.State==RaceGVGState.Race2Battle or self.State==RaceGVGState.Race2Calc then
           RaceGVGSubsystem:Get():SendMsg_RankList(0,RaceGVGState.Race2Battle,RaceGVGManager:Get():GetMatchSuccess())
            return
        end
       if self.State==RaceGVGState.Race3Battle or self.State==RaceGVGState.Race3Calc then
           RaceGVGSubsystem:Get():SendMsg_RankList(0,RaceGVGState.Race3Battle,RaceGVGManager:Get():GetMatchSuccess())
            return
        end
        RaceGVGSubsystem:Get():SendMsg_RankList(1,0,RaceGVGManager:Get():GetMatchSuccess())
    end)
    self.BtnFight=CommonHelper:HButtonSetCallback("BtnFight",self.gameObject,function (hbtn)
        if RaceGVGManager:Get():GetCurNum()>=RaceGVGManager:Get():GetMaxNum()  then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopTopNoCount))
            return
        end
        if CarDataManager:Get():CheckCarCompleteness(self.Page_SelectCar:GetCurCar():GetID()) then
            RaceGVGSubsystem:Get():SendMsg_BeginBattle(self.Page_SelectCar:GetCurCar():GetID())
        end
    end)
    self.Pre_SelectCar = UIUtil.GetChild("Page_SelectCar", self.gameObject)
    self.ObjCarIdx = UIUtil.GetChild("CaridxGroup", self.gameObject)
    self.items = {}
    for i = 1, 4 do
        self.items[i] = UIUtil.GetChild("SelfItem" .. i, self.gameObject)
    end
    self.PartsItem = { 4, 1, 2, 3 }
end

function RaceGVGView:OnOpen()

    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRefitTable(port)
    self:SetCar()

end
function RaceGVGView:ReOpen()

    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRefitTable(port)
    self:SetCar()
    RaceGVGSubsystem:Get():SendMsg_GetInfo()
end
function RaceGVGView:SetCar()
    if self.PreCarIdx == nil then
        self.PreCarIdx = PreGarageCarIdx()
        self:SetPreGarageCar()
    else
        self:SetPreGarageCar()
    end

end

function RaceGVGView:SetPreGarageCar()
    self.PreCarIdx:SetData(self.ObjCarIdx, UIModuleID.RaceGVG, PlayerPrefsHelper:GetValue_MainMenuViewCarIndex(), true, false, function(data, isautoselect)
        self:SetCarMesh(data)
        PlayerPrefsHelper:SetValue_MainMenuViewCarIndex(data:GetCarIdx())
    end)
end
function RaceGVGView:SetCarMesh(data)
    if self.Page_SelectCar == nil then
        self.Page_SelectCar = Page_SelectCar()
        self:SetPageSelectCar(data)
    else
        self:SetPageSelectCar(data)
    end

end
---@param data CarData
function RaceGVGView:SetPageSelectCar(data)
    if self.Page_SelectCar then
        self.Page_SelectCar:SetData(self.Pre_SelectCar, UIModuleID.RaceGVG, data:GetCarIdx(), false, SceneChangeID.RefitTable, false)
        self:SetCarGroup(data)
    end
end
---@param cardata CarData
function RaceGVGView:SetCarGroup(cardata)
    local partsList = cardata:GetPartDataList()
    for i = 1, 4 do
        ---@type parts_config_cell
        local parts = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partsList[self.PartsItem[i]].PartCfgID)
        CommonHelper:SetGameObjectActive("ItemPart_118",self.items[i],parts~=nil)
        CommonHelper:SetGameObjectActive("grooveopen",self.items[i],parts==nil)
        local grovveId= AssembleHelper:MsgIdxToGrooveID(self.PartsItem[i])
        local cfg= CommonHelper:GetTableDataByID(ConfigNames.grooveid_config,grovveId)
        CommonHelper:GetComponentSetUITexture("defaulticon",self.items[i],cfg.bgicon,UIModuleID.RaceTop)
        if parts then
            CommonHelper:SetItemPartGroup(self.items[i], UIModuleID.RaceGVG, parts.C_ID)
        end
    end
end
--}}}

function RaceGVGView:OnClose()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
    end
    CommonHelper:ReleasePool(UIModuleID.RaceGVG)
end

function RaceGVGView:OnAutoClose()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
    end
end

function RaceGVGView:SetData()
    self.State=RaceGVGManager:Get():GetState()
    if self.State<=RaceGVGState.None then
        return
    end
    self.SignRoot=CommonHelper:SetGameObjectActive("SignState",self.gameObject,self.State==RaceGVGState.Sign or RaceGVGManager:Get():NoSign() or self.State==RaceGVGState.Group)
    self.RaceRoot=CommonHelper:SetGameObjectActive("RaceState",self.gameObject,self.State~=RaceGVGState.Sign and not RaceGVGManager:Get():NoSign() and self.State~=RaceGVGState.Group )

    if self.State==RaceGVGState.Sign or RaceGVGManager:Get():NoSign() or self.State==RaceGVGState.Group then
        self:SetSignState()
    else
        self:SetTimer()
        self:SetRaceState()
    end
end
function RaceGVGView:SetSignState()

    if self.State==RaceGVGState.Sign then
        self:SetTimer()
        CommonHelper:SetGameObjectActive("BtnSigned",self.SignRoot,RaceGVGManager:Get():GetIsSign())
        CommonHelper:SetGameObjectActive("BtnSign",self.SignRoot,not RaceGVGManager:Get():GetIsSign())
        CommonHelper:SetGameObjectActive("BtnNoSign",self.SignRoot,false)
        CommonHelper:SetGameObjectActive("BtnMatching",self.SignRoot,false)
        return
    end
    if self.State==RaceGVGState.Group and RaceGVGManager:Get():GetIsSign() then
        self:SetTimer()
        CommonHelper:SetGameObjectActive("BtnSigned",self.SignRoot,false)
        CommonHelper:SetGameObjectActive("BtnSign",self.SignRoot,false)
        CommonHelper:SetGameObjectActive("BtnNoSign",self.SignRoot,false)
        CommonHelper:SetGameObjectActive("BtnMatching",self.SignRoot,true)
        return
    end
    local dataTimeStart=CommonHelper:ConvertIntToDataTime(RaceGVGManager:Get():GetBeginTime()*1000)
    local dataTimeEnd=CommonHelper:ConvertIntToDataTime(RaceGVGManager:Get():GetEndTime()*1000)
    local time1= CommonHelper:FormatDataString(dataTimeStart,"yyyy.MM.dd")
    local time2= CommonHelper:FormatDataString(dataTimeEnd,"yyyy.MM.dd")
    CommonHelper:SetText("###racetime",self.SignRoot,CommonHelper:GetTempStr_Default(TemplateStringID.RaceGVGTime,time1,time2))
    CommonHelper:SetGameObjectActive("BtnSigned",self.SignRoot,false)
    CommonHelper:SetGameObjectActive("BtnSign",self.SignRoot,false)
    CommonHelper:SetGameObjectActive("BtnMatching",self.SignRoot,false)
    CommonHelper:SetGameObjectActive("BtnNoSign",self.SignRoot,true)
end


function RaceGVGView:SetRaceState()
    self:SetTrackData()
    self:SetFirstRacer()
    self:SetGuildInfo()
    self:SetFightState()
end
function RaceGVGView:SetFightState()
    CommonHelper:SetToggleState(self.BtnFight,not (self.State==RaceGVGState.Race3Battle or self.State==RaceGVGState.Race1Battle or self.State==RaceGVGState.Race2Battle))
    CommonHelper:SetHButtonClick(self.BtnFight,self.State==RaceGVGState.Race3Battle or self.State==RaceGVGState.Race1Battle or self.State==RaceGVGState.Race2Battle,false)
    CommonHelper:SetText("###fightcount",self.RaceRoot,CommonHelper:GetTempStr_Default(TemplateStringID.RaceGVGBattle,RaceGVGManager:Get():GetCurNum(),RaceGVGManager:Get():GetMaxNum()))
end
function RaceGVGView:SetGuildInfo()
    if RaceGVGManager:Get():GetGuildId()>0 then
        CommonHelper:GetComponentSetUITexture("GuildIcon", self.RaceRoot, CommonHelper:GetPlayerIconById(RaceGVGManager:Get():GetGuildIcon(), HeadIconType.ClubIcon)..".png", UIModuleID.RaceGVG)
        CommonHelper:SetText("###GuildName",self.RaceRoot,RaceGVGManager:Get():GetGuildName())
    else
        CommonHelper:GetComponentSetUITexture("FGuildIcon", self.RaceRoot, "guild_icon_default.png", UIModuleID.RaceGVG)
        CommonHelper:SetText("###GuildName",self.RaceRoot,CommonHelper:GetTempStr_Default(TemplateStringID.RaceGVGGuildNull))
    end
    if RaceGVGManager:Get():GetFGuildId()>0 then
        CommonHelper:GetComponentSetUITexture("FGuildIcon", self.RaceRoot, CommonHelper:GetPlayerIconById(RaceGVGManager:Get():GetFGuildIcon(), HeadIconType.ClubIcon)..".png", UIModuleID.RaceGVG)
        CommonHelper:SetText("###FGuildName",self.RaceRoot,RaceGVGManager:Get():GetFGuildName())
    else
        CommonHelper:GetComponentSetUITexture("FGuildIcon", self.RaceRoot, "guild_icon_default.png", UIModuleID.RaceGVG)
        CommonHelper:SetText("###FGuildName",self.RaceRoot,CommonHelper:GetTempStr_Default(TemplateStringID.RaceGVGGuildNull))
    end
end
function RaceGVGView:SetTrackData()
    self.TrackData = RaceGVGManager:Get():GetTrack()
    if self.TrackData then
        self.SceneId = RaceGVGManager:Get():GetSceneId()
        CommonHelper:GetComponentSetTrackIconByData("trackicon", self.RaceRoot, self.TrackData, UIModuleID.RaceGVG)
        CommonHelper:SetTrackFeatureByParent("trackfeature", self.RaceRoot, self.TrackData:GetFeature(), true)
        CommonHelper:SetGameObjectActive("trackfeature",self.RaceRoot,true)
        CommonHelper:SetGameObjectActive("BtnReview",self.RaceRoot,true)
        if self.SceneId ~= -1 then
            ---@type scene_config_cell
            local sceneCfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, self.SceneId)
            if sceneCfg then
                CommonHelper:GetComponentSetUITexture("chapterpic", self.RaceRoot, sceneCfg.icon, UIModuleID.RaceGVG)
            end
        end
        CommonHelper:HButtonSetCallback("BtnReview", self.RaceRoot, function(data)
            if self.TrackData:GetIsField() then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackFieldNoLook))
            else
                CommonHelper:LoadReviewTrack(nil, self.TrackData)
            end
        end)
    else
        CommonHelper:GetComponentSetUITexture("trackicon",self.RaceRoot,"uitex_sucai_default.png",UIModuleID.RaceGVG)
        CommonHelper:SetGameObjectActive("trackfeature",self.RaceRoot,false)
        CommonHelper:SetGameObjectActive("BtnReview",self.RaceRoot,false)

    end

end
function RaceGVGView:SetFirstRacer()
    local MyRank=self:GetChild("FirstRank")
    if RaceGVGManager:Get():GetFastTime()>0 then
        --时间
        CommonHelper:GetComponentTransferTime("###timevalue1", MyRank,RaceGVGManager:Get():GetFastTime())
        --名字
        CommonHelper:SetText("###playername", MyRank, PlayerDataManager:Get():GetPlayerName())
         CommonHelper:SetText("###clubername", MyRank, PlayerDataManager:Get():GetGuildName())
        --头像
        CommonHelper:SetPlayerIconById("PlayerIcon", MyRank, PlayerDataManager:Get():GetPlayerIcon(), PlayerDataManager:Get():GetPlayerIconFrame(), nil, UIModuleID.RaceTop)
    else
        CommonHelper:SetText("###timevalue1", MyRank, "--:--:--")
        CommonHelper:SetText("###playername", MyRank, PlayerDataManager:Get():GetPlayerName())
        CommonHelper:SetText("###clubername", MyRank, PlayerDataManager:Get():GetGuildName())
        CommonHelper:SetPlayerIconById("PlayerIcon", MyRank, PlayerDataManager:Get():GetPlayerIcon(), PlayerDataManager:Get():GetPlayerIconFrame(), nil, UIModuleID.RaceTop)
    end
end
function RaceGVGView:SetTimer()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
    end

    self.RaceSubTime = RaceGVGManager:Get():GetEndTime() - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    self.StateSubTime = RaceGVGManager:Get():GetCEndTime() - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    self:SetRaceTime()
    self:SetStateTime()
    self.TimeId = TimerManager:Get():CreateTimerLoop(1, function(class)
        if self.RaceSubTime <= 0 then
            TimerManager:Get():StopTimer(self.TimeId)
        end
        self:SetRaceTime()
        self:SetStateTime()

    end, self)
end

function RaceGVGView:SetRaceTime()
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
function RaceGVGView:SetStateTime()
    local day = math.modf(self.StateSubTime / TimeSecond_Day)
    local hour = math.modf((self.StateSubTime - (day * TimeSecond_Day)) / TimeSecond_Hour)
    local minute = math.modf((self.StateSubTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour)) / TimeSecond_Minute)
    local second = self.StateSubTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour) - (minute * TimeSecond_Minute)
    self.StateSubTime = self.StateSubTime - 1
    if self.StateSubTime<=0 then
        RaceGVGSubsystem:Get():SendMsg_GetInfo()
    end
    local time=""
    if day >= 1 then
        time=CommonHelper:GetTempStr_Default(TemplateStringID.RaceGVGTimeDay, day, hour, minute)
    else
        time=CommonHelper:GetTempStr_Default(TemplateStringID.RaceGVGTimeHour, hour, minute, second)
    end
    local objName=""
    if self.State==RaceGVGState.Sign or self.State==RaceGVGState.Group  then
        objName="###racetime"
        CommonHelper:SetText(objName, self.SignRoot, CommonHelper:GetTempStr_Default(self:GetFormatStringByState(), time))
    else
        objName="###donetime"
        CommonHelper:SetText("###state",self.RaceRoot,CommonHelper:GetTempStr_Default(self:GetFormatStringByState()))
        CommonHelper:SetText(objName, self.gameObject,  time)
    end



    --if day >= 1 then
    --    CommonHelper:SetText(objName, self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopDayTime, day, hour, minute))
    --else
    --    CommonHelper:SetText(objName, self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RaceTopStateTime, hour, minute, second))
    --end
end
function RaceGVGView:GetFormatStringByState()
    if self.State==RaceGVGState.Sign then
        return TemplateStringID.RaceGVGStateSign
    end
    if self.State==RaceGVGState.Group then
        return TemplateStringID.RaceGVGStateMatching
    end
    if self.State==RaceGVGState.Race1Battle then
        return TemplateStringID.RaceGVGStateDay1Race
    end
    if self.State==RaceGVGState.Race1Calc then
        return TemplateStringID.RaceGVGStateDay1Settlement
    end
    if self.State==RaceGVGState.Race2Battle then
        return TemplateStringID.RaceGVGStateDay2Race
    end
   if self.State==RaceGVGState.Race2Calc then
        return TemplateStringID.RaceGVGStateDay2Settlement
    end
   if self.State==RaceGVGState.Race3Battle then
        return TemplateStringID.RaceGVGStateDay3Race
    end
   if self.State==RaceGVGState.Race3Calc then
        return TemplateStringID.RaceGVGStateDay3Settlement
    end
    if self.State==RaceGVGState.RaceCalc then
        return TemplateStringID.RaceGVGStateSettlement
    end

end



