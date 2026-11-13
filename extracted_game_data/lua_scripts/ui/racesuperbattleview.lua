---@class RaceSuperBattleView : ViewBase
RaceSuperBattleView = class("RaceSuperBattleView", ViewBase)

function RaceSuperBattleView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceSuperBattleViewAction")
end

function RaceSuperBattleView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(hbtn)
        CommonHelper:ShowHelpView(PageDetailType.RaceSuperBattle)
    end)
    CommonHelper:HButtonSetCallback("BtnBanTrack", self.gameObject, function(hbtn)
        UIManager:Get():OpenView("RaceSuperBattleBanTrackView",CanvasType.MainCanvas,"RaceSuperBattleBanTrackView")
    end)
    self.BtnSign=CommonHelper:HButtonSetCallback("BtnSign",self.gameObject,function (hbtn)
        if RaceSuperBattleManager:Get():GetCanSign() then
            if CarDataManager:Get():GetCarNum()<3 then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleNoEnoughCar))
                return
            end
            UIManager:Get():OpenView("RaceSuperBattleEnterView",CanvasType.MainCanvas,"RaceSuperBattleEnterView")
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceGVGNoSignRight))
        end
    end)
   CommonHelper:HButtonSetCallback("BtnSelectCar",self.gameObject,function (hbtn)
       if RaceSuperBattleManager:Get():IsEnter(self.Data:GetRaceState()) then
           --不足三辆车不跳转
           if CarDataManager:Get():GetCarNum()<3 then
               CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleNoEnoughCar))
               return
           end
           UIManager:Get():OpenView("RaceSuperBattleEnterView",CanvasType.MainCanvas,"RaceSuperBattleEnterView")
       else
           if self.Data:GetIsFail() then
               CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleFail))
               return
           end
           UIManager:Get():OpenView("RaceSuperBattleEnterView",CanvasType.MainCanvas,"RaceSuperBattleEnterView")
       end

    end)
    CommonHelper:HButtonSetCallback("BtnRaceOverLook",self.gameObject,function (hbtn)
        if RaceSuperBattleManager:Get():IsKnockout8State(self.Data:GetMatchRankState()) then
            RaceSuperBattleSubsystem:SendMsg_RaceSuperBattle64Rank(9)
        else
            RaceSuperBattleSubsystem:SendMsg_RaceSuperBattle64Rank(1)
        end

         --RaceSuperBattleSubsystem:Get():SendMsg_RaceResult(PlayerDataManager:Get():GetPlayerRID(),2)
    end)
    CommonHelper:HButtonSetCallback("BtnRankList",self.gameObject,function (hbtn)
        RaceSuperBattleSubsystem:Get():SendMsg_RaceSuperBattleRank()
    end)
    CommonHelper:HButtonSetCallback("BtnRaceLook",self.gameObject,function (hbtn)
        CommonHelper:ShowRaceStateView(UIModuleID.RaceSuperBattle)
    end)
    CommonHelper:HButtonSetCallback("BtnReward",self.gameObject,function (hbtn)
        CommonHelper:ShowRankingListReward(RankingRewardType.RaceSuperBattle,true,false)
    end)
    local SignState= self:GetChild("SignState")
    CommonHelper:HButtonSetCallback("BtnTask",SignState,function (hbtn)
        if UIManager:Get():IsViewShow("TaskView") == false then
            UIManager:Get():OpenView("TaskView", CanvasType.MainCanvas, "TaskView")
        end
        TaskDataManager:Get():SetOpenModuleType(UIModuleID.RaceSuperBattle)
        UINotify:Get():SendNotification(UINotifyEvent.TaskViewSetData, TaskType.SuperBattle)
    end)
    ---@type Page_SuperBattle_SelectCar
    self.PageSelectCar=nil
end

function RaceSuperBattleView:OnOpen()
    self.IsOpen=true
end

