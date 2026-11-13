---@class RaceTopRankingListView : ViewBase
RaceTopRankingListView = class("RaceTopRankingListView", ViewBase)

function RaceTopRankingListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceTopRankingListViewAction")
end

function RaceTopRankingListView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnReward",self.gameObject,function (hbtn)
        if RaceTopManager:Get():GetStates()==RaceTopState.RaceB then
            CommonHelper:ShowRankingListReward(RankingRewardType.RaceTopB,true,false)
        else
            CommonHelper:ShowRankingListReward(RankingRewardType.RaceTop32,true,false)
        end
    end)
    self.Self=self:GetChild("self")
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
end

function RaceTopRankingListView:OnOpen()
   self:SetData()
end

function RaceTopRankingListView:SetData()
    CommonHelper:SetGameObjectActive("RaceB",self.gameObject,RaceTopManager:Get():GetStates()==RaceTopState.RaceB)
    CommonHelper:SetGameObjectActive("Audition",self.gameObject,RaceTopManager:Get():GetStates()~=RaceTopState.RaceB)

    self.RankingData=RankingListDataManager:Get():GetRankingListData()
    if self.Page_RankListView==nil then
        self.Page_RankListView=Page_RankListScrollView()
    end
    self.Page_RankListView:SetData(self.ScrollView,self.Self,self.RankingData,UIModuleID.RaceTopRankList,nil,function(id,time)

        if RaceTopManager:Get():GetStates()==RaceTopState.RaceB then
             RaceTopSubsystem:Get():SendMsg_BeginBattleRaceTopRecord(id,1)
        end
        if RaceTopManager:Get():GetStates()~=RaceTopState.RaceB then
             RaceTopSubsystem:Get():SendMsg_BeginBattleRaceTopRecord(id,0)
        end
        RankListTestVerifyDataManager:Get():SetRaplayData(id,{self.RankingData.type},time,version,PlayerDataManager:Get():GetPlayerServerID())
    end,nil,RankingListModuleType.RaceTopRankingListView)
end

function RaceTopRankingListView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceTopRankList)
end

