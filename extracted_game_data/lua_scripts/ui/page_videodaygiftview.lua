---@field GetUIModuleID fun(param:self):string
---@field gameObject  CS.UnityEngine.GameObject
---@class Page_VideoDayGiftView
Page_VideoDayGiftView = class("Page_VideoDayGiftView", Page_WelfareViewBase)

function Page_VideoDayGiftView:GetPageName()
    return "Page_VideoDayGiftView"
end

function Page_VideoDayGiftView:initialize()

end

function Page_VideoDayGiftView:OnAwake()
    self.DualOutputSVC = UIUtil.GetTypeChildWightInputPath("DualOutputSVC", self.gameObject, typeof(MoreRowScrollView))

    WelfareVideoDataManager:Get():InitDayGiftAwardData()
    WelfareVideoDataManager:Get():InitVideoDayGiftCumulative()
end

function Page_VideoDayGiftView:OnOpen()
    CommonHelper:GetComponentSetUITexture("BG", self.gameObject, "uitex_sucai_videodaygift_bg.png", UIModuleID.Welfare)
    self:InitView()

    self:SetLookBtnState(true)
end

function Page_VideoDayGiftView:RequestOpen()
    ----连续礼赠
    MonthSignSubsystem:Get():SendMsg_ReqDayVideo()
    WelfareVideoDataManager:Get():SetWelfareFuncID(WelfareFuncType.dayGift)

    self:SetLookBtnState(true)
end

function Page_VideoDayGiftView:InitView()
    local giftAwards = WelfareVideoDataManager:Get():GetDayGiftAwardData()

    for i, v in pairs(giftAwards) do
        local itemObj = UIUtil.GetChild("DayGiftItem_" .. i, self.gameObject)
        CommonHelper:GetComponentSetUITexture("BGImage", itemObj, "uitex_sucai_videodaygift_item_" .. i .. ".png", UIModuleID.Welfare)

        for j, k in pairs(v.propsids) do
            local obj = UIUtil.GetChild("item_" .. j, itemObj)
            local param = Param_ItemArticleParam()
            param.count = tonumber(v.propsnums[j])
            CommonHelper:SetItemComGroup(obj, UIModuleID.CommonFestivalTwo, tonumber(k), param, function(btnData)
                CommonHelper:ShowPartInfoByCfgId(tonumber(k), UIModuleID.Welfare)
            end, k)

            if tonumber(v.randvals[j]) > 0 then
                CommonHelper:SetText("###valText", obj, CommonHelper:GetTempStr_Default(TemplateStringID.WelfareVideoInevitable))
            else
                CommonHelper:SetText("###valText", obj, CommonHelper:GetTempStr_Default(TemplateStringID.WelfareVideoProbability))
            end

            obj:SetActive(true)
        end
    end

    self:RefreshView()
end

function Page_VideoDayGiftView:RefreshView()
    local giftState = WelfareVideoDataManager:Get():GetDayGiftStateData()
    for i, v in pairs(giftState) do
        local itemObj = UIUtil.GetChild("DayGiftItem_" .. i, self.gameObject)
        ------@type DayGiftData
        local maxWatch = v:GetMaxWatch()
        local watchNum = v:GetWatchNum()

        CommonHelper:SetText("BtnDayGiftLook/###text", itemObj, maxWatch - watchNum .. "/" .. maxWatch)
        CommonHelper:HButtonSetCallback("BtnDayGiftLook", itemObj, function(hbtn)
            if maxWatch - watchNum > 0 then
                self:SetLookBtnState(false)
                WelfareVideoDataManager:Get():CreateTimerID(WelfareFuncType.dayGift)
                WelfareVideoDataManager:Get():SetVideoDayGiftNumber(i)
                MaxSdkAds:Get():ShowRewardedAd()
            else
                CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.WelfareVideoRunOutOf))
            end

        end)
    end

    local curActCount = WelfareVideoDataManager:Get():GetVideoDayGiftCumulative() --累计登陆可领取礼包
    local BoxSlider = {}
    local sliderNum = WelfareVideoDataManager:Get():GetVideoDayGiftCumulativeCountNum()
    for i = 1, #curActCount do
        local num = math.modf((curActCount[i].countNo / curActCount[#curActCount].countNo) * 100)
        table.insert(BoxSlider, num * 0.01)
    end

    CommonHelper:SetBoxStateSlider("BoxSlider", self.parentPref, BoxSlider, function(item, index, BoxSlider)
        CommonHelper:SetBoxState("BoxState", item, tonumber(curActCount[index + 1].giftFlag))
        CommonHelper:HButtonSetCallback("BoxBtn", item, function(hbtn)
            self:ClickBoxBtn(curActCount[index + 1])
        end, index)
    end)

    CommonHelper:SetSlider("SliderBaseColor", self.parentPref, sliderNum / curActCount[#curActCount].countNo)

    self:SetLookBtnState(true)
end

function Page_VideoDayGiftView:ClickBoxBtn(_data)
    local flagData = {}
    for i, v in pairs(_data.awardIds) do
        table.insert(flagData, { id = _data.awardIds[i], num = _data.awardNums[i] })
    end

    if _data.giftFlag == 1 then
        MonthSignSubsystem:SendMsg_ReqDayVideoGift(_data.countNo)
    elseif _data.giftFlag == 0 then
        CommonHelper:ShowRewardPopup(flagData, ClientDataManager:Get():GetTemplateString(TemplateStringID.RewardPreview))
    else
        CommonHelper:ShowRewardPopup(flagData, ClientDataManager:Get():GetTemplateString(TemplateStringID.RewardGeted))
    end

end

function Page_VideoDayGiftView:SetLookBtnState(state)
    local giftState = WelfareVideoDataManager:Get():GetDayGiftStateData()
    for i, v in pairs(giftState) do
        local itemObj = UIUtil.GetChild("DayGiftItem_" .. i, self.gameObject)
        local btn = UIUtil.GetTypeChildWightInputPath("BtnDayGiftLook", itemObj, typeof(HButton))
        CommonHelper:SetHButtonEnable(btn, state)
    end
end

function Page_VideoDayGiftView:GetRedPointActive()
    return RedPointManager:Get():GetValue(RedPointID.S_VideoDayGift) or RedPointManager:Get():GetValue(RedPointID.S_VideoDayGiftSum)
end

function Page_VideoDayGiftView:OnClose()

end