function RaceSuperBattleView:SetRaceState()
    ---@type RaceSuperBattleData
    self.Data=RaceSuperBattleManager:Get():GetData()
    print("1",RaceSuperBattleManager:Get():IsSignState(self.Data:GetRaceState()),self.Data:IsUpKnockout() , self.Data:GetIsFail()  , self.Data:OffSeason() ,  not RaceSuperBattleManager:Get():GetIsSign())
    print("1",RaceSuperBattleManager:Get():IsTrackReviewState(self.Data:GetRaceState()) , not self.Data:GetIsFail() ,not self.Data:OffSeason() , not self.Data:IsUpKnockout()  , RaceSuperBattleManager:Get():GetIsSign())
    self.SignRoot=CommonHelper:SetGameObjectActive("SignState",self.gameObject, RaceSuperBattleManager:Get():IsSignState(self.Data:GetRaceState()) or self.Data:IsUpKnockout() or self.Data:GetIsFail()  or self.Data:OffSeason() or  not RaceSuperBattleManager:Get():GetIsSign() )
    self.PreSelectCar=CommonHelper:SetGameObjectActive("RaceState",self.gameObject, RaceSuperBattleManager:Get():IsTrackReviewState(self.Data:GetRaceState()) and not self.Data:GetIsFail() and not self.Data:OffSeason() and not self.Data:IsUpKnockout() and RaceSuperBattleManager:Get():GetIsSign())
    CommonHelper:SetGameObjectActive("BtnRaceOverLook",self.SignRoot,RaceSuperBattleManager:Get():IsKnockoutState(self.Data:GetRaceState()))
    CommonHelper:SetGameObjectActive("BtnRankList",self.SignRoot,not RaceSuperBattleManager:Get():IsKnockoutState(self.Data:GetRaceState()))
    if  RaceSuperBattleManager:Get():IsSignState(self.Data:GetRaceState()) or self.Data:IsUpKnockout() or self.Data:GetIsFail()  or self.Data:OffSeason() or  not RaceSuperBattleManager:Get():GetIsSign()  then
        self:SetSignState()
    elseif  RaceSuperBattleManager:Get():IsTrackReviewState(self.Data:GetRaceState()) and not self.Data:GetIsFail() and not self.Data:OffSeason() and not self.Data:IsUpKnockout()  and RaceSuperBattleManager:Get():GetIsSign() then
        local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
        HomeSceneHelper:SetRefitTable(port)
        if self.PageSelectCar==nil then
            self.PageSelectCar=Page_SuperBattle_SelectCar()
        end
        if self.PageSelectCar then
            self.PageSelectCar:SetData(self.PreSelectCar)
        end
    end
    self:SetTimer()
end


function RaceSuperBattleView:SetSignState()
    local dataTimeStart=CommonHelper:ConvertIntToDataTime(self.Data:GetRaceBeginTime()*1000)
    local dataTimeEnd=CommonHelper:ConvertIntToDataTime(self.Data:GetRaceEndTime()*1000)
    local time1= CommonHelper:FormatDataString(dataTimeStart,"yyyy.MM.dd")
    local time2= CommonHelper:FormatDataString(dataTimeEnd,"yyyy.MM.dd")
    ---@type dictkillerstage_config_cell
    local cfg= CommonHelper:GetTableDataByID(ConfigNames.dictkillerstage_config,self.Data:GetState())
    CommonHelper:SetText("###racetime",self.SignRoot,CommonHelper:GetTempStr_Default(TemplateStringID.RaceGVGTime,time1,time2))
    CommonHelper:SetText("###statename",self.SignRoot,CommonHelper:GetTempStr_Default(cfg.desc))
    CommonHelper:SetGameObjectActive("BtnSigned",self.SignRoot,false)
    CommonHelper:SetGameObjectActive("BtnSign",self.SignRoot,false)
    CommonHelper:SetGameObjectActive("BtnNoSign",self.SignRoot,false)
    CommonHelper:SetGameObjectActive("BtnSelectCar",self.SignRoot,false)
    CommonHelper:SetGameObjectActive("BtnMatching",self.SignRoot,false)
    CommonHelper:SetGameObjectActive("BtnFail",self.SignRoot,false)
    CommonHelper:SetGameObjectActive("NoJoin",self.SignRoot,false)
    CommonHelper:SetGameObjectActive("DayResult",self.SignRoot,false)
    CommonHelper:SetGameObjectActive("OffSeason",self.SignRoot,false)
    CommonHelper:SetGameObjectActive("BePromoted",self.SignRoot,false)
    CommonHelper:SetGameObjectActive("BtnBanTracked",self.SignRoot,false)
    CommonHelper:SetGameObjectActive("BtnBanTrack",self.SignRoot,false)
    CommonHelper:SetGameObjectActive("BtnTask",self.SignRoot,RaceSuperBattleManager:Get():GetIsSign())
    if RaceSuperBattleManager:Get():GetIsSign() and  self.Data:GetIsFail() then
        CommonHelper:SetGameObjectActive("BtnFail",self.SignRoot,true)
        return
    end
    if self.Data:GetRaceState()==RaceSuperBattleBattleState.Enter then
        CommonHelper:SetGameObjectActive("BtnSigned",self.SignRoot,RaceSuperBattleManager:Get():GetIsSign())
        CommonHelper:SetGameObjectActive("BtnSign",self.SignRoot,RaceSuperBattleManager:Get():GetCanSign())
        return
    end
    if not RaceSuperBattleManager:Get():GetIsSign() then
        CommonHelper:SetGameObjectActive("NoJoin",self.SignRoot,true)
        return
    end

    if RaceSuperBattleManager:Get():IsPlayoffState(self.Data:GetRaceState())  and (self.Data:OffSeason() or  self.Data:IsUpKnockout()) then
        CommonHelper:SetGameObjectActive("OffSeason",self.SignRoot, self.Data:OffSeason())
        CommonHelper:SetGameObjectActive("BePromoted",self.SignRoot, self.Data:IsUpKnockout() and not self.Data:OffSeason())
        return
    end
    if RaceSuperBattleManager:Get():IsPlayoffResultState(self.Data:GetRaceState())  and  self.Data:IsPlayoffStateOverExt() then
        CommonHelper:SetGameObjectActive("DayResult",self.SignRoot, true)
        return
    end
    if RaceSuperBattleManager:Get():IsPlayoffResultState(self.Data:GetRaceState())  and not self.Data:GetIsFail() then
        CommonHelper:SetGameObjectActive("BePromoted",self.SignRoot,not self.Data:GetIsFail())
        return
    end
    if RaceSuperBattleManager:Get():IsBanTrackState(self.Data:GetRaceState()) and not self.Data:GetIsFail() then
        CommonHelper:SetGameObjectActive("BtnBanTracked",self.SignRoot,not self.Data:GetIsCanBanTrack())
        CommonHelper:SetGameObjectActive("BtnBanTrack",self.SignRoot,self.Data:GetIsCanBanTrack())
    end
    if RaceSuperBattleManager:Get():IsDayResultState(self.Data:GetRaceState()) and not self.Data:GetIsFail() then
        CommonHelper:SetGameObjectActive("DayResult",self.SignRoot,true)
        return
    end
    if RaceSuperBattleManager:Get():IsMatchState(self.Data:GetRaceState()) and RaceSuperBattleManager:Get():GetIsSign() and not self.Data:GetIsFail() then
        CommonHelper:SetGameObjectActive("BtnMatching",self.SignRoot,true)
        return
    end
    if RaceSuperBattleManager:Get():IsSelectCarState(self.Data:GetRaceState()) and RaceSuperBattleManager:Get():GetIsSign() and not self.Data:GetIsFail() then
        CommonHelper:SetGameObjectActive("BtnSelectCar",self.SignRoot,true)
        return
    end
