---
---@field GetUIModuleID fun(param:self):string
---@field gameObject  CS.UnityEngine.GameObject
---@class Page_PhysicalPowerView
Page_PhysicalPowerView = class("Page_PhysicalPowerView", Page_WelfareViewBase)

function Page_PhysicalPowerView:initialize()

end

function Page_PhysicalPowerView:GetPageName()
    return "Page_PhysicalPowerView"
end

function Page_PhysicalPowerView:OnAwake()
    self.physicalPower1 = UIUtil.GetChild("PhysicalPower_1", self.gameObject)
    self.physicalPower2 = UIUtil.GetChild("PhysicalPower_2", self.gameObject)
    self.itemArticle1 = UIUtil.GetChild("ItemArticle_202", self.physicalPower1)
    self.itemArticle2 = UIUtil.GetChild("ItemArticle_202", self.physicalPower2)
    local PowerArticleCfgID = tonumber(CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.PowerArticleCfgID).varval)
    self.ReceiveBtn1 = CommonHelper:HButtonSetCallback("ReceiveBtn", self.physicalPower1, function()
        FreePhysicalPowerSubsystem:Get():SendMsg_GetPhysicalPower(0, 0)
    end)
    self.AlreadyReceived1 = UIUtil.GetChild("AlreadyReceived", self.physicalPower1)

    self.Ready1 = UIUtil.GetChild("Ready", self.physicalPower1)
    self.ReplacementBtn1 = CommonHelper:HButtonSetCallback("ReplacementBtn", self.physicalPower1, function()
        local cfgCost = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.FreePowerReplacementCost)
        local cost = tonumber(cfgCost.varval)
        local playerDiamond = PlayerDataManager:Get():GetCurrency(CurrencyType.Diamond)
        if cost > playerDiamond then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RetroactiveMonthSignCostNotEnough))
        else
            if cost == 0 then
                FreePhysicalPowerSubsystem:Get():SendMsg_GetPhysicalPower(0, 1)
            else
                local boxFunc = function()
                    local str = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.RetroactiveMonthSignCostTip), cost)
                    local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, str)
                    if ret == MessageBoxHelp.BtnType.OK then
                        FreePhysicalPowerSubsystem:Get():SendMsg_GetPhysicalPower(0, 1)
                    end
                end
                MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
            end
        end
    end)
    self.TipBtn1 = CommonHelper:HButtonSetCallback("TipBtn", self.physicalPower1, function()
        UIManager:Get():OpenPopup("ArticleInfoView", CanvasType.TopCanvas, "ArticleInfoView", true)
        UINotify:Get():SendNotification(UINotifyEvent.ArticleInfoView_SetDataByCfg, { PowerArticleCfgID, UIModuleID.Welfare })
    end)
    self.Ready2 = UIUtil.GetChild("Ready", self.physicalPower2)
    self.ReceiveBtn2 = CommonHelper:HButtonSetCallback("ReceiveBtn", self.physicalPower2, function()
        FreePhysicalPowerSubsystem:Get():SendMsg_GetPhysicalPower(1, 0)
    end)
    self.AlreadyReceived2 = UIUtil.GetChild("AlreadyReceived", self.physicalPower2)
    ----这个应该用不到
    self.ReplacementBtn2 = CommonHelper:HButtonSetCallback("ReplacementBtn", self.physicalPower2, function()
        local cfgCost = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.FreePowerReplacementCost)
        local cost = tonumber(cfgCost.varval)
        local playerDiamond = PlayerDataManager:Get():GetCurrency(CurrencyType.Diamond)
        if cost > playerDiamond then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RetroactiveMonthSignCostNotEnough))
        else
            if cost == 0 then
                FreePhysicalPowerSubsystem:Get():SendMsg_GetPhysicalPower(1, 1)
            else
                local boxFunc = function()
                    local str = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.RetroactiveMonthSignCostTip), cost)
                    local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, str)
                    if ret == MessageBoxHelp.BtnType.OK then
                        FreePhysicalPowerSubsystem:Get():SendMsg_GetPhysicalPower(1, 1)
                    end
                end
                MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
            end
        end
    end)

    self.TipBtn2 = CommonHelper:HButtonSetCallback("TipBtn", self.physicalPower2, function()
        UIManager:Get():OpenPopup("ArticleInfoView", CanvasType.TopCanvas, "ArticleInfoView", true)
        UINotify:Get():SendNotification(UINotifyEvent.ArticleInfoView_SetDataByCfg, { PowerArticleCfgID, UIModuleID.Welfare })
    end)
    ---@type dictpowergift_config_cell
    local cfgData1 = CommonHelper:GetTableDataByID(ConfigNames.dictpowergift_config, 0)
    ---@type dictpowergift_config_cell
    local cfgData2 = CommonHelper:GetTableDataByID(ConfigNames.dictpowergift_config, 1)
    CommonHelper:SetText("###count", self.physicalPower1, "x" .. cfgData1.powernum)
    CommonHelper:SetText("###count", self.physicalPower2, "x" .. cfgData2.powernum)
    local serverTime = CommonHelper:GetNowTime()
    local begin1 = stringSplit(cfgData1.begintime, ":")
    local end1 = stringSplit(cfgData1.endtime, ":")
    local begin2 = stringSplit(cfgData2.begintime, ":")
    local end2 = stringSplit(cfgData2.endtime, ":")
    local beginTime1 = CommonHelper:UnixTimeConvertTime(CommonHelper:ConvertParamToInt(serverTime.Year, serverTime.Month, serverTime.Day, tonumber(begin1[1]), tonumber(begin1[2]), 0))
    local endTime1 = CommonHelper:UnixTimeConvertTime(CommonHelper:ConvertParamToInt(serverTime.Year, serverTime.Month, serverTime.Day, tonumber(end1[1]), tonumber(end1[2]), 0))
    local beginTime2 = CommonHelper:UnixTimeConvertTime(CommonHelper:ConvertParamToInt(serverTime.Year, serverTime.Month, serverTime.Day, tonumber(begin2[1]), tonumber(begin2[2]), 0))
    local endTime2 = CommonHelper:UnixTimeConvertTime(CommonHelper:ConvertParamToInt(serverTime.Year, serverTime.Month, serverTime.Day, tonumber(end2[1]), tonumber(end2[2]), 0))

    CommonHelper:SetText("###subTime", self.physicalPower1,cfgData1.showTime1 )
    CommonHelper:SetText("###subTime", self.physicalPower2,cfgData2.showTime1 )
    --if currencycfg == nil then
    --    CommonHelper:GetComponentSetUITexture("icon", self.physicalPower1,"uitex_sucai_default.png", UIModuleID.Welfare)
    --    CommonHelper:GetComponentSetUITexture("icon", self.physicalPower2,"uitex_sucai_default.png", UIModuleID.Welfare)
    --else
    --    CommonHelper:GetComponentSetUITexture("icon", self.physicalPower1,currencycfg.icon..".png", UIModuleID.Welfare)
    --    CommonHelper:GetComponentSetUITexture("icon", self.physicalPower2,currencycfg.icon..".png", UIModuleID.Welfare)
    --end


