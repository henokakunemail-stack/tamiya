---@class SelectTeamBaseView : ViewBase
SelectTeamBaseView = class("SelectTeamBaseView", ViewBase)

function SelectTeamBaseView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SelectTeamBaseViewAction")
    self.Pre_SelectCar = nil
    self.Pre_CarInfo = nil
    self.Pre_Custom = nil
    ---@type Page_SelectCar
    self.Page_SelectCar = nil
    ---@type PreGarageCarIdx
    self.PreCarIdx = nil
    ---@type Page_SelectCar_Five2
    self.PreCarFive = nil
    ---@type Page_SelectCarBase
    self.Page_SelectCarCustom = nil

    ---@type Page_SelectCarCommon
    self.Page_SelectCarCommon=nil
end

function SelectTeamBaseView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHome",self.gameObject,function (hbtn)
        SkipModuleHelper:Get():BackToMainMenuView(true)
    end)
    self.PageRoot = UIUtil.GetChild("pageroot",self.gameObject)
    self.Pre_SelectCar =UIUtil.GetChild("Page_SelectCar",self.gameObject)
    self.Pre_CarInfo =UIUtil.GetChild("page_carinfo",self.gameObject)
    self.Pre_Custom =UIUtil.GetChild("page_custom",self.gameObject)
    self.ObjCarIdx =UIUtil.GetChild("CaridxGroup",self.gameObject)
    self.Page_SelectCar_Five =UIUtil.GetChild("Page_SelectCar_Five2",self.gameObject)
end

function SelectTeamBaseView:OnOpen()
    self:ViewFixScreen()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit",self.gameObject)
    HomeSceneHelper:SetRefitTable(port)
    self.OpenType=true
end
function SelectTeamBaseView:OnOpenAnimEnd()
    if ClientDataManager:Get().IsConfig2 then
        if self.OpenType and self.BattleType==RaceModel.RaceSeniorTrain and self.LevelData.levelCfg.copytype==LevelType.GuideLevel and  self.LevelData.levelCfg.guideId>0  then
            if self.LevelData.levelCfg.guideId>0 and self.LevelData.starNum<1  then
                GuideManager:Get():Init(self.LevelData.levelCfg.guideId,true)
            end
            self:CheckNewBieGuide(nil,GuideTriggerType.PveLevelTrigger,nil,self.LevelData.id)
        else
            self:CheckNewBieGuide(nil,GuideTriggerType.OpenAnimEnd)
        end
    else
        if self.OpenType and self.BattleType==RaceModel.RaceSeniorTrain and self.LevelData.levelCfg.copytype==LevelType.GuideLevel and  (self.LevelData.levelCfg.guideId>0 or self.LevelData.levelCfg.GuideId>0)  then
            if self.LevelData.levelCfg.guideId>0 and self.LevelData.starNum<1  then
                GuideManager:Get():Init(self.LevelData.levelCfg.guideId,true)
            elseif self.LevelData.levelCfg.GuideId and self.LevelData.levelCfg.GuideId>0 and self.LevelData.starNum<1  then
                GuideManager:Get():Init(self.LevelData.levelCfg.GuideId,true)
            end
            self:CheckNewBieGuide(nil,GuideTriggerType.PveLevelTrigger,nil,self.LevelData.id)
        else
            self:CheckNewBieGuide(nil,GuideTriggerType.OpenAnimEnd)
        end
    end


end
function SelectTeamBaseView:OnClose()
    if  self.Page_SelectCar then
        self.Page_SelectCar:Release()
    end
    CommonHelper:UnloadTrack(MiniTrackType.LocalCustomTrack)
    CommonHelper:ReleasePool(UIModuleID.SelectTeam)
    HomeSceneCarMeshHelper:Get():ClearCache()
end
function SelectTeamBaseView:OnAutoClose()
    if self.Page_SelectCar then
        self.Page_SelectCar:Release()
    end
    CommonHelper:UnloadTrack(MiniTrackType.LocalCustomTrack)
    HomeSceneCarMeshHelper:Get():ClearCache()
end
function SelectTeamBaseView:GetCarNum()
    if self.BattleInfoList   then
        if #self.BattleInfoList<=1 then
            if self.BattleCars then
                return self.BattleCars
            end
            return 1
        end
        return #self.BattleInfoList
    end
    return 1
end
function SelectTeamBaseView:ReOpen()
    if self.BattleInfoList==nil or self:GetCarNum()<=1 then
        self:SetCar()
    else
        self:SetCarFive(self.Page_SelectCarCustom:GetCurTrackCar())
        self.Page_SelectCarCustom:ReOpen()
    end
    local port = CommonHelper:CameraPortUIFit("CameraUIFit",self.gameObject)
    HomeSceneHelper:SetRefitTable(port)
    self.OpenType=false
