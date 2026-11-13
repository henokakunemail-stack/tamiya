---@class RaceTopSuperRankingListView : ViewBase
RaceTopSuperRankingListView = class("RaceTopSuperRankingListView", ViewBase)

function RaceTopSuperRankingListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceTopSuperRankingListViewAction")
end

function RaceTopSuperRankingListView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnReward",self.gameObject,function (hbtn)
        if RaceTopSuperManager:Get():GetStates()==RaceTopState.RaceB then
            CommonHelper:ShowRankingListReward(RankingRewardType.RaceTopSuperB,true,false)
        else
            CommonHelper:ShowRankingListReward(RankingRewardType.RaceTopSuper32,true,false)
        end
    end)
    self.Self=self:GetChild("self")
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
end

function RaceTopSuperRankingListView:OnOpen()
   self:SetData()
end

function RaceTopSuperRankingListView:SetData()
    CommonHelper:SetGameObjectActive("RaceB",self.gameObject, RaceTopSuperManager:Get():GetStates()==RaceTopState.RaceB)
    CommonHelper:SetGameObjectActive("Audition",self.gameObject, RaceTopSuperManager:Get():GetStates()~=RaceTopState.RaceB)

    self.RankingData=RankingListDataManager:Get():GetRankingListData()
    if self.Page_RankListView==nil then
        self.Page_RankListView=Page_RankListScrollView()
    end
    self.Page_RankListView:SetData(self.ScrollView,self.Self,self.RankingData,UIModuleID.RaceTopRankList,nil,function(id,time)

        if RaceTopSuperManager:Get():GetStates()==RaceTopState.RaceB then
             RaceTopSuperSubsystem:Get():SendMsg_BeginBattleRaceTopRecord(id,1)
        end
        if RaceTopSuperManager:Get():GetStates()~=RaceTopState.RaceB then
             RaceTopSuperSubsystem:Get():SendMsg_BeginBattleRaceTopRecord(id,0)
        end
        RankListTestVerifyDataManager:Get():SetRaplayData(id,{self.RankingData.type},time,version,PlayerDataManager:Get():GetPlayerServerID())
    end,nil,RankingListModuleType.RaceTopSuperRankingListView)
end

function RaceTopSuperRankingListView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceTopSuperRankList)
end

