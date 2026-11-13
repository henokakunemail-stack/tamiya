


---@class MeshCacheMgr
MeshCacheMgr = class("MeshCacheMgr")

function MeshCacheMgr:initialize()
    self.Instance = nil
    self.Root = nil
    ---@type table<string, MeshCacheData>@ key 是prefab的名字，value 是缓存数据
    self.AssetMap = {}
    ---对象池回收后保存时间
    self.DurTime=CS.UnityEngine.WaitForSeconds(60)
    self:OnInit()
end
function MeshCacheMgr:Get()
    if self.Instance == nil then self.Instance = MeshCacheMgr() end
    return self.Instance
end

----创建mesh 缓存的根节点-->MeshCacheRoot
function MeshCacheMgr:OnInit()
    if self.Root == nil then
        self.Root = GameObject.Find("MeshCacheRoot");
        if self.Root == nil then
            self.Root = GameObject("MeshCacheRoot");
            GameObject.DontDestroyOnLoad(self.Root);
        end
        self.DummyRoot = GameObject.Find("MeshCacheRoot/DummyRoot");
        if self.DummyRoot == nil then
            self.DummyRoot = GameObject("DummyRoot");
            UIUtil.SetParentGameObject(self.Root, self.DummyRoot)
            GameObject.DontDestroyOnLoad(self.DummyRoot);
        end
    end
end
----把mesh移到根节点下 关闭掉
function MeshCacheMgr:MoveToRoot(obj)
    if self.Root == nil then print("---   error:MeshCacheRoot = nil") return end
    if obj == nil then print("---   error:MoveToRoot   obj = nil") return end

    obj:SetActive(false)
    UIUtil.SetParentGameObject(self.Root, obj)
end

----以prefab 名字为key 添加缓存数据到assetMap里面
---@return MeshCacheData
function MeshCacheMgr:AddCacheData(resName, assetlv, objcachelv)
    assetlv = assetlv or MeshAssetLV.Max
    objcachelv = objcachelv or MeshObjCacheLV.Default
    local data = self.AssetMap[resName]
    if data == nil then
        data = MeshCacheData()
        data:InitData(resName, assetlv, objcachelv,self)
        self.AssetMap[resName] = data
    end
    return data
end

----根据prefab名字 加载模型，或者从缓存池里取，返回该模型 和 它下面的挂点
---@return table, ChassisDummyMap
function MeshCacheMgr:SwapMesh(resName)
    local data = self.AssetMap[resName]
    if data then
        local result, dummy = data:Swap()
        if result then result:SetActive(true) end
        return result, dummy
    end
    return nil, nil
end

----目前没用
function MeshCacheMgr:SwapMeshAsync(resName, assetlv, objcachelv, finishevt, param, class)
    local data = self:AddCacheData(resName, assetlv, objcachelv)
    if data then
        data:SwapAsync(finishevt, param, class)
    end
end

----根据prefab名字，先添加到缓存数据里面，再加载prefab
function MeshCacheMgr:LoadMesh(resName, assetlv, objcachelv)
    local data = self:AddCacheData(resName, assetlv, objcachelv)
    data:LoadMesh(resName)
end

function MeshCacheMgr:IsLoadFinish(resName)
    --local data = self:AddCacheData(resName, assetlv, objcachelv)
    --data:LoadMesh(resName)
    local data = self.AssetMap[resName]
    if data == nil then
        return false
    end
    return data:IsLoadFinish()
end




function MeshCacheMgr:AssetLoadFinish(resName, istouch)
    local data = self.AssetMap[resName]
    if data ~= nil then
        data:LoadAssetFinish(istouch)
    end
end

----如果当前的obj 正在用着，且它是车上的mesh 或者 是 挂点 就把它移到缓存的根目录下，否则就销毁
function MeshCacheMgr:RecycleMesh(obj)
    if obj == nil or CommonHelper:GameObjectIsNull(obj) then print("---   error:MeshCacheMgr:RecycleMesh   obj = nil") return end

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
        if CarCacheManager:Get():CheckResCache(data.ResName) or dummy_config.IsDummy(data.ResName) then
            data:Recycle(obj)
            if dummy_config.IsDummy(data.ResName) then
                UIUtil.SetParentGameObject(self.DummyRoot, obj)
            end
            --print("------只是回收mesh，并没有卸载------")
        else
            print("------只是回收mesh，并卸载------")
            data:DestoryPrefab(obj)
        end
    end
end


function MeshCacheMgr:AdvanceLoad()
    for k,v in pairs(AdvanceLoad_StaticParts) do
        MeshCacheMgr:Get():LoadMesh(v)
    end
    ---@type dummy_config
    local dummy_config=ClientDataManager:Get():GetDataTable(ConfigNames.dummy_config)
    for k,v in pairs(dummy_config.GetConfigData()) do
        MeshCacheMgr:Get():LoadMesh(v.resname)
    end
    local localParts=PlayerPrefsHelper:GetValue_MeshCache()
    if not CommonHelper:IsNullOrEmpty(localParts) then
        local parts=stringSplit(localParts,'|')
        for k,v in pairs(parts) do
            if not CommonHelper:IsNullOrEmpty(v) then
                MeshCacheMgr:Get():LoadMesh(v)
            end
        end
    else
        print("本地没有缓存默认加载新手的四辆车")
        ---本地没有缓存默认加载新手的四辆车
        ---@type dictcar_config
        local dictcarcfg=ClientDataManager:Get():GetDataTable(ConfigNames.dictcar_config)
        for k,v in pairs(dictcarcfg.GetConfigData()) do
            local data=CommonHelper:GetTableDataByID(ConfigNames.dictcardetail_config,k)
            if data then
                local partList = AssembleHelper:AnalyseCfgToMsgParts(data)
                for i = 1, #partList do
                    ---@type dictparts_config_cell
                    local parts_config = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partList[i])
                    if parts_config then
                        ---@type meshcfg_config_cell[]
                        local meshCfgs=CarBuilderHelper:GetMeshCfgResName(partList[i],1)
                        for j = 1, #meshCfgs do
                            if meshCfgs[j] then
                                MeshCacheMgr:Get():LoadMesh(meshCfgs[j])
                            end
                        end
                    end
                end
            end
        end
    end
end


function MeshCacheMgr:ReleaseAllMesh()
    for k,v in pairs(self.AssetMap) do
        if v ~= nil then
           v:DestoryAllPrefab()
        end
    end
end

function MeshCacheMgr:ReleaseUnusedMesh()
    for k,v in pairs(self.AssetMap) do
        if CarCacheManager:Get():CheckResCache(v.ResName) or dummy_config.IsDummy(v.ResName) then

        else
            v:DestoryAllPrefab()
        end
    end
end
function MeshCacheMgr:ReleaseUnusedMesh()
    for k,v in pairs(self.AssetMap) do
        if CarCacheManager:Get():CheckResCache(v.ResName) or dummy_config.IsDummy(v.ResName) then

        else
            v:DestoryAllPrefab()
        end
    end
end
function MeshCacheMgr:ReleaseNotUseMesh()
    for k,v in pairs(self.AssetMap) do
        v:DestoryPrefabOnlyOne()
    end
end

function MeshCacheMgr:GetRoot()
    return self.Root
end
function MeshCacheMgr:SavePartList()
    local result=""
    for k, v in pairs(self.AssetMap) do
        if not dummy_config.IsDummy(v.ResName) then
            result=result..v.ResName.."|"
        end
    end
    if CommonHelper:IsNullOrEmpty(result) then
        return
    end
    PlayerPrefsHelper:SetValue_MeshCache(result)
end

