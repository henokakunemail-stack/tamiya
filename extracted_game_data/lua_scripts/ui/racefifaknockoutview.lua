---@class RaceFifaKnockoutView : ViewBase
RaceFifaKnockoutView = class("RaceFifaKnockoutView", ViewBase)

function RaceFifaKnockoutView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceFifaKnockoutViewAction")
end

function RaceFifaKnockoutView:Awake()
    CommonHelper:HButtonSetCallback("BtnHome",self.gameObject,function (hbtn)
        SkipModuleHelper:Get():BackToMainMenuView(_CurShow~=page_init)
    end)
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnGuess",self.gameObject,function (hbtn)
        UIManager:Get():OpenPopup("RaceFifaTeamListView",CanvasType.FrontCanvas,"RaceFifaTeamListView")
        UINotify:Get():SendNotification(UINotifyEvent.RaceFifaTeamListView_SetDataCountry)
    end)
    CommonHelper:HButtonSetCallback("BtnGetReward",self.gameObject,function (hbtn)
        RaceFifaSubsystem:Get():SendMsg_GetReward(RaceFifaDataManager:Get():Get_RaceFifaSeasonId(),-1)
    end)
end
function RaceFifaKnockoutView:OnOpen()
  self:SetData()
end
function RaceFifaKnockoutView:ReOpen()

end
function RaceFifaKnockoutView:OnClose()

end
function RaceFifaKnockoutView:OnAutoClose()

end
function RaceFifaKnockoutView:OnOpenAnimEnd()

end
function RaceFifaKnockoutView:GuessSuccess(flag)
    if not flag then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaGuessSuccess))
    end
    self:SetData()
end

