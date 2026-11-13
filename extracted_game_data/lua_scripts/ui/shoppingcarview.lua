---@type ShopData
local CurShop=nil
---@class ShoppingCarView : ViewBase
ShoppingCarView = class("ShoppingCarView", ViewBase)
function ShoppingCarView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ShoppingCarViewAction")
end

function ShoppingCarView:Awake()

    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (data)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnSelectAll",self.gameObject,function (data)

    end)
    CommonHelper:HButtonSetCallback("BtnBuy",self.gameObject,function (data)

    end)
    CommonHelper:HButtonSetCallback("BtnDelete",self.gameObject,function (data)

    end)
   self.MoreRowScrollView_V=self:GetChildWight("MoreRowScrollView_V",typeof(MoreRowScrollView))
end
function ShoppingCarView:OnOpen()
      self:SetData()
end
local _CurSelect=nil
function ShoppingCarView:SetData()

    ---@type table<number,ShoppingCarGoodsData>
   local data= ShoppingCarDataManager:Get():GetLocalGoods()
    _CurSelect={}
    if data then
        for i = 0, #data-1 do
            _CurSelect[i]=false
        end
        CommonHelper:InitMoreRowScrollView(self.MoreRowScrollView_V,#data,5,function(index,item,scroll)
            local team=data[index+1].GoodsData
            local param = Param_ShopGoodsGroup()
            param.goodType=team.goodsType
            param.articleId = team.id
            param.grid=team.grid
            param.moduleId = UIModuleID.Shop
            param.count = team.goodsNum
            param.price = team.moneyNum
            param.currencytype = team.moneyType
            param.num=team.count
            param.disCount=team.discount
            param.maxNum=team.maxNum
            param.flag = team.flag
            CommonHelper:SetShopGoodsGroup(item, param)
            local  TogSelect=CommonHelper:HButtonSetCallback("TogSelect",item,function(btnData)
                _CurSelect[btnData.intData]=not _CurSelect[btnData.intData]
                CommonHelper:MoreRowView_RefreshCurList(self.MoreRowScrollView_V,false)
            end,index)
            CommonHelper:SetToggleState(TogSelect,_CurSelect[index])
        end)
    end
end


function ShoppingCarView:OnClose()

end
