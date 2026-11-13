---@class Page_ActivityRookiePackage:Page_ActivityBase
Page_ActivityRookiePackage = class("Page_ActivityRookiePackage", Page_ActivityBase)

function Page_ActivityRookiePackage:initialize()

end

function Page_ActivityRookiePackage:InitViewInfo(parent, activityType, msg,isreset)
    Page_ActivityBase:InitViewInfo(parent, activityType, msg)
    self.itemList = UIUtil.GetTypeChildWightByParent("ScrollView", self.parent, typeof(MoreRowScrollView))
    self:SetData(msg)
    self:SetView(isreset)
end

---@ param msg SC_ActivityInfo
function Page_ActivityRookiePackage:SetData(msg)
    self.Data = {}

    for i = 1, #msg.curActInfo do
        ---@type act_period_config_cell
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.act_gift_config, msg.curActInfo[i].itemid)
        local chargecfg = CommonHelper:GetChargeCfgByAreaAndItemId( msg.curActInfo[i].itemid)
        table.insert(self.Data, { Cfg = cfg, chargecfg = chargecfg, buyState = msg.curActInfo[i].buysum == 0 })--,BuyState=msg.curActInfo[i].buyState,CurDay=msg.curActInfo[i].curDay,GetState=msg.curActInfo[i].curGetState,DaySum=msg.curActInfo[i].daySum})
    end

end

function Page_ActivityRookiePackage:SetView(isreset)
    local temp = self.Data
    CommonHelper:SetGameObjectActive("left", self.parent, #temp > 3)
    CommonHelper:SetGameObjectActive("right", self.parent, #temp > 3)
    CommonHelper:InitMoreRowScrollView(self.itemList, #temp, 1, function(dataIndex, itemObj, scroll)
        local data = temp[dataIndex + 1]
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
        CommonHelper:GetComponentSetUITexture("bg1", itemObj, cfg.giftIcon .. ".png", UIModuleID.Activity)
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
        CommonHelper:SetGameObjectActive("notime", itemObj, cfg.timeType == 0)
        CommonHelper:SetGameObjectActive("time", itemObj, cfg.timeType == 1)

        CommonHelper:SetText("###topdesc", itemObj, CommonHelper:GetTempStr_Default(cfg.title))
        CommonHelper:SetText("###bottomdesc", itemObj, CommonHelper:GetTempStr_Default(cfg.reference))
        local str = ""
        if cfg.maxCount == 1 then
            str = CommonHelper:GetTempStr_Default(TemplateStringID.ForeverBuyOne)
            CommonHelper:SetText("###limit", itemObj, str)
        elseif cfg.maxCount == 0 then
            str = CommonHelper:GetTempStr_Default(TemplateStringID.ForeverBuyInfinite)
            CommonHelper:SetText("###limit", itemObj, str)
        else
            str = CommonHelper:GetTempStr_Default(TemplateStringID.ForeverBuyMore, cfg.maxCount)
            CommonHelper:SetText("###limit", itemObj, str)
        end

        CommonHelper:SetText("###price", itemObj, payCfg.pricename)
        local pay = CommonHelper:HButtonSetCallback("BtnPay", itemObj, function(btnData)
            local data = temp[btnData.intData + 1].chargecfg
            CommonHelper:ChargeMoneyByID(data.itemid)
        end, dataIndex)
        self:SetBtnIsRmbOrToken(pay,data.chargecfg)
        CommonHelper:SetHButtonClick(pay, data.buyState, true)
    end,false,nil,isreset)
end

function Page_ActivityRookiePackage:SetRefreshTimeTextHour(time, parent)
    local hour = math.modf(time / 60 / 60)
    local minute = math.modf((time - (hour * 60 * 60)) / 60)
    local second = math.fmod(time, 60)
    CommonHelper:SetText("###timelimit", parent, CommonHelper:GetTempStr_Default(TemplateStringID.TimeLimitBuy, hour, minute, second))
end

function Page_ActivityRookiePackage:OnBaseClose()

end