function RaceFifaKnockoutView:SetData()
   local KnockoutData=RaceFifaDataManager:Get():GetRaceData(RaceFifaRaceState.RaceKnockout)
    self:SetView()
    local Count=self.SeasonCfg.outcount
    local Line15=CommonHelper:SetGameObjectActive("lines15",self.gameObject,Count==15)
    local flags15=CommonHelper:SetGameObjectActive("flags15",self.gameObject,Count==15)
    local Line7=CommonHelper:SetGameObjectActive("lines7",self.gameObject,Count==7)
    local flags7=CommonHelper:SetGameObjectActive("flags7",self.gameObject,Count==7)
    local Parent=flags15
    if Count==7 then
        Parent=flags7
    end
    for i = 1, Count do
        local item1=UIUtil.GetChild("RaceFifaKnockoutItem"..(i*2-1),Parent)
        local item2=UIUtil.GetChild("RaceFifaKnockoutItem"..(i*2),Parent)
        if KnockoutData[i]==nil then
            CommonHelper:SetText("###name",item1,CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaGroupNone))
            CommonHelper:SetGameObjectActive("flag",item1,false)
            CommonHelper:SetGameObjectActive("default",item1,true)
            CommonHelper:SetText("###name",item2,CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaGroupNone))
            CommonHelper:SetGameObjectActive("flag",item2,false)
            CommonHelper:SetGameObjectActive("default",item2,true)
        else
            local countryA=KnockoutData[i].TeamA
            local countryB=KnockoutData[i].TeamB
            if countryA==nil or countryA==0 then
                CommonHelper:SetText("###name",item1,CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaGroupNone))
                CommonHelper:SetGameObjectActive("flag",item1,false)
                CommonHelper:SetGameObjectActive("default",item1,true)
            else
                CommonHelper:SetGameObjectActive("flag",item1,true)
                CommonHelper:SetGameObjectActive("default",item1,false)
                local cfg=CommonHelper:GetTableDataByID(ConfigNames.dictuefacountry_config,countryA)
                CommonHelper:SetText("###name",item1,CommonHelper:GetTempStr_Default(cfg.name))
                CommonHelper:GetComponentSetUITexture("flag",item1,string.format("%s.png",cfg.icon),UIModuleID.RaceFifaKnockout)

            end
            if countryB==nil or countryB==0 then
                CommonHelper:SetText("###name",item2,CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaGroupNone))
                CommonHelper:SetGameObjectActive("flag",item2,false)
                CommonHelper:SetGameObjectActive("default",item2,true)
            else
                CommonHelper:SetGameObjectActive("flag",item2,true)
                CommonHelper:SetGameObjectActive("default",item2,false)
                local cfg=CommonHelper:GetTableDataByID(ConfigNames.dictuefacountry_config,countryB)
                CommonHelper:SetText("###name",item2,CommonHelper:GetTempStr_Default(cfg.name))
                CommonHelper:GetComponentSetUITexture("flag",item2,string.format("%s.png",cfg.icon),UIModuleID.RaceFifaKnockout)
            end
        end
    end
    local serverTime=CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    local championId=0
    if KnockoutData[Count]==nil then
        CommonHelper:SetGameObjectActive("champion/championnamebg",self.gameObject,false)
        CommonHelper:SetGameObjectActive("champion/championflagbg/flag",self.gameObject,false)
        CommonHelper:SetGameObjectActive("champion/championflagbg/default",self.gameObject,true)
        CommonHelper:SetText("champion/championresultbg/###result",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaGroupNone))
    else
        if KnockoutData[Count].Result==RaceFifaBattleResult.None then
            CommonHelper:SetGameObjectActive("champion/championnamebg",self.gameObject,false)
            CommonHelper:SetGameObjectActive("champion/championflagbg/flag",self.gameObject,false)
            CommonHelper:SetGameObjectActive("champion/championflagbg/default",self.gameObject,true)
            CommonHelper:SetText("champion/championresultbg/###result",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaGroupNone))
        else
            CommonHelper:SetGameObjectActive("champion/championnamebg",self.gameObject,true)
            CommonHelper:SetGameObjectActive("champion/championflagbg/flag",self.gameObject,true)
            CommonHelper:SetGameObjectActive("champion/championflagbg/default",self.gameObject,false)
            CommonHelper:SetText("champion/championresultbg/###result",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaScore,KnockoutData[Count].TeamABallCount,KnockoutData[Count].TeamBBallCount))
            local id=KnockoutData[Count].TeamA
            if KnockoutData[Count].Result==RaceFifaBattleResult.Lose then
                id=KnockoutData[Count].TeamB
            end
            championId=id
            local cfg=CommonHelper:GetTableDataByID(ConfigNames.dictuefacountry_config,id)
            CommonHelper:SetText("champion/championnamebg/###championname",self.gameObject,CommonHelper:GetTempStr_Default(cfg.name))
            CommonHelper:GetComponentSetUITexture("champion/championflagbg/flag",self.gameObject,string.format("%s.png",cfg.icon),UIModuleID.RaceFifaKnockout)
        end
    end
    local _Data=RaceFifaDataManager:Get():Get_RaceFifaData()
    CommonHelper:SetGameObjectActive("BtnGetReward",self.gameObject,championId~=0 and _Data.ChampionId~=0 and  _Data.ChampionGetReward==0)--比赛完成竞猜成功未领取奖励
    CommonHelper:SetGameObjectActive("raceresult1",self.gameObject,championId~=0 and _Data.ChampionId~=0 and  _Data.ChampionGetReward~=0)--比赛完成竞猜成功已领取奖励
    CommonHelper:SetGameObjectActive("raceresult2",self.gameObject,false)--比赛完成竞猜失败
    CommonHelper:SetGameObjectActive("raceresult3",self.gameObject,championId~=0 and _Data.ChampionId==0)--比赛完成未竞猜
    CommonHelper:SetGameObjectActive("BtnGuess",self.gameObject,championId==0 and serverTime<_Data.ChampionTime and _Data.ChampionId==0)
    CommonHelper:SetGameObjectActive("raceresult4",self.gameObject,championId==0 and serverTime>=_Data.ChampionTime and _Data.ChampionId==0 )
    CommonHelper:SetGameObjectActive("###raceresult5",self.gameObject,championId==0 and serverTime<_Data.ChampionTime and _Data.ChampionId~=0)
    if championId==0 and serverTime<_Data.ChampionTime and _Data.ChampionId~=0 then
        local cfg=CommonHelper:GetTableDataByID(ConfigNames.dictuefacountry_config, _Data.ChampionId)
        if cfg then
            CommonHelper:SetText("###raceresult5",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaGuessChampion,CommonHelper:GetTempStr_Default(cfg.name)))
        end
    end
    local _BeginTime=CommonHelper:ConvertIntToDataTime(_Data.BeginTime*1000)
    local _EndTime=CommonHelper:ConvertIntToDataTime(_Data.EndTime*1000)
    CommonHelper:SetText("###racetime",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceFifaTimeFormat,_BeginTime.Year,_BeginTime.Month,_BeginTime.Day,_EndTime.Year,_EndTime.Month,_EndTime.Day))
    self:SetCost()
end
function RaceFifaKnockoutView:SetCost()
    local CostId=RaceFifaDataManager:Get():Get_RaceFifaData().PayId
    CommonHelper:SetText("###GuessodCostCount",self.gameObject,KnapsackDataManager:Get():GetArticleCountByCfgid(CostId))
    local cell = CommonHelper:GetTableDataByID(ConfigNames.article_config, CostId)
    CommonHelper:GetComponentSetUITexture("GuessodCostIcon",self.gameObject,cell.NewIcon,UIModuleID.RaceFifaKnockout)
end
function RaceFifaKnockoutView:SetView()
    self.SeasonCfg=RaceFifaDataManager:Get()._RaceFifaData.Cfg
    CommonHelper:GetComponentSetUITexture("background", self.gameObject, self.SeasonCfg.bg, UIModuleID.RaceFifaKnockout)
    CommonHelper:GetComponentSetImage("logo1", self.gameObject, self.SeasonCfg.logbg1, UIModuleID.RaceFifaKnockout)
    CommonHelper:GetComponentSetImage("logo2", self.gameObject, self.SeasonCfg.logbg2, UIModuleID.RaceFifaKnockout)
    CommonHelper:GetComponentSetUITexture("racebg", self.gameObject, self.SeasonCfg.racebg, UIModuleID.RaceFifaKnockout)
    CommonHelper:SetText("###racename",self.gameObject,CommonHelper:GetTempStr_Default(self.SeasonCfg.raceknockoutname))
end
