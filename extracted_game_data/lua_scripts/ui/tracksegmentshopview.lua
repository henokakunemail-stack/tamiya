---@class TrackSegmentShopView : ViewBase
TrackSegmentShopView = class("TrackSegmentShopView", ViewBase)
local _Top=nil
local _Center=nil
local _Bottom=nil
local _SelectTog=-1
---@type ShopData
local _CurShop=nil
function TrackSegmentShopView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "TrackSegmentShopViewAction")
end

function TrackSegmentShopView:Awake()
   CommonHelper:HButtonSetCallback("BgBth",self.gameObject,function (data)
        UIManager:Get():HidePersistentView("TrackSegmentShopView")
    end)
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (data)
        UIManager:Get():HidePersistentView("TrackSegmentShopView")
    end)
    self.diamond = self:GetChild("diamond")
    self.TogView=self:GetChildWight("MoreRowScrollView_H",typeof(MoreRowScrollView))
    self.Content=self:GetChildWight("MoreRowScrollView_V(Clone)",typeof(MoreRowScrollView))
    CommonHelper:HButtonSetCallback("BtnAllBuy",self.gameObject,function (data)
        UIManager:Get():OpenPopup("TrackSegmentShopNeedBuyView",CanvasType.MainCanvas,"TrackSegmentNeedView")
    end)
end
function TrackSegmentShopView:SetData()

    ---@type ShopData
    _CurShop=ShopDataManager:Get():GetCurShop()
    CommonHelper:SetText("LabDiamond", self.diamond, PlayerDataManager:Get():GetCurrency(CurrencyType.Diamond))
    CommonHelper:InitMoreRowScrollView(self.TogView, 4,1 ,function (dataIndex, itemObj, scroll)
        local name=CommonHelper:GetTypeName( SegmentDataManager:Get().TrackNumbers,dataIndex+1)
        local icon=CommonHelper:GetTypeIcon(SegmentDataManager:Get().TrackNumbers,dataIndex+1)
        CommonHelper:SetText("typename",itemObj,name)
        local image= CommonHelper:GetComponentSetImage("icon1",itemObj,icon)
        CommonHelper:ImageSetNativeSize(image)
        local tog = CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function (hbtn)
            self:OnClickTog_Type(hbtn.intData)
        end, dataIndex)
        CommonHelper:SetToggleState(tog,dataIndex == _SelectTog)
    end, nil ,true)
    _SelectTog=0
    self:OnClickTog_Type(_SelectTog)
end

function TrackSegmentShopView:SetShowList(type)
   local allGoods= _CurShop.goods
   self.showList= {}
    for i = 1, #allGoods do
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.tracksegement_config,allGoods[i].id)
        if cfg ==nil then return end
        if cfg.type==type+1 then
            table.insert(self.showList,allGoods[i])
        end
    end
end
function TrackSegmentShopView:OnClickTog_Type(idx)

    _SelectTog = idx

    CommonHelper:MoreRowView_RefreshCurList(self.TogView,false)

    self:SetShowList(_SelectTog)
    self:SetScrollView()
end
function TrackSegmentShopView:SetScrollView()
    CommonHelper:InitMoreRowScrollView(self.Content,#self.showList,4,function (index, itemObj,scroll)
        local data = self.showList[index + 1]
        if data == nil then return end
        local param=Param_TrackSegmentGroup()
        param.moduleId=UIModuleID.CustomTrackEditor
        param.trackSegmentId=data.id
        param.count=0
        param.showcount=false
        param.showname=false
        param.isdirection=false
        CommonHelper:SetTrackSegmentGroup(itemObj,param)
        CommonHelper:SetText("LabPrice",itemObj,tostring(data.moneyNum))
        CommonHelper:GetComponentSetImage("SpcSprite",itemObj, CommonHelper:GetCurrencyTypeImage(data.moneyType) ,UIModuleID.CustomTrackEditor)
        CommonHelper:HButtonSetCallback("HButton",itemObj,function (data)
            self:ClickItem(data.intData)
        end,index)
    end)
end
function TrackSegmentShopView:ClickItem(index)
    -- 弹出商品详情面板
    UIManager:Get():OpenPopup("TrackSegmentGoodInfoView",CanvasType.MainCanvas,"TrackSegmentGoodInfoView")
    UINotify:Get():SendNotification(UINotifyEvent.TrackSegmentSetGoodsInfoView, self.showList[index+1])
end
function TrackSegmentShopView:SetPlayerMoney()
    CommonHelper:SetText("LabDiamond", self.diamond, PlayerDataManager:Get():GetCurrency(CurrencyType.Diamond))
end





function TrackSegmentShopView:OnOpen()

end
function TrackSegmentShopView:OnClose()
    CommonHelper:InitMoreRowScrollView(self.TogView, 0,1)
    CommonHelper:InitMoreRowScrollView(self.Content, 0,4)
end





