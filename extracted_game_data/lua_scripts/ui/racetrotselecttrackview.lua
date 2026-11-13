---@class RaceTrotSelectTrackView : ViewBase
RaceTrotSelectTrackView = class("RaceTrotSelectTrackView", ViewBase)

function RaceTrotSelectTrackView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceTrotSelectTrackViewAction")
end

function RaceTrotSelectTrackView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHome",self.gameObject,function (hbtn)
        SkipModuleHelper:Get():BackToMainMenuView(true,function()
            self:Clear()
        end)
    end)
    CommonHelper:HButtonSetCallback("BtnForbidden",self.gameObject,function (hbtn)
        if ForbiddenDataManager:Get():IsForbidden() then
            UIManager:Get():OpenPopup("ForbiddenView",CanvasType.MainCanvas,"ForbiddenView")
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.UnForbidden))
        end
    end)
    CommonHelper:HButtonSetCallback("BtnHistory",self.gameObject,function (hbtn)
        UIManager:Get():ShowPersistentView("RaceTrotHistoryView",CanvasType.FrontCanvas,"RaceTrotHistoryView")
    end)
    CommonHelper:HButtonSetCallback("BtnHelp",self.gameObject,function (hbtn)
        CommonHelper:ShowHelpView(PageDetailType.RaceTrot)
    end)

    self.BtnRefresh= CommonHelper:HButtonSetCallback("BtnRefresh",self.gameObject,function (hbtn)
        local value= CommonHelper:GetDictCalcData(CommonCfgKey.RaceTrotRefreshTrackCount,false)
        if value-RaceTrotManager:Get():GetFreshTrack()>0 then
            local boxFunc = function()
                local value= CommonHelper:GetDictCalcData(CommonCfgKey.RaceTrotRefreshTrackCost,false)
                ---@type article_config_cell
                local cell= CommonHelper:GetTableDataByID(ConfigNames.article_config,CurrencyType.Diamond)
                value=string.format("%d%s",value,CommonHelper:GetTempStr_Default(cell.name))
                local tips=CommonHelper:GetTempStr_Default(TemplateStringID.RefreshTrackTips,value)
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, tips, CommonHelper:GetTempStr_Default(TemplateStringID.RefreshTrackTittle), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), true)
                if ret == MessageBoxHelp.BtnType.OK then
                    RaceTrotSubsystem:Get():SendMsg_RefreshTrack()
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxFunc)

        else
           CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RefreshTrackCountNo))
        end
    end)

    CommonHelper:HButtonSetCallback("BtnEnter",self.gameObject,function (hbtn)
       -- CommonHelper:CheckMini4wdRule(UIModuleID.RaceTrotSelectTrack,function()
            RaceTrotSubsystem:Get():SendMsg_SelectTrack(self.SelectIdx-1)
        --end)
    end)

    self.TogState = {}
    for i = 1, 2 do
        self.TogState[i] = CommonHelper:HButtonSetCallback("TogTrack"..i,self.gameObject,function (hbtn)
            self:OnClickTog(hbtn.intData,true)
        end, i)
    end
end
function RaceTrotSelectTrackView:StopTime()
    self.TimeCount=0
    if self.Time then
        TimerManager:Get():StopTimer(self.Time)
    end
    self.Time=nil
    CommonHelper:SetHButtonClick(self.BtnRefresh,true)
    CommonHelper:SetText("###text",self.BtnRefresh.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.Refresh))
end
function RaceTrotSelectTrackView:StartTime()
    CommonHelper:SetHButtonClick(self.BtnRefresh,false)
    self.TimeCount=3
    CommonHelper:SetText("###text",self.BtnRefresh.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotObservation_Refresh,self.TimeCount))
    self.Time=TimerManager:Get():CreateTimerLoop(1,function(class)
        class.TimeCount=class.TimeCount-1
        if class.TimeCount<=0 then
            class:StopTime()
        else
            CommonHelper:SetText("###text",class.BtnRefresh.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotObservation_Refresh,class.TimeCount))
        end
    end,self)
end

function RaceTrotSelectTrackView:OnOpen()
    ForbiddenDataManager:Get():SetData()
    CommonHelper:SetGameObjectActive("BtnForbidden",self.gameObject,ForbiddenDataManager:Get():IsForbidden())
    --CommonHelper:IsOpenMini4wdRuleView(UIModuleID.RaceTrotSelectTrack)
    HomeSceneHelper:SetTrackReview()
    UINotify:Get():SendNotification(UINotifyEvent.RankTrotSelectTrack_SetData,false)
