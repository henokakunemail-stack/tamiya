


---@class RaceSelfHistoryViewAction:ViewBaseAction
RaceSelfHistoryViewAction = class("RaceSelfHistoryViewAction",ViewBaseAction)

function RaceSelfHistoryViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSelfHistoryViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceSelfHistoryView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfHistoryView_ClickTog, self.ClickTog)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfHistoryView_UpdateScrollJoin, self.UpdateScrollJoin)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfHistoryView_ClickItemJoin, self.ClickItemJoin)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfHistoryView_UpdateScrollCreate, self.UpdateScrollCreate)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfHistoryView_ClickItemCreate, self.ClickItemCreate)
end

---@return RaceSelfHistoryView
function RaceSelfHistoryViewAction:View()
    return self.view
end

function RaceSelfHistoryViewAction:SetData(msg)
    if self:View() then
        self:View():SetData(msg)
    end
end

function RaceSelfHistoryViewAction:ClickTog(idx)
    if self:View() then
        self:View():OnClickTog(idx)
    end
end

function RaceSelfHistoryViewAction:UpdateScrollJoin(param)
    if self:View() then
        self:View():UpdateScrollJoin(param[1], param[2])
    end
end

function RaceSelfHistoryViewAction:ClickItemJoin(idx)
    if self:View() then
        self:View():ClickItemJoin(idx)
    end
end

function RaceSelfHistoryViewAction:UpdateScrollCreate(param)
    if self:View() then
        self:View():UpdateScrollCreate(param[1], param[2])
    end
end

function RaceSelfHistoryViewAction:ClickItemCreate(idx)
    if self:View() then
        self:View():ClickItemCreate(idx)
    end
end

return RaceSelfHistoryViewAction()