---@class ClubExchangeView : ViewBase
ClubExchangeView = class("ClubMessageView", ViewBase)

local _consumeDiamond = 0
function ClubExchangeView:initialize()
    ViewBase.initialize()
    ViewBase.RegisteAction(self, "ClubExchangeViewAction")
end

function ClubExchangeView:Awake()
    self:CacheBaseData()
    self:InitClubExchangeViewBtnFunc()
end

function ClubExchangeView:OnOpen()
    self:InitClubExchangeViewInfo()
end

function ClubExchangeView:CacheBaseData()
    self:CacheMainMenuBaseData()
    self.LabCost = self:GetChild("LabCost")
    self.Rewards = self:GetChild("Rewards")

    self.ExchangeBtn = self:GetChildWightByParent("ExchangeBtn", self.bottom, typeof(HButton))
    self.ExchangeZeroText = self:GetChild("ExchangeZeroText")
    self.ExchangeNoZero = self:GetChild("ExchangeNoZero")
    self.RewardGoItems = self:CacheRewardGo()
end

function ClubExchangeView:InitClubExchangeViewBtnFunc()
    self:InitMainMenuBaseViewBtnFunc()
    CommonHelper:HButtonSetCallback("BtnBack", self.bottom, function(param)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("ExchangeBtn", self.bottom, function(param)
        self:OnExchangeBtnClick()
    end)
end

function ClubExchangeView:InitClubExchangeViewInfo()
    local curSelectClubId = ClubDataManager:Get():GetCurSelectClubId()
    local selfCreatedClubData = ClubDataManager:Get():GetClubDataById(curSelectClubId)
    self:InitDetailCommonInfo(selfCreatedClubData)
end

---@param msg SC_DonationInfo
function ClubExchangeView:UpdateExchangeViewInfo(msg)
    local dNum = msg.dNum
    local maxNum = msg.maxNum
    local restTimes = maxNum - dNum
    local isZero = self:ExchangeTimeZero(dNum, maxNum)
    if not isZero then
        self:InitExchangeNoZeroInfo(dNum, restTimes)
    end
end

function ClubExchangeView:ExchangeTimeZero(dNum, maxNum)
    if dNum == maxNum then
        self.ExchangeZeroText.gameObject:SetActive(true)
        self.ExchangeNoZero.gameObject:SetActive(false)
        CommonHelper:SetHButtonClick(self.ExchangeBtn, false, true)
    else
        self.ExchangeZeroText.gameObject:SetActive(false)
        self.ExchangeNoZero.gameObject:SetActive(true)
        CommonHelper:SetHButtonClick(self.ExchangeBtn, true, true)
    end
    return dNum == maxNum
end

function ClubExchangeView:InitExchangeNoZeroInfo(dNum, restTimes)
    ---@type donation_config_cell
    local donationConfigs = CommonHelper:GetTableDataByID(ConfigNames.donation_config, dNum + 1)
    self:SetRewardInfo(donationConfigs.currency, donationConfigs.items)
    _consumeDiamond = donationConfigs.consume
    CommonHelper:SetText("RestTimesText", self.gameObject, restTimes)
    if donationConfigs.consume == 0 then
        self.LabCost.gameObject:SetActive(false)
        CommonHelper:SetText("Diamond/Text", self.gameObject, "首次免费")
    else
        self.LabCost.gameObject:SetActive(true)
        CommonHelper:SetText("Diamond/Text", self.gameObject, "费用")
        CommonHelper:SetText("LabCost", self.gameObject, tostring(donationConfigs.consume))
    end
end

function ClubExchangeView:SetRewardInfo(rewardCurrency, rewardItems)
    for i = 1, #self.RewardGoItems do
        local go = self.RewardGoItems[i].gameObject
        if i <= 4 then
            if i <= #rewardItems then
                go:SetActive(true)
                local param = Param_PartOrArticleParam()
                param.moduleId = UIModuleID.Club
                param.id = rewardItems[i][1]
                param.count = rewardItems[i][2]
                param.showcount = true
                CommonHelper:SetPartOrArticleGroup(self.RewardGoItems[i], param)
            else
                go:SetActive(false)
            end
        else
            if (i - 4) <= #rewardCurrency then
                go:SetActive(true)
                local count = rewardCurrency[i - 4][2]
                CommonHelper:SetText("GoldCountText", self.RewardGoItems[i], tostring(count))--这个地方应该根据currency的id设置他的图片数据
            else
                go:SetActive(false)
            end
        end
    end
end

---@param msg SC_DonationRes
function ClubExchangeView:UpdateExchangePlayerAttr(msg)
    self:UpdateExchangeViewInfo(msg.donationInfo)
    PlayerDataManager:Get():SetCurrency(CurrencyType.Diamond, msg.diamond)
    local clubData = ClubDataManager:Get():GetCurSelectClubData()
    clubData:SetExp(msg.guildExp)
    clubData:SetCoin(msg.coin)
    clubData:SetLevel(msg.guildLv)

    UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuBaseView_InitDetailCommonInfo, clubData)
    UINotify:Get():SendNotification(UINotifyEvent.ClubExchangeGetRewardView_SetRewardInfo, msg.donationInfo.dNum)

end

function ClubExchangeView:OnExchangeBtnClick()
    local playerDiamond = PlayerDataManager:Get():GetCurrency(CurrencyType.Diamond)
    if playerDiamond >= _consumeDiamond then
        ClubSubsystem:Get():SendMsg_GuildDonation()
    else
        local boxFunc = function()
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Orange, CommonHelper:GetTempStr_Default(TemplateStringID.DiamondNotHave), CommonHelper:GetTempStr_Default(TemplateStringID.DiamondPay), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), true)
            if ret == MessageBoxHelp.BtnType.OK then
                CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.StaminaPurchaseNotOpen))
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
    end
end

function ClubExchangeView:CacheRewardGo()
    local rewardItems = {}
    for i = 1, 7 do
        local rewardItem
        if i <= 4 then
            rewardItem = self:GetChildByParent(string.format("PartOrArtcleComponent (%d)", i - 1), self.Rewards.gameObject)
        else
            rewardItem = self:GetChildByParent(string.format("IconMoneyGold (%d)", i - 1), self.Rewards.gameObject)
        end
        table.insert(rewardItems, rewardItem)
    end
    return rewardItems
end

function ClubExchangeView:OnClose()

end

