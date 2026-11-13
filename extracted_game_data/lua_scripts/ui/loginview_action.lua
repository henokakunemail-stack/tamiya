
---@class LoginViewAction
LoginViewAction = class("LoginViewAction",ViewBaseAction)

function LoginViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function LoginViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.LoginView_OpenLoginView, self.OpenLoginView)
    self:AddNotificationEvent(UINotifyEvent.LoginView_OpenLogoutView,self.OpenLogoutView)
    self:AddNotificationEvent(UINotifyEvent.LoginView_OpenInputNameView,self.OpenInputNameView)
    self:AddNotificationEvent(UINotifyEvent.LoginView_InitBtn,self.InitBtn)
end
---@return loginview
function LoginViewAction:View()
   return self.view
end
function LoginViewAction:OpenLoginView()
    --if self:View() then
        print("LoginViewAction")
        UIManager:Get():OpenView("LoginView", CanvasType.MainCanvas, "LoginView", false)
    --end
end



function LoginViewAction:OpenLogoutView()
    --if self:View() then
        UIManager:Get():OpenView("LoginView", CanvasType.FrontCanvas, "LoginView", false)
    --end
end

function LoginViewAction:OpenInputNameView()
    --if self:View() then
        self:View():OpenInputName()
    --end
end

function LoginViewAction:InitBtn(isEnable)
    --if self:View() then
        self:View():InitBtn(isEnable)
   -- end
end


return LoginViewAction()