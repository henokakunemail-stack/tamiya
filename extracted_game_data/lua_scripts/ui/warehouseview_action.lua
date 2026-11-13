---@class WarehouseAction:ViewBaseAction
WarehouseViewAction = class("WarehouseViewAction", ViewBaseAction)

function WarehouseViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function WarehouseViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.AccessoryWarehouseView_InitData, self.InitData)
    self:AddNotificationEvent(UINotifyEvent.AccessoryWarehouseView_RefreshData, self.Refresh)

end

---@return WarehouseView
function WarehouseViewAction:View()
    return self.view
end

function WarehouseViewAction:InitData(flag)
    if self:View() then
        self:View():SetScrollViewPart(false,flag)
    end
end

function WarehouseViewAction:Refresh()
    if self:View() then
        self:View():SetScrollViewPart(true)
    end
end

return WarehouseViewAction()