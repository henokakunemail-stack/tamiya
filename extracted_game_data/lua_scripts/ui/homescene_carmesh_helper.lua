




---@class HomeSceneCarMeshHelper
HomeSceneCarMeshHelper = class("HomeSceneCarMeshHelper")

function HomeSceneCarMeshHelper:initialize()

    self.sceneType = ""
    self.IsPlayEnterAni = true

    self.AniType = AnimateType.None
    self.AniName = ""
    self.AniTime = 0

    self.BuildID = -1
    self.BuildGroup = {}
    self.IsLoading = false

    self.AniObj = nil

    self.SelfCarId = -1

    ---@type table<number, Lua_PartData>
    self.PartDataList = {}
    ---@type carshell_config_cell
    self.CarShellCfg = nil
    self.Lightweight = {} -- 玩家轻量化数据
    self.Grids = {} -- 玩家纱网数据
    self.Colorid = 0 -- 玩家车壳染色数据
    self.Stickerid = 0 -- 玩家贴纸数据
end

---@return HomeSceneCarMeshHelper
function HomeSceneCarMeshHelper:Get()
    if self._instance == nil then
        self._instance = HomeSceneCarMeshHelper()
    end
    return self._instance
end


function HomeSceneCarMeshHelper:BeginLoad()
    self:BeginWaitingTimer()

    self.IsLoading = true

    self:SetMeshCtrl(false)


    if self.PartDataList == nil or #self.PartDataList == 0 then
        self:ErrorEnd()
        return
    end
    if self.AniType ~= AnimateType.None then
        if self.AniType == AnimateType.Garage then
            if self.CarShellCfg == nil then
                self.AniName = ""
                self.AniTime = 0
            else
                self.AniName = self.CarShellCfg.NewAniEnter
                self.AniTime = self.CarShellCfg.aniEnterTime
            end
        end
        if self.AniType == AnimateType.MainCity then
            self.AniName = MainCityAniName
            self.AniTime = MainCityAniTime
        end


        if self.AniName == "" or self.AniName == "-1" then
            log("---   error:HomeSceneCarMeshHelper   aniname = nil, anitype = ", self.AniType)
            HomeSceneCarMeshHelper:Get():LoadCar()
        else
            PrefabCacheMgr:Get():SwapPrefabAsync(self.AniName, nil, nil,function (param, obj)
                HomeSceneCarMeshHelper:Get():LoadAniFinish(param, obj)
            end, nil)
        end
    else
        HomeSceneCarMeshHelper:Get():LoadCar()
    end
end


function HomeSceneCarMeshHelper:LoadAniFinish(param, obj)
    if obj == nil then
        self:ErrorEnd()
        return
    end

    self.AniObj = obj
    self.AniObj:SetActive(false)

    HomeSceneCarMeshHelper:Get():LoadCar()
end


function HomeSceneCarMeshHelper:LoadCar()
    if self.SelfCarId > -1 and CarDataManager:Get():GetCarDataByCarID(self.SelfCarId) then
        TeamCacheManager:Get():GetCarByCarId(self.SelfCarId, function (buildid)
            if self.LoadType==CarLoadType.One then
                self.BuildID = buildid
            elseif self.LoadType==CarLoadType.More then
                table.insert(self.BuildGroup,buildid)
            end

            CarBuilderManager:Get():SetParent(buildid, self:GetCarRoot(false))
            local obj = CarBuilderManager:Get():GetCarRoot(buildid)

            HomeSceneCarMeshHelper:Get():LoadCarFinish(obj)
            self:CarAssembleOver(buildid)
        end)
    else
        local param = CarBuilderParam()
        param.buildType = CarBuilderType.Data
        param.parts = self.PartDataList
        param.lightweight = self.Lightweight
        param.grids = self.Grids
        param.colorid = self.Colorid
        param.stickerid = self.Stickerid
        param.combineType = CombineType.None
        param.parent = self:GetCarRoot(false)

        param.finishEvt = function(id, obj)
            log("----   HomeSceneCarMeshHelper.LoadCar   ", id, obj)
            CarBuilderManager:Get():SetParent(id, self:GetCarRoot(false))
            HomeSceneCarMeshHelper:Get():LoadCarFinish(obj)
            self:CarAssembleOver(id)
        end
        if self.LoadType==CarLoadType.One then
            self.BuildID = CarBuilderManager:Get():BuildCar(param)
        elseif self.LoadType==CarLoadType.More then
            table.insert(self.BuildGroup,CarBuilderManager:Get():BuildCar(param))
        end
    end

