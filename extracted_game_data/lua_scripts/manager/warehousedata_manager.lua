---@class WarehouseDataManager
WarehouseDataManager = class("WarehouseDataManager")

function WarehouseDataManager:initialize()
    self.wareHouseData = {}
    CacheClearTrigger:Get():RegisterEvent(self, self.ClearData)
end

---@return WarehouseDataManager
function WarehouseDataManager:Get()
    if self._instance == nil then
        self._instance = WarehouseDataManager()
    end
    return self._instance
end

function WarehouseDataManager:InitData(msg)
    for i, v in pairs(msg) do
        local warehouseCell = WarehouseCell()
        warehouseCell:InitData(v)
        self.wareHouseData[warehouseCell:GetID()] = warehouseCell
    end

end

function WarehouseDataManager:InitDataByID(msg)
    for i, v in pairs(self.wareHouseData) do
        for j, k in pairs(msg) do
            if v:GetID() == k.propid then
                if k.propnum == 0 then
                    self.wareHouseData[i] = nil
                else
                    local warehouseCell = WarehouseCell()
                    warehouseCell:InitData(k)
                    self.wareHouseData[i] = warehouseCell
                end
            end
        end
    end
end

function WarehouseDataManager:GetAllData()
    local allData = {}
    for i, v in pairs(self.wareHouseData) do
        table.insert(allData, v)
    end
    return allData
end

function WarehouseDataManager:GetAllDataLength()
    local len = 0
    for _, v in pairs(self.wareHouseData) do
        if v ~= nil then
            len = len + 1
        end
    end
    return len
end

function WarehouseDataManager:GetDataByID(id)
    for i, v in pairs(self.wareHouseData) do
        if v.cellId == id then
            return v
        end
    end
end

function WarehouseDataManager:GetDataByType(type)
    local data = {}
    for i, v in pairs(self.wareHouseData) do
        if v:GetPartBaseConfig().parttype == type then
            table.insert(data, v)
        end
    end
    return data
end

---@class WarehouseCell
WarehouseCell = class("WarehouseCell")

function WarehouseCell:initialize()
    self.cellId = -1
    self.cellNum = 0
    self.partConfig = { }
    self.partBaseConfig = { }
end

---@param data SC_UserProp
function WarehouseCell:InitData(data)
    self.cellId = data.propid
    self.cellNum = data.propnum

    self.partConfig = CommonHelper:GetTableDataByID(ConfigNames.parts_config, self.cellId)
    ---@type dictpartbase_config_cell
    self.partBaseConfig = CommonHelper:GetPartBaseCfg(self.cellId)
    ---@type dictpartage_config_cell
    self.partAgeConfig = CommonHelper:GetPartAgeCfg(self.cellId, 1)
end

function WarehouseCell:GetID()
    return self.cellId
end

function WarehouseCell:GetCount()
    return self.cellNum
end

function WarehouseCell:GetPartConfig()
    return self.partConfig
end

function WarehouseCell:GetPartBaseConfig()
    return self.partBaseConfig
end

function WarehouseCell:GetPartAgeConfig()
    return self.partAgeConfig
end

function WarehouseDataManager:ClearData()
    self.wareHouseData = {}
end

return WarehouseDataManager()