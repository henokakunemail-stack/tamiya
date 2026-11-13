


function CarBuilder:SetCSharpCarDataResource()
    local commpoent = UIUtil.GetGameobjectComponent(self.Root, typeof(CSCarDataResource))
    if commpoent == nil then
        commpoent = UIUtil:AddGameobjectComponent(self.Root, typeof(CSCarDataResource))
    end

    commpoent:ResetData()

    self:CSharpCommpoent_SetTyreRadius(commpoent)

    self:CSharpCommpoent_SetMeshRenderList(commpoent)

    self:CSharpCommpoent_SetChassisMeshRender(commpoent)

    self:CSharpCommpoent_SetShellMeshRender(commpoent)

   -- self:CSharpCommpoent_SetWheelBlurCompoent(commpoent)

    self:CSharpCommpoent_SetPulleyPoint(commpoent)
    self:CSharpCommpoent_SetRailPoint(commpoent)
    self:CSharpCommpoent_SetRailGameObject(commpoent)
    self:CSharpCommpoent_SetStabilizerBarGameObject(commpoent)
end

--region 设置轮胎半径
function CarBuilder:CSharpCommpoent_SetTyreRadius(com)
    if com == nil then return end

    local partid = self:GetPartDataID(PartGrooveID.BTyre)
    local generation = self:GetPartDataGeneration(PartGrooveID.BTyre)
    if partid == -1 or partid == nil then return end

    local value = 0.542 * 0.5
    local cfg = self:GetPartMeshCfg(partid,generation)
    if cfg and cfg.thickness > 0 then
        value = value + cfg.thickness
    end

    com:SetTyreRadius(value)
end
--endregion

--region 设置所有模型的meshrender
function CarBuilder:CSharpCommpoent_SetMeshRenderList(com)
    if com == nil then return end

    local temp = self:GetAllMeshObj()
    --for k, v in pairs(self.UsingMeshDict) do
    --    for i = 1, #v do
    --        table.insert(temp, v[i])
    --    end
    --end

    com:SetMeshRenderList(temp)
end
--endregion

