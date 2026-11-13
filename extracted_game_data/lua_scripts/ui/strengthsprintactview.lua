---@class StrengthSprintActView : ViewBase
StrengthSprintActView = class("StrengthSprintActView", ViewBase)

local SelectID = -1

function StrengthSprintActView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "StrengthSprintActViewAction")
end

function StrengthSprintActView:Awake()
    self.ChooseBtnSVC = UIUtil.GetTypeChildWightByParent("ChooseBtnSVC", self.gameObject, typeof(MoreRowScrollView))

    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
    end)

    CommonHelper:HButtonSetCallback("goBtn", self.gameObject, function()
        UIManager:Get():ClosePopup()
        FunctionSkipManager:Get():SkipToFunction(GameFunction.Story)
    end)
    ---@type Page_StrengthActivityBaseView[]
    self.ActivityViewList={}
    self.ActivityViewList[StrengthActivityType.Shop]=Page_StrengthActivityShopView(self:GetChild("Page_CommonStrengthView"),StrengthActivityType.Shop,self)
    self.ActivityViewList[StrengthActivityType.Gift]= Page_StrengthActivityGiftView(self:GetChild("Page_StrengthRechargeView"),StrengthActivityType.Gift,self)
end

function StrengthSprintActView:OnOpen()
    SelectID = 1
    self:OpenCurActivityView()
    self:InitChooseData()
end

function StrengthSprintActView:ReOpen()

end
---@param data StrengthActivityData
function StrengthSprintActView:OnActivityClick(subType)
    self.ActivityData:Open(subType)
end
function StrengthSprintActView:OpenCurActivityView()
    self.ActivityData=StrengthActivityManager:Get().CurActivityData
    for k, v in pairs(self.ActivityViewList) do
        if v.type==StrengthActivityManager:Get().CurActivitySubType then
            self.CurView=v
        else
            v:Close()
        end
    end
    self.CurView:Open(self.ActivityData)
end

function StrengthSprintActView:InitChooseData()
    local dataList=self.ActivityData.Tabs
    local UpdateFunc = function(index, itemObj, scroll)
        local dataIndex=index+1
        local temp=dataList[dataIndex]
        CommonHelper:SetGameObjectActive("choose", itemObj, SelectID == dataIndex)
        CommonHelper:SetGameObjectActive("common", itemObj, SelectID ~= dataIndex)
        CommonHelper:SetText("choose/###Text", itemObj, CommonHelper:GetTempStr_Default(temp))
        CommonHelper:SetText("common/###Text", itemObj, CommonHelper:GetTempStr_Default(temp))
        CommonHelper:HButtonSetCallback("ItemBtn", itemObj, function(btn)
            if SelectID~=btn.intData then
                SelectID = btn.intData
                self:OnActivityClick(SelectID)
                CommonHelper:MoreRowView_RefreshCurList(self.ChooseBtnSVC,false)
            end
        end,dataIndex)
    end
    CommonHelper:InitMoreRowScrollView(self.ChooseBtnSVC, #dataList, 1, UpdateFunc, true, nil, false)
end

function StrengthSprintActView:Refresh()
    self.CurView:Refresh()
end
function StrengthSprintActView:SetActivityTime(type)
    local dataList=self.ActivityData.Tabs
    local durationTime = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.FestivalTimeText,
            self.ActivityData.BTime.Month, self. ActivityData.BTime.Day,  self.ActivityData.BTime.Hour, self.ActivityData.BTime.Minute,
            self. ActivityData.ETime.Month,  self.ActivityData.ETime.Day, self. ActivityData.ETime.Hour,  self.ActivityData.ETime.Minute))
    CommonHelper:SetText("###activitytime",self.gameObject, durationTime)
    CommonHelper:SetText("###curactivityname",self.gameObject, CommonHelper:GetTempStr_Default(dataList[type]))
    local key=CommonHelper:GetDictCalcData(CommonCfgKey.StrengthSprintCoin)
    CommonHelper:SetText("###exchangeNum",self.gameObject,KnapsackDataManager:Get():GetArticleCountByCfgid(key))
    CommonHelper:SetNewLineText("###StrengthActivityGiftDesc",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.StrengthActivityGiftDesc))
end

function StrengthSprintActView:OnClose()

end

