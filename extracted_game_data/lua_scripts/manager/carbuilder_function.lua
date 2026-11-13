----获取dummy点的prefab名字
function CarBuilder:GetChassisDummy()
    local chassisid = self:GetPartDataID(PartGrooveID.Chassis)
    local generation = self:GetPartDataGeneration(PartGrooveID.Chassis)
    if chassisid == nil or chassisid == -1 then
        logError("---   error:找不到正确dummy资源,   111   partcfg中chassisid = ", chassisid)
        return DufaultDummyPrefabName
    end

    local cfg = self:GetPartMeshCfg(chassisid, generation)

    if cfg == nil then
        logError("---   error:找不到正确dummy资源,   222   meshcfg = nil")
        return DufaultDummyPrefabName
    end

    ---@type dummy_config_cell
    local dummycfg = CommonHelper:GetTableDataByID(ConfigNames.dummy_config, cfg.flag)

    if dummycfg == nil then
        logError("---   error:找不到正确dummy资源,   333   dummycfg = nil, flag = ", cfg.flag)
        return DufaultDummyPrefabName
    end

    return dummycfg.resname
end
----获取dummy点的prefab名字
function CarBuilder:GetSingleShellDummy()
    local chassisid = self:GetPartDataID(PartGrooveID.Shell)
    local generation = self:GetPartDataGeneration(PartGrooveID.Shell)
    if chassisid == nil or chassisid == -1 then
        logError("---   error:找不到正确dummy资源,   111   partcfg中chassisid = ", chassisid)
        return DufaultDummyPrefabName
    end

    ---@type dummy_config_cell
    local dummycfg = CommonHelper:GetTableDataByID(ConfigNames.dummy_config, chassisid)
    if dummycfg == nil then
        logError("---   error:CarBuilderHelper  找不到正确dummy资源,   333   dummycfg = nil, flag = ", chassisid)
        return DufaultDummyPrefabName
    end
    return dummycfg.resname

end

----从meshKey里面获取到mesh gameObject 然后根据挂点找到挂点的gameObject，把mesh 放到下面，并设置好偏移
---@param meshkey CarBuilderMeshKey
---@param offset LuaVector3
---@param scale LuaVector3
function CarBuilder:AddMeshOld(grooveid, meshkey, point, offset, scale, otherparent)
    if meshkey then
        if meshkey.ResName ~= nil and meshkey.ResName ~= -1 and meshkey.ResName ~= "" then
            local mesh = MeshCacheMgr:Get():SwapMesh(meshkey.ResName)
            if mesh then
                if self.DummyPointMap.Map then
                    local parent = self.DummyPointMap.Map[point]
                    if otherparent then
                        parent = otherparent
                    end
                    if parent == nil then
                        --logError("---   error: 找不到dummy  grooveid = ", grooveid, "mesh = ", mesh, "point = ", point)
                        parent = self.Root
                    end
                    UIUtil.SetParentGameObject(parent, mesh)
                    if offset then
                        UIUtil:GameobjectLocalPositionLuaVector3(mesh, offset)
                    end
                    if scale then
                        mesh.transform.localScale = Vector3(scale:GetData())
                    end
                end
                self:AddMesh(meshkey, mesh)
                --self:AddMeshObj(grooveid, mesh)
            end
        end
    end
end

----根据索引获取底盘组成模型中的其中一个
function CarBuilder:GetChassisDefaultMeshID(idx)
    --车扣，电池，轮轴，轴承，传动轴，电池片，车底盘开关
    local partid = self:GetPartDataID(PartGrooveID.Chassis)
    local generation = self:GetPartDataGeneration(PartGrooveID.Chassis)
    if partid == -1 or partid == nil then
        return -1
    end

    local cfg = self:GetPartMeshCfg(partid, generation)
    if cfg then
        return cfg.NewInitModel[idx]
    end
    return -1
end

--{{{ 抬高车体
----抬高车体，根据轮胎的厚度
function CarBuilder:ResetBodyPos()
    local body = self.DummyPointMap.Map[DummyPoint.body]
    if body then
        UIUtil:GameobjectLocalPosition(body, Vector3.zero)

        local posx = 0
        local posy = 0
        local posz = 0

        local partid = self:GetPartDataID(PartGrooveID.FTyre)
        local generation = self:GetPartDataGeneration(PartGrooveID.FTyre)
        if partid and partid > 0 then
            local cfg = self:GetPartMeshCfg(partid, generation)
            if cfg then
                if cfg.thickness > 0 then
                    posy = cfg.thickness
                end
            end
        end

        local bounds = HMath.GetBounds(self.Root)
        local boundscenter = bounds.center

        local rootpos = self.Root.transform.position
        posz = rootpos.z - boundscenter.z

        if math.abs(posz) < 0.000001 then
            posz = body.transform.localPosition.z
        end

        UIUtil:GameobjectLocalPosition(body, Vector3(posx, posy, posz))
    end
end
--}}}
--{{{ 抬高旋转车体 适配前后轮胎
function CarBuilder:ResetBodyPosRot()
    local body = self.DummyPointMap.Map[DummyPoint.body]
    ---@type assemblerule_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.assemblerule_config)
    local bodybounds = HMath.GetBounds(self.Root)
    local Bbounds = nil
    local Fbounds = nil
    if body then
        UIUtil:GameobjectLocalPosition(body, Vector3.zero)
        body.transform.localRotation = Quaternion.identity
        local posx = body.transform.localPosition.x
        local posy = 0
        local posz = body.transform.localPosition.z
        local fposy = 0
        local fpartid = self:GetPartDataID(PartGrooveID.FTyre)
        local fgeneration = self:GetPartDataGeneration(PartGrooveID.FTyre)
        local fgenerationsticker = self:GetPartSticker(PartGrooveID.FTyre)
        local ftyres = self:GetPulleyObjsByGrooveID(PartGrooveID.FTyre)
        if fpartid and fpartid > 0 then
            local cfg = self:GetPartMeshCfg(fpartid, fgeneration, PartGrooveID.FTyre, fgenerationsticker)
            if cfg and ftyres[1] then
                if cfg.thickness > 0 then
                    fposy = cfg.thickness
                end
                Fbounds = HMath.GetBounds(ftyres[1].gameObject)
            else
                ftyres[1] = self.DummyPointMap.Map[DummyPoint.fltyre]
                Fbounds = bodybounds
            end
        else
            ftyres[1] = self.DummyPointMap.Map[DummyPoint.fltyre]
            Fbounds = bodybounds
        end

        local bposy = 0
        local bpartid = self:GetPartDataID(PartGrooveID.BTyre)
        local bgeneration = self:GetPartDataGeneration(PartGrooveID.BTyre)
        local bgenerationsticker = self:GetPartSticker(PartGrooveID.BTyre)
        local btyres = self:GetPulleyObjsByGrooveID(PartGrooveID.BTyre)
        if bpartid and bpartid > 0 then
            local cfg = self:GetPartMeshCfg(bpartid, bgeneration, PartGrooveID.BTyre, bgenerationsticker)
            if cfg and btyres[1] then
                if cfg.thickness > 0 then
                    bposy = cfg.thickness
                end
                Bbounds = HMath.GetBounds(btyres[1].gameObject)
            else
                btyres[1] = self.DummyPointMap.Map[DummyPoint.bltyre]
                Bbounds = bodybounds
            end
        else
            btyres[1] = self.DummyPointMap.Map[DummyPoint.bltyre]
            Bbounds = bodybounds
        end
        if bposy > fposy then
            posy = bposy
            if ftyres[1] then
                local point = ftyres[1].gameObject.transform.position
                local boundscenter = Bbounds.center
                point = Vector3(point.x, point.y - boundscenter.y, point.z)
                body.transform:RotateAround(point, Vector3.right, self:CalcAngle(bposy, point))
            end

        elseif bposy < fposy then
            posy = fposy
            if btyres[1] then
                local point = btyres[1].gameObject.transform.position
                local boundscenter = Fbounds.center
                point = Vector3(point.x, point.y - boundscenter.y, point.z)
                body.transform:RotateAround(point, Vector3.left, self:CalcAngle(fposy, point))
            end

        else
            posy = bposy
        end
        UIUtil:GameobjectLocalPosition(body, Vector3(posx, posy, posz))
    end
end
--}}}

