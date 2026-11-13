


---@class PrefabCacheData
PrefabCacheData = class("PrefabCacheData")
function PrefabCacheData:initialize()
    self.ID = -1
    self.ResName = ""
    self.AssetLV = MeshAssetLV.Max
    self.ObjCacheLV = MeshObjCacheLV.Default

    self.Asset = nil
    self.UsingObjList = {}
    self.ObjPool = {}

end

function PrefabCacheData:InitData(resName, assetLV, objLV)
    self.ID = -1
    self.ResName = resName
    self.AssetLV = assetLV or MeshAssetLV.Max
    self.ObjCacheLV = objLV or MeshObjCacheLV.Default
end

function PrefabCacheData:SetLoadCache(finishevt, param, class)
    self.FinishEvt = finishevt
    self.Param = param
    self.Class = class
end
function PrefabCacheData:TouchFinishEvt(result)
    if self.FinishEvt then
        if self.Class then
            self.FinishEvt(self.Class, self.Param, result)
        else
            self.FinishEvt(self.Param, result)
        end
    end
    self:SetLoadCache(nil,nil,nil)
end

function PrefabCacheData:Swap()
    local result
    if #self.ObjPool > 0 then
        result = self.ObjPool[1]
        table.remove(self.ObjPool, 1)

        if result then
            local objid = result:GetInstanceID()
            if self.UsingObjList[objid] then
                print("---   error: PrefabCacheData 数据异常,resname = ",self.ResName)
                result = nil
            else
                self.UsingObjList[objid] = result
            end
        end
    end

    if result == nil and self.Asset and self.Asset.asset then
        result = CommonHelper:InstantiateGameObjectByObject(self.Asset.asset)

        local objid = result:GetInstanceID()
        if self.UsingObjList[objid] == nil then
            self.UsingObjList[objid] = result
        else
            print("---   error:UnityBug")
            result = nil
        end
    end

    return result
end

function PrefabCacheData:IsLoadFinish()
    return self.Asset~=nil and self.Asset.isDone
end


function PrefabCacheData:SwapAsync(finishevt, param, class)
    if self.FinishEvt then
        print("---   error:PrefabCacheData repeat load asset, name = ",self.ResName)
        return
    end
    if finishevt == nil then return end

    local result = self:Swap()

    self:SetLoadCache(finishevt, param, class)
    if result then
        result:SetActive(true)
        self:TouchFinishEvt(result)
        return
    end

    self:LoadAsset()
end

function PrefabCacheData:LoadPrefab(resName)
    if self.Asset == nil then
        self.Asset = AssetsManager.LoadAsync(resName, typeof(GameObject))
        self.Asset:AddComplete(function(asset)
            PrefabCacheMgr:Get():AssetLoadFinish(asset.name, false)
        end)
    end
end

function PrefabCacheData:Recycle(obj)
    if obj == nil then print("---   error:PrefabCacheData:Recycle   obj = nil") return end

    local objid = obj:GetInstanceID()
    if self.UsingObjList[objid] == nil then print("---   error:回收了异常数据",self.ResName, obj.name) return end

    self.UsingObjList[objid] = nil
    table.insert(self.ObjPool, obj)
end

function PrefabCacheData:IsRef(obj)
    if obj == nil then print("---   error:PrefabCacheData:IsRef   obj = nil") return false end

    local objid = obj:GetInstanceID()
    return self.UsingObjList[objid] ~= nil
end

function PrefabCacheData:LoadAsset() -- 外部不可调用
    if self.Asset == nil then
        self.Asset = AssetsManager.LoadAsync(self.ResName, typeof(GameObject))
        self.Asset:AddComplete(function(asset)
            PrefabCacheMgr:Get():AssetLoadFinish(asset.name, true)
        end)
    end
end

function PrefabCacheData:LoadAssetFinish(isTouchEvt)
    if self.Asset == nil then print("---   Error:PrefabCacheData   Asset = null,  resname = ",self.ResName) end

    if self.Asset.asset == nil then
        print("---   Error:PrefabCacheData   Asset gameobject = null,  resname = ",self.ResName)
    else
        if isTouchEvt then
            local result = CommonHelper:InstantiateGameObjectByObject(self.Asset.asset)

            local objid = result:GetInstanceID()
            if self.UsingObjList[objid] == nil then
                self.UsingObjList[objid] = result
            else
                print("---   error:UnityBug")
                result = nil
            end

            result.name = self.ResName
            self:TouchFinishEvt(result)
        end
    end
end

function PrefabCacheData:DestoryPrefab(obj)
    if obj == nil then print("---   error:PrefabCacheData:Destory   obj = nil") return end

    local objid = obj:GetInstanceID()
    if self.UsingObjList[objid] == nil then print("---   error:回收了异常数据",self.ResName, obj.name) return end

    self.UsingObjList[objid] = nil
    GameObject.Destroy(obj)

    if #self.ObjPool == 0 and self:IsUsing() == false then
        if self.Asset then
            AssetsManager.Unload(self.Asset)
            self.Asset = nil
        end

    end
end

function PrefabCacheData:DestoryAllPrefab()
    if self:IsUsing() then return end

    for i = 1, #self.ObjPool do
        GameObject.Destroy(self.ObjPool[i])
    end
    self.ObjPool = {}
    if self.Asset then
        AssetsManager.Unload(self.Asset)
        self.Asset = nil
    end
end

function PrefabCacheData:Break()
    if self.Asset then
        AssetsManager.Unload(self.Asset)
        self.Asset = nil
    end
end

function PrefabCacheData:IsUsing()
    for k,v in pairs(self.UsingObjList) do
        if v ~= nil then
            return true
        end
    end
    return false
end