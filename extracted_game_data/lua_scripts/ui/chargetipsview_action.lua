---@class ChargeTipsViewAction:ViewBaseAction
ChargeTipsViewAction = class("ChargeTipsViewAction", ViewBaseAction)

function ChargeTipsViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ChargeTipsViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ChargeTipsSetData, self.SetData)
end

---@return ChargeTipsView
function ChargeTipsViewAction:View()
    return self.view
end

function ChargeTipsViewAction:SetData( )
    if self:View() then
        self:View():SetData( )
    end
end

return ChargeTipsViewAction()
