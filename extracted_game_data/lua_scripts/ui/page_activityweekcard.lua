---@class Page_ActivityWeekCardView
Page_ActivityWeekCardView = class("Page_ActivityWeekCardView", Page_ActivityBase)
function Page_ActivityWeekCardView:initialize()

end

function Page_ActivityWeekCardView:InitViewInfo(parent, activityType, msg,isreset)
    self.Root = parent
    self:SetData(msg,isreset)
end

---@param msg SC_ActivityInfo
function Page_ActivityWeekCardView:SetData(msg)
    local temp = {}
    local curActInfo = self:OnInitData(msg.curActInfo)

    for i = 1, #curActInfo do
        ---@type act_period_config_cell
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.act_period_config, curActInfo[i].itemid)
        local chargecfg = CommonHelper:GetChargeCfgByAreaAndItemId(curActInfo[i].itemid)
        table.insert(temp, { Cfg = cfg,
                             chargecfg = chargecfg,
                             BuyState = curActInfo[i].exptime ~= 0,
                             GetState = curActInfo[i].giftTime,
                             CurDay = math.ceil(((curActInfo[i].exptime - CommonHelper:ConvertNowTimeDouble()) / TimeSecond_Day))
        })
    end

    self.ScrollView = UIUtil.GetTypeChildWightByParent("ScrollView", self.Root, typeof(MoreRowScrollView))
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #temp, 1, function(index, itemObj, scroll)
        local Buy = CommonHelper:HButtonSetCallback("BtnBuy", itemObj, function(data)
            CommonHelper:ChargeMoneyByID(temp[data.intData + 1].chargecfg.itemid)
        end, index)
        self:SetBtnIsRmbOrToken(Buy,temp[index + 1].chargecfg)
        local Get = CommonHelper:HButtonSetCallback("BtnGet", itemObj, function(data)
            ActivitySubsystem:Get():SendMsg_GetWeekCardReward(temp[data.intData + 1].chargecfg.itemid)
        end, index)

        CommonHelper:GetComponentSetUITexture("icon", itemObj, temp[index + 1].Cfg.weekBg .. ".png", UIModuleID.Activity)
        CommonHelper:SetText("###priceText", Buy.gameObject, temp[index + 1].chargecfg.pricename)
        CommonHelper:SetText("###diamond", Get.gameObject, temp[index + 1].Cfg.awardnums)

        if temp[index + 1].BuyState then
            CommonHelper:SetText("###CanGetDay", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.ActivityWeekSubDay, temp[index + 1].CurDay))
        else
            CommonHelper:SetText("###CanGetDay", itemObj, "")
        end

        ---@type SC_UserPeriodGift
        CommonHelper:SetHButtonClick(Buy, not temp[index + 1].BuyState, true)
        CommonHelper:SetHButtonClick(Get, temp[index + 1].BuyState and temp[index + 1].GetState == 0, true)
        CommonHelper:SetGameObjectActive("BtnGeted", itemObj, temp[index + 1].BuyState and temp[index + 1].GetState == 1)

    end)
end

function Page_ActivityWeekCardView:OnInitData(_data)
    local curActInfo = {}
    if #_data > 2 then
        for i = 1, #_data do
            if i ~= 2 then
                table.insert(curActInfo, _data[i])
            end
        end
    else
        for i = 1, #_data do
            table.insert(curActInfo, _data[i])
        end
    end

    return curActInfo
end

function Page_ActivityWeekCardView:OnClose()

end


