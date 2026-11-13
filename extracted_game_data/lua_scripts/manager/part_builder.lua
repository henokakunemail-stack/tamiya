





---@class PartBuilder  @构建part
PartBuilder = class("PartBuilder")

function PartBuilder:initialize()
    self.Instance = nil
    self.Dummy = nil


    self.Isloading = false
    self.cs_Start = nil

    self.partId = 0
    self.composeIds = {}
    self.parent = nil
    self.finishEvt = nil
    self.param = nil

    self.partPrefab = nil
    self.usingMat = {}

end

function PartBuilder:Get()
    if self.Instance == nil then
        self.Instance = PartBuilder()
    end
    return self.Instance
end


function PartBuilder:BuildPart(partid, composeids, parent, finish, param)
    if self.Isloading then return end

    if self.partPrefab then self:RecyclePart() end


    self:StartTimer()

    self.Isloading = true
    self.partId = partid
    self.parent = parent
    self.finishEvt = finish
    self.param = param

    self.composeIds = composeids

    if self.Dummy == nil then self:LoadDummy() return end

    self:LoadMesh()
end


function PartBuilder:LoadDummy()
    if self.Dummy == nil then
        PrefabCacheMgr:Get():SwapPrefabAsync(PartDummyPrefab,nil,nil,function (param, obj)
            PartBuilder:Get():LoadDummyFinish(param, obj)
        end)
    end
end

function PartBuilder:LoadDummyFinish(param, obj)
    self.Dummy = obj

    UIUtil.SetParentGameObject(UIManager:Get():GetMeshCanvasRoot(), self.Dummy)

    self:LoadMesh()
end





function PartBuilder:LoadMesh()
    PrefabCacheMgr:Get():SwapPrefabAsync(self:GetMeshResName(self.partId),nil,nil,function (param, obj)
        PartBuilder:Get():LoadMeshFinish(param, obj)
    end)
end

function PartBuilder:LoadMeshFinish(param, obj)
    self.partPrefab = obj

    self:LoadMatRes()
end

function PartBuilder:SetMeshParent()
    local cfg = self:GetPartCfg()
    local parent = nil
    if cfg.type == PartType.Chassis then parent = UIUtil.GetChild("chassis", self.Dummy) end
    if cfg.type == PartType.Shell   then parent = UIUtil.GetChild("shell", self.Dummy) end
    if cfg.type == PartType.Motor   then parent = UIUtil.GetChild("motor1", self.Dummy) end
    if cfg.type == PartType.Pulley  then parent = UIUtil.GetChild("pulley1", self.Dummy) end
    if cfg.type == PartType.Head  then parent = UIUtil.GetChild("head", self.Dummy) end
    if cfg.type == PartType.Wing  then parent = UIUtil.GetChild("wing", self.Dummy) end
    if cfg.type == PartType.Tail  then parent = UIUtil.GetChild("tail1", self.Dummy) end
    if cfg.type == PartType.Gears  then parent = UIUtil.GetChild("gears", self.Dummy) end
    if cfg.type == PartType.Hub  then parent = UIUtil.GetChild("hub", self.Dummy) end
    if cfg.type == PartType.Tyre  then parent = UIUtil.GetChild("tyre", self.Dummy) end
    if cfg.type == PartType.Rail  then parent = UIUtil.GetChild("pulley2", self.Dummy) end
    if cfg.type == PartType.Nail then parent = UIUtil.GetChild("pulley2", self.Dummy) end
    if cfg.type == PartType.Weight  then parent = UIUtil.GetChild("pulley2", self.Dummy) end
    if cfg.type == PartType.Stronger and cfg.type1 == PartChildType.SmallGear then parent = UIUtil.GetChild("smallgear", self.Dummy) end
    if cfg.type == PartType.Stronger and cfg.type1 == PartChildType.ConductiveSheet then parent = UIUtil.GetChild("conductivesheet", self.Dummy) end
    if cfg.type == PartType.Stronger and cfg.type1 == PartChildType.DriveAxle then parent = UIUtil.GetChild("driveaxle", self.Dummy) end
    if cfg.type == PartType.Stronger and cfg.type1 == PartChildType.WheelAxle then parent = UIUtil.GetChild("wheelaxle", self.Dummy) end
    if cfg.type == PartType.Stronger and cfg.type1 == PartChildType.ChassisBearing then parent = UIUtil.GetChild("bearing", self.Dummy) end

    UIUtil.SetParentGameObject(parent, self.partPrefab)
