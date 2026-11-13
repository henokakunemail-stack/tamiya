
---@class GiftShowRewardView : ViewBase
GiftShowRewardView = class("GiftShowRewardView", ViewBase)

function GiftShowRewardView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "GiftShowRewardViewAction")

    print("---   GetReward 初始化完成")
end

function GiftShowRewardView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function()
         UIManager:Get():ClosePopup()
    end)

    self.ScrollView = UIUtil.GetTypeChildWightByParent("ScrollHorizontalOneRow", self.gameObject, typeof(MoreRowScrollView))

end

function GiftShowRewardView:OnClose()
end
function GiftShowRewardView:OnOpen()
end
function GiftShowRewardView:OnOpenAnimEnd()
end
---@param value RewardData[]
function GiftShowRewardView:SetRewardInfo(value,giftId)
    ---@type dictgiftpart_config
    local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictgiftpart_config)
    if value then
        local funcUpdateItem = function(dataIndex, itemObj, scroll)
            local data = value[dataIndex + 1]
            if data == nil then
                return
            end
            local reform= cfg.GetPartDataByGiftId(giftId,data.id)
            local param = Param_ItemArticleParam()
            param.count = data.num
            local type=ItemPartUIType.Simple
            if reform then
                param.generation=reform.partage
                param.star=reform.partstart
                param.lv=reform.partlev
                param.awaken=reform.partbreak==1
                type=ItemPartUIType.Normal
            end
            CommonHelper:SetItemComGroup(itemObj, UIModuleID.GiftShowReward, data.id, param, function(btnData)
                local reform= cfg.GetPartDataByGiftId(giftId,btnData)
                CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.GiftShowReward, false,reform)
            end, data.id,type)

        end

        CommonHelper:InitMoreRowScrollView(self.ScrollView, #value, 5, funcUpdateItem, true)
    end
end

