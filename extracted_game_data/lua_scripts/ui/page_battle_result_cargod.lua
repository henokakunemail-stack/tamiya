----page_battle_result_cargod

function PageBattleResult:CarGod_InitResultInfo(isFail,playerData,Page_BattleResultRank)
    self.Page_BattleResultRank=Page_BattleResultRank
    if BattleDataManager:Get():GetBattleType()==RaceModel.RaceCarGod  then
        isFail =  playerData:GetError() ~= BattleFailError.None or playerData:GetTime() == 0
    end
    CommonHelper:SetGameObjectActive("battleresult_bg_win", self.pageCarGodCG.gameObject, not isFail)
    CommonHelper:SetGameObjectActive("battleresult_bg_lose", self.pageCarGodCG.gameObject, isFail)

    local dropData = BattleDataRaceCarGod:GetFinishCarGodData()
     CommonHelper:SetGameObjectActive("RewardList", self.pageCarGodCG.gameObject, dropData ~= nil and dropData.items)
    CommonHelper:SetGameObjectActive("MoreRowScrollView_V", self.pageCarGodCG.gameObject, RaceCarGodDataManager:Get():GetLastFlag())
    CommonHelper:SetGameObjectActive("Reward", self.pageCarGodCG.gameObject, RaceCarGodDataManager:Get():GetLastFlag())
    CommonHelper:SetGameObjectActive("MiddleResult", self.pageCarGodCG.gameObject,not RaceCarGodDataManager:Get():GetLastFlag())

    if dropData then
        if dropData.items ~= nil then
            self:CarGod_InitDropDownScroll(dropData.items)
        end

        self:CarGod_InitRecordScroll(dropData.SeasonID)
        self:InitBaseData(self.pageCarGodCG.gameObject, nil, not isFail)

        local PlayerData = BattleDataManager:Get():GetDefaultPlayerBattleResultData()

        CommonHelper:HButtonSetCallback("BtnHelp", self.pageCarGodCG.gameObject, function()
            CommonHelper:OpenEncyclopedia(EncyclopediaPage.Parts)
        end)
        CommonHelper:HButtonSetCallback("BtnHelpError", self.pageCarGodCG.gameObject, function()
            CommonHelper:ShowHelpView(PlayerData:GetError())
        end)

        CommonHelper:SetHButtonClick(self.BtnHelpError, false, true)
        CommonHelper:SetText("###FailReasonText", self.pageCarGodCG.gameObject, CommonHelper:GetTempStr_BattleFailM_ErrorTips(PlayerData:GetError()))
    end
end

function PageBattleResult:CarGod_InitRecordScroll()
    self.MoreRowScrollView_V = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.pageCarGodCG.gameObject, typeof(MoreRowScrollView))
    local copyID = RaceCarGodDataManager:Get():GetNewOneGodRankCopyID()
    local copyData= RaceCarGodDataManager:Get():GetPVEGodSectionDataByID(copyID)
    local recordData = copyData.goods
    local recordNum = (recordData==nil or #recordData < 5) and 5 or #recordData

    local playerTime = RaceCarGodDataManager:Get().PlayerTime

    CommonHelper:InitMoreRowScrollView(self.MoreRowScrollView_V, recordNum, 1, function(index, itemObj, scroll)
        local _data = recordData[index + 1]
        local _Speed = tonumber(_data.succVal)
        CommonHelper:SetGameObjectActive("lock", itemObj, playerTime >= _Speed)
        CommonHelper:SetGameObjectActive("star", itemObj, playerTime < _Speed)
        local TitleFinish =CommonHelper:GetTempStr_Default(TemplateStringID.RaceOneCarGodAwardTitleFinish,CommonHelper:TransferTimeToString(CommonHelper:TransferTime(playerTime)), CommonHelper:TransferTimeToString(CommonHelper:TransferTime(_data.succVal)))
        CommonHelper:SetText("###FailReasonText",itemObj,TitleFinish)
        CommonHelper:SetGameObjectActive("unlock",itemObj,playerTime <= _Speed)
        CommonHelper:SetGameObjectActive("lock",itemObj,playerTime > _Speed)
    end)

end

local __Items = {}
---@param items SC_SomeDown
function PageBattleResult:CarGod_InitDropDownScroll(items)
    if items == nil then
        return
    end
    __Items = {}
    __Items = CommonHelper:GetRewardDataBySomeDown(items)

    local funcUpdateItem = function(dataIndex, itemObj, scroll)
        local data = __Items[dataIndex + 1]
        if data ~= nil then
            local param = Param_ItemArticleParam()
            param.count = tostring(data.num)
            CommonHelper:SetItemComGroup(itemObj, UIModuleID.BattleResult, data.id, param, function()
                CommonHelper:ShowPartInfoByCfgId(data.id, UIModuleID.BattleResult)
            end)
        end
        CommonHelper:SetGameObjectActive("ItemCom_118", itemObj, data ~= nil)
    end

    self.rewardList = UIUtil.GetTypeChildWightByParent("RewardList", self.pageCarGodCG.gameObject, typeof(MoreRowScrollView))

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