---@class AdShopManager
AdShopManager = class("AdShopManager")
function AdShopManager:initialize()
    ---@type ShopData
    self.CurShopData =nil
end

---@param msg SC_ShopInfo
function AdShopManager:SetShopData(msg)
    self.CurShopData=ShopData()
    self.CurShopData:SetData(msg)
end