end

function HomeSceneCarMeshHelper:LoadCarFinish(obj)
    if self.AniType ~= AnimateType.None and self.AniName~="-1" then
        UIUtil.SetParentGameObject(self:GetAniRoot(), self.AniObj)
        self.AniObj:SetActive(true)

        TimerManager:Get():CreateTimer(self.AniTime,function()
            HomeSceneCarMeshHelper:Get():OnEnd()
        end)
    else
        HomeSceneCarMeshHelper:Get():OnEnd(obj)
    end
end

function HomeSceneCarMeshHelper:OnEnd(obj)
    self.IsLoading = false

    local tar = nil
    if self.AniType ~= AnimateType.None and self.AniName~="-1" then tar = self.AniObj
    else tar = self:GetCarRoot(false) end


    self:SetMeshCtrl(true, tar)

    self:StopTimer()
end


function HomeSceneCarMeshHelper:GetAniRoot()
    if self.sceneType == SceneChangeID.Garage then
        return HomeSceneHelper:GetTimeLineRoot_Blue()
    end
    if self.sceneType == SceneChangeID.Garage_New then
        return HomeSceneHelper:GetTimeLineRoot_Garage_New()
    end
    if self.sceneType == SceneChangeID.SelectCar then
        return HomeSceneHelper:GetTimeLineRoot_Yellow()
    end

end

function HomeSceneCarMeshHelper:GetCarRoot(flag)
    if self.AniType ~= AnimateType.None and not flag and  self.AniName~="-1" then
        if self.AniType == AnimateType.Garage then
            local carroot=UIUtil.GetChild(SceneHome_CarRoot, self.AniObj)
            carroot.transform.localScale=self:GetCarRoot(true).transform.localScale
            return carroot
        elseif self.AniType == AnimateType.MainCity then
            local carroot=UIUtil.GetChild(SceneMainCity_CarRoot,self.AniObj)
            carroot.transform.localScale=self:GetCarRoot(true).transform.localScale
            return carroot
        end
    else
        if self.sceneType == SceneChangeID.RefitTable then
            return HomeSceneHelper:GetCarRoot_RefitTable()
        end
        if self.sceneType == SceneChangeID.SelectCar then
            return HomeSceneHelper:GetCarRoot_SelectCar()
        end
        if self.sceneType == SceneChangeID.Garage then
            return HomeSceneHelper:GetCarRoot_GarageBlue()
        end
        if self.sceneType == SceneChangeID.Garage_New then
            return HomeSceneHelper:GetCarRoot_GarageNew()
        end

        if self.sceneType == SceneChangeID.MainCity then
            return HomeSceneHelper:GetCarRoot_MainCity()
        end
        if self.sceneType == SceneChangeID.MainCity_New then
            return HomeSceneHelper:GetCarRoot_MainCity_New()
        end
       if self.sceneType == SceneChangeID.MainCity_NewNight then
            return HomeSceneHelper:GetCarRoot_MainCity_NewNight()
        end
        if self.sceneType == SceneChangeID.MainCity_Autumn then
            return HomeSceneHelper:GetCarRoot_MainCity_Autumn()
        end
        if self.sceneType == SceneChangeID.RoleInfo then
            return HomeSceneHelper:GetCarRoot_RoleInfo(self.SelfCarIdx)
        end
        if self.sceneType == SceneChangeID.RankingList then
            return HomeSceneHelper:GetCarRoot_RankList()
        end
        if self.sceneType == SceneChangeID.MainRankingList then
            return HomeSceneHelper:GetCarRoot_MainRankList()
        end
        if self.sceneType == SceneChangeID.RaceRank then
            return HomeSceneHelper:GetCarRoot_RaceRank()
        end
        if self.sceneType == SceneChangeID.RaceTrot_Vs then
            return HomeSceneHelper:GetSelfCarRoot_RaceTrot_Vs()
        end
        if self.sceneType == SceneChangeID.RaceRankSelectCar then
            return HomeSceneHelper:GetSelfCarRoot_RaceRank_SelectCar()
        end
        if self.sceneType == SceneChangeID.PersonalHome then
            return HomeSceneHelper:GetCarRoot_PersonalHome(self.SelfCarIdx)
        end
    end
end

