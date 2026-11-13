---@class DebugViewAction:ViewBaseAction
DebugViewAction = class("DebugViewAction", ViewBaseAction)
-- Action必加1
function DebugViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@return DebugView
function DebugViewAction:View()
    return self.view
end
-- Action必加2
function DebugViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.DebugViewShowLogView, self.ShowLogView)
    self:AddNotificationEvent(UINotifyEvent.DebugViewShowLogView_SetAttrs, self.Attrs)
end

function DebugViewAction:ShowLogView(type)
    if self:View() then
        self:View():PopupException(type)
    end
end
function DebugViewAction:Attrs(data)
    if self:View() then
        self:View():SetAttrs(data)
    end
end

-- Action必加3
return DebugViewAction()
