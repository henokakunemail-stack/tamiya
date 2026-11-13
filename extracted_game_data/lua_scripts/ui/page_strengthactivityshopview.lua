---@class Page_StrengthActivityShopView:Page_StrengthActivityBaseView
Page_StrengthActivityShopView = class("Page_StrengthActivityShopView",Page_StrengthActivityBaseView)

function Page_StrengthActivityShopView:OnOpen()
    self.StrengthScroll = UIUtil.GetTypeChildWightByParent("StrengthScroll", self.gameObject, typeof(MoreRowScrollView))
    ---@type ShopData
    self.ShopData= StrengthActivityManager:Get().CurShopData
    self:SetActivityTime()
    self:SetCost()
    local UpdateFunc = function(dataIndex, itemObj,view)
        ---@type GoodsData
        local data = self.ShopData.goods[dataIndex + 1]
        ---@type dictarticle_config_cell
        local dictarticle_cell =CommonHelper:GetTableDataByID(ConfigNames.article_config, data.id)
        CommonHelper:SetText("###residueText", itemObj, CommonHelper:GetTempStr_Default(dictarticle_cell.name))
        local limitText = CommonHelper:GetTempStr_Default(TemplateStringID.StrengthActivityLimitDesc,data.buyNum,data.maxNum)
        local canBuy = true
        if data.maxNum == 0 then
            CommonHelper:SetText("LimitCount", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.StrengthActivityNotLimitDesc))
            canBuy = true
        else
            CommonHelper:SetText("LimitCount", itemObj, limitText)
            canBuy = data.buyNum<data.maxNum
        end
        CommonHelper:SetGameObjectActive("BtnStrengthExchange",itemObj,canBuy)
        CommonHelper:SetGameObjectActive("sellOut",itemObj,not canBuy)


        local currency =CommonHelper:GetTableDataByID(ConfigNames.currency_config, data.moneyType)
        CommonHelper:GetComponentSetImage("exchangeIcon",itemObj,currency.icon2,UIModuleID.StrengthActivity)
        CommonHelper:SetText("###price", itemObj, "X".. data.price)
        local obj = UIUtil.GetChild("ItemCom_118", itemObj)
        local param = Param_ItemArticleParam()
        param.count=1
        CommonHelper:SetItemComGroup(obj, UIModuleID.StrengthActivity, data.id, param, function(btnData)
            CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.StrengthActivity, false)
        end, data.id)

        CommonHelper:HButtonSetCallback("BtnStrengthExchange", itemObj, function(btn)
            UIManager:Get():ShowPersistentView("GoodsInfoView",CanvasType.MainCanvas,"GoodsInfoView")
            UINotify:Get():SendNotification(UINotifyEvent.SetGoodsInfoView, btn.intData)
        end,dataIndex)
    end
    CommonHelper:InitMoreRowScrollView(self.StrengthScroll, #self.ShopData.goods, 3, UpdateFunc, true, nil, false)
end

function Page_StrengthActivityShopView:OnClose()

end

function Page_StrengthActivityShopView:Refresh()
    self:SetCost()
    self:SetActivityTime()
    CommonHelper:MoreRowView_RefreshCurList(self.StrengthScroll,false)
end
function Page_StrengthActivityShopView:SetCost()
    local CoinId= self.ShopData.goods[1].moneyType
    CommonHelper:SetText("###exchangeNum",self.gameObject,KnapsackDataManager:Get():GetArticleCountByCfgid(CoinId))
    ---@type dictcurrency_config_cell
    local currency =CommonHelper:GetTableDataByID(ConfigNames.currency_config, CoinId)
    CommonHelper:GetComponentSetImage("haveExchangeIcon",self.gameObject,currency.icon2,UIModuleID.StrengthActivity)
end
