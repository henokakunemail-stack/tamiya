---@class ActivityFirstBuyView : ViewBase
ActivityFirstBuyView = class("ActivityFirstBuyView", ViewBase)
function ActivityFirstBuyView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ActivityFirstBuyViewAction")
end

local _SelectType = nil
local FirstChargeData = nil

function ActivityFirstBuyView:Awake()
    self:InitBtnFunc()
end

function ActivityFirstBuyView:InitBtnFunc()
    self.Center = self:GetChildWight("Center", typeof(RectTransform))

    self.ChooseTypeScroll = self:GetChildWightByParent("ChooseTypeScroll", self.Center.gameObject, typeof(MoreRowScrollView))
    self.InfoBaseScroll = self:GetChildWightByParent("InfoBaseScroll", self.Center.gameObject, typeof(MoreRowScrollView))

    self.GoPurchaseBtn = CommonHelper:HButtonSetCallback("GoPurchaseBtn", self.gameObject, function()
        self:OnPurchaseBtnClick()
    end)

    self.GetRewardBtn = CommonHelper:HButtonSetCallback("GetRewardBtn", self.gameObject, function()
        self:OnGetRewardBtnClick()
    end)

    self.GetRewardedBtn = UIUtil.GetChild("GetRewardedBtn", self.gameObject)

    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function()
        UIManager:Get():HidePersistentView("ActivityFirstBuyView")
        UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_SetLuaViewInfo,{"ActivityFirstBuyView",false})
    end)

end
function ActivityFirstBuyView:OnBackKey()
    UIManager:Get():HidePersistentView("ActivityFirstBuyView")
    UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_SetLuaViewInfo,{"ActivityFirstBuyView",false})
end


function ActivityFirstBuyView:OnPurchaseBtnClick()
    FunctionSkipManager:Get():SkipToFunction(GameFunction.PurchasePanel)
end

function ActivityFirstBuyView:OnGetRewardBtnClick()
    ActivitySubsystem:Get():SendMsg_GetFirstBuyReward(_SelectType + 1)
end

function ActivityFirstBuyView:InitViewInfo(ref)
    if ref==false then
        _SelectType = 0
    end
    self:InitBaseTypeList()
end

function ActivityFirstBuyView:InitBaseTypeList()
    ---@type act_firstcharge_config
    local act_firstcharge_config = ClientDataManager:Get():GetDataTable(ConfigNames.act_firstcharge_config)
    ---@type act_firstcharge_config_cell[]
    FirstChargeData = {}
    for i, v in pairs(act_firstcharge_config.GetConfigData()) do
        table.insert(FirstChargeData, v)
    end

    local UpdateFunc = function(dataIndex, itemObj, scroll)
        ---@type act_firstcharge_config_cell
        local data = FirstChargeData[dataIndex + 1]
        CommonHelper:SetText("normal/###text", itemObj, CommonHelper:GetTempStr_Default(data.dayname))
        CommonHelper:SetText("hover/###text", itemObj, CommonHelper:GetTempStr_Default(data.dayname))

        local Btn = CommonHelper:HButtonSetCallback("ToggleBtn", itemObj, function(data)
            _SelectType = data.intData
            CommonHelper:MoreRowTitle_Refresh(self.ChooseTypeScroll, false)
            self:SetRewardView()
        end, dataIndex)
        CommonHelper:SetToggleState(Btn, dataIndex == _SelectType)
    end
    self:SetRewardView()
    CommonHelper:InitMoreRowScrollView(self.ChooseTypeScroll, #FirstChargeData, 1, UpdateFunc, true)
end

function ActivityFirstBuyView:SetRewardView()
    local rewardConfig = FirstChargeData[_SelectType + 1]
    local reward = {}
    local ids = stringSplitToNumber(rewardConfig.awardids, ':')
    local nums = stringSplitToNumber(rewardConfig.awardnums, ':')
    for i = 1, #ids do
        local rewardData = RewardData()
        rewardData:SetDataIdNum(ids[i], nums[i])
        table.insert(reward, rewardData)
    end

    CommonHelper:InitMoreRowScrollView(self.InfoBaseScroll, #reward, 1, function(index, item, scrollview)
        local param = Param_ItemArticleParam()
        param.count = reward[index + 1].num
        CommonHelper:SetItemComGroup(item, UIModuleID.FirstBuy, reward[index + 1].id, param, function()
            CommonHelper:ShowPartInfoByCfgId(reward[index + 1].id, UIModuleID.FirstBuy)
        end)
    end)

    self:SetBtnState()
end

function ActivityFirstBuyView:SetBtnState()

    local userGiftData = UserFirstGiftManager:Get():GetDataByID(1)
    if userGiftData == nil then
        CommonHelper:CSGameObjectSetActive(self.GoPurchaseBtn.gameObject, true)
        CommonHelper:CSGameObjectSetActive(self.GetRewardBtn.gameObject, false)
        CommonHelper:CSGameObjectSetActive(self.GetRewardedBtn.gameObject, false)
    else
        if _SelectType == 0 then
            if math.floor((userGiftData.Actfirstcharge % 10)) == 1 then
                CommonHelper:CSGameObjectSetActive(self.GoPurchaseBtn.gameObject, false)
                CommonHelper:CSGameObjectSetActive(self.GetRewardBtn.gameObject, false)
                CommonHelper:CSGameObjectSetActive(self.GetRewardedBtn.gameObject, true)

            else
                CommonHelper:CSGameObjectSetActive(self.GoPurchaseBtn.gameObject, false)
                CommonHelper:CSGameObjectSetActive(self.GetRewardBtn.gameObject, true)
                CommonHelper:CSGameObjectSetActive(self.GetRewardedBtn.gameObject, false)
            end
        end

        if _SelectType == 1 then
            if math.floor(((userGiftData.Actfirstcharge % 100) / 10)) == 1 then
                CommonHelper:CSGameObjectSetActive(self.GoPurchaseBtn.gameObject, false)
                CommonHelper:CSGameObjectSetActive(self.GetRewardBtn.gameObject, false)
                CommonHelper:CSGameObjectSetActive(self.GetRewardedBtn.gameObject, true)
            else
                CommonHelper:CSGameObjectSetActive(self.GoPurchaseBtn.gameObject, false)
                CommonHelper:CSGameObjectSetActive(self.GetRewardBtn.gameObject, true)
                CommonHelper:CSGameObjectSetActive(self.GetRewardedBtn.gameObject, false)
            end
        end

        if _SelectType == 2 then
            if math.floor((userGiftData.Actfirstcharge / 100)) == 1 then
                CommonHelper:CSGameObjectSetActive(self.GoPurchaseBtn.gameObject, false)
                CommonHelper:CSGameObjectSetActive(self.GetRewardBtn.gameObject, false)
                CommonHelper:CSGameObjectSetActive(self.GetRewardedBtn.gameObject, true)
            else
                CommonHelper:CSGameObjectSetActive(self.GoPurchaseBtn.gameObject, false)
                CommonHelper:CSGameObjectSetActive(self.GetRewardBtn.gameObject, true)
                CommonHelper:CSGameObjectSetActive(self.GetRewardedBtn.gameObject, false)
            end
        end
    end
end