end


----返回part 贴纸 的材质球
function PartBuilder:AnalyseMatRes()
    local result = {}

    local sticker = self:GetStickerMatName()
    if sticker ~= "" then table.insert(result, sticker) end

    if self.composeIds and #self.composeIds > 0 then
        for i = 1, #self.composeIds do
            local matname = self:GetPartMatName(self.composeIds[i])
            if matname ~= "" then table.insert(result, matname) end
        end
    end

    return result
end

----加载mat的bundle
function PartBuilder:LoadMatRes()

    local matres = self:AnalyseMatRes()
    if #matres > 0 then
        self.cs_Start = cs_coroutine.start(function()
            local resname = PartBuilder:Get():AnalyseMatRes()

            for i = 1, #resname do
                if resname[i] ~= "" then MatCacheDataMgr:Get():LoadMaterial(resname[i]) end
            end

            for i = 1, #resname do
                if resname[i] ~= "" then
                    while MatCacheDataMgr:Get():IsLoadFinish(resname[i]) == false  do
                        coroutine.yield()
                    end
                end
            end

            PartBuilder:Get():LoadMatResFinish()
        end)
    else
        self:LoadMatResFinish()
    end
end

function PartBuilder:LoadMatResFinish()

    self.cs_Start = nil

    self:SetMatSticker()

    self:SetMatLabParts()

    self:OnFinish()
end

function PartBuilder:AddMatRef(mat)
    table.insert(self.usingMat, mat)
end

----实例化mat,把它赋给贴纸的prefab
function PartBuilder:SetMatSticker()
    local sticker = self:GetStickerMatName()
    if sticker == "" then return end

    local mat = MatCacheDataMgr:Get():SwapMaterial(sticker)
    if mat == nil then return end

    self:AddMatRef(mat)

    local m = UIUtil.GetGameobjectComponent(self.partPrefab, typeof(MeshRenderer))
    if not CommonHelper:GameObjectIsNull(m) then m.material = mat end
    for i = 1, ShellHoldCount do
        m = UIUtil.GetTypeChildWightByParent("hole_0"..i,self.partPrefab,typeof(MeshRenderer))
        if not CommonHelper:GameObjectIsNull(m) then m.material = mat end
    end
end

