---@class Page_CommonFestivalSignInView
Page_CommonFestivalSignInView = class("Page_CommonFestivalSignInView")

function Page_CommonFestivalSignInView:initialize(parentPref)

    self.parentPref = parentPref
    self:SetSignInObjData()
    self.TogGroup = {}
    self.actID = 0
end

function Page_CommonFestivalSignInView:SetSignInObjData()
    self.togDayItem = {}

    for i = 1, 7 do
        local dayObj = UIUtil.GetChild("CommonFestival_obj_" .. i, self.parentPref)
        table.insert(self.togDayItem, dayObj)
    end

end

function Page_CommonFestivalSignInView:RefreshSignInInfo(sign)
    ---@type act_day_sign_config
    local act_day_sign_config = ClientDataManager:Get():GetDataTable(ConfigNames.act_day_sign_config)

    local _beginTime, _endTime = CommonFestivalDataManager:Get():GetActTime(sign.actId)
    local starttime = CommonHelper:ConvertIntToDataTime(_beginTime * 1000)
    local endtime = CommonHelper:ConvertIntToDataTime(_endTime * 1000)
    CommonHelper:SetText("time/###time", self.parentPref,
            CommonHelper:GetTempStr_Default(TemplateStringID.FestivalTimeText,
                    starttime.Month, starttime.Day, starttime.Hour, starttime.Minute,
                    endtime.Month, endtime.Day, endtime.Hour, endtime.Minute))

    for i = 1, #self.togDayItem do
        CommonHelper:SetText("###dayNum", self.togDayItem[i].gameObject,
                string.format(CommonHelper:GetTempStr_Default(TemplateStringID.CommonSignInTitleTheDay), tostring(i)))
        CommonHelper:SetTextColorByName("###dayNum", self.togDayItem[i].gameObject, sign.nowday == i and "338248" or "764e3b")

        CommonHelper:SetGameObjectActive("BtnRetroactive", self.togDayItem[i].gameObject, sign.nowday > i and sign.actSigns[i] == 0)
        CommonHelper:SetGameObjectActive("BtnSign", self.togDayItem[i].gameObject, sign.nowday == i and sign.actSigns[i] == 0)
        CommonHelper:SetGameObjectActive("today", self.togDayItem[i].gameObject, sign.nowday == i and sign.actSigns[i] == 0)
        CommonHelper:SetGameObjectActive("signed", self.togDayItem[i].gameObject, sign.actSigns[i] == 2)

        local awardData = act_day_sign_config.GetDayDataById(sign.actId, i)
        local _type, _data = CommonHelper:GetPropTypeById(tonumber(awardData[1]))

        local _iconImg = _type == PropType.Part and _data.icon or _data.icon .. ".png"
        local _iconName = _type == PropType.Part and _data.partname or _data.name

        CommonHelper:GetComponentSetUITexture("###iconImg", self.togDayItem[i].gameObject, _iconImg, UIModuleID.CommonFestival)
        CommonHelper:SetText("###iconImg/###iconNum", self.togDayItem[i].gameObject, CommonHelper:GetTempStr_Default(_iconName) .. "*" .. awardData[2], UIModuleID.CommonFestival)

        CommonHelper:HButtonSetCallback("BtnSign", self.togDayItem[i].gameObject, function(data)
            CommonFestivalSubSystem:Get():SendMsg_SignNow(sign.actId, i, 0)
        end, i)

        CommonHelper:HButtonSetCallback("BtnRetroactive", self.togDayItem[i].gameObject, function(data)
            UIManager:Get():OpenPopup("CommonFestivalTipsView", CanvasType.FrontCanvas, "CommonFestivalTipsView", true)
            UINotify:Get():SendNotification(UINotifyEvent.CommonFestival_RefreshTips, { sign.actId, i, 1 })
        end, i)

        if i ~= 7 then
            CommonHelper:SetText("###dayNum", self.togDayItem[i].gameObject,
                    string.format(CommonHelper:GetTempStr_Default(TemplateStringID.CommonSignInTitleTheDay), tostring(i)))
            CommonHelper:SetTextColorByName("###dayNum", self.togDayItem[i].gameObject, sign.nowday == i and "ffff7f" or "FF9900")
            CommonHelper:SetGameObjectActive("BtnRetroactive", self.togDayItem[i].gameObject, sign.nowday > i and sign.actSigns[i] == 0)
            CommonHelper:SetGameObjectActive("BtnSign", self.togDayItem[i].gameObject, sign.nowday == i and sign.actSigns[i] == 0)
            CommonHelper:SetGameObjectActive("signed", self.togDayItem[i].gameObject, sign.actSigns[i] == 2)

            CommonHelper:HButtonSetCallback("BtnSign", self.togDayItem[i].gameObject, function(data)
                CommonFestivalSubSystem:Get():SendMsg_SignNow(sign.actId, i, 0)
            end)

            CommonHelper:HButtonSetCallback("BtnRetroactive", self.togDayItem[i].gameObject, function(data)
                UIManager:Get():OpenPopup("CommonFestivalTipsView", CanvasType.FrontCanvas, "CommonFestivalTipsView", true)
                UINotify:Get():SendNotification(UINotifyEvent.CommonFestival_RefreshTips, { sign.actId, i, 1 })
            end)

        end

    end
end



