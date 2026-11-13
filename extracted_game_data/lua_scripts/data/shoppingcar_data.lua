---@class ShoppingCarData
---@field goods
---@field ShopId
ShoppingCarData = class("ShoppingCarData")
function ShoppingCarData:initialize()
    self.ShopId=-1;
    self.goods={}
end

---@class ShoppingCarGoodsData
---@field GoodsData GoodsData
---@field count
ShoppingCarGoodsData=class("ShoppingCarGoodsData")
function  ShoppingCarGoodsData:initialize()

end
function ShoppingCarGoodsData:SetData(goodsData,count)
    self.GoodsData=goodsData
    self.count=count
end