


---@class RaceRoomSelectCarViewAction:ViewBaseAction
RaceRoomSelectCarViewAction = class("RaceRoomSelectCarViewAction",ViewBaseAction)

function RaceRoomSelectCarViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceRoomSelectCarViewAction:OnRegisterEvents()
    --self:AddNotificationEvent(UINotifyEvent.RaceRoomSelectCarView_SelectCar, self.SelectCar)
end

---@return RaceRoomSelectCarView
function RaceRoomSelectCarViewAction:View()
    return self.view
end

function RaceRoomSelectCarViewAction:SelectCar()
    if self:View() then
        --self:View():OnClickBtnSelectCar()
    end
end


return RaceRoomSelectCarViewAction()