end

function SelectTeamBaseView:SetData(battletype,param)
    self.BattleType=battletype
    ---@type PVELevelData
    self.LevelData=param
    if self.BattleType==RaceModel.Battle or self.BattleType==RaceModel.RaceSeniorTrain then
        self.BattleInfoList=self.LevelData:GetBattleInfo()
        self.BattleCars=self.LevelData.levelCfg.BattleCars
        self.CarLockIdx=CommonHelper:GetLockCarListByNum(self:GetCarNum())
    end
    if self.BattleType==RaceModel.RaceSelfChapter then
        self.BattleInfoList=self.LevelData[2].BattleInfoList
        self.BattleCars=self.LevelData[2].BattleCars
        self.CarLockIdx=CommonHelper:GetLockCarListByNum(self:GetCarNum())
    end
    if self.BattleType==RaceModel.RaceSelfLevel then
        self.CarLockIdx=nil
    end
    if self.Page_SelectCar == nil then
        self.Page_SelectCar = Page_SelectCar()
    end
    if self.PreCarFive == nil then
        self.PreCarFive = Page_SelectCar_Five2()
    end
    if self:GetCarNum()>1 then
        self:SetSelectCatCustom(battletype,param,self.PreCarFive)
    else
        self:SetSelectCatCustom(battletype,param,self.Page_SelectCar)
    end

    self:SetSelectCatCommon(self.BattleType,self.LevelData,1)
    self:SetSelectCarType(self:GetCarNum(),PlayerPrefsHelper:GetValue_MainMenuViewCarIndex())
end
function SelectTeamBaseView:SetSelectCarType(num,idx)
    CommonHelper:SetGameObjectActive("Page_SelectCar",self.gameObject,num<=1)
    CommonHelper:SetGameObjectActive("Page_SelectCar_Five2",self.gameObject,num>1)
    if num<=1 then
        self:SetCar()
    else
        self:SetCarFive(idx)
    end

end
function SelectTeamBaseView:SetCarMesh(idx)
    cs_coroutine.start(function()
        if  self.BattleType==RaceModel.RaceSeniorTrain and  self.LevelData.levelCfg.copytype==LevelType.GuideLevel then
            coroutine.yield()
            CommonHelper:SetGameObjectActive("CaridxGroup",self.gameObject,false)
            local carData=CarReviewData()
            carData:SetDataByNPC(stringSplitToNumber(RaceSeniorTrainManager:Get():GetCurLevelData().levelCfg.npcid,":")[2])
            HomeSceneCarMeshHelper:Get():SetDataByCarReviewData(carData,SceneChangeID.RefitTable,nil)
        else
            CommonHelper:SetGameObjectActive("CaridxGroup",self.gameObject,true)
            self:SetPageSelectCar(idx)
        end
    end)
end

function SelectTeamBaseView:SetCar()
    if self.PreCarIdx==nil then
        self.PreCarIdx=PreGarageCarIdx()
        self:SetPreGarageCar()
    else
        self:SetPreGarageCar()
    end
end
function SelectTeamBaseView:SetCarFive(idx)
    self.PreCarFive:SetData(self.Page_SelectCar_Five,UIModuleID.SelectTeam, idx, false,function(idx, isautoselect)
        self:SetCarMesh(idx)
        self.Page_SelectCarCustom:SetCurCarState(idx,self.PreCarFive:GetState(idx))
    end)
end

---@param data CarData
function SelectTeamBaseView:SetPageSelectCar(idx)
    if self.Page_SelectCar then
        self.Page_SelectCar:SetData(self.Pre_SelectCar, UIModuleID.SelectTeam,idx,false, SceneChangeID.RefitTable, false)
        self:SetCarRecommend(idx)
    end
end

function SelectTeamBaseView:SetPreGarageCar()
    self.PreCarIdx:SetData(self.ObjCarIdx, UIModuleID.SelectTeam, PlayerPrefsHelper:GetValue_MainMenuViewCarIndex(),true,false ,function(data, isautoselect)
        self:SetCarMesh(data:GetCarIdx())
        PlayerPrefsHelper:SetValue_MainMenuViewCarIndex(data:GetCarIdx())
    end)
end


function SelectTeamBaseView:SetSelectCatCustom(battletype,param,Page_SelectCar)
    if self.Page_SelectCarCustom == nil then
        self.Page_SelectCarCustom = Page_SelectCarBase()
        self.Page_SelectCarCustom:Init(self.Pre_Custom)
        self:Page_SetSelectCarCustom(battletype,param,Page_SelectCar)
    else
        self:Page_SetSelectCarCustom(battletype,param,Page_SelectCar)
    end
end

