


---@class MatCacheDataMgr
MatCacheDataMgr = class("MatCacheDataMgr")

function MatCacheDataMgr:initialize()
    self.Instance = nil
    ---@type table<string, MatCacheData>
    self.AssetMap = {}

end
function MatCacheDataMgr:Get()
    if self.Instance == nil then self.Instance = MatCacheDataMgr() end
    return self.Instance
end

----根据材质球名字，实例化材质球
function MatCacheDataMgr:SwapMaterial(resName)
    local data = self.AssetMap[resName]
    if data then
        local result = data:Swap()
        return result
    end
end

function MatCacheDataMgr:LoadMaterial(resName, assetlv, objcachelv)
    local data = self:AddCacheData(resName, assetlv, objcachelv)
    data:LoadMaterial(resName)
end

---@return MatCacheData
function MatCacheDataMgr:AddCacheData(resName, assetlv, objcachelv)
    assetlv = assetlv or MeshAssetLV.Max
    objcachelv = objcachelv or MeshObjCacheLV.Default
    local data = self.AssetMap[resName]
    if data == nil then
        data = MatCacheData()
        data:InitData(resName, assetlv, objcachelv)
        self.AssetMap[resName] = data
    end
    return data
end

function MatCacheDataMgr:SwapMaterialAsync(resName, assetlv, objcachelv, finishevt, param, class)
    local data = self:AddCacheData(resName, assetlv, objcachelv)
    if data then
        data:SwapAsync(finishevt, param, class)
    end
end

function MatCacheDataMgr:AssetLoadFinish(resName, istouch)
    local data = self.AssetMap[resName]
    if data == nil then
        return false
    end
    return data:LoadAssetFinish(istouch)
end

----回收车上的改材质球，并没有销毁材质球实例，只是卸载bundle
function MatCacheDataMgr:RecycleMaterial(mat, isdestory)
    if mat == nil then
        logError("---   error:MatCacheDataMgr:RecycleMaterial   mat = nil")
        return
    end

    if isdestory == nil then isdestory = true end

    ---@type MatCacheData
    local data = nil
    for k,v in pairs(self.AssetMap) do
        if v and v:CheckInstaceID(mat) then
            data = v
            break
        end
    end

    if data ~= nil then
        if isdestory and (not CarCacheManager:Get():CheckMatResCache(data.ResName)) then
            data:DestoryMaterial()
        else
            data:Recycle()
        end
    end
end

function MatCacheDataMgr:AdvanceLoad()
    for k,v in pairs(AdvanceLoad_Mats) do
        MatCacheDataMgr:Get():LoadMaterial(v)
    end
end

function MatCacheDataMgr:IsLoadFinish(resName)
    local data = self.AssetMap[resName]
    if data == nil then
        return false
    end
    return data:IsLoadFinish()
end
----卸载车上没有用到的材质球
function MatCacheDataMgr:RecycleUnusedMaterial()
    for k,v in pairs(self.AssetMap) do
        if (not CarCacheManager:Get():CheckMatResCache(v.ResName))then
            v:DestoryMaterial()
        end
    end
end
