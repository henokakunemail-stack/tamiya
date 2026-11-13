
---@class NewPlayerSelectCarViewAction:ViewBaseAction
NewPlayerSelectCarViewAction = class("NewPlayerSelectCarViewAction",ViewBaseAction)

function NewPlayerSelectCarViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function NewPlayerSelectCarViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.NewPlayerSelectCarViewSetData, self.SetData)
end

---@return NewPlayerSelectCarView
function NewPlayerSelectCarViewAction:View()
    return self.view
end

function NewPlayerSelectCarViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data[1],data[2])
    end
end

return NewPlayerSelectCarViewAction()