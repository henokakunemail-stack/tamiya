---@class LabResolvePropViewAction:ViewBaseAction
LabResolvePropViewAction = class("LabResolvePropViewAction", ViewBaseAction)

function LabResolvePropViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@return LabResolvePropView
function LabResolvePropViewAction:View()
    return self.view
end

function LabResolvePropViewAction:OnRegisterEvents()
    --self:AddNotificationEvent(UINotifyEvent.LaboratoryTireView_UpdateOnePartComposeUI, self.UpdateOnePartComposeUI)
end

function LabResolvePropViewAction:InitOnePartComposeUI(curSelectPropType)
    if self:View() then
      --  self:View():InitOnePartComposeUI(curSelectPropType)
    end
end

return LabResolvePropViewAction()


