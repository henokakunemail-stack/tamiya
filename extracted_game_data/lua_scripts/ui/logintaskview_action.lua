----@class LoginTaskViewAction
LoginTaskViewAction = class("LoginTaskViewAction",ViewBaseAction)

function LoginTaskViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function LoginTaskViewAction:OnRegisterEvents()
    --self:AddNotificationEvent(UINotifyEvent.OpenLoginView, self.OpenLoginView)
    self:AddNotificationEvent(UINotifyEvent.LoginNoviceTaskView_RefreshCurView, self.RefreshCurNoviceView)
    self:AddNotificationEvent(UINotifyEvent.LoginNoviceTaskView_SetData, self.SetNoviceData)
    self:AddNotificationEvent(UINotifyEvent.LoginTaskSignView_InitTaskLoginInfo, self.InitTaskLoginInfo)
    self:AddNotificationEvent(UINotifyEvent.LoginTaskSignView_RefreshLoginInfo, self.RefreshTaskLoginInfo)
end
---@return LoginTaskView
function LoginTaskViewAction:View()
    return self.view
end
function LoginTaskViewAction:SetNoviceData()
    if self:View() then
        self:View():SetNoviceData()
    end
end
function LoginTaskViewAction:RefreshCurNoviceView()
    if self:View() and UIManager:Get():IsPersistentViewShow("LoginTaskView") then
        self:View():RefreshCurNoviceView()
    end
end

function LoginTaskViewAction:InitTaskLoginInfo(msg)
    if self:View() then
        self:View():InitTaskLoginInfo(msg)
    end
end
function LoginTaskViewAction:RefreshTaskLoginInfo(msg)
    if self:View() then
        self:View():RefreshTaskLoginInfo(msg)
    end
end

function LoginTaskViewAction:OpenLogoutView()
    UIManager:Get():OpenView("LoginView", CanvasType.FrontCanvas, "LoginView", false)
end


return LoginTaskViewAction()