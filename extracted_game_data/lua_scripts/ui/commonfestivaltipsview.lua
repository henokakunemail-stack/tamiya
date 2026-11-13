---@class CommonFestivalTipsView: ViewBase
CommonFestivalTipsView = class("CommonFestivalTipsView", ViewBase)

function CommonFestivalTipsView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "CommonFestivalTipsViewAction")
end
local __AddNum = 1
local _MaxAddNum = 1
local _CostData=nil
function CommonFestivalTipsView:Awake()

    self.SignInTipsCG = self:GetChildWight("SignInTipsCG", typeof(CanvasGroup))
    self.GoodsInfoCG = self:GetChildWight("GoodsInfoCG", typeof(CanvasGroup))
    self.TipsCustomGiftLockCG = self:GetChildWight("TipsCustomGiftLockCG", typeof(CanvasGroup))

    CommonHelper:HButtonSetCallback("BtnCloseMask", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
    end)
    self.buyInput = UIUtil.GetTypeChildWightByParent("BuyNumInput", self.gameObject, typeof(InputField))
    self.buyInput.onValueChanged:AddListener(function(str)
        if CommonHelper:IsNullOrEmpty(str) then
            return
        end
        local result = tonumber(str)
        if result then
            if result <= 1 then
                result = 1
            end
            if result >= _MaxAddNum then
                result = _MaxAddNum
            end
            __AddNum=result
        end
        self:SetUseNum(_CostData.price)
    end)
    self.ItemCom = self:GetChild("ItemCom")
end


function CommonFestivalTipsView:OnOpen()
    __AddNum = 1
    _MaxAddNum = 1
end

function CommonFestivalTipsView:RefreshTipsInfo(actId, itemData, exchangeNum)
    local _type = CommonHelper:GetTableDataByID(ConfigNames.act_bussiness_config, actId).actstyle

    if _type == CommonFestivalType.SignIn then
        UIUtil.ShowCanvasGroup(self.SignInTipsCG, true)
        UIUtil.ShowCanvasGroup(self.GoodsInfoCG, false)
        UIUtil.ShowCanvasGroup(self.TipsCustomGiftLockCG, false)
        self:RefreshSignInInfo(actId, itemData)
    end

    if _type == CommonFestivalType.Exchange then
        UIUtil.ShowCanvasGroup(self.SignInTipsCG, false)
        UIUtil.ShowCanvasGroup(self.GoodsInfoCG, true)
        UIUtil.ShowCanvasGroup(self.TipsCustomGiftLockCG, false)
        self:RefreshGoodsInfo(actId, itemData, exchangeNum)
    end

    if _type == CommonFestivalType.CustomGift then
        UIUtil.ShowCanvasGroup(self.SignInTipsCG, false)
        UIUtil.ShowCanvasGroup(self.GoodsInfoCG, false)
        UIUtil.ShowCanvasGroup(self.TipsCustomGiftLockCG, true)
        self:RefreshTipsCustomGiftLock(actId, itemData, exchangeNum)
    end

end

function CommonFestivalTipsView:RefreshSignInInfo(signInId, signInData)
    ---@type act_day_sign_config
    local costNum = CommonHelper:GetTableDataByID(ConfigNames.act_day_sign_config, signInId).exppay
    CommonHelper:SetText("###Text", self.gameObject,
            string.format(CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalRetroactive), costNum))

    CommonHelper:HButtonSetCallback("BtnOK", self.gameObject, function(data)
        --print("251 请求签到P2=actid P3=签到天 P4=0正常1补签", signInId, signInData, 1, costNum)
        if costNum <= PlayerDataManager:Get():GetCurrency(CurrencyType.Diamond) then
            CommonFestivalSubSystem:Get():SendMsg_SignNow(signInId, signInData, 1)
            UIManager:Get():ClosePopup()
        else
            CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.CommonFestivalNoDiamond))
        end

    end)
end

