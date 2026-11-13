---@class TrackSegmentGoodInfoView : ViewBase
TrackSegmentGoodInfoView = class("TrackSegmentGoodInfoView", ViewBase)
---@type ShopData
local _CurShop=nil
---@type BuyGoodData
local _BuyGoodInfo=nil
---@type GoodsData
local GoodsData=nil

function TrackSegmentGoodInfoView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "TrackSegmentGoodInfoViewAction")
end
function TrackSegmentGoodInfoView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (data)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnAdd1",self.gameObject,function (data)
        _BuyGoodInfo.buyGoodCount=  _BuyGoodInfo.buyGoodCount+1
        if _BuyGoodInfo.buyGoodCount>10 then
            _BuyGoodInfo.buyGoodCount=10
        end
        self:SetBuyNum()
    end)
    CommonHelper:HButtonSetCallback("BtnMax1",self.gameObject,function (data)
        _BuyGoodInfo.buyGoodCount=10
        self:SetBuyNum()
    end)
    CommonHelper:HButtonSetCallback("BtnJian1",self.gameObject,function (data)
        _BuyGoodInfo.buyGoodCount=  _BuyGoodInfo.buyGoodCount-1
        if _BuyGoodInfo.buyGoodCount<1 then
            _BuyGoodInfo.buyGoodCount=1
        end
        self:SetBuyNum()
    end)
    CommonHelper:HButtonSetCallback("BtnOK",self.gameObject,function (data)
        ShopDataManager:SetBuyGoods(_BuyGoodInfo)
        ShopSubsystem:Get():SendMsg_Buy(ShopDataManager:Get():GetCurShop().ShopId,GoodsData.grid,_BuyGoodInfo.buyGoodCount)
    end)
    self.trackSegGroup=self:GetChild("ItemTrackSegment_Shop")
end

---@param data GoodsData
function TrackSegmentGoodInfoView:SetData(gooddata)
    GoodsData=gooddata
    _BuyGoodInfo=BuyGoodData()
    _BuyGoodInfo.buyGoodId=gooddata.id
    _BuyGoodInfo.buyGoodCount=1
     local data=SegmentDataManager:Get():GetTrackSegmentDataById(gooddata.id)
    local param = Param_TrackSegmentGroup()
    param.moduleId = UIModuleID.CustomTrackEditor
    param.trackSegmentId = data.cfgId
    param.showcount = false
    param.showname = false
    param.isdirection = false
    CommonHelper:SetTrackSegmentGroup(self.trackSegGroup, param)

    CommonHelper:GetComponentSetImage("priceIcon",self.gameObject,CommonHelper:GetCurrencyTypeImage(gooddata.moneyType),UIModuleID.CustomTrackEditor)
    ---@type tracksegement_config_cell
    local trackCfg= CommonHelper:GetTableDataByID(ConfigNames.tracksegement_config,data.cfgId)
    CommonHelper:SetText("###moneynum",self.gameObject,gooddata.moneyNum)
    CommonHelper:SetText("###name",self.gameObject,CommonHelper:GetTempStr_Default(trackCfg.name))
    CommonHelper:SetText("###desc",self.gameObject,CommonHelper:GetTempStr_Default(trackCfg.desc))
    self:SetBuyNum()
end

function TrackSegmentGoodInfoView:BuyDone()

end
function TrackSegmentGoodInfoView:SetBuyNum()
     CommonHelper:SetInputFieldText("Input75",self.gameObject,tostring(_BuyGoodInfo.buyGoodCount))
end
