




local __ID = 0


---@class CarBuilder
CarBuilder = class("CarBuilder")

function CarBuilder:initialize()
    __ID = __ID + 1
    self.ID = __ID
    self.BuildType = CarBuilderType.None   --1.加载默认车 2.根据组装系统加载车 3.配件列表组装车
    self.LoadProgress = 1
    self.finishEvt = nil
    self.finishParam = nil
    self.RebuildFinishEvt = nil
    self.RebuildFinishParam = nil
    self.CombineType = CombineType.None
    self.isLoading = false
    self.newCarID = -1
    self.tableID = -1
    self.suitID = -1
    self.Parent = nil
    self.Root = nil
    --self.PartIDs = {}
    --self.PartList = {}
    ---@type table<number, CarBuilderPartData>
    self.PartDataList = {}
    ---@type CarBuilderAppearanceData
    self.AppearanceData = CarBuilderAppearanceData()
    --self.ChassisType = ChassisType.Error
    self.Lightweight = {true,true,true,true,true}
    self.ShellGrids = {}
    self.ShellColorID = 0
    self.StickerID = 0
    self.DefaultSticker = ""
    self.TempStickerMat = nil
    self.TempGridMat = nil
    self.TempHoleMat = nil
    ---@type ChassisDummyMap
    self.DummyPointMap = nil
    --self.UsingMeshObjects = {}
    --self.UsingMeshDict = {}
    ---@type table<number, CarBuilderMeshKey>
    self.MeshKeyList = {}
    self.UsingMaterials = {}
    self.UsingShellMat = nil
    self.MutliMeshDict = {}
    self.IsColor=0

    self.ShellAdditionWheels = nil


    self.ShellBaker = nil
    self.GridsBaker = nil
    self.MetalBaker = nil
    self.PlasticBaker = nil
    self.TyreBaker = nil
    self.VertexBaker = {}
    self.TextureBakers = {}
    self.CombinePreccess = 0
    self.CombineMax = -1
    self.FlagCombine = false



    self.cs_Start = nil
    self.timerId = -1


end



----------------------------------------------------------------------------

function CarBuilder:AddMaterial(mat)
    table.insert(self.UsingMaterials, mat)
end


function CarBuilder:AddMeshObj(key, mesh)
    --table.insert(self.UsingMeshObjects, mesh)

    --if key then
    --    if self.UsingMeshDict[key] == nil then self.UsingMeshDict[key] = {} end
    --    local temp = self.UsingMeshDict[key]
    --    table.insert(temp, mesh)
    --end

end


function CarBuilder:EnableCar(enable)
    if self.Root then
        if GameObjectIsNull(self.Root) then
            print("---   Error:EnableCar   self.Root = nil")
        elseif enable == nil  then
            print("---   Error:EnableCar   enable = nil")
        else
            self.Root:SetActive(enable)
        end
    end
end


--------------------------------------回收
function CarBuilder:Recycle_Destory()
    self:RecycleIcon()
    self:BreakBuild()
    self:ResetCenter()
    self:ReverseCombine()
    self:RecycleCombinePrefab()
    self:RemoveMatRelevance()
    self:RecycleShellAdditionWheels()
    self:RecycleAllObj()
    self:RecycleAllMaterial()
    self:ClearCache()
end
--function CarBuilder:Recycle_Save()
--    self:ReverseCombine()
--    self:RecycleAllObj()
--    self:ClearCache()
--end

function CarBuilder:ClearCache()
    self.BuildType = CarBuilderType.None
    self.LoadProgress = 1
    self.finishEvt = nil
    self.finishParam = nil
    self.CombineType = CombineType.None
    self.isLoading = false
    self.newCarID = -1
    self.tableID = -1
    self.suitID = -1
    self.Root = nil
    self.Parent = nil
    self.PartDataList = {}

    self.Lightweight = 0
    self.ShellGrids = {}
    self.ShellColorID = 0
    self.StickerID = 0
    self.DefaultSticker = ""
    self.TempStickerMat = nil
    self.TempGridMat = nil
    self.TempHoleMat = nil
    self.DummyPointMap = {}
    self.MeshKeyList = {}
    --self.UsingMeshObjects = {}
    --self.UsingMeshDict = {}
    self.UsingMaterials = {}
    self.UsingShellMat = nil
    self.MutliMeshDict = {}


    self.cs_Start = nil


    self.ShellBaker = nil
    self.GridsBaker = nil
    self.MetalBaker = nil
    self.PlasticBaker = nil
    self.TyreBaker = nil
    self.VertexBaker = {}
    self.CombinePreccess = 0
    self.CombineMax = -1



    self:StopTimer()


end
--------------------------------------回收




------------------------------------------------------------------计算配件列表












------------------------------------------------------------------计算配件列表






------------------------------------------------------------------计算车壳贴纸配置

