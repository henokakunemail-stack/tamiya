---@class ShopData
---@field goodExs
---@field goodExs2
---@field goods
---@field LastCoin
---@field LastRNum
---@field RefreshMoneyNum
---@field MoneyType
---@field RefreshTime
---@field ShopId
ShopData = class("ShopData")
function ShopData:initialize()
    ---@type table<number, GoodsData>
    self.goodExs={}
    ---@type table<number, GoodsData>
    self.goodExs2={}
    ---@type table<number, GoodsData>
    self.goods={}
    self.LastCoin=0
    self.LastRNum=0
    self.RefreshMoneyNum=0
    self.MoneyType=0
    self.RefreshTime=0
    self.ShopId=0
    self.GuideLevel=0
end
---@param msg SC_ShopInfo
function ShopData:SetData(msg)
    self.ShopId=msg.shopid
    self.goods={}
    for i = 1, #msg.shoplist do
        local temp=GoodsData()
        temp:SetData(msg.shoplist[i])
        table.insert(self.goods,temp)
    end
    table.sort(self.goods,function(a, b)
       return a.grid<b.grid
    end)
    ---@type dictshop_config_cell
    local shopCfg= CommonHelper:GetTableDataByID(ConfigNames.shop_config,self.ShopId)
    local count=#stringSplitToNumber(shopCfg.costs,':')
    self.PropId=shopCfg.propid
    self.LastRNum=count-msg.freshnum
    self.MoneyType=msg.freshcoin
    self.RefreshMoneyNum=msg.freshpay
    self.GuideLevel=msg.curGuildLev
    print("当前时间",CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()),"刷新时间",msg.freshtime)
    self.RefreshTime=msg.freshtime
end
function ShopData:GetGoodsDataById(id)
    local result=nil
    if #self.goods>0 then
        for i = 1, #self.goods do
            if id==self.goods[i].id then
                result=self.goods[i]
            end
        end
    end
    return result
end
---@class GoodsData
GoodsData=class("GoodsData")
function GoodsData:initialize()
    self.id = 0
    self.moneyType = 0
    self.price = 0
    self.count = 0
    self.discount = 0
    self.goodsType=0
    self.maxNum=0
    self.num=0
    self.cfg=nil
    self.Condition=0
    self.ConditionValue=0
end
---@param msg SC_ShopItem
function GoodsData:SetData(msg)
    self.grid=msg.grid
    self.id=msg.propsid
    self.goodsType=msg.propsytpe
    self.moneyType=msg.coinid
    self.price=msg.price
    self.discount=msg.discount/100
    self.num=msg.limitnum-msg.curnum
    self.buyNum=msg.curnum
    self.maxNum=msg.limitnum
    self.Condition=msg.cond
    self.ConditionValue=msg.condval
    self.flag=msg.tag or 0
    self.cfg=CommonHelper:GetTableDataByID(ConfigNames.article_config,self.goodsType)
    if self.cfg==nil then
        self.cfg=CommonHelper:GetTableDataByID(ConfigNames.parts_config,self.goodsType)
    end
   if self.cfg==nil then
        self.cfg=CommonHelper:GetTableDataByID(ConfigNames.parts_config,self.goodsType)
    end
end


---@param msg SC_ShopInfo
function GoodsData:Update(num)
    self.num =num
end
---@param msg SC_ShopInfo
function GoodsData:UpdateBuyNum(num)
    self.buyNum =num
end

---@class BuyGoodData
BuyGoodData=class("BuyGoodData")
function BuyGoodData:initialize()
    self.buyGoodGridId=0
    self.buyGoodId=0
    self.buyGoodCount=0
    self.buyGoodMaxNum=0
end
function BuyGoodData:SetData(grid,id,buyCount,buyMaxNum)
    self.buyGoodGridId=grid
    self.buyGoodId=id
    self.buyGoodCount=buyCount
    self.buyGoodMaxNum=buyMaxNum
end