function SelectTeamBaseView:Page_SetSelectCarCustom(battletype,param,Page_SelectCar)
    if self.Page_SelectCarCustom then
        self.Page_SelectCarCustom:SetPage(battletype,param,Page_SelectCar)
    end
end

function SelectTeamBaseView:SetSelectCatCommon(battletype,param,idx)
    if self.Page_SelectCarCommon == nil then
        self.Page_SelectCarCommon = Page_SelectCarCommon()
        self.Page_SelectCarCommon:Init(self.Pre_CarInfo)
        self:Page_SetSelectCarCommon(battletype,param,idx)
    else
        self:Page_SetSelectCarCommon(battletype,param,idx)
    end
end

function SelectTeamBaseView:RaceSelfLevelJoinSuccess(result)
    self.Page_SelectCarCustom:RaceSelfLevelJoinSuccess(result)
end
function SelectTeamBaseView:ClubRaceSelfLevelJoinSuccess(result)
    self.Page_SelectCarCustom:ClubRaceSelfLevelJoinSuccess(result)
end
function SelectTeamBaseView:PveChapterViewRefresh(id)
    self.Page_SelectCarCustom:PveChapterViewRefresh(id)
end
function SelectTeamBaseView:RaceSeniorChapterViewRefresh(id)
    self.Page_SelectCarCustom:RaceSeniorTrainRefresh(id)
end


function SelectTeamBaseView:PveChapterSetCommon(id)
    self:SetSelectCatCommon(self.BattleType,self.LevelData,id)
end

