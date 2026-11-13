---@class TopInfoView : ViewBase
TopInfoView = class("TopInfoView", ViewBase)

function TopInfoView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "TopInfoViewAction")
end

function TopInfoView:Awake()
    log("---   TopinfoView awake")

    CommonHelper:HButtonSetCallback("BtnAddPower", self.gameObject, function(param)
        UIManager:OpenPopup("StaminaView", CanvasType.MainCanvas, "StaminaView", true)
    end)

    CommonHelper:HButtonSetCallback("BtnAddDiamond", self.gameObject, function(param)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.PurchasePanel)
    end)
  CommonHelper:HButtonSetCallback("BtnAddMoney", self.gameObject, function(param)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.PurchasePanel)
    end)

    CommonHelper:HButtonSetCallback("BtnAddGold", self.gameObject, function(param)
        UIManager:OpenPopup("BuyGoldView", CanvasType.MainCanvas, "BuyGoldView", true)
    end)
end
function TopInfoView:CloseAllUI(flag)
    UIUtil.ShowCanvasGroupByName("Top", self.gameObject, flag)
    UINotify:Get():SendNotification(UINotifyEvent.Msg_LeftCloseUI,flag)
end
function TopInfoView:OnOpen()
    self:InitTopInfoViewInfo()
end

function TopInfoView:InitTopInfoViewInfo()
    CommonHelper:SetText("###LabPlayerName", self.gameObject, PlayerDataManager:Get():GetPlayerName())
    self:SetCurrencyData()
    self:SetStamina()
end

function TopInfoView:SetCurrencyData()
    CommonHelper:SetText("###LabGold", self.gameObject, PlayerDataManager:Get():GetCurrency(CurrencyType.Gold))
    CommonHelper:SetText("###LabDiamond", self.gameObject, PlayerDataManager:Get():GetCurrency(CurrencyType.Diamond))
    CommonHelper:SetText("###LabMoney", self.gameObject, PlayerDataManager:Get():GetCurrency(CommonHelper:GetDictCalcData(CommonCfgKey.TokenExchange)))
    self:SetFriendShip(self.CurType,self.FileName)
end

function TopInfoView:SetStamina()
    local curStamina = PlayerDataManager:Get():GetPlayerStamina()
    local maxStamina = PlayerDataManager:Get():GetPlayerMaxStamina()
    CommonHelper:SetText("###LabPower", self.gameObject, string.format("%d/%d", curStamina, maxStamina))
end

function TopInfoView:SetFriendShip(type,fileName)
    if type and fileName then
        self.CurType=type
        self.FileName=fileName
        CommonHelper:SetText("###LabFriendShip", self.gameObject, tostring(PlayerDataManager:Get():GetCurrency(type)))
        local image= CommonHelper:GetComponentSetImage("friendship_1",self.gameObject,fileName,UIModuleID.Top)
        CommonHelper:ImageSetNativeSize(image)
    end

    --CommonHelper:ImageSetNativeSize(image)
end