end


function RaceSuperBattleView:ReOpen()
    self.IsOpen=false
    RaceSuperBattleSubsystem:Get():SendMsg_EnterRaceSuperBattle()
    if self.PageSelectCar then
        self.PageSelectCar:ReOpen()
    end
end


--{{{  设置时间
function RaceSuperBattleView:SetTimer()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
    end

    self.RaceSubTime = self.Data:GetRaceEndTime() - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    self.StateSubTime = self.Data:GetStageEndTime() - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    if self.StateSubTime<=0 then return end
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

function RaceSuperBattleView:SetRaceTime()
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
function RaceSuperBattleView:SetStateTime()
    local day = math.modf(self.StateSubTime / TimeSecond_Day)
    local hour = math.modf((self.StateSubTime - (day * TimeSecond_Day)) / TimeSecond_Hour)
    local minute = math.modf((self.StateSubTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour)) / TimeSecond_Minute)
    local second = self.StateSubTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour) - (minute * TimeSecond_Minute)
    self.StateSubTime = self.StateSubTime - 1
    if self.StateSubTime<=0 then
        cs_coroutine.start(function()
            coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
            RaceSuperBattleSubsystem:Get():SendMsg_EnterRaceSuperBattle()
        end)
    end
    local time=""
    if day >= 1 then
        time=CommonHelper:GetTempStr_Default(TemplateStringID.RaceGVGTimeDay, day, hour, minute)
    else
        time=CommonHelper:GetTempStr_Default(TemplateStringID.RaceGVGTimeHour, hour, minute, second)
    end
    local objName=""
    if RaceSuperBattleManager:Get():IsTrackReviewState(self.Data:GetRaceState()) and not self.Data:GetIsFail() and not self.Data:OffSeason() and not self.Data:IsUpKnockout()  and RaceSuperBattleManager:Get():GetIsSign() then
        objName="###subtime"
    else
        objName="###racestatetime"
    end
    if RaceSuperBattleManager:Get():IsTrackReviewState(self.Data:GetRaceState()) and not self.Data:GetIsFail() and not self.Data:OffSeason() and not self.Data:IsUpKnockout() then
        if day >= 1 then
            CommonHelper:SetText(objName, self.gameObject,
                    CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleSelectSubTime,CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTime, day, hour, minute)))
        else
            CommonHelper:SetText(objName, self.gameObject,
                    CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleSelectSubTime,CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTimeSecond, hour, minute, second)))
        end
    else
        if day >= 1 then
            CommonHelper:SetText(objName, self.gameObject,
                    CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleStateSubTime,CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTime, day, hour, minute)))
        else
            CommonHelper:SetText(objName, self.gameObject,
                    CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleStateSubTime,CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTimeSecond, hour, minute, second)))
        end
    end
end
--}}}



function RaceSuperBattleView:OnClose()
    if self.PageSelectCar then
        self.PageSelectCar:Release()
    end
    self:StopTime()
    CommonHelper:ReleasePool(UIModuleID.RaceSuperBattle)
end
function RaceSuperBattleView:OnAutoClose()
    self:StopTime()
end

function RaceSuperBattleView:StopTime()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
        self.TimeId = nil
    end
end