------------------------------------------------------------------计算车壳贴纸配置





function CarBuilder:BuilderCar(isrebuild)
    if self.isLoading then
        log("---   BuilderCar Error")
        return
    end

    CarBuilderManager:Get():AddBuildMask()

    self.isLoading = true
    self.LoadProgress = 0


    self:StartTimer()

    self:RemoveMatRelevance()
    self:ReverseCombine()
    self:RecycleCombinePrefab()
    self:RecycleShellAdditionWheels()
    self:RecycleAllObj()
    self:RecycleAllMaterial()

    self:LoadAssets()

    self:CoroutineStart(isrebuild)
end

function CarBuilder:CoroutineStart(isrebuild)
    ---@param carbuilder CarBuilder
    self.cs_Start = cs_coroutine.start(function(carbuilder)

        local loadProcess = function(meshresname, metresname)
            local maxcount = 0
            local finishcount = 0
            for i = 1, #meshresname do
                if meshresname[i] ~= "" then
                    maxcount = maxcount + 1
                    if MeshCacheMgr:Get():IsLoadFinish(meshresname[i]) then
                        finishcount = finishcount + 1
                    end
                end
            end
            for i = 1, #metresname do
                if metresname[i] ~= "" then
                    maxcount = maxcount + 1
                    if MatCacheDataMgr:Get():IsLoadFinish(metresname[i]) then
                        finishcount = finishcount + 1
                    end
                end
            end
            local per = finishcount / maxcount
            self.LoadProgress = per * 0.6
            return per
        end

        local meshres = CarBuilderHelper:AnalyseAllMeshRes(carbuilder.PartDataList,self.StickerID)
        local metres = CarBuilderHelper:AnalyseAllMaterialRes(carbuilder.DefaultSticker, carbuilder.StickerID, carbuilder:GetShellGrid(), carbuilder.PartDataList)
        while loadProcess(meshres, metres) < 1  do
            coroutine.yield()
        end

        carbuilder:StartBuild(isrebuild)
    end,self)
end

function CarBuilder:LoadAssets()
    local resname = CarBuilderHelper:AnalyseAllMeshRes(self.PartDataList,self.StickerID)
    for i = 1, #resname do
        MeshCacheMgr:Get():LoadMesh(resname[i])
    end

    resname = CarBuilderHelper:AnalyseAllMaterialRes(self.DefaultSticker, self.StickerID, self:GetShellGrid(), self.PartDataList)
    for i = 1, #resname do
        MatCacheDataMgr:Get():LoadMaterial(resname[i])
    end
end


function CarBuilder:StartBuild(isrebuild)

    log("---   开始分步组装")
    self:BuildDummy()
    self:BuildPart(PartGrooveID.Shell)
    if not self:CheckSingleShell() then
        self:BuildPart(PartGrooveID.Chassis)
        self:BuildPart(PartGrooveID.Gears)
        self:BuildPart(PartGrooveID.Motor)


        self:BuildPart(PartGrooveID.FHub)
        self:BuildPart(PartGrooveID.BHub)

        self:BuildPart(PartGrooveID.FTyre)
        self:BuildPart(PartGrooveID.BTyre)


        self:BuildPart(PartGrooveID.Head)
        if self:CheckMsChassis() then
            self:BuildPart(PartGrooveID.Wing)
            self:BuildPart(PartGrooveID.Middle)
            self:BuildPart(PartGrooveID.PulleyMiddleCenter)
            self:BuildPart(PartGrooveID.PulleyMiddleButtom1)
            self:BuildPart(PartGrooveID.PulleyMiddleMinus)
        end
        self:BuildPart(PartGrooveID.Tail)

        self:BuildPart(PartGrooveID.Front)
        self:BuildPart(PartGrooveID.Front2)
        self:BuildPart(PartGrooveID.Front3)



        self:BuildPart(PartGrooveID.Rear)
        self:BuildPart(PartGrooveID.Rear2)
        self:BuildPart(PartGrooveID.Rear3)

        self:BuildPart(PartGrooveID.FrontExtr2)
        self:BuildPart(PartGrooveID.FrontExtr3)

        self:BuildPart(PartGrooveID.RearExtr2)
        self:BuildPart(PartGrooveID.RearExtr3)


        self:BuildPart(PartGrooveID.PulleyFrontCenter)
        self:BuildPart(PartGrooveID.PulleyFrontButtom)
        self:BuildPart(PartGrooveID.PulleyFrontMinus)



        self:BuildPart(PartGrooveID.PulleyRearCenter)
        self:BuildPart(PartGrooveID.PulleyRearButtom)
        self:BuildPart(PartGrooveID.PulleyRearMinus)



        self:BuildPart(PartGrooveID.PulleyShell)

        self:BuildPart(PartGrooveID.FBrake)
        self:BuildPart(PartGrooveID.BBrake)

        self:BuildPart(PartGrooveID.Strong1)
        self:BuildPart(PartGrooveID.Strong2)
        self:BuildPart(PartGrooveID.Strong3)
        self:BuildPart(PartGrooveID.Strong4)
        --self:BuildPart(PartGrooveID.Strong5)
        --self:BuildPart(PartGrooveID.Strong6)
        --self:BuildPart(PartGrooveID.Strong7)
        --self:BuildPart(PartGrooveID.Strong8)



        --底盘默认模型
        self:BuildShellLock(self:GetChassisDefaultMeshID(1))
        self:BuildDefaultPart(self:GetChassisDefaultMeshID(2),nil)
        self:BuildDefaultPart(self:GetChassisDefaultMeshID(3), PartChildType.WheelAxle)
        self:BuildDefaultPart(self:GetChassisDefaultMeshID(4), PartChildType.ChassisBearing)
        self:BuildDefaultPart(self:GetChassisDefaultMeshID(5), PartChildType.DriveAxle)
        self:BuildDefaultPart(self:GetChassisDefaultMeshID(6), nil)
        self:BuildChassisSwitch(self:GetChassisDefaultMeshID(7), nil)
    end





    self:BuildShellGrid()
    self:BuildSticker(self:GetSticker())
    self:BuildShellColor(self:GetShellColor())
    self:BuildLightweight(self:GetLightweight())
    if not self:CheckSingleShell() then
        self:BuildWings()
    end
    self:BuildSingleShellWheel()

    --切换shader高低配
    self:ChangeShader()


    self:ResetBodyPos()
    self:ResetBodyPosRot()

    self:SetCSharpCarDataResource()

    --self:BuildMeshBaker()

    log("---   分步组装完成")
    self.LoadProgress = 0.7
    self:DisableShellAnim()
    self:OnBuildFinish(isrebuild)
