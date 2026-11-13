local __instance
---@class CarCacheManager
CarCacheManager = class("CarCacheManager")
function CarCacheManager:initialize()
    ---@type table<string, boolean>
    self.MeshDic = {}
    ---@type table<string, boolean>
    self.MatDic = {}
end
---@return CarCacheManager
function CarCacheManager:Get()
    if __instance == nil then
        __instance = CarCacheManager()
    end
    return __instance
end

function CarCacheManager:InitData()
    self:UpdateCache()
    --self:AdvanceLoad()
end

function CarCacheManager:UpdateCache()
    self.MeshDic = {}
    self.MatDic = {}
    local list = CarDataManager:Get():GetCarList()
    for i = 1, #list do
        self:UpdateCacheByCardata(list[i])
    end
end

function CarCacheManager:AdvanceLoad()
    for k, v in pairs(self.MeshDic) do
        if v then
            MeshCacheMgr:Get():LoadMesh(k)
        else
            logError("---   error:CarCacheManager   存在异常数据, resname = " .. k .. "  value = " .. v)
        end
    end

    for k, v in pairs(self.MatDic) do
        if v then
            MatCacheDataMgr:Get():LoadMaterial(k)
        else
            logError("---   error:CarCacheManager   存在异常数据, resname = " .. k .. "  value = " .. v)
        end
    end
end

function CarCacheManager:ClearData()
    self.MeshDic = {}
    self.MatDic = {}
    --MeshCacheMgr:Get():ReleaseAllMesh()
end

----根据当前车辆的数据，更新车辆的缓存，也就是是否有这个mesh了
---@param cardata CarData
function CarCacheManager:UpdateCacheByCardata(cardata)
    local dufaultsticker = -1
    local stickerid = -1
    local grids = {}
    local partlist = {}
    if cardata.LockState==ParkingLotState.Open then
        local list = cardata:GetPartDataList()
        for i = 1, #list do
            local grooveid = AssembleHelper:MsgIdxToGrooveID(i)
            local temp = list[i]
            if temp then
                local data = CarBuilderPartData()
                data:SetData(temp.PartCfgID, temp.ComposeIds,temp.PartGeneration,temp.st)
                partlist[grooveid] = data
            end
        end

        if cardata:GetShellCfg() then
            dufaultsticker = cardata:GetShellCfg().defaultSticker
        end
        stickerid = cardata:GetShellSticker()
        grids = cardata:GetShellGridList()
    end

    self:SetDict(partlist, dufaultsticker, stickerid, grids)
end

function CarCacheManager:UpdateCacheBySuitID(id)
    local dufaultsticker = -1
    local stickerid = -1
    local grids = {}
    local partlist = {}
    self:SetDict(partlist, dufaultsticker, stickerid, grids)
end

----设置车的缓存数据，包括配件、连接件 和 材质球 如果有就为true
function CarCacheManager:SetDict(partlist, dufaultsticker, stickerid, grids)
    local reslist = CarBuilderHelper:AnalyseAllMeshRes(partlist,stickerid)
    for i = 1, #reslist do
        local resname = reslist[i]
        if resname == nil or resname == "" then
            logError("---   error:CarCacheManager:UpdateCarMesh   车模型资源缓存，resname = nil  or  resname = 空 ")
        else
            --logError("---   &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&   ",resname)
            self.MeshDic[resname] = true
        end
    end

    local metreslist = CarBuilderHelper:AnalyseAllMaterialRes(dufaultsticker, stickerid, grids, partlist)
    for i = 1, #metreslist do
        local resname = metreslist[i]
        if resname == nil or resname == "" then
            logError("---   error:CarCacheManager:UpdateCarMesh   车材质球缓存，resname = nil  or  resname = 空 ")
        else
            --logError("---   &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&   ",resname)
            self.MatDic[resname] = true
        end
    end
    self.MatDic[ShellHoleSelectMat] = true
end



----检查当前车上是不是有这个mesh
function CarCacheManager:CheckResCache(resname)
    if self.MeshDic[resname] then
        return true
    end
    return false
end

----检查当前车上是不是有这个材质球
function CarCacheManager:CheckMatResCache(resname)
    if self.MatDic[resname] then
        return true
    end
    return false
end
