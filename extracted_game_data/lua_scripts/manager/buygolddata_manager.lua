---@class BuyGoldDataManager
BuyGoldDataManager = class("BuyGoldDataManager")

function BuyGoldDataManager:Get()
    if self._instance == nil then
        self._instance = BuyGoldDataManager()
    end
    return self._instance
end

function BuyGoldDataManager:initialize()
    self.BuyGoldData = {}
end

function BuyGoldDataManager:UpdateBuyGoldData(_data)
    for i, v in pairs(_data) do
        table.insert(self.BuyGoldData, v)
    end
end

function BuyGoldDataManager:GetBuyGoldData()
    return self.BuyGoldData
end

function BuyGoldDataManager:Clear()
    self.BuyGoldData = {}
end

function BuyGoldDataManager:SetBuyGoldTipsData()
    self.BuyGoldTipsData = {}

    ---@type dictexchgold_config
    local cfg = ClientDataManager:Get():GetDataTable(ConfigNames.dictexchgold_config)
    local cfgData = cfg.GetConfigData()
    for i, v in pairs(cfgData) do
        if self.BuyGoldTipsData[v.dianum] == nil then
            self.BuyGoldTipsData[v.dianum] = {}
            local batrands = {}
            local _data = stringSplitToNumber(v.batrands, ':')
            table.insert(batrands, v.dianum)
             for j, k in pairs(_data) do
                table.insert(batrands, k)
            end
            self.BuyGoldTipsData[v.dianum] = batrands
        end
    end

    self.keys = {}
    for key in pairs(self.BuyGoldTipsData) do
        table.insert(self.keys, key)
    end
    table.sort(self.keys)


end

function BuyGoldDataManager:GetBuyGoldTipsData()
    return self.BuyGoldTipsData, self.keys
end
