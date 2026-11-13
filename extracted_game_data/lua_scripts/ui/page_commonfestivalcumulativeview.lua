---@class Page_CommonFestivalCumulativeView
---累计登陆充值礼包

Page_CommonFestivalCumulativeView = class("Page_CommonFestivalChargeView")

function Page_CommonFestivalCumulativeView:initialize(parentPref)
    self.parentPref = parentPref
    self.DayItemSVC = UIUtil.GetTypeChildWightByParent("DayItemSVC", self.parentPref, typeof(MoreRowScrollView))
end

function Page_CommonFestivalCumulativeView:RefreshCumulativeInfo()

    local curActCount = CommonFestivalDataManager:Get():GetCumulativeCurActCount() --累计登陆可领取礼包
    local curActInfo = CommonFestivalDataManager:Get():GetCumulativeCurActInfo()--累计登录充值项

    local BoxSlider = {}
    local sliderNum = 0
    for i = 1, #curActCount do
        if curActCount[i].giftFlag >= 1 then
            sliderNum = sliderNum + 1
        end
        local num = math.modf((curActCount[i].countNo / curActCount[#curActCount].countNo) * 100)
        table.insert(BoxSlider, num * 0.01)
    end

    CommonHelper:SetBoxStateSlider("BoxSlider", self.parentPref, BoxSlider, function(item, index, BoxSlider)
        CommonHelper:SetBoxState("BoxState", item, tonumber(curActCount[index + 1].giftFlag))
        CommonHelper:HButtonSetCallback("BoxBtn", item, function(hbtn)
            self:ClickBoxBtn(curActCount[index + 1])
        end, index)
    end)
    self.ScrollView = UIUtil.GetTypeChildWightByParent("MoreRowScrollViewClick_H", self.parentPref, typeof(MoreRowScrollView))
    CommonHelper:SetSlider("SliderBaseColor", self.parentPref, sliderNum / curActCount[#curActCount].countNo)
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #curActInfo, 1, function(index, itemObj, scroll)
        local _GroupData = curActInfo[index+1]
        local giftData = CommonHelper:GetTableDataByID(ConfigNames.act_gift_config, _GroupData.itemid)
        local giftAwards = stringSplit(giftData.awardids, ":")
        local giftAwardNums = stringSplit(giftData.awardnums, ":")
        CommonHelper:GetComponentSetUITexture("BGImage", itemObj, giftData.giftIcon .. ".png", UIModuleID.CommonFestivalTwo)
        for k, v in pairs(giftAwards) do
            local obj = UIUtil.GetChild("item_" .. k, itemObj)
            local param = Param_ItemArticleParam()
            param.count = tonumber(giftAwardNums[k])
            CommonHelper:SetItemComGroup(obj, UIModuleID.CommonFestivalTwo, tonumber(v), param, function(btnData)
                CommonHelper:ShowPartInfoByCfgId(tonumber(v), UIModuleID.CommonFestivalTwo)
            end, v)
            obj:SetActive(true)
        end

        local BtnGet = CommonHelper:HButtonSetCallback("BtnGet", itemObj, function(data)
            CommonHelper:ChargeMoneyByID(curActInfo[data.intData].itemid)
        end,index+1)
        local BtnChooseNum = CommonHelper:GetChargeCfgByAreaAndItemId(curActInfo[index+1].itemid)
        CommonHelper:SetText("###priceText", BtnGet.transform, BtnChooseNum.pricename)
        CommonHelper:SetBtnIsRmbOrToken(BtnGet,CommonHelper:GetChargeCfgByAreaAndItemId(curActInfo[index+1].itemid))
    end)
    for i = 1, 4 do

    end

    local actID = CommonFestivalDataManager:Get():GetActivityDataIDByType(CommonFestivalType.Cumulative)
    local t_beginTime, t_endTime = CommonFestivalDataManager:Get():GetActTime(actID)
    local starttime = CommonHelper:ConvertIntToDataTime(t_beginTime * 1000)
    local endtime = CommonHelper:ConvertIntToDataTime(t_endTime * 1000)
    CommonHelper:SetText("###time", self.parentPref,
            CommonHelper:GetTempStr_Default(TemplateStringID.FestivalTimeText,
                    starttime.Month, starttime.Day, starttime.Hour, starttime.Minute,
                    endtime.Month, endtime.Day, endtime.Hour, endtime.Minute))

    CommonHelper:SetText("###BoxSliderText", self.parentPref,
            CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalCumulativeSliderText))

end

function Page_CommonFestivalCumulativeView:ClickBoxBtn(_data)
    local flagData ={}
    for i, v in pairs(_data.awardIds) do
        table.insert(flagData,{ id = _data.awardIds[i], num = _data.awardNums[i] })
    end

    if _data.giftFlag == 1 then
        local actID = CommonFestivalDataManager:Get():GetActivityDataIDByType(CommonFestivalType.Cumulative)
        CommonFestivalSubSystem:Get():SendMsg_CountGift(actID, _data.countNo)
    elseif _data.giftFlag == 0 then
        CommonHelper:ShowRewardPopup(flagData, ClientDataManager:Get():GetTemplateString(TemplateStringID.RewardPreview))
    else
        CommonHelper:ShowRewardPopup(flagData, ClientDataManager:Get():GetTemplateString(TemplateStringID.RewardGeted))
    end

end