function HomeSceneCarMeshHelper:SetMeshCtrl(enable, tar,sceneType)
    if self.sceneType~="" then sceneType=self.sceneType end
    if enable then
        if sceneType == SceneChangeID.Garage then HomeSceneHelper:SetMeshCtrl_Blue(true, tar) end
        if sceneType == SceneChangeID.Garage_New then HomeSceneHelper:SetMeshCtrl_GarageNew(true, tar) end
        if sceneType == SceneChangeID.SelectCar then HomeSceneHelper:SetMeshCtrl_Yellow(true, tar) end
        if sceneType == SceneChangeID.RefitTable then HomeSceneHelper:SetMeshCtrl_Tamiya(true, tar) end
        if sceneType == SceneChangeID.MainCity then HomeSceneHelper:SetMeshCtrl_MainCity(true, tar) end
        if sceneType == SceneChangeID.MainCity_New then HomeSceneHelper:SetMeshCtrl_MainCityNew(true, tar) end
        if sceneType == SceneChangeID.MainCity_NewNight then HomeSceneHelper:SetMeshCtrl_MainCityNewNight(true, tar) end
        if sceneType == SceneChangeID.MainCity_Autumn then HomeSceneHelper:SetMeshCtrl_MainCity_Autumn(true, tar) end
        if sceneType == SceneChangeID.RaceRank then HomeSceneHelper:SetMeshCtrl_RaceRank(true, tar) end
        if sceneType == SceneChangeID.MainRankingList then HomeSceneHelper:SetMeshCtrl_MainRankingList(true, tar) end
    else
        HomeSceneHelper:SetMeshCtrl_Blue(false)
        HomeSceneHelper:SetMeshCtrl_Yellow(false)
        HomeSceneHelper:SetMeshCtrl_Tamiya(false)
        HomeSceneHelper:SetMeshCtrl_MainCity(false)
        HomeSceneHelper:SetMeshCtrl_GarageNew(false)
        HomeSceneHelper:SetMeshCtrl_MainCityNew(false)
        HomeSceneHelper:SetMeshCtrl_MainCityNewNight(false)
        HomeSceneHelper:SetMeshCtrl_RaceRank(false)
        HomeSceneHelper:SetMeshCtrl_MainRankingList(false)
        HomeSceneHelper:SetMeshCtrl_MainCity_Autumn(false)
    end
end


function HomeSceneCarMeshHelper:ErrorEnd()
    print("---   Error:HomeSceneCarMeshHelper:ErrorEnd")
    self:ClearCache()
    self:StopTimer()
end

function HomeSceneCarMeshHelper:ClearCache()
    self:SetMeshCtrl(false)

    self.sceneType = ""
    self.IsPlayEnterAni = true
    self.IsLoading = false
    if self.LoadType==CarLoadType.One then
        if self.SelfCarId and CarDataManager:Get():GetCarDataByCarID(self.SelfCarId) then
            TeamCacheManager:Get():Recycle(self.BuildID)
        else
            CarBuilderManager:Get():Recycle(self.BuildID)
        end
    else
        for i = 1, #self.BuildGroup do
            TeamCacheManager:Get():Recycle(self.BuildGroup[i])
        end
    end

    self.SelfCarId = -1

    if self.AniObj then PrefabCacheMgr:Get():RecyclePrefab(self.AniObj) end
    self.AniType = AnimateType.None
    self.AniName = ""
    self.AniTime = 0

    self.BuildID = -1
    self.AniObj = nil
end

function HomeSceneCarMeshHelper:BeginWaitingTimer()
    self:StopTimer()
    self.timerId = TimerManager:Get():CreateTimer(10, function()
        self:WaitingOvertime()
    end)
    CommonHelper:PlayScreenEffectNull(true)
end
function HomeSceneCarMeshHelper:WaitingOvertime()
    log("---   error:HomeSceneCarMeshHelper overtime... ")
    self:ErrorEnd()
end
function HomeSceneCarMeshHelper:StopTimer()
    TimerManager:Get():StopTimer(self.timerId)
    self.timerId = -1
    CommonHelper:PlayScreenEffectNull(false)
end

function HomeSceneCarMeshHelper:Break()
    if self.AniType ~= AnimateType.None and self.AniName ~= "" then
        PrefabCacheMgr:Get():Break(self.AniName)
    end
    self:ClearCache()
    self:StopTimer()
end

function HomeSceneCarMeshHelper:QuickBreak()
    self:ClearCache()
    self:StopTimer()
end











