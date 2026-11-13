---@class ARMainViewAction:ViewBaseAction
ARMainViewAction = class("ARMainViewAction", ViewBaseAction)

function ARMainViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ARMainViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ARState_Update, self.ARState_Update)
end

---@return ARMainView
function ARMainViewAction:View()
    return self.view
end

function ARMainViewAction:ARState_Update()
    if self:View()~=nil then
        self:View():ARState_Update()
    end
end

return ARMainViewAction()