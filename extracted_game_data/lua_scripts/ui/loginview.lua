---@class loginview : ViewBase
LoginView = class("LoginView", ViewBase)

function LoginView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "LoginViewAction")

end

function LoginView:Awake()

    self.BtnEnter = CommonHelper:HButtonSetCallback("EnterBtn", self.gameObject, function()
        self:InitBtn(false)
        self:OnClickBtnEnter()
    end)
end

function LoginView:OnOpen()
    print("---   loginview start")
    CommonHelper:SetInputFieldText("UserName",self.gameObject,PlayerPrefsHelper:GetValue_LoginName())
end

function LoginView:InitBtn(isEnable)
    CommonHelper:SetBtnDelayClick(self.BtnEnter, 3, isEnable)
end
-----------------------------------------------------------------Btn事件
function LoginView:OnClickBtnEnter()
    if NetManager:Get():GetNetReachability() == NetworkReachability.NotReachable then
        CommonHelper:LoginTipPop(CommonHelper:GetTempStr_Default(TemplateStringID.LoginTips_1007), CommonHelper:GetTempStr_Default(TemplateStringID.Retry), function()
            --self:OnClickBtnEnter()
        end)
    else
        print("---   点击登录")
        local userName= CommonHelper:GetInputFieldText("UserName",self.gameObject)
        if CommonHelper:IsNullOrEmpty(userName) then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PleaseInputName))
        else
            local loginUrl = PlayerPrefsHelper:GetValue_LoginUrl()
            if CommonHelper:IsNullOrEmpty(loginUrl) == false then
                DebugLogDataManager:Get().selectIp = loginUrl
            end
            if DebugLogDataManager:Get().selectIp ~= GameProperties.LoginUrl then
                GameProperties.LoginUrl = DebugLogDataManager:Get().selectIp
            end
            LoginSubSystem:Get():Send_GetServerList(userName)
            self:SaveLoginInfo(userName)
           -- mono.KpGameAutoCreate()
        end
    end
end

function LoginView:SaveLoginInfo(name)
    PlayerPrefsHelper:SetValue_LoginName(name)
end

-----------------------------------------------------------------