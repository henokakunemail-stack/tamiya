---@class RecruitGoView :ViewBase
RecruitGoView = class("RecruitGoView", ViewBase)

function RecruitGoView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RecruitGoViewAction")

end

function RecruitGoView:Awake()
    self.BtnClose = CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
    end)

    self.BtnCancel = CommonHelper:HButtonSetCallback("BtnCancel", self.gameObject, function(data)
        UIManager:Get():ClosePopup()

    end)
    self.BtnOK = CommonHelper:HButtonSetCallback("BtnOK", self.gameObject, function(data)
        print("扭蛋  快捷购买---", self.propID, self.propNum, self.coinID)
        CommonSubsystem:Get():SendMsg_BuyDirect(self.propID, self.propNum, self.coinID)
    end)

    self.BtnNoOK = CommonHelper:HButtonSetCallback("BtnNoOK", self.gameObject, function(data)
        if self.coinID == CurrencyType.Gold then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ShopBuyMoneyNoEnough))
        else
            ChargeTipsDataManager:Get():SetChargeStateNeedNum(self.needNum - self.haveCoinNum)
            CommonSubsystem:Get():SendMsg_ShowCharge()
        end
    end)

    self.BtnGou = CommonHelper:HButtonSetCallback("BtnGou", self.gameObject, function(data)
        local ifAlertData = UserDirectManager:Get():GetDataByID(self.propID, self.coinID)
        if ifAlertData.ifalert == 1 then
            CommonSubsystem:Get():SendMsg_DirectAlert(self.propID, self.coinID, 0)
        else
            CommonSubsystem:Get():SendMsg_DirectAlert(self.propID, self.coinID, 1)
        end
    end)
end

function RecruitGoView:OnOpen()
end

function RecruitGoView:SetData(propID, coinID, count)
    self.propID = propID
    self.coinID = coinID

    self.haveNum = KnapsackDataManager:Get():GetArticleCountByCfgid(self.propID)
    self.haveCoinNum = KnapsackDataManager:Get():GetArticleCountByCfgid(self.coinID)
    self.priceNum = UserDirectManager:Get():GetDataByID(self.propID, self.coinID)
    self.propNum = count - self.haveNum
    self.needNum = self.priceNum.pay[1] * self.propNum

    local propType, propcfg = CommonHelper:GetPropTypeById(self.propID)
    local coinType, coincfg = CommonHelper:GetPropTypeById(self.coinID)

    CommonHelper:GetComponentSetUITexture("PropImage_dt", self.gameObject, propcfg.icon .. ".png", UIModuleID.RecruitGo)
    CommonHelper:GetComponentSetUITexture("NeedImage_dt", self.gameObject, coincfg.icon .. ".png", UIModuleID.RecruitGo)
    CommonHelper:SetText("###PropText", self.gameObject, tostring(self.propNum))
    CommonHelper:SetText("###NeedText", self.gameObject, tostring(self.needNum))

    CommonHelper:SetGameObjectActive("BtnNoOK", self.gameObject, self.needNum > self.haveCoinNum)
    CommonHelper:SetGameObjectActive("BtnOK", self.gameObject, self.needNum <= self.haveCoinNum)
    CommonHelper:SetGameObjectActive("BtnGou", self.gameObject, true)

    CommonHelper:SetText("BtnNoOK/###numtext", self.gameObject, tostring(self.needNum - self.haveCoinNum))
    CommonHelper:GetComponentSetUITexture("BtnNoOK/NeedImage_dt", self.gameObject, coincfg.icon .. ".png", UIModuleID.RecruitGo)

    CommonHelper:SetText("###showText", self.gameObject,
            string.format(CommonHelper:GetTempStr_Default(TemplateStringID.RecruitGoShowText),
                    self.needNum, CommonHelper:GetTempStr_Default(propcfg.name), self.propNum))

    CommonHelper:SetText("BtnGou/###text", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.RecruitGoGouText))

    self:RefreshAlert()
end

function RecruitGoView:RefreshAlert()
    CommonHelper:SetGameObjectActive("BtnGou/BgOK", self.gameObject, self.priceNum.ifalert == 0)
end

function RecruitGoView:OnClose()
    self.propID = nil
    self.coinID = nil
    self.haveNum = nil
    self.haveCoinNum = nil
    self.priceNum = nil
    self.propNum = nil
    self.needNum = nil
    CommonHelper:ReleasePool(UIModuleID.RecruitGo)
end


