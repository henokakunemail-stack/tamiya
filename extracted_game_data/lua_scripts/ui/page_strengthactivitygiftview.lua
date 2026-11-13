---@class Page_StrengthActivityGiftView:Page_StrengthActivityBaseView
Page_StrengthActivityGiftView = class("Page_StrengthActivityGiftView",Page_StrengthActivityBaseView)

function Page_StrengthActivityGiftView:OnOpen()
    self:SetActivityTime()
    self.StrengthRechargeScroll = UIUtil.GetTypeChildWightByParent("StrengthRechargeScroll", self.gameObject, typeof(MoreRowScrollView))

    CommonHelper:InitMoreRowScrollView(self.StrengthRechargeScroll,#self.ActivityData.GiftDataList,1,function(dataIndex, itemObj,view)
        local gift = self.ActivityData.GiftDataList[dataIndex + 1]
        CommonHelper:SetText("###residueText", itemObj, CommonHelper:GetTempStr_Default(gift.Cfg.name))
        local limitText = CommonHelper:GetTempStr_Default(TemplateStringID.StrengthActivityLimitDesc,gift.Count,gift.Cfg.buymax)
        local canBuy = true
        if gift.Cfg.buymax == 0 then
            CommonHelper:SetText("###LimitText", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.StrengthActivityNotLimitDesc))
            canBuy = true
        else
            CommonHelper:SetText("###LimitText", itemObj, limitText)
            canBuy = gift.Count<gift.Cfg.buymax
        end
        CommonHelper:SetGameObjectActive("BtnBuy",itemObj,canBuy)
        CommonHelper:SetGameObjectActive("sellOut",itemObj,not canBuy)
        local rewards= CommonHelper:SetDataByStrIdAndNum(gift.Cfg.awardids,gift.Cfg.awardnums)
        local SVC_Three = UIUtil.GetTypeChildWightByParent("SVC_Three", itemObj, typeof(MoreRowScrollView))
        local RewardUpdateFunc = function(rewardIndex, rewardObj)
            local targetReward = rewards[rewardIndex + 1]
            local obj = UIUtil.GetChild("ItemCom_118", rewardObj)
            local param = Param_ItemArticleParam()
            param.count=targetReward.num
            CommonHelper:SetItemComGroup(obj, UIModuleID.StrengthActivity, targetReward.id, param, function(btnData)
                CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.StrengthActivity, false)
            end, targetReward.id)
        end
        CommonHelper:InitMoreRowScrollView(SVC_Three, #rewards, #rewards, RewardUpdateFunc, true, nil, false)

        local  btn=CommonHelper:HButtonSetCallback("BtnBuy", itemObj, function(btn)
            local data = self.ActivityData.GiftDataList[btn.intData]
            local canBuy = true
            if data.buymax == 0 then
                canBuy = true
            else
                canBuy = data.Count<data.Cfg.buymax
            end
            CommonHelper:ChargeMoneyByID(data.ChargeCfg.itemid)
        end,dataIndex + 1)
        CommonHelper:SetBtnIsRmbOrToken(btn,gift.ChargeCfg)
    end)
end

function Page_StrengthActivityGiftView:OnClose()

end

function Page_StrengthActivityGiftView:OnRefresh()
    self:SetActivityTime()
    CommonHelper:MoreRowView_RefreshCurList(self.StrengthRechargeScroll,false)
end
