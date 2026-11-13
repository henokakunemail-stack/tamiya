



---@class CarBuilderHelper
CarBuilderHelper = class("CarBuilderHelper")
function CarBuilderHelper:initialize()

end

--{{{解析车所有mesh资源名

----获取所有part、连接件、底盘挂点 的mesh prefab名字，然后在添加 multiMesh、meshBaker、shell、grid、metal、plastic 的合批prefab
---@param partlist table<number, CarBuilderPartData>
function CarBuilderHelper:AnalyseAllMeshRes(partlist,stickerid)--key:槽位id
    local result = CarBuilderHelper:AnalysePartsMeshRes(partlist,stickerid)
    table.insert(result, CarBuilderHelper:GetChassisDummy(partlist))
    table.insert(result, MutliMeshBakerPrefab)
    table.insert(result, MeshBakerPrefab)
    table.insert(result, MeshBackerPrefabShell)
    table.insert(result, MeshBackerPrefabGrid)
    table.insert(result, MeshBackerPrefabMetal)
    table.insert(result, MeshBackerPrefabPlatstic)
    return result
end

---@param partlist table<number, CarBuilderPartData>@key 是槽位id，返回配件的mesh名字或者连接件的名字
---@return table<number,string>@返回
function CarBuilderHelper:AnalysePartsMeshRes(partlist,stickerId)
    local result = {}
    local shellid = -1
    local shellgeneration=1
    local shellsticker=0
    if partlist and partlist[PartGrooveID.Shell] then
        shellid = partlist[PartGrooveID.Shell]:GetPartID()
        shellgeneration=partlist[PartGrooveID.Shell]:GetGeneration()
        shellsticker=partlist[PartGrooveID.Shell]:GetSticker()
    end
    if CarBuilderHelper:CheckSingleShell(shellid) then
        if shellid and shellid > 0 then
            local resnames = CarBuilderHelper:GetMeshCfgResName(shellid,shellgeneration,PartGrooveID.Shell,shellsticker)
            for i = 1, #resnames do
                if resnames[i] ~= "" and resnames[i] ~= nil then
                    table.insert(result, resnames[i])
                end
            end
            local linkname = CarBuilderHelper:AnalyseLinkMeshRes(partlist, PartGrooveID.Shell,shellsticker)
            for i = 1, #linkname do
                if linkname[i] ~= "" and linkname[i] ~= nil then
                    table.insert(result, linkname[i])
                end
            end
        end
    else
        for k,v in pairs(partlist) do
            local partid = v:GetPartID()
            local sticker = v:GetSticker()
            if partid and partid > 0 then
                local resnames = CarBuilderHelper:GetMeshCfgResName(partid,v.generation,k,sticker)
                for i = 1, #resnames do
                    if resnames[i] ~= "" and resnames[i] ~= nil then
                        table.insert(result, resnames[i])
                    end
                end

                if k > 0 then
                    local linkname = CarBuilderHelper:AnalyseLinkMeshRes(partlist, k,sticker)
                    for i = 1, #linkname do
                        if linkname[i] ~= "" and linkname[i] ~= nil then
                            table.insert(result, linkname[i])
                        end
                    end
                end
            end
        end
    end


    return result
end

----根据槽位id 获取该槽位的规则中 连接件 部分的 mesh 资源名字
---@param partlist table<number, CarBuilderPartData>
function CarBuilderHelper:AnalyseLinkMeshRes(partlist, grooveid)
    local result = {}

    local partid = -1
    if partlist and partlist[grooveid] then
        partid = partlist[grooveid]:GetPartID()
    end
    if partid <= 0 then return result end

    local cfg = CarAssembleRule:Get():GetAssembleRuleCfg(partlist, grooveid)
    if cfg == nil then
        return result
    end

    -----获取静态连接件组的mesh 名字
    if cfg.linkid > 0 then
        ---@type assemblelink_config_cell
        local linkcfg = CommonHelper:GetTableDataByID(ConfigNames.assemblelink_config, cfg.linkid)
        if linkcfg then
            for i = 1, #linkcfg.NewLinkIds do
                local resname = CarBuilderHelper:GetMeshCfgResNameById(linkcfg.NewLinkIds[i])
                table.insert(result, resname)
            end
        end
    end
    -----获取动态连接件组的mesh 名字
    if cfg.dyclinkid > 0 then
        local linkcfg = CommonHelper:GetTableDataByID(ConfigNames.assemblelink_config, cfg.dyclinkid)
        if linkcfg then
            for i = 1, #linkcfg.NewLinkIds do
                local resname = CarBuilderHelper:GetMeshCfgResNameById(linkcfg.NewLinkIds[i])
                table.insert(result, resname)
            end
        end
    end

    return result
end

----获取车上底盘挂点的 prefab名字
---@param partlist table<number, CarBuilderPartData>
function CarBuilderHelper:GetChassisDummy(partlist)
    local chassisid = -1
    local generation=1
    local sticker=0
    local shellid = -1
    local shellgeneration=1
    local shellsticker=0
    if partlist and partlist[PartGrooveID.Shell] then
        shellid = partlist[PartGrooveID.Shell]:GetPartID()
        shellgeneration=partlist[PartGrooveID.Shell]:GetGeneration()
        shellsticker=partlist[PartGrooveID.Shell]:GetSticker()
    end
    if CarBuilderHelper:CheckSingleShell(shellid) then
        ---@type dummy_config_cell
        local dummycfg = CommonHelper:GetTableDataByID(ConfigNames.dummy_config, shellid)
        if dummycfg == nil then
            logError("---   error:CarBuilderHelper  找不到正确dummy资源,   333   dummycfg = nil, flag = ", shellid)
            return DufaultDummyPrefabName
        end
        return dummycfg.resname
    end

    if partlist and partlist[PartGrooveID.Chassis] then
        chassisid = partlist[PartGrooveID.Chassis]:GetPartID()
        generation=partlist[PartGrooveID.Chassis]:GetGeneration()
        sticker=partlist[PartGrooveID.Chassis]:GetSticker()
    end

    if chassisid == nil or chassisid == -1 then
        logError("---   error:CarBuilderHelper  找不到正确dummy资源,   111   partcfg中chassisid = ", chassisid)
        return DufaultDummyPrefabName
    end

    local cfg = CarBuilderHelper:GetPartMeshCfg(chassisid,generation,sticker)
    if cfg == nil then
        logError("---   error:CarBuilderHelper  找不到正确dummy资源,   222   meshcfg = nil, chassisid = ",chassisid)
        return DufaultDummyPrefabName
    end

    ---@type dummy_config_cell
    local dummycfg = CommonHelper:GetTableDataByID(ConfigNames.dummy_config, cfg.flag)
    if dummycfg == nil then
        logError("---   error:CarBuilderHelper  找不到正确dummy资源,   333   dummycfg = nil, flag = ", cfg.flag)
        return DufaultDummyPrefabName
    end
    return dummycfg.resname
end
--}}}
function CarBuilderHelper:CheckSingleShell(partid)
    local flag=false
    if PartIdDefine then
        for k, v in pairs(PartIdDefine) do
            if partid==v then
                flag=true
                break
            end
        end
    end
    return flag
