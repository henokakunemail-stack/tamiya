---@class ClubExchangeGetRewardView : ViewBase
ClubExchangeGetRewardView = class("ClubExchangeGetRewardView", ViewBase)

function ClubExchangeGetRewardView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ClubExchangeGetRewardViewAction")
end


function ClubExchangeGetRewardView:Awake()
    self.ScrollView = UIUtil.GetTypeChildWightByParent("ScrollVerticalMoreRow", self.gameObject, typeof(InfinityScrollView))
    self.Rewards = self:GetChild("Rewards")
    self.RewardGoItems = self:CacheRewardGo()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject, function ()
        UIManager:Get():ClosePopup()
    end)
end

--function ClubExchangeGetRewardView:SetRewardInfo(dNum)
--    local donationConfigs = CommonHelper:GetTableDataByID(ConfigNames.donation_config, dNum)
--    local items=donationConfigs.items
--    if #items<= 0 then return  end
--    local funcUpdateItem = function (dataIndex, itemObj,scroll)
--        local data = items[dataIndex + 1]
--        if data == nil then return end
--        local param = Param_PartOrArticleParam()
--        param.moduleId = UIModuleID.Club
--        param.id = data[1]
--        param.count = data[2]
--        CommonHelper:SetPartOrArticleGroup(itemObj, param)
--    end
--    CommonHelper:InitScroll_MoreRows( self.ScrollView, #items, 4, funcUpdateItem, true)
--end

function ClubExchangeGetRewardView:SetRewardInfo(dNum)
    ---@type donation_config_cell
    local donationConfigs = CommonHelper:GetTableDataByID(ConfigNames.donation_config, dNum )
    local rewardCurrency=donationConfigs.currency
    local rewardItems= donationConfigs.items
    for i = 1, #self.RewardGoItems do
        if i<=4 then
            if i <= #rewardItems then
                self.RewardGoItems[i]:SetActive(true)
                local param = Param_PartOrArticleParam()
                param.moduleId = UIModuleID.Club
                param.id = rewardItems[i][1]
                param.count = rewardItems[i][2]
                param.showcount=true
                CommonHelper:SetPartOrArticleGroup(self.RewardGoItems[i], param)
            else
                self.RewardGoItems[i]:SetActive(false)
            end
        else
            if (i-4) <= #rewardCurrency then
                self.RewardGoItems[i]:SetActive(true)
                local count=rewardCurrency[i-4][2]
                CommonHelper:SetText("GoldCountText",self.RewardGoItems[i],tostring(count))--这个地方应该根据currency的id设置他的图片数据
            else
                self.RewardGoItems[i]:SetActive(false)
            end
        end
    end
end
function ClubExchangeGetRewardView:CacheRewardGo()
    local rewardItems = {}
    for i = 1, 7 do
        local rewardItem
        if i<=4 then
            rewardItem = self:GetChildByParent(string.format("PartOrArtcleComponent (%d)", i - 1), self.Rewards.gameObject)
        else
            rewardItem = self:GetChildByParent(string.format("IconMoneyGold (%d)", i - 1), self.Rewards.gameObject)
        end
        table.insert(rewardItems, rewardItem)
    end
    return rewardItems
end