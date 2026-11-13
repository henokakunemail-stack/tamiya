---@class PveChapterRankListView : ViewBase
PveChapterRankListView = class("PveChapterRankListView", ViewBase)

function PveChapterRankListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "PveChapterRankListViewAction")
end

function PveChapterRankListView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UIManager:Get():HidePersistentView("PveChapterRankListView")
    end)
    CommonHelper:HButtonSetCallback("BtnCloseMask", self.gameObject, function(data)
        UIManager:Get():HidePersistentView("PveChapterRankListView")
    end)

    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
end

function PveChapterRankListView:OnOpen()
    self:SetData()
end
function PveChapterRankListView:ReOpen()

end
function PveChapterRankListView:SetData()
    self.RankingData=RankingListDataManager:Get():GetRankingListData()
    local levelid=0
    if self.RankingData.type==RankingListType.PveChapter then
        levelid=PVEChapterDataManager:Get():GetCurLevelData().id
    elseif self.RankingData.type==RankingListType.SpecialTraining then
        levelid=SpecialTrainingDataManager:Get():GetSelectCopy().C_ID
    end

    if self.Page_RankListView==nil then
        self.Page_RankListView=Page_RankListScrollView()
    end
    self.Page_RankListView:SetData(self.ScrollView,self.Self,self.RankingData,UIModuleID.PveChapterRankList,nil,function(playerId,speed)
        ChapterSubsystem:SendMsg_GetChapterRank(levelid,playerId,self.RankingData.type)
        RankListTestVerifyDataManager:Get():SetRaplayData(playerId,{self.RankingData.type,levelid},speed,version,PlayerDataManager:Get():GetPlayerServerID())
    end,8,RankingListModuleType.PveChapterRankListView)
end


function PveChapterRankListView:OnOpenAnimEnd()

end
function PveChapterRankListView:OnClose()
   CommonHelper:ReleasePool(UIModuleID.PveChapterRankList)
end
function PveChapterRankListView:OnAutoClose()

end