end


--{{{解析车所有材质球

----解析车的 贴纸  纱网  配件和合成配件材质球的名字
---@return table<number,string>
---@param partlist table<number, CarBuilderPartData>
function CarBuilderHelper:AnalyseAllMaterialRes(defaultsticker, strickerid, grids, partlist)
    local result = {}
    result = CarBuilderHelper:AnalyseStickerMaterialRes(result, defaultsticker, strickerid)
    result = CarBuilderHelper:AnalyseGridsMaterialRes(result, grids)
    result = CarBuilderHelper:AnalyseComposePartMaterialRes(result, partlist,strickerid)
    return result
end

----根据贴纸id 或者 默认贴纸id 返回贴纸的材质球名字，如果没有换贴纸就返回默认的，换了就返回两者的
function CarBuilderHelper:AnalyseStickerMaterialRes(result, defaultsticker, strickerid)
    ---@type apsticker_config_cell
    local stickercfg = CommonHelper:GetTableDataByID(ConfigNames.apsticker_config, defaultsticker)
    if stickercfg ~= nil then table.insert(result, stickercfg.NewMat) end

    if strickerid and strickerid ~= -1 and strickerid ~= 0 then
        stickercfg = CommonHelper:GetTableDataByID(ConfigNames.apsticker_config, strickerid)
        if stickercfg ~= nil then table.insert(result, stickercfg.NewMat) end
    end
    if stickercfg ~= nil and stickercfg.NewMatAdditional~="0" then table.insert(result, stickercfg.NewMatAdditional) end
    return result
end
----根据纱网id 返回纱网的 材质球名字
function CarBuilderHelper:AnalyseGridsMaterialRes(result, grids)
    for i = 1, #grids do
        local gridid = grids[i]
        if gridid ~= nil and gridid ~= 0 then
            ---@type apgrid_config_cell
            local gridcfg = CommonHelper:GetTableDataByID(ConfigNames.apgrid_config, gridid)
            if gridcfg ~= nil then table.insert(result, gridcfg.NewMat) end
        end
    end
    return result
end

----返回该配件各合成配件的材质球 名字
---@param partlist table<number, CarBuilderPartData>
function CarBuilderHelper:AnalyseComposePartMaterialRes(result, partlist,stickerid)
    for k,v in pairs(partlist) do
        if v ~= nil then
            if k > 0 then
                local list = v:GetComposeIds()
                if list and #list > 0 then
                    for i = 1, #list do
                        local matname = CarBuilderHelper:GetPartMatName(list[i],k,stickerid)
                        if matname and matname ~= "" then
                            table.insert(result, matname)
                        end
                    end
                end
            end
        end
    end
    return result
end
--}}}






