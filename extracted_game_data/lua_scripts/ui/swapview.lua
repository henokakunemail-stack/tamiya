local __AddNum = 0
local __AddMax = 0

---@type PVELevelData
local __LevelData = nil

---@class SwapView : ViewBase
SwapView = class("SwapView", ViewBase)

function SwapView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SwapViewAction")
end
local isUseArticle=false
function SwapView:Awake()
    isUseArticle=false
    local Normal= CommonHelper:SetGameObjectActive("Normal",self.gameObject,isUseArticle)
    local CN=CommonHelper:SetGameObjectActive("CN",self.gameObject,not isUseArticle)
    self.Root=Normal
    if not isUseArticle then
        self.Root=CN
    end
    CommonHelper:HButtonSetCallback("BtnClose", self.Root, function(hbtn)
        UIManager:Get():ClosePopup()
    end)

    CommonHelper:HButtonSetCallback("BtnSure", self.Root, function(hbtn)
        self:OnEnsureBtnClick()
    end)

    CommonHelper:HButtonSetCallback("BtnEditorRemove", self.Root, function(hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.SwapView_ClickNum, -1)
    end)

    CommonHelper:HButtonSetCallback("BtnEditorAdd", self.Root, function(hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.SwapView_ClickNum, 1)
    end)

    CommonHelper:HButtonSetCallback("BtnEditorMax", self.Root, function(hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.SwapView_ClickNum, __AddMax)
    end)

    self.Input = UIUtil.GetTypeChildWightInputPath("UseNumInput", self.Root, typeof(InputField))
end

function SwapView:OnEnsureBtnClick()
    local temp = __AddNum * self.PayPower
    if temp > PlayerDataManager:Get():GetPlayerStamina() then
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.PowerNotEnough))
        return
    end

    ---@type dictcalc_config_cell
    local value = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.SwapTicket)
    local costcount = KnapsackDataManager:Get():GetArticleCountByCfgid(tonumber(value.varval))
    if  isUseArticle then
        if costcount<=0 or costcount < __AddNum then
            CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.SwapNoMoney))
            return
        end
    end
    if __LevelData.levelCfg.maxenter>0 and __LevelData.count>= __LevelData.levelCfg.maxenter  then
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ChapterLevelNoPassNum))
        return
    end
    if __LevelData.chapterType==PveType.Chapter and __AddNum>0 then
        ChapterSubsystem:Get():SendMsg_Swap(__LevelData.id, __AddNum)
    end
    if __LevelData.chapterType==PveType.RaceSeniorTrain then
        RaceSeniorTrainSubsystem:Get():SendMsg_Swap(__LevelData.id, __AddNum)
    end

end

function SwapView:OnClose()

end

function SwapView:SetData(data)
    __AddNum = 0

    if data~=nil then
        __LevelData = data
    end
    self.PayPower= __LevelData.levelCfg.paypower
    -----@type dictcalc_config_cell
    local value = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.SwapTicket)
    if not isUseArticle then
        __AddMax=10
    else
        __AddMax = KnapsackDataManager:Get():GetArticleCountByCfgid(tonumber(value.varval))
    end






    __AddMax = __AddMax >= 10 and 10 or __AddMax
    if __LevelData.levelCfg.maxenter>0 then __AddMax = __AddMax >= __LevelData.levelCfg.maxenter-__LevelData.count and __LevelData.levelCfg.maxenter-__LevelData.count or __AddMax end
    if __AddMax* __LevelData.levelCfg.paypower>PlayerDataManager:Get():GetPlayerStamina() then
        __AddMax=math.floor(PlayerDataManager:Get():GetPlayerStamina()/__LevelData.levelCfg.paypower)
    end

    self:OnClickBtn_Num(__AddNum)
end

function SwapView:SetCost()
    CommonHelper:SetInputFieldTextByGo(self.Input, string.format("%d/%d", __AddNum, __AddMax))

    local curStamina = PlayerDataManager:Get():GetPlayerStamina()
    local consumeStamina = __AddNum * self.PayPower
    ---@type dictcalc_config_cell
    local value = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.SwapTicket)
    local ticketCount = KnapsackDataManager:Get():GetArticleCountByCfgid(tonumber(value.varval))

    CommonHelper:SetText("###PropCountText", self.Root, tostring(ticketCount))
    local obj = self:GetChild("ItemArticleCom")
    local param = Param_PropParam()
    param.id = tonumber(value.varval)
    param.moduleId = UIModuleID.Swap
    param.showname = true
    param.count = -1
    CommonHelper:SetPropGroup(obj, param)

    ---@type dictarticle_config_cell
    local articleData = CommonHelper:GetTableDataByID(ConfigNames.article_config, tonumber(value.varval))
    if articleData then
        CommonHelper:SetText("###PropInfoText", self.Root, ClientDataManager:Get():GetTemplateString(articleData.description))
    end
    CommonHelper:SetText("###PropPriceText", self.Root, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.NumComNum), consumeStamina, curStamina))
end

function SwapView:OnClickBtn_Num(num)
    __AddNum = __AddNum + num

    __AddNum = __AddNum < 1 and 1 or __AddNum
    __AddNum = __AddNum > __AddMax and __AddMax or __AddNum

    self:SetCost()
end

function SwapView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.Swap)
end

