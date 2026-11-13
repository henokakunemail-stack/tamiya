


---@class ExhibitCacheData @exhibit 的缓存数据 比如exhibit名字 该exhibit的下的所有挂点obj 该exhibit的gameObject
ExhibitCacheData = class("ExhibitCacheData")
function ExhibitCacheData:initialize()
    self.ID = -1
    self.ResName = ""
    self.AssetLV = ExhibitAssetLV.Low
    self.ObjCacheLV = ExhibitObjCacheLV.Default

    self.Asset = nil ---¬从bundle中加载的资源
    self.UsingObjList = {}---当前exhibit 使用的GameObject，key是obj的instanceId,value是obj
    self.ObjPool = {}
    self.batchLoadMgr = BatchLoadManager()
end

----初始化exhibit 缓存的prefab名字和缓存等级
function ExhibitCacheData:InitData(resName, assetLV, objLV)
    self.ID = -1
    self.ResName = resName
    self.AssetLV = assetLV or ExhibitAssetLV.Low
    self.ObjCacheLV = objLV or ExhibitObjCacheLV.Default
end

----设置加载完资源的回调
function ExhibitCacheData:SetLoadCache(finishevt, param, class)
    self.FinishEvt = finishevt
    self.Param = param
    self.Class = class
end
----触发资源加载完的回调
function ExhibitCacheData:TouchFinishEvt(result)
    if self.FinishEvt then
        if self.Class then
            self.FinishEvt(self.Class, self.Param, result)
        else
            self.FinishEvt(self.Param, result)
        end
    end
    self:SetLoadCache(nil,nil,nil)
end

----如果缓存池里有，就从缓存池里取，要不然就实例化一个，返回该exhibit obj 和它下面的挂点
---@return table
function ExhibitCacheData:Swap()
    -------------从缓存池取一个exhibit,根据它的instanceID,添加到正在使用的objList里面
    local result
    if #self.ObjPool > 0 then
        result = self.ObjPool[1]
        table.remove(self.ObjPool, 1)

        if result then
            local objId = result:GetInstanceID()
            if self.UsingObjList[objId] then
                print("---   error: ExhibitCacheData 数据异常,resname = ",self.ResName)
                result = nil
            else
                self.UsingObjList[objId] = result
            end
        end
    end

    -----如果该资源没有加载过，也就是没有缓存，就实例化一个新的，并把它添加到正在使用的列表里面
    if result == nil and self.Asset and self.Asset.asset then
        result = CommonHelper:InstantiateGameObjectByObject(self.Asset.asset)
        result.name = self.ResName

        local objid = result:GetInstanceID()
        if self.UsingObjList[objid] == nil then
            self.UsingObjList[objid] = result
        else
            print("---   error:UnityBug")
            result = nil
        end
    end

    if result then
        return result
    end

    return nil
end

----目前没用
function ExhibitCacheData:SwapAsync(finishevt, param, class)
    if self.FinishEvt then
        print("---   error:ExhibitCacheData repeat load asset, name = ",self.ResName)
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

----根据exhibit名字 加载exhibit 资源
function ExhibitCacheData:LoadExhibit(resName)
    if self.Asset == nil then
        self.Asset = AssetsManager.LoadAsync(resName, typeof(GameObject))
        log("resName  :",resName)
        self.Asset:AddComplete(function(asset)
            ExhibitCacheMgr:Get():AssetLoadFinish(asset.name, false)
        end)
    end
end

----把该obj从UsingObjList移除，添加到缓存池里面
function ExhibitCacheData:Recycle(obj)
    if obj == nil then print("---   error:ExhibitCacheData:Recycle   obj = nil") return end

    local objid = obj:GetInstanceID()
    if self.UsingObjList[objid] == nil then print("---   error:回收了异常数据",self.ResName, obj.name) return end

    self.UsingObjList[objid] = nil
    table.insert(self.ObjPool, obj)
end

----当前是否在引用该obj
function ExhibitCacheData:IsRef(obj)
    if obj == nil then print("---   error:ExhibitCacheData:IsRef   obj = nil") return false end

    local objid = obj:GetInstanceID()
    return self.UsingObjList[objid] ~= nil
end

function ExhibitCacheData:IsLoadFinish()
    local result = (self.Asset ~= nil and self.Asset.asset ~= nil)
    return result
end

----根据缓存的 exhibit prefab资源名字 加载资源，目前没用
function ExhibitCacheData:LoadAsset() -- 外部不可调用
    if self.Asset == nil then
        self.Asset = AssetsManager.LoadAsync(self.ResName, typeof(GameObject))
        self.Asset:AddComplete(function(asset)
            ExhibitCacheMgr:Get():AssetLoadFinish(asset.name, true)
        end)
    end
end

----加载完prefab之后，实例化，目前没用
function ExhibitCacheData:LoadAssetFinish(isTouchEvt)
    if self.Asset == nil then print("---   Error:ExhibitCacheData   Asset = null,  resname = ",self.ResName) end

    if self.Asset.asset == nil then
        print("---   Error:ExhibitCacheData   Asset gameobject = null,  resname = ",self.ResName)
    else

        if isTouchEvt then
            local result = CommonHelper:InstantiateGameObjectByObject(self.Asset.asset)
            result.name = self.ResName

            local objid = result:GetInstanceID()

            if self.UsingObjList[objid] == nil then
                self.UsingObjList[objid] = result
            else
                print("---   error:UnityBug")
                result = nil
            end

            self:TouchFinishEvt(result)

        else
            --if self.UsingObjList[objid] ~= nil then print("---   error:预加载模型回收了异常数据",self.ResName, result.name) return end
            --self.UsingObjList[objid] = nil
            --table.insert(self.ObjPool, result)
            --
            --ExhibitCacheMgr:Get():MoveToRoot(result)
        end

    end
end


----销毁该物体，并卸载
function ExhibitCacheData:DestoryPrefab(obj)
    if obj == nil then print("---   error:ExhibitCacheData:Recycle   obj = nil") return end

    local objId = obj:GetInstanceID()
    if self.UsingObjList[objId] == nil then print("---   error:回收了异常数据",self.ResName, obj.name) return end

    self.UsingObjList[objId] = nil
    GameObject.DestroyImmediate(obj)
    --GameObject.Destroy(obj)

    if #self.ObjPool == 0 and self:IsUsing() == false then
        if self.Asset then
            print("---   error: ExhibitCacheData 卸载exhibit ")
            AssetsManager.Unload(self.Asset)
            self.Asset = nil
        end

    end
end

function ExhibitCacheData:DestoryAllPrefab()
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

----遍历所有当前正在使用的物体，如果有当前正在使用的，就返回true，说明不能销毁
function ExhibitCacheData:IsUsing()
    for k,v in pairs(self.UsingObjList) do
        if v ~= nil then
            return true
        end
    end
    return false
end



