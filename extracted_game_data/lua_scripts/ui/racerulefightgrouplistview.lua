


---@class RaceRuleFightGroupListViewParam
RaceRuleFightGroupListViewParam = class("RaceRuleFightGroupListViewParam")
function RaceRuleFightGroupListViewParam:initialize()
    self.Type = RaceRuleModule.None

    self.Title = ""
    ---@type table<number, RaceDataFightGroup>
    self.GroupList = {}

    ---@type RaceSelfData
    self.RaceSelfData = nil
end


---@class RaceRuleFightGroupListView:ViewBase
RaceRuleFightGroupListView = class("RaceRuleFightGroupListView", ViewBase)

function RaceRuleFightGroupListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceRuleFightGroupListViewAction")

    ---@type RaceRuleFightGroupListViewParam
    self.Param = nil
end

function RaceRuleFightGroupListView:Awake()
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnMap",self.gameObject,function (hbtn)
        self:ClickBtnMap()
    end)

    self.BaseGroup = UIUtil.GetChild("RaceRuleBaseInfo",self.gameObject)
    self.GourpListObj = UIUtil.GetChild("RaceRuleFightGroupList",self.gameObject)
end

function RaceRuleFightGroupListView:OnOpen()

end

function RaceRuleFightGroupListView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceRuleFightGroupList)
end

function RaceRuleFightGroupListView:SetData(param)
    self.Param = param

    self:SetTitle()

    self:SetBaseGroup()

    self:SetFightGroup()
end

function RaceRuleFightGroupListView:SetTitle()
    CommonHelper:SetText("TitleCompoentRed/title1", self.gameObject, self.Param.Title)
end

function RaceRuleFightGroupListView:SetBaseGroup()
    if self.Param.Type == RaceRuleModule.Self then
        local baseinfo = Pre_RaceRuleBaseInfo()
        baseinfo:SetRaceSelfData(self.BaseGroup, self.Param.RaceSelfData, UIModuleID.RaceRuleFightGroupList)
    end
end

function RaceRuleFightGroupListView:SetFightGroup()
    local playernum = 1
    if self.Param.Type == RaceRuleModule.Self then playernum = self.Param.RaceSelfData.RaceType end

    local baseinfo = Pre_RaceRuleFightGroupList()
    baseinfo:SetData(self.GourpListObj, playernum, self.Param.GroupList , UIModuleID.RaceRuleFightGroupList)
end

function RaceRuleFightGroupListView:ClickBtnMap()
    if self.Param.Type == RaceRuleModule.Self then
        UIManager:Get():OpenView("RaceSelfMapView",CanvasType.MainCanvas,"RaceSelfMapView")
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfMapView_SetData, self.Param.RaceSelfData)
    end
end