---@class Page_PreferentialBag:Page_ActivityBase
Page_PreferentialBag = class("Page_PreferentialBag", Page_ActivityBase)
function Page_PreferentialBag:initialize()

end
local _SelectTog = -1
local Data = nil
local itemList = nil
function Page_PreferentialBag:InitViewInfo(parent, activityType, msg, isreset)
    Page_ActivityBase:InitViewInfo(parent, activityType, msg)
    self:SetData(msg)
    if _SelectTog == -1 then
        _SelectTog = ChargeType.DayGift
        itemList = UIUtil.GetTypeChildWightByParent("ScrollView", self.parent, typeof(MoreRowScrollView))
        self.TogDay = CommonHelper:HButtonSetCallback("ToggleDay", self.parent, function(data)
            self:TogClick(ChargeType.DayGift)
        end)
        self.ToggleWeek = CommonHelper:HButtonSetCallback("ToggleWeek", self.parent, function(data)
            self:TogClick(ChargeType.WeekGift)
        end)
        self.ToggleMonth = CommonHelper:HButtonSetCallback("ToggleMonth", self.parent, function(data)
            self:TogClick(ChargeType.MonthGift)
        end)
        self:TogClick(_SelectTog, true)
    else
        self:SetView(false)
    end
end
function Page_PreferentialBag:TogClick(type, check)
    if check == nil then
        check = false
    end
    if _SelectTog ~= type or check then
        _SelectTog = type
        CommonHelper:SetToggleState(self.TogDay, _SelectTog == ChargeType.DayGift)
        CommonHelper:SetToggleState(self.ToggleWeek, _SelectTog == ChargeType.WeekGift)
        CommonHelper:SetToggleState(self.ToggleMonth, _SelectTog == ChargeType.MonthGift)
        self:SetView(true)
    end
end
---@ param msg SC_ActivityInfo
function Page_PreferentialBag:SetData(msg)
    Data = {}
    for i = 1, #msg.curActInfo do
        ---@type act_period_config_cell
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.act_gift_config, msg.curActInfo[i].itemid)
        local chargecfg = CommonHelper:GetChargeCfgByAreaAndItemId(msg.curActInfo[i].itemid)
        if Data[chargecfg.chargetype] == nil then
            Data[chargecfg.chargetype] = {}
        end
        table.insert(Data[chargecfg.chargetype], { Cfg = cfg, chargecfg = chargecfg, state = msg.curActInfo[i].buysum < cfg.buymax, limit = (cfg.buymax - msg.curActInfo[i].buysum) })--,BuyState=msg.curActInfo[i].buyState,CurDay=msg.curActInfo[i].curDay,GetState=msg.curActInfo[i].curGetState,DaySum=msg.curActInfo[i].daySum})
        if cfg.buymax==0 then
            self.Data[i].buyState=true
        end
    end
end

