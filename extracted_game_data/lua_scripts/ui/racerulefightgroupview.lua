


---@class RaceRuleFightGroupViewParam
RaceRuleFightGroupViewParam = class("RaceRuleFightGroupViewParam")

function RaceRuleFightGroupViewParam:initialize()
    self.Type = RaceRuleModule.None
    self.PlayerIdentity = RaceRulePlayerIdentity.None
    self.Title = ""

    self.IsShowCup = false

    ---@type RaceDataFightGroup
    self.FightGroup = nil

    ---@type RaceSelfData
    self.RaceSelfData = nil

end


---@class RaceRuleFightGroupView:ViewBase
RaceRuleFightGroupView = class("RaceRuleFightGroupView", ViewBase)

function RaceRuleFightGroupView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceRuleFightGroupViewAction")

    ---@type RaceRuleFightGroupViewParam
    self.Param = nil
end

function RaceRuleFightGroupView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnChangeCar",self.gameObject,function (hbtn)
        self:ClickBtnChangeCar()
    end)

    CommonHelper:HButtonSetCallback("BtnTry",self.gameObject,function (hbtn)
        self:ClickBtnTry()
    end)

    CommonHelper:HButtonSetCallback("BtnBuyCount",self.gameObject,function (hbtn)
        self:ClickBtnBuy()
    end)

    CommonHelper:HButtonSetCallback("BtnMap",self.gameObject,function (hbtn)
        self:ClickBtnMap()
    end)

    self.BaseGroup = UIUtil.GetChild("RaceRuleBaseInfo",self.gameObject)
    self.FightGroupObj = UIUtil.GetChild("RaceRuleFightGroup",self.gameObject)
end

function RaceRuleFightGroupView:OnOpen()

end

function RaceRuleFightGroupView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceRuleFightGroup)
end

---@param param RaceRuleFightGroupViewParam
function RaceRuleFightGroupView:SetData(param)
    self.Param = param

    self:SetTitle()

    self:SetBaseGroup()

    self:SetFightGroup()

    CommonHelper:SetGameObjectActive("JoinerBtnGroup", self.gameObject, self.Param.PlayerIdentity == RaceRulePlayerIdentity.Joiner)

end

function RaceRuleFightGroupView:SetTitle()
    CommonHelper:SetText("TitleCompoentRed/title1", self.gameObject, self.Param.Title)
end

function RaceRuleFightGroupView:SetBaseGroup()
    if self.Param.Type == RaceRuleModule.Self then
        local baseinfo = Pre_RaceRuleBaseInfo()
        baseinfo:SetRaceSelfData(self.BaseGroup, self.Param.RaceSelfData, UIModuleID.RaceRuleFightGroup)
    end
end

function RaceRuleFightGroupView:SetFightGroup()
    local baseinfo = Pre_RaceRuleFightGroup()
    baseinfo:SetData(self.FightGroupObj, self.Param.FightGroup, UIModuleID.RaceRuleFightGroup, self.IsShowCup)
end



function RaceRuleFightGroupView:ClickBtnChangeCar()
    UIManager:Get():OpenView("RaceSelfSelectCarView",CanvasType.MainCanvas,"RaceSelfSelectCarView")
    local param = {self.Param.RaceSelfData, RaceSelfSelectCarType.ChangeCar}
    UINotify:Get():SendNotification(UINotifyEvent.RaceSelfSelectCarView_SetData, param)
end

function RaceRuleFightGroupView:ClickBtnTry()
    UIManager:Get():OpenView("RaceSelfSelectCarView",CanvasType.MainCanvas,"RaceSelfSelectCarView")
    local param = {self.Param.RaceSelfData, RaceSelfSelectCarType.TryRun}
    UINotify:Get():SendNotification(UINotifyEvent.RaceSelfSelectCarView_SetData, param)
end

function RaceRuleFightGroupView:ClickBtnBuy()

end

function RaceRuleFightGroupView:ClickBtnMap()
    if self.Param.Type == RaceRuleModule.Self then
        UIManager:Get():OpenView("RaceSelfMapView",CanvasType.MainCanvas,"RaceSelfMapView")
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfMapView_SetData, self.Param.RaceSelfData)
    end
end