---@class RaceFifaGuessView : ViewBase
RaceFifaGuessView = class("RaceFifaGuessView", ViewBase)

function RaceFifaGuessView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceFifaGuessViewAction")
end

function RaceFifaGuessView:Awake()
    CommonHelper:HButtonSetCallback("BtnHome",self.gameObject,function (hbtn)
        SkipModuleHelper:Get():BackToMainMenuView()
    end)
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnKnockout",self.gameObject,function (hbtn)
        UIManager:Get():OpenView("RaceFifaKnockoutView",CanvasType.MainCanvas,"RaceFifaKnockoutView")
    end)
  CommonHelper:HButtonSetCallback("BtnHelper",self.gameObject,function (hbtn)
      CommonHelper:ShowHelpView(self.SeasonCfg.HelperId)
    end)

    self.ScrollView=self:GetChildWight("MoreRowScrollView_H",typeof(MoreRowScrollView))
    self.Group3=self:GetChild("Group3")
    self.Group2=self:GetChild("Group2")
    self.Group1=self:GetChild("Group1")
end
function RaceFifaGuessView:OnOpen()

end
function RaceFifaGuessView:ReOpen()

end
function RaceFifaGuessView:OnClose()

end
function RaceFifaGuessView:OnAutoClose()

end
function RaceFifaGuessView:SetView()
    self.SeasonCfg=RaceFifaDataManager:Get()._RaceFifaData.Cfg
    CommonHelper:GetComponentSetUITexture("background", self.gameObject, self.SeasonCfg.bg, UIModuleID.RaceFifaKnockout)
    CommonHelper:GetComponentSetImage("logo1", self.gameObject, self.SeasonCfg.logbg1, UIModuleID.RaceFifaKnockout)
    CommonHelper:GetComponentSetImage("logo2", self.gameObject, self.SeasonCfg.logbg2, UIModuleID.RaceFifaKnockout)
    CommonHelper:SetText("###racename",self.gameObject,CommonHelper:GetTempStr_Default(self.SeasonCfg.raceguesstittlename))
end

function RaceFifaGuessView:OnOpenAnimEnd()

