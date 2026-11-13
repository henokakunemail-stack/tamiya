


---@class AssembleNode
AssembleNode = class("AssembleNode")

function AssembleNode:initialize(tab)

    self.CarID = tab[1]

    ---@type AssembleManager
    self.assembleMgr = tab[2]

    ---@type AssembleEquipmentData
    self.equipmentData = nil

    ---@type AssembleGrooveData
    self.grooveData = nil

    ---@type AssembleClientData
    self.clientData = nil

end


function AssembleNode:SetNode(equipment, groove, client)
    self.equipmentData = equipment
    self.grooveData = groove
    self.clientData = client
end


function AssembleNode:SetEquipmentData_IgnoreLimit(bagid) --不使用组装限制规则，配件安装无限制
    if bagid and bagid > 0 then
        self.equipmentData:SetEquipment(bagid)
    else
        self.equipmentData:ClearData()
    end

    --self:UpdateGrooveList(cfg, true)
end


function AssembleNode:SetGrooveData(enable)
    --self.grooveData:UpdatePartList(partId, isadd)

    self.grooveData:SetGrooveState(enable)

    --self.grooveData:SetPort()

    --self.grooveData:UpdateEquipment(isadd)
end


function AssembleNode:ClientSetFitterData()
    self.clientData:SetFitterData()
end
function AssembleNode:ClientClearOpenList()
    self.clientData:ClearOpenList()
end
function AssembleNode:ClientAddOpenPart(node)
    self.clientData:AddOpenPart(node)
end
function AssembleNode:CalibrateServerData_Enable()
    self.clientData:CalibrateServerData_Enable()
end




function AssembleNode:Clear()

end

function AssembleNode:GetCarIdx() return self.CarID end
function AssembleNode:GetGrooveEnable() return self.grooveData.Enable end
function AssembleNode:GetGrooveID() return self.grooveData.GrooveID end
--function AssembleNode:GetGroovePort() return self.grooveData.Port end
function AssembleNode:GetPartCfgID() return self.equipmentData.equipmentID end
function AssembleNode:GetBagId() return self.equipmentData.bagid end
function AssembleNode:GetPartCfg() return self.equipmentData.equipmentCfg end
--function AssembleNode:GetPartList() return self.grooveData.PartList end
function AssembleNode:GetPort() return self.equipmentData.equipmentCfg.PortData end

















-----@return parts_config_cell
--function AssembleNode:CheckPartid(partid)
--    --if self:GetGroovePort() == nil then
--    --    logError("---   error:组装节点未设置槽位信息，无法判断能否组装装备")
--    --    return
--    --end
--
--    if partid == nil then
--        logError("---   error:partid = nil")
--        return
--    end
--
--    if partid <= 0 then
--        if self:GetPartCfg() then
--            --self:UpdateGrooveList(self:GetPartCfg(), false)
--        end
--        self.equipmentData:ClearData()
--        return
--    end
--
--    ---@type parts_config_cell
--    local cfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partid)
--    if cfg == nil then
--        logError("---   error:组装节点设置装备信息，配件找不到配置表数据，partid = "..partid.."   carid = "..self.CarID)
--        return
--    end
--    return cfg
--end


--function AssembleNode:SetEquipmentData(partid)  --启用组装限制规则
--    --if partid == nil then logError("---   error:组装失败，partid = nil") return end
--    --local cfg = self:CheckPartid(partid)
--    --if cfg == nil then return end
--    --
--    --local result = AssembleHelper:Fitter_ComparePort(self:GetGroovePort(), cfg.NeedPort, cfg.type)
--    --if result == false then
--    --    logError("---   error:配件端口不适配，不可组装，partid = "..partid.."   carid = "..self.CarID.."   grooveid = "..self:GetGrooveID())
--    --    return
--    --end
--    --
--    --result = AssembleHelper:Fitter_CompareNeedGrooveID(cfg, self:GetGrooveID())
--    --if result == false then
--    --    logError("---   error:配件安装所需槽位匹配失败，partid = "..partid.."   carid = "..self.CarID.."   grooveid = "..self:GetGrooveID())
--    --    return
--    --end
--    --
--    --result = AssembleHelper:Fitter_CompareNeedPartID(cfg, self:GetPartList())
--    --if result == false then
--    --    logError("---   error:配件安装所需partid匹配失败，partid = "..partid.."   carid = "..self.CarID.."   grooveid = "..self:GetGrooveID())
--    --    return
--    --end
--    --
--    --self.equipmentData:SetEquipment(cfg.id)
--    --self:UpdateGrooveList(cfg, true)
--end

--function AssembleNode:SetEquipmentData_IgnoreLimit(partid) --不使用组装限制规则，配件安装无限制
--    local cfg = self:CheckPartid(partid)
--    if cfg == nil then return end
--
--    local result = AssembleHelper:Fitter_ComparePort(self:GetGroovePort(), cfg.NeedPort, cfg.type)
--    if result == false then logError("---   error:配件端口不适配，id = "..partid.." carid = "..self.CarID.." grooveid = "..self:GetGrooveID()) end
--
--    result = AssembleHelper:Fitter_CompareNeedGrooveID(cfg, self:GetGrooveID())
--    if result == false then logError("---   error:所需槽位匹配失败，id = "..partid.." carid = "..self.CarID.." grooveid = "..self:GetGrooveID()) end
--
--    result = AssembleHelper:Fitter_CompareNeedPartID(cfg, self:GetPartList())
--    if result == false then logError("---   error所需partid匹配失败，id = "..partid.." carid = "..self.CarID.." grooveid = "..self:GetGrooveID()) end
--
--    self.equipmentData:SetEquipment(cfg.id)
--    self:UpdateGrooveList(cfg, true)
--end

-----@param cfg parts_config_cell
--function AssembleNode:UpdateGrooveList(cfg, isadd)
--    --if cfg == nil then
--    --    logError("---   error: UpdateGrooveList()   cfg = nil")
--    --    return
--    --end
--
--    --local group = AssembleHelper:CfgCalculate_AnalyseProvidePos(cfg)
--    --for i = 1, #group do
--    --    local node = self.assembleMgr:GetNodeByGrooveID(group[i])
--    --    node:SetGrooveData(cfg.id, isadd)
--    --end
--end


-----@param port PartPort_Groove
--function AssembleNode:SetGrooveData(partId, isadd)
--
--    self.grooveData:UpdatePartList(partId, isadd)
--
--    self.grooveData:SetGrooveState()
--
--    self.grooveData:SetPort()
--
--    self.grooveData:UpdateEquipment(isadd)
--end