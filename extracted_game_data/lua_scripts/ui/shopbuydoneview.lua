---@class ShopBuyDoneView : ViewBase
ShopBuyDoneView = class("ShopBuyDoneView", ViewBase)

function ShopBuyDoneView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ShopBuyDoneViewAction")
end

function ShopBuyDoneView:Awake()
    self.PropCompoent=UIUtil.GetChild("PropCompoent",self.gameObject)

    self.BtnBack= CommonHelper:HButtonSetCallback("BtnCloseWhite",self.gameObject,function (data)
        UIManager:Get():HidePersistentView("BuyDoneView")
        self:CheckNewBieGuide("ShopView")
    end)

end
local Color=-1
---@param data SC_buyShop
function ShopBuyDoneView:SetData(data)
    local param = Param_ItemArticleParam()
    param.count=ShopDataManager:Get():GetBuyGoods().buyGoodCount
    CommonHelper:SetItemComGroup(self.gameObject,UIModuleID.Shop,ShopDataManager:Get():GetBuyGoods().buyGoodId,param,function()
        CommonHelper:ShowPartInfoByCfgId(ShopDataManager:Get():GetBuyGoods().buyGoodId, UIModuleID.Shop)
    end)
    local propType,cfg=CommonHelper:GetPropTypeById(ShopDataManager:Get():GetBuyGoods().buyGoodId)
    if propType==PropType.Article then
        CommonHelper:SetText("###goodname",self.gameObject,CommonHelper:GetTempStr_Default(cfg.name))
    elseif propType==PropType.Part then
        CommonHelper:SetText("###goodname",self.gameObject,CommonHelper:GetTempStr_Default(cfg.partname))
    elseif propType==PropType.TracKSegment then
        CommonHelper:SetText("###goodname",self.gameObject,CommonHelper:GetTempStr_Default(cfg.name))
    end
    if ShopDataManager:Get():GetBuyGoods().buyGoodCount~=0 then
        CommonHelper:SetText("###Count",self.gameObject,string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrNum),"x",ShopDataManager:Get():GetBuyGoods().buyGoodCount))
    else
        CommonHelper:SetText("###Count",self.gameObject,string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrNum),"x",ShopDataManager:Get():GetBuyGoods().buyGoodCount))
    end

    self:CheckNewBieGuide()
   -- 设置积分
   --CommonHelper:SetText("IntegralNum",self.Center,PlayerDataManager:Get():GetCurrency(ShopDataManager:Get().ShopType[ShopDataManager:Get().CurShopId].currencyType))
end