end
local _SelectItem=nil
local _Data=nil
function RaceFifaGuessView:SetData(data)
    ---@type RaceFifaVenueData[]
    _Data=data
    self:SetView()
    local serverTime= CommonHelper:GetNowTime()
    local index=0
    local serverday=serverTime.Month*100+serverTime.Day
    local DataIndex={}
    for i = 1, #_Data do
        local raceTime=CommonHelper:ConvertIntToDataTime(_Data[i].BettingEndTime*1000)
        local raceDay=raceTime.Month*100+raceTime.Day
        if DataIndex[raceDay]==nil then
            DataIndex[raceDay]=i-1
        end
    end
    for k, v in pairs(DataIndex) do
        if serverday==k then
            index=v
            break
        end
        if serverday>k then
            index=v
        end
    end
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #_Data, 1,function(dataIndex, itemObj, scroll)
        ---@type RaceFifaVenueData
        local temp=_Data[dataIndex+1]
        CommonHelper:GetComponentSetUITexture("Normal",itemObj,self.SeasonCfg.itembg,UIModuleID.RaceFifaKnockout)
        if temp.TeamA~=0 and temp.TeamB~=0 then
            local cfgA=CommonHelper:GetTableDataByID(ConfigNames.dictuefacountry_config,temp.TeamA)
            local cfgB=CommonHelper:GetTableDataByID(ConfigNames.dictuefacountry_config,temp.TeamB)
            CommonHelper:SetText("Normal/###name1",itemObj,CommonHelper:GetTempStr_Default(cfgA.name))
            CommonHelper:GetComponentSetUITexture("Normal/flag1",itemObj,string.format("%s.png",cfgA.icon),UIModuleID.RaceFifaKnockout)
            CommonHelper:SetText("Normal/###name2",itemObj,CommonHelper:GetTempStr_Default(cfgB.name))
            CommonHelper:GetComponentSetUITexture("Normal/flag2",itemObj,string.format("%s.png",cfgB.icon),UIModuleID.RaceFifaKnockout)
            CommonHelper:SetText("Guess/###name1",itemObj,CommonHelper:GetTempStr_Default(cfgA.name))
            CommonHelper:GetComponentSetUITexture("Guess/flag1",itemObj,string.format("%s.png",cfgA.icon),UIModuleID.RaceFifaKnockout)
            CommonHelper:SetText("Guess/###name2",itemObj,CommonHelper:GetTempStr_Default(cfgB.name))
            CommonHelper:GetComponentSetUITexture("Guess/flag2",itemObj,string.format("%s.png",cfgB.icon),UIModuleID.RaceFifaKnockout)
            CommonHelper:SetText("Guess/###name2",itemObj,CommonHelper:GetTempStr_Default(cfgB.name))
            CommonHelper:SetText("###Normaloddsvalue1",itemObj,temp.TeamAOdds)
            CommonHelper:SetText("###Normaloddsvalue2",itemObj,temp.TeamFlatOdds)
            CommonHelper:SetText("###Normaloddsvalue3",itemObj,temp.TeamBOdds)
            CommonHelper:SetText("###Guessoddsvalue1",itemObj,temp.TeamAOdds)
            CommonHelper:SetText("###Guessoddsvalue2",itemObj,temp.TeamFlatOdds)
            CommonHelper:SetText("###Guessoddsvalue3",itemObj,temp.TeamBOdds)
            CommonHelper:SetText("###valuecost1",itemObj,temp.TeamBOdds)
            CommonHelper:SetText("###valuecost2",itemObj,temp.TeamBOdds)
            CommonHelper:SetText("###valuecost3",itemObj,temp.TeamBOdds)
            if temp.Result==RaceFifaBattleResult.None then
                CommonHelper:SetText("###result",itemObj,CommonHelper:GetTempStr_Default(temp.RaceCfg.timeDes))
            else
                if temp.Result==RaceFifaBattleResult.Win then
                    CommonHelper:SetText("###result",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaCountryWin,temp.TeamABallCount,temp.TeamBBallCount,CommonHelper:GetTempStr_Default(cfgA.name)))
                elseif temp.Result==RaceFifaBattleResult.Flat then
                    CommonHelper:SetText("###result",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaCountryFlat,temp.TeamABallCount,temp.TeamBBallCount))
                elseif temp.Result==RaceFifaBattleResult.Lose then
                    CommonHelper:SetText("###result",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaCountryLose,temp.TeamABallCount,temp.TeamBBallCount,CommonHelper:GetTempStr_Default(cfgA.name)))
                end
            end
            local _EndTime=CommonHelper:ConvertIntToDataTime(temp.BettingEndTime*1000)
            CommonHelper:SetText("###bettingendtime",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaBettingEndTimeFormat,_EndTime.Year,_EndTime.Month,_EndTime.Day,_EndTime.Hour,_EndTime.Minute))
            CommonHelper:SetGameObjectActive("Imageresult2",itemObj,temp.RaceCfg.tpye==RaceFifaRaceState.RaceGroup)
            CommonHelper:SetGameObjectActive("Normal/GameObject/result2num",itemObj,temp.RaceCfg.tpye==RaceFifaRaceState.RaceGroup)
            CommonHelper:SetGameObjectActive("Guess/GameObject/result2num",itemObj,temp.RaceCfg.tpye==RaceFifaRaceState.RaceGroup)
            CommonHelper:SetGameObjectActive("BtnGetReward",itemObj,temp.Result~=RaceFifaBattleResult.None and temp.GuessTeam~=RaceFifaBattleResult.None and  temp.GetReward==0)--比赛完成竞猜成功未领取奖励
            CommonHelper:SetGameObjectActive("raceresult1",itemObj,temp.Result~=RaceFifaBattleResult.None and temp.GuessTeam~=RaceFifaBattleResult.None and  temp.GetReward~=0)--比赛完成竞猜成功已领取奖励
            CommonHelper:SetGameObjectActive("raceresult2",itemObj,false)--比赛完成竞猜失败
            CommonHelper:SetGameObjectActive("raceresult3",itemObj,temp.Result~=RaceFifaBattleResult.None and temp.GuessTeam==RaceFifaBattleResult.None)--比赛完成未竞猜
            local serverTime=CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
            CommonHelper:SetGameObjectActive("BtnGuess",itemObj,temp.Result==RaceFifaBattleResult.None and serverTime<temp.BettingEndTime and temp.GuessTeam==0)
            CommonHelper:SetGameObjectActive("raceresult4",itemObj,temp.Result==RaceFifaBattleResult.None and serverTime>=temp.BettingEndTime and temp.GuessTeam==0 )
            CommonHelper:SetGameObjectActive("###raceresult5",itemObj,temp.Result==RaceFifaBattleResult.None  and temp.GuessTeam~=0)
            if temp.Result==RaceFifaBattleResult.None  and temp.GuessTeam~=0 then
                if temp.GuessTeam==RaceFifaBattleResult.Win then
                    CommonHelper:SetText("###raceresult5",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaGuessDoneWin,CommonHelper:GetTempStr_Default(cfgA.name)))
                elseif temp.GuessTeam==RaceFifaBattleResult.Flat then
                    CommonHelper:SetText("###raceresult5",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaGuessDoneFlat,CommonHelper:GetTempStr_Default(cfgA.name)))
                elseif temp.GuessTeam==RaceFifaBattleResult.Lose then
                    CommonHelper:SetText("###raceresult5",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaGuessDoneLose,CommonHelper:GetTempStr_Default(cfgA.name)))
                end
            end
            CommonHelper:TweenGroupUILeft("tweenNormal", itemObj, true)
            CommonHelper:TweenGroupUILeft("tweenGuess", itemObj, false)
            CommonHelper:HButtonSetCallback("BtnGuess",itemObj,function (hbtn)
                CommonHelper:TweenGroupUILeft("tweenNormal", itemObj, false)
                CommonHelper:TweenGroupUILeft("tweenGuess", itemObj, true)
            end)
            CommonHelper:HButtonSetCallback("BtnResult1",itemObj,function (hbtn)
                _SelectItem=itemObj
                UIManager:Get():OpenPopup("RaceFifaTeamListView",CanvasType.FrontCanvas,"RaceFifaTeamListView")
                UINotify:Get():SendNotification(UINotifyEvent.RaceFifaTeamListView_SetDataGuess,{_Data[hbtn.intData],RaceFifaBattleResult.Win})
            end,dataIndex+1)
            CommonHelper:HButtonSetCallback("BtnResult2",itemObj,function (hbtn)
                UIManager:Get():OpenPopup("RaceFifaTeamListView",CanvasType.FrontCanvas,"RaceFifaTeamListView")
                UINotify:Get():SendNotification(UINotifyEvent.RaceFifaTeamListView_SetDataGuess,{_Data[hbtn.intData],RaceFifaBattleResult.Flat})
                _SelectItem=itemObj
            end,dataIndex+1)
            CommonHelper:HButtonSetCallback("BtnResult3",itemObj,function (hbtn)
                UIManager:Get():OpenPopup("RaceFifaTeamListView",CanvasType.FrontCanvas,"RaceFifaTeamListView")
                UINotify:Get():SendNotification(UINotifyEvent.RaceFifaTeamListView_SetDataGuess,{_Data[hbtn.intData],RaceFifaBattleResult.Lose})
                _SelectItem=itemObj
            end,dataIndex+1)
            CommonHelper:HButtonSetCallback("BtnGetReward",itemObj,function (hbtn)
                RaceFifaSubsystem:Get():SendMsg_GetReward(RaceFifaDataManager:Get():Get_RaceFifaSeasonId(),hbtn.intData,false)
            end,temp.Id)
        else

        end
    end)
    CommonHelper:MoreRowView_ScrollToItem(self.ScrollView,index)
    self:SetCost()
end
function RaceFifaGuessView:GuessSuccess(data,flag)
    if not flag then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaGuessSuccess))
    end
    CommonHelper:TweenGroupUILeft("tweenNormal", _SelectItem, true)
    CommonHelper:TweenGroupUILeft("tweenGuess", _SelectItem, false)
    _Data=data
    self:SetCost()
    CommonHelper:MoreRowView_RefreshCurList(self.ScrollView,false)
end
function RaceFifaGuessView:SetCost()
    local CostId=RaceFifaDataManager:Get():Get_RaceFifaData().PayId
    CommonHelper:SetText("###GuessodCostCount",self.gameObject,KnapsackDataManager:Get():GetArticleCountByCfgid(CostId))
    local cell = CommonHelper:GetTableDataByID(ConfigNames.article_config, CostId)
    CommonHelper:GetComponentSetUITexture("GuessodCostIcon",self.gameObject,cell.NewIcon,UIModuleID.RaceFifaKnockout)
end
