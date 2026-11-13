
---@class InitialViewAction:ViewBaseAction
InitialViewAction = class("InitialViewAction",ViewBaseAction)

function InitialViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function InitialViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.InitialView_SelectCar, self.SelectCar)
    self:AddNotificationEvent(UINotifyEvent.InitialView_Sure, self.Sure)
    self:AddNotificationEvent(UINotifyEvent.InitialView_Succeed, self.Succeed)
end

---@return InitialView
function InitialViewAction:View()
    return self.view
end

function InitialViewAction:SelectCar(idx)
    if self:View() then
        self:View():OnClickBtnCar(idx)
    end
end

function InitialViewAction:Sure()
    if self:View() then
        self:View():OnClickBtnSure()
    end
end

function InitialViewAction:Succeed()
    if self:View() then
        self:View():SelectSucceed()
    end
end

return InitialViewAction()