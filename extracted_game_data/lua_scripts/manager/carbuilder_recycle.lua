


function CarBuilder:RecycleAllMaterial()
    for i = 1, #self.UsingMaterials do
        MatCacheDataMgr:Get():RecycleMaterial(self.UsingMaterials[i])
    end
    self.UsingMaterials = {}
    self.UsingShellMat = nil

    if self.TempStickerMat then
        MatCacheDataMgr:Get():RecycleMaterial(self.TempStickerMat)
        self.TempStickerMat = nil
    end

    if self.TempGridMat then
        MatCacheDataMgr:Get():RecycleMaterial(self.TempGridMat)
        self.TempGridMat = nil
    end

    if self.TempHoleMat then
        MatCacheDataMgr:Get():RecycleMaterial(self.TempHoleMat)
        self.TempHoleMat = nil
    end


end

----移除mesh 挂点 下所有的mesh,如果在车上就缓存，不在车上就卸载
function CarBuilder:RecycleAllObj()
    log("--------------》》》》。回收")
    for i = #self.MeshKeyList, 1, -1 do
        local temp = self.MeshKeyList[i]
        for m = 1, #temp.Objs do
            MeshCacheMgr:Get():RecycleMesh(temp.Objs[m])
        end
    end
    self.MeshKeyList = {}

    --for i = #self.UsingMeshObjects, 1, -1 do
    --    local mesh = self.UsingMeshObjects[i]
    --    MeshCacheMgr:Get():RecycleMesh(mesh)
    --end
    --self.UsingMeshObjects = {}
    --self.UsingMeshDict = {}
end
function CarBuilder:RecycleShellAdditionWheels()
    log("--------------》》》》。回收")
    if  self.ShellAdditionWheels then
        local shell = self:GetShellObj()
        local cfg = self:GetPartMeshCfg(self:GetPartDataID(PartGrooveID.Shell),self:GetPartDataGeneration(PartGrooveID.Shell),PartGrooveID.Shell,self.StickerID)
        local sheelAddition1= UIUtil.GetChild(cfg.NewMeshForm[1],shell)
        for i = 1, #self.ShellAdditionWheels do
            UIUtil.SetParentGameObject(sheelAddition1,self.ShellAdditionWheels[i],false)
        end
    end
    self.ShellAdditionWheels=nil

    --for i = #self.UsingMeshObjects, 1, -1 do
    --    local mesh = self.UsingMeshObjects[i]
    --    MeshCacheMgr:Get():RecycleMesh(mesh)
    --end
    --self.UsingMeshObjects = {}
    --self.UsingMeshDict = {}
end

----移除车壳上纱网的材质球
function CarBuilder:RemoveMatRelevance()
    local shell = self:GetShellObj()
    if shell and CommonHelper:GameObjectIsNull(shell) then
        local m = UIUtil.GetGameobjectComponent(shell, typeof(MeshRenderer))
        if not CommonHelper:GameObjectIsNull(m) then
            if m then m.material = nil end
            for i = 1, ShellHoldCount do
                m = UIUtil.GetTypeChildWightByParent("hole_0"..i,shell,typeof(MeshRenderer))
                if not CommonHelper:GameObjectIsNull(m) then m.material = nil end
            end

            for i = 1, ShellHoldCount do
                local render = UIUtil.GetTypeChildWightByParent("grid_0"..i,shell,typeof(MeshRenderer))
                if not CommonHelper:GameObjectIsNull(render) then render.material = nil end
            end
        end
    end
end