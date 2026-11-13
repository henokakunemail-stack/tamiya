---@class RaceAssembleRankingListView : ViewBase
RaceAssembleRankingListView = class("RaceAssembleRankingListView", ViewBase)

function RaceAssembleRankingListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceAssembleRankingListViewAction")
end

function RaceAssembleRankingListView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    self.BtnReward= CommonHelper:HButtonSetCallback("BtnReward",self.gameObject,function (hbtn)
        CommonHelper:ShowRankingListReward(RankingRewardType.RaceAssemble,true,false)
    end)
    self.Self=self:GetChild("self")
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
end

function RaceAssembleRankingListView:OnOpen()

end

function RaceAssembleRankingListView:OnClose()

end
function RaceAssembleRankingListView:SetData(data)
    self.CurRankType= data.type
    self.RankingData=data
    if self.Page_RankListView==nil then
        self.Page_RankListView=Page_RankListScrollView()
    end
    self.Page_RankListView:SetData(self.ScrollView,self.Self,self.RankingData,UIModuleID.RaceAssemble,nil,function(id)

    end,nil,RankingListModuleType.RaceAssembleRankingListView)
end