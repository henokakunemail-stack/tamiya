---@class PartAwakeSuccessViewAction:ViewBaseAction
PartAwakeSuccessViewAction = class("PartAwakeSuccessViewAction", ViewBaseAction)

function PartAwakeSuccessViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@return PartAwakeSuccessView
function PartAwakeSuccessViewAction:View()
    return self.view
end

function PartAwakeSuccessViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.Part_AwakeResultSetData, self.SetData)
end

function PartAwakeSuccessViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data[1],data[2],data[3])
    end
end


return PartAwakeSuccessViewAction()

