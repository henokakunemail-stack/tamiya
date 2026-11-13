---@class Page_CommonFestivalMoreMoneyView
--暴击充值

Page_CommonFestivalMoreMoneyView = class("Page_CommonFestivalEveryDayView")

function Page_CommonFestivalMoreMoneyView:initialize(parentPref)

    self.parentPref = parentPref
end
---@param msg SC_ActChargeGift
function Page_CommonFestivalMoreMoneyView:RefreshMoreMoneyInfo(msg)

    CommonHelper:SetText("RawImage/###Text", self.parentPref,
            CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalMoreMoneyShowText))

    self.ScrollView = UIUtil.GetTypeChildWightByParent("MoreRowScrollViewClick_H", self.parentPref, typeof(MoreRowScrollView))
    self.Data = {}
    ---@type act_bussiness_config_cell
    self.PageCfg = CommonHelper:GetTableDataByID(ConfigNames.act_bussiness_config, msg.actId)
    for i = 1, #msg.buyItems do
        ---@type act_gift_config_cell
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.act_gift_config, msg.buyItems[i])
        local chargecfg = CommonHelper:GetChargeCfgByAreaAndItemId(msg.buyItems[i])
        local temp = {}
        temp.cfg = cfg
        temp.chargecfg = chargecfg
        if msg.actBuyFlag[i] then
            temp.buyFlag = msg.actBuyFlag[i]
            temp.canBuy = msg.actBuyFlag[i] > -1
            if msg.actBuyFlag[i] == -1 then
                temp.buyFlag = 0
            end
        else
            temp.buyFlag = 0
        end

        table.insert(self.Data, temp)
    end

    local t_beginTime, t_endTime = CommonFestivalDataManager:Get():GetActTime(msg.actId)
    local startTime = CommonHelper:ConvertIntToDataTime(t_beginTime * 1000)
    local endTime = CommonHelper:ConvertIntToDataTime(t_endTime * 1000)
    CommonHelper:SetText("###time", self.parentPref,
            CommonHelper:GetTempStr_Default(TemplateStringID.FestivalTimeText,
                    startTime.Month, startTime.Day, startTime.Hour, startTime.Minute,
                    endTime.Month, endTime.Day, endTime.Hour, endTime.Minute))

    CommonHelper:InitMoreRowScrollView(self.ScrollView, #self.Data, 1, function(index, itemObj, scroll)
        local data = self.Data[index + 1]
        CommonHelper:SetText("###titleText", itemObj, CommonHelper:GetTempStr_Default(data.cfg.name))
        CommonHelper:SetText("###astrictText", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalMoreMoneyLimit, data.buyFlag, data.cfg.buymax))
        local btnBuy = CommonHelper:HButtonSetCallback("BtnBuy", itemObj, function(data)
            --print("幸运暴击   充值ID    ----",self.Data[data.intData + 1].chargecfg.itemid)
            CommonHelper:ChargeMoneyByID(self.Data[data.intData + 1].chargecfg.itemid)
        end, index)
        CommonHelper:SetBtnIsRmbOrToken(btnBuy,self.Data[index + 1].chargecfg)
        if data.canBuy and data.buyFlag < data.cfg.buymax then
            CommonHelper:SetHButtonClick(btnBuy, true, true)
            CommonHelper:SetBtnIsRmbOrToken(btnBuy,data.chargecfg)
            CommonHelper:SetText("###priceText", btnBuy.gameObject, CommonHelper:GetTempStr_Default(data.chargecfg.pricename))
            CommonHelper:SetGameObjectActive("###buyState", itemObj, false)
        else
            CommonHelper:SetHButtonClick(btnBuy, false, true)
            CommonHelper:SetGameObjectActive("###buyState", itemObj, true)
            if not data.canBuy then
                CommonHelper:SetText("###buyState", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalMoreMoneyNoBuy))
            end
            if data.buyFlag >= data.cfg.buymax then
                CommonHelper:SetText("###buyState", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalMoreMoneyBuyMax))
            end
        end
    end)
    self.BtnProb=CommonHelper:HButtonSetCallback("BtnProb", self.parentPref, function(hbtn)
        CommonHelper:ShowHelpView(PageDetailType.LuckyCriticalProb, nil, HelpStyleType.YellowStyle, true)
    end)
    CommonHelper:SetHButtonClick(self.BtnProb,HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.BtnProb),true)
end