---@class CarBuilderParam
CarBuilderParam = class("CarBuilderParam")
function CarBuilderParam:initialize()
    self.newCarId = -1
    self.tableID = -1
    self.suitID = -1
    self.buildType = CarBuilderType.None--1.加载默认车 2.根据组装系统加载车 3.玩家数据组装车
    self.parent = nil
    self.finishEvt = nil
    self.finishParam = nil
    self.combineType = CombineType.None
    ---@type table<number, Lua_PartData>
    self.parts = {} -- 玩家配件数据
    self.lightweight = {false,false,false,false,false}  -- 玩家轻量化数据
    self.grids = {} -- 玩家纱网数据
    self.colorid = 0 -- 玩家车壳染色数据
    self.stickerid = 0 -- 玩家贴纸数据
    self.BuilderTexture=false
end

-------------------------------------------------------------------------------

local __instance

---@class CarBuilderManager
CarBuilderManager = class("CarBuilderManager")

function CarBuilderManager:initialize()
    ---@type table<number,CarBuilder>
    self.BuilderDic = {}

    ---@type table<number, CarBuilder>
    self.BuilderCache = {}---builder 缓存

    self.MaskRef = 0
end

---@return CarBuilderManager
function CarBuilderManager:Get()
    if __instance then
        return __instance
    end
    __instance = CarBuilderManager()
    return __instance
end

---@param param CarBuilderParam
function CarBuilderManager:BuildCar(param)
    --if self:CheckCarID(param.newCarId) == false then return -1 end

    if param.buildType == CarBuilderType.None then
        log("---   Error:BuildType = None")
        return -1
    end

    ---@type CarBuilder
    local result = self:SampleBuilder(param)
    if result == nil then
        log("---   Error:CarBuilder = nil")
        return -1
    end
    result:RecycleShellAdditionWheels()
    if result:GetProgress() >= 1 then
        result:BuilderCar()
    else
        log("---   Error:车没加载完，重复加载，检查数据", param.buildType, param.newCarId, param.tableID, param.suitID)
    end

    return result.ID
end

---@param param CarBuilderParam
function CarBuilderManager:QucikReBuild(id, param)
    local builder = self.BuilderDic[id]
    if builder == nil then
        return
    end
    builder:RecycleShellAdditionWheels()
    builder:AnalyseData(param)
    builder:BuilderCar(true)
end

function CarBuilderManager:CheckCarID(newCarId)
    --local carid = CommonHelper:AnalyseCarId(newCarId)

    if CommonHelper:GetTableDataByID(ConfigNames.car_config, newCarId) then
        return true
    end
    return false
end

---@param param CarBuilderParam
function CarBuilderManager:SampleBuilder(param)
    ---@type CarBuilder
    local result
    if #self.BuilderCache > 0 then
        result = self.BuilderCache[1]
        table.remove(self.BuilderCache, 1)
    else
        result = CarBuilder()
    end
    result:SetParam(param)
    self.BuilderDic[result.ID] = result
    return result
end

----根据Id 回收builder ，同时回收模型和材质
---@param carbuilder CarBuilder
function CarBuilderManager:Recycle(ID)
    local builder = self.BuilderDic[ID]
    if builder == nil then
        return
    end

    self.BuilderDic[ID] = nil
    table.insert(self.BuilderCache, builder)
    builder:Recycle_Destory()
end

----显示车辆
---@param carbuilder CarBuilder
function CarBuilderManager:EnableCar(ID, enable)
    local builder = self.BuilderDic[ID]
    if builder == nil then
        return
    end
    builder:EnableCar(enable)
end

----根据合批类型 合并材质 或者顶点
function CarBuilderManager:Combine(ID)
    if self.BuilderDic[ID] ~= nil then
        self.BuilderDic[ID]:Combine()
    end
end

function CarBuilderManager:ReverseCombine(ID)
    if self.BuilderDic[ID] ~= nil then
        self.BuilderDic[ID]:ReverseCombine()
    end
end

function CarBuilderManager:GetLoadProgress(ID)
    if self.BuilderDic[ID] ~= nil then
        return self.BuilderDic[ID]:GetProgress()
    end
    return 1
end

----预览贴纸，先加载材质球
function CarBuilderManager:ReviewSticker(ID, stickerid)
    if stickerid == nil or stickerid == -1 then
        return
    end
    ---@type apsticker_config_cell
    local stickercfg = CommonHelper:GetTableDataByID(ConfigNames.apsticker_config, stickerid)
    if stickercfg ~= nil then
        MatCacheDataMgr:Get():SwapMaterialAsync(stickercfg.NewMat, nil, nil, function(param, mat)
            CarBuilderManager:Get():LoadStickerFinish(param, mat)
        end, ID)
    end
end

----加载完贴纸材质球之后，给车壳赋颜色，设置贴纸材质球，重新合批
function CarBuilderManager:LoadStickerFinish(ID, mat)
    if self.BuilderDic[ID] ~= nil then
        self.BuilderDic[ID]:BuildTempSticker(mat)
        self.BuilderDic[ID]:BuildShellColor(self:GetColorID(ID))
        self.BuilderDic[ID]:ReCombine()
    end
end

----纱网预览
function CarBuilderManager:ReviewGrid(ID, idx, gridid)
    ---@type apgrid_config_cell
    local gridcfg = CommonHelper:GetTableDataByID(ConfigNames.apgrid_config, gridid)
    if gridcfg ~= nil then
        MatCacheDataMgr:Get():SwapMaterialAsync(gridcfg.NewMat, nil, nil, function(param, mat)
            CarBuilderManager:Get():LoadGridFinish(param[1], param[2], param[3], mat,true)
        end, { ID, idx, gridid })
    end
