
---@class MiniCarInfoViewAction:ViewBaseAction
MiniCarInfoViewAction = class("MiniCarInfoViewAction",ViewBaseAction)

function MiniCarInfoViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function MiniCarInfoViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.MiniCarInfoViewSetData, self.SetData)
end
---@return MiniCarInfoView
function MiniCarInfoViewAction:View()
    return self.view
end

function MiniCarInfoViewAction:SetData(date)
    if self:View() then
        self:View():SetData(date)
    end
end

return MiniCarInfoViewAction()