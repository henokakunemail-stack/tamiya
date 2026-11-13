---@class RaceTrotEnterView : ViewBase
RaceTrotEnterView = class("RaceTrotEnterView", ViewBase)

function RaceTrotEnterView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceTrotEnterViewAction")
end

function RaceTrotEnterView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHelper",self.gameObject,function (hbtn)
        CommonHelper:ShowHelpView(PageDetailType.RaceTrot)
    end)
    CommonHelper:HButtonSetCallback("BtnHome",self.gameObject,function (hbtn)
        SkipModuleHelper:Get():BackToMainMenuView(true)
    end)

    CommonHelper:HButtonSetCallback("BtnShop",self.gameObject,function (hbtn)
        local activityData = CommonFestivalDataManager:Get():GetAllDataIDTab()
        if #activityData>0 then
            FunctionSkipManager:Get():SkipToFunction(GameFunction.CommonAct)
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ActActivityNoOpen))
        end

    end)
    CommonHelper:HButtonSetCallback("BtnRankList",self.gameObject,function (hbtn)
        if RaceActManager:Get():GetRaceInfo(RaceActId.RaceTrot,true) then
            RaceTrotSubsystem:Get():SendMsg_RankList()
        end
    end)
    CommonHelper:HButtonSetCallback("BtnRaceInfo",self.gameObject,function (hbtn)
        if RaceActManager:Get():GetRaceInfo(RaceActId.RaceTrot,true) then
            UIManager:Get():ShowPersistentView("RaceTrotHistoryView",CanvasType.FrontCanvas,"RaceTrotHistoryView")
        end

    end)

    CommonHelper:HButtonSetCallback("BtnEnter",self.gameObject,function (hbtn)
        if RaceActManager:Get():GetRaceInfo(RaceActId.RaceTrot,true) then
            if RaceTrotManager:Get():GetMaxCount() - RaceTrotManager:Get():GetJoinCount() > 0 then
                UIManager:Get():CloseView()
                UIManager:Get():OpenView("RaceTrotSelectTrackView", CanvasType.MainCanvas, "RaceTrotSelectTrackView")
            else
                local maxCount= CommonHelper:GetDictCalcData(CommonCfgKey.RaceTrotMaxEnterCount,false)
                if (maxCount-RaceTrotManager:Get():GetMaxCount()) -(RaceTrotManager:Get():GetJoinCount()-RaceTrotManager:Get():GetMaxCount())<=0 then
                    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotEnterNotCount))
                    return
                end
                local id = CommonHelper:GetDictCalcData(CommonCfgKey.RaceTrotEnterCost, false)
                if PlayerDataManager:Get():CheckCurrencyEnough(id, 1) then
                    UIManager:Get():CloseView()
                    UIManager:Get():OpenView("RaceTrotSelectTrackView", CanvasType.MainCanvas, "RaceTrotSelectTrackView")
                end
            end
        end
    end)

end
function RaceTrotEnterView:StopTime()
    if self.Time then
        TimerManager:Get():StopTimer(self.Time)
    end
end
function RaceTrotEnterView:StartTime()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
    end
    local flag,time=RaceActManager:Get():GetRaceInfo(RaceActId.RaceTrot,false,true)
    if time then
        local _beginTime=time.BeginTime
        local _endTime =time.EndTime
        self.TimeId = TimerManager:Get():CreateTimerLoop(1, function(class)
            if CommonHelper:GetNowTime()>_beginTime then
                local subTime=CommonHelper:SubTimeByDateTime(_endTime)
                if subTime>=0 then
                    self:StopTime()
                end
                local day,hour,minute,second=CommonHelper:GetConvertMillSecond(math.abs(subTime))
                CommonHelper:SetText("###subtime",self.gameObject, string.format("%s%s%s",CommonHelper:GetTempStr_Default(TemplateStringID.RaceOpenTimeTipsJu),CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotName),CommonHelper:GetTempStr_Default(TemplateStringID.RaceEndTime,day,hour,minute,second)))
            else
                local subTime= CommonHelper:SubTimeByDateTime(_beginTime)
                if subTime<=0 then
                    self:StopTime()
                end
                local day,hour,minute,second=CommonHelper:GetConvertMillSecond(math.abs(subTime))
                CommonHelper:SetText("###subtime",self.gameObject,string.format("%s%s%s",CommonHelper:GetTempStr_Default(TemplateStringID.RaceOpenTimeTipsJu),CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotName),CommonHelper:GetTempStr_Default(TemplateStringID.RaceOpenTime,day,hour,minute,second)))
            end
        end, self)
    end
end

function RaceTrotEnterView:OnOpen()
    self:SetData()
    self:StartTime()
    self:CheckNewBieGuide()
    HistoryDataManager:Get():Init()
end
function RaceTrotEnterView:ReOpen()


end


function RaceTrotEnterView:OnOpenAnimEnd()

end
function RaceTrotEnterView:OnClose()
   self:StopTime()
end
function RaceTrotEnterView:OnAutoClose()
   self:StopTime()
end
function RaceTrotEnterView:SetData(isRefresh)
    local flag,time=RaceActManager:Get():GetRaceInfo(RaceActId.RaceTrot,false,true)
    if flag then
        if RaceTrotManager:Get():GetMaxCount()-RaceTrotManager:Get():GetJoinCount()>0 then
            CommonHelper:SetGameObjectActive("entercost",self.gameObject,false)
            CommonHelper:SetText("###count",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotSubCount,RaceTrotManager:Get():GetJoinCount(),RaceTrotManager:Get():GetMaxCount()))
        else
            CommonHelper:SetGameObjectActive("entercost",self.gameObject,true)
            local maxCount= CommonHelper:GetDictCalcData(CommonCfgKey.RaceTrotMaxEnterCount,false)
            CommonHelper:SetText("###count",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotBattleCost,RaceTrotManager:Get():GetJoinCount()-RaceTrotManager:Get():GetMaxCount(),maxCount-RaceTrotManager:Get():GetMaxCount()))
        end
    else
        CommonHelper:SetGameObjectActive("entercost",self.gameObject,false)
        CommonHelper:SetText("###count",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotNoOpen))
    end

end
