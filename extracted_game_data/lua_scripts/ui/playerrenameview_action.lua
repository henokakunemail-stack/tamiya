---@class PlayerRenameViewAction:ViewBaseAction
PlayerRenameViewAction = class("PlayerRenameViewAction",ViewBaseAction)

function PlayerRenameViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function PlayerRenameViewAction:OnRegisterEvents()
    --self:AddNotificationEvent(UINotifyEvent.CommonInputView_SetData, self.SetData)
end

---@return PlayerRenameView
function PlayerRenameViewAction:View()
    return self.view
end

function PlayerRenameViewAction:SetData(param)
    if self:View() then
        self:View():SetData(param)
    end
end

return PlayerRenameViewAction()