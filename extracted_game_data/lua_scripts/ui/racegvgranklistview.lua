---@class RaceGVGRankListView : ViewBase
RaceGVGRankListView = class("RaceGVGRankListView", ViewBase)

function RaceGVGRankListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceGVGRankListViewAction")
end

function RaceGVGRankListView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    self.BtnReward=CommonHelper:HButtonSetCallback("BtnReward",self.gameObject,function (hbtn)
        if self.RankingData.type==RankingListType.RaceGVGSpeed1 then
            CommonHelper:ShowRankingListReward(RankingRewardType.RaceGVGSpeed1,true,false)
        elseif self.RankingData.type==RankingListType.RaceGVGSpeed2 then
            CommonHelper:ShowRankingListReward(RankingRewardType.RaceGVGSpeed2,true,false)
        elseif self.RankingData.type==RankingListType.RaceGVGSpeed3 then
            CommonHelper:ShowRankingListReward(RankingRewardType.RaceGVGSpeed3,true,false)
        elseif self.RankingData.type==RankingListType.RaceGVGPoint then
            CommonHelper:ShowRankingListReward(RankingRewardType.RaceGVGPoint,true,false)
        end
    end)
    self.TogRank1= CommonHelper:HButtonSetCallback("TogRank1",self.gameObject,function (hbtn)
        self:TogClick(RankingListType.RaceGVGSpeed1)
    end)
    self.TogRank2=CommonHelper:HButtonSetCallback("TogRank2",self.gameObject,function (hbtn)
        self:TogClick(RankingListType.RaceGVGSpeed2)
    end)
    self.TogRank3=CommonHelper:HButtonSetCallback("TogRank3",self.gameObject,function (hbtn)
        self:TogClick(RankingListType.RaceGVGSpeed3)
    end)
    self.TogRank4=CommonHelper:HButtonSetCallback("TogRank4",self.gameObject,function (hbtn)
        self:TogClick(RankingListType.RaceGVGPoint)
    end)
    self.TogRank5=CommonHelper:HButtonSetCallback("TogRank5",self.gameObject,function (hbtn)
        self:TogClick(RankingListType.RaceClubAll)
    end)
    self.Self=self:GetChild("self")
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
end

function RaceGVGRankListView:OnClose()
     CommonHelper:ReleasePool(UIModuleID.RaceGVGRankList)
end
function RaceGVGRankListView:TogClick(type)
    if type==self.CurRankType then
        return
    end
    if type==RankingListType.RaceGVGSpeed1 then
        RaceGVGSubsystem:Get():SendMsg_RankList(0,RaceGVGState.Race1Battle,RaceGVGManager:Get():GetMatchSuccess())
    elseif type==RankingListType.RaceGVGSpeed2 then
        RaceGVGSubsystem:Get():SendMsg_RankList(0,RaceGVGState.Race2Battle,RaceGVGManager:Get():GetMatchSuccess())
    elseif type==RankingListType.RaceGVGSpeed3 then
        RaceGVGSubsystem:Get():SendMsg_RankList(0,RaceGVGState.Race3Battle,RaceGVGManager:Get():GetMatchSuccess())
    elseif type==RankingListType.RaceGVGPoint then
        RaceGVGSubsystem:Get():SendMsg_RankList(1,0,RaceGVGManager:Get():GetMatchSuccess())
    elseif type==RankingListType.RaceClubAll then
        RaceGVGSubsystem:Get():SendMsg_GetClubRankList()
    else

    end

end
function RaceGVGRankListView:OnOpen()

end

function RaceGVGRankListView:SetData()

    self.RankingData=RankingListDataManager:Get():GetRankingListData()
    self.CurRankType= self.RankingData.type
    self:SetTog()
    if self.Page_RankListView==nil then
        self.Page_RankListView=Page_RankListScrollView()
    end
    self.Page_RankListView:SetData(self.ScrollView,self.Self,self.RankingData,UIModuleID.RankingList,nil,function(id)

    end,nil,RankingListModuleType.RaceGVGRankListView)
end
function RaceGVGRankListView:SetTog()
    CommonHelper:SetToggleState(self.TogRank1,self.CurRankType==RankingListType.RaceGVGSpeed1)
    CommonHelper:SetToggleState(self.TogRank2,self.CurRankType==RankingListType.RaceGVGSpeed2)
    CommonHelper:SetToggleState(self.TogRank3,self.CurRankType==RankingListType.RaceGVGSpeed3)
    CommonHelper:SetToggleState(self.TogRank4,self.CurRankType==RankingListType.RaceGVGPoint)
    CommonHelper:SetToggleState(self.TogRank5,self.CurRankType==RankingListType.RaceClubAll)
    CommonHelper:SetHButtonClick(self.BtnReward,self.CurRankType~=RankingListType.RaceClubAll,true)
    CommonHelper:SetGameObjectActive("rank1_tittle",self.gameObject,self.CurRankType==RankingListType.RaceGVGSpeed1 or self.CurRankType==RankingListType.RaceGVGSpeed2 or self.CurRankType==RankingListType.RaceGVGSpeed3)
    CommonHelper:SetGameObjectActive("rank2_tittle",self.gameObject,self.CurRankType==RankingListType.RaceGVGPoint )
    CommonHelper:SetGameObjectActive("rank3_tittle",self.gameObject,self.CurRankType==RankingListType.RaceClubAll)
    CommonHelper:SetGameObjectActive("self",self.gameObject,self.CurRankType~=RankingListType.RaceClubAll)

end