function CarBuilder:CalcAngle(high, point)
    local angle = Vector3.Angle(Vector3(point.x, high, point.z), point)
    return angle
end

--{{{ 获得车壳的gameobject
----获得车壳的gameObject
function CarBuilder:GetShellObj()
    local shell = nil
    local cfg = self:GetPartMeshCfg(self:GetPartDataID(PartGrooveID.Shell), self:GetPartDataGeneration(PartGrooveID.Shell), PartGrooveID.Shell, self.StickerID)
    if cfg then
        local objlist = self:GetMeshListByGrooveID(PartGrooveID.Shell, cfg.mesh)
        if #objlist ~= 1 then
            print("---   error:CarBuilder:GetShellObj   ", #objlist)
        else
            shell = objlist[1]
        end
    end
    return shell
end
--}}}

--{{{ 获得车壳的材质球
----获得车壳的材质球
function CarBuilder:GetShellMat()
    return self.UsingShellMat
end
--}}}

--{{{ 重置车壳材质球的名字，去掉instance后缀
----重置车壳、打孔、纱网 材质球的名字，去掉instance后缀
function CarBuilder:ResetShellMaterailName()
    local shell = self:GetShellObj()
    if shell == nil then
        return
    end
    local m = UIUtil.GetGameobjectComponent(shell, typeof(MeshRenderer))
    if not CommonHelper:GameObjectIsNull(m) and m.material ~= nil then
        m.material.name = CommonHelper:GetMaterialOriginalName(m.material)
    end
    local cfg = self:GetPartMeshCfg(self:GetPartDataID(PartGrooveID.Shell), self:GetPartDataGeneration(PartGrooveID.Shell), PartGrooveID.Shell, self.StickerID)
    if cfg.NewMeshForm then
        for i, v in pairs(cfg.NewMeshForm) do
            local shellAddition = UIUtil.GetChild(v, shell)
            local m = UIUtil.GetGameobjectComponent(shellAddition, typeof(MeshRenderer))
            if not CommonHelper:GameObjectIsNull(m) and m.material ~= nil then
                for i = 0, m.materials.Length - 1 do
                    m.materials[i].name = CommonHelper:GetMaterialOriginalName(m.materials[i])
                end
            end
        end
    end
    for i = 1, ShellHoldCount do
        m = UIUtil.GetTypeChildWightByParent("hole_0" .. i, shell, typeof(MeshRenderer))
        if not CommonHelper:GameObjectIsNull(m) then
            m.material.name = CommonHelper:GetMaterialOriginalName(m.material)
        end
        m = UIUtil.GetTypeChildWightByParent("hole_0" .. i .. "grid", shell, typeof(MeshRenderer))
        if not CommonHelper:GameObjectIsNull(m) then
            m.material.name = CommonHelper:GetMaterialOriginalName(m.material)
        end
    end
end
--}}}

--{{{轻量化
function CarBuilder:BuildLightweight(lightweight)
    local temp = self:GetShellObj()
    for i = 1, ShellHoldCount do
        local meshrenderer = UIUtil.GetTypeChildWightByParent("hole_0" .. i, temp, typeof(MeshRenderer))
        if not CommonHelper:GameObjectIsNull(meshrenderer) then
            local enable = lightweight[i]
            meshrenderer.enabled = enable
        end
    end
end
function CarBuilder:BuildTempHole(idx, mat)
    if self.TempHoleMat then
        MatCacheDataMgr:Get():RecycleMaterial(self.TempHoleMat)
    end

    if mat then
        self.TempHoleMat = mat
        self:SetHoleMat(idx, mat)
    end
end
function CarBuilder:SetHoleMat(idx, mat)
    local temp = self:GetShellObj()
    for i = 1, ShellHoldCount do
        local render = UIUtil.GetTypeChildWightByParent("hole_0" .. i, temp, typeof(MeshRenderer))
        if not CommonHelper:GameObjectIsNull(render) then
            if i == idx then
                render.material = mat
            else
                render.material = self:GetShellMat()
            end
        end
    end
end
--}}}
---{{{风翼
function CarBuilder:BuildWings()
    local partid = self:GetPartDataID(PartGrooveID.RearWing)
    local sticker = self:GetPartSticker(PartGrooveID.RearWing)
    local generation = self:GetPartDataGeneration(PartGrooveID.RearWing)
    local temp = self:GetShellObj()
    local defaultrender = UIUtil.GetTypeChildWightByParent("default_wings", temp, typeof(MeshRenderer))
    local mesh = nil
    if not CommonHelper:GameObjectIsNull(defaultrender) then
        defaultrender.enabled = partid == nil or partid <= 0
        CommonHelper:CSGameObjectSetActive(defaultrender.gameObject, partid == nil or partid <= 0)
    end
    if partid == nil or partid <= 0 then
        return
    end
    ---@type meshcfg_config_cell
    local meshcfg = self:GetPartMeshCfg(partid, generation, PartGrooveID.RearWing, sticker)

    if meshcfg == nil then
        if AssembleLogEnable then
            log("---   <<<<<<< AssembleRule为空：", PartGrooveID.RearWing)
        end
        return
    end
    local key = self:CreateMeshKeyGroovePart(meshcfg.mesh, PartGrooveID.RearWing)
    if key then
        if key.ResName ~= nil and key.ResName ~= -1 and key.ResName ~= "" then
            mesh = MeshCacheMgr:Get():SwapMesh(key.ResName)
            if mesh then
                ---@type assemblerulewing_config_cell
                local wingCfg = CommonHelper:GetTableDataByID(ConfigNames.assemblerulewing_config, meshcfg.flag)
                local wings1 = UIUtil.GetChild(wingCfg.point, temp)
                if wings1 == nil then
                    if defaultrender then
                        defaultrender.enabled = true
                        CommonHelper:CSGameObjectSetActive(defaultrender.gameObject, true)
                    end
                    if mesh then
                        CommonHelper:CSGameObjectSetActive(mesh, false)
                    end
                    return
                end
                CommonHelper:CSGameObjectSetActive(mesh, true)
                UIUtil.SetParentGameObject(wings1, mesh)
                local offset = wingCfg.NewOffset
                local rotate = wingCfg.NewRotate
                if offset then
                    UIUtil:GameobjectLocalPositionLuaVector3(mesh, offset)
                    mesh.gameObject.transform.localRotation = Quaternion.Euler(rotate.X, rotate.Y, rotate.Z)
                end
            end
            self:AddMesh(key, mesh)
        end
    end
    if PlayerPrefsHelper:GetValue_Car_GrooveIDShow(PartGrooveID.RearWing) == 0 then
        if defaultrender then
            defaultrender.enabled = true
            CommonHelper:CSGameObjectSetActive(defaultrender.gameObject, true)
        end
        if mesh then
            CommonHelper:CSGameObjectSetActive(mesh, false)
        end
    end
end
function CarBuilder:CheckMsChassis()
    local partid = self:GetPartDataID(PartGrooveID.Chassis)
    if CommonHelper:GetPartBaseCfg(partid).subtype == 10 or CommonHelper:GetPartBaseCfg(partid).subtype == 9 then
        return false
    end
    return true
end
function CarBuilder:CheckSingleShell()
    local partid = self:GetPartDataID(PartGrooveID.Shell)
    local flag = false
    if PartIdDefine then
        for k, v in pairs(PartIdDefine) do
            if partid == v then
                flag = true
                break
            end
        end
    end
    return flag
end
function CarBuilder:CheckSingleOtherShell()
    local partid = self:GetPartDataID(PartGrooveID.Shell)
    local flag = false
    if PartOtherIdDefine then
        for k, v in pairs(PartOtherIdDefine) do
            if partid == v then
                flag = true
                break
            end
        end
    end
    return flag

end

function CarBuilder:SetWingsMat(mat)
    local temp = self:GetShellObj()
    local render = UIUtil.GetTypeChildWightByParent("default_wings", temp, typeof(MeshRenderer))
    if not CommonHelper:GameObjectIsNull(render) then
        render.material = mat
    end
end
--}}}

--{{{纱网
----设置车上纱网的材质球
function CarBuilder:BuildShellGrid()
    for i = 1, ShellHoldCount do
        local grids = self:GetShellGrid()
        local gridid = grids[i]
        local mat = nil
        if gridid ~= nil and gridid ~= 0 then
            ---@type apgrid_config_cell
            local cfg = CommonHelper:GetTableDataByID(ConfigNames.apgrid_config, gridid)
            if cfg then
                mat = MatCacheDataMgr:Get():SwapMaterial(cfg.NewMat)
                self:AddMaterial(mat)
            end
        end
        self:SetGridMat(i, gridid, mat)
    end

    self:ResetShellMaterailName()
end
----给预览纱网设置tempGridMat材质球
function CarBuilder:BuildTempGrid(idx, gridid, mat, isReview)
    if self.TempGridMat then
        MatCacheDataMgr:Get():RecycleMaterial(self.TempGridMat)
    end

    if mat then
        self.TempGridMat = mat
        self:SetGridMat(idx, gridid, mat, isReview)
    end

    self:ResetShellMaterailName()
end
function CarBuilder:SetGridMat(idx, gridid, mat, isReview)
    local temp = self:GetShellObj()
    local render = UIUtil.GetTypeChildWightByParent("grid_0" .. idx, temp, typeof(MeshRenderer))
    if not CommonHelper:GameObjectIsNull(render) then
        local enable = (not self:GetLightweight()[idx]) and ((gridid ~= nil and gridid > 2) or isReview)
        render.enabled = enable
        render.gameObject:SetActive(enable)
        render.material = mat
    end

end
--}}}

--{{{车壳换色

----给车壳换颜色，根据颜色id 去配置表里读取颜色，给车壳和贴纸的部分赋予相同的材质球
function CarBuilder:BuildShellColor(colorid)
    local  flag= self:BuildOtherShellColor(colorid)
    if flag then
        return
    end
    local shell = self:GetShellObj()
    if shell == nil then
        return
    end
    local m = UIUtil.GetGameobjectComponent(shell, typeof(MeshRenderer))
    if CommonHelper:GameObjectIsNull(m) then
        return
    end

    if colorid == 0 then
        if self.IsColor == 1 then
            self:SetDefaultMatColorParam(m, true)
        else
            self:SetDefaultMatColorParam(m, false)
        end
    else
        local colorcfg = self:GetColorResCfg(colorid)
        if colorcfg then
            self:SetMatColorParam(m, true, colorcfg.NewBaseColor, colorcfg.NewSSSColor, colorcfg.NewFakeColor, colorcfg.metallic, colorcfg.smoothness)
        end
    end
    local stickerid=  self:GetSticker()
    ---@type apsticker_config_cell
    local stickercfg = CommonHelper:GetTableDataByID(ConfigNames.apsticker_config, stickerid)
    if stickercfg.NewMatAdditional ~= "0" then
        self:SetStickerAdditionalColor(colorid)
    end
    for i = 1, ShellHoldCount do
        local render = UIUtil.GetTypeChildWightByParent("hole_0" .. i, shell, typeof(MeshRenderer))
        if not CommonHelper:GameObjectIsNull(render) then
            if colorid == 0 then
                if self.IsColor == 1 then
                    self:SetDefaultMatColorParam(render, true)
                else
                    self:SetDefaultMatColorParam(render, false)
                end
            else
                local colorcfg = self:GetColorResCfg(colorid)
                if colorcfg then
                    self:SetMatColorParam(render, true, colorcfg.NewBaseColor, colorcfg.NewSSSColor, colorcfg.NewFakeColor, colorcfg.metallic, colorcfg.smoothness)
                end
            end
        end
    end
    local render = UIUtil.GetTypeChildWightByParent("default_wings", shell, typeof(MeshRenderer))
    if not CommonHelper:GameObjectIsNull(render) then
        if colorid == 0 then
            if self.IsColor == 1 then
                self:SetDefaultMatColorParam(render, true)
            else
                self:SetDefaultMatColorParam(render, false)
            end
        else
            local colorcfg = self:GetColorResCfg(colorid)
            if colorcfg then
                self:SetMatColorParam(render, true, colorcfg.NewBaseColor, colorcfg.NewSSSColor, colorcfg.NewFakeColor, colorcfg.metallic, colorcfg.smoothness)
            end
        end
    end
    self:ResetShellMaterailName()
end
function CarBuilder:BuildOtherShellColor(colorid)
    local flag= self:CheckSingleOtherShell()
    if not  flag then
        return false
    end
    local shell = self:GetShellObj()
    if shell == nil then
        return
    end
    local ms = UIUtil.GetGameobjectComponentsInChild(shell, typeof(CS.UnityEngine.SkinnedMeshRenderer))
    if ms then
        for k, v in pairs(ms) do
            if not CommonHelper:GameObjectIsNull(v) then
                if colorid == 0 then
                    if self.IsColor == 1 then
                        self:SetSkinDefaultMatColorParam(v, true)
                    else
                        self:SetSkinDefaultMatColorParam(v, false)
                    end
                else
                    local colorcfg = self:GetColorResCfg(colorid)
                    if colorcfg then
                        self:SetSkinMatColorParam(v ,true, colorcfg.basecolor, colorcfg.ssscolor, colorcfg.fakecolor, colorcfg.metallic, colorcfg.smoothness)
                    end
                end
                v.material.name = CommonHelper:GetMaterialOriginalName(v.material)
            end
        end
    end
    return flag
end

---@param basecolor LuaColor
---@param ssscolor LuaColor
---@param fakecolor LuaColor
----设置材质球的参数，比如baseColor、sssColor、fakeColor、metalLic、Smoothness
function CarBuilder:SetMatColorParam(render, enable, basecolor, ssscolor, fakecolor, metallic, smoothness)
    if CommonHelper:GameObjectIsNull(render) then
        return
    end
    local function SafeSetFloat(comp, name, value)
        if CommonHelper:GameObjectIsNull(comp) then return end
        pcall(function()
            CS.MaterialExtension.SetFloat(comp, name, value)
        end)
    end
    local function SafeSetColor(comp, name, colorData)
        if CommonHelper:GameObjectIsNull(comp) then return end
        pcall(function()
            CS.MaterialExtension.SetColor(comp,name, colorData:GetData())
        end)
    end
    if enable then
        SafeSetFloat(render, "_ENABLEBASECOLOR", 1)
        SafeSetFloat(render, "_EnableSSSColor", 1)
        SafeSetFloat(render, "_EnableFakeColor", 1)
        SafeSetFloat(render, "_ENABLEMETALLIC", 1)
        SafeSetFloat(render, "_ENABLESMOOTHNESS", 1)
        SafeSetColor(render, "_BaseColor", basecolor)
        SafeSetColor(render, "_SSSColor", ssscolor)
        SafeSetColor(render, "_FakeColor", fakecolor)
        SafeSetFloat(render, "_ColorMetallic", metallic)
        SafeSetFloat(render, "_ColorSmoothness", smoothness)
    else
        SafeSetFloat(render, "_ENABLEBASECOLOR", 0)
        SafeSetFloat(render, "_EnableSSSColor", 0)
        SafeSetFloat(render, "_EnableFakeColor", 0)
        SafeSetFloat(render, "_ENABLEMETALLIC", 0)
        SafeSetFloat(render, "_ENABLESMOOTHNESS", 0)
    end
end
--}}}
--{{{车壳默认颜色
function CarBuilder:SetDefaultMatColorParam(render, enable)
    if CommonHelper:GameObjectIsNull(render) then
        return
    end
    local function SafeSetFloat(comp, name, value)
        if CommonHelper:GameObjectIsNull(comp) then return end
        pcall(function()
            CS.MaterialExtension.SetFloat(comp,name, value)
        end)
    end
    if enable then
        SafeSetFloat(render, "_ENABLEBASECOLOR", 1)
        SafeSetFloat(render, "_EnableSSSColor", 1)
        SafeSetFloat(render, "_EnableFakeColor", 1)
        SafeSetFloat(render, "_ENABLEMETALLIC", 1)
        SafeSetFloat(render, "_ENABLESMOOTHNESS", 1)
    else
        SafeSetFloat(render, "_ENABLEBASECOLOR", 0)
        SafeSetFloat(render, "_EnableSSSColor", 0)
        SafeSetFloat(render, "_EnableFakeColor", 0)
        SafeSetFloat(render, "_ENABLEMETALLIC", 0)
        SafeSetFloat(render, "_ENABLESMOOTHNESS", 0)
    end
end
--}}}
---@param basecolor LuaColor
---@param ssscolor LuaColor
---@param fakecolor LuaColor
----设置材质球的参数，比如baseColor、sssColor、fakeColor、metalLic、Smoothness
function CarBuilder:SetSkinMatColorParam(render, enable, basecolor, ssscolor, fakecolor, metallic, smoothness)
    if CommonHelper:GameObjectIsNull(render) then
        return
    end
    local function SafeSetFloat(comp, name, value)
        if CommonHelper:GameObjectIsNull(comp) then return end
        pcall(function()
            comp.material:SetFloat( name, value)
        end)
    end
    local function SafeSetColor(comp, name, colorData)
        if CommonHelper:GameObjectIsNull(comp) then return end
        pcall(function()
            comp.material:SetColor(name,UIUtil:HexToColorRGB(colorData))
        end)
    end
    if enable then
        SafeSetFloat(render, "_ENABLEBASECOLOR", 1)
        SafeSetFloat(render, "_EnableSSSColor", 1)
        SafeSetFloat(render, "_EnableFakeColor", 1)
        SafeSetFloat(render, "_ENABLEMETALLIC", 1)
        SafeSetFloat(render, "_ENABLESMOOTHNESS", 1)
        SafeSetColor(render, "_BaseColor", basecolor)
        SafeSetColor(render, "_SSSColor", ssscolor)
        SafeSetColor(render, "_FakeColor", fakecolor)
        SafeSetFloat(render, "_ColorMetallic", metallic)
        SafeSetFloat(render, "_ColorSmoothness", smoothness)
    else
        SafeSetFloat(render, "_ENABLEBASECOLOR", 0)
        SafeSetFloat(render, "_EnableSSSColor", 0)
        SafeSetFloat(render, "_EnableFakeColor", 0)
        SafeSetFloat(render, "_ENABLEMETALLIC", 0)
        SafeSetFloat(render, "_ENABLESMOOTHNESS", 0)
    end
end
--}}}
--{{{车壳默认颜色
function CarBuilder:SetSkinDefaultMatColorParam(render, enable)
    if CommonHelper:GameObjectIsNull(render) then
        return
    end
    local function SafeSetFloat(comp, name, value)
        if CommonHelper:GameObjectIsNull(comp) then return end
        pcall(function()
            comp.material:SetFloat(name,value)
        end)
    end
    if enable then
        SafeSetFloat(render, "_ENABLEBASECOLOR", 1)
        SafeSetFloat(render, "_EnableSSSColor", 1)
        SafeSetFloat(render, "_EnableFakeColor", 1)
        SafeSetFloat(render, "_ENABLEMETALLIC", 1)
        SafeSetFloat(render, "_ENABLESMOOTHNESS", 1)
    else
        SafeSetFloat(render, "_ENABLEBASECOLOR", 0)
        SafeSetFloat(render, "_EnableSSSColor", 0)
        SafeSetFloat(render, "_EnableFakeColor", 0)
        SafeSetFloat(render, "_ENABLEMETALLIC", 0)
        SafeSetFloat(render, "_ENABLESMOOTHNESS", 0)
    end
end
--}}}