function CommonFestivalTipsView:RefreshGoodsInfo(shopID, costData, exchangeNum)
    local _goodsType, _goodsData = CommonHelper:GetPropTypeById(tonumber(costData.coinid))
    local _goodsIconImg = _goodsType == PropType.Part and _goodsData.icon or _goodsData.icon .. ".png"
    _CostData=costData
    local _itemType, _itemData = CommonHelper:GetPropTypeById(tonumber(costData.propsid))
    local _name, _desc, _itemIconImg = CommonHelper:GetPropMessageByType(_itemType, _itemData)

    local param = Param_ItemArticleParam()
    CommonHelper:SetItemComGroup(self.ItemCom, UIModuleID.CommonFestivalTips, _itemData.C_ID, param)

    CommonHelper:GetComponentSetUITexture("###priceIcon", self.gameObject, _goodsIconImg, UIModuleID.CommonFestivalTips)
    CommonHelper:SetText("###name", self.gameObject, CommonHelper:GetTempStr_Default(_name))
    CommonHelper:SetText("###desc", self.gameObject, CommonHelper:GetTempStr_Default(_desc))
    ---@type dictparts_config_cell
    local partData = CommonHelper:GetTableDataByID(ConfigNames.parts_config, _itemData.C_ID)
    local articleData = CommonHelper:GetTableDataByID(ConfigNames.article_config, _itemData.C_ID)
    ---@type tracksegement_config_cell
    local trackData = CommonHelper:GetTableDataByID(ConfigNames.tracksegement_config, _itemData.C_ID)
    local count =0
    if partData ~= nil then
        count=#KnapsackDataManager:Get():GetPartListByCfgid( _itemData.C_ID)
        CommonHelper:SetText("###playerHoldNum", self.gameObject, count)
    else
        count = KnapsackDataManager:Get():GetArticleCountByCfgid( _itemData.C_ID)
    end
    if articleData ~= nil or trackData~=nil then
        CommonHelper:SetText("###playerHoldNum", self.gameObject, count)
    end
    local _limitNum = costData.limitnum - costData.curnum
    local _moneyGetNum = math.floor(exchangeNum / costData.price)

    _MaxAddNum = _moneyGetNum > _limitNum and _limitNum or _moneyGetNum

    if _limitNum > _moneyGetNum then
        _MaxAddNum = _moneyGetNum
    end

    self:SetUseNum(costData.price)

    CommonHelper:HButtonSetCallback("BtnEditorAdd", self.gameObject, function(data)
        __AddNum = __AddNum + 1
        if __AddNum >= _MaxAddNum then
            __AddNum = _MaxAddNum
        end
        self:SetUseNum(costData.price)
    end)

    CommonHelper:HButtonSetCallback("BtnEditorRemove", self.gameObject, function(data)
        __AddNum = __AddNum - 1
        if __AddNum <= 1 then
            __AddNum = 1
        end
        self:SetUseNum(costData.price)
    end)

    CommonHelper:HButtonSetCallback("BtnExchange", self.gameObject, function(data)
        --print("255 请求兑换商城物品P2=shopid P3=商品idP4=数量", shopID, costData.propsid, __AddNum)
        CommonFestivalSubSystem:Get():SendMsg_BuyActShop(shopID, costData.propsid, __AddNum)
        UIManager:Get():ClosePopup()
    end)

    CommonHelper:HButtonSetCallback("BtnMax", self.gameObject, function(data)
        __AddNum = _MaxAddNum
        self:SetUseNum(costData.price)
    end)
    CommonHelper:HButtonSetCallback("BtnMin", self.gameObject, function(data)
        __AddNum = 1
        self:SetUseNum(costData.price)
    end)

end

function CommonFestivalTipsView:SetUseNum(price)
    if __AddNum > _MaxAddNum then
        __AddNum = _MaxAddNum
    end

    CommonHelper:SetInputFieldText("BuyNumInput", self.gameObject, __AddNum)
    CommonHelper:SetText("###moneynum", self.gameObject, __AddNum * price)

end

function CommonFestivalTipsView:RefreshTipsCustomGiftLock(actID, giftId, buyStr)
    CommonHelper:SetText("###CustomGiftText", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalTipsLockedTxt))

    CommonHelper:HButtonSetCallback("CustomGiftBtnOK", self.gameObject, function(data)

        CommonFestivalSubSystem:SendMsg_LockDesign(giftId, actID, buyStr)
        UIManager:Get():ClosePopup()
    end)
end

function CommonFestivalTipsView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.CommonFestivalTips)
end