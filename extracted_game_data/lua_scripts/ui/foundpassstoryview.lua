---@class FoundPassStoryView : ViewBase
FoundPassStoryView = class("FoundPassStoryView", ViewBase)
function FoundPassStoryView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "FoundPassStoryViewAction")
end

function FoundPassStoryView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function(data)
        UINotify:Get():SendNotification(UINotifyEvent.FoundPassToggleView_CloseView)
    end)
    CommonHelper:HButtonSetCallback("BtnClose2",self.gameObject,function(data)
        UINotify:Get():SendNotification(UINotifyEvent.FoundPassToggleView_CloseView)
    end)
    self.activityList = self:GetChildWightByParent("InfoBaseScroll", self.gameObject, typeof(MoreRowScrollView))
    self.WillView = self:GetChildWightByParent("WillView", self.gameObject, typeof(MoreRowScrollView))
    self.NowView = self:GetChildWightByParent("NowView", self.gameObject, typeof(MoreRowScrollView))
    self.viewbuyed = self:GetChildByParent("viewbuyed", self.gameObject)
    self.viewNormal = self:GetChildByParent("viewNormal", self.gameObject)
    self.BtnBuy = CommonHelper:HButtonSetCallback("BtnBuy", self.gameObject, function(data)
        if self.Data.IsBuy then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.SeasonOrderBuyed))
            return
        end
        CommonHelper:ChargeMoneyByID(self.chargeCfg.itemid)
    end)
    CommonHelper:HButtonSetCallback("BtnGetGift", self.gameObject, function(data)
        if self.CanGet then
            SeasonOrderSubsystem:Get():SendMsg_GetSeasonGift(0)
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.SeasonOrderNoGeted))
        end

    end)
    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(data)
        CommonHelper:ShowHelpView(PageDetailType.SeasonOrder)
    end)
end

function FoundPassStoryView:OnOpen()
    self.Data=FoundListManager:Get():GetFoundData(UserFoundType.Story)
    self:SetData(self.Data,true)
end
function FoundPassStoryView:BuyFinish()
    self:SetData(self.Data)
end

function FoundPassStoryView:OnClose()
    if self.TimeId then
        TimerManager:Get():StopTimer(self.TimeId)
        self.TimeId = nil
    end
end
function FoundPassStoryView:OnClose()

