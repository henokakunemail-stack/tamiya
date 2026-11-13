
---@class PlayerTipsViewAction:ViewBaseAction
PlayerTipsViewAction = class("PlayerTipsViewAction",ViewBaseAction)

function PlayerTipsViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return PlayerTipsView
function PlayerTipsViewAction:View()
    return self.view
end
function PlayerTipsViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.PlayerTipsView_SetData, self.SetData)
end


function PlayerTipsViewAction:SetData(param)
    if self:View() then
        self:View():SetData(param)
    end
end
return PlayerTipsViewAction()