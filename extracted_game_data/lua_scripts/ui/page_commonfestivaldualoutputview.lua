---双倍掉落宣传界面

---@field GetRedPointActive fun(param:self):boolean @可选重写
---@field GetDataTimeString  fun(param:self):string @可选重写 获取活动持续时间
---@field GetDataTime fun(param:self):number
---@field GetUIModuleID fun(param:self):string
---@field gameObject  CS.UnityEngine.GameObject
---@field actConfig  act_bussiness_config_cell
---@class Page_CommonFestivalDualOutputView
Page_CommonFestivalDualOutputView = class("Page_CommonFestivalDualOutputView", Page_CommonActViewBase)

function Page_CommonFestivalDualOutputView:GetPageName()
    return "Page_CommonFestivalDualOutputView"
end

function Page_CommonFestivalDualOutputView:initialize()

end

function Page_CommonFestivalDualOutputView:OnAwake()
    self.DualOutputSVC = UIUtil.GetTypeChildWightInputPath("DualOutputSVC", self.gameObject, typeof(MoreRowScrollView))
    --
end

function Page_CommonFestivalDualOutputView:OnOpen()
    self:InitDualOutputInfo()


    
    CommonHelper:SetText("time/###time", self.gameObject, self:GetDataTimeString())


end

function Page_CommonFestivalDualOutputView:InitDualOutputInfo()
    local dualOutput = stringSplit(self.actConfig.itemids, ":")
    local titleText = stringSplit(CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.DualOutPut).varval, ':')

    local UpdateFunc = function(dataIndex, itemObj, scroll)
        CommonHelper:HButtonSetCallback("BtnGo", itemObj, function()
            UIManager:Get():ClosePopup()
            self:GoToFunc(dataIndex + 1)
        end)

        if dataIndex / 2 > 0 then
            CommonHelper:GetComponentSetImage("itemTitleBG", itemObj, "conventional_dualoutput_title1_dt", UIModuleID.CommonAct)
        else
            CommonHelper:GetComponentSetImage("itemTitleBG", itemObj, "conventional_dualoutput_title2_dt", UIModuleID.CommonAct)
        end

        local titleName = ClientDataManager:Get():GetTemplateString(titleText[dataIndex + 1])
        CommonHelper:SetText("###TitleText", itemObj, titleName)
        local showText = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.DualOutputShowText), titleName)
        CommonHelper:SetText("###showText", itemObj, showText)
    end

    CommonHelper:InitMoreRowScrollView(self.DualOutputSVC, #dualOutput, 1, UpdateFunc)

end

function Page_CommonFestivalDualOutputView:GoToFunc(_toID)

    if _toID == CommonFestivalGoToType.Story then
        FunctionSkipManager:Get():SkipToFunction(GameFunction.Story)
    end

    if _toID == CommonFestivalGoToType.Challenge then
        FunctionSkipManager:Get():SkipToFunction(GameFunction.SpecialTraining)
    end

end
