---@class Param_SelectCarCommon
Param_SelectCarCommon = class("Param_SelectCarCommon")
function Param_SelectCarCommon:initialize()
    ---@type CarReviewData
    self.CarRewardData = nil
    self.NpcId = -1
    self.SceneId = -1

    ---@type RaceTrackData
    self.TrackData = nil
    self.tittle = ""
    self.NpcIcon=-1
    self.RoleIcon=-1
    self.IconFrame=-1
    self.Star=0
    self.IsMore=false
    self.NpcQuality=1
    self.idx=1
    self.CarData=nil
end



---@class Page_SelectCarCommon
Page_SelectCarCommon=class("Page_SelectCarCommon")
function Page_SelectCarCommon:initialize()

end

function Page_SelectCarCommon:Init(root)
    self.Root=root
    self.items={}
    for i = 1, 4 do
        self.items[i]=UIUtil.GetChild("Item"..i,self.Root)
    end
    self.PartsItem={4,1,2,3}
end

---@param param Param_SelectCarCommon
function Page_SelectCarCommon:SetPage(param,BattleType)
    CommonHelper:SetText("###leveltittle",self.Root,param.tittle)
    CommonHelper:SetTrackFeatureByParent("trackfeature",self.Root,param.TrackData:GetFeature(),true)
    CommonHelper:GetComponentSetTrackIconByData("trackicon",self.Root,param.TrackData,UIModuleID.SelectTeam)
    CommonHelper:SetGameObjectActive("tips",self.Root,param.TrackData:GetRaceType()==MiniTrackType.System or  param.TrackData:GetRaceType()==MiniTrackType.LocalCustomTrack)
    if param.Star==-1 then
        CommonHelper:SetGameObjectActive("ThreeStar",self.Root,false)
    else
        CommonHelper:SetGameObjectActive("normal_bg",self.Root,param.NpcQuality==1)
        CommonHelper:SetGameObjectActive("elite_bg",self.Root,param.NpcQuality==2)
        CommonHelper:SetGameObjectActive("boss_bg",self.Root,param.NpcQuality==3)
    end


    if param.SceneId~=-1 then
      ---@type scene_config_cell
      local sceneCfg=CommonHelper:GetTableDataByID(ConfigNames.scene_config,param.SceneId)
        if sceneCfg then
            CommonHelper:GetComponentSetUITexture("chapterpic",self.Root,sceneCfg.icon,UIModuleID.SelectTeam)
        end
    end
    local name=nil
    local icon=nil
    local iconframe=nil

    if param.RoleIcon~=-1 then
         icon=CommonHelper:GetPlayerIconById(tonumber(param.RoleIcon))
         iconframe=CommonHelper:GetPlayerIconById(tonumber(param.IconFrame),nil,HeadIconAttrType.Frame)
    end
    if param.NpcId~=-1 then
       name,icon= CommonHelper:AnalyseNPCNameAndIconById(param.NpcId)
    end
    if param.NpcIcon~=-1 then
       icon=param.NpcIcon
    end
    CommonHelper:SetGameObjectActive("moretrack",self.Root,param.IsMore)
    CommonHelper:SetGameObjectActive("npcgroup",self.Root,not param.IsMore)
    self.CarInfo= CommonHelper:SetGameObjectActive("carinfo",self.Root, BattleType~=RaceModel.Battle)
    self.CarAttrRecommend=CommonHelper:SetGameObjectActive("carAttrRecommend",self.Root,BattleType==RaceModel.Battle)
    CommonHelper:GetComponentSetUITexture("npcgroup/npcicon",self.Root,icon,UIModuleID.SelectTeam)
    CommonHelper:GetComponentSetUITexture("npcgroup/iconframe",self.Root,icon,UIModuleID.SelectTeam)
    if param.CarRewardData then
        local partsList = param.CarRewardData:GetPartList()
        for i = 1, 4 do
            local item=UIUtil.GetChild("Item"..i,self.CarInfo)
            if partsList[self.PartsItem[i]] then
                ---@type parts_config_cell
                local parts=CommonHelper:GetTableDataByID(ConfigNames.parts_config,partsList[self.PartsItem[i]].PartCfgID)
                if parts then
                    CommonHelper:SetItemPartGroup(item,UIModuleID.SelectTeam,parts.C_ID,ItemPartUIType.Simple,nil,function(id)
                        CommonHelper:ShowPartInfoByCfgId(id, UIModuleID.SelectTeam)
                    end,parts.C_ID)
                end
            end
            CommonHelper:SetGameObjectActive("ItemPart_118", self.items[i],partsList[self.PartsItem[i]]~=nil)
        end
        CommonHelper:SetGameObjectActive("nocarinfo",self.Root,#partsList<=0)
    end
    if param.IsMore then
        for i = 1, 5 do
            local  tog=CommonHelper:HButtonSetCallback("ToggleYellow"..i,self.Root,function (hbtn)
                UINotify:Get():SendNotification(UINotifyEvent.SelectTeamViewPveChapterSetCommon,hbtn.intData)
            end,i)
            CommonHelper:SetToggleState(tog,param.idx==i)
            CommonHelper:SetHButtonClick(tog,param.BattleInfoList[i]~=nil,true)
        end
    end
    CommonHelper:HButtonSetCallback("BtnRefit", self.Root, function(data)
        if BattleType==RaceModel.RaceSeniorTrain and RaceSeniorTrainManager:Get():GetCurLevelData().levelCfg.copytype==LevelType.GuideLevel then
            local  data=CarReviewData()
            data:SetDataByNPC(stringSplitToNumber(RaceSeniorTrainManager:Get():GetCurLevelData().levelCfg.npcid,":")[2],nil,GuideGarageViewOpenType.RaceSeniorTrain)
            SkipModuleHelper:Get():ToGuideGarageView(data)
        else
            SkipModuleHelper:Get():ToGarage(UIModuleID.SelectTeam)
        end
    end)
    CommonHelper:HButtonSetCallback("BtnReview", self.Root, function(data)
        if param.TrackData:GetIsField() then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackFieldNoLook))
        else
            CommonHelper:LoadReviewTrack(nil, param.TrackData)
        end
    end)
    self.TrackId=param.TrackData:GetId()
