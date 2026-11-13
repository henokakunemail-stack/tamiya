


---@class MeshCacheData @mesh 的缓存数据 比如mesh名字 该mesh的下的所有挂点obj 该mesh的gameObject
MeshCacheData = class("MeshCacheData")
function MeshCacheData:initialize()
    self.ID = -1
    self.ResName = ""
    self.AssetLV = MeshAssetLV.Low
    self.ObjCacheLV = MeshObjCacheLV.Default

    self.Asset = nil ---¬从bundle中加载的资源
    self.UsingObjList = {}---当前mesh 使用的GameObject，key是obj的instanceId,value是obj
    self.ObjPool = {}
    ---@type table<number,ChassisDummyMap >
    self.DummyMapList = {}
    self.batchLoadMgr = BatchLoadManager()
end

----初始化mesh 缓存的prefab名字和缓存等级
function MeshCacheData:InitData(resName, assetLV, objLV,mgr)
    self.ID = -1
    self.ResName = resName
    self.AssetLV = assetLV or MeshAssetLV.Low
    self.ObjCacheLV = objLV or MeshObjCacheLV.Default
    self.Manager=mgr
end

----设置加载完资源的回调
function MeshCacheData:SetLoadCache(finishevt, param, class)
    self.FinishEvt = finishevt
    self.Param = param
    self.Class = class
end
----触发资源加载完的回调
function MeshCacheData:TouchFinishEvt(result, dummy)
    if self.FinishEvt then
        if self.Class then
            self.FinishEvt(self.Class, self.Param, result, dummy)
        else
            self.FinishEvt(self.Param, result, dummy)
        end
    end
    self:SetLoadCache(nil,nil,nil)
end

----如果缓存池里有，就从缓存池里取，要不然就实例化一个，返回该mesh obj 和它下面的挂点
---@return table , ChassisDummyMap
function MeshCacheData:Swap()
    -------------从缓存池取一个mesh,根据它的instanceID,添加到正在使用的objList里面
    local result
    if #self.ObjPool > 0 then
        result = self.ObjPool[1]
        table.remove(self.ObjPool, 1)

        if result then
            local objid = result:GetInstanceID()
            if self.UsingObjList[objid] then
                print("---   error: MeshCacheData 数据异常,resname = ",self.ResName)
                result = nil
            else
                self.UsingObjList[objid] = result
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

        self:AddDummyMap(result)
    end

    if result then
        local dummy = self.DummyMapList[result:GetInstanceID()]
        return result, dummy
    end

    return nil, nil
end

----目前没用
function MeshCacheData:SwapAsync(finishevt, param, class)
    if self.FinishEvt then
        print("---   error:MeshCacheData repeat load asset, name = ",self.ResName)
        return
    end
    if finishevt == nil then return end

    local result, dummy = self:Swap()

    self:SetLoadCache(finishevt, param, class)
    if result then
        self:TouchFinishEvt(result, dummy)
        return
    end

    self:LoadAsset()

end

----根据mesh名字 加载mesh 资源
function MeshCacheData:LoadMesh(resName)
    if self.Asset == nil then
        self.Asset = AssetsManager.LoadAsync(resName, typeof(GameObject))
        if self.Asset then
            self.Asset:AddComplete(function(asset)
                MeshCacheMgr:Get():AssetLoadFinish(asset.name, false)
            end)
        end
    end
end

----把该obj从UsingObjList移除，添加到缓存池里面
function MeshCacheData:Recycle(obj)
    if obj == nil then print("---   error:MeshCacheData:Recycle   obj = nil") return end


    local objid = obj:GetInstanceID()
    if self.UsingObjList[objid] == nil then print("---   error:回收了异常数据",self.ResName, obj.name) return end

    self.UsingObjList[objid] = nil
    table.insert(self.ObjPool, obj)
end

----当前是否在引用该obj
function MeshCacheData:IsRef(obj)
    if obj == nil then print("---   error:MeshCacheData:IsRef   obj = nil") return false end

    local objid = obj:GetInstanceID()
    return self.UsingObjList[objid] ~= nil
end

function MeshCacheData:IsLoadFinish()
    local result = (self.Asset ~= nil and self.Asset.asset ~= nil)
    return result
end

