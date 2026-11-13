---@class Page_TrackSegmentShop
Page_TrackSegmentShop = class("Page_TrackSegmentShop")
local _SelectShowType=-1
local _CurShop=-1
function Page_TrackSegmentShop:initialize()

end

function Page_TrackSegmentShop:SetRoot(root)
   CommonHelper:HButtonSetCallback("ShopBackBtn",root,function(btnData)
       UINotify:Get():SendNotification(UINotifyEvent.CustomTrackShopBack)
   end)
    CommonHelper:HButtonSetCallback("ShoppingCarBtn",root,function(btnData)
        UIManager:Get():OpenPopup("ShoppingCarView",CanvasType.MainCanvas,"ShoppingCarView")
   end)
    self.Straightaway = CommonHelper:HButtonSetCallback("Toggle1", root, function(data)
        _SelectShowType = TrackSegmentType.Straightaway
        self:UpdateToggleGroup()
    end)
    self.Curve = CommonHelper:HButtonSetCallback("Toggle2", root, function(data)
        _SelectShowType = TrackSegmentType.Curve
        self:UpdateToggleGroup()
    end)
    self.Special = CommonHelper:HButtonSetCallback("Toggle3", root, function(data)
        _SelectShowType = TrackSegmentType.Special
        self:UpdateToggleGroup()
    end)
    self.ChangeTrack = CommonHelper:HButtonSetCallback("Toggle4", root, function(data)
        _SelectShowType = TrackSegmentType.ChangeTrack
        self:UpdateToggleGroup()
    end)
    self.ScrollView=UIUtil.GetTypeChildWightByParent("ScrollHorizontalOneRow",root,typeof(MoreRowScrollView))
    self.diamonds=UIUtil.GetChildInputPath("coin",root)
    self.coin=UIUtil.GetChildInputPath("diamonds",root)
end

function Page_TrackSegmentShop:SetData(type)
    _SelectShowType = TrackSegmentType.Straightaway
    self:UpdateToggleGroup()
    self:SetPlayerMoney()
end
function Page_TrackSegmentShop:SetPlayerMoney()
    CommonHelper:GetComponentSetImage("priceIcon",self.coin,CommonHelper:GetCurrencyTypeImage(CurrencyType.Gold),UIModuleID.CustomTrackEditor)
    CommonHelper:SetText("###num",self.coin,PlayerDataManager:Get():GetCurrency(CurrencyType.Gold))
    CommonHelper:GetComponentSetImage("priceIcon",self.diamonds,CommonHelper:GetCurrencyTypeImage(CurrencyType.Diamond),UIModuleID.CustomTrackEditor)
    CommonHelper:SetText("###num",self.diamonds,PlayerDataManager:Get():GetCurrency(CurrencyType.Diamond))
end
function Page_TrackSegmentShop:UpdateToggleGroup()
    CommonHelper:SetToggleState(self.Straightaway, _SelectShowType == TrackSegmentType.Straightaway)
    CommonHelper:SetToggleState(self.Curve, _SelectShowType == TrackSegmentType.Curve)
    CommonHelper:SetToggleState(self.Special, _SelectShowType == TrackSegmentType.Special)
    CommonHelper:SetToggleState(self.ChangeTrack, _SelectShowType == TrackSegmentType.ChangeTrack)
    self:SetScrollView()
end

function Page_TrackSegmentShop:SetScrollView()
    local data = {}
    SegmentDataManager:Get():SetShowDataByType(_SelectShowType)
    ---@type ShopData
    _CurShop=ShopDataManager:Get():GetCurShop()
    local shopList=_CurShop.goodExs2

    for h, d in pairs(shopList) do
        for k, v in pairs(SegmentDataManager:Get().curShowList) do
            if d.id==v.cfgId then
                table.insert(data,d)
            end
        end
    end
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #data, 4, function(dataIndex, itemObj, scroll)
        local temp=data[dataIndex+1]
        CommonHelper:HButtonSetCallback("BtnItem", itemObj, function(btnData)
            CommonHelper:MoreRowView_SelectItem(self.ScrollView,btnData.intData,function(scroll,item,index)
                     local temp=data[index+1]
                    CommonHelper:HButtonSetCallback("addCarBtn",item,function(addBtnData)
                    end,index)
                    CommonHelper:HButtonSetCallback("buyBtn",item,function(buyBtnData)
                      UIManager:OpenPopup("TrackSegmentGoodInfoView",CanvasType.FrontCanvas,"TrackSegmentGoodInfoView")
                      UINotify:Get():SendNotification(UINotifyEvent.TrackSegmentSetGoodsInfoView,temp)
                    end,index)
                self:SetItem(item,data[index+1])
            end)
            CommonHelper:MoreRowView_ShowClickItem(self.ScrollView,btnData.intData)
        end,dataIndex)

        if temp then
            self:SetItem(itemObj, temp)
        end
    end)
end

---@param data GoodsData
function Page_TrackSegmentShop:SetItem(itemObj, data)
    local param = Param_TrackSegmentGroup()
    param.moduleId = UIModuleID.CustomTrackEditor
    param.trackSegmentId = data.id
    param.showcount = false
    param.showname = false
    param.isdirection = false
    CommonHelper:SetTrackSegmentGroup(itemObj, param)
    CommonHelper:GetComponentSetImage("priceIcon",itemObj,CommonHelper:GetCurrencyTypeImage(data.moneyType),UIModuleID.CustomTrackEditor)
    CommonHelper:SetText("###price",itemObj,data.moneyNum)
end