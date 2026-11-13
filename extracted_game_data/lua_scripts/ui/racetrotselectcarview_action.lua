---@class RaceTrotSelectCarViewAction:ViewBaseAction
RaceTrotSelectCarViewAction = class("RaceTrotSelectCarViewAction",ViewBaseAction)

function RaceTrotSelectCarViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceTrotSelectCarViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RankTrotSelectCar_SetData, self.SetData)
end

---@return RaceTrotSelectCarView
function RaceTrotSelectCarViewAction:View()
    return self.view
end

function RaceTrotSelectCarViewAction:SetData()
    if self:View() then
        self:View():SetData()
    end
end

return RaceTrotSelectCarViewAction()