----根据缓存的 mesh prefab资源名字 加载资源，目前没用
function MeshCacheData:LoadAsset() -- 外部不可调用
    if self.Asset == nil then
        self.Asset = AssetsManager.LoadAsync(self.ResName, typeof(GameObject))
        self.Asset:AddComplete(function(asset)
            MeshCacheMgr:Get():AssetLoadFinish(asset.name, true)
        end)
    end
end

----加载完prefab之后，实例化，目前没用
function MeshCacheData:LoadAssetFinish(isTouchEvt)
    if self.Asset == nil then print("---   Error:MeshCacheData   Asset = null,  resname = ",self.ResName) end

    if self.Asset.asset == nil then
        print("---   Error:MeshCacheData   Asset gameobject = null,  resname = ",self.ResName)
    else

        if isTouchEvt then
            local result = CommonHelper:InstantiateGameObjectByObject(self.Asset.asset)
            result.name = self.ResName
            self:AddDummyMap(result)
            local objid = result:GetInstanceID()

            if self.UsingObjList[objid] == nil then
                self.UsingObjList[objid] = result
            else
                print("---   error:UnityBug")
                result = nil
            end
            local dummy = self.DummyMapList[objid]

            self:TouchFinishEvt(result, dummy)

        else
            --if self.UsingObjList[objid] ~= nil then print("---   error:预加载模型回收了异常数据",self.ResName, result.name) return end
            --self.UsingObjList[objid] = nil
            --table.insert(self.ObjPool, result)
            --
            --MeshCacheMgr:Get():MoveToRoot(result)
        end

    end
end


----如果这个mesh 是挂点，找到该mesh 下的所有挂点 obj ,添加到ChassisDummyMap里面
function MeshCacheData:AddDummyMap(obj)
    if obj == nil then print("---   error:MeshCacheData:AddDummyMap   obj = nil") return false end

    if not dummy_config.IsDummy(self.ResName) then return end

    local objid = obj:GetInstanceID()

    local dummy = ChassisDummyMap()


    -----找到该mesh obj下的所有挂点，并添加到dummy
    local points = CarAssembleRule:Get():GetDummyPointMap()
    for k,v in pairs(points) do
        local point = UIUtil.GetChild(v,obj)
        if point == nil then
            --print("---   error:dummy丢失挂点.   object = ",obj,"   point = ",v)
        else
            dummy.Map[v] = point
        end
    end


    if self.DummyMapList[objid] ~= nil then print("---   error:DummyMap 有脏数据") end

    self.DummyMapList[objid] = dummy
end


----销毁该物体，并卸载
function MeshCacheData:DestoryPrefab(obj)
    if obj == nil then print("---   error:MeshCacheData:Recycle   obj = nil") return end

    local objid = obj:GetInstanceID()
    if self.UsingObjList[objid] == nil then print("---   error:回收了异常数据",self.ResName, obj.name) return end

    self.UsingObjList[objid] = nil
    GameObject.DestroyImmediate(obj)
    --GameObject.Destroy(obj)

    if #self.ObjPool == 0 and self:IsUsing() == false then
        if self.Asset then
            print("---   error: MeshCacheData 卸载mesh ")
            AssetsManager.Unload(self.Asset)
            self.Asset = nil
        end

    end
end

function MeshCacheData:DestoryAllPrefab()
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
function MeshCacheData:DestoryPrefabOnlyOne()
    if #self.ObjPool<=1 then return end
    local NotUseObj={}
    for i = 1, #self.ObjPool do
        local flag=false
        for k,v in pairs(self.UsingObjList) do
            if v:GetInstanceID() == self.ObjPool[i]:GetInstanceID() then
                flag=true
            end
        end
        if not flag then
            table.insert(NotUseObj,i)
        end
    end
    print("------------->",#NotUseObj)
    for i = 1, #NotUseObj do
        GameObject.Destroy(self.ObjPool[NotUseObj[i]])
        self.ObjPool[NotUseObj[i]]=nil
    end
    for k, v in pairs(self.ObjPool) do
        if v==nil then
            print(k)
        end
    end
end

----遍历所有当前正在使用的物体，如果有当前正在使用的，就返回true，说明不能销毁
function MeshCacheData:IsUsing()
    for k,v in pairs(self.UsingObjList) do
        if v ~= nil then
            return true
        end
    end
    return false
end



---@class ChassisDummyMap @挂点映射表,key是 挂点的prefab 名字，value 是挂点gameObject
ChassisDummyMap = class("ChassisDummyMap")
function ChassisDummyMap:initialize()
    self.Map = {}
end