--region 设置底盘meshrender
function CarBuilder:CSharpCommpoent_SetChassisMeshRender(com)
    if com == nil then return end


    local meshname = ""
    local meshcfg = self:GetPartMeshCfg(self:GetPartDataID(PartGrooveID.Chassis),self:GetPartDataGeneration(PartGrooveID.Chassis))
    if meshcfg then
        meshname = meshcfg.mesh
    end

    local objlist = self:GetMeshListByGrooveID(PartGrooveID.Chassis, meshname)
    if #objlist ~= 1 then
        print("---   error:CSharpCommpoent_SetShellMeshRender  底盘模型个数",#objlist)
        return
    end

    com:SetChassisMeshRender(objlist[1])

end
--endregion

--region 设置车壳meshrendfer
function CarBuilder:CSharpCommpoent_SetShellMeshRender(com)
    if com == nil then return end

    local meshname = ""
    local meshcfg = self:GetPartMeshCfg(self:GetPartDataID(PartGrooveID.Shell),self:GetPartDataGeneration(PartGrooveID.Shell),PartGrooveID.Shell,self.StickerID)
    if meshcfg then
        meshname = meshcfg.mesh
    end

    local objlist = self:GetMeshListByGrooveID(PartGrooveID.Shell, meshname)
    if #objlist ~= 1 then
        print("---   error:CSharpCommpoent_SetShellMeshRender  车壳模型个数",#objlist)
        return
    end

    com:SetShellMeshRender(objlist[1])

end
--endregion

--region 设置轮毂模糊组件
function CarBuilder:CSharpCommpoent_SetWheelBlurCompoent(com)
    if com == nil then return end
    local wheellist = {}
    local meshname = ""
    local meshcfg = self:GetPartMeshCfg(self:GetPartDataID(PartGrooveID.FHub),self:GetPartDataGeneration(PartGrooveID.FHub))
    if meshcfg then meshname = meshcfg.mesh end
    local objlist = self:GetMeshListByGrooveID(PartGrooveID.FHub, meshname)
    for i = 1, #objlist do
        table.insert(wheellist, objlist[i])
    end


    meshname = ""
    meshcfg = self:GetPartMeshCfg(self:GetPartDataID(PartGrooveID.BHub),self:GetPartDataGeneration(PartGrooveID.BHub))
    if meshcfg then meshname = meshcfg.mesh end
    objlist = self:GetMeshListByGrooveID(PartGrooveID.BHub, meshname)
    for i = 1, #objlist do
        table.insert(wheellist, objlist[i])
    end
   -- com:SetWheelBlurCompoent(wheellist)

end
--endregion

--region 设置导轮挂点一共20个
function CarBuilder:CSharpCommpoent_SetPulleyPoint(com)
    if com == nil then return end

    local temp = {}
    table.insert(temp, self:GetPulleyPointByGrooveID(PartGrooveID.PulleyFrontCenter))
    table.insert(temp, self:GetPulleyPointByGrooveID(PartGrooveID.PulleyFrontButtom))
    table.insert(temp, self:GetPulleyPointByGrooveID(PartGrooveID.PulleyFrontMinus))

    table.insert(temp, self:GetPulleyPointByGrooveID(PartGrooveID.PulleyMiddleCenter))
    table.insert(temp, self:GetPulleyPointByGrooveID(PartGrooveID.PulleyMiddleButtom1))
    table.insert(temp, self:GetPulleyPointByGrooveID(PartGrooveID.PulleyMiddleMinus))

    table.insert(temp, self:GetPulleyPointByGrooveID(PartGrooveID.PulleyRearCenter))
    table.insert(temp, self:GetPulleyPointByGrooveID(PartGrooveID.PulleyRearButtom))
    table.insert(temp, self:GetPulleyPointByGrooveID(PartGrooveID.PulleyRearMinus))

    table.insert(temp, self:GetPulleyPointByGrooveID(PartGrooveID.PulleyShell))
    if temp[1][1]==-1 then
        temp[1]=self:GetPulleyPointByGrooveID(PartGrooveID.Front)
    end
    local result = {}
    for i = 1, #temp do
        local t = temp[i]
        table.insert(result, t[1])
        table.insert(result, t[2])
    end

    com:SetPulleyPointList(result)

end
--endregion
--region 设置钉钉挂点
function CarBuilder:CSharpCommpoent_SetRailPoint(com)
    if com == nil then return end

    local temp = {}
    table.insert(temp, self:GetPulleyPointByGrooveID(PartGrooveID.FrontExtr2))
    table.insert(temp, self:GetPulleyPointByGrooveID(PartGrooveID.RearExtr2))


    local result = {}
    for i = 1, #temp do
        local t = temp[i]
        table.insert(result, t[1])
        table.insert(result, t[2])
    end

    com:SetRailList(result)

end
--endregion
--region 设置导钉钉
function CarBuilder:CSharpCommpoent_SetRailGameObject(com)
    if com == nil then return end

    local temp = {}
    table.insert(temp, self:GetPulleyObjsByGrooveID(PartGrooveID.FrontExtr2,{-1,-1}))
    table.insert(temp, self:GetPulleyObjsByGrooveID(PartGrooveID.RearExtr2,{-1,-1}))


    local result = {}
    for i = 1, #temp do
        local t = temp[i]
        table.insert(result, t[1])
        table.insert(result, t[2])
    end

    com:SetRailGameList(result)

end
--endregion
--region 设置平衡杆
function CarBuilder:CSharpCommpoent_SetStabilizerBarGameObject(com)
    if com == nil then return end

    local temp = {}
    table.insert(temp, self:GetPulleyObjsByGrooveID(PartGrooveID.Front2,{-1,-1}))
    table.insert(temp, self:GetPulleyObjsByGrooveID(PartGrooveID.Rear2,{-1,-1}))
    table.insert(temp, self:GetPulleyObjsByGrooveID(PartGrooveID.Front,{-1,-1}))
    table.insert(temp, self:GetPulleyObjsByGrooveID(PartGrooveID.Rear,{-1,-1}))
    table.insert(temp, self:GetPulleyObjsByGrooveID(PartGrooveID.Middle,{-1,-1}))


    local result = {}
    for i = 1, #temp do
        local t = temp[i]
        table.insert(result, t[1])
        table.insert(result, t[2])
    end

    com:SetStabilizerBarGameObjectList(result)

end
--endregion

--region 设置mutlimeshbaker
function CarBuilder:CSharpCommpoent_SetBakers(com)
    local result = {}
    for k,v in pairs(self.VertexBaker) do
        table.insert(result, v)
    end
    com:SetBakers(result)
end
--endregion