--{{{常用方法，获取配置数据
----根据partId 获取到该配件的所有组装模型的mesh名字,有可能是一个，也有可能是多个，比如底盘由多个mesh组成
---@return table<number,string>
function CarBuilderHelper:GetMeshCfgResName(partId,generation,grooveid,stickerid)
    local result = {}
    ---@type dictparts_config_cell
    local partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partId)
    if partCfg == nil or partCfg.recource == 0 or partCfg.recource == -1 then
        return result
    end

    ---@type meshcfg_config_cell
    local meshCfg = CarBuilderHelper:GetPartMeshCfg(partId,generation,grooveid,stickerid)
    if meshCfg == nil then
        return result
    end

    result[1] = meshCfg.mesh

    if meshCfg.NewInitModel then
        for i = 1, #meshCfg.NewInitModel do
            local temp = CarBuilderHelper:GetMeshCfgResNameById(meshCfg.NewInitModel[i])
            if temp and temp ~= "" then table.insert(result, temp) end
        end
    end
    return result
end

----根据partId 获取part的meshCfg
---@return meshcfg_config_cell
function CarBuilderHelper:GetPartMeshCfg(partId,generation,groove,stickerid)
    ---@type dictparts_config_cell
    local partcfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partId)
    if partcfg == nil then return end
    ---@type meshcfg_config_cell
    local meshCfg = CommonHelper:GetTableDataByID(ConfigNames.meshcfg_config, partcfg.recource)
    if generation and generation>1 then
        if generation==2 then
            meshCfg=CommonHelper:GetTableDataByID(ConfigNames.meshcfg_config, partcfg.recource2)
        end
        if generation==3 then
            meshCfg=CommonHelper:GetTableDataByID(ConfigNames.meshcfg_config, partcfg.recource3)
        end
        if generation==4 then
            meshCfg=CommonHelper:GetTableDataByID(ConfigNames.meshcfg_config, partcfg.recource4)
        end
    end
    if groove  and stickerid then
        ---@type apsticker_config_cell
        local stickercfg = CommonHelper:GetTableDataByID(ConfigNames.apsticker_config, stickerid)
        if stickercfg ~= nil and stickercfg.mesh and stickercfg.mesh~=0 then
            meshCfg=CommonHelper:GetTableDataByID(ConfigNames.meshcfg_config,stickercfg.mesh)
        end
    end
    return meshCfg
end

----根据mesh id 获取mesh的prefab名字
function CarBuilderHelper:GetMeshCfgResNameById(id)
    if id == nil or id == 0 or id == -1 then return "" end

    ---@type meshcfg_config_cell
    local tempcfg = CommonHelper:GetTableDataByID(ConfigNames.meshcfg_config, id)
    if tempcfg then return tempcfg.mesh end
    return ""
end

----根据partId 获取该配件的材质球名字
function CarBuilderHelper:GetPartMatName(partId,generation,groove,stickerid)
    ---@type parts_config_cell
    local partCfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partId)
    if partCfg and partCfg.recource ~= 0 and partCfg.recource ~= -1 then
        ---@type meshcfg_config_cell
        local meshCfg = CarBuilderHelper:GetPartMeshCfg(partId,generation,groove,stickerid)
        if meshCfg then
            return meshCfg.meshcolor
        end
    end
    return ""
end
--}}}