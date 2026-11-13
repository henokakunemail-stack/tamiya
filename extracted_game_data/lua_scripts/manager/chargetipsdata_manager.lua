---@class ChargeTipData
ChargeTipData = class("ChargeTipData")
function ChargeTipData:initialize()
    self.itemID = -1
    self.firstFlag = -1
    self.diamond = -1
    self.addMoney = -1
    self.maxDiamond = -1
end

---@param msg SC_DirectChargeItem
function ChargeTipData:InitBaseData(msg)
    self.itemID = msg.itemid
    self.firstFlag = msg.firstflag
    self.diamond = msg.diamond
    self.addMoney = msg.addmoney

    if self.firstFlag == 1 then
        self.maxDiamond = self.diamond + self.addMoney
    else
        self.maxDiamond = self.diamond
    end

end

---@class ChargeTipsDataManager
ChargeTipsDataManager = class("ChargeTipsDataManager")

function ChargeTipsDataManager:Get()
    if self._instance == nil then
        self._instance = ChargeTipsDataManager()
    end
    return self._instance
end

function ChargeTipsDataManager:initialize()

end

function ChargeTipsDataManager:SetChargeStateData(msg)
    ---@type SC_DirectCharge
    self.chargeData = {}

    for i, v in pairs(msg) do

        local _Data = ChargeTipData()
        _Data:InitBaseData(msg[i])
        table.insert(self.chargeData, _Data)
    end

end

function ChargeTipsDataManager:GetChargeStateData()
    return self.chargeData
end

function ChargeTipsDataManager:GetChargeStateDataByCostNum()
    ---@type SC_DirectChargeItem
    for i, v in pairs(self.chargeData) do
        if v.maxDiamond > self.NeedNum then
            return v
        end
    end

end

function ChargeTipsDataManager:SetChargeStateNeedNum(_needNum)
    self.NeedNum = _needNum
end

function ChargeTipsDataManager:GetChargeStateNeedNum()
    return self.NeedNum
end

function ChargeTipsDataManager:GetMoneyIfEnough(_propid, _coinid,count)
    local haveNum = KnapsackDataManager:Get():GetArticleCountByCfgid(_propid)
    local haveCoinNum = KnapsackDataManager:Get():GetArticleCountByCfgid(_coinid)
    local priceNum = UserDirectManager:Get():GetDataByID(_propid, _coinid)
    if priceNum then
        local propNum = count - haveNum
        local needNum = priceNum.pay[1] * propNum

        return needNum - haveCoinNum
    else
        PlayerDataManager:Get():CheckCurrencyEnough(_propid,count)
    end

end