


---@class RaceSelfJoinViewAction:ViewBaseAction
RaceSelfJoinViewAction = class("RaceSelfJoinViewAction",ViewBaseAction)

function RaceSelfJoinViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSelfJoinViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceSelfJoinView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfJoinView_ClickBtnJoin, self.ClickBtnJoin)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfJoinView_ClickBtnChangeCar, self.ClickBtnChangeCar)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfJoinView_UpdateScrollView, self.UpdateScrollView)
end

---@return RaceSelfJoinView
function RaceSelfJoinViewAction:View()
    return self.view
end

function RaceSelfJoinViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data)
    end
end

function RaceSelfJoinViewAction:ClickBtnJoin()
    if self:View() then
        self:View():ClickBtnJoin()
    end
end

function RaceSelfJoinViewAction:ClickBtnChangeCar()
    if self:View() then
        self:View():ClickBtnChangeCar()
    end
end

function RaceSelfJoinViewAction:UpdateScrollView(param)
    if self:View() then
        self:View():UpdateScrollView(param[1], param[2])
    end
end

return RaceSelfJoinViewAction()