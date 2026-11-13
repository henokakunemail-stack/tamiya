


---@class GarageTipsViewAction:ViewBaseAction
GarageTipsViewAction = class("GarageTipsViewAction",ViewBaseAction)

function GarageTipsViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function GarageTipsViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.GarageTipsView_SetData, self.SetData)
end

---@return GarageTipsView
function GarageTipsViewAction:View()
    return self.view
end

function GarageTipsViewAction:SetData(param)
    if self:View() then
        self:View():SetData(param[1], param[2], param[3])
    end
end

return GarageTipsViewAction()