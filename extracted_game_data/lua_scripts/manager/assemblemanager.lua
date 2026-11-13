


---@class AssembleManager
AssembleManager = class("AssembleManager")

function AssembleManager:initialize()
    ---@type table<number, CarDetailData>
    self.NodeList = {}
end



---@param msg SC_UserCarDetail[]
---@param msg KnapsackData
function AssembleManager:SetData(id,parts,isself,KnapsackData)
    self.CarID = id
    for i = 1, #parts do
        local temp=CarDetailData()
        temp:SetData(self,parts[i],isself,KnapsackData)
        table.insert(self.NodeList,temp)
    end
    local temp=self:CheckArticleAdaptationChassis()
    for i = 1, #temp do
        local node= self:GetNodeByGrooveID(temp[i])
        node:SetGrooveState(GrooveState.NoMatching)
    end
end

---@param parts table<number, Lua_PartData>
function AssembleManager:SetDataByPartList(id,parts,isself)
    self.CarID = id
    for i = 1, #parts do
        local temp=CarDetailData()
        temp:SetDataByLuaPartData(self,parts[i],i,isself)
        table.insert(self.NodeList,temp)
    end
    local temp=self:CheckArticleAdaptationChassis()
    for i = 1, #temp do
        local node= self:GetNodeByGrooveID(temp[i])
        node:SetGrooveState(GrooveState.NoMatching)
    end
end

function AssembleManager:UpdatePartList()
    for i = 1, #self.NodeList do
        self.NodeList[i]:UpdateCfg()
    end
end

---@return CarDetailData
function AssembleManager:GetNodeByGrooveID(grooveid)
    local error = nil
    for i = 1, #self.NodeList do
        if self.NodeList[i]:GetGrooveId() == grooveid then
            return self.NodeList[i]
        end

        if self.NodeList[i]:GetGrooveId() == PartGrooveID.Error then
            error = self.NodeList[i]
        end
    end
    if AssembleLogEnable then
        logError("---   error:没有找到槽位：grooveid = ",grooveid)
    end
    return error
end
---@return CarDetailData
function AssembleManager:GetPartByBagID(bagId)
    local error = nil
    for i = 1, #self.NodeList do
        if self.NodeList[i]:GetBagId() == bagId then
            return self.NodeList[i]
        end

        if self.NodeList[i]:GetBagId() == PartGrooveID.Error then
            error = self.NodeList[i]
        end
    end
    if AssembleLogEnable then
        logError("---   error:没有找到配件：grooveid = ",bagId)
    end
    return error
end

---@return CarDetailData
function AssembleManager:CheckArticleAdaptationChassis()
    local temp={}
    local node= self:GetNodeByGrooveID(PartGrooveID.Chassis)
    if node then
        ---@type dictpartbase_config_cell
        local ChassisNode= node:GetPartBaseCfg()
        if ChassisNode then
            for k, v in pairs(PartGrooveID) do
                local node=  self:GetNodeByGrooveID(v)
                if node and node:GetBagId() then
                    if node:GetBagId()<=0 then
                    else
                        ---@type dictpartbase_config_cell
                        local Cell=node:GetPartBaseCfg()
                        if Cell then
                            local ChassisLimit =Cell.NewChassisLimit
                            if #ChassisLimit==0 then

                            else
                                local result=false
                                for i = 1,#ChassisLimit  do
                                    if ChassisLimit[i]==ChassisNode.subtype then
                                        result=true
                                        break
                                    end
                                end
                                if result==false then
                                    table.insert(temp,v)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return temp
end




























function AssembleManager:InitData(carId, msg, groovemsg)
    self.CarID = carId

    ----构建配件槽位表
    self:InitMap()

    ---设置服务器数据
    self:SetMsgData(msg)
    self:SetGrooveListState(groovemsg)
    self:UpdateClientData()
end

function AssembleManager:AddNodeList(node)
    table.insert(self.NodeList, node)
end




----------------------------------------------------------------------------------------构建map
function AssembleManager:NewNode(grooveId)
    local node = AssembleNode({self.CarID, self})
    local equipment = AssembleEquipmentData(node)
    local groove = AssembleGrooveData({grooveId, node})
    local clientdata = AssembleClientData({grooveId, node})
    node:SetNode(equipment, groove, clientdata)
    self:AddNodeList(node)
    return node
end

function AssembleManager:InitMap()
    for k, v in pairs(PartGrooveID) do
        self:NewNode(v)
    end
end

function AssembleManager:SetMsgData(msg)

    for i = 1, #msg do
        local grooveid = AssembleHelper:MsgIdxToGrooveID(i)
        self:GetNodeByGrooveID(grooveid):SetEquipmentData_IgnoreLimit(msg[i])
    end
end

function AssembleManager:SetGrooveListState(groovemsg)
    for k, v in pairs(PartGrooveID) do
        local temp = self:GetNodeByGrooveID(v)
        temp:SetGrooveData(self:IsOpenGroove(v, groovemsg))
    end

end
function AssembleManager:IsOpenGroove(grooveid, groovemsg)
    for i = 1, #groovemsg do
        if grooveid == groovemsg[i] then
            return  true
        end
    end

    return AssembleHelper:Check_StaticNode(grooveid)
end

--function AssembleManager:SetGrooveListStateClient()
--    for i = 1, #self.NodeList do
--        self.NodeList[i]:ClientSetFitterData()
--    end
--end
function AssembleManager:UpdateClientData()
    for i = 1, #self.NodeList do
        self.NodeList[i]:ClientSetFitterData()
        self.NodeList[i]:ClientClearOpenList()
    end
    for i = 1, #self.NodeList do
        local temp = self.NodeList[i]
        local cfg = temp:GetPartCfg()
        if cfg then
            local openpos = AssembleHelper:AnalysePartOpenGrooveID(temp:GetGrooveId(), cfg)
            if openpos then
                for m = 1, #openpos do
                    local node = self:GetNodeByGrooveID(openpos[m])
                    node:ClientAddOpenPart(temp)
                end
            end
        end
    end
    for i = 1, #self.NodeList do
        self.NodeList[i]:CalibrateServerData_Enable()
    end
end
----------------------------------------------------------------------------------------构建map



-----------------------------------------------------------------------------------穿上，更换，拆卸装备
---@param node AssembleNode
---@param articleCell ArticleCell
function AssembleManager:AssembleEquipment(node, articleCell)
    --if articleCell == nil then
    --    logError("---   error:更换装备异常，articleCell = nil")
    --    return
    --end
    --
    --node:SetEquipmentData(0)
    --node:SetEquipmentData(articleCell:GetPartConfig().id)
end


---@param node AssembleNode
function AssembleManager:DisassembleEquipment(node)
    --if node == nil then
    --    logError("---   error:拆除装备异常，节点为空")
    --    return
    --end
    --
    --if AssembleHelper:Check_NodeDisassemble(node) == false then
    --    return
    --end
    --
    --node:SetEquipmentData(0)
end
-----------------------------------------------------------------------------------穿上，更换，拆卸装备





-----------------------------------------------------------------------------------外部接口
---@return table<number,CarDetailData>
function AssembleManager:GetNodeList()
    return self.NodeList
end

---@param node AssembleNode
---@return AssembleNode
function AssembleManager:GetNodeByNode(node)
    local result = nil
    for i = 1, #self.NodeList do
        if self.NodeList[i].NodeID == node.NodeID then
            result = self.NodeList[i]
            break
        end
    end
    return result
end

-----------------------------------------------------------------------------------外部接口
