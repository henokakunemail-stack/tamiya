
---@class PlayerLevelUpViewAction:ViewBaseAction
PlayerLevelUpViewAction = class("PlayerLevelUpViewAction",ViewBaseAction)

function PlayerLevelUpViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return PlayerLevelUpView
function PlayerLevelUpViewAction:View()
    return self.view
end
function PlayerLevelUpViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.PlayerLevelUpView_InitViewInfo,self.InitViewInfo)
end

---@param msg SC_NotifyLevelChange
function PlayerLevelUpViewAction:InitViewInfo()
    if self:View() then
      return self:View():InitViewInfo()
    end
end

return PlayerLevelUpViewAction()