--{{{ 车壳换贴纸
----根据贴纸id 给车壳换上贴纸
function CarBuilder:BuildSticker(stickerid)
    local  flag=self:BuildOtherShellSticker(stickerid)
    if not flag then
        ---@type apsticker_config_cell
        local stickercfg = CommonHelper:GetTableDataByID(ConfigNames.apsticker_config, stickerid)
        if stickercfg ~= nil then
            local mat = MatCacheDataMgr:Get():SwapMaterial(stickercfg.NewMat)
            self:AddMaterial(mat)
            self:SetStickerMat(mat)
            self.UsingShellMat = mat
            self:SetWingsMat(mat)
            if stickercfg.NewMatAdditional ~= "0" then
                local matAddition = MatCacheDataMgr:Get():SwapMaterial(stickercfg.NewMatAdditional)
                self:AddMaterial(matAddition)
                self:SetStickerAdditionalMat(matAddition)
            end
        end
    end
end
function CarBuilder:BuildOtherShellSticker(stickerid)
    local flag= self:CheckSingleOtherShell()
    if not  flag then
        return false
    end
    ---@type apsticker_config_cell
    local stickercfg = CommonHelper:GetTableDataByID(ConfigNames.apsticker_config, stickerid)
    if stickercfg ~= nil then
        local mat = MatCacheDataMgr:Get():SwapMaterial(stickercfg.NewMat)
        local shell = self:GetShellObj()
        if shell == nil then
            return
        end
        local ms = UIUtil.GetGameobjectComponentsInChild(shell, typeof(CS.UnityEngine.SkinnedMeshRenderer))
        if ms then
            for k, v in pairs(ms) do
                if not CommonHelper:GameObjectIsNull(v) then
                    v.material = mat
                    v.material.name = CommonHelper:GetMaterialOriginalName(v.material)
                end
            end
        end
    end
    return true
end

----找到车壳的材质球，赋予其贴纸的材质球，如果之前已经有了，就回收
function CarBuilder:BuildTempSticker(mat)
    if self.TempStickerMat then
        MatCacheDataMgr:Get():RecycleMaterial(self.TempStickerMat)
    end

    if mat then
        self.TempStickerMat = mat
        self:SetStickerMat(mat)
        self:SetWingsMat(mat)
    end
end

----给车壳上的贴纸附材质球
function CarBuilder:SetStickerMat(mat)
    local shell = self:GetShellObj()
    if shell == nil then
        return
    end
    local m = UIUtil.GetGameobjectComponent(shell, typeof(MeshRenderer))

    if mat then
        if not CommonHelper:GameObjectIsNull(m) then
            m.material = mat
        end
        for i = 1, ShellHoldCount do
            m = UIUtil.GetTypeChildWightByParent("hole_0" .. i, shell, typeof(MeshRenderer))
            if not CommonHelper:GameObjectIsNull(m) then
                m.material = mat
            end
        end
    end

    self:ResetShellMaterailName()

end
--}}}
----给车壳上的附加加贴纸附材质球
function CarBuilder:SetStickerAdditionalMat(mat)
    local shell = self:GetShellObj()
    if shell == nil then
        return
    end
    local cfg = self:GetPartMeshCfg(self:GetPartDataID(PartGrooveID.Shell), self:GetPartDataGeneration(PartGrooveID.Shell), PartGrooveID.Shell, self.StickerID)
    if cfg.NewMeshForm then
        for i, v in pairs(cfg.NewMeshForm) do
            local shellAddition = UIUtil.GetChild(v, self.Root)
            local m = UIUtil.GetGameobjectComponent(shellAddition, typeof(MeshRenderer))
            if mat then
                if not CommonHelper:GameObjectIsNull(m) then
                    m.material = mat
                end
            end
        end
    end
    self:ResetShellMaterailName()
