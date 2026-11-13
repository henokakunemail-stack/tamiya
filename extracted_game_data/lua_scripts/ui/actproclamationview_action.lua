----@class ActProclamationViewAction
ActProclamationViewAction = class("ActProclamationViewAction", ViewBaseAction)

function ActProclamationViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ActProclamationViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ActAdvanceNotice_RefreshTitleState, self.RefreshTitleState)
    self:AddNotificationEvent(UINotifyEvent.ActAdvanceNotice_RefreshTitleSystem, self.RefreshTitleSystem)
    self:AddNotificationEvent(UINotifyEvent.ActAdvanceNotice_RefreshTitleRace, self.RefreshTitleRace)

end

---@return  ActProclamationView
function ActProclamationViewAction:View()
    return self.view
end

function ActProclamationViewAction:RefreshTitleState(Data)
    if self:View() then
        self:View():RefreshTitleState(Data)
    end
end

function ActProclamationViewAction:RefreshTitleSystem()
    if self:View() then
        self:View():RefreshTitleSystem()
    end
end

function ActProclamationViewAction:RefreshTitleRace()
    if self:View() then
        self:View():RefreshTitleSystem()
    end
end

return ActProclamationViewAction()