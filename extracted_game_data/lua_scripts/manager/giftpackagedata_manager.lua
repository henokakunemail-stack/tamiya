---@class GiftPackageDataManager
GiftPackageDataManager = class("GiftPackageDataManager")

---@class ActGiftBuyData---------------------------------------
ActGiftBuyData = class("ActGiftBuyData")
function ActGiftBuyData:initialize()
    self.ItemID = -1
    self.BuyMax = -1
    self.BuySum = -1

end

function ActGiftBuyData:InitBaseData(data, data2, data3)
    self.ItemID = data.itemid
    self.BuyMax = data.buymax
    self.BuySum = data.buysum
    self.AwardIDS = stringSplitToNumber(data2.awardids, ':')
    self.AwardNum = stringSplitToNumber(data2.awardnums, ':')
    self.PriceName = data3.pricename
    self.ChargeID = data3.itemid
end

function GiftPackageDataManager:Get()
    if self._instance == nil then
        self._instance = GiftPackageDataManager()
    end
    return self._instance
end

function GiftPackageDataManager:initialize()

end

function GiftPackageDataManager:SetGiftPackageMsgData(msg)
    self.GiftPackageMsg = {}

    for i, v in pairs(msg.giftPackages) do
        local itemData = ActGiftBuyData()
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.act_gift_config, v.itemid)
        local chargeCfg = CommonHelper:GetChargeCfgByAreaAndItemId(v.itemid)

        itemData:InitBaseData(v, cfg, chargeCfg)
        table.insert(self.GiftPackageMsg, itemData)
    end

end

function GiftPackageDataManager:GetGiftPackageMsgData()
    return self.GiftPackageMsg
end

function GiftPackageDataManager:RefreshGiftPackageMsgData(msg)
    GiftPackageDataManager:Get():SetGiftPackageIsResetFlag(false)
    for i, v in pairs(self.GiftPackageMsg) do
        if v.ItemID == msg.curActGift.itemid then
            self.GiftPackageMsg[i].BuySum = msg.curActGift.buysum
        end
    end
end
function GiftPackageDataManager:SetGiftPackageIsResetFlag(value)
    self.IsRefresh=value
end
function GiftPackageDataManager:GetGiftPackageIsResetFlag()
    return self.IsRefresh
end