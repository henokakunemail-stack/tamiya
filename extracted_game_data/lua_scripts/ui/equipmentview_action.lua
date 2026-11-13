

---@class EquipmentViewAction:ViewBaseAction
EquipmentViewAction = class("EquipmentViewAction",ViewBaseAction)

function EquipmentViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function EquipmentViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.EquipmentView_UpdateScrollView, self.UpdateScrollView)
    self:AddNotificationEvent(UINotifyEvent.EquipmentView_Refresh, self.RefreshData)
    self:AddNotificationEvent(UINotifyEvent.EquipmentView_UpdateTog, self.UpdateTogView)
    self:AddNotificationEvent(UINotifyEvent.EquipmentView_ClickTog, self.ClickTog)
end

---@return EquipmentView
function EquipmentViewAction:View()
    return self.view
end


function EquipmentViewAction:UpdateScrollView(node)
    if self:View() then
        self:View():UpdateScrollView(node[1], node[2], node[3])
    end
end

function EquipmentViewAction:RefreshData()
    if self:View() then
        --self:View():RefreshData()
    end
end

function EquipmentViewAction:UpdateTogView(node)
    if self:View() then
        self:View():UpdateToggleView(node[1], node[2], node[3])
    end
end

function EquipmentViewAction:ClickTog(type)
    if self:View() then
        self:View():OnClickTog_Type(type)
    end
end

return EquipmentViewAction()