

------------合批

function CarBuilder:BuildMeshBaker()
    if self.CombineType == CombineType.None  then
        return
    end

    CombinUtil4wd.ResetMaterialName(self.Root)

    if self.CombineType == CombineType.TextureBaker  then
        if self.ShellBaker == nil then
            self.ShellBaker = MeshCacheMgr:Get():SwapMesh(MeshBackerPrefabShell)
            --self.ShellBaker.name = "ShellBaker"
            UIUtil.SetParentGameObject(self.Root, self.ShellBaker)
        end
        if self.GridsBaker == nil then
            self.GridsBaker = MeshCacheMgr:Get():SwapMesh(MeshBackerPrefabGrid)
            --self.GridsBaker.name = "GridsBaker"
            UIUtil.SetParentGameObject(self.Root, self.GridsBaker)
        end
        if self.MetalBaker == nil then
            self.MetalBaker = MeshCacheMgr:Get():SwapMesh(MeshBackerPrefabMetal)
            --self.MetalBaker.name = "MetalBaker"
            UIUtil.SetParentGameObject(self.Root, self.MetalBaker)
        end
        if self.PlasticBaker == nil then
            self.PlasticBaker = MeshCacheMgr:Get():SwapMesh(MeshBackerPrefabPlatstic)
            --self.PlasticBaker.name = "PlasticBaker"
            UIUtil.SetParentGameObject(self.Root, self.PlasticBaker)
        end
        --if self.TyreBaker == nil then
        --    self.TyreBaker = MeshCacheMgr:Get():SwapMesh(MeshBackerPrefab)
        --    self.TyreBaker.name = "TyreBaker"
        --    UIUtil.SetParentGameObject(self.Root, self.TyreBaker)
        --end
    end

    if self.CombineType == CombineType.OnceVertexBaker then
        local objdict = CombinUtil4wd.FindVertexMeshs(self.Root.transform)
        self.MutliMeshDict = objdict
        for k,v in pairs(objdict) do
            local baker = MeshCacheMgr:Get():SwapMesh(MutliMeshBakerPrefab)
            baker.name = string.format("meshbaker_%d_%s",v.Count,k)
            UIUtil.SetParentGameObject(self.Root, baker)
            self.VertexBaker[k] = baker
        end
    end

    if self.CombineType == CombineType.MeshBaker then
        local objdict = CombinUtil4wd.FindVertexMeshs(self.Root.transform)
        self.MutliMeshDict = objdict
        for k,v in pairs(objdict) do
            local baker = MeshCacheMgr:Get():SwapMesh(MeshBakerPrefab)
            baker.name = string.format("texturebaker_%d_%s",v.Count,k)
            UIUtil.SetParentGameObject(self.Root, baker)
            self.TextureBakers[k] = baker
        end
    end
end

function CarBuilder:Combine(finishevt)
    self.CombineMax = 0
    CombinUtil4wd.ResetMaterialName(self.Root)

    if self.CombineType == CombineType.TextureBaker then
        self:CombineShell(function () self:CombineOneFinish(finishevt)  end)
        self:CombineGrids(function () self:CombineOneFinish(finishevt)  end)
        --self:CombineTyre(function () self:CombineOneFinish(finishevt)  end)
        self:CombinePlastic(function () self:CombineOneFinish(finishevt)  end)
        self:CombineMetal(function () self:CombineOneFinish(finishevt)  end)
    end

    if self.CombineType == CombineType.OnceVertexBaker then
        self:CombineVertexOnly(finishevt)
    end

    if self.CombineType == CombineType.MeshBaker then
        self:CombineMeshWithoutTexture(finishevt)
    end



end

function CarBuilder:CombineOneFinish(finishevt)
    self.CombinePreccess = self.CombinePreccess + 1
    if self.CombinePreccess == self.CombineMax then
        if finishevt then finishevt() end
    end
end

function CarBuilder:CombineShell(finishevt)
    self.CombineMax = self.CombineMax + 1
    if self.ShellBaker == nil then
        logError("---   Error:没有加载shellBaker，合批失败")
        if finishevt then finishevt() end
    else
        local shell = self:GetShellObj()
        if shell then
            CombinUtil4wd.CombineShell(self.Root, shell.transform, self.ShellBaker, function ()
                if finishevt then finishevt() end
            end)
        else
            if finishevt then finishevt() end
        end
    end
