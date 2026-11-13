---@class RankingListView : ViewBase
RankingListView = class("RankingListView", ViewBase)

function RankingListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RankingListViewAction")
end

function RankingListView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    self.BtnReward= CommonHelper:HButtonSetCallback("BtnReward",self.gameObject,function (hbtn)
        if self.CurRankType==RankingListType.Speed then
            CommonHelper:ShowRankingListReward(RankingRewardType.RankSpeed,true,false)
            return
        end
        if self.CurRankType==RankingListType.RlSpeed then
            CommonHelper:ShowRankingListReward(RankingRewardType.RankRlSpeed,true,false)
            return
        end
        if self.CurRankType==RankingListType.Score then
            CommonHelper:ShowRankingListReward(RankingRewardType.RankScore,true,false)
            return
        end
    end)
    self.TogRank1= CommonHelper:HButtonSetCallback("TogRank1",self.gameObject,function (hbtn)
        self:TogClick(RankingListType.Speed)
    end)
    self.TogRank2=CommonHelper:HButtonSetCallback("TogRank2",self.gameObject,function (hbtn)
        self:TogClick(RankingListType.Score)
    end)
    self.TogRank3=CommonHelper:HButtonSetCallback("TogRank3",self.gameObject,function (hbtn)
        self:TogClick(RankingListType.RaceJCP)
    end)
    self.TogRank4=CommonHelper:HButtonSetCallback("TogRank4",self.gameObject,function (hbtn)
        self:TogClick(RankingListType.RlSpeed)
    end)

    self.Self=self:GetChild("self")
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
end

function RankingListView:OnOpen()

end

function RankingListView:OnClose()

end
function RankingListView:TogClick(type)
    if type==self.CurRankType then
        return
    end
    if type==RankingListType.RaceJCP then
        RankingListSubsystem:Get():SendMsg_RankingListInfo(type,0)
    else
        RankingListSubsystem:Get():SendMsg_RankingListInfo(type)
    end

end
function RankingListView:SetData(type)
    self.CurRankType= type
    self:SetTog()
    self.RankingData=RankingListDataManager:Get():GetRankingListData()
    if self.Page_RankListView==nil then
        self.Page_RankListView=Page_RankListScrollView()
    end
    self.Page_RankListView:SetData(self.ScrollView,self.Self,self.RankingData,UIModuleID.RankingList,nil,function(id,time)
        if self.CurRankType==RankingListType.Speed  then
            --CommonSubsystem:SendMsg_RePlayBattle(SerE_RecordType.Rank,id,ReplayFlag.RaceRank)
            CommonSubsystem:SendMsg_RePlayBattle(id,RaceRankManager:Get():GetSessionId(),RaceProtectType.Normal)
            RankListTestVerifyDataManager:Get():SetRaplayData(id,{self.CurRankType,RaceRankManager:Get():GetSessionId()},time,version,PlayerDataManager:Get():GetPlayerServerID())
        end
        if self.CurRankType==RankingListType.RlSpeed then

            --CommonSubsystem:SendMsg_RePlayBattle(SerE_RecordType.Rank,id,ReplayFlag.RaceRank)
            CommonSubsystem:SendMsg_RePlayBattle(id,RaceRankManager:Get():GetSessionId(),RaceProtectType.Protect)
            RankListTestVerifyDataManager:Get():SetRaplayData(id,{self.CurRankType,RaceRankManager:Get():GetSessionId()},time,version,PlayerDataManager:Get():GetPlayerServerID())
        end
    end,nil,RankingListModuleType.RankingListView)
end

function RankingListView:SetTog()
    CommonHelper:SetToggleState(self.TogRank1,self.CurRankType==RankingListType.Speed)
    CommonHelper:SetToggleState(self.TogRank2,self.CurRankType==RankingListType.Score)
    CommonHelper:SetToggleState(self.TogRank3,self.CurRankType==RankingListType.RaceJCP)
    CommonHelper:SetToggleState(self.TogRank4,self.CurRankType==RankingListType.RlSpeed)
    CommonHelper:SetGameObjectActive("rank1_tittle",self.gameObject,self.CurRankType==RankingListType.Speed or self.CurRankType==RankingListType.RlSpeed)
    CommonHelper:SetGameObjectActive("rank2_tittle",self.gameObject,self.CurRankType==RankingListType.Score)
    CommonHelper:SetGameObjectActive("rank5_tittle",self.gameObject,self.CurRankType==RankingListType.RaceJCP)
    local key=string.format("rankinglistgroup_%d",RankingListDataManager:Get():GetRankCurGroup())
    local group= CommonHelper:GetTempStr_Default(key)
    if key==group then
        group=CommonHelper:GetTempStr_Default("rankinglistgroup_150")
    end
    CommonHelper:SetText("###groupnamenormal",self.TogRank3.gameObject,group)
    CommonHelper:SetText("###groupnamehover",self.TogRank3.gameObject,group)
    --CommonHelper:SetHButtonClick(self.BtnReward,self.CurRankType==RankingListType.Speed,true)
end