end
--}}}
----给车壳上的附加加贴纸附材质球
function CarBuilder:SetStickerAdditionalColor(colorid)
    local shell = self:GetShellObj()
    if shell == nil then
        return
    end
    local cfg = self:GetPartMeshCfg(self:GetPartDataID(PartGrooveID.Shell), self:GetPartDataGeneration(PartGrooveID.Shell), PartGrooveID.Shell, self.StickerID)
    if cfg.NewMeshForm then
        for i, v in pairs(cfg.NewMeshForm) do
            local shellAddition = UIUtil.GetChild(v, self.Root)
            local m = UIUtil.GetGameobjectComponent(shellAddition, typeof(MeshRenderer))
            if colorid == 0 then
                if self.IsColor == 1 then
                    self:SetDefaultMatColorParam(m, true)
                else
                    self:SetDefaultMatColorParam(m, false)
                end
            else
                local colorcfg = self:GetColorResCfg(colorid)
                if colorcfg then
                    self:SetMatColorParam(m, true, colorcfg.NewBaseColor, colorcfg.NewSSSColor, colorcfg.NewFakeColor, colorcfg.metallic, colorcfg.smoothness)
                end
            end
        end
    end
    self:ResetShellMaterailName()
end
--}}}

----给车壳上的附加加贴纸附材质球
function CarBuilder:BuildSingleShellWheel()
    if not self:CheckSingleShell() then
        return
    end
    local shell = self:GetShellObj()
    if shell == nil then
        return
    end
    local cfg = self:GetPartMeshCfg(self:GetPartDataID(PartGrooveID.Shell), self:GetPartDataGeneration(PartGrooveID.Shell), PartGrooveID.Shell, self.StickerID)
    if cfg.NewMeshForm then
        local shell = self:GetShellObj()
        local tyres = {}
        table.insert(tyres, self.DummyPointMap.Map[DummyPoint.fltyre])
        table.insert(tyres, self.DummyPointMap.Map[DummyPoint.frtyre])
        table.insert(tyres, self.DummyPointMap.Map[DummyPoint.bltyre])
        table.insert(tyres, self.DummyPointMap.Map[DummyPoint.brtyre])
        self.ShellAdditionWheels = {}
        for i = 2, #cfg.NewMeshForm do
            local shellAddition = UIUtil.GetChild(cfg.NewMeshForm[i], shell)
            UIUtil.SetParentGameObject(tyres[i - 1], shellAddition, false)
            table.insert(self.ShellAdditionWheels, shellAddition)
        end
    end
