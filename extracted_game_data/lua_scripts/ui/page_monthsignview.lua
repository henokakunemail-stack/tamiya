---
---@field GetUIModuleID fun(param:self):string
---@field gameObject  CS.UnityEngine.GameObject
---@class Page_MonthSignInView
Page_MonthSignInView = class("Page_MonthSignInView", Page_WelfareViewBase)

function Page_MonthSignInView:initialize(parentPref)
    self.parentPref = parentPref
    self.ClickNum = 0
end

function Page_MonthSignInView:GetPageName()
    return "Page_MonthSignInView"
end

function Page_MonthSignInView:OnAwake()
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("ScrollView", self.parentPref, typeof(MoreRowScrollView))
    CommonHelper:HButtonSetCallback("MonthSignBtn", self.parentPref, function(data)
        local day = CommonHelper:GetNowTime().Day
        MonthSignSubsystem:Get():SendMsg_RetroactiveMonthSign(day, 0)
    end)

end

function Page_MonthSignInView:RequestOpen()
    MonthSignSubsystem:Get():SendMsg_GetMonthSignList()
end

function Page_MonthSignInView:RefreshMonthSignScrollView()
    if self.CountdownCoroutine == nil then
        self.CountdownCoroutine = cs_coroutine.start(function()
            local nextmonth = MonthSignManager:Get():GetCurMonth() + 1
            local nowTime = CommonHelper:GetNowTime()
            local nextYear = nowTime.Year
            if nextmonth > 12 then
                nextYear = nextYear + math.modf(nextmonth / 12)
                nextmonth = nextmonth % 12
            end
            local time = CommonHelper:ConvertParamToInt(nextYear, nextmonth, 1, 0, 0, 0)
            local nowTick = CommonHelper:ConvertNowTimeDouble()
            local subTick = time - nowTick
            local Day = math.abs(math.modf(subTick / TimeSecond_Day))
            local Hour = math.abs(math.modf((subTick - (Day * TimeSecond_Day)) / TimeSecond_Hour))
            local Minute = math.ceil((subTick - (Day * TimeSecond_Day) - (Hour * TimeSecond_Hour)) / TimeSecond_Minute)
            CommonHelper:SetText("###monthcountdown", self.parentPref, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.MonthSignCountdown), Day, Hour, Minute))
            coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
        end)
    end
    local day = CommonHelper:GetNowTime().Day
    self.ClickNum = day
    local monthSignInfo = MonthSignManager:Get():GetMonthSignInfoByIndex(day)
    CommonHelper:SetGameObjectActive("MonthSignBtn", self.parentPref, monthSignInfo.ifGet)
    if (monthSignInfo.ifGet) then
        RedPointManager:Get():UpdateValue(RedPointID.S_MonthSign, true)
    else
        RedPointManager:Get():UpdateValue(RedPointID.S_MonthSign, false)
    end
    CommonHelper:SetText("###MonthSignText", self.parentPref, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.MonthSignTip), MonthSignManager:Get():GetCurMonth()))
    local monthCardExp = MonthSignManager:Get():GetMonthCardExp()
    local monthCardOverDay = 0
    if monthCardExp > 0 then
        local nowTick = CommonHelper:ConvertNowTimeDouble()
        monthCardOverDay = math.modf((monthCardExp - nowTick) / TimeSecond_Day)
    end
    CommonHelper:SetText("###monthvalid", self.parentPref, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.MonthSignNum), monthCardOverDay))
    CommonHelper:SetText("###monthsignnum", self.parentPref, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.MonthSignNum), MonthSignManager:Get():GetMonthSignedNum()))
    CommonHelper:InitMoreRowScrollView(self.ScrollView, MonthSignManager:Get():GetMonthSignCount(), 8, function(dataIndex, itemObj, scroll)
        self:SetItem(dataIndex + 1, itemObj, scroll)
    end)

    self:RefreshRightMessage()
end

