---@class Page_SelectCarBase
Page_SelectCarBase=class("Page_SelectCarBase")
function Page_SelectCarBase:initialize()

end
function Page_SelectCarBase:SetPage(battletype,param,page_selectCar)
    local root=nil
    local page=nil
    if battletype == RaceModel.Battle then
        root=self.Pre_PVEChapter
        page=self.Page_PveChapter
    end
   if battletype == RaceModel.RaceSeniorTrain then
        root=self.Pre_RaceSeniorTrain
        page=self.Page_RaceSeniorTrain
    end
    if battletype == RaceModel.RaceRoom then

    end

    if battletype == RaceModel.RaceRank then

    end

    if battletype == RaceModel.Challenge then
        root=self.Pre_Challenge
        page=self.Page_Challenge
    end

    if battletype==RaceModel.SelfChallenge then

    end

    if battletype == RaceModel.RaceSelf then

    end

    if battletype == RaceModel.ClubTrain then

    end

    if battletype == RaceModel.RaceWeek then

    end
    if battletype == RaceModel.RaceSelfChapter then
        root=self.Pre_SelfChapter
        page=self.Page_RaceSelfChapter
    end
    if battletype == RaceModel.RaceSelfLevel then
        root=self.Pre_SelfLevel
        page=self.Page_RaceSelfLevel
    end
    if battletype == RaceModel.ClubRaceSelfChapter then
        root=self.Pre_ClubSelfChapter
        page=self.Page_ClubRaceSelfChapter
    end
    if battletype == RaceModel.ClubRaceSelfLevel then
        root=self.Pre_ClubSelfLevel
        page=self.Page_ClubRaceSelfLevel
    end
    self.BattleType=battletype
    page:SetData(root,param,page_selectCar)
    self:UpdatePre(battletype)

end
function Page_SelectCarBase:UpdatePre(type)
    CommonHelper:CSGameObjectSetActive(self.Pre_SelfChapter,type==RaceModel.RaceSelfChapter)
    CommonHelper:CSGameObjectSetActive(self.Pre_SelfLevel,type==RaceModel.RaceSelfLevel)
    CommonHelper:CSGameObjectSetActive(self.Pre_Challenge,type==RaceModel.Challenge)
    CommonHelper:CSGameObjectSetActive(self.Pre_PVEChapter,type==RaceModel.Battle)
    CommonHelper:CSGameObjectSetActive(self.Pre_ClubSelfLevel,type==RaceModel.ClubRaceSelfLevel)
    CommonHelper:CSGameObjectSetActive(self.Pre_ClubSelfChapter,type==RaceModel.ClubRaceSelfChapter)
    CommonHelper:CSGameObjectSetActive(self.Pre_RaceSeniorTrain,type==RaceModel.RaceSeniorTrain)
end
function Page_SelectCarBase:SetData(root,param)

end
function Page_SelectCarBase:ReOpen()
    if self.BattleType==RaceModel.Battle then
        self.Page_PveChapter:ReOpen()
    end
    if self.BattleType==RaceModel.RaceSelfChapter then
        self.Page_RaceSelfChapter:ReOpen()
    end
end
function Page_SelectCarBase:Init(root)
    self.Pre_SelfLevel=UIUtil.GetChild("page_selflevel",root)
    self.Pre_SelfChapter=UIUtil.GetChild("page_selfchapter",root)
    self.Pre_ClubSelfLevel=UIUtil.GetChild("page_clubselflevel",root)
    self.Pre_ClubSelfChapter=UIUtil.GetChild("page_clubselfchapter",root)
    self.Pre_Challenge=UIUtil.GetChild("page_challenge",root)
    self.Pre_PVEChapter=UIUtil.GetChild("page_pvechapter",root)
    self.Pre_RaceSeniorTrain=UIUtil.GetChild("page_raceseniortrain",root)
    self.Page_RaceSelfChapter=Page_RaceSelfChapterSelectCar()
    self.Page_RaceSelfLevel=Page_RaceSelfLevelSelectCar()
    self.Page_ClubRaceSelfChapter=Page_ClubRaceSelfChapterSelectCar()
    self.Page_ClubRaceSelfLevel=Page_ClubRaceSelfLevelSelectCar()
    self.Page_Challenge=Page_ChallengeSelectCar()
    self.Page_PveChapter=Page_PveChapterSelectCar()
    self.Page_RaceSeniorTrain=Page_RaceSeniorTrainSelectCar()
end

function Page_SelectCarBase:RaceSelfLevelJoinSuccess(result)
    if self.BattleType==RaceModel.RaceSelfLevel then
        self.Page_RaceSelfLevel:JoinSuccess(result)
    end
end
function Page_SelectCarBase:ClubRaceSelfLevelJoinSuccess(result)
    if self.BattleType==RaceModel.ClubRaceSelfLevel then
        self.Page_ClubRaceSelfLevel:JoinSuccess(result)
    end
end
function Page_SelectCarBase:PveChapterViewRefresh(levelid)
    if self.BattleType==RaceModel.Battle then
      self.Page_PveChapter:Refresh(self.Pre_PVEChapter,levelid)
    end
    if self.BattleType==RaceModel.RaceSelfChapter then
      self.Page_RaceSelfChapter:Refresh(self.Pre_SelfLevel,levelid)
    end

end
function Page_SelectCarBase:RaceSeniorTrainRefresh(levelid)
    if self.BattleType==RaceModel.RaceSeniorTrain then
        self.Page_RaceSeniorTrain:Refresh(self.Pre_RaceSeniorTrain,levelid)
    end
end
function Page_SelectCarBase:SetCurCarState(idx,state)
    if self.BattleType==RaceModel.Battle then
        self.Page_PveChapter:SetCurCarState(idx,state)
    end
    if self.BattleType==RaceModel.RaceSelfChapter then
        self.Page_RaceSelfChapter:SetCurCarState(idx,state)
    end

end
function Page_SelectCarBase:GetCurTrackCar()
    if self.BattleType==RaceModel.Battle then
        return  self.Page_PveChapter:GetCurTrackCar()
    end
    if self.BattleType==RaceModel.RaceSelfChapter then
        return  self.Page_RaceSelfChapter:GetCurTrackCar()
    end

end

function Page_SelectCarBase:ParseTime(milliSecond)
    local time=CommonHelper:GetSelfTransferTimeStr(milliSecond)
    local second=string.format("%s'%s'%s",time.minute,time.second,time.milliSecond)
    return second
end