----给part 设置材质球
function PartBuilder:SetMatLabParts()
    if self.composeIds and #self.composeIds > 0 then

        local renderNames = self:GetPartMeshRenderNameList()
        if renderNames == nil then return end
        if #renderNames ~= #self.composeIds then
            print("---   error:PartBuilder:SetMatLabParts()   配件个数与meshrander个数不匹配",#renderNames , #self.composeIds)
            return
        end


        for i = 1, #self.composeIds do
            local matname = self:GetPartMatName(self.composeIds[i])
            if matname ~= "" then
                local mat = MatCacheDataMgr:Get():SwapMaterial(matname)
                if mat then
                    self:AddMatRef(mat)

                    local temp = renderNames[i]
                    for i = 1, #temp do
                        local m = UIUtil.GetTypeChildWightByParent(temp[i],self.partPrefab,typeof(MeshRenderer))
                        if not CommonHelper:GameObjectIsNull(m) then m.material = mat end
                    end

                end

            end
        end
    end
end

----设置父物体
function PartBuilder:OnFinish()
    self:StopTimer()

    if self.Dummy and self.parent then
        UIUtil.SetParentGameObject(self.parent, self.Dummy)
    else
        UIUtil.SetParentGameObject(UIManager:Get():GetMeshCanvasRoot(), self.Dummy)
    end

    self:SetMeshParent()

    self.Isloading = false
    if self.finishEvt then
        self.finishEvt(self.param)
    end

end









function PartBuilder:RecyclePart()
    if self.Isloading then return end

    self:ClearData()
end

function PartBuilder:ClearData()
    if self.partPrefab then
        PrefabCacheMgr:Get():RecyclePrefab(self.partPrefab)
    end
    self.partPrefab = nil

    for i = 1, #self.usingMat do
        MatCacheDataMgr:Get():RecycleMaterial(self.usingMat[i])
    end
    self.usingMat = {}

    if self.cs_Start then
        cs_coroutine.stop(self.cs_Start)
        self.cs_Start = nil
    end

    self.Isloading = false
    self.partId = 0
    self.parent = nil
    self.finishEvt = nil
    self.param = nil
    self.composeIds = {}

end







function PartBuilder:StartTimer()
    self:StopTimer()
    ---@param class PartBuilder
    self.timerId = TimerManager:Get():CreateTimer(10, function()
        PartBuilder:Get():BuildOvertime()
    end)
end
function PartBuilder:StopTimer()
    TimerManager:Get():StopTimer(self.timerId)
    self.timerId = -1
end

function PartBuilder:BuildOvertime()
    self:StopTimer()
    print("---   error:PartBuilder overtime...   id = ",self.partId)
    self:ClearData()
end












function PartBuilder:GetMeshResName(partId)
    ---@type parts_config_cell
    local partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partId)
    if partCfg and partCfg.recource ~= 0 and partCfg.recource ~= -1 then
        ---@type meshcfg_config_cell
        local meshCfg = CommonHelper:GetTableDataByID(ConfigNames.meshcfg_config, partCfg.recource)
        if meshCfg then
            return meshCfg.showmodel
        end
    end

    return "mesh_error.prefab"
end
----获取贴纸的的材质球prefab名字
function PartBuilder:GetStickerMatName()
    local cfg = self:GetPartCfg()
    if cfg.type == PartType.Shell then
        ---@type dictpartbase_config_cell
        local partBaseCfg = CommonHelper:GetTableDataByID(ConfigNames.dictpartbase_config, cfg.baseid)
        ---@type carshell_config_cell
        local shellcfg = CommonHelper:GetTableDataByID(ConfigNames.dictpartcell_config, partBaseCfg.NewShellId)
        ---@type apsticker_config_cell
        local stickercfg = CommonHelper:GetTableDataByID(ConfigNames.apsticker_config, shellcfg.defaultSticker)

        return stickercfg.NewMat
    end
    return ""
end
----根据partId 获取材质球part的材质球名字
function PartBuilder:GetPartMatName(partId)
    ---@type parts_config_cell
    local partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partId)
    if partCfg and partCfg.recource ~= 0 and partCfg.recource ~= -1 then
        ---@type meshcfg_config_cell
        local meshCfg = CommonHelper:GetTableDataByID(ConfigNames.meshcfg_config, partCfg.recource)
        if meshCfg then
            return meshCfg.meshcolor
        end
    end
    return ""
end
function PartBuilder:GetPartMeshRenderNameList()
    ---@type parts_config_cell
    local partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, self.partId)
    if partCfg and partCfg.recource ~= 0 and partCfg.recource ~= -1 then
        ---@type meshcfg_config_cell
        local meshCfg = CommonHelper:GetTableDataByID(ConfigNames.meshcfg_config, partCfg.recource)
        if meshCfg then
            return meshCfg.NewMeshmatch
        end
    end
    return nil
end
---@return parts_config_cell
function PartBuilder:GetPartCfg()
    local partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, self.partId)
    return partCfg
end