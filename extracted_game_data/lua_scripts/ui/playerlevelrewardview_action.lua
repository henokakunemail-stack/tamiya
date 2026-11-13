
---@class PlayerLevelRewardViewAction:ViewBaseAction
PlayerLevelRewardViewAction = class("PlayerLevelRewardViewAction",ViewBaseAction)

function PlayerLevelRewardViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return PlayerLevelRewardView
function PlayerLevelRewardViewAction:View()
    return self.view
end
function PlayerLevelRewardViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.PlayerLevelRewardUpdate,self.InitViewInfo)
end


function PlayerLevelRewardViewAction:InitViewInfo()
    if self:View() then
        self:View():SetData()
    end
end

return PlayerLevelRewardViewAction()