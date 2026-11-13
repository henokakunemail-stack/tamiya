
---@class PlayerInfoSelectCarViewAction:ViewBaseAction
PlayerInfoSelectCarViewAction = class("PlayerInfoSelectCarViewAction",ViewBaseAction)

function PlayerInfoSelectCarViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return PlayerInfoSelectCarView
function PlayerInfoSelectCarViewAction:View()
    return self.view
end
function PlayerInfoSelectCarViewAction:OnRegisterEvents()

    self:AddNotificationEvent(UINotifyEvent.PlayerInfoView_SelectCarOpen,self.AutoSelect)

end
function PlayerInfoSelectCarViewAction:AutoSelect(index)
    self:View():AutoSelect(index)
end

return PlayerInfoSelectCarViewAction()