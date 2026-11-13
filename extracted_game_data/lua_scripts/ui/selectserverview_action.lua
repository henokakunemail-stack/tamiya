
---@class SelectServerViewAction:ViewBaseAction
SelectServerViewAction = class("SelectServerViewAction",ViewBaseAction)

function SelectServerViewAction:initialize()
    ViewBaseAction.initialize(self)
end
function SelectServerViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SetSelectServerInfo, self.SetData)
end
---@return SelectServerView
function SelectServerViewAction:View()
    return self.view
end
---@return SelectServerView
function SelectServerViewAction:SetData(id)
    if self:View() then
        self:View():SetData(id)
    end
end



return SelectServerViewAction()