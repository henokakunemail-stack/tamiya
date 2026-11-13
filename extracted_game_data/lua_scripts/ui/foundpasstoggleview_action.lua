---@class FoundPassToggleViewAction:ViewBaseAction
FoundPassToggleViewAction = class("FoundPassToggleViewAction", ViewBaseAction)

function FoundPassToggleViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return FoundPassToggleView
function FoundPassToggleViewAction:View()
    return self.view
end

function FoundPassToggleViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.FoundPassToggleView_SetToggle,self.SetToggle)
    self:AddNotificationEvent(UINotifyEvent.FoundPassToggleView_CloseView,self.CloseView)
end
function FoundPassToggleViewAction:SetToggle(msg)
    if not UIManager:Get():IsPersistentViewShow("FoundPassToggleView") then
        UIManager:Get():ShowPersistentView("FoundPassToggleView", CanvasType.FrontCanvas, "FoundPassToggleView")
    end
   self:View():SetToggle(msg[1],msg[2])
end
function FoundPassToggleViewAction:CloseView(msg)
   self:View():CloseView()
end



return FoundPassToggleViewAction()