function Page_PreferentialBag:SetView(isrepet)
    CommonHelper:SetGameObjectActive("left", self.parent, #Data[_SelectTog] > 3)
    CommonHelper:SetGameObjectActive("right", self.parent, #Data[_SelectTog] > 3)
    self.LimitTimeList = {}
    if self.refreshTimeId ~= nil then
        TimerManager:Get():StopTimer(self.refreshTimeId)
        self.refreshTimeId = nil
    end
    local count = 0
    CommonHelper:InitMoreRowScrollView(itemList, #Data[_SelectTog], 1, function(dataIndex, itemObj, scroll)
        local data = Data[_SelectTog][dataIndex + 1]
        ---@type act_gift_config_cell
        local cfg = data.Cfg
        ---@type paylist_config_cell
        local payCfg = data.chargecfg
        local scrollView = UIUtil.GetTypeChildWightByParent("MoreRowScrollView_V", itemObj, typeof(MoreRowScrollView))
        local reward = {}
        local ids = stringSplitToNumber(cfg.awardids, ':')
        local nums = stringSplitToNumber(cfg.awardnums, ':')
        for i = 1, #ids do
            local rewarddata = RewardData()
            rewarddata:SetDataIdNum(ids[i], nums[i])
            table.insert(reward, rewarddata)
        end
        local rawImage = CommonHelper:GetComponentSetUITexture("bg1", itemObj, cfg.giftIcon .. ".png", UIModuleID.Activity)
        CommonHelper:InitMoreRowScrollView(scrollView, #reward, 1, function(index, item, scrollview)
            CommonHelper:SetPropGroupByRewardData(item, reward[index + 1], UIModuleID.Activity)
            CommonHelper:SetText("###count", item, CommonHelper:GetTempStr_Default(TemplateStringID.PreferentialBagCount, reward[index + 1].num))
            local propType, cfg = CommonHelper:GetPropTypeById(reward[index + 1].id)
            if propType == PropType.Part then
                CommonHelper:SetText("###name", item, CommonHelper:GetTempStr_Default(cfg.partname))
            else
                CommonHelper:SetText("###name", item, CommonHelper:GetTempStr_Default(cfg.name))
            end

        end)
        CommonHelper:SetGameObjectActive("notime", itemObj, cfg.begintime == 0)
        CommonHelper:SetGameObjectActive("time", itemObj, cfg.begintime ~= 0)

        CommonHelper:SetText("###topdesc", itemObj, CommonHelper:GetTempStr_Default(cfg.title))
        CommonHelper:SetText("###bottomdesc", itemObj, CommonHelper:GetTempStr_Default(cfg.reference))
        if cfg.begintime == 0 then
            local str = ""
            if data.limit == 0 and data.state then
                str = CommonHelper:GetTempStr_Default(TemplateStringID.ForeverBuyInfinite)
                CommonHelper:SetText("###limit", itemObj, str)
            elseif data.limit == 0 and not data.state then
                str = CommonHelper:GetTempStr_Default(TemplateStringID.ForeverBuyDone)
                CommonHelper:SetText("###limit", itemObj, str)
            elseif data.limit >= 999 then
                str = CommonHelper:GetTempStr_Default(TemplateStringID.ForeverBuyInfinite)
                CommonHelper:SetText("###limit", itemObj, str)
            else
                str = CommonHelper:GetTempStr_Default(TemplateStringID.ForeverBuyMore, data.limit)
                CommonHelper:SetText("###limit", itemObj, str)
            end

        else
            local time = cfg.endtime - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
            self:SetRefreshTimeTextHour(time, itemObj)
            --count=count+1
            --self.LimitTimeList[itemObj:GetInstanceID()]={time,itemObj}
        end
        --if cfg.buymax==1 then
        --    str=CommonHelper:GetTempStr_Default(TemplateStringID.ForeverBuyOne)
        --    CommonHelper:SetText("###limit",itemObj,str)
        --elseif cfg.buymax==0 then
        --    str=CommonHelper:GetTempStr_Default(TemplateStringID.ForeverBuyInfinite)
        --    CommonHelper:SetText("###limit",itemObj,str)
        --else

        -- end


        CommonHelper:SetText("###price", itemObj, payCfg.pricename)
        local BtnPay = CommonHelper:HButtonSetCallback("BtnPay", itemObj, function(btnData)
            local data = Data[_SelectTog][btnData.intData + 1].chargecfg
            CommonHelper:ChargeMoneyByID(data.itemid)
        end, dataIndex)

        CommonHelper:SetHButtonClick(BtnPay, data.state, true)
        self:SetBtnIsRmbOrToken(BtnPay,data.chargecfg)
    end, false, nil, isrepet)
    if count > 0 then
        self.refreshTimeId = TimerManager:Get():CreateTimerLoop(1, function(class)
            for k, v in pairs(class.LimitTimeList) do
                class:SetRefreshTimeTextHour(v[1], v[2])
                if v[1] > 0 then
                    v[1] = v[1] - 1
                end
            end

        end, self)
    end
end

function Page_PreferentialBag:SetRefreshTimeTextHour(time, parent)
    if time <= 0 then
        UINotify:Get():SendNotification(UINotifyEvent.ActivityView_RefreshChargeState)
    else
        local hour = math.modf(time / 60 / 60)
        local minute = math.modf((time - (hour * 60 * 60)) / 60)
        local second = math.fmod(time, 60)
        CommonHelper:SetText("###timelimit", parent, CommonHelper:GetTempStr_Default(TemplateStringID.TimeLimitBuy, hour))
    end
end
function Page_PreferentialBag:OnChangeBase()
    _SelectTog = -1
    Data = nil
end
function Page_PreferentialBag:OnBaseClose()
    _SelectTog = -1
    Data = nil
    if self.refreshTimeId ~= nil then
        TimerManager:Get():StopTimer(self.refreshTimeId)
        self.refreshTimeId = nil
    end
end