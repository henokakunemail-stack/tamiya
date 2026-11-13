---@class Page_CommonFestivalEveryDayView
--每日礼赠

Page_CommonFestivalEveryDayView = class("Page_CommonFestivalEveryDayView")

function Page_CommonFestivalEveryDayView:initialize(parentPref)
    self.parentPref = parentPref
end

function Page_CommonFestivalEveryDayView:RefreshEveryDayInfo()
    self.everyDayData = CommonFestivalDataManager:Get():GetEveryDayaData()

    for i = 1, 4 do
        local itemObj = UIUtil.GetChild("ItemObj_" .. i, self.parentPref)
        local _data = CommonHelper:GetTableDataByID(ConfigNames.act_gift_config, self.everyDayData[i].itemid)
        local awardGift = stringSplit(_data.awardids, ':')
        local awardGiftNum = stringSplit(_data.awardnums, ':')

        for i = 1, #awardGift do
            local item = UIUtil.GetChild("obj_grid/Item_" .. i, itemObj)
            local param = Param_ItemArticleParam()
            param.count = tonumber(awardGiftNum[i])
            CommonHelper:SetItemComGroup(item, UIModuleID.CommonAct, tonumber(awardGift[i]), param, function(btnData)
                CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.CommonAct)
            end, tonumber(awardGift[i]))


            CommonHelper:SetGameObjectActive("obj_grid/Item_" .. i, itemObj, true)
        end

        local BtnChoose=CommonHelper:HButtonSetCallback("BtnChoose", itemObj, function(data)
            CommonHelper:ChargeMoneyByID(self.everyDayData[i].itemid)
        end)
        if i > 1 then
            local chargecfg = CommonHelper:GetChargeCfgByAreaAndItemId(self.everyDayData[i].itemid)
            CommonHelper:SetBtnIsRmbOrToken(BtnChoose,chargecfg)
        else
            CommonHelper:SetGameObjectActive("###priceText",BtnChoose.gameObject,true)
            CommonHelper:SetGameObjectActive("moneycost",BtnChoose.gameObject,false)
            CommonHelper:SetText("BtnChoose/###priceText", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalEveryDayBtnText))
        end
        if self.everyDayData[5].buysum == 0 then
            CommonHelper:SetGameObjectActive("maskImage", itemObj, self.everyDayData[i].buysum > 0)
            CommonHelper:SetGameObjectActive("BtnChoose", itemObj, self.everyDayData[i].buysum == 0)
        else
            if i > 1 then
                CommonHelper:SetGameObjectActive("maskImage", itemObj, true)
                CommonHelper:SetGameObjectActive("BtnChoose", itemObj, false)
            else
                CommonHelper:SetGameObjectActive("maskImage", itemObj, self.everyDayData[i].buysum > 0)
                CommonHelper:SetGameObjectActive("BtnChoose", itemObj, self.everyDayData[i].buysum == 0)
            end
        end

    end

    local BtnAllBuyNum = CommonHelper:GetChargeCfgByAreaAndItemId(self.everyDayData[#self.everyDayData].itemid)
    CommonHelper:SetText("BtnAllBuy/###priceText", self.parentPref, BtnAllBuyNum.pricename)
    CommonHelper:SetText("BtnAllBuy/###zheText", self.parentPref,
            CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalEveryDayZheText))

    local BtnAllBuy= CommonHelper:HButtonSetCallback("BtnAllBuy", self.parentPref, function(data)
        CommonHelper:ChargeMoneyByID(self.everyDayData[#self.everyDayData].itemid)

    end)
    CommonHelper:SetBtnIsRmbOrToken(BtnAllBuy,CommonHelper:GetChargeCfgByAreaAndItemId(self.everyDayData[#self.everyDayData].itemid))
    local AllBuyState = self:GetBtnAllBuyState()
    CommonHelper:SetGameObjectActive("BtnAllBuy", self.parentPref, AllBuyState)

    CommonHelper:SetText("showText/###Text", self.parentPref,
            CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalEveryShowText))

    local actID = CommonFestivalDataManager:Get():GetActivityDataIDByType(CommonFestivalType.EveryDayGift)
    local t_beginTime, t_endTime = CommonFestivalDataManager:Get():GetActTime(actID)
    local _beginTime = CommonHelper:ConvertIntToDataTime(t_beginTime * 1000)
    local _endTime = CommonHelper:ConvertIntToDataTime(t_endTime * 1000)
    CommonHelper:SetText("time/###time", self.parentPref,
            CommonHelper:GetTempStr_Default(TemplateStringID.FestivalTimeText,
                    _beginTime.Month, _beginTime.Day, _beginTime.Hour, _beginTime.Minute,
                    _endTime.Month, _endTime.Day, _endTime.Hour, _endTime.Minute))

end

function Page_CommonFestivalEveryDayView:GetBtnAllBuyState()
    for i = 2, #self.everyDayData do
        if self.everyDayData[i].buysum > 0 then
            return false
        end
    end

    return true
end

