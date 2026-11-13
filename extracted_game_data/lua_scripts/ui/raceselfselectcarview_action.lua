


---@class RaceSelfSelectCarViewAction:ViewBaseAction
RaceSelfSelectCarViewAction = class("RaceSelfSelectCarViewAction",ViewBaseAction)

function RaceSelfSelectCarViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSelfSelectCarViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceSelfSelectCarView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfSelectCarView_SelectCar, self.SelectCar)
end

---@return RaceSelfSelectCarView
function RaceSelfSelectCarViewAction:View()
    return self.view
end

function RaceSelfSelectCarViewAction:SetData(param)
    if self:View() then
        self:View():SetData(param)
    end
end

function RaceSelfSelectCarViewAction:SelectCar()
    if self:View() then
        self:View():OnClickBtnSelectCar()
    end
end

return RaceSelfSelectCarViewAction()