function Page_MonthSignInView:SetItem(dataIndex, itemObj, scroll)
    local signInfo = MonthSignManager:Get():GetMonthSignInfoByIndex(dataIndex)
    local curday = CommonHelper:GetNowTime().Day
    CommonHelper:SetGameObjectActive("HaveSign", itemObj, signInfo.receive)
    CommonHelper:SetGameObjectActive("DoubleSign", itemObj, signInfo.ifbat and curday <= signInfo.dayNum)
    CommonHelper:SetGameObjectActive("RedPoint", itemObj, curday == signInfo.dayNum and signInfo.ifGet)
    CommonHelper:SetGameObjectActive("RetroactiveSignBtn", itemObj, signInfo.ifRepair)
    CommonHelper:SetGameObjectActive("CanSignImg", itemObj, signInfo.receive)
    CommonHelper:SetGameObjectActive("DetailsBtn", itemObj, (not signInfo.ifGet) or curday == signInfo.dayNum)

    ---@type dictsignmonth_config
    local cfg = ClientDataManager:Get():GetDataTable(ConfigNames.dictsignmonth_config)
    ---@type dictsignmonth_config_cell
    local cfgData = cfg.GetConfigDataByMonthDay(MonthSignManager:Get():GetCurMonth(), signInfo.dayNum)
    if cfgData == nil then
        logError("  月签到表格没有配  ")
        return
    end

    CommonHelper:HButtonSetCallback("RetroactiveSignBtn", itemObj, function(data)
        self:RefreshRightSignMessage(signInfo.dayNum, signInfo.ifRepair)
    end)

    CommonHelper:HButtonSetCallback("DetailsBtn", itemObj, function(data)
        self:RefreshMonthSignScrollView()
        self:RefreshRightSignMessage(signInfo.dayNum, signInfo.ifRepair)
    end)

    CommonHelper:SetGameObjectActive("ClickBG", itemObj, self.ClickNum == dataIndex)

    if signInfo.dayNum > 9 then
        CommonHelper:SetText("###DayText", itemObj, signInfo.dayNum)
    else
        CommonHelper:SetText("###DayText", itemObj, "0" .. signInfo.dayNum)
    end
    local param = Param_ItemArticleParam()
    param.count = cfgData.propsnum
    local item = UIUtil.GetChild("ItemCom_138", itemObj)
    CommonHelper:SetItemComGroup(item, UIModuleID.Welfare, cfgData.propsid, param)
end

function Page_MonthSignInView:RefreshRightMessage()
    local nowTime = CS.ServerTime:Get():ServerTimeNow()
    CommonHelper:SetText("###yearmonth", self.parentPref,
            string.format(CommonHelper:GetTempStr_Default(TemplateStringID.YearAndMonth, nowTime.Year, nowTime.Month)))
    CommonHelper:SetText("###week", self.gameObject, CommonHelper:GetWeekString(nowTime.DayOfWeek.value__))
    CommonHelper:SetText("###Day", self.parentPref, nowTime.Day)

    self:RefreshRightSignMessage(nowTime.Day, false)
end

function Page_MonthSignInView:RefreshRightSignMessage(DayNum, ifRepair)
    ---@type dictsignmonth_config
    local cfg = ClientDataManager:Get():GetDataTable(ConfigNames.dictsignmonth_config)
    local signInfo = MonthSignManager:Get():GetMonthSignInfoByIndex(DayNum)
    ---@type dictsignmonth_config_cell
    local cfgData = cfg.GetConfigDataByMonthDay(MonthSignManager:Get():GetCurMonth(), signInfo.dayNum)
    if cfgData == nil then
        logError("  月签到表格没有配  ")
        return
    end
    local BigItem = UIUtil.GetChild("ItemCom_220", self.parentPref)
    local param = Param_ItemArticleParam()
    param.count = cfgData.propsnum
    CommonHelper:SetItemComGroup(BigItem, UIModuleID.Welfare, cfgData.propsid, param)

    local propType, cfg = CommonHelper:GetPropTypeById(cfgData.propsid)
    CommonHelper:SetText("###bigItemText", self.parentPref, CommonHelper:GetTempStr_Default(cfg.name))

    local monthSignInfo = MonthSignManager:Get():GetMonthSignInfoByIndex(DayNum)
    CommonHelper:SetGameObjectActive("MonthSignBtn", self.parentPref, monthSignInfo.ifGet and DayNum == CS.ServerTime:Get():ServerTimeNow().Day)
    CommonHelper:SetGameObjectActive("BtnRecover", self.parentPref, ifRepair and DayNum < CS.ServerTime:Get():ServerTimeNow().Day)

    CommonHelper:HButtonSetCallback("BtnRecover", self.parentPref, function(data)
        local retroactiveMonthSign = PlayerDataManager:Get():GetRetroactiveMonthSign() + 1
        local cfgCost = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.MonthSignReplacementCost)
        local list = stringSplitToNumber(cfgCost.varval, ':')
        local playerDiamond = PlayerDataManager:Get():GetCurrency(CurrencyType.Diamond)
        if retroactiveMonthSign > #list then
            retroactiveMonthSign = #list
        end
        if list[retroactiveMonthSign] > playerDiamond then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RetroactiveMonthSignCostNotEnough))
        else
            local str = ""
            if list[retroactiveMonthSign] == 0 then
                local signedNum = MonthSignManager:Get():GetMonthSign() - PlayerDataManager:Get():GetRetroactiveMonthSign()
                str = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.RetroactiveMonthSignFreeTip), signedNum)
            else
                str = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.RetroactiveMonthSignCostTip), list[retroactiveMonthSign])
            end

            local boxFunc = function()
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, str)
                if ret == MessageBoxHelp.BtnType.OK then
                    MonthSignSubsystem:Get():SendMsg_RetroactiveMonthSign(signInfo.dayNum, 1)
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
        end

    end)
end

function Page_MonthSignInView:GetRedPointActive()
    return RedPointManager:Get():GetValue(RedPointID.S_MonthSign)
end

function Page_MonthSignInView:OnClose()
    self.ClickNum = 0

    if self.CountdownCoroutine then
        cs_coroutine.stop(self.CountdownCoroutine)
        self.CountdownCoroutine = nil
    end
end