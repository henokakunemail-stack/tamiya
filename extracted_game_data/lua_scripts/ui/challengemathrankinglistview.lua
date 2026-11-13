---@class ChallengeMathRankingListView : ViewBase
ChallengeMathRankingListView = class("ChallengeMathRankingListView", ViewBase)

function ChallengeMathRankingListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ChallengeMathRankingListViewAction")
end

function ChallengeMathRankingListView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    self.BtnReward= CommonHelper:HButtonSetCallback("BtnReward",self.gameObject,function (hbtn)
        CommonHelper:ShowRankingListReward(RankingRewardType.RaceSelfLevel,true,false)
    end)
    self.Self=self:GetChild("self")
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
end

function ChallengeMathRankingListView:OnOpen()

end

function ChallengeMathRankingListView:OnClose()

end
function ChallengeMathRankingListView:SetData(data)
    self.CurRankType= data.type
    self.RankingData=data
    if self.Page_RankListView==nil then
        self.Page_RankListView=Page_RankListScrollView()
    end
    self.Page_RankListView:SetData(self.ScrollView,self.Self,self.RankingData,UIModuleID.ChallengeMatch,nil,function(id)

    end,nil,RankingListModuleType.ChallengeMathRankingListView)
end