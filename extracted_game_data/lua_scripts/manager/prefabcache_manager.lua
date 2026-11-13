


---@class PrefabCacheMgr
PrefabCacheMgr = class("PrefabCacheMgr")

function PrefabCacheMgr:initialize()
    self.Instance = nil
    self.Root = nil
    ---@type table<number, PrefabCacheData>
    self.AssetMap = {}
    self:OnInit()
end
---@return PrefabCacheMgr
function PrefabCacheMgr:Get()
    if self.Instance == nil then self.Instance = PrefabCacheMgr() end
    return self.Instance
end

function PrefabCacheMgr:OnInit()
    if self.Root == nil then
        self.Root = GameObject.Find("PrefabCacheRoot");
        if self.Root == nil then
            self.Root = GameObject("PrefabCacheRoot");
            GameObject.DontDestroyOnLoad(self.Root);
        end
    end
end

function PrefabCacheMgr:MoveToRoot(obj)
    if self.Root == nil then print("---   error:PrefabCacheRoot = nil") return end
    if obj == nil then print("---   error: PrefabCacheMgr:MoveToRoot   obj = nil") return end

    obj:SetActive(false)
    UIUtil.SetParentGameObject(self.Root, obj)
end

---@return PrefabCacheData
function PrefabCacheMgr:AddCacheData(resName, assetlv, objcachelv)
    assetlv = assetlv or MeshAssetLV.Max
    objcachelv = objcachelv or MeshObjCacheLV.Default
    local data = self.AssetMap[resName]
    if data == nil then
        data = PrefabCacheData()
        data:InitData(resName, assetlv, objcachelv)
        self.AssetMap[resName] = data
    end
    return data
end

function PrefabCacheMgr:SwapPrefab(resName)
    local data = self.AssetMap[resName]
    if data then
        local result = data:Swap()
        if result then result:SetActive(true) end
        return result
    end
end

function PrefabCacheMgr:SwapPrefabAsync(resName, assetlv, objcachelv, finishevt, param, class)
    local data = self:AddCacheData(resName, assetlv, objcachelv)
    if data then
        data:SwapAsync(finishevt, param, class)
    end
end

function PrefabCacheMgr:LoadPrefab(resName, assetlv, objcachelv)
    local data = self:AddCacheData(resName, assetlv, objcachelv)
    data:LoadPrefab(resName)
end

function PrefabCacheMgr:AssetLoadFinish(resName, istouch)
    local data = self.AssetMap[resName]
    if data == nil then
        return false
    end
    return data:LoadAssetFinish(istouch)
end

function PrefabCacheMgr:RecyclePrefab(obj)
    if obj == nil then print("---   error:PrefabCacheMgr:RecycleMesh   obj = nil") return end

    local name = obj.name
    local data = self.AssetMap[name]

    if data == nil then
        for k,v in pairs(self.AssetMap) do
            if v and v:IsRef(obj) then
                data = v
                break
            end
        end
    end

    if data ~= nil then
        data:Recycle(obj)
        self:MoveToRoot(obj)
    end
end

function PrefabCacheMgr:DestoryMesh(obj)
    if obj == nil then print("---   error:PrefabCacheMgr:DestoryMesh   obj = nil") return end

    local name = obj.name
    local data = self.AssetMap[name]

    if data == nil then
        for k,v in pairs(self.AssetMap) do
            if v and v:IsRef(obj) then
                data = v
                break
            end
        end
    end

    if data ~= nil then
        data:DestoryPrefab(obj)
    end
end

function PrefabCacheMgr:ReleaseAllMesh()
    for k,v in pairs(self.AssetMap) do
        if v ~= nil then
            v:DestoryAllPrefab()
        end
    end
end

function PrefabCacheMgr:Break(resname)
    local data = self.AssetMap[resname]
    if data then data:Break() end
end

function PrefabCacheMgr:AdvanceLoad()
    for k,v in pairs(AdvanceLoad_Prefabs) do
        PrefabCacheMgr:Get():LoadPrefab(v)
    end
end
function PrefabCacheMgr:AdvanceLoadProgress()
    for k,v in pairs(AdvanceLoad_Prefabs) do
        if self.AssetMap[v] and not self.AssetMap[v]:IsLoadFinish() then
            return false
        end
    end
    return true
end

