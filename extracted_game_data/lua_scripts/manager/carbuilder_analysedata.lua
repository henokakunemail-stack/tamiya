


--{{{设置组装数据
----设置车的组装数据，比如车的配件，车壳id，纱网id
---@param param CarBuilderParam
function CarBuilder:SetParam(param)
    self.BuildParam=param
    self.newCarID = param.newCarId
    self.tableID = param.tableID
    self.suitID = param.suitID
    self.BuildType = param.buildType
    self.finishEvt = param.finishEvt
    self.finishParam = param.finishParam
    self.CombineType = param.combineType
    self.IsBuildTexture=param.BuilderTexture
    self.Parent = param.parent
    self:AnalyseData(param)
end
--}}}


---@param param CarBuilderParam
function CarBuilder:AnalyseData(param)
    if param==nil then param=self.BuildParam end
    if self.BuildType == CarBuilderType.Table then
        self:AnalysePartList_CarCfg()
        self:AnalyseLightweight(param.lightweight)
        self:AnalyseShellGrid(param.grids)
        self:AnalyseShellColor(param.colorid)
        self:AnalyseSticker(param.stickerid)
        self:AnalyseDefaultColor()
    elseif self.BuildType == CarBuilderType.Assemble then
        local cardata = CarDataManager:Get():GetCarDataByCarID(self.newCarID)
        self:AnalysePartList_Assemble()
        if cardata then
            self:AnalyseLightweight(cardata:GetLightweight())
            self:AnalyseShellGrid(cardata:GetShellGridList())
            self:AnalyseShellColor(cardata:GetShellColor())
            self:AnalyseSticker(cardata:GetShellSticker())
        end
        self:AnalyseDefaultColor()
    elseif self.BuildType == CarBuilderType.Data then
        self:AnalysePartList_Data(param.parts)
        self:AnalyseLightweight(param.lightweight)
        self:AnalyseShellGrid(param.grids)
        self:AnalyseShellColor(param.colorid)
        self:AnalyseSticker(param.stickerid)
        self:AnalyseDefaultColor()
    end
end

--{{{解析配件数据
function CarBuilder:CreatePartData(grooveid, partid, composeids,PartGeneration,sticker)
    local data = CarBuilderPartData()
    data:SetData(partid, composeids,PartGeneration,sticker)
    self.PartDataList[grooveid] = data
end

----根据car表里面的车辆id，得到它的配件，然后根据配件转换成服务器的槽位，然后构建出车的配件数据，比如：导轮的半径
function CarBuilder:AnalysePartList_CarCfg()
    local cfg = self:GetCfg_CarEquipment(self.tableID)
    if cfg == nil then return end

    local partList = AssembleHelper:AnalyseCfgToMsgParts(cfg)

    for i = 1, #partList do
        local grooveid = AssembleHelper:MsgIdxToGrooveID(i)
        if grooveid then
            local partid = partList[i]
            ---@type parts_config_cell
            local cfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partid)
            if cfg then
                self:CreatePartData(grooveid, partid, cfg.NewComposeIDs,1,0)
            end
        end
    end
end
----通过撤的id得到车的数据，然后根据车的槽位 反推出配件
function CarBuilder:AnalysePartList_Assemble()
    local cardata = CarDataManager:Get():GetCarDataByCarID(self.newCarID)
    for k,v in pairs(PartGrooveID) do
        if cardata then
            local node=cardata.assembleMgr:GetNodeByGrooveID(v)
            if node then
                local partid = node:GetPartId(true)
                local generation=node:GetGeneration()
                local sticker=node:GetSticker(true)
                local composeids = {}
                local articledata = KnapsackDataManager:Get():GetArticleByID(cardata.assembleMgr:GetNodeByGrooveID(v):GetBagId())
                if articledata then
                    composeids = articledata:GetPartComposeIds()
                end

                self:CreatePartData(v, partid, composeids,generation,sticker)
            end
        end
    end
end
----根据套装id 获取车的数据，从而获取配件数据
function CarBuilder:AnalysePartList_Suit()
    local suit = SuitDataManager:Get():GetSuit(self.suitID)
    local cardata = suit:GetCarData()
    for k,v in pairs(PartGrooveID) do
        local partid = cardata.assembleMgr:GetNodeByGrooveID(v):GetPartId()
        local sticker = cardata.assembleMgr:GetNodeByGrooveID(v):GetSticker()
        local composeids = {}
        local articledata = KnapsackDataManager:Get():GetArticleByID(cardata.assembleMgr:GetNodeByGrooveID(v):GetBagId())
        if articledata then
            composeids = articledata:GetPartComposeIds()
        end

        self:CreatePartData(v, partid, composeids, cardata.assembleMgr:GetNodeByGrooveID(v):GetGeneration(),sticker)
    end
end

---@param parts table<number, Lua_PartData>
function CarBuilder:AnalysePartList_Data(parts)
    for i = 1, #parts do
        local temp = parts[i]
        local grooveid = AssembleHelper:MsgIdxToGrooveID(i)
        if grooveid and temp then
            self:CreatePartData(grooveid, temp.PartCfgID, temp.ComposeIds,temp.PartGeneration,temp.sticker)
        end
    end
end
--}}}
