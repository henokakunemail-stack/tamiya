



PushViewViewAction = class("PushViewViewAction",ViewBaseAction)

function PushViewViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function PushViewViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ShowTips_Top, self.ShowTips)
end

function PushViewViewAction:ShowTips(param)
    local isshow = UIManager:Get():IsPersistentViewShow("PushView")
    if isshow == false then
        UIManager:Get():ShowPersistentView("PushView", CanvasType.TopCanvas, "PushView")
    end
    self.view:ShowTips(param)
end



return PushViewViewAction()