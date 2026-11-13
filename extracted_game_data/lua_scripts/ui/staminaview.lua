---@class StaminaView:ViewBase
StaminaView = class("StaminaView", ViewBase)

function StaminaView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "StaminaViewAction")
end

function StaminaView:Awake()
    --购买
    self.PurchaseBtn = CommonHelper:HButtonSetCallback("PurchaseBtn", self.gameObject, function(param)
        local PowerArticleCfgID = tonumber(CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.PowerArticleCfgID).varval) --12040104	体力药剂
        --UIManager:Get():OpenPopup("BuyDirectView", CanvasType.FrontCanvas, "BuyDirectView")
        --UINotify:Get():SendNotification(UINotifyEvent.BuyDirectViewSetData, PowerArticleCfgID)
        CommonSubsystem:Get():SendMsg_BuyDirect(PowerArticleCfgID, 1, CurrencyType.Diamond)
    end)

    --使用
    CommonHelper:HButtonSetCallback("UseBtn", self.gameObject, function(param)
        local cell = CommonHelper:GetPowerArticleCfg()
        if PlayerDataManager:Get():CheckCurrencyEnough(cell.C_ID,1)  then
            StaminaSubsystem:Get():SendMsg_UseStamina(cell.C_ID, 1)
        end
    end)

    --任意处关闭
    CommonHelper:HButtonSetCallback("BgBtn", self.gameObject, function(param)
        UIManager:Get():ClosePopup()
    end)
end

function StaminaView:OnOpen()
    self:InitStaminaView()
end

function StaminaView:InitStaminaView()
    local PowerArticleCfgID = tonumber(CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.PowerArticleCfgID).varval)--12040104	体力药剂
    print("PowerArticleCfgID   PowerArticleCfgID        ", PowerArticleCfgID)
    local articleCount = KnapsackDataManager:Get():GetArticleCountByCfgid(PowerArticleCfgID)
    ---@type article_config_cell
    local articleData = CommonHelper:GetTableDataByID(ConfigNames.article_config, PowerArticleCfgID)  --12040104	体力药剂
    CommonHelper:SetText("###PropCountText", self.gameObject, tostring(articleCount))
    local obj = self:GetChild("ItemArticleCom")
    local param = Param_PropParam()
    param.id = PowerArticleCfgID
    param.moduleId = UIModuleID.Stamina
    param.showname = true
    param.count = -1
    CommonHelper:SetPropGroup(obj, param)

    CommonHelper:SetText("###PropInfoText", self.gameObject,ClientDataManager:Get():GetTemplateString(articleData.description))
    local directData = UserDirectManager:Get():GetDataByID(param.id, CurrencyType.Diamond)
    local buyData = directData.pay[directData.curnum + 1]
    local price = buyData == nil and -1 or tonumber(buyData)
    self:SetPurchaseText(directData.curnum ,#directData.pay, price)

end

function StaminaView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.Stamina)
end

--50,60, 70, 80, 90, 100
function StaminaView:UpdateData(isBuyStamina)
    local PowerArticleCfgID = tonumber(CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.PowerArticleCfgID).varval) --12040104	体力药剂
    local articleCount = KnapsackDataManager:Get():GetArticleCountByCfgid(PowerArticleCfgID)
    CommonHelper:SetText("###PropCountText", self.gameObject, tostring(articleCount))
    if isBuyStamina then
        local directData = UserDirectManager:Get():GetDataByID(PowerArticleCfgID, CurrencyType.Diamond)
        local buyData = directData.pay[directData.curnum + 1]
        local price = buyData == nil and -1 or tonumber(buyData)
        self:SetPurchaseText(directData.curnum ,#directData.pay, price)
    else
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.StaminaHasUsedProp))
    end
end

function StaminaView:SetPurchaseText(buyStaminaTimes, maxcount,price)
    CommonHelper:SetText("PurchaseBtn/###text", self.gameObject, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.PurchaseNum), maxcount-buyStaminaTimes))

    CommonHelper:SetGameObjectActive("###PropFreePurchaseText", self.gameObject, price == -1)
    CommonHelper:SetGameObjectActive("consume", self.gameObject, price ~= -1)

    CommonHelper:SetHButtonClick(self.PurchaseBtn, price ~= -1, true)

    if price == -1 then
        CommonHelper:SetText("###PropFreePurchaseText", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.PurchaseLimit))
    else
        CommonHelper:SetText("###PropPriceText", self.gameObject, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrNum), "x", price))
    end
end