end

function Page_PhysicalPowerView:OnOpen()
    self:RefreshState()
    self:RefreshView()

end

function Page_PhysicalPowerView:RequestOpen()
    UINotify:Get():SendNotification(UINotifyEvent.WelfareVideoOpenPage, WelfareFuncType.physical)
    UINotify:Get():SendNotification(UINotifyEvent.WelfareVideo_PageRunAction, { WelfareFuncType.physical, "RefreshView" })
end

function Page_PhysicalPowerView:RefreshState()
    self:TimeCalculate()
    self:UpdateTimeState()
    self:CheckTimeState()
end
function Page_PhysicalPowerView:CheckTimeState()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
    end
    self.TimeId = TimerManager:Get():CreateTimerLoop(1, function(class)
        self:TimeCalculate()
        self:UpdateTimeState()
    end)
end


function Page_PhysicalPowerView:RefreshView()
    local isAlreadyRemoved1 = PlayerDataManager:Get():IsAlreadyRemovedFreePhysicalPower(1)
    local isAlreadyRemoved2 = PlayerDataManager:Get():IsAlreadyRemovedFreePhysicalPower(2)
    CommonHelper:CSGameObjectSetActive(self.Ready1, self.timeState == 0)
    CommonHelper:CSGameObjectSetActive(self.ReceiveBtn1.gameObject, self.timeState == 1 and (not isAlreadyRemoved1))
    CommonHelper:CSGameObjectSetActive(self.AlreadyReceived1, self.timeState > 0 and isAlreadyRemoved1)
    CommonHelper:CSGameObjectSetActive(self.ReplacementBtn1.gameObject, self.timeState > 1 and (not isAlreadyRemoved1))
    CommonHelper:CSGameObjectSetActive(self.Redpoint1)
    CommonHelper:CSGameObjectSetActive(self.Ready2, self.timeState < 3)
    CommonHelper:CSGameObjectSetActive(self.ReceiveBtn2.gameObject, self.timeState == 3 and (not isAlreadyRemoved2))
    CommonHelper:CSGameObjectSetActive(self.AlreadyReceived2, self.timeState > 2 and isAlreadyRemoved2)
    CommonHelper:CSGameObjectSetActive(self.ReplacementBtn2.gameObject, self.timeState > 3 and (not isAlreadyRemoved2))
    if (self.timeState == 1 and (not isAlreadyRemoved1)) or (self.timeState == 3 and (not isAlreadyRemoved2)) then
        RedPointManager:Get():UpdateValue(RedPointID.S_FreePower, true)
    else
        RedPointManager:Get():UpdateValue(RedPointID.S_FreePower, false)
    end