end
function CarBuilder:CombineGrids(finishevt)
    self.CombineMax = self.CombineMax + 1
    if self.GridsBaker == nil then
        logError("---   Error:没有加载gridBaker，合批失败")
        if finishevt then finishevt() end
    else
        local shell = self:GetShellObj()
        if shell then
            CombinUtil4wd.CombineShellGrid(self.Root, shell.transform, self.GridsBaker, function ()
                if finishevt then finishevt() end
            end)
        else
            if finishevt then finishevt() end
        end
    end
end
function CarBuilder:CombineTyre(finishevt)
    self.CombineMax = self.CombineMax + 1
    if finishevt then finishevt() end
    --if self.TyreBaker == nil then
    --    logError("---   Error:没有加载TyreBaker，合批失败")
    --    if finishevt then finishevt() end
    --else
    --    local tran = UIUtil.GetChild("wheels", self.Root)
    --    if tran then
    --        CombinUtil4wd.CombineWheelBlur(self.Root, tran.transform, self.TyreBaker, function ()
    --            if finishevt then finishevt() end
    --        end)
    --    else
    --        if finishevt then finishevt() end
    --    end
    --end
end
function CarBuilder:CombinePlastic(finishevt)
    self.CombineMax = self.CombineMax + 1
    if self.PlasticBaker == nil then
        logError("---   Error:没有加载PlasticBaker，合批失败")
        if finishevt then finishevt() end
    else
        CombinUtil4wd.CombineMetal(self.Root, self.Root.transform, self.PlasticBaker, false, function ()
            if finishevt then finishevt() end
        end)
    end
end
function CarBuilder:CombineMetal(finishevt)
    self.CombineMax = self.CombineMax + 1
    if self.MetalBaker == nil then
        logError("---   Error:没有加载metalBaker，合批失败")
        if finishevt then finishevt() end
    else
        CombinUtil4wd.CombineMetal(self.Root, self.Root.transform, self.MetalBaker, true, function ()
            if finishevt then finishevt() end
        end)
    end
end

function CarBuilder:CombineVertexOnly(finishevt)
    for k,v in pairs(self.MutliMeshDict) do
        local baker = self.VertexBaker[k]
        CombinUtil4wd.MutliMeshBaker(baker, v)
    end

    if finishevt then finishevt() end
end

function CarBuilder:CombineMeshWithoutTexture(finishevt)
    for k,v in pairs(self.MutliMeshDict) do
        self.CombineMax = self.CombineMax + 1
    end

    local count = 0
    for k,v in pairs(self.MutliMeshDict) do
        local baker = self.TextureBakers[k]
        CombinUtil4wd.CombineMeshWithoutTexture(self.Root, baker, v, function ()
            count = count + 1
            if count == self.CombineMax then
                if finishevt then finishevt() end
            end
        end)
    end

end


function CarBuilder:ReCombine()
    self:ReverseCombine()
    self:Combine()
end





function CarBuilder:ReverseCombine()
    self:ReverseCombineOne(self.ShellBaker)
    self:ReverseCombineOne(self.GridsBaker)
    self:ReverseCombineOne(self.MetalBaker)
    self:ReverseCombineOne(self.PlasticBaker)
    self:ReverseCombineOne(self.TyreBaker)

    for k,v in pairs(self.VertexBaker) do CombinUtil4wd.ReverseMutliMeshBaker(v) end

    for k,v in pairs(self.TextureBakers) do self:ReverseCombineOne(v) end
end
function CarBuilder:ResetCenter()
  local center=UIUtil.GetChildInputPath("center",self.Root)
    if center and CommonHelper:GameObjectIsNull(center) then
        center.transform.localRotation=Quaternion.identity
    end
end

function CarBuilder:ReverseCombineOne(baker)
    if baker then CombinUtil4wd.ReverseTextureBaker(baker) end
end

----回收BakerPrefab 如果mesh在车上 就移动到缓存目录下，否则就销毁并卸载
function CarBuilder:RecycleCombinePrefab()
    MeshCacheMgr:Get():RecycleMesh(self.ShellBaker)
    MeshCacheMgr:Get():RecycleMesh(self.GridsBaker)
    MeshCacheMgr:Get():RecycleMesh(self.MetalBaker)
    MeshCacheMgr:Get():RecycleMesh(self.PlasticBaker)
    MeshCacheMgr:Get():RecycleMesh(self.TyreBaker)
    self.ShellBaker = nil
    self.GridsBaker = nil
    self.MetalBaker = nil
    self.PlasticBaker = nil
    self.TyreBaker = nil

    for k,v in pairs(self.VertexBaker) do MeshCacheMgr:Get():RecycleMesh(v) end
    self.VertexBaker = {}
end
