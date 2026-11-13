


---@class ExhibitCacheMgr
ExhibitCacheMgr = class("ExhibitCacheMgr")

function ExhibitCacheMgr:initialize()
    self.Instance = nil
    self.Root = nil
    ---@type table<string, ExhibitCacheData>@ key 是prefab的名字，value 是缓存数据
    self.AssetMap = {}
    ExhibitCacheMgr:OnInit()
end
function ExhibitCacheMgr:Get()
    if self.Instance == nil then self.Instance = ExhibitCacheMgr() end
    return self.Instance
end

----创建exhibit 缓存的根节点-->ExhibitCacheRoot
function ExhibitCacheMgr:OnInit()
    if self.Root == nil then
        self.Root = GameObject.Find("ExhibitCacheRoot");
        if self.Root == nil then
            self.Root = GameObject("ExhibitCacheRoot");
            GameObject.DontDestroyOnLoad(self.Root);
        end
    end
end
----把exhibit移到根节点下 关闭掉
function ExhibitCacheMgr:MoveToRoot(obj)
    if self.Root == nil then print("---   error:ExhibitCacheRoot = nil") return end
    if obj == nil then print("---   error:MoveToRoot   obj = nil") return end

    obj:SetActive(false)
    UIUtil.SetParentGameObject(self.Root, obj)
end

----以prefab 名字为key 添加缓存数据到assetMap里面
---@return ExhibitCacheData
function ExhibitCacheMgr:AddCacheData(resName, assetlv, objcachelv)
    assetlv = assetlv or ExhibitAssetLV.Max
    objcachelv = objcachelv or ExhibitObjCacheLV.Default
    local data = self.AssetMap[resName]
    if data == nil then
        data = ExhibitCacheData()
        data:InitData(resName, assetlv, objcachelv)
        self.AssetMap[resName] = data
    end
    return data
end

----根据prefab名字 加载模型，或者从缓存池里取，返回该模型
---@return table
function ExhibitCacheMgr:SwapExhibit(resName)
    local data = self.AssetMap[resName]
    if data then
        local result = data:Swap()
        if result then
            result:SetActive(true) ---由于box需要走初始化，下个版本手动初始化
        end
        return result
    end
    return nil
end

----目前没用
function ExhibitCacheMgr:SwapExhibitAsync(resName, assetlv, objcachelv, finishevt, param, class)
    local data = self:AddCacheData(resName, assetlv, objcachelv)
    if data then
        data:SwapAsync(finishevt, param, class)
    end
end

----根据prefab名字，先添加到缓存数据里面，再加载prefab
function ExhibitCacheMgr:LoadExhibit(resName, assetlv, objcachelv)
    local data = self:AddCacheData(resName, assetlv, objcachelv)
    data:LoadExhibit(resName)
end

function ExhibitCacheMgr:IsLoadFinish(resName)
    --local data = self:AddCacheData(resName, assetlv, objcachelv)
    --data:LoadExhibit(resName)
    local data = self.AssetMap[resName]
    if data == nil then
        return false
    end
    return data:IsLoadFinish()
end

function ExhibitCacheMgr:AssetLoadFinish(resName, istouch)
    local data = self.AssetMap[resName]
    if data ~= nil then
        data:LoadAssetFinish(istouch)
    end
end

----如果当前的obj 正在用着，且它是车上的exhibit 或者 是 挂点 就把它移到缓存的根目录下，否则就销毁
function ExhibitCacheMgr:RecycleExhibit(obj, isDestroy)
    if obj == nil then print("---   error:ExhibitCacheMgr:RecycleExhibit   obj = nil") return end

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
        self:MoveToRoot(obj)
        if isDestroy then
            data:DestoryPrefab(obj)
        else
            data:Recycle(obj)
            print("------只是回收exhibit，并没有卸载------")
        end
    end
end

function ExhibitCacheMgr:ReleaseAllExhibit()
    if self.AssetMap then
        for k,v in pairs(self.AssetMap) do
            if v ~= nil then
                v:DestoryAllPrefab()
            end
        end
    end
end

function ExhibitCacheMgr:GetRoot()
    return self.Root
end