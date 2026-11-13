


---@class RaceRuleResultViewParam
RaceRuleResultViewParam = class("RaceRuleResultViewParam")
function RaceRuleResultViewParam:initialize()
    self.Type = RaceRuleModule.None
    self.PlayerIdentity = RaceRulePlayerIdentity.None
    self.Title = ""
    self.ScoreTips = ""

    ---@type RaceDataPlayer
    self.Winer = nil
    ---@type RaceSelfData
    self.RaceSelfData = nil
end


---@class RaceRuleResultView:ViewBase
RaceRuleResultView = class("RaceRuleResultView", ViewBase)

function RaceRuleResultView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceRuleResultViewAction")

    ---@type RaceRuleResultViewParam
    self.Param = nil
end

function RaceRuleResultView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnMap",self.gameObject,function (hbtn)
        self:ClickBtnMap()
    end)

    self.BaseGroup = UIUtil.GetChild("RaceRuleBaseInfo",self.gameObject)
end

function RaceRuleResultView:OnOpen()

end

function RaceRuleResultView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceRuleResult)
end

---@param param RaceRuleResultViewParam
function RaceRuleResultView:SetData(param)
    self.Param = param

    self:SetTitle()

    self:SetBaseGroup()

    self:SetRankInfo()
end


function RaceRuleResultView:SetTitle()
    CommonHelper:SetText("TitleCompoentRed/title1", self.gameObject, self.Title)
end

function RaceRuleResultView:SetBaseGroup()
    if self.Param.Type == RaceRuleModule.Self then
        local baseinfo = Pre_RaceRuleBaseInfo()
        baseinfo:SetRaceSelfData(self.BaseGroup, self.Param.RaceSelfData, UIModuleID.RaceRuleResult)
    end
end

function RaceRuleResultView:SetRankInfo()
    local obj = UIUtil.GetChild("RaceRuleResult", self.gameObject)
    local baseinfo = Pre_RaceRuleResult()
    baseinfo:SetData(obj, self.Param.PlayerIdentity, self.Param.ScoreTips, self.Param.Winer)
end

function RaceRuleResultView:ClickBtnMap()
    if self.Param.Type == RaceRuleModule.Self then
        UIManager:Get():OpenView("RaceSelfMapView",CanvasType.MainCanvas,"RaceSelfMapView")
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfMapView_SetData, self.Param.RaceSelfData)
    end
end