end

function CarBuilderManager:LoadGridFinish(ID, idx, gridid, mat,isReview)
    isReview =isReview or false
    if self.BuilderDic[ID] ~= nil then
        self.BuilderDic[ID]:BuildTempGrid(idx, gridid, mat,isReview)
        self.BuilderDic[ID]:ReCombine()
    end
end

----预览车壳颜色
function CarBuilderManager:ReviewColor(ID, colorid)
    if self.BuilderDic[ID] ~= nil then
        self.BuilderDic[ID]:BuildShellColor(colorid)
        self.BuilderDic[ID]:ReCombine()
    end
end
----打孔预览
function CarBuilderManager:ReviewHole(ID, selectidx)
    if self.BuilderDic[ID] ~= nil then
        MatCacheDataMgr:Get():SwapMaterialAsync(ShellHoleSelectMat, nil, nil, function(param, mat)
            CarBuilderManager:Get():LoadHoleFinish(param[1], param[2], mat)
        end, { ID, selectidx })
    end
end
function CarBuilderManager:LoadHoleFinish(ID, selectidx, mat)
    if self.BuilderDic[ID] ~= nil then
        self.BuilderDic[ID]:BuildTempHole(selectidx, mat)
        self.BuilderDic[ID]:BuildShellColor(self:GetColorID(ID))
        self.BuilderDic[ID]:ReCombine()
    end
end

----预览车 主界面
function CarBuilderManager:ReviewPart(ID, grooveid, partid, composeids, generation,sticker, grids, color, lightweight,rebuildEvt,param)
    if self.BuilderDic[ID] == nil then
        return
    end
    local builder = self.BuilderDic[ID]
    builder:RecycleShellAdditionWheels()
    if builder.BuildType == CarBuilderType.Assemble then
        builder:AnalysePartList_Assemble() --拿到背包最新数据
    end

    if rebuildEvt then
        builder.RebuildFinishEvt=rebuildEvt
    end
    if param then
        builder.RebuildFinishParam=param
    end

    for k, v in pairs(PartGrooveID) do
        if grooveid == v then
            builder:CreatePartData(v, partid, composeids,generation,sticker)
        end
    end

    if sticker == nil then
        sticker = builder:GetSticker()
    end
    if grids == nil then
        grids = builder:GetShellGrid()
    end
    if color == nil then
        color = builder:GetShellColor()
    end
    if lightweight == nil then
        lightweight = builder:GetLightweight()
    end
    if grooveid==PartGrooveID.Shell then
        if builder.BuildType == CarBuilderType.Table then
            builder:AnalyseSticker()
            builder:AnalyseDefaultColor()
        elseif builder.BuildType == CarBuilderType.Assemble then
            builder:AnalyseSticker(sticker)
            builder:AnalyseShellGrid(grids)
            builder:AnalyseShellColor(color)
            builder:AnalyseLightweight(lightweight)
            builder:AnalyseDefaultColor()
        elseif builder.BuildType == CarBuilderType.Data then
            builder:AnalyseLightweight(lightweight)
            builder:AnalyseShellGrid(grids)
            builder:AnalyseShellColor(color)
            builder:AnalyseSticker(sticker)
            builder:AnalyseDefaultColor()
        end
    end
    builder:BuilderCar(true)
end

function CarBuilderManager:GetCarRoot(id)
    if self.BuilderDic[id] == nil then
        return nil
    end
    return self.BuilderDic[id].Root
end

function CarBuilderManager:GetFinishParam(id)
    if self.BuilderDic[id] == nil then
        return nil
    end
    return self.BuilderDic[id].finishParam
end
function CarBuilderManager:GetCarBuilder(id)
    if self.BuilderDic[id] == nil then
        return nil
    end
    return self.BuilderDic[id]
end

function CarBuilderManager:SetParent(id, parent)
    if self.BuilderDic[id] == nil then
        return
    end
    self.BuilderDic[id].Parent = parent
    if parent  and self.BuilderDic[id].Root then
        UIUtil.SetParentGameObject(parent, self.BuilderDic[id].Root)
    end
end

----根据id 获取车壳颜色id
function CarBuilderManager:GetColorID(id)
    if self.BuilderDic[id] == nil then
        return -1
    end
    return self.BuilderDic[id]:GetShellColor()
end

----车辆构建的时候添加蒙版，防止点击
function CarBuilderManager:AddBuildMask()
    self.MaskRef = self.MaskRef + 1
    if self.MaskRef > 0 and (not UIManager:Get():IsPersistentViewShow("CarBuildMaskView")) then
        UIManager:Get():ShowPersistentView("CarBuildMaskView", CanvasType.TopCanvas, "CarBuildMaskView")
    end
    --log("---   ^^^   AddBuildMask", self.MaskRef)
end
function CarBuilderManager:RemoveBuildMask()
    self.MaskRef = self.MaskRef - 1
    if self.MaskRef == 0 then
        UIManager:Get():HidePersistentView("CarBuildMaskView")
    end
    --log("---   ^^^   RemoveBuildMask", self.MaskRef)
end
function CarBuilderManager:RecycleTextureBuyId(ID)
    if self.BuilderDic[ID] == nil then
        return
    end
    local builder = self.BuilderDic[ID]
    builder:RecycleIcon()
end
