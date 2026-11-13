---@class LabChoosePropViewAction:ViewBaseAction
LabChoosePropViewAction = class("LabChoosePropViewAction", ViewBaseAction)

function LabChoosePropViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@return LabChoosePropView
function LabChoosePropViewAction:View()
    return self.view
end

function LabChoosePropViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.LabChooseProp_SetData, self.SetData)
end

function LabChoosePropViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data[1], data[2])
    end
end
return LabChoosePropViewAction()

