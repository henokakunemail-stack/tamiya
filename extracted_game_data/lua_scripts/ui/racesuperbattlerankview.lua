---@class RaceSuperBattleRankView : ViewBase
RaceSuperBattleRankView = class("RaceSuperBattleRankView", ViewBase)
function RaceSuperBattleRankView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceSuperBattleRankViewAction")
end

function RaceSuperBattleRankView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnReward",self.gameObject,function (hbtn)
        CommonHelper:ShowRankingListReward(RankingRewardType.RaceSuperBattle,true,false)
    end)
    self.TogRank1= CommonHelper:HButtonSetCallback("TogRank1",self.gameObject,function (hbtn)
        self:TogClick(RankingListType.RaceSuperBattlePoint)
    end)
    self.TogRank2=CommonHelper:HButtonSetCallback("TogRank2",self.gameObject,function (hbtn)
        self:TogClick(RankingListType.RaceSuperBattlePlayerOffPoint)
    end)
    self.Self=self:GetChild("self")
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
end

function RaceSuperBattleRankView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceSuperBattleRank)
end
function RaceSuperBattleRankView:TogClick(type)
    if type==self.CurRankType then
        return
    end
    if type==RankingListType.RaceSuperBattlePoint then
        RaceSuperBattleSubsystem:Get():SendMsg_RaceSuperBattleRank()
    elseif type==RankingListType.RaceSuperBattlePlayerOffPoint then
        RaceSuperBattleSubsystem:Get():SendMsg_RaceSuperBattlePlayerOffRank()
    else

    end

end
function RaceSuperBattleRankView:OnOpen()

end

function RaceSuperBattleRankView:SetData()

    self.RankingData=RankingListDataManager:Get():GetRankingListData()
    self.CurRankType= self.RankingData.type
    self:SetTog()
    if self.Page_RankListView==nil then
        self.Page_RankListView=Page_RankListScrollView()
    end
    self.Page_RankListView:SetData(self.ScrollView,self.Self,self.RankingData,UIModuleID.RaceSuperBattleRank,nil,function(id)
        if RaceSuperBattleManager:Get():IsReachResult(RaceSuperBattleManager:Get():GetData():GetRaceState()) then
            RaceSuperBattleSubsystem:Get():SendMsg_RaceResult(id,RaceSuperBattleManager:Get():GetData():GetMatchRankState())
        else
            local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictkillerstage_config)
            RaceSuperBattleSubsystem:Get():SendMsg_RaceResult(id,cfg.Get_RankingStage(RaceSuperBattleManager:Get():GetData():GetMatchAddDay()-1))
        end

    end,nil,RankingListModuleType.RaceSuperBattleRankView)
end
function RaceSuperBattleRankView:SetTog()
    CommonHelper:SetToggleState(self.TogRank1,self.CurRankType==RankingListType.RaceSuperBattlePoint)
    CommonHelper:SetToggleState(self.TogRank2,self.CurRankType==RankingListType.RaceSuperBattlePlayerOffPoint)
    CommonHelper:SetGameObjectActive("rank1_tittle",self.gameObject,self.CurRankType==RankingListType.RaceSuperBattlePoint )
    CommonHelper:SetGameObjectActive("rank2_tittle",self.gameObject,self.CurRankType==RankingListType.RaceSuperBattlePlayerOffPoint)
    CommonHelper:SetHButtonClick(self.TogRank2,RaceSuperBattleManager:Get():GetData():GetMatchRankState()>=RaceSuperBattleRaceState.KnockoutStage,true)
end