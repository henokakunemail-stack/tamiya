---@class RaceTrotRankListView : ViewBase
RaceTrotRankListView = class("RaceTrotRankListView", ViewBase)

function RaceTrotRankListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceTrotRankListViewAction")
end

function RaceTrotRankListView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    self.BtnReward= CommonHelper:HButtonSetCallback("BtnReward",self.gameObject,function (hbtn)
        CommonHelper:ShowRankingListReward(RankingRewardType.RaceTrot,true,false)
    end)
    self.Self=self:GetChild("self")
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
end

function RaceTrotRankListView:OnOpen()

end
function RaceTrotRankListView:ReOpen()

end
function RaceTrotRankListView:SetData(data)
    self.RankingData=data
    if self.Page_RankListView==nil then
        self.Page_RankListView=Page_RankListScrollView()
    end
    self.Page_RankListView:SetData(self.ScrollView,self.Self,self.RankingData,UIModuleID.RaceTrotRankList,nil,function(id)

    end,nil,RankingListModuleType.RaceTrotRankListView)
end


function RaceTrotRankListView:OnOpenAnimEnd()

end
function RaceTrotRankListView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceTopRankList)
end
function RaceTrotRankListView:OnAutoClose()

end