end
---@param msg FoundData
function FoundPassStoryView:SetData(msg, default)
    ---@type dictcharge_config_cell
    self.chargeCfg = msg.ChargeCfg
    if not msg.IsBuy then
        UIUtil.SetParentTransform(self.viewNormal, self.activityList, true, true)
        if self.chargeCfg and self.chargeCfg.exnum then
            CommonHelper:SetBtnIsRmbOrToken(self.BtnBuy,self.chargeCfg)
        end
    else
        UIUtil.SetParentTransform(self.viewbuyed, self.activityList, true, true)
        CommonHelper:SetText("BtnBuy/###priceText", self.BtnBuy.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.SeasonOrderBuyed))
    end
    CommonHelper:SetGameObjectActive("buyBg", self.gameObject, not msg.IsBuy)
    CommonHelper:SetGameObjectActive("lockimage", self.gameObject, not msg.IsBuy)
    CommonHelper:SetSlider("Slider", self.gameObject, msg.Lv / msg.LevelMax)

    --self:SetSeasonMoreDerTime(msg)

    local GetNow = {}
    local GetWill = {}
    self.CanGet = false
    ---@type dictpassaward_config_cell[]
    local awards = self.Data.Awards
    for i = 1, #awards do
        local highaward = CommonHelper:ParseToRewardBy2Code(awards[i].highawards)
        if awards[i].level <= msg.Lv then
            for i = 1, #highaward do
                if GetNow[highaward[i].id] == nil then
                    GetNow[highaward[i].id] = highaward[i].num
                else
                    GetNow[highaward[i].id] = GetNow[highaward[i].id] + highaward[i].num
                end
            end

            if self.CanGet == false and self.Data.IsGift[i] and self.Data.IsGift[i] == 0 then
                self.CanGet = true
            end
            if self.CanGet == false and self.Data.IsGift[i] and self.Data.IsBuy and self.Data.IsGift[i] == 1 then
                self.CanGet = true
            end
        else
            for i = 1, #highaward do
                if GetWill[highaward[i].id] == nil then
                    GetWill[highaward[i].id] = highaward[i].num
                else
                    GetWill[highaward[i].id] = GetWill[highaward[i].id] + highaward[i].num
                end
            end
        end
    end
    local GetNowList = {}
    local GetWillList = {}
    for k, v in pairs(GetNow) do
        local data = RewardData()
        data:SetDataIdNum(k, v)
        table.insert(GetNowList, data)
    end
    for k, v in pairs(GetWill) do
        local data = RewardData()
        data:SetDataIdNum(k, v)
        data:SetTypeAndQuality()
        table.insert(GetWillList, data)
    end
    table.sort(GetWillList, function(a, b)
        return a.type < b.type
    end)
    table.sort(GetWillList, function(a, b)
        return a.quality > b.quality
    end)
    CommonHelper:InitMoreRowScrollView(self.activityList, #awards, 1, function(index, itemObj, scroll)
        ---@type dictpassaward_config_cell
        local temp = awards[index + 1]
        ---@type dcitchapter_config_cell
        local levelCfg= CommonHelper:GetTableDataByID(ConfigNames.pvelevel_config,temp.LastCfg.lvexp)
        CommonHelper:SetText("###rewardlv", itemObj, temp.levelshow)
        CommonHelper:SetGameObjectActive("toplock", itemObj, temp.level > self.Data.Lv or self.Data.IsGift[index + 1] == -1)
        CommonHelper:SetGameObjectActive("bottomlock", itemObj, temp.level > self.Data.Lv or self.Data.IsGift[index + 1] == -1)
        if self.Data.IsBuy then
            CommonHelper:SetGameObjectActive("bottomlock", itemObj, temp.level > self.Data.Lv)
        else
            CommonHelper:SetGameObjectActive("bottomlock", itemObj, true)
        end
        if (self.Data.IsGift[index + 1] == nil ) or self.Data.IsGift[index + 1] == 0 or self.Data.IsGift[index + 1] == -1 then
            CommonHelper:SetGameObjectActive("toplockgeted", itemObj, false)
            CommonHelper:SetGameObjectActive("bottomlockgeted", itemObj, false)
        else
            CommonHelper:SetGameObjectActive("toplockgeted", itemObj, true)
            CommonHelper:SetGameObjectActive("bottomlockgeted", itemObj, self.Data.IsGift[index + 1] == 2)
        end
        local freeAward = CommonHelper:ParseToRewardBy2Code(awards[index + 1].freeawards)
        local highAward = CommonHelper:ParseToRewardBy2Code(awards[index + 1].highawards)
        local reward1 = self:GetChildByParent("reward1", itemObj)
        local reward2 = self:GetChildByParent("reward2", itemObj)
        local param1 = Param_ItemArticleParam()
        param1.count = freeAward[1].num
        local param2 = Param_ItemArticleParam()
        param2.count = highAward[1].num
        CommonHelper:SetItemComGroup(reward1, UIModuleID.SeasonOrder, freeAward[1].id, param1, function(data)
            if self.Data.IsGift[data]==0 then
                FoundSubsystem:Get():SendMsg_GewFoundAward(self.Data.Id)
            else
                CommonHelper:ShowPartInfoByCfgId(freeAward[1].id, UIModuleID.SeasonOrder)
            end
        end, index + 1)
        CommonHelper:SetItemComGroup(reward2, UIModuleID.SeasonOrder, highAward[1].id, param2, function(data)
            if self.Data.IsGift[data]==1 or self.Data.IsGift[data]==0 then
                FoundSubsystem:Get():SendMsg_GewFoundAward(self.Data.Id)
            else
                CommonHelper:ShowPartInfoByCfgId(highAward[1].id, UIModuleID.SeasonOrder)
            end
        end, index + 1)
    end, false, nil, not default)
    if default then
        local index = self.Data.Lv - 1
        if index < 0 then
            index = 0
        end
        if index >= #awards then
            index = #awards - 1
        end
        CommonHelper:MoreRowView_ScrollToItem(self.activityList, index)
    end
    CommonHelper:InitMoreRowScrollView(self.NowView, #GetNowList, 1, function(index, itemObj, scroll)
        ---@type RewardData
        local temp = GetNowList[index + 1]
        local param = Param_ItemArticleParam()
        param.count = temp.num
        CommonHelper:SetItemComGroup(itemObj, UIModuleID.SeasonOrder, tonumber(temp.id), param, function(data)
            CommonHelper:ShowPartInfoByCfgId(tonumber(temp.id), UIModuleID.SeasonOrder)
        end)
    end)
    CommonHelper:InitMoreRowScrollView(self.WillView, #GetWillList, 1, function(index, itemObj, scroll)
        ---@type RewardData
        local temp = GetWillList[index + 1]
        local param = Param_ItemArticleParam()
        param.count = temp.num
        CommonHelper:SetItemComGroup(itemObj, UIModuleID.SeasonOrder, tonumber(temp.id), param, function(data)
            CommonHelper:ShowPartInfoByCfgId(tonumber(temp.id), UIModuleID.SeasonOrder)
        end)
    end)
end



