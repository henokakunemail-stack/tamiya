---@class ChargeTipsView :ViewBase
ChargeTipsView = class("ChargeTipsView", ViewBase)

function ChargeTipsView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ChargeTipsViewAction")

end

function ChargeTipsView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
    end)

    CommonHelper:HButtonSetCallback("BtnLookMore", self.gameObject, function(data)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.PurchasePanel)
        UIManager:Get():ClosePopup()
    end)

    self.BtnBuy= CommonHelper:HButtonSetCallback("BtnBuy", self.gameObject, function(data)
        CommonHelper:ChargeMoneyByID(self._minData.itemID)
    end)
end

function ChargeTipsView:OnOpen()

end

function ChargeTipsView:SetData()
    self._minData = ChargeTipsDataManager:Get():GetChargeStateDataByCostNum()
    local cfg = CommonHelper:GetChargeDataByArea()
    local shwoData = cfg[self._minData.itemID]
    CommonHelper:SetBtnIsRmbOrToken(self.BtnBuy,CommonHelper:GetChargeCfgByAreaAndItemId(self._minData.itemID))
    if shwoData then

    end
    CommonHelper:GetComponentSetUITexture("icon_dt", self.gameObject, shwoData.icon, UIModuleID.ChargeTips)
    CommonHelper:SetText("###Diamond", self.gameObject, CommonHelper:GetTempStr_Default(shwoData.name))
    CommonHelper:SetGameObjectActive("firstdouble", self.gameObject, self._minData.firstFlag == 1)
    CommonHelper:SetText("BtnBuy/###priceText", self.gameObject, shwoData.pricename)

    local needNum = ChargeTipsDataManager:Get():GetChargeStateNeedNum()
    CommonHelper:SetText("###needText", self.gameObject,
            string.format(CommonHelper:GetTempStr_Default(TemplateStringID.ChargeTipsNeedText), needNum))

end

function ChargeTipsView:OnClose()
    self._minData = {}
    CommonHelper:ReleasePool(UIModuleID.ChargeTips)
end


