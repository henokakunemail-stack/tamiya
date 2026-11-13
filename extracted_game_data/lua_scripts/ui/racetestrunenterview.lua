---@class RaceTestRunEnterView : ViewBase
RaceTestRunEnterView = class("RaceTestRunEnterView", ViewBase)

function RaceTestRunEnterView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceTestRunEnterViewAction")

end
function RaceTestRunEnterView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHome",self.gameObject,function (hbtn)
        SkipModuleHelper:Get():BackToMainMenuView(true)
    end)
    self.ToggleSelect= CommonHelper:HButtonSetCallback("ToggleSelect",self.gameObject,function (hbtn)
        local value= PlayerPrefsHelper:GetValue_RaceTestSelectPosition(self.OpenType)
        PlayerPrefsHelper:SetValue_RaceTestSelectPosition(self.OpenType,value==1 and 0 or 1)
        CommonHelper:SetToggleState(self.ToggleSelect, PlayerPrefsHelper:GetValue_RaceTestSelectPosition(self.OpenType)==1)
    end)
    self.BtnTestEnter = CommonHelper:HButtonSetCallback("BtnTestEnter", self.gameObject, function(hbtn)
        if RaceAssembleAddManager:Get().CarDataManager[1] and RaceAssembleAddManager:Get().CarDataManager[1]:CheckCarCompleteness(true) then
            if PlayerPrefsHelper:GetValue_RaceTestSelectPosition(self.OpenType)==1  then
                local data= {trackId=self.TrackData:GetId(),scenceId=self.SceneId,Car=RaceAssembleAddManager:Get().CarDataManager[1],position=nil,carIds=nil,raceType=self.RaceType,raceStyle=self.RaceStyleType}
                BattleDataManager:Get():SetRoomData(data, RaceModel.RaceAssembleTest,false)
                local scenename = BattleDataManager:Get():GetSceneName()
                local trackdata = BattleDataManager:Get():GetTrackData()
                SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceAssembleTest)
            else
                CommonHelper:TrackSelectDepartPosition(self.TrackData:GetRaceNumber(),function(position)
                    local data= {trackId=self.TrackData:GetId(),scenceId=self.SceneId,Car=RaceAssembleAddManager:Get().CarDataManager[1],position=position,carIds=nil,raceType=self.RaceType,raceStyle=self.RaceStyleType}
                    BattleDataManager:Get():SetRoomData(data, RaceModel.RaceAssembleTest,false)
                    local scenename = BattleDataManager:Get():GetSceneName()
                    local trackdata = BattleDataManager:Get():GetTrackData()
                    SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceAssembleTest)
                end,TrackPositionViewType.None)
            end
        end
    end)
    CommonHelper:HButtonSetCallback("BtnRefit", self.gameObject, function(data)
        SkipModuleHelper:Get():ToAssembleGarageView(RaceAssembleAddManager:Get().CarDataManager[1],RaceAssembleAddManager:Get().Bag,AssembleGarageOpenType.RaceAssembleAdd)
    end)
    self.MoreRowScrollView_Rank=UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_Rank",self.gameObject,typeof(MoreRowScrollView))
    self.CarAttrRecommend=UIUtil.GetChild("carAttrRecommend",self.gameObject)
    self.items = {}
    for i = 1, 4 do
        self.items[i] = UIUtil.GetChild("SelfItem" .. i, self.gameObject)
    end
    self.PartsItem = { 4, 1, 2, 3 }
end

function RaceTestRunEnterView:OnOpen()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRaceRankSelectCar(port)
end

function RaceTestRunEnterView:ReOpen()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRaceRankSelectCar(port)
    self:SetData()
end
function RaceTestRunEnterView:SetData()
    self.OpenType=RaceAssembleAddManager:Get():GetOpenType()
    self.SceneId=RaceAssembleAddManager:Get():GetSceneID()
    self.TrackData=RaceAssembleAddManager:Get():GetTrackData()
    self.RaceType=RaceAssembleAddManager:Get():GetRaceType()
    self.RaceStyleType=RaceAssembleAddManager:Get():GetRaceStyleType()
    self.CarData=RaceAssembleAddManager:Get().CarDataManager[1]
    self.Bag=RaceAssembleAddManager:Get().Bag
    CommonHelper:SetToggleState(self.ToggleSelect, PlayerPrefsHelper:GetValue_RaceTestSelectPosition(self.OpenType)==1)
    self:SetCar()
    self:SetRankListView()
    --self:SetTrackData()
    --self:SetCarAttrRecommend()
end
function RaceTestRunEnterView:SetTrackData()
    if self.TrackData then
        CommonHelper:GetComponentSetTrackIconByData("trackicon", self.gameObject, self.TrackData, UIModuleID.RaceAssembleAdd)
        CommonHelper:SetTrackFeatureByParent("trackfeature", self.gameObject, self.TrackData:GetFeature(), true)
        CommonHelper:SetGameObjectActive("trackfeature",self.gameObject,true)
        CommonHelper:SetGameObjectActive("BtnReview",self.gameObject,true)
        if self.SceneId ~= -1 then
            ---@type scene_config_cell
            local sceneCfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, self.SceneId)
            if sceneCfg then
                CommonHelper:GetComponentSetUITexture("chapterpic", self.gameObject, sceneCfg.icon, UIModuleID.RaceAssembleAdd)
            end
        end
        CommonHelper:HButtonSetCallback("BtnReview", self.gameObject, function(data)
            if self.TrackData:GetIsField() then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackFieldNoLook))
            else
                CommonHelper:LoadReviewTrack(nil, self.TrackData)
            end
        end)
    else
        CommonHelper:GetComponentSetUITexture("trackicon",self.gameObject,"uitex_sucai_default.png",UIModuleID.RaceAssembleAdd)
        CommonHelper:SetGameObjectActive("trackfeature",self.gameObject,false)
        CommonHelper:SetGameObjectActive("BtnReview",self.gameObject,false)

    end

end
function RaceTestRunEnterView:SetRankListView()
    local players = RaceRankManager:Get():GetFastRank(self.TrackData:GetId())
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_Rank", self.gameObject, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView,4,1,function(index, itemObj,scroll)
        local data=nil
        if players then
            data=players[index+1]
        end
        if index==3 then
            CommonHelper:SetGameObjectActive("coustom_rank_none",itemObj,false)
            CommonHelper:SetGameObjectActive("playergroup",itemObj,false)
        else
            local coustom_rank_none= CommonHelper:SetGameObjectActive("coustom_rank_none",itemObj,data==nil)
            local playergroup= CommonHelper:SetGameObjectActive("playergroup",itemObj,data~=nil)
            if data==nil then
                CommonHelper:SetPlayerIconById("PlayerIcon",coustom_rank_none,99999,99999,nil,UIModuleID.RaceRank)
            else
                self:SetItem(playergroup,data,index)
            end
        end
    end)
    self:SetItem(self:GetChild("self"),RaceRankManager:Get():GetSelfRank(self.TrackData:GetId()),-1)
end

---@param data RaceRankMoreTrackRankData
function RaceTestRunEnterView:SetItem(parent,data,dataIndex)
    if data.Rank then
        CommonHelper:SetGameObjectActive("first",parent,data.Rank==1)
        CommonHelper:SetGameObjectActive("second",parent,data.Rank==2)
        CommonHelper:SetGameObjectActive("third",parent,data.Rank==3)
    end

    if data.Time>0 then
        CommonHelper:GetComponentTransferTime("###bestrecord",parent,data.Time)
    elseif data.Time<0 then
        local result=CommonHelper:TransferTime(math.abs(data.Time), 0.001)
        CommonHelper:SetText("###bestrecord", parent,"-".. CommonHelper:TransferTimeToString(result))
    else
        CommonHelper:SetText("###bestrecord",parent,"--:--:--")
    end
    if data.Score then
        ---@type qualifyingrank_config_cell
        local curcfg, minscore, maxscore = CommonHelper:GetRankCfgByScore(data.Score)
        CommonHelper:SetRankIconGroup("rankicon_s_5", parent, curcfg)
    end
    CommonHelper:SetPlayerIconById("PlayerIcon",parent,data.HeadIcon,data.IconFrame,nil,UIModuleID.RaceRank)
    CommonHelper:SetText("###playerName",parent,data.Name)
end

function RaceTestRunEnterView:OnAutoClose()
    HomeSceneCarMeshHelper:Get():ClearCache()
end

function RaceTestRunEnterView:OnClose()
    HomeSceneCarMeshHelper:Get():ClearCache()
end
--{{{设置车
function RaceTestRunEnterView:SetCar()
    cs_coroutine.start(function()
        coroutine.yield()
        coroutine.yield()
        HomeSceneCarMeshHelper:Get():SetDataByCarData(self.CarData, SceneChangeID.RaceRankSelectCar, AnimateType.None)
    end)
    self:SetCarGroup(self.CarData)
end
---@param cardata CarData
function RaceTestRunEnterView:SetCarGroup(cardata)
    CommonHelper:SetGameObjectActive("nocarinfogroup",self.gameObject,cardata==nil)
    CommonHelper:SetGameObjectActive("carinfo",self.gameObject,cardata~=nil)
    if cardata then
        local partsList = cardata:GetPartDataList()
        for i = 1, 4 do
            ---@type dictparts_config_cell
            local parts = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partsList[self.PartsItem[i]].PartCfgID)
            CommonHelper:SetGameObjectActive("ItemPart_118",self.items[i],parts~=nil)
            CommonHelper:SetGameObjectActive("grooveopen",self.items[i],parts==nil)
            local grovveId= AssembleHelper:MsgIdxToGrooveID(self.PartsItem[i])
            local cfg= CommonHelper:GetTableDataByID(ConfigNames.grooveid_config,grovveId)
            CommonHelper:GetComponentSetUITexture("defaulticon",self.items[i],cfg.bgicon,UIModuleID.RaceAssembleAdd)
            if parts then
                CommonHelper:SetItemPartGroup(self.items[i], UIModuleID.RaceAssembleAdd, parts.C_ID)
            end
        end
        CommonHelper:SetText("###shellname",self.gameObject,string.format(CommonHelper:GetColorShellStringByQuality(CommonHelper:GetPartBaseCfg(cardata:GetShellPartCfg().C_ID).fabric),CommonHelper:GetTempStr_Default(cardata:GetShellPartCfg().partname)))
    end

end
--}}}
function RaceTestRunEnterView:SetCarAttrRecommend()
    local partIdx={PartGrooveID.Motor,PartGrooveID.Gears}
    ---@type CarData
    local carData = self.CarData
    if carData==nil then return end
    for i = 1, 2 do
        local item=UIUtil.GetChild("Item"..i,self.CarAttrRecommend)
        if carData.assembleMgr:GetNodeByGrooveID(partIdx[i]) and carData.assembleMgr:GetNodeByGrooveID(partIdx[i]).PartId~=0 then
            ---@type dictparts_config_cell
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
                CommonHelper:SetItemPartGroup(item,UIModuleID.RaceAssembleAdd,parts.C_ID,ItemPartUIType.Simple,param,function(id)
                    CommonHelper:ShowPartInfoByCfgId(id, UIModuleID.RaceAssembleAdd)
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
        CommonHelper:SetText("attr2/value",self.CarAttrRecommend,selfCushion>=data.cushionMin and data.cushionMin or CommonHelper:GetTempStr_Default(TemplateStringID.CarAttrCompareLow,data.cushionMin))
        CommonHelper:SetText("attr3/value",self.CarAttrRecommend,selfDownforce>=data.downforceMin and data.downforceMin or CommonHelper:GetTempStr_Default(TemplateStringID.CarAttrCompareLow,data.downforceMin))
    end
    CommonHelper:SetGameObjectActive("nocarinfo",self.CarAttrRecommend,data==nil)
end
