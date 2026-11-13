---@class Page_ActivityGrowthAwardMaxView
Page_ActivityGrowthAwardMaxView = class("Page_ActivityGrowthAwardMaxView", Page_ActivityBase)

function Page_ActivityGrowthAwardMaxView:initialize()

end

function Page_ActivityGrowthAwardMaxView:InitViewInfo(parent, activityType, msg, isreset)
    self.Root = parent
    self.activityType = activityType
    self:SetData(msg)
end

---@param msg SC_UserActGrowup
function Page_ActivityGrowthAwardMaxView:SetData(msg)
    self.ScrollView = UIUtil.GetTypeChildWightByParent("GrowthAwardScroll", self.Root, typeof(MoreRowScrollView))

    local cell = CommonHelper:GetTableDataByID(ConfigNames.act_activity_config, self.activityType)

    local BtnBuy= CommonHelper:HButtonSetCallback("BtnBuy", self.Root, function()
        CommonHelper:ChargeMoneyByID(cell.giftid)
    end)

    ---@type act_growup_config
    local MoneyNum = CommonHelper:GetChargeCfgByAreaAndItemId(tonumber(cell.giftid))
    self:SetBtnIsRmbOrToken(BtnBuy,MoneyNum)
    CommonHelper:SetText("BtnBuy/###priceText", self.Root, MoneyNum.pricename)
    CommonHelper:SetText("###titleTextLeft", self.Root, CommonHelper:GetTempStr_Default(TemplateStringID.GrowthAwardTitle_1))
    CommonHelper:SetText("multiplying/###text", self.Root, CommonHelper:GetTempStr_Default(TemplateStringID.GrowthAwardTitle_3))

    ---@type SC_ActGrowupGift
    CommonHelper:HButtonSetCallback("BtnAllGet", self.Root, function()
        --ActivitySubsystem:SendMsg_GrowthGiftUp(PlayerDataManager:Get():GetPlayerLV())
        ActivitySubsystem:SendMsg_ActLevelUp(0)
    end)

    self:SetScrollView(msg)

end

function Page_ActivityGrowthAwardMaxView:SetScrollView(msg)
    ---@type act_growup_config
    local act_growup_config = ClientDataManager:Get():GetDataTable(ConfigNames.act_growup_config)
    --local growthTabData = act_growup_config.GetAllData()
    local growthTabData = act_growup_config.GetAllDataByType(1)

    CommonHelper:SetText("###titleTextRight", self.Root, CommonHelper:GetTempStr_Default(TemplateStringID.GrowthAwardMaxTitle_2))

    local growthFreeData = msg.myActLevelup.curActGrowup

    CommonHelper:InitMoreRowScrollView(self.ScrollView, #growthFreeData, 1, function(index, itemObj, scroll)

        CommonHelper:SetText("###itemLV", itemObj, tostring(growthFreeData[index + 1].lev))
        -- -- --reward1
        local ItemFree = UIUtil.GetChild("ItemFree", itemObj)
        local param = Param_ItemArticleParam()
        param.count = growthTabData[index + 1].awardnums
        CommonHelper:SetItemComGroup(ItemFree, UIModuleID.Activity, tonumber(growthTabData[index + 1].awardids), param)

        -- -- --reward2
        local ItemMoney = UIUtil.GetChild("ItemMoney", itemObj)
        local param = Param_ItemArticleParam()
        param.count = growthTabData[index + 1].hawardnums
        CommonHelper:SetItemComGroup(ItemMoney, UIModuleID.Activity, tonumber(growthTabData[index + 1].hawardids), param)

        -- -- --state
        if PlayerDataManager:Get():GetPlayerLV() >= growthFreeData[index + 1].lev then

            CommonHelper:SetGameObjectActive("topgeted", itemObj, growthFreeData[index + 1].ifaward > 0)
            CommonHelper:SetGameObjectActive("bottomgeted", itemObj, growthFreeData[index + 1].ifaward > 1)

            CommonHelper:SetGameObjectActive("toplock", itemObj, growthFreeData[index + 1].curtype < 0)
            CommonHelper:SetGameObjectActive("bottomlock", itemObj, growthFreeData[index + 1].curtype < 1)

            if growthFreeData[index + 1].ifaward >= 2 then
                CommonHelper:SetGameObjectActive("toplock", itemObj, false)
                CommonHelper:SetGameObjectActive("bottomlock", itemObj, false)
            end

        else
            CommonHelper:SetGameObjectActive("toplock", itemObj, true)
            CommonHelper:SetGameObjectActive("bottomlock", itemObj, true)
            CommonHelper:SetGameObjectActive("topgeted", itemObj, false)
            CommonHelper:SetGameObjectActive("bottomgeted", itemObj, false)
        end


    end)
end

function Page_ActivityGrowthAwardMaxView:OnClose()

end