end

function Page_SelectCarCommon:SetCarAttrRecommend(idx)
    local partIdx={PartGrooveID.Motor,PartGrooveID.Gears}
    ---@type CarData
    local carData = CarDataManager:Get():GetCarDataByIndex(idx)
    for i = 1, 2 do
        local item=UIUtil.GetChild("Item"..i,self.CarAttrRecommend)
        if carData.assembleMgr:GetNodeByGrooveID(partIdx[i]) and carData.assembleMgr:GetNodeByGrooveID(partIdx[i]).PartId~=0 then
            ---@type parts_config_cell
            local parts=CommonHelper:GetTableDataByID(ConfigNames.parts_config,carData.assembleMgr:GetNodeByGrooveID(partIdx[i]).PartId)
            if parts then
                local articleCell=carData.assembleMgr:GetNodeByGrooveID(partIdx[i]).ArticleCell
                local param = Param_ItemPartParam()
                param.quality = articleCell:GetPartQuality()
                param.star = articleCell:GetStar()
                param.lv = articleCell:GetPartLV()
                param.using = articleCell:GetCarId()
                param.lock = articleCell:GetPartLock()
                param.awaken=articleCell:GetAwaken()
                param.generation=articleCell:GetGeneration()
                param.downType=articleCell:GetPartDownType()
                param.source = articleCell:GetPartSource()
                param.expireTime = articleCell:GetPartExpTime()
                CommonHelper:SetItemPartGroup(item,UIModuleID.SelectTeam,parts.C_ID,ItemPartUIType.Simple,param,function(id)
                    CommonHelper:ShowPartInfoByCfgId(id, UIModuleID.SelectTeam)
                end,parts.C_ID)
            end
        end
        CommonHelper:SetGameObjectActive("ItemPart_118", item,carData.assembleMgr:GetNodeByGrooveID(partIdx[i])~=nil and carData.assembleMgr:GetNodeByGrooveID(partIdx[i]).PartId~=0)
    end
    local data= CarAttrRecommendManager:Get():GetDataByTrackId_MotorId_GearId(self.TrackId,carData.assembleMgr:GetNodeByGrooveID(partIdx[1]).PartId,carData.assembleMgr:GetNodeByGrooveID(partIdx[2]).PartId)
    for i = 1, 3 do
        CommonHelper:SetGameObjectActive("attr"..i,self.CarAttrRecommend,data~=nil)
    end
    CommonHelper:HButtonSetCallback("BtnCarAttrRecommend",self.CarAttrRecommend,function (hbtn)
        CommonHelper:ShowHelpView(PageDetailType.CarAttrRecommend)
    end)
    if data~=nil then
        local selfStabilize=CommonHelper:FloatRound( carData:GetAttrValueById(CarAttrType.Stabilize).value/1000,100)
        local selfCushion= CommonHelper:FloatRound(carData:GetAttrValueById(CarAttrType.Cushion).value/1000,100)
        local selfDownforce=  CommonHelper:FloatRound(carData:GetAttrValueById(CarAttrType.Downforce).value/1000,100)
        CommonHelper:SetText("attr1/value",self.CarAttrRecommend,selfStabilize>=data.stabilizeMin and data.stabilizeMin or CommonHelper:GetTempStr_Default(TemplateStringID.CarAttrCompareLow,data.stabilizeMin))
        --CommonHelper:SetText("attr1/comparevalue",self.CarAttrRecommend,CommonHelper:GetAttrCompareString(data.stabilizeMin,selfStabilize))
        CommonHelper:SetText("attr2/value",self.CarAttrRecommend,selfCushion>=data.cushionMin and data.cushionMin or CommonHelper:GetTempStr_Default(TemplateStringID.CarAttrCompareLow,data.cushionMin))
        -- CommonHelper:SetText("attr2/comparevalue",self.CarAttrRecommend,CommonHelper:GetAttrCompareString(data.cushionMin,selfCushion))
        CommonHelper:SetText("attr3/value",self.CarAttrRecommend,selfDownforce>=data.downforceMin and data.downforceMin or CommonHelper:GetTempStr_Default(TemplateStringID.CarAttrCompareLow,data.downforceMin))
        --CommonHelper:SetText("attr3/comparevalue",self.CarAttrRecommend,CommonHelper:GetAttrCompareString(data.downforceMin,selfDownforce))
    end
    CommonHelper:SetGameObjectActive("nocarinfo",self.CarAttrRecommend,data==nil)
end
