---@class Page_ReturnOldPlayerBoxView
Page_ReturnOldPlayerBoxView = class("Page_ReturnOldPlayerBoxView")

function Page_ReturnOldPlayerBoxView:initialize(parentPref)

    self.parentPref = parentPref
    self:SetBoxInObjData()
end

function Page_ReturnOldPlayerBoxView:SetBoxInObjData()
    self.BoxSVC = UIUtil.GetTypeChildWightByParent("BoxSVC", self.parentPref, typeof(MoreRowScrollView))

end

function Page_ReturnOldPlayerBoxView:RefreshBoxInInfo(msg)
    self.Data = {}

    for i = 1, #msg.curActInfo do
        ---@type act_period_config_cell
        local cfg = CommonHelper:GetTableDataByID(ConfigNames.act_gift_config, msg.curActInfo[i].itemid)
        local chargecfg = CommonHelper:GetChargeCfgByAreaAndItemId(msg.curActInfo[i].itemid)
        table.insert(self.Data, { Cfg = cfg, chargecfg = chargecfg, buyState = msg.curActInfo[i].buysum == 0 })--,BuyState=msg.curActInfo[i].buyState,CurDay=msg.curActInfo[i].curDay,GetState=msg.curActInfo[i].curGetState,DaySum=msg.curActInfo[i].daySum})
    end

    local temp = self.Data
    CommonHelper:InitMoreRowScrollView(self.BoxSVC, #temp, 1, function(dataIndex, itemObj, scroll)
        local data = temp[dataIndex + 1]
        ---@type act_gift_config_cell
        local cfg = data.Cfg
        ---@type paylist_config_cell
        local payCfg = data.chargecfg
        local scrollView = UIUtil.GetTypeChildWightByParent("ItemSVC", itemObj, typeof(MoreRowScrollView))
        local reward = {}
        local ids = stringSplitToNumber(cfg.awardids, ':')
        local nums = stringSplitToNumber(cfg.awardnums, ':')

        CommonHelper:GetComponentSetUITexture("bg1", itemObj, cfg.giftIcon .. ".png", UIModuleID.ReturnOldPlayer)

        CommonHelper:InitMoreRowScrollView(scrollView, #ids, 1, function(index, item, scrollview)

            local param = Param_ItemArticleParam()
            param.count = tonumber(nums[index + 1])
            CommonHelper:SetItemComGroup(item, UIModuleID.ReturnOldPlayer, tonumber(ids[index + 1]), param, function(btnData)
                CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.ReturnOldPlayer, false)
            end, ids[index + 1])

            local propType, cfg = CommonHelper:GetPropTypeById(ids[index + 1])
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

        CommonHelper:SetText("###priceText", itemObj, payCfg.pricename)
        local pay = CommonHelper:HButtonSetCallback("BtnPay", itemObj, function(btnData)
            local data = temp[btnData.intData + 1].chargecfg
            CommonHelper:ChargeMoneyByID(data.itemid)
        end, dataIndex)
        CommonHelper:SetBtnIsRmbOrToken(pay,payCfg)
    end)
end