end
--}}}







----------------------------------

function CarBuilder:BuildDummy()
    local resname = self:GetChassisDummy()
    if self:CheckSingleShell() then
        resname = self:GetSingleShellDummy()
    end
    local key = self:CreateMeshKeyDummy(resname)
    if resname ~= nil and resname ~= -1 and resname ~= "" then
        local mesh, dummy = MeshCacheMgr:Get():SwapMesh(resname)
        if mesh ~= nil then
            self.Root = mesh
            self.Root.name = string.format("Car_%d", self.ID)
        end

        if dummy ~= nil then
            self.DummyPointMap = dummy
        end
        self:AddMesh(key, mesh)
        --self:AddMeshObj(nil, mesh)
    end
end

function CarBuilder:BuildPart(grooveid)
    local partid = self:GetPartDataID(grooveid)
    local generation = self:GetPartDataGeneration(grooveid)
    local sticker = self:GetPartSticker(grooveid)
    if partid and partid <= 0 then
        return
    end

    local cfg = CarAssembleRule:Get():GetAssembleRuleCfg(self.PartDataList, grooveid, sticker)
    local meshcfg = self:GetPartMeshCfg(partid, generation, grooveid, sticker)
    if cfg == nil then
        if AssembleLogEnable then
            log("---   <<<<<<< AssembleRule为空：", grooveid)
        end
        return
    end

    if AssembleLogEnable then
        log("---   <<<<<<< 3 meshcfg配置表 模型挂点：", grooveid, meshcfg.mesh, cfg.hpoint, cfg.symhpoint)
    end

    local key = self:CreateMeshKeyGroovePart(meshcfg.mesh, grooveid)
    self:AddMeshGroup(grooveid, key, cfg.hpoint, cfg.NewOffset, cfg.symhpoint, cfg.NewOffset2, cfg.NewScale, cfg.NewSymScale)

    self:BuildComposeMat(grooveid)

    self:BuildStaticLink(grooveid, cfg)

    self:BuildDycLink(grooveid, cfg)
