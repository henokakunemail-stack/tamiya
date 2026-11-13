---@class GoodsInfoView : ViewBase
GoodsInfoView = class("GoodsInfoView", ViewBase)
---@type ShopData
local _CurShop = nil
---@type BuyGoodData
local _BuyGoodInfo = nil
function GoodsInfoView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "GoodsInfoViewAction")
end
local maxCount=9999
function GoodsInfoView:Awake()
    self.Center = UIUtil.GetChild("Center", self.gameObject)
    self.shownum = UIUtil.GetChild("shownum", self.Center)

    self.buyButton = UIUtil.GetTypeChildWightByParent("BuyBtn", self.Center, typeof(HButton))

    CommonHelper:HButtonSetCallback("BtnCloseMask", self.Center, function(data)
        UIManager:Get():HidePersistentView("GoodsInfoView")

    end)
    CommonHelper:HButtonSetCallback("BtnClose", self.Center, function(data)
        UIManager:Get():HidePersistentView("GoodsInfoView")
    end)
end
local CurCurrenyNum = 0
function GoodsInfoView:SetData(dataIndex)
    local data=nil
    if ShopDataManager:Get().ShopId== ShopID.StrengthSprint then
        _CurShop = StrengthActivityManager:Get().CurShopData
        data=_CurShop.goods[dataIndex+1]
    else
        _CurShop = ShopDataManager:Get():GetCurShop()
        data=ShopDataManager:Get().CurShopGoodList[dataIndex+1]
    end
    _BuyGoodInfo = BuyGoodData()
    if data == nil then
        return
    end
    if _CurShop.LastCoin ~= 0 then
        CurCurrenyNum = _CurShop.LastCoin
    else
        CurCurrenyNum = PlayerDataManager:Get():GetCurrency(data.moneyType)
    end
    local param = Param_ShopGoodsGroup()
    param.goodType = data.goodsType
    param.articleId = data.id
    param.moduleId = UIModuleID.Shop
    param.count = 1
    param.price = data.price
    param.currencytype = data.moneyType
    param.num = data.num
    param.maxNum = data.maxNum
    param.showname = true
    param.flag = data.flag
    self.disCount = data.discount
    self.param = param
    CommonHelper:SetShopGoodsGroup(self.Center, param,function(data)
        CommonHelper:ShowPartInfoByCfgId(data, UIModuleID.Shop)
    end,data.id)
    -- CommonHelper:SetText("PriceTxt", self.Center, data.moneyNum)

    if data.moneyType then
        ---@type dictarticle_config_cell
        local image = CommonHelper:GetComponentSetImage("currySprite", self.gameObject, CommonHelper:GetCurrencyTypeImage(data.moneyType), UIModuleID.Shop)
        CommonHelper:ImageSetNativeSize(image)
    end
    self.buyInput = UIUtil.GetTypeChildWightByParent("UseNumInput", self.gameObject, typeof(InputField))

    _BuyGoodInfo.buyGoodCount = 1
    _BuyGoodInfo.buyGoodGridId = data.grid
    _BuyGoodInfo.buyGoodId = data.id
    _BuyGoodInfo.buyGoodMaxNum = data.num
    _BuyGoodInfo.buyGoodIsLimit = data.maxNum
    CommonHelper:InputFieldSetValue(self.buyInput,_BuyGoodInfo.buyGoodCount)
    self:SetBuyNum()
    CommonHelper:HButtonSetCallback("BtnEditorRemove", self.Center, function(data)
        _BuyGoodInfo.buyGoodCount = _BuyGoodInfo.buyGoodCount - 1
        if _BuyGoodInfo.buyGoodCount <= 0 then
            _BuyGoodInfo.buyGoodCount = 1
        end
        UINotify:Get():SendNotification(UINotifyEvent.SetBuyNum)
    end)
    CommonHelper:HButtonSetCallback("BtnEditorAdd", self.Center, function(data)
        _BuyGoodInfo.buyGoodCount = _BuyGoodInfo.buyGoodCount + 1
        if _BuyGoodInfo.buyGoodIsLimit~=0 then
            if _BuyGoodInfo.buyGoodCount > _BuyGoodInfo.buyGoodMaxNum then
                _BuyGoodInfo.buyGoodCount = _BuyGoodInfo.buyGoodMaxNum
            end
        end
        if _BuyGoodInfo.buyGoodIsLimit==0 and _BuyGoodInfo.buyGoodCount>maxCount then
            _BuyGoodInfo.buyGoodCount =maxCount
        end
        UINotify:Get():SendNotification(UINotifyEvent.SetBuyNum)
    end)
    local BtnEditorMax=  CommonHelper:HButtonSetCallback("BtnEditorMax", self.Center, function(data)
        _BuyGoodInfo.buyGoodCount = _BuyGoodInfo.buyGoodMaxNum
        if _BuyGoodInfo.buyGoodIsLimit==0 then
            _BuyGoodInfo.buyGoodCount =maxCount
        end
        UINotify:Get():SendNotification(UINotifyEvent.SetBuyNum)
    end)
    local BtnEditorMin=  CommonHelper:HButtonSetCallback("BtnEditorMin", self.Center, function(data)
        _BuyGoodInfo.buyGoodCount =1
        UINotify:Get():SendNotification(UINotifyEvent.SetBuyNum)
    end)

    self.buyInput.onValueChanged:AddListener(function(str)
        if CommonHelper:IsNullOrEmpty(str) then
            return
        end
        local result = tonumber(str)
        if result then
            if   result > 0 and result <= _BuyGoodInfo.buyGoodMaxNum then
                _BuyGoodInfo.buyGoodCount = result
                if _BuyGoodInfo.buyGoodIsLimit==0 and _BuyGoodInfo.buyGoodCount>maxCount then
                    _BuyGoodInfo.buyGoodCount =maxCount
                end
            else
                if result <= 0 then
                    _BuyGoodInfo.buyGoodCount =1
                else
                    if _BuyGoodInfo.buyGoodIsLimit==0 and result>maxCount then
                        _BuyGoodInfo.buyGoodCount =maxCount
                    else
                        if result>_BuyGoodInfo.buyGoodMaxNum and _BuyGoodInfo.buyGoodIsLimit~=0 then
                            _BuyGoodInfo.buyGoodCount = _BuyGoodInfo.buyGoodMaxNum
                        else
                            _BuyGoodInfo.buyGoodCount=result
                        end
                    end
                end
            end
            UINotify:Get():SendNotification(UINotifyEvent.SetBuyNum)
        end
    end)
    CommonHelper:SetGameObjectActive("shownum", self.Center, _BuyGoodInfo.buyGoodMaxNum >= 1 or _BuyGoodInfo.buyGoodIsLimit==0)

    --CommonHelper:SetText("PlayerMoneyTxt", self.Center, CurCurrenyNum)
    --CommonHelper:SetText("CurCount", self.Center, data.count)
    --CommonHelper:SetText("AllCount", self.Center, data.maxNum)
    ---@type dictparts_config_cell
    local partData = CommonHelper:GetTableDataByID(ConfigNames.parts_config, data.id)
    local articleData = CommonHelper:GetTableDataByID(ConfigNames.article_config, data.id)
    ---@type tracksegement_config_cell
    local trackData = CommonHelper:GetTableDataByID(ConfigNames.tracksegement_config, data.id)
    local desc = ""
    local count =0
    if partData ~= nil then
        --self.HasNum:SetActive(true)
        count=#KnapsackDataManager:Get():GetPartListByCfgid(data.id)
        CommonHelper:SetText("###playerHoldNum", self.gameObject, count)
        desc = CommonHelper:GetTempStr_Default(partData.partdesc)
    else
        count = KnapsackDataManager:Get():GetArticleCountByCfgid(data.id)
    end
    if articleData ~= nil or trackData~=nil then
        CommonHelper:SetText("###playerHoldNum", self.gameObject, count)
        if articleData then
            desc= CommonHelper:GetTempStr_Default(articleData.description)
        end
        if trackData then
            desc=CommonHelper:GetTempStr_Default(trackData.desc)
        end
    end

    CommonHelper:SetText("###goodsdesctext", self.Center, desc)


    CommonHelper:HButtonSetCallback("BuyBtn", self.Center, function(data)
        if CommonHelper:IsNullOrEmpty(CommonHelper:InputFieldGetValue(self.buyInput)) then
            _BuyGoodInfo.buyGoodCount =1
            UINotify:Get():SendNotification(UINotifyEvent.SetBuyNum)
            CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ShopBuyInputNoNull))
            return
        end
        if PlayerDataManager:Get():CheckCurrencyEnough(self.param.currencytype,math.modf(self.param.price * _BuyGoodInfo.buyGoodCount * self.disCount))   and (_BuyGoodInfo.buyGoodMaxNum >= _BuyGoodInfo.buyGoodCount or _BuyGoodInfo.buyGoodIsLimit==0) then
            ShopDataManager:Get():SetBuyGoods(_BuyGoodInfo)
            ShopSubsystem:Get():SendMsg_Buy(_CurShop.ShopId, _BuyGoodInfo.buyGoodGridId, _BuyGoodInfo.buyGoodCount)
        else
            if _BuyGoodInfo.buyGoodMaxNum < _BuyGoodInfo.buyGoodCount and _BuyGoodInfo.buyGoodIsLimit~=0 then
                CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ShopBuyCountNoEnough))
            end
        end

    end)

    self:CheckNewBieGuide()
