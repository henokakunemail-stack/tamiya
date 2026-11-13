TestViewAction = class("TestViewAction", ViewBaseAction)

-- Action必加1
function TestViewAction:initialize(  )
	ViewBaseAction.initialize(self)
end

-- Action必加2
function TestViewAction:OnRegisterEvents()
	--self:AddNotificationEvent(UINotifyEvent.OpenTestView, self.OpenTest)
end

-- detail actions ------------------------------------------------------------------------------
function TestViewAction:OpenTest( notifyData )
	UIManager:Get():ShowPersistentView("TestView", CanvasType.MainCanvas, "TestView")
	self.view:Debug()
end

-- Action必加3
return TestViewAction()