end

function CarBuilder:GetProgress()
    return self.LoadProgress
end

function CarBuilder:OnBuildFinish(isrebuild)
    self.cs_Start = nil
    self.isLoading = false
    self:StopTimer()
    CarBuilderManager:Get():RemoveBuildMask()
    if self.Root == nil then
        log("---   Error:Car BuilderFinish!!!     Root = nil.......")
        return
    end
    self.Root:SetActive(true)

    if self.CombineType ~= CombineType.None then
        self:Combine(function()
            self:OnCombineFinish(isrebuild)
        end)
    else
        self:OnCombineFinish(isrebuild)
    end

end

function CarBuilder:OnCombineFinish(isrebuild)
    self.LoadProgress = 1
    if self.IsBuildTexture and self.CarIcon==nil then
        self:BuilderTexture()
    end
    if self.Parent then
        UIUtil.SetParentGameObject(self.Parent, self.Root)
    else
        UIUtil.SetParentGameObject(MeshCacheMgr:Get():GetRoot(), self.Root)
    end

    if isrebuild then if self.RebuildFinishEvt then self.RebuildFinishEvt(self.ID,self.Root,self.RebuildFinishParam) end  return end

    if self.finishEvt then
        self.finishEvt(self.ID, self.Root, self.finishParam)
    end
end


function CarBuilder:BreakBuild()
    if self.cs_Start then
        cs_coroutine.stop(self.cs_Start)
        self.cs_Start = nil
    end
end











function CarBuilder:GetPartDataID(grooveid)
    local partid = -1
    if self.PartDataList[grooveid] then
        partid = self.PartDataList[grooveid]:GetPartID()
    end
    return partid
end
function CarBuilder:GetPartDataGeneration(grooveid)
    local generation = -1
    if self.PartDataList[grooveid] then
        generation = self.PartDataList[grooveid]:GetGeneration()
    end
    return generation
end
function CarBuilder:GetPartSticker(grooveid)
    local sticker = 0
    if self.PartDataList[grooveid] then
        sticker = self.PartDataList[grooveid]:GetSticker()
    end
    return sticker
end


---@return dictcardetail_config_cell
function CarBuilder:GetCfg_CarEquipment(carid)

    if self.BuildType == CarBuilderType.Table then
        ---@type dictcardetail_config_cell
        local carcfg = CommonHelper:GetTableDataByID(ConfigNames.dictcardetail_config,carid)
        return carcfg
    end

end


function CarBuilder:GetMeshCfgResNameById(id)
    if id == nil or id == 0 or id == -1 then return "" end

    ---@type meshcfg_config_cell
    local tempcfg = CommonHelper:GetTableDataByID(ConfigNames.meshcfg_config, id)
    if tempcfg then return tempcfg.mesh end
    return ""
end

---@return parts_config_cell
function CarBuilder:GetPartCfg(partId)
    ---@type parts_config_cell
    local partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partId)
    return partCfg
