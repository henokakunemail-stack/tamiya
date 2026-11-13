function PageBattleResult:Reward_InitResultInfo(isFail)
    CommonHelper:SetGameObjectActive("battleresult_bg_win", self.pageRewardCG.gameObject, not isFail)
    CommonHelper:SetGameObjectActive("battleresult_bg_lose", self.pageRewardCG.gameObject, isFail)

    local dropData = self.battleResultData:GetOtherResultData()

    CommonHelper:SetGameObjectActive("RewardList", self.pageRewardCG.gameObject, dropData ~= nil)

    if dropData ~= nil then
        self:Reward_InitDropDownScroll(dropData.items)
    end
    dropData=dropData~=nil and dropData.data or dropData
    self:InitBaseData(self.pageRewardCG.gameObject, dropData, not isFail)
    local PlayerData=BattleDataManager:Get():GetDefaultPlayerBattleResultData()
    CommonHelper:HButtonSetCallback("BtnHelp", self.pageRewardCG.gameObject, function()
        CommonHelper:OpenEncyclopedia(EncyclopediaPage.Parts)
    end)
    CommonHelper:HButtonSetCallback("BtnHelpError", self.pageRewardCG.gameObject, function()
        CommonHelper:ShowHelpView(PlayerData:GetError())
    end)
    CommonHelper:SetHButtonClick(self.BtnHelpError,false,true)
    CommonHelper:SetText("###FailReasonText", self.pageRewardCG.gameObject, CommonHelper:GetTempStr_BattleFailM_ErrorTips(PlayerData:GetError()))
end

local __Items = {}
---@param items SC_SomeDown
function PageBattleResult:Reward_InitDropDownScroll(items)
    if items == nil then
        return
    end
    __Items =  CommonHelper:GetRewardDataBySomeDown(items)
    local funcUpdateItem = function(dataIndex, itemObj, scroll)
        local data = __Items[dataIndex + 1]
        if data then
            local param = Param_ItemArticleParam()
            param.count = data.num
            local type=ItemPartUIType.Simple
            local cell=nil
            if data.partIdx~=nil then
                cell=KnapsackDataManager:Get():GetArticleByCellID(data.partIdx)
                if cell then
                    param.quality = cell:GetPartQuality()
                    param.star = cell:GetStar()
                    param.lv = cell:GetPartLV()
                    param.using = cell:GetCarId()
                    param.lock = cell:GetPartLock()
                    param.awaken=cell:GetAwaken()
                    param.generation=cell:GetGeneration()
                    param.downType=cell:GetPartDownType()
                    param.source = cell:GetPartSource()
                    param.expireTime = cell:GetPartExpTime()
                    type=ItemPartUIType.Normal
                end
            end
            CommonHelper:SetItemComGroup(itemObj, UIModuleID.BattleResult, tonumber(data.id), param, function(btnData)
                CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.BattleResult, false,nil,cell)
            end, tonumber(data.id),type)
        end
        CommonHelper:SetGameObjectActive("ItemCom_118", itemObj, data ~= nil)
    end

    self.rewardList = UIUtil.GetTypeChildWightByParent("RewardList", self.pageRewardCG.gameObject, typeof(MoreRowScrollView))

    local dataCount = #__Items > 6 and #__Items or 6
    CommonHelper:InitMoreRowScrollView(self.rewardList, dataCount, 1, funcUpdateItem, true)
end

----获得当前得到多少金币
function PageBattleResult:GetAwardGold(currencyTable)
    if #currencyTable > 0 then
        for i = 1, #currencyTable do
            if currencyTable[i].num1 == CurrencyType.Gold then
                return currencyTable[i].num2
            end
        end
    else
        return 0
    end
end