


---@class RaceRuleSiftViewParam
RaceRuleSiftViewParam = class("RaceRuleSiftViewParam")

function RaceRuleSiftViewParam:initialize()
    self.Type = RaceRuleModule.None
    self.PlayerIdentity = RaceRulePlayerIdentity.None
    self.Title = ""

    ---@type RaceDataPlayer
    self.MyData = nil
    ---@type table<number, RaceDataPlayer>
    self.PlayerList = {}

    ---@type RaceSelfData
    self.RaceSelfData = nil

end


---@class RaceRuleSiftView:ViewBase
RaceRuleSiftView = class("RaceRuleSiftView", ViewBase)

function RaceRuleSiftView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceRuleSiftViewAction")

    ---@type RaceRuleSiftViewParam
    self.Param = nil
end

function RaceRuleSiftView:Awake()
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
    self.SiftGroup = UIUtil.GetChild("RaceRuleSift",self.gameObject)
end

function RaceRuleSiftView:OnOpen()

end

function RaceRuleSiftView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceRuleSift)
end

function RaceRuleSiftView:SetData(param)
    self.Param = param

    self:SetTitle()

    self:SetBaseGroup()

    self:SetFightGroup()

    CommonHelper:SetGameObjectActive("JoinerBtnGroup", self.gameObject, self.Param.PlayerIdentity == RaceRulePlayerIdentity.Joiner)
end

function RaceRuleSiftView:SetTitle()
    CommonHelper:SetText("TitleCompoentRed/title1", self.gameObject, self.Param.Title)
end

function RaceRuleSiftView:SetBaseGroup()
    if self.Param.Type == RaceRuleModule.Self then
        local baseinfo = Pre_RaceRuleBaseInfo()
        baseinfo:SetRaceSelfData(self.BaseGroup, self.Param.RaceSelfData, UIModuleID.RaceRuleSift)
    end
end

function RaceRuleSiftView:SetFightGroup()
    local limit = -1
    if self.Param.Type == RaceRuleModule.Self then limit = self.Param.RaceSelfData:GetSiftLimit() end

    local baseinfo = Pre_RaceRuleSift()
    baseinfo:SetData(self.SiftGroup, self.Param.MyData, self.Param.PlayerList, limit, UIModuleID.RaceRuleSift)
end



function RaceRuleSiftView:ClickBtnChangeCar()
    UIManager:Get():OpenView("RaceSelfSelectCarView",CanvasType.MainCanvas,"RaceSelfSelectCarView")
    local param = {self.Param.RaceSelfData, RaceSelfSelectCarType.ChangeCar}
    UINotify:Get():SendNotification(UINotifyEvent.RaceSelfSelectCarView_SetData, param)
end

function RaceRuleSiftView:ClickBtnTry()
    UIManager:Get():OpenView("RaceSelfSelectCarView",CanvasType.MainCanvas,"RaceSelfSelectCarView")
    local param = {self.Param.RaceSelfData, RaceSelfSelectCarType.TryRun}
    UINotify:Get():SendNotification(UINotifyEvent.RaceSelfSelectCarView_SetData, param)
end

function RaceRuleSiftView:ClickBtnBuy()

end

function RaceRuleSiftView:ClickBtnMap()
    if self.Param.Type == RaceRuleModule.Self then
        UIManager:Get():OpenView("RaceSelfMapView",CanvasType.MainCanvas,"RaceSelfMapView")
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfMapView_SetData, self.Param.RaceSelfData)
    end
end