--{{{外部接口

--{{{ 通过cardata加载车
---@param cardata CarData
function HomeSceneCarMeshHelper:SetDataByCarData(cardata, scene, AniType,isCleatCache)
    if cardata == nil then return end
    if isCleatCache == nil then isCleatCache=true end

    if self.IsLoading then return end

    if isCleatCache then self:ClearCache() end
    self.LoadType=CarLoadType.One
    self.sceneType = scene

    self.AniType = AniType or AnimateType.None
    self.SelfCarId = cardata:GetID()
    self.SelfCarIdx = cardata:GetCarIdx()
    self.PartDataList = cardata:GetPartDataList()
    self.CarShellCfg = cardata:GetShellCfg(true)
    self.Lightweight = cardata:GetLightweight()
    self.Grids = cardata:GetShellGridList()
    self.Colorid = cardata:GetShellColor()
    self.Stickerid = cardata:GetShellSticker()
    self:BeginLoad()
end
--}}}
--{{{ 加载玩家所有车
---@param cardata CarData
function HomeSceneCarMeshHelper:LoadAllCar(scene)
    self.sceneType = scene
    if self.IsLoading then return end
    self.AniType =AnimateType.None
    self.LoadType=CarLoadType.More
    for i = 1, #CarDataManager:Get():GetCarList() do
        local cardata=CarDataManager:Get():GetCarDataByIndex(i)
        if  cardata.LockState ==ParkingLotState.Open then
            self.SelfCarId = cardata:GetID()
            self.SelfCarIdx = cardata:GetCarIdx()
            self.PartDataList = cardata:GetPartDataList()
            self.CarShellCfg = cardata:GetShellCfg(true)
            self:BeginLoad()
        end
    end
end
--}}}



---@param data CarReviewData
function HomeSceneCarMeshHelper:SetDataByCarReviewData(data , scene,AniType)
    if data == nil then
        return
    end
    if self.IsLoading then self:ErrorEnd() end
    self.LoadType=CarLoadType.One
    self:ClearCache()


    self.sceneType = scene
    self.AniType = AniType or AnimateType.None

    self.SelfCarId = -1
    self.PartDataList = data:GetPartList()
    self.Lightweight = data:GetLightweight()
    self.Grids = data:GetGrids()
    self.Colorid = data:GetColorId()
    self.Stickerid = data:GetStickerid()
    self.CarShellCfg = data:GetShellCfg(true)


    self:BeginLoad()
end

--{{{配件预览
---@param article ArticleCell
function HomeSceneCarMeshHelper:ReviewPart(article, grooveid,isorg)
        if article then
            local partid = article:GetPartConfig().C_ID
            local composeids = article:GetPartComposeIds()
            local generation=article:GetGeneration()
            --if article:GetPartType() == PartType.Shell then
                local sticker = article:GetPartShellSticker()
                local grids = article:GetPartShellGridList()
                local color = article:GetPartShellColor()
                local lightweight = article:GetPartLightweight()
                if isorg==false and article:GetChangeIdx()>0 then
                    partid = article:GetChangeIdx()
                    sticker = article:GetPartChangeShellSticker()
                    grids = article:GetPartChangeShellGridList()
                    color = article:GetPartChangeShellColor()
                    lightweight = article:GetPartChangeLightweight()
                end
                CarBuilderManager:Get():ReviewPart(self.BuildID, grooveid, partid, composeids, generation,sticker, grids, color, lightweight)
            --else
            --    CarBuilderManager:Get():ReviewPart(self.BuildID, grooveid, partid, composeids,generation)
            --end
        end
end
--}}}
---@param article ArticleCell
function HomeSceneCarMeshHelper:ReviewPartByCfgId(id,article, grooveid)
    if article then
        local partid = id
        local composeids = article:GetPartComposeIds()
        local generation=article:GetGeneration()
        --if article:GetPartType() == PartType.Shell then
            local sticker = article:GetPartShellSticker()
            local grids = article:GetPartShellGridList()
            local color = article:GetPartShellColor()
            local lightweight = article:GetPartLightweight()
            CarBuilderManager:Get():ReviewPart(self.BuildID, grooveid, partid, composeids, generation,sticker, grids, color, lightweight)
       -- else
            --CarBuilderManager:Get():ReviewPart(self.BuildID, grooveid, partid, composeids,generation)
        --end

    end
end
--}}}

---@param article PartData
function HomeSceneCarMeshHelper:ReviewPartCfg(article, grooveid)
    if article then
        local partid = article.PartCfg.C_ID
        local composeids = {}
        --if article.PartBaseCfg.parttype == PartType.Shell then
            local sticker = 0
            local grids = {0,0,0,0,0}
            local color = 0
            local lightweight = {true,true,true,true,true}
            CarBuilderManager:Get():ReviewPart(self.BuildID, grooveid, partid, composeids, 1,sticker, grids, color, lightweight)
        --else
            --CarBuilderManager:Get():ReviewPart(self.BuildID, grooveid, partid, composeids,1)
        --end

    end
