



---@class AssembleEquipmentData
AssembleEquipmentData = class("AssembleEquipmentData")

---@param node AssembleNode
function AssembleEquipmentData:initialize(node)
    self.equipmentID = -1
    ---@type parts_config_cell
    self.equipmentCfg = nil
    ---@type AssembleNode
    self.Node = node

    self.bagid = -1

end
function AssembleEquipmentData:SetEquipment(bagid)
    self.bagid = bagid
    local data = KnapsackDataManager:Get():GetArticleByID(bagid)
    if data == nil then
        print("---   error:组装配件数据异常，背包中没有数据，bagid = ", bagid)
        self:ClearData()
    else
        self.equipmentCfg = data:GetPartConfig()
        self.equipmentID = data:GetArticleID()
    end

end
function AssembleEquipmentData:ClearData()
    self.bagid = -1
    self.equipmentCfg = nil
    self.equipmentID = -1
end