end

function CarBuilder:AddMeshGroup(grooveid, key, point, offset, symhpoint, symhoffset, scale, syscale, parent, sympartent)

    point, symhpoint = self:Expand_PulleyResetPoint(grooveid, point, symhpoint)

    self:AddMeshOld(grooveid, key, point, offset, scale, parent)--
    if symhpoint ~= "" and symhpoint ~= "-1" then
        self:AddMeshOld(grooveid, key, symhpoint, symhoffset, syscale, sympartent)--
    end
end

---@param cfg assemblerule_config_cell
function CarBuilder:BuildStaticLink(grooveid, cfg)
    if cfg.linkid > 0 then
        self:BuildLink(grooveid, cfg.linkid, cfg.linkpoint, cfg.symlinkpoint, cfg.NewLinkOffset, cfg.NewLinkSymOffset)
    end

end

---@param cfg assemblerule_config_cell
function CarBuilder:BuildDycLink(grooveid, cfg)
    if cfg.dyclinkid > 0 then
        if CarAssembleRule:Get():IsAssembleDycLink(self.PartDataList, grooveid) then
            self:BuildLink(grooveid, cfg.dyclinkid, cfg.linkpoint, cfg.symlinkpoint, cfg.NewLinkOffset, cfg.NewLinkSymOffset)
        end
    end
end

----根据连接件id，分解得到连接件各部分的mesh和坐标偏移，用的是vector3（拆箱装箱）
---@param id @连接件id
---@param grooveid @槽位id
function CarBuilder:BuildLink(grooveid, id, point, sympoint, offset, symoffset)
    ---@type assemblelink_config_cell
    local linkcfg = CommonHelper:GetTableDataByID(ConfigNames.assemblelink_config, id)
    if linkcfg then
        for i = 1, #linkcfg.NewLinkIds do
            local resname = self:GetMeshCfgResNameById(linkcfg.NewLinkIds[i])

            local offset1 = linkcfg.NewLinkOffsets[i]:Add(offset)
            local offset2 = linkcfg.NewLinkOffsets[i]:Add(symoffset)
            local key = self:CreateMeshKeyLinkPart(resname, grooveid, i)
            self:AddMeshGroup(grooveid, key, point, offset1, sympoint, offset2)
        end
    end
