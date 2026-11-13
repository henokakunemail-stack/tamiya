
---@class ShopDataManager
ShopDataManager = class("ShopDataManager")
function ShopDataManager:initialize()
    self.IsAllBuy=0
    self.ShopDataDic={}
    ---@type table<number,shop_config_cell>
    local cfg=ClientDataManager:Get():GetDataTable(ConfigNames.shop_config).GetConfigData()
    self.ShopType={}
    for i, v in pairs(cfg) do
        self.ShopType[v.C_ID]=v
    end
    ---@type table<number, GoodsData>
    self.CurShopGoodList=nil
    CrossDayTrigger:Get():RegisterEvent(self,self.CrossDay)
end
function ShopDataManager:Get()
    if self._instance == nil then
        self._instance = ShopDataManager()
    end
    return self._instance
end
---@param msg SC_ShopInfo
function ShopDataManager:SetData(msg)
    self.CurShop=ShopData()
    self.CurShop:SetData(msg)
    self.ShopDataDic[self.CurShop.ShopId]=self.CurShop

end

---@param msg SC_buyShop
function ShopDataManager:UpdateShopGood(msg)
    if  self.CurShop==nil or self.CurShop.goods == nil or msg.shopid~=self.CurShop.ShopId then
        print("---   error:数据异常，没有商店数据，id = ", msg.shopId)
        return
    end

    if msg.curItem==nil then return end

    for i = 1, #self.CurShop.goods do
        if self.CurShop.goods[i].grid == msg.curItem.grid then
            self.CurShop.goods[i]:Update(msg.curItem.limitnum-msg.curItem.curnum)
            break
        end
    end
end
function ShopDataManager:GetShopGood(grid)
    local goods=nil
    if #self.CurShop.goodExs2>0 then
        goods = self.CurShop.goodExs2
    end
    if #self.CurShop.goodExs>0 then
        goods =self.CurShop.goodExs
    end
    if #self.CurShop.goods>0 then
        goods =self.CurShop.goods
    end

    if goods == nil then
        print("---   error:数据异常，没有商店数据，id = ", msg.shopId)
        return
    end


    for i = 1, #goods do
        if goods[i].grid == grid then
            return goods[i]
        end
    end
    return nil
end
---@return  ShopData
function ShopDataManager:GetCurShop()
    return self.CurShop
end
---@param goods BuyGoodData
function ShopDataManager:SetBuyGoods(goods)
    self.BuyGoods=goods
end
function ShopDataManager:GetBuyGoods()
    return self.BuyGoods
end

function ShopDataManager:CrossDay()
    if UIManager:Get():IsViewShow("ShopView") then
        ShopSubsystem:Get():SendMsg_ShopInfo(self.CurShop.ShopId)
    end
end