end
---@return dictpartbase_config_cell
function CarBuilder:GetPartBaseCfg(partId)
    ---@type dictpartbase_config_cell
    local partCfg = CommonHelper:GetPartBaseCfg(partId)
    return partCfg
end
---@return dictpartcell_config_cell
function CarBuilder:GetPartCellCfg(partId)
    ---@type dictpartbase_config_cell
    local partCfg = CommonHelper:GetPartCellCfg(partId)
    return partCfg
end

---@return meshcfg_config_cell
function CarBuilder:GetPartMeshCfg(partId,generation,groove,stickerid)

    ---@type dictparts_config
    local partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partId)
    if partCfg == nil then
        return nil
    end
    ---@type meshcfg_config_cell
    local meshCfg = CarBuilderHelper:GetPartMeshCfg(partId,generation,groove,stickerid)
    return meshCfg
end
---@return dictpartcell_config_cell
function CarBuilder:GetCarShellCfg(partId)
    ---@type parts_config_cell
    local partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partId)
    if partCfg == nil then
        return nil
    end
    ---@type dictpartbase_config_cell
    local partBaseCfg = CommonHelper:GetTableDataByID(ConfigNames.dictpartbase_config, partCfg.baseid)
    if partBaseCfg == nil then
        return nil
    end
    ---@type carshell_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictpartcell_config, partBaseCfg.NewShellId)
    return cfg
end

---@return apcolor_config_cell
function CarBuilder:GetColorResCfg(id)
    ---@type apcolor_config_cell
    local colorrescfg = CommonHelper:GetTableDataByID(ConfigNames.apcolor_config, id )
    if colorrescfg == nil then
        return nil
    end

    return colorrescfg
end
function CarBuilder:GetPartMeshRenderNameList(partid,generation,groove,stickerid)
    ---@type parts_config_cell
    local partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partid)
    if partCfg and partCfg.recource ~= 0 and partCfg.recource ~= -1 then
        ---@type meshcfg_config_cell
        local meshCfg = CarBuilderHelper:GetPartMeshCfg(partid,generation,groove,stickerid)
        if meshCfg then
            return meshCfg.NewMeshmatch
        end
    end
    return nil
end
function CarBuilder:GetPartMatName(partId,generation,groove)
    ---@type parts_config_cell
    local partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partId)
    if partCfg and partCfg.recource ~= 0 and partCfg.recource ~= -1 then
        ---@type meshcfg_config_cell
        local meshCfg = CarBuilderHelper:GetPartMeshCfg(partId,generation,groove,self.StickerID)
        if meshCfg then
            return meshCfg.meshcolor
        end
    end
    return ""
end











function CarBuilder:StartTimer()
    self:StopTimer()
    ---@param class CarBuilder
    self.timerId = TimerManager:Get():CreateTimer(10, function(class)
        class:BuildOvertime()
    end, self)
end
function CarBuilder:StopTimer()
    TimerManager:Get():StopTimer(self.timerId)
    self.timerId = -1
end

function CarBuilder:BuildOvertime()
    self:StopTimer()
    log("---   error:carbuilder overtime...   type,id = ",self.BuildType, self.newCarID, self.tableID, self.suitID)
    CarBuilderManager:Get():RemoveBuildMask()
end

function CarBuilder:BuilderTexture()
    local  cineachineState=CSCinemachineCameraManager.Get().IsEnable
    CSCinemachineCameraManager.Get():SetCineMachineCameraActive(false)
    UIUtil.SetParentGameObject( self:GetCarRoot(),self.Root,true)
    local localScale=self.Root.transform.localScale
    self.Root.transform.localScale=Vector3.one
    local layer= self.Root.layer
    mono.SetLayerName( self.Root,"RaceTrot")
    self.CarIcon=RtHelper:CreateUI3DIcon(self.Root,self:GetCameraRoot(), "RaceTrot", "car_texture"..self.ID,CarTextIconSizeWidth,CarTextIconSizeHigh)
    mono.SetLayer( self.Root,layer)
    UIUtil.SetParentGameObject(self.Parent, self.Root)
    self.Root.transform.localScale=localScale
    CSCinemachineCameraManager.Get():SetCineMachineCameraActive(cineachineState)
    cs_coroutine.start(function()

    end)
end
function CarBuilder:GetCarRoot()
    local Root=UIUtil.GetChild("CarRt/car_root", RtHelper:GetRoot())
    return Root
end

function CarBuilder:GetCameraRoot()
    local Root=UIUtil.GetChild("CarRt/camera_root",RtHelper:GetRoot())
    return Root
end
function CarBuilder:RecycleIcon()
    if self.CarIcon then
        CS.UnityEngine.Object.Destroy(self.CarIcon)
        self.CarIcon=nil
    end
end