end

function Page_PhysicalPowerView:TimeCalculate()
    ---@type dictpowergift_config_cell
    local cfgData1 = CommonHelper:GetTableDataByID(ConfigNames.dictpowergift_config, 0)
    ---@type dictpowergift_config_cell
    local cfgData2 = CommonHelper:GetTableDataByID(ConfigNames.dictpowergift_config, 1)
    local datetime = CommonHelper:GetNowTime()  --CommonHelper:ConvertDateTimeToInt()
    local begin1 = stringSplit(cfgData1.begintime, ":")
    local end1 = stringSplit(cfgData1.endtime, ":")
    local begin2 = stringSplit(cfgData2.begintime, ":")
    local end2 = stringSplit(cfgData2.endtime, ":")
    local beginHour1 = tonumber(begin1[1])
    local beginMinute1 = tonumber(begin1[2])
    local beginSecond1 = tonumber(begin1[3])
    local endHour1 = tonumber(end1[1])
    local endMinute1 = tonumber(end1[2])
    local endSecond1 = tonumber(end1[3])
    local beginHour2 = tonumber(begin2[1])
    local beginMinute2 = tonumber(begin2[2])
    local beginSecond2 = tonumber(begin2[3])
    local endHour2 = tonumber(end2[1])
    local endMinute2 = tonumber(end2[2])
    local endSecond2 = tonumber(end2[3])
    self.freeTimeBegin1 = CommonHelper:ConvertParamToInt(datetime.Year, datetime.Month, datetime.Day, beginHour1, beginMinute1, beginSecond1)
    self.freeTimeEnd1 = CommonHelper:ConvertParamToInt(datetime.Year, datetime.Month, datetime.Day, endHour1, endMinute1, endSecond1)
    self.freeTimeBegin2 = CommonHelper:ConvertParamToInt(datetime.Year, datetime.Month, datetime.Day, beginHour2, beginMinute2, beginSecond2)
    self.freeTimeEnd2 = CommonHelper:ConvertParamToInt(datetime.Year, datetime.Month, datetime.Day, endHour2, endMinute2, endSecond2)
    self.timeState = -1 ----0  freeTimeBegin1之前   1   freeTimeBegin1-freeTimeEnd1   2 freeTimeEnd1 - begin2  3 begin2 -end2  4 end2之后

end

function Page_PhysicalPowerView:UpdateTimeState()
    local now = math.floor(CommonHelper:ConvertNowTimeDouble())
    local beforeState = self.timeState
    if now < self.freeTimeBegin1 then
        self.timeState = 0
    elseif now < self.freeTimeEnd1 then
        self.timeState = 1
    elseif now < self.freeTimeBegin2 then
        self.timeState = 2
    elseif now < self.freeTimeEnd2 then
        self.timeState = 3
    else
        self.timeState = 4
    end
    if beforeState ~= self.timeState then
        self:RefreshView()
    end
end

function Page_PhysicalPowerView:GetRedPointActive()
    return RedPointManager:Get():GetValue(RedPointID.S_FreePower)
end

function Page_PhysicalPowerView:OnClose()
    if self.freeTimeCoroutine then
        cs_coroutine.stop(self.freeTimeCoroutine)
        self.freeTimeCoroutine = nil
    end
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
    end
end
