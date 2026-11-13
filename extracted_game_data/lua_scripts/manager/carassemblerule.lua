

---@class CarAssembleNode @挂点的信息 包含 槽位id 父物体 子物体
CarAssembleNode = class("CarAssembleNode")

function CarAssembleNode:initialize(id)
    self.GrooveId = id
    self.Parents = {}
    self.Childs = {}
end

function CarAssembleNode:AddParent(id)
    for i = 1, #self.Parents do
        if self.Parents[i] == id then
            return
        end
    end
    table.insert(self.Parents, id)
end

function CarAssembleNode:AddChild(id)
    for i = 1, #self.Childs do
        if self.Childs[i] == id then
            return
        end
    end
    table.insert(self.Childs, id)
end

function CarAssembleNode:GetParents()
    return self.Parents
end

function CarAssembleNode:GetChilds()
    return self.Childs
end



---@class CarAssembleRule
CarAssembleRule = class("CarAssembleRule")

function CarAssembleRule:initialize()
    self.Instance = nil
    ---@type table<number, CarAssembleNode>
    self.Map = {}
    ----挂点，里面是所有挂点的名字，挂点包括 配件挂点 配件连接件对称挂点 连接件挂点 连接件对称挂点
    self.DummyPoint = {}
end
function CarAssembleRule:Get()
    if self.Instance == nil then self.Instance = CarAssembleRule() end
    return self.Instance
end

----初始化车的挂点数据，以槽位id为key，找到该槽位的父节点和子节点，然后给dummyPoint添加所有组装规则的挂点数据，这是配置表的数据
function CarAssembleRule:Init()
    self.Map = {}

    ------------为每个槽位添加父节点和子节点，从assemble表里读取------------
    ---@type grooveid_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.grooveid_config)
    local cfgs = tab.GetConfigData()
    for k, v in pairs(cfgs) do
        local id = v.C_ID
        if self.Map[id] == nil then self.Map[id] = CarAssembleNode(id) end
        local node = self.Map[id]
        for i = 1, #v.NewList do
            local parentid = v.NewList[i]
            node:AddParent(parentid)

            if self.Map[parentid] == nil then self.Map[parentid] = CarAssembleNode(id) end
            local parentnode = self.Map[parentid]
            parentnode:AddChild(id)
        end
    end

    ------------为每个槽位的挂点 添加挂点gameobject的名字，挂点偏移位置，连接件挂点名字，连接件偏移位置-------
    ---@type assemblerule_config
    local ruletab = ClientDataManager:Get():GetDataTable(ConfigNames.assemblerule_config)
    local rulecfgs = ruletab.GetConfigData()
    for k,v in pairs(rulecfgs) do
        self.DummyPoint[v.hpoint] = v.hpoint
        self.DummyPoint[v.symhpoint] = v.symhpoint
        self.DummyPoint[v.linkpoint] = v.linkpoint
        self.DummyPoint[v.symlinkpoint] = v.symlinkpoint
    end

    ---@type assembledefaultmesh_config
    local defaultmeshtab = ClientDataManager:Get():GetDataTable(ConfigNames.assembledefaultmesh_config)
    local defaultmeshcfgs = defaultmeshtab.GetConfigData()
    for k,v in pairs(defaultmeshcfgs) do
        self.DummyPoint[v.point1] = v.point1
        self.DummyPoint[v.point2] = v.point2
    end

    self.DummyPoint[DummyPoint.body] = DummyPoint.body
end

function CarAssembleRule:Clear()
    self.Map = {}
end

----根据槽位id 得到该槽位上所有的父节点，然后根据节点获取到该槽位的组装规则
---@param partlist table<number, CarBuilderPartData>
---@return assemblerule_config_cell
function CarAssembleRule:GetAssembleRuleCfg(partlist, grooveid)
    if partlist == nil or grooveid == nil then return end

    local data = partlist[grooveid]

    if data == nil or data:GetPartID()==nil or data:GetPartID() <= 0 then return end


    ---@type meshcfg_config_cell
    local meshCfg = self:GetMeshCfg(data:GetPartID(),data:GetGeneration(),grooveid,data:GetSticker())
    if meshCfg == nil then return end

    local parentlist = self:GetParentMeshCfg(partlist, grooveid,data:GetSticker())
    local parentflag = {}
    for i = 1, #parentlist do
        if parentlist[i] then
            table.insert(parentflag, parentlist[i].flag)
        end
    end

    ---@type assemblerule_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.assemblerule_config)


    local data = tab.GetAssembleCfg(grooveid, meshCfg.flag, parentflag)

    if AssembleLogEnable then
        log("---   <<<<<<< 1 组装配置表 查找条件：",grooveid,meshCfg.flag,parentflag[1],parentflag[2],parentflag[3],"   <<<<<<< 2 查找结果：",ProtoMsgHelp.block(data))
    end


    return data
end

----根据partId 获取mesh表
---@return meshcfg_config_cell
function CarAssembleRule:GetMeshCfg(partid,generation,groove,stickerid)
    ---@type parts_config_cell
    local partcfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partid)
    if partcfg == nil then return end
    ---@type meshcfg_config_cell
    local meshCfg = CarBuilderHelper:GetPartMeshCfg(partid,generation,groove,stickerid)
    return meshCfg
end

----根据槽位id，返回该槽位的所有父节点上的meshCfg,就是一个槽位有多个父节点，返回父节点的meshCfg
---@param partlist table<number, CarBuilderPartData> @key 是槽位id
---@return table<number, meshcfg_config_cell>
function CarAssembleRule:GetParentMeshCfg(partlist, grooveid)

    ---@type table<number, meshcfg_config_cell>
    local result = {}

    ---@type grooveid_config_cell
    local groovecfg = CommonHelper:GetTableDataByID(ConfigNames.grooveid_config, grooveid)
    if groovecfg == nil then return result end

    for i = 1, #groovecfg.NewList do
        local data = partlist[groovecfg.NewList[i]]
        if data and data:GetPartID() and data:GetPartID() > 0 then
            table.insert(result, self:GetMeshCfg(data:GetPartID(),data:GetGeneration(),groovecfg.NewList[i],data:GetSticker()))
        end
    end

    return result
end


----获取该槽位是不是动态连接件，连接件不属于配件
---@param partlist table<number, CarBuilderPartData>
function CarAssembleRule:IsAssembleDycLink(partlist, grooveid)
    local result = true
    local node = self.Map[grooveid]
    if node then
        local childs = node:GetChilds()
        for i = 1, #childs do
            local data = partlist[childs[i]]
            if data ~= nil and data:GetPartID() > 0 then
                result = false
                break
            end
        end
    end

    return result
end

----返回所有组装规则的挂点数据，包括挂点偏移 挂点位置 连接件的名字  偏移位置
function CarAssembleRule:GetDummyPointMap()
    return self.DummyPoint
end