end
--}}}

--{{{打孔预览
function HomeSceneCarMeshHelper:ReviewHole(selectidx)
    CarBuilderManager:Get():ReviewHole(self.BuildID, selectidx)
end
--}}}

--{{{染色预览
function HomeSceneCarMeshHelper:RebuildColor(id)
    CarBuilderManager:Get():ReviewColor(self.BuildID, id)
end
--}}}

--{{{贴纸预览
function HomeSceneCarMeshHelper:RebuildSticker(partid,generation,id)
    local sticker = id
    CarBuilderManager:Get():ReviewPart(self.BuildID, PartGrooveID.Shell, partid, { } ,generation, sticker, nil, nil, nil)
end
--}}}
--{{{配件贴纸预览
function HomeSceneCarMeshHelper:RebuildPartSticker(grooveID,partid,generation,id)
    local sticker = id
    CarBuilderManager:Get():ReviewPart(self.BuildID, grooveID, partid, { } ,generation, sticker, nil, nil, nil)
end
--}}}

--{{{纱网预览
function HomeSceneCarMeshHelper:RebuildGrid(idx, gridid)
    CarBuilderManager:Get():ReviewGrid(self.BuildID, idx, gridid)
end
--}}}

--{{{
function HomeSceneCarMeshHelper:ResetCar()
    MeshCacheMgr:Get():ReleaseUnusedMesh()
    MatCacheDataMgr:Get():RecycleUnusedMaterial()

end
--}}}
--{{{
function HomeSceneCarMeshHelper:QucikReBuild()
    CarBuilderManager:Get():RecycleTextureBuyId(self.BuildID)
    CarBuilderManager:Get():QucikReBuild(self.BuildID)
end
--}}}
--{{{
---@param data CarReviewData
function HomeSceneCarMeshHelper:QucikReBuildCarReviewData(data)
    CarBuilderManager:Get():RecycleTextureBuyId(self.BuildID)
    self.PartDataList = data:GetPartList()
    self.Lightweight = data:GetLightweight()
    self.Grids = data:GetGrids()
    self.Colorid = data:GetColorId()
    self.Stickerid = data:GetStickerid()
    self.CarShellCfg = data:GetShellCfg(true)
    local param = CarBuilderParam()
    param.buildType = CarBuilderType.Data
    param.parts = self.PartDataList
    param.lightweight = self.Lightweight
    param.grids = self.Grids
    param.colorid = self.Colorid
    param.stickerid = self.Stickerid
    param.combineType = CombineType.None
    param.parent = self:GetCarRoot(false)
    CarBuilderManager:Get():QucikReBuild(self.BuildID,param)
end
--}}}
---@param data CarData
function HomeSceneCarMeshHelper:QucikReBuildCarData(data)
    CarBuilderManager:Get():RecycleTextureBuyId(self.BuildID)
    self.PartDataList = data:GetPartDataList()
    self.Lightweight = data:GetLightweight()
    self.Grids = data:GetShellGridList()
    self.Colorid = data:GetShellColor()
    self.Stickerid = data:GetShellSticker()
    self.CarShellCfg = data:GetShellCfg(false)
    local param = CarBuilderParam()
    param.buildType = CarBuilderType.Data
    param.parts = self.PartDataList
    param.lightweight = self.Lightweight
    param.grids = self.Grids
    param.colorid = self.Colorid
    param.stickerid = self.Stickerid
    param.combineType = CombineType.None
    param.parent = self:GetCarRoot(false)
    CarBuilderManager:Get():QucikReBuild(self.BuildID,param)
end
--}}}

function HomeSceneCarMeshHelper:CarAssembleOver(index)
    if self.sceneType==SceneChangeID.PersonalHome then
        if index == PlayerPrefsHelper:GetValue_MainMenuViewCarIndex() then
            local curCar = CarBuilderManager:Get():GetCarBuilder(index)
            PersonalHomeDataManager:Get():InitCarReplica(curCar.Root)
        end
    end
end


function HomeSceneCarMeshHelper:TestA(idx)
    CarBuilderManager:Get():Combine(self.BuildID)
end
function HomeSceneCarMeshHelper:TestB(idx)
    CarBuilderManager:Get():ReverseCombine(self.BuildID)
end



