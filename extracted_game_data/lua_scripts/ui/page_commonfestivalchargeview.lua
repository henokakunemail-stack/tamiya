---@class Page_CommonFestivalChargeView
Page_CommonFestivalChargeView = class("Page_CommonFestivalChargeView")

function Page_CommonFestivalChargeView:initialize(parentPref)

    self.parentPref = parentPref
    self.finishGiftId=nil
end

function Page_CommonFestivalChargeView:RefreshChargeInfo(msg,finishGiftId)
    self.finishGiftId=finishGiftId
    self.ChargeSVC = UIUtil.GetTypeChildWightByParent("ChargeSVC", self.parentPref, typeof(MoreRowScrollView))
    local finishItem=UIUtil.GetChild("FinishItem",self.parentPref)
    CommonHelper:SetText("introduceText", self.parentPref, CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalChargeMessage))
    local _beginTime, _endTime = CommonFestivalDataManager:Get():GetActTime(msg.actId)
    local starttime = CommonHelper:ConvertIntToDataTime(_beginTime * 1000)
    local endtime = CommonHelper:ConvertIntToDataTime(_endTime * 1000)
    CommonHelper:SetText("time/###time", self.parentPref,
            CommonHelper:GetTempStr_Default(TemplateStringID.FestivalTimeText,
                    starttime.Month, starttime.Day, starttime.Hour, starttime.Minute,
                    endtime.Month, endtime.Day, endtime.Hour, endtime.Minute))

    ---@type SC_ActDayGift
    local UpdateFunc = function(dataIndex, itemObj, scroll)



        if dataIndex < 5 then
            local obj = UIUtil.GetChild("ItemCom_118", itemObj)

            CommonHelper:SetGameObjectActive("###buyStateText_2", itemObj, false)
            CommonHelper:SetGameObjectActive("###buyStateText", itemObj, false)
            local giftData = CommonHelper:GetTableDataByID(ConfigNames.act_gift_config, msg.buyItems[dataIndex + 1])
            local param = Param_ItemArticleParam()
            param.count = giftData.awardnums
            CommonHelper:SetItemComGroup(obj, UIModuleID.CommonFestival, tonumber(giftData.awardids), param, function(btnData)
                CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.CommonFestival, false)
            end, tonumber(giftData.awardids))

            local giftPrice = CommonHelper:GetChargeCfgByAreaAndItemId(msg.buyItems[dataIndex + 1])
            CommonHelper:SetText("BtnCharge/###priceText", itemObj, tostring(giftPrice.pricename))

            CommonHelper:SetGameObjectActive("notOpen", itemObj, msg.actBuyFlag[dataIndex + 1] == 0)

            CommonHelper:GetComponentSetImage("residueImg", itemObj, "commonfestival_icon_3_dt", UIModuleID.CommonFestival)
            local _beginTime, _endTime = CommonFestivalDataManager:Get():GetActTime(msg.actId)
            local _month, _day = self:GetDataTimeIndex(_beginTime, dataIndex)
            CommonHelper:SetText("residueImg/###residueText", itemObj,
                    string.format(CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalChargeTitle), _month, _day))
            CommonHelper:SetText("notOpen/###residueText2", itemObj,
                    string.format(CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalChargeTitle), _month, _day))

            CommonHelper:SetText("###notOpenText", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalChargeNotOpen))
            CommonHelper:SetText("###buyStateText", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalChargeBought))

            CommonHelper:SetGameObjectActive("###buyStateText", itemObj, msg.actBuyFlag[dataIndex + 1] == 2)
            CommonHelper:SetGameObjectActive("BtnCharge", itemObj, msg.actBuyFlag[dataIndex + 1] ~= 2)
            CommonHelper:SetGameObjectActive("###notOpenText", itemObj, msg.actBuyFlag[dataIndex + 1] == 0)
            local BtnCharge= CommonHelper:HButtonSetCallback("BtnCharge", itemObj, function(data)
                if msg.actBuyFlag[dataIndex + 1] == 0 then
                    CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.CommonFestivalChargeNotOpenTips))
                else
                    CommonHelper:ChargeMoneyByID(msg.buyItems[dataIndex + 1])
                end
            end)
            CommonHelper:SetBtnIsRmbOrToken(BtnCharge,CommonHelper:GetChargeCfgByAreaAndItemId(msg.buyItems[dataIndex + 1]))

        else
            CommonHelper:CSGameObjectSetActive(itemObj,false)
            itemObj=finishItem
            local obj = UIUtil.GetChild("ItemCom_118", itemObj)

            CommonHelper:SetGameObjectActive("###buyStateText_2", itemObj, false)
            CommonHelper:SetGameObjectActive("###buyStateText", itemObj, false)
            local lastData = CommonHelper:GetTableDataByID(ConfigNames.act_bussiness_config, msg.actId)
            local finishgift = stringSplit(lastData.finishgift, ':')

            local param = Param_ItemArticleParam()
            param.count = finishgift[2]
            CommonHelper:SetItemComGroup(obj, UIModuleID.CommonFestival, tonumber(self.finishGiftId), param, function(btnData)
                CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.CommonFestival, false)
            end, tonumber(self.finishGiftId))

            CommonHelper:SetText("residueImg/###residueText", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalChargeTitleBig))
            CommonHelper:SetText("notOpen/###residueText2", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalChargeTitleBig))
            CommonHelper:GetComponentSetImage("residueImg", itemObj, "commonfestival_icon_2_dt", UIModuleID.CommonFestival)

            CommonHelper:SetGameObjectActive("BtnCharge", itemObj, msg.finishGift == 1)
            CommonHelper:SetGameObjectActive("BtnCharge/###priceText", itemObj, true)
            CommonHelper:SetGameObjectActive("BtnCharge/moneycost", itemObj, true)
            CommonHelper:SetText("BtnCharge/###priceText", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalChargeGetGift))

            if msg.finishGift == 2 then
                CommonHelper:SetGameObjectActive("notOpen", itemObj, false)
                CommonHelper:SetText("###buyStateText_2", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.ChapterBoxHaveGet))
            else
                CommonHelper:SetGameObjectActive("notOpen", itemObj, true)
                CommonHelper:SetText("###buyStateText_2", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalChargeAllBought))
            end
            --CommonHelper:SetGameObjectActive("notOpen", itemObj, msg.actBuyFlag[dataIndex + 1] == 0)
            --CommonHelper:SetGameObjectActive("notOpen", itemObj, false)
            CommonHelper:SetGameObjectActive("###notOpenText", itemObj, false)

            CommonHelper:SetGameObjectActive("###buyStateText_2", itemObj, msg.finishGift ~= 1)

            CommonHelper:HButtonSetCallback("BtnCharge", itemObj, function(data)
                if msg.actBuyFlag[dataIndex + 1] == 0 then
                    CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.CommonFestivalChargeNotOpenTips))
                else
                    --print("259, --请求活动日礼包最终奖励 P2=活动id---", msg.actId)
                    CommonFestivalSubSystem:Get():SendMsg_ActDayFinish(msg.actId)
                end
            end)

            self.lastItemObj = itemObj
        end
    end

    CommonHelper:InitMoreRowScrollView(self.ChargeSVC, 6, 1, UpdateFunc)
end

function Page_CommonFestivalChargeView:SetLastItemObjState(finishGift)
    CommonHelper:SetGameObjectActive("BtnCharge", self.lastItemObj, finishGift == 1)
    CommonHelper:SetGameObjectActive("###buyStateText_2", self.lastItemObj, finishGift ~= 1)

    CommonHelper:SetText("###buyStateText_2", self.lastItemObj, CommonHelper:GetTempStr_Default(TemplateStringID.ChapterBoxHaveGet))
end

function Page_CommonFestivalChargeView:GetDataTimeIndex(_beginTime, dataIndex)
    local month = CommonHelper:ConvertIntToDataTime(_beginTime * 1000).Month
    local nextMonth = CommonHelper:ConvertIntToDataTime(_beginTime * 1000 + 86400000 * dataIndex).Month
    if (nextMonth - month) > 0 then
        month = month + 1
    end
    local day = CommonHelper:ConvertIntToDataTime(_beginTime*1000 + 86400000 * dataIndex).Day
    return month, day
end