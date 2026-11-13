HelloViewAction = class("HelloViewAction", ViewBaseAction)

-- Action必加1
function HelloViewAction:initialize(  )
	ViewBaseAction.initialize(self)
end

-- Action必加2
function HelloViewAction:OnRegisterEvents()
	--self:AddNotificationEvent(UINotifyEvent.OpenHelloWorldView, self.OpenHelloworld)
end

-- detail actions ------------------------------------------------------------------------------
function HelloViewAction:OpenHelloworld( notifyData )
	UIManager:Get():ShowPersistentView("HelloView", CanvasType.MainCanvas, "HelloView")
	self.view:Debug()
end

-- Action必加3
return HelloViewAction()