function SelectTeamBaseView:Page_SetSelectCarCommon(battletype,arg,idx)

    if self.Page_SelectCarCommon then
        local param=nil
        if battletype==RaceModel.Battle then
            param=Param_SelectCarCommon()
            ---@type PVELevelData
            local levelData=arg
            ---@type PVELevelBattleData
            param.tittle=levelData.name
            ---@type PVELevelBattleData
            local BattleInfo=nil
            param.IsMore=#self.BattleInfoList>1
            param.idx=idx
            param.BattleInfoList=self.BattleInfoList
            if #self.BattleInfoList>1 then
                BattleInfo=self.BattleInfoList[idx]
                param.IsMore=true
            else
                BattleInfo=self.BattleInfoList[1]
            end
            param.TrackData=CommonHelper:GetRacetrackData(BattleInfo.TrackId)
            param.NpcIcon=levelData.levelCfg.levelicon
            param.SceneId=BattleInfo.SceneId
            param.NpcQuality=levelData.levelCfg.copytype
            param.Star=levelData.starNum
            CommonHelper:SetText("Title1/###title1",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterTittle))
        end
        if battletype==RaceModel.RaceSeniorTrain then
            param=Param_SelectCarCommon()
            ---@type PVELevelData
            local levelData=arg
            param.tittle=levelData.name
            ---@type PVELevelBattleData
            local BattleInfo=nil
            param.IsMore=#self.BattleInfoList>1
            param.idx=idx
            param.BattleInfoList=self.BattleInfoList
            if #self.BattleInfoList>1 then
                BattleInfo=self.BattleInfoList[idx]
            else
                BattleInfo=self.BattleInfoList[1]
            end
            param.TrackData=CommonHelper:GetRacetrackData(BattleInfo.TrackId)
            param.NpcIcon=levelData.levelCfg.levelicon
            param.SceneId=BattleInfo.SceneId
            param.CarRewardData=CarReviewData()
            param.CarRewardData:SetDataByNPC(BattleInfo.NpcIds[1])
            param.NpcQuality=levelData.levelCfg.copytype
            param.Star=levelData.starNum
            CommonHelper:SetText("Title1/###title1",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterTittle))
        end
        if battletype==RaceModel.RaceSelfChapter then
            param=Param_SelectCarCommon()
            ---@type RaceSelfChapterData
            local chapterData=arg[1]
            ---@type dictactivitycopy_config_cell
            local levelData=arg[2]
            ---@type PVELevelBattleData
            local BattleInfo=nil
            param.IsMore=#self.BattleInfoList>1
            param.idx=idx
            param.BattleInfoList=self.BattleInfoList
            if #self.BattleInfoList>1 then
                BattleInfo=self.BattleInfoList[idx]
            else
                BattleInfo=self.BattleInfoList[1]
            end
            param.tittle=CommonHelper:GetTempStr_Default(chapterData.cfg.mapname)
            param.TrackData=CommonHelper:GetRacetrackData(BattleInfo.TrackId)
            param.NpcIcon=levelData.levelicon
            param.SceneId=BattleInfo.SceneId
            param.CarRewardData=CarReviewData()
            param.CarRewardData:SetDataByNPC(BattleInfo.NpcIds[1])
            param.NpcQuality=levelData.copytype
            param.NpcQuality=1
            if levelData.isBoos==1 then
                param.NpcQuality=3
            end
            param.Star=-1
            CommonHelper:SetText("Title1/###title1",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterTittle))
        end
        if battletype==RaceModel.RaceSelfLevel then
            param=Param_SelectCarCommon()
            ---@type  SC_RetBattle
            local levelData=arg.battles[1]
            param.tittle=levelData.rolename
            param.TrackData=CommonHelper:GetRacetrackData(levelData.trackid,levelData.trackinfo)
            param.SceneId=tonumber(levelData.scenceid)
            param.CarRewardData=CarReviewData()
            param.RoleIcon=0
            param.IsMore=false
            if levelData.firstracer and #levelData.firstracer>0 then
                param.RoleIcon=levelData.firstracer[1].headicon
                param.CarRewardData:SetDataByMsg(levelData.firstracer[1].car)
            end
            param.NpcQuality=1
            param.Star=-1
            CommonHelper:SetText("Title1/###title1",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfLevelTittle))
        end
        if battletype==RaceModel.ClubRaceSelfChapter then
            param=Param_SelectCarCommon()
            ---@type ClubRaceSelfChapterData
            local chapterData=arg[1]
            ---@type guildselfchapterlevelinfo_config_cell
            local levelData=arg[2]
            param.tittle=CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterHoldRace,chapterData.masterName)
            param.TrackData=CommonHelper:GetRacetrackData(levelData.trackId)
            param.RoleIcon=chapterData.masterIcon
            param.SceneId=levelData.sceneId
            param.IsMore=false
            local npcs=stringSplitToNumber(levelData.npcs,',')
            param.CarRewardData=CarReviewData()
            param.CarRewardData:SetDataByNPC(npcs[1])
            param.NpcQuality=1
            if levelData.isBoos==1 then
                param.NpcQuality=3
            end
            param.Star=-1
            CommonHelper:SetText("Title1/###title1",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.ClubRaceSelfChapterTittle))
        end
        if battletype==RaceModel.ClubRaceSelfLevel then
            param=Param_SelectCarCommon()
            ---@type ClubRaceSelfLevelData
            local levelData=arg
            param.tittle=levelData.name
            param.TrackData=CommonHelper:GetRacetrackData(levelData.trackId,levelData.trackInfo)
            param.RoleIcon=levelData.masterIcon
            param.IsMore=false
            param.SceneId=tonumber(levelData.sceneId)
            param.CarRewardData=CarReviewData()
            local npcs=nil
            ---@type guildselflevelreward_config_cell
            local cfg=CommonHelper:GetTableDataByID(ConfigNames.selflevelreward_config,levelData.NpcId)
            if param.TrackData:GetRaceNumber() == TrackSegmentNumbers.Three then
                npcs=stringSplitToNumber(cfg.npcs3,',')
            end
            if param.TrackData:GetRaceNumber() == TrackSegmentNumbers.Five then
                npcs=stringSplitToNumber(cfg.npcs5,',')
            end
            param.CarRewardData:SetDataByNPC(npcs[1])
            param.NpcQuality=1
            param.Star=-1
            CommonHelper:SetText("Title1/###title1",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.ClubRaceSelfLevelTittle))
        end
        if battletype==RaceModel.Challenge then
            local data=SpecialTrainingDataManager:Get():GetSelectCopy()
            local temData=SpecialTrainingDataManager:Get():GetCurChallengeTeam()
            param=Param_SelectCarCommon()
            local level= SpecialTrainingDataManager:Get().CurLevel
            local tittle=""
            param.IsMore=false
            if level==1 then
                tittle= CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeTittleLow,CommonHelper:GetTempStr_Default(temData.name))
            end
            if level==2 then
                tittle=CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeTittleMiddle,CommonHelper:GetTempStr_Default(temData.name))
            end
            if level==3 then
                tittle=CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeTittleHigh,CommonHelper:GetTempStr_Default(temData.name))
            end
            param.tittle=tittle
            param.TrackData=CommonHelper:GetRacetrackData(data.racetrack)
            param.SceneId=tonumber(data.sceneId)
            param.CarRewardData=CarReviewData()
            local npcs= stringSplitToNumber(data.npcs,',')
            local npcs=tonumber(npcs[1])
            param.NpcId=npcs
            param.CarRewardData:SetDataByNPC(npcs)
            param.NpcQuality=1
            param.Star=-1
            CommonHelper:SetText("Title1/###title1",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.ChallengeTittle))
        end
        if param then
            self.Page_SelectCarCommon:SetPage(param,self.BattleType)
        end
    end
end

function SelectTeamBaseView:SetCarRecommend(idx)
    if self.Page_SelectCarCommon then
        if self.BattleType==RaceModel.Battle then
            self.Page_SelectCarCommon:SetCarAttrRecommend(idx)
        end
    end
end