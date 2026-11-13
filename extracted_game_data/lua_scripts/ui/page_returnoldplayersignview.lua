---@class Page_ReturnOldPlayerSignView
Page_ReturnOldPlayerSignView = class("Page_ReturnOldPlayerSignView")

function Page_ReturnOldPlayerSignView:initialize(parentPref)

    self.parentPref = parentPref
    self:SetSignInObjData()
    self.TogGroup = {}
    self.actID = 0
end

function Page_ReturnOldPlayerSignView:SetSignInObjData()
    self.togDayItem = {}
    self.SignSVC = UIUtil.GetTypeChildWightByParent("SignSVC", self.parentPref, typeof(MoreRowScrollView))
end

function Page_ReturnOldPlayerSignView:RefreshSignInInfo(sign)

    ---@type dictbacksign_config
    local dictbacksign_config = ClientDataManager:Get():GetDataTable(ConfigNames.dictbacksign_config)
    dictbacksign_config = dictbacksign_config.GetConfigData()

    local ifChargeState = ReturnOldPlayerDataManager:Get():GetSignIfCharge()
    local sign = ReturnOldPlayerDataManager:Get():GetSignGift()

    ---1**没签   0**可签   1**免费的已签   2**花钱的已签
    local signedNum = 0

    local UpdateFunc = function(dataIndex, itemObj, scroll)
        CommonHelper:SetGameObjectActive("signed", itemObj, sign[dataIndex + 1] >= 1)
        CommonHelper:SetGameObjectActive("signedMoney", itemObj, sign[dataIndex + 1] == 2)
        if sign[dataIndex + 1] >= 1 then
            signedNum = signedNum + 1
        end

        --CommonHelper:SetText("###dayNum", itemObj, CommonHelper:GetTempStr_Default(dataIndex + 1))

        CommonHelper:SetText("###dayNum", itemObj,
                string.format(CommonHelper:GetTempStr_Default(TemplateStringID.ReturnOldPlayerSignTitle), tostring(dataIndex + 1)))


        local awardData = CommonHelper:GetTableDataByID(ConfigNames.dictbacksign_config, dataIndex + 1)

        local obj = UIUtil.GetChild("ItemCom", itemObj)
        local param = Param_ItemArticleParam()
        param.count = awardData.awardnums
        CommonHelper:SetItemComGroup(obj, UIModuleID.ChallengeMatchCreate, tonumber(awardData.awardids), param, function()
            --print(" 265, --请求回归签到 P2=天数 P3=0普通 ", dataIndex + 1, 0)
            ReturnOldPlayerSubsystem:SendMsg_ReturnBackSign(dataIndex + 1, 0)
        end)

        local obj = UIUtil.GetChild("ItemComMoney", itemObj)
        local param = Param_ItemArticleParam()
        param.count = awardData.hawardnums
        CommonHelper:SetItemComGroup(obj, UIModuleID.ChallengeMatchCreate, tonumber(awardData.hawardids), param, function()
            if ifChargeState == 1 then
                --print(" 265, --请求回归签到 P2=天数  P3=1高级", dataIndex + 1, 1)
                ReturnOldPlayerSubsystem:SendMsg_ReturnBackSign(dataIndex + 1, 1)
            else
                CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ReturnOldPlayerBtnSignMoney))
            end
        end)

        -- -1没到日期   0可签 1普通签完 2高级签完
        CommonHelper:SetGameObjectActive("ItemMask", itemObj, sign[dataIndex + 1] == -1)
        if ifChargeState == 1 then
            CommonHelper:SetGameObjectActive("ItemMaskMoney", itemObj, sign[dataIndex + 1] == -1)
        else
            CommonHelper:SetGameObjectActive("ItemMaskMoney", itemObj, true)
        end

    end

    CommonHelper:InitMoreRowScrollView(self.SignSVC, #dictbacksign_config, 1, UpdateFunc, true,
            function()
            end, false)

    CommonHelper:SetText("Signed/###Text", self.parentPref,
            string.format(CommonHelper:GetTempStr_Default(TemplateStringID.ReturnOldPlayerSignedTxt), signedNum))

    CommonHelper:SetText("diamondBG/###count", self.parentPref, "300")
    CommonHelper:SetText("moneyGet", self.parentPref,
            string.format(CommonHelper:GetTempStr_Default(TemplateStringID.ReturnOldPlayerMoney), 300))

    CommonHelper:SetGameObjectActive("moneyGet/BtnCom", self.parentPref, ifChargeState ~= 1)
    local BtnCom= CommonHelper:HButtonSetCallback("moneyGet/BtnCom", self.parentPref, function(hbtn)
        local chargeID = ReturnOldPlayerChargeID.SignHighID
        CommonHelper:ChargeMoneyByID(chargeID)
    end)
    CommonHelper:SetBtnIsRmbOrToken(BtnCom,CommonHelper:GetChargeCfgByAreaAndItemId(ReturnOldPlayerChargeID.SignHighID))
end