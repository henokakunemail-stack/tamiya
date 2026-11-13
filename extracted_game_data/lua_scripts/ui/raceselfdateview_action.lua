


---@class RaceSelfDateViewAction:ViewBaseAction
RaceSelfDateViewAction = class("RaceSelfDateViewAction",ViewBaseAction)

function RaceSelfDateViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSelfDateViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SelfRaceDateView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.SelfRaceDateView_ClickTogDate, self.OnClickTogDate)
    self:AddNotificationEvent(UINotifyEvent.SelfRaceDateView_UpdateScrollView, self.UpdateScrollView)
    self:AddNotificationEvent(UINotifyEvent.SelfRaceDateView_ClickScrollItem, self.OnClickBtnScrollItem)
end

---@return RaceSelfDateView
function RaceSelfDateViewAction:View()
    return self.view
end

function RaceSelfDateViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data)
    end
end

function RaceSelfDateViewAction:OnClickTogDate(idx)
    if self:View() then
        self:View():OnClickTogDate(idx)
    end
end

function RaceSelfDateViewAction:UpdateScrollView(param)
    if self:View() then
        self:View():UpdateScrollView(param[1], param[2])
    end
end

function RaceSelfDateViewAction:OnClickBtnScrollItem(idx)
    if self:View() then
        self:View():OnClickBtnScrollItem(idx)
    end
end

return RaceSelfDateViewAction()