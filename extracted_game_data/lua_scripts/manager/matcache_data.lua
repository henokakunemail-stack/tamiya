


---@class MatCacheData @材质球的缓存数据包括 bundle资源 从bundle中实例化的材质球实例 资源名字
MatCacheData = class("MatCacheData")
function MatCacheData:initialize()
    self.ID = -1
    self.ResName = ""

    self.Asset = nil
    self.MatInstance = nil
end

function MatCacheData:InitData(resName, assetLV, objLV)
    self.ID = -1
    self.ResName = resName
end

function MatCacheData:SetLoadCache(finishevt, param, class)
    self.FinishEvt = finishevt
    self.Param = param
    self.Class = class
end
function MatCacheData:TouchFinishEvt(result)
    if self.FinishEvt then
        if self.Class then
            self.FinishEvt(self.Class, self.Param, result)
        else
            self.FinishEvt(self.Param, result)
        end
    end
    self:SetLoadCache(nil,nil,nil)
end

function MatCacheData:LoadMaterial(resName)
    if self.Asset == nil then
        print("加载材质",resName)
        self.Asset = AssetsManager.LoadAsync(resName, typeof(Material))
        self.Asset:AddComplete(function(asset)
            MatCacheDataMgr:Get():AssetLoadFinish(asset.name, false)
        end)
    end
end

----实例化该材质球
function MatCacheData:Swap()
    if self.Asset == nil or self.Asset.asset == nil then return nil end

    self.MatInstance = CommonHelper:InstantiateMaterialByObject(self.Asset.asset)
    return self.MatInstance
end

function MatCacheData:SwapAsync(finishevt, param, class)
    if self.FinishEvt then
        log("---   error:MatCacheData repeat load asset, name = ",self.ResName)
        return
    end
    if finishevt == nil then return end

    local result = self:Swap()

    self:SetLoadCache(finishevt, param, class)
    if result then
        self:TouchFinishEvt(result)
        return
    end

    self:LoadAsset()
end

function MatCacheData:LoadAsset() -- 外部不可调用
    if self.Asset == nil then
        self.Asset = AssetsManager.LoadAsync(self.ResName, typeof(Material))
        self.Asset:AddComplete(function(asset)
            MatCacheDataMgr:Get():AssetLoadFinish(asset.name, true)
        end)
    end
end

function MatCacheData:LoadAssetFinish(isTouchEvt)
    if self.Asset == nil then log("---   Error:MatCacheData   Asset = null,  resname = ",self.ResName) end

    if self.Asset.asset == nil then
        log("---   Error:MatCacheData   Asset gameobject = null,  resname = ",self.ResName)
    else
        if isTouchEvt then
            self.MatInstance = CommonHelper:InstantiateMaterialByObject(self.Asset.asset)
            self:TouchFinishEvt(self.MatInstance)
        end
    end
end

----检查两个材质球是不是同一个
function MatCacheData:CheckInstaceID(mat)
    if self.MatInstance and mat then
        if self.MatInstance:GetInstanceID() == mat:GetInstanceID() then
            return true
        end
    end
    return false
end

function MatCacheData:IsLoadFinish()
    local result = (self.Asset ~= nil and self.Asset.asset ~= nil)
    return result
end

function MatCacheData:Recycle()

end

----卸载材质球
function MatCacheData:DestoryMaterial()

    if self.Asset then
        print("------卸载材质球:但是没有销毁材质球的gameObject",self.ResName,debug.traceback())
        AssetsManager.Unload(self.Asset)
        self.MatInstance = nil
        self.Asset = nil
    end
end

