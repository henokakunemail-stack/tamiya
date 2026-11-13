


---@class RaceSelfCreateView : ViewBase
RaceSelfCreateView = class("RaceSelfCreateView", ViewBase)

function RaceSelfCreateView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceSelfCreateViewAction")
end

function RaceSelfCreateView:Awake()
    self.Page1 = UIUtil.GetChildInputPath("Group1", self.gameObject)
    self.Page2 = UIUtil.GetChildInputPath("Group2", self.gameObject)
    self.Page3 = UIUtil.GetChildInputPath("Group3", self.gameObject)
    self.Page4 = UIUtil.GetChildInputPath("Group4", self.gameObject)

    self.TogStep = {}
    for i = 1, 4 do
        self.TogStep[i] = UIUtil.GetTypeChildWightByParent("TogStep"..i, self.gameObject, typeof(HButton))
    end

    CommonHelper:HButtonSetCallback("BtnHelp",self.gameObject,function (hbtn)
        --CommonHelper:ShowHelpView(UIColor.Red, PageDetailType.RaceSelf_Create)
    end)
    CommonHelper:HButtonSetCallback("BtnNext",self.Page1,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfCreateView_ClickBtnStep, 2)
    end)
    CommonHelper:HButtonSetCallback("BtnNext",self.Page2,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfCreateView_ClickBtnStep, 3)
    end)
    CommonHelper:HButtonSetCallback("BtnNext",self.Page3,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfCreateView_ClickBtnStep, 4)
    end)
    CommonHelper:HButtonSetCallback("BtnNext",self.Page4,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfCreateView_ClickBtnCreate)
    end)
    CommonHelper:HButtonSetCallback("BtnBack",self.Page1,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnLast",self.Page2,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfCreateView_ClickBtnStep, 1)
    end)
    CommonHelper:HButtonSetCallback("BtnLast",self.Page3,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfCreateView_ClickBtnStep, 2)
    end)
    CommonHelper:HButtonSetCallback("BtnLast",self.Page4,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.RaceSelfCreateView_ClickBtnStep, 3)
    end)
end

function RaceSelfCreateView:OnOpen()
    self:SetTogStep(1)

    self:ClickBtnStep(1,true)
end

function RaceSelfCreateView:OnClose()
    for i = 1, 4 do
        self:ClickBtnStep(i,true)
    end

    CommonHelper:ReleasePool(UIModuleID.RaceSelfCreate)
end

function RaceSelfCreateView:SetTogStep(idx)
    for i = 1, #self.TogStep do
        CommonHelper:SetToggleState(self.TogStep[i], i == idx, true)
    end
end

function RaceSelfCreateView:SetPageGroup(idx)
    self.Page1:SetActive(idx == 1)
    self.Page2:SetActive(idx == 2)
    self.Page3:SetActive(idx == 3)
    self.Page4:SetActive(idx == 4)
    self:SetTogStep(idx)
end

function RaceSelfCreateView:ClickBtnStep(idx, default)
    if idx == 1 then self:SetStep1(default) end
    if idx == 2 then self:SetStep2(default) end
    if idx == 3 then self:SetStep3(default) end
    if idx == 4 then self:SetStep4(default) end
end

function RaceSelfCreateView:ClickBtnCreate()
    ---@type SC_SC_CreateGameInfo
    local param = {}
    param.raceType = self.Param_Flag
    param.enterNum = self.Param_RuleType
    param.configId = self.Param_CostID
    param.name = CommonHelper:GetInputFieldText("InputName", self.Page4)
    param.maxNum = self.Param_JoinerMax
    param.times = {
        num1 = self.Param_Time[1] * 1000,
        num2 = self.Param_Time[2] * 1000,
        num3 = self.Param_Time[3] * 1000,
        num4 = self.Param_Time[4] * 1000,
        num5 = self.Param_Time[5] * 1000,
    }
    param.trackId = self.Param_TrackData:GetId()
    param.sceneId = 29000001
    RaceSelfSubsystem:Get():SendMsg_CreateRace(param)


end