end

function CarBuilder:BuildComposeMat(grooveid)

    local data = self.PartDataList[grooveid]
    if data == nil then
        return
    end

    if data:GetPartID() <= 0 then
        return
    end

    local composeIds = data:GetComposeIds()
    if composeIds == nil or #composeIds <= 0 then
        return
    end

    local renderNames = self:GetPartMeshRenderNameList(data:GetPartID(), data:GetGeneration(), grooveid, self.StickerID)
    if renderNames == nil or #renderNames <= 0 then
        return
    end

    if #renderNames ~= #composeIds then
        print("---   error:CarBuilder:BuildComposeMat   配件个数与meshrander个数不匹配", #renderNames, #composeIds)
        return
    end

    local meshname = ""
    local meshcfg = self:GetPartMeshCfg(self:GetPartDataID(grooveid), self:GetPartDataGeneration(grooveid), grooveid, self.StickerID)
    if meshcfg then
        meshname = meshcfg.mesh
    end

    local objlist = self:GetMeshListByGrooveID(grooveid, meshname)

    for loopA = 1, #objlist do
        local obj = objlist[loopA]
        for loopB = 1, #composeIds do
            local matname = self:GetPartMatName(composeIds[loopB], grooveid)
            local mlist = renderNames[loopB]
            if matname ~= "" then
                local mat = MatCacheDataMgr:Get():SwapMaterial(matname)
                --print("---   创建高级配件，加载材质球",composeIds[loopB], matname, mat)
                if mat then
                    self:AddMaterial(mat)
                    for loopC = 1, #mlist do
                        local m = UIUtil.GetTypeChildWightByParent(mlist[loopC], obj, typeof(MeshRenderer))
                        if not CommonHelper:GameObjectIsNull(m) then
                            m.material = mat
                        end
                    end

                end

            end
        end
    end

end

function CarBuilder:BuildDefaultPart(meshid, type)
    if meshid == nil or meshid <= 0 then
        return
    end
    if not self:IsBuildDefaultMesh(type) then
        return
    end

    if AssembleLogEnable then
        log("---   <<<<<<<   BuildDefaultPart   1  meshid = ", meshid, "  type =", type)
    end

    ---@type meshcfg_config_cell
    local meshCfg = CommonHelper:GetTableDataByID(ConfigNames.meshcfg_config, meshid)
    --log("---   <<<<<<<   BuildDefaultPart  meshcfg查找结果",meshCfg)
    if meshCfg then
        ---@type assembledefaultmesh_config_cell
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.assembledefaultmesh_config, meshCfg.flag)
        --log("---   <<<<<<<   BuildDefaultPart  assembledefaultmesh查找结果",cfg)
        if cfg then
            if AssembleLogEnable then
                log("---   <<<<<<<   BuildDefaultPart   2  meshname = ", meshCfg.mesh, "  挂点组 = ", cfg.point1, cfg.NewOffset1:GetData(), cfg.point2, cfg.NewOffset2:GetData(), cfg.C_ID)
            end
            local key = self:CreateMeshKeyDefaultPart(meshCfg.mesh)
            self:AddMeshGroup(nil, key, cfg.point1, cfg.NewOffset1, cfg.point2, cfg.NewOffset2, cfg.NewScale, cfg.NewSymScale)
        end
    end

end

function CarBuilder:BuildShellLock(meshid)
    local partid = self:GetPartDataID(PartGrooveID.Chassis)
    local generation = self:GetPartDataGeneration(PartGrooveID.Chassis)
    if partid ~= -1 and partid ~= nil then
        local cfg = self:GetPartMeshCfg(partid, generation)
        if cfg then
            local lockid = cfg.NewInitModel[1]
            if lockid then
                meshid = lockid
            end
        end
    end
    self:BuildDefaultPart(meshid, nil)
end

----------------------------------



function CarBuilder:GetPulleyPointByGrooveID(grooveid)
    local result = {}
    local meshname = ""

    local partid = self:GetPartDataID(grooveid)
    local generation = self:GetPartDataGeneration(grooveid)
    if partid and partid > 0 then
        local meshcfg = self:GetPartMeshCfg(partid, generation, grooveid, self.StickerID)
        if meshcfg then
            meshname = meshcfg.mesh
        end
    else
        print("---------->>>", self:GetPartDataID(grooveid), grooveid)
    end

    local objlist = self:GetMeshListByGrooveID(grooveid, meshname)
    if #objlist == 2 then
        for i = 1, #objlist do
            local obj = objlist[i]
            if obj then
                result[i] = obj.transform.parent.gameObject
            else
                result[i] = -1
            end
        end
    else
        if #objlist ~= 0 then
            logError("---   error:导轮安装个数异常，grooveid = ", grooveid, "   数量 = ", #objlist)
        else
            --log("---   CSharpCarDataResource  GetPulleyPointByGrooveID   槽位上没有导轮，grooveid = ", grooveid)
        end

        result[1] = -1
        result[2] = -1
    end
    return result
end
function CarBuilder:GetPulleyObjsByGrooveID(grooveid, result)
    local meshname = ""
    if result == nil then
        result = {}
    end
    local partid = self:GetPartDataID(grooveid)
    local generation = self:GetPartDataGeneration(grooveid)
    local partsticker = self:GetPartSticker(grooveid)
    if partid and partid > 0 then
        local meshcfg = self:GetPartMeshCfg(partid, generation, grooveid, partsticker)
        if meshcfg then
            meshname = meshcfg.mesh
        end
    else
        logError("----->" .. grooveid)
    end

    local objlist = self:GetMeshListByGrooveID(grooveid, meshname)
    for i = 1, #objlist do
        result[i] = objlist[i]
    end
    return result
end

function CarBuilder:IsBuildDefaultMesh(partchildtype)
    local result = true

    ---@type dictparts_config_cell
    local partCfg

    local partlist = {}
    table.insert(partlist, self:GetPartDataID(PartGrooveID.Strong1))
    table.insert(partlist, self:GetPartDataID(PartGrooveID.Strong2))
    table.insert(partlist, self:GetPartDataID(PartGrooveID.Strong3))
    table.insert(partlist, self:GetPartDataID(PartGrooveID.Strong4))
    --table.insert(partlist, self:GetPartDataID(PartGrooveID.Strong5))
    --table.insert(partlist, self:GetPartDataID(PartGrooveID.Strong6))
    --table.insert(partlist, self:GetPartDataID(PartGrooveID.Strong7))
    --table.insert(partlist, self:GetPartDataID(PartGrooveID.Strong8))

    for i = 1, #partlist do
        local partid = partlist[i]
        if partid > 0 then
            partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partid)
            local baseCfg = CommonHelper:GetPartBaseCfg(partid)
            if baseCfg and baseCfg.parttype == PartType.Stronger and baseCfg.subtype == partchildtype then
                result = false
                break
            end
        end
    end

    return result

end

function CarBuilder:BuilderChassisSwitchTips()
    --车扣，电池，轮轴，轴承，传动轴，电池片，车底盘开关
    local partid = self:GetPartDataID(PartGrooveID.Chassis)
    if partid == -1 or partid == nil then
        return
    end
    local mesh = self:GetPulleyObjsByGrooveID(PartGrooveID.Chassis)[1]
    local obj = UIUtil.GetChildInputPath(ChassisSwitchHit, mesh)
    self.SwitchHitAsset = AssetsManager.Load(ChassisSwitchHitFX, typeof(GameObject))
    self.SwitchTipsGo = CommonHelper:InstantiateGameObjectByObject(self.SwitchHitAsset.asset)
    UIUtil.SetParentTransform(obj, self.SwitchTipsGo, true, false)
end
function CarBuilder:ReleaseTips()
    if self.SwitchTipsGo then
        GameObject.Destroy(self.SwitchTipsGo)
        AssetsManager.Unload(self.SwitchHitAsset)
        self.SwitchTipsGo = nil
        self.SwitchHitAsset = nil
    end
end
function CarBuilder:EnableShellAnim()
    if self:CheckSingleOtherShell() then
        local shell = self:GetShellObj()
        if shell == nil then
            return
        end
        local anim=  UIUtil.GetGameobjectComponent(shell, typeof(CS.UnityEngine.Animator))
        if not CommonHelper:GameObjectIsNull(anim) then
            anim.enabled=true
        end
    end
end
function CarBuilder:DisableShellAnim()
    if self:CheckSingleOtherShell() then
        local shell = self:GetShellObj()
        if shell == nil then
            return
        end
        local anim=  UIUtil.GetGameobjectComponent(shell, typeof(CS.UnityEngine.Animator))
        if not CommonHelper:GameObjectIsNull(anim) then
            anim.enabled=false
        end
    end

end

function CarBuilder:BuilderChassisSwitchFx()
    local partid = self:GetPartDataID(PartGrooveID.Chassis)
    if partid == -1 or partid == nil then
        return
    end
    local baseCfg = self:GetPartBaseCfg(partid)
    local mesh = self:GetPulleyObjsByGrooveID(PartGrooveID.Chassis)[1]
    local obj = UIUtil.GetChildInputPath(ChassisSwitchRoot, mesh)
    self.SwitchGo = UIUtil.GetChildInputPath(self.SwitchName, mesh)
    self.ChassisSwitchFxAsset = AssetsManager.Load(baseCfg.chassisSwitchFx, typeof(GameObject))
    self.ChassisSwitchFxGo = CommonHelper:InstantiateGameObjectByObject(self.ChassisSwitchFxAsset.asset)
    UIUtil.SetParentTransform(obj, self.ChassisSwitchFxGo, true, false)
    local fxroot = UIUtil.GetChildInputPath(ChassisSwitchHitFXRoot, self.ChassisSwitchFxGo)
    UIUtil.SetParentTransform(fxroot, self.SwitchGo, true, false)
end
function CarBuilder:ReleaseChassisSwitchFx()
    if self.ChassisSwitchFxGo then
        local partid = self:GetPartDataID(PartGrooveID.Chassis)
        if partid == -1 or partid == nil then
            return
        end
        local mesh = self:GetPulleyObjsByGrooveID(PartGrooveID.Chassis)[1]
        local obj = UIUtil.GetChildInputPath(ChassisSwitchRoot, mesh)
        UIUtil.SetParentTransform(obj, self.SwitchGo, true, false)
        GameObject.Destroy(self.ChassisSwitchFxGo)
        AssetsManager.Unload(self.ChassisSwitchFxAsset)
        self.ChassisSwitchFxGo = nil
        self.ChassisSwitchFxAsset = nil
    end
end
function CarBuilder:BuildChassisSwitch(meshid, type)
    if meshid == nil or meshid <= 0 then
        return
    end
    if AssembleLogEnable then
        log("---   <<<<<<<   BuildDefaultPart   1  meshid = ", meshid, "  type =", type)
    end

    ---@type meshcfg_config_cell
    local meshCfg = CommonHelper:GetTableDataByID(ConfigNames.meshcfg_config, meshid)
    --log("---   <<<<<<<   BuildDefaultPart  meshcfg查找结果",meshCfg)
    if meshCfg then
        ---@type assembledefaultmesh_config_cell
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.assembledefaultmesh_config, meshCfg.flag)
        --log("---   <<<<<<<   BuildDefaultPart  assembledefaultmesh查找结果",cfg)
        if cfg then
            if AssembleLogEnable then
                log("---   <<<<<<<   BuildDefaultPart   2  meshname = ", meshCfg.mesh, "  挂点组 = ", cfg.point1, cfg.NewOffset1:GetData(), cfg.point2, cfg.NewOffset2:GetData(), cfg.C_ID)
            end
            local key = self:CreateMeshKeyDefaultPart(meshCfg.mesh)
            self.SwitchName = meshCfg.mesh
            local mesh = self:GetPulleyObjsByGrooveID(PartGrooveID.Chassis)[1]
            local partent = UIUtil.GetChild(cfg.point1, mesh)
            local sympartent = UIUtil.GetChild(cfg.point2, mesh)
            self:AddMeshGroup(nil, key, cfg.point1, cfg.NewOffset1, cfg.point2, cfg.NewOffset2, cfg.NewScale, cfg.NewSymScale, partent, sympartent)
        end
    end

end

