---@class BuyGoldNotarizeView:ViewBase
BuyGoldNotarizeView = class("BuyGoldNotarizeView", ViewBase)

function BuyGoldNotarizeView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "BuyGoldNotarizeAction")
end

function BuyGoldNotarizeView:Awake()

    CommonHelper:HButtonSetCallback("BgBtn", self.gameObject, function(param)
        UIManager:Get():ClosePopup()
    end)

    CommonHelper:HButtonSetCallback("BtnCancel", self.gameObject, function(param)
        UIManager:Get():ClosePopup()
    end)

    CommonHelper:HButtonSetCallback("BtnOK", self.gameObject, function(param)
        print("--179, --请求点金手 P2=次数", 5)
        CommonSubsystem:Get():SendMsg_ExChGold(5)
        UIManager:Get():ClosePopup()
    end)

end

function BuyGoldNotarizeView:OnOpen()

end

function BuyGoldNotarizeView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.BuyGoldNotarize)
end

function BuyGoldNotarizeView:UpdateBuyGoldNotarizeView(nowNum)

    ---@type dictexchgold_config
    local cfg = ClientDataManager:Get():GetDataTable(ConfigNames.dictexchgold_config)
    local _dataPrice, _dataNum = cfg.GetNumDataByID(nowNum + 1)

    CommonHelper:SetText("leftIcon/###Text", self.gameObject, _dataPrice)
    CommonHelper:SetText("RightIcon/###Text", self.gameObject, _dataNum)

end



