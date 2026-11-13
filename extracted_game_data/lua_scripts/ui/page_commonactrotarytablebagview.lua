---@field GetDataTimeString  fun(param:self):string @可选重写 获取活动持续时间
---@field GetDataTime fun(param:self):number
---@field GetUIModuleID fun(param:self):string
---@field gameObject  CS.UnityEngine.GameObject
---@field actConfig  act_bussiness_config_cell
---@class Page_CommonActRotaryTableBagView
Page_CommonActRotaryTableBagView = class("Page_CommonActRotaryTableBagView", Page_CommonActViewBase)

function Page_CommonActRotaryTableBagView:GetPageName()
    return "Page_CommonActRotaryTableBagView"
end

function Page_CommonActRotaryTableBagView:initialize()

end

function Page_CommonActRotaryTableBagView:OnAwake()
    self.TableBagSVC = UIUtil.GetTypeChildWightInputPath("TableBagSVC", self.gameObject, typeof(MoreRowScrollView))

end

function Page_CommonActRotaryTableBagView:OnOpen()
    local timeTxt = self:GetDataTimeString()
    CommonHelper:SetText("###time", self.gameObject, timeTxt)
end

function Page_CommonActRotaryTableBagView:RequestOpen()
    print(" --623, --請求限时活动礼包 P2=actid", self.actConfig.C_ID)
    CommonFestivalSubSystem:Get():SendMsg_ActGiftPackage(self.actConfig.C_ID)
end

function Page_CommonActRotaryTableBagView:Refresh()
    self.GiftPackageMsgData = GiftPackageDataManager:Get():GetGiftPackageMsgData()

    CommonHelper:InitMoreRowScrollView(self.TableBagSVC, #self.GiftPackageMsgData, 1, function(itemIndex, itemChild, scroll)
        local msgData = self.GiftPackageMsgData[itemIndex + 1]

        CommonHelper:SetText("###progress", itemChild, string.format(
                CommonHelper:GetTempStr_Default(TemplateStringID.RotaryTableBagBuyNum), msgData.BuySum, msgData.BuyMax))

       local btnBuy= CommonHelper:HButtonSetCallback("btnBuy", itemChild, function(btnData)
            CommonHelper:ChargeMoneyByID(msgData.ItemID)
        end)
       -- CommonHelper:SetBtnIsRmbOrToken(btnBuy,CommonHelper:GetChargeCfgByAreaAndItemId(msgData.ItemID))
        local ItemSVC = UIUtil.GetTypeChildWightInputPath("ItemSVC", itemChild, typeof(MoreRowScrollView))
        CommonHelper:InitMoreRowScrollView(ItemSVC, #msgData.AwardIDS, 1, function(rewardIndex, itemObject, scroll)
            local _data = msgData.AwardIDS[rewardIndex + 1]
            local ItemObj = UIUtil.GetChild("ItemCom_118", itemObject)
            local param = Param_ItemArticleParam()
            param.count = msgData.AwardNum[rewardIndex + 1]
            CommonHelper:SetItemComGroup(ItemObj, UIModuleID.CommonAct, _data, param,function()
                CommonHelper:ShowPartInfoByCfgId(_data, UIModuleID.CommonAct)
            end)
        end)

        CommonHelper:SetText("btnBuy/Text", itemChild, msgData.PriceName)

    end,false,nil,GiftPackageDataManager:Get():GetGiftPackageIsResetFlag())

end

function Page_CommonActRechargeRewardView:RefreshRedPointID(Active)
    --local actData = RechargeRewardManager:Get():GetActData(self.actConfig.C_ID)
    --local redPointID = actData.sumType<1000 and RedPointID.S_ActSingleDayRechargerReward or RedPointID.S_ActRechargerReward
    --RedPointManager:Get():UpdateValue(redPointID,Active)
end

function Page_CommonActRotaryTableBagView:OnClose()

end