end
function RaceTrotSelectTrackView:ReOpen()
    HomeSceneHelper:SetTrackReview()
    UINotify:Get():SendNotification(UINotifyEvent.RankTrotSelectTrack_SetData,false)
end

function RaceTrotSelectTrackView:OnOpenAnimEnd()
    self:AutoSelect()
end

function RaceTrotSelectTrackView:OnClose()
  self:Clear()
end
function RaceTrotSelectTrackView:Clear()
    ForbiddenDataManager:Get():Clear()
    SelfDefineTrack:Clear()
    self:StopTime()
    CommonHelper:ReleasePool(UIModuleID.RaceTrotSelectTrack)
end

function RaceTrotSelectTrackView:OnAutoClose()
    SelfDefineTrack:Clear()
    self:StopTime()
end

---@param msgdata RaceWeekData
function RaceTrotSelectTrackView:SetData(isRefreshTrack)
    self.Data=RaceTrotManager:Get():GetStandByTrackList()
    self:SetView()
    self:RefreshTrack()
    if isRefreshTrack then
        self:OnClickTog(self.SelectIdx,false)
    end
end

function RaceTrotSelectTrackView:SetView()
    local value= CommonHelper:GetDictCalcData(CommonCfgKey.RaceTrotRefreshTrackCount,false)
    if value-RaceTrotManager:Get():GetFreshTrack()<=0 then
        CommonHelper:SetText("###text",self.BtnRefresh.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RefreshTrackTittle))
    else
        CommonHelper:SetText("###text",self.BtnRefresh.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RefreshTrackCount,value-RaceTrotManager:Get():GetFreshTrack()))
    end
    CommonHelper:SetTrotGroupByData("Page_RaceTrotInfo", self.gameObject, RaceTrotManager:Get().RaceTrot)
    CommonHelper:SetGameObjectActive("rankicon_s_4", self.gameObject, RaceTrotManager:Get().RaceTrot.UpMatch==-1)
    CommonHelper:SetText("###score",self.gameObject,RaceTrotManager:Get():GetCurScore())
    CommonHelper:SetText("###boxscore",self.gameObject,string.format("%d/%d",RaceTrotManager:Get():GetBoxScore(),RaceTrotManager:Get():GetMaxBoxScore()))
    CommonHelper:SetText("###battlecount",self.gameObject,tostring(RaceTrotManager:Get():GetActSum()))
    CommonHelper:SetText("###succcount",self.gameObject,tostring(RaceTrotManager:Get():GetWinSum()))
end

---@param msgdata RaceWeekData
function RaceTrotSelectTrackView:RefreshTrack()
    for i = 1, #self.TogState do
        CommonHelper:GetComponentSetTrackIconByData("trackicon",self.TogState[i].gameObject,self.Data[i],UIModuleID.RaceTrotSelectTrack)
        CommonHelper:SetText("###trackvalue"..i,self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceTrotTrackPassNum,RaceTrotManager:Get():GetTrackWinPercentByIdx(i)))
    end
end

function RaceTrotSelectTrackView:SetRank()

end



function RaceTrotSelectTrackView:AutoSelect()
    RaceTrotManager:Get():SetSelectTrack(self.Data[1])
    self:OnClickTog(1,false)
end

function RaceTrotSelectTrackView:OnClickTog(idx,isCheck)
    if isCheck and idx==self.SelectIdx then return  end
    self.SelectIdx=idx
    RaceTrotManager:Get():SetSelectTrack(self.Data[self.SelectIdx])
    for i = 1, #self.TogState do
        CommonHelper:SetToggleState(self.TogState[i], self.Data[i]:GetId() == RaceTrotManager:Get():GetSelectTrack():GetId(), true)
    end
    self:ChangeTrack(self.Data[idx])
end

function RaceTrotSelectTrackView:ChangeTrack(raceTrackData)
    SelfDefineTrack:Clear()
    CommonHelper:PlayScreenEffectUIMask(0.5)
    cs_coroutine.start(function()
        coroutine.yield()
        CommonHelper:LoadRaceTrack(raceTrackData)
    end)
end
