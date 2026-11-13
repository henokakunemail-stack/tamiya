


---@class PlayRollViewAction:ViewBaseAction
PlayRollViewAction = class("PlayRollViewAction",ViewBaseAction)

function PlayRollViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function PlayRollViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.TopLeftInfoView_UpdateRollText_System,self.UpdateRollText_System)
    self:AddNotificationEvent(UINotifyEvent.TopLeftInfoView_UpdateRollText_Player,self.UpdateRollText_Player)
end

---@return PlayRollView
function PlayRollViewAction:View()
    return self.view
end

function PlayRollViewAction:UpdateRollText_System()
    if self:View() then
        self:View():UpdateRollText_System()
    end
end

function PlayRollViewAction:UpdateRollText_Player()
    if self:View() then
        self:View():UpdateRollText_Player()
    end
end

return PlayRollViewAction()