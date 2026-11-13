


---@class RaceSelfCreateViewAction:ViewBaseAction
RaceSelfCreateViewAction = class("RaceSelfCreateViewAction",ViewBaseAction)

function RaceSelfCreateViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSelfCreateViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceSelfCreateView_ClickBtnStep, self.ClickBtnStep)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfCreateView_ClickBtnCreate, self.ClickBtnCreate)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfCreateView_Step1_ClickTog, self.Step1_SelectTog)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfCreateView_Step2_ClickTogType, self.Step2_ClickTogType)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfCreateView_Step2_ClickTogNum, self.Step2_ClickTogNum)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfCreateView_Step2_SelectTrack, self.Step2_SelectTrack)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfCreateView_Step2_ClickBtnReview, self.Step2_ClickBtnReview)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfCreateView_Step3_UpdateDate, self.Step3_UpdateDate)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfCreateView_Step4_ClickTogCost, self.Step4_ClickTogCost)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfCreateView_Step4_UpdateScrollView, self.Step4_UpdateScrollView)
end

---@return RaceSelfCreateView
function RaceSelfCreateViewAction:View()
    return self.view
end

function RaceSelfCreateViewAction:ClickBtnStep(idx)
    if self:View() then
        self:View():ClickBtnStep(idx, true)
    end
end

function RaceSelfCreateViewAction:ClickBtnCreate()
    if self:View() then
        self:View():ClickBtnCreate()
    end
end

function RaceSelfCreateViewAction:Step1_SelectTog(idx)
    if self:View() then
        self:View():Step1_SelectTog(idx)
    end
end

function RaceSelfCreateViewAction:Step2_ClickTogType(idx)
    if self:View() then
        self:View():Step2_ClickTogType(idx)
    end
end

function RaceSelfCreateViewAction:Step2_ClickTogNum(idx)
    if self:View() then
        self:View():Step2_ClickTogNum(idx)
    end
end

function RaceSelfCreateViewAction:Step2_SelectTrack(node)
    if self:View() then
        self:View():Step2_SelectTrack(node)
    end
end

function RaceSelfCreateViewAction:Step2_ClickBtnReview()
    if self:View() then
        self:View():Step2_ClickBtnReview()
    end
end

function RaceSelfCreateViewAction:Step3_UpdateDate()
    if self:View() then
        self:View():ClickBtnStep(3)
    end
end

function RaceSelfCreateViewAction:Step4_ClickTogCost(idx)
    if self:View() then
        self:View():Step4_ClickTogCost(idx)
    end
end

function RaceSelfCreateViewAction:Step4_UpdateScrollView(param)
    if self:View() then
        self:View():Step4_UpdateScrollView(param[1], param[2])
    end
end

return RaceSelfCreateViewAction()