end

function GoodsInfoView:SetBuyNum(flag)
    local curAllMoney = math.floor(self.param.price * _BuyGoodInfo.buyGoodCount * self.disCount)
    -- print(curAllMoney)
    if CurCurrenyNum - curAllMoney < 0  then
        _BuyGoodInfo.buyGoodCount = math.floor(CurCurrenyNum / (self.param.price * self.disCount))
        if _BuyGoodInfo.buyGoodCount <= 1 then
            _BuyGoodInfo.buyGoodCount = 1
        end
        curAllMoney = math.floor(self.param.price * _BuyGoodInfo.buyGoodCount * self.disCount)
        if _BuyGoodInfo.buyGoodCount <= 1 then
            curAllMoney = string.format(ClientDataManager:Get():GetTemplateString(TemplateStringID.FontFormatRed), curAllMoney)
        end
    end
    CommonHelper:SetText("###paymoney", self.Center, curAllMoney)
    ShopDataManager:Get().curAllMoney=curAllMoney
    if flag then
        CommonHelper:InputFieldSetValue(self.buyInput,_BuyGoodInfo.buyGoodCount)
    end
    --CommonHelper:ImageSetGray(self:GetChildWightByParent("bg",self.buyButton.gameObject,typeof(Image)),false)
    --=self.Insufficientmoney:SetActive(CurCurrenyNum<math.floor(self.param.price*1*self.disCount))
    --CommonHelper:SetHButtonClick(self.buyButton,CurCurrenyNum>=self.param.price*1*self.disCount,true)
    --self.PlayerMoney:SetActive(CurCurrenyNum>=self.param.price*1*self.disCount)
end
function GoodsInfoView:OnClose()

end
