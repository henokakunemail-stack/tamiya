---@class InheritFilterViewAction:ViewBaseAction
InheritFilterViewAction = class("InheritFilterViewAction",ViewBaseAction)

function InheritFilterViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function InheritFilterViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.InheritFilterView_SetData,self.SetData)
end

---@return InheritFilterView
function InheritFilterViewAction:View()
    return self.view
end

function InheritFilterViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data[1],data[2])
    end
end

return InheritFilterViewAction()