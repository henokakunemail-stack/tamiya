---@class NewPlayerSelectCarView : ViewBase
NewPlayerSelectCarView = class("NewPlayerSelectCarView", ViewBase)

function NewPlayerSelectCarView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "NewPlayerSelectCarViewAction")

end
function NewPlayerSelectCarView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHome",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    self.BtnFight= CommonHelper:HButtonSetCallback("BtnFight",self.gameObject,function(data)
        ChapterSubsystem:Get():SendMsg_BattleBegin(self.LevelData.id, 11)
    end)
    CommonHelper:HButtonSetCallback("BtnRefit", self.gameObject, function(data)
       SkipModuleHelper:Get():ToAssembleGarageView(NewPlayerCarDataManager:Get().CarDataManager[1],NewPlayerCarDataManager:Get().Bag,AssembleGarageOpenType.RaceNewPlayer)
    end)
    self.CarAttrRecommend=UIUtil.GetChild("carAttrRecommend",self.gameObject)
    self.items = {}
    for i = 1, 4 do
        self.items[i] = UIUtil.GetChild("carinfo/Item" .. i, self.gameObject)
    end
    self.PartsItem = { 4, 1, 2, 3 }
end

function NewPlayerSelectCarView:OnOpen()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRefitTable(port)
end

function NewPlayerSelectCarView:ReOpen()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    HomeSceneHelper:SetRefitTable(port)
    self:SetData(self.RaceModle,self.LevelData)
end
---@param data PVELevelData
function NewPlayerSelectCarView:SetData(racemodle,data)
    ---@type PVELevelData
    self.LevelData=data
    self.RaceModle=racemodle
    self:SetCar()
    self:SetTrackData()
end
function NewPlayerSelectCarView:SetTrackData()
    if self.LevelData then
        ---@type PVELevelBattleData
        local  data=self.LevelData:GetBattleInfo()[1]
        self.SceneId = data.SceneId
        self.TrackData=CommonHelper:GetRacetrackData(data.TrackId)
        CommonHelper:GetComponentSetTrackIconByData("trackicon", self.gameObject, self.TrackData, UIModuleID.NewBieSelectCar)
        CommonHelper:SetTrackFeatureByParent("trackfeature", self.gameObject, self.TrackData:GetFeature(), true)
        CommonHelper:SetGameObjectActive("trackfeature",self.gameObject,true)
        CommonHelper:SetGameObjectActive("BtnReview",self.gameObject,true)
        if self.SceneId ~= -1 then
            ---@type scene_config_cell
            local sceneCfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, self.SceneId)
            if sceneCfg then
                CommonHelper:GetComponentSetUITexture("chapterpic", self.gameObject, sceneCfg.icon, UIModuleID.NewBieSelectCar)
            end
        end
        CommonHelper:HButtonSetCallback("BtnReview", self.gameObject, function(data)
            if self.TrackData:GetIsField() then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackFieldNoLook))
            else
                CommonHelper:LoadReviewTrack(nil, self.TrackData)
            end
        end)
        CommonHelper:SetGameObjectActive("normal_bg",self.gameObject,false)
        CommonHelper:SetGameObjectActive("elite_bg",self.gameObject,false)
        CommonHelper:SetGameObjectActive("boss_bg",self.gameObject,true)
        CommonHelper:SetText("###leveltittle",self.gameObject,self.LevelData.name)
        CommonHelper:GetComponentSetUITexture("npcgroup/npcicon",self.gameObject,self.LevelData.levelCfg.levelicon,UIModuleID.NewBieSelectCar)
    else
        CommonHelper:GetComponentSetUITexture("trackicon",self.gameObject,"uitex_sucai_default.png",UIModuleID.NewBieSelectCar)
        CommonHelper:SetGameObjectActive("trackfeature",self.gameObject,false)
        CommonHelper:SetGameObjectActive("BtnReview",self.gameObject,false)

    end

end
function NewPlayerSelectCarView:OnAutoClose()
    HomeSceneCarMeshHelper:Get():ClearCache()
end
function NewPlayerSelectCarView:OnOpenAnimEnd()
    self:CheckNewBieGuide()
end
function NewPlayerSelectCarView:OnClose()
    HomeSceneCarMeshHelper:Get():ClearCache()
end
--{{{设置车
function NewPlayerSelectCarView:SetCar()
    cs_coroutine.start(function()
        coroutine.yield()
        coroutine.yield()
        HomeSceneCarMeshHelper:Get():SetDataByCarData(NewPlayerCarDataManager:Get().CarDataManager[1], SceneChangeID.RefitTable, AnimateType.None)
    end)
    self:SetCarGroup(NewPlayerCarDataManager:Get().CarDataManager[1])
end
---@param cardata CarData
function NewPlayerSelectCarView:SetCarGroup(cardata)
    CommonHelper:SetGameObjectActive("nocarinfogroup",self.gameObject,cardata==nil)
    CommonHelper:SetGameObjectActive("carinfo",self.gameObject,cardata~=nil)
    if cardata then
        local partsList = cardata:GetPartDataList()
        for i = 1, 4 do
            ---@type parts_config_cell
            local parts = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partsList[self.PartsItem[i]].PartCfgID)
            CommonHelper:SetGameObjectActive("ItemPart_118",self.items[i],parts~=nil)
            CommonHelper:SetGameObjectActive("grooveopen",self.items[i],parts==nil)
            local grovveId= AssembleHelper:MsgIdxToGrooveID(self.PartsItem[i])
            local cfg= CommonHelper:GetTableDataByID(ConfigNames.grooveid_config,grovveId)
            CommonHelper:GetComponentSetUITexture("defaulticon",self.items[i],cfg.bgicon,UIModuleID.RaceAssemble)
            if parts then
                CommonHelper:SetItemPartGroup(self.items[i], UIModuleID.RaceAssemble, parts.C_ID)
            end
        end
    end

end