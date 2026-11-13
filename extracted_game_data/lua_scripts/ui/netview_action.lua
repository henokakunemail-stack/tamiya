NetViewAction = class("NetViewAction", NetViewAction)

-- Action必加1
function NetViewAction:initialize(  )
    ViewBaseAction.initialize(self)
end

-- Action必加2
function NetViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.OpenNetWaitingView, self.OpenNetWaiting)
    self:AddNotificationEvent(UINotifyEvent.CloseNetWaitingView, self.CloseNetWaiting)

end

-- detail actions ------------------------------------------------------------------------------
function NetViewAction:OpenNetWaiting( notifyData )
    UIManager:Get():ShowPersistentView("TestView", CanvasType.MainCanvas, "TestView")
    self.view:Debug()
end

function NetViewAction:CloseNetWaiting( notifyData )
    UIManager:Get():ShowPersistentView("TestView", CanvasType.MainCanvas, "TestView")
    self.view:Debug()
end


-- Action必加3
return NetViewAction()