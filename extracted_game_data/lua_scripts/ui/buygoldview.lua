---@class BuyGoldView:ViewBase
BuyGoldView = class("BuyGoldView", ViewBase)

function BuyGoldView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "BuyGoldViewAction")
end

function BuyGoldView:Awake()

    CommonHelper:HButtonSetCallback("BgBtn", self.gameObject, function(param)
        UIManager:Get():ClosePopup()
    end)

    CommonHelper:HButtonSetCallback("BtnProbability", self.gameObject, function(hbtn)
        local isshow = UIManager:Get():IsPersistentViewShow("BuyGoldTipsView")
        if isshow == false then
            UIManager:Get():ShowPersistentView("BuyGoldTipsView", CanvasType.TopCanvas, "BuyGoldTipsView", false, true)
        end
        UINotify:Get():SendNotification(UINotifyEvent.ShowBuyGoldTips_Center)
    end)

    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(btn)
        CommonHelper:ShowHelpView(PageDetailType.BuyGold, nil, nil, true)
    end)

    self.ShowGoldSVC = UIUtil.GetTypeChildWightInputPath("ShowGoldSVC", self.gameObject, typeof(MoreRowScrollView))

end

function BuyGoldView:OnOpen()
    CommonHelper:HButtonSetCallback("BtnNum", self.gameObject, function(param)
        if self.NumState then
            UIManager:OpenPopup("BuyGoldNotarizeView", CanvasType.MainCanvas, "BuyGoldNotarizeView", true)
            UINotify:Get():SendNotification(UINotifyEvent.ShowBuyGoldNotarize_Center, self.nowNum)

        else
            CommonTipsHelper:Get():ShowPushTips(CommonHelper:GetTempStr_Default(TemplateStringID.BuyGoldUseNumTips1))
        end
    end)
    CommonHelper:HButtonSetCallback("BtnOne", self.gameObject, function(param)
        if self.NumStateOne then
            print("--179, --请求点金手 P2=次数", 1)
            CommonSubsystem:Get():SendMsg_ExChGold(1)
        else
            CommonTipsHelper:Get():ShowPushTips(CommonHelper:GetTempStr_Default(TemplateStringID.BuyGoldUseNumTips2))
        end
    end)

    self:UpdateBuyGoldView()
end

function BuyGoldView:OnClose()
    BuyGoldDataManager:Get():Clear()

    CommonHelper:ReleasePool(UIModuleID.BuyGold)
end

function BuyGoldView:UpdateBuyGoldView()

    self.nowNum = PlayerDataManager:Get():GetExChGold()

    ---@type dictexchgold_config
    local cfg = ClientDataManager:Get():GetDataTable(ConfigNames.dictexchgold_config)
    local _maxNum = #cfg.GetConfigData()
    local nowData = cfg.GetNowDataByID(self.nowNum + 1)

    CommonHelper:SetText("###showTxt", self.gameObject,
            string.format(CommonHelper:GetTempStr_Default(TemplateStringID.BuyGoldUseNumText), _maxNum - self.nowNum, _maxNum))

    CommonHelper:SetText("leftIcon/###Text", self.gameObject, nowData.dianum)
    CommonHelper:SetText("RightIcon/###Text", self.gameObject, nowData.goldnum)

    self.NumState = (_maxNum - self.nowNum) >= 5
    self.NumStateOne = self.nowNum < _maxNum

    local showData = BuyGoldDataManager:Get():GetBuyGoldData()
    CommonHelper:SetGameObjectActive("ifShow", self.gameObject, #showData > 0)
    CommonHelper:InitMoreRowScrollView(self.ShowGoldSVC, #showData, 1, function(itemIndex, itemChild, scroll)
        local msgData = showData[itemIndex + 1]
        --local str = ""
        --
        --if msgData.batval == 1 then
        --    str = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.BuyGoldTipsText2), msgData.downgold)
        --else
        --    str = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.BuyGoldTipsText), msgData.batval, msgData.downgold)
        --end

        CommonHelper:SetText("###progress1", itemChild,
                string.format(CommonHelper:GetTempStr_Default(TemplateStringID.BuyGoldSVCShow1), msgData.pay))
        CommonHelper:SetText("###progress2", itemChild,
                string.format(CommonHelper:GetTempStr_Default(TemplateStringID.BuyGoldSVCShow2), msgData.downgold))
        CommonHelper:SetText("###progress3", itemChild,
                string.format(CommonHelper:GetTempStr_Default(TemplateStringID.BuyGoldSVCShow3), msgData.batval))

    end)

    if #showData - 1 > 5 then
        CommonHelper:MoreRowView_ScrollToItem(self.ShowGoldSVC, #showData - 1)
    end


end



