---@class PlayerIdentityCallback
PlayerIdentityCallback = class("PlayerIdentityCallback")
local _OneHour=60*60
local _TwoHour=60*60*2
local _Three=60*60*3
local _AnHourAndAHalf=60*60+60*30
local _IsKickOff=false
---@return PlayerIdentityCallback
function PlayerIdentityCallback:Get()
    if self._instance == nil then
        self._instance = PlayerIdentityCallback()
    end
    self.duration=0
    return self._instance
end
function PlayerIdentityCallback:Init(playerIdentityCallback)
   local funOn_KickOff =self.On_KickOff
   local funOn_Message=self.On_Message
   local funOn_JudgePay=self.On_JudgePay
   local funOn_JudgeTime=self.On_JudgeTime
   local funOn_Error=self.On_Error
   local funOn_GetUser=self.On_GetUser
   local funOn_Login=self.On_Login
    local funOn_LogOut=self.On_Logout
    local funOn_Register=self.On_Register
    self.playerIdentityCallback=playerIdentityCallback
    playerIdentityCallback:Init(self,funOn_KickOff,funOn_Message,funOn_JudgePay,funOn_JudgeTime,funOn_Error,funOn_GetUser,funOn_Login,funOn_LogOut)
    playerIdentityCallback. On_Register=funOn_Register
    print("CallbackInit")
end
local _flag
function PlayerIdentityCallback:On_Login()
       print("dengluchenggng:")
   -- UIManager:Get():HidePersistentView("GameStartView")
    --UIManager:Get():CloseView()

    UINotify:Get():SendNotification(UINotifyEvent.LoginView_OpenLoginView)
    self:ContinueBeat()
    --[[
    --   local  result=stringSplit(email,"@")
    --   local loginName=""
    --if PlayerPrefs.GetString(email)=="" then
    --    loginName=LoginSubSystem:Get():CreateUserName()
    --    PlayerPrefs.SetString(email,loginName)
    --else
    --    loginName=PlayerPrefs.GetString(email)
    --end
    --   LoginSubSystem:Get():LoginToUserServer(loginName,"1111")
    ]]--
end
function PlayerIdentityCallback:On_Register()
    CommonTipsHelper:Get():ShowCenterTips("注册成功")
end
function PlayerIdentityCallback:On_Logout()
    print("Logout")
  --  ClientDataManager:Get():ClearDataManager()
  --  --UINotify:Get():SendNotification(UINotifyEvent.OpenLogoutView)
  -- -- UIManager:Get():OpenView("GameStartView", CanvasType.MainCanvas, "GameStartView",false, true)
  --  UIManager:Get():ShowPersistentView("CommonBg2View",CanvasType.MainCanvas,nil)
  --  UIManager:Get():ShowPersistentView("GameStartView",CanvasType.FrontCanvas,"GameStartView",false,true)
  -- -- self:OpenAccountView()
  --  local boxfunc = function()
  --      local   text=ClientDataManager:Get():GetTemplateString("minortips1001")
  --      local ret =  MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue,text,"温馨提示",nil,nil,false,false,true)
  --      if ret==MessageBoxHelp.BtnType.OK then
  --          CS.Application.Quit()
  --      end
  --  end
  --  MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
end
function PlayerIdentityCallback:On_KickOff(traceId, ruleName)
    print("traceId"..traceId)
    print("ruleName"..ruleName)
    UIManager:Get():ShowPersistentView("CommonBg2View",CanvasType.BackCanvas,nil)
    _IsKickOff=true
    --[[
    -- local  text=ClientDataManager:Get():GetTemplateString("minortips1001")
    --if 0~=self.duration and self.duration>=60*3*60 then
    --    local boxfunc = function()
    --        local   text=ClientDataManager:Get():GetTemplateString("minortips1001")
    --        local ret =  MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue,text,"温馨提示",nil,nil,false,false,true)
    --        if ret==MessageBoxHelp.BtnType.OK then
    --            CS.Application.Quit()
    --        end
    --    end
    --    MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
    --else
    --    UIManager:Get():CloseView()
    --    UIManager:Get():ShowPersistentView("GameStartView", CanvasType.FrontCanvas, "GameStartView",false,true)
    --    self:OpenSignInPanel()
    --end
    ]]--
end
--[[
    --UIManager:Get():ShowPersistentView("GameStartView",CanvasType.FrontuCanvas,"GameStartView",false,true)
   -- self:OpenAccountView()
    --cs_coroutine.start( function()
    --    local curSceneName =CS.UnityEngine.SceneManagement.SceneManager.GetActiveScene().name
    --    while  curSceneName ~= "scn_home" do
	--			print("curSceneName"..curSceneName)
    --        coroutine.yield()
    --    end
    --    UIManager:Get():CloseAllViews()
    --    UINotify:Get():SendNotification(UINotifyEvent.OpenLoginView)
    --end)
]]--
-- title  ReportExecution ReportExecution 游戏温馨提示
function PlayerIdentityCallback:On_Message(title, msg, context)
    self:On_JudgeTime()
    if (msg~=nil or #msg>0) and (title==ClientDataManager:Get():GetTemplateString(TemplateStringID.GameWarmPrompt))  then
        local boxfunc = function()
            local text=msg
            if  msg=="" or msg==nil then
                text=ClientDataManager:Get():GetTemplateString("minortips1004")
            end
            local limitLogin=string.find(msg,"无法")
            --local   text=ClientDataManager:Get():GetTemplateString("minortips1001")
            local ret =  MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue,text,ClientDataManager:Get():GetTemplateString(TemplateStringID.GameWarmPrompt),nil,nil,false,false,true)
            if ret==MessageBoxHelp.BtnType.OK then
                if msg=="" or msg==nil then
                    UIManager:Get():CloseView()
                    UIManager:Get():ShowPersistentView("GameStartView", CanvasType.FrontCanvas, "GameStartView",false,true)
                    self:OpenSignInPanel()
                else
                    if limitLogin~=nil then
                        CommonHelper:ApplicationQuit()
                    end
                    if self.duration>=_AnHourAndAHalf or self.duration>=_Three  then
                        CommonHelper:ApplicationQuit()
                    end
                end
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
    end
end
function PlayerIdentityCallback:On_GetUser(userID)
    if userID==nil then return end
    print("userID:" .. userID)
   -- LoginSubSystem:Get():LoginToUserServer(userID,"1111")
end
function PlayerIdentityCallback:On_JudgeTime(duration)
    if duration==nil then
        return
    end
    self.duration=duration
    local hours = math.modf(duration / 3600)
    local minutes =math.modf((duration - hours * 3600) / 60)
    local seconds = math.modf(duration % 60)
    print("current play time: " ..hours .. "h" .. minutes .. "min" .. seconds .. "s")
    --[[if duration>=60*60+60*55 then
        local boxfunc = function()
            local text=ClientDataManager:Get():GetTemplateString("minortips1003")
            if duration>=60*3*60 then
                text=ClientDataManager:Get():GetTemplateString("minortips1001")
            end
            local ret =  MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue,text,"温馨提示",nil,nil,false,false,true)
            if ret==MessageBoxHelp.BtnType.OK and duration>=60*3*60 then
                --UIManager:Get():OpenView("GameStartView", CanvasType.MainCanvas, "GameStartView")
                UIManager:Get():ShowPersistentView("GameStartView",CanvasType.FrontCanvas,"GameStartView",false,true)

            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
    end
    ]]--
end
function PlayerIdentityCallback:On_JudgePay(age)
    print("Age"..age)
end
function PlayerIdentityCallback:On_Error(error)
    if error==nil then
        CommonTipsHelper:Get():ShowCenterTips("输入错误")
        return end
    print("ERROR:"..error)
    --local passwordStartIndex=string.find(error,"INVALID_CREDENTIALS")--|密码不合法时会收到以下
    local userStartIndex=string.find(error,"User Not Fount")--用户不存在
   -- local AccountIndex=string.find(error,"Account already exists")--当使用已注册过用户的电子邮件
    local WEAK_PASSWORD=string.find(error,"WEAK_PASSWORD")--当用户输入密码小于6个字符
    local INVALID_EMAIL=string.find(error,"INVALID_EMAIL")--当用户电子邮件不合法或者缺失
    local ID_PROVIDER_ERROR=string.find(error,"ID_PROVIDER_ERROR")--当使用无效的第三方令牌
    local INVALID_SESSION_TOKEN=string.find(error,"INVALID_SESSION_TOKEN")--当使用不合法的session token(会话令牌)
    local MISSING_SESSION_TOKEN=string.find(error,"MISSING_SESSION_TOKEN")--在需要传递session token(会话令牌)地方没有传递
    local ACCOUNT_EXISTS=string.find(error,"ACCOUNT_EXISTS")--当使用已注册过用户的电子邮件
    --local externalaccountIndex=string.find(error,"ID_PROVIDER_ERROR")--尝试登录一个目前不支持的ID provider的账号
    local LAST_ID_PROVIDER=string.find(error,"LAST_ID_PROVIDER")--|用户尝试解除最后一个ID provider
    local CANNOT_UNLINK_PASSWORD=string.find(error,"CANNOT_UNLINK_PASSWORD")--|尝试解除提供密码的ID provider
    local INVALID_PARAMETERS=string.find(error,"INVALID_PARAMETERS")--发送没有验证码的请求
    local PASSWORD_AUTH_NOT_SETUP=string.find(error,"PASSWORD_AUTH_NOT_SETUP")--|当用户尚未通过电子邮件/密码验证
    local INVALID_CREDENTIALS=string.find(error,"INVALID_CREDENTIALS") --密码或者邮件不合法
    local PASSWORD_AUTH_ALREADY_SETUP=string.find(error,"PASSWORD_AUTH_ALREADY_SETUP") --用户已经创建email/password
    local PASSWORD_MATCH_ERROR=string.find(error,"PASSWORD_MATCH_ERROR") --用户已经创建email/password
    local NO_NOTWORK=string.find(error,"NO_NOTWORK")


    --if passwordStartIndex~=nil  then
    --    CommonTipsHelper:Get():ShowCenterTips("账号或密码错误 请重新输入")
    --    return
    --end
    if userStartIndex~=nil then
        CommonTipsHelper:Get():ShowCenterTips("用户不存在请注册")
        return
    elseif WEAK_PASSWORD~=nil then
        CommonTipsHelper:Get():ShowCenterTips("密码不足8位请输入8位有效字符")
    elseif INVALID_EMAIL~=nil then
        CommonTipsHelper:Get():ShowCenterTips("当用户电子邮件不合法或者缺失")
    elseif ID_PROVIDER_ERROR~=nil then
       -- CommonTipsHelper:Get():ShowCenterTips("当使用无效的第三方令牌")
    elseif INVALID_SESSION_TOKEN~=nil then
       -- CommonTipsHelper:Get():ShowCenterTips("当使用不合法的session token(会话令牌)")
    elseif MISSING_SESSION_TOKEN~=nil then
       -- CommonTipsHelper:Get():ShowCenterTips("在需要传递session token(会话令牌)地方没有传递")
    elseif ACCOUNT_EXISTS~=nil then
        CommonTipsHelper:Get():ShowCenterTips("当前用户已存在")
    elseif LAST_ID_PROVIDER~=nil then
        CommonTipsHelper:Get():ShowCenterTips("用户尝试解除最后一个ID provider")
    elseif CANNOT_UNLINK_PASSWORD~=nil then
        CommonTipsHelper:Get():ShowCenterTips("尝试解除提供密码的ID provider")
    elseif INVALID_PARAMETERS~=nil then
        CommonTipsHelper:Get():ShowCenterTips("请输入有效信息")
    elseif PASSWORD_AUTH_NOT_SETUP~=nil then
        CommonTipsHelper:Get():ShowCenterTips("当用户尚未通过电子邮件/密码验证")
    elseif INVALID_CREDENTIALS~=nil then
        CommonTipsHelper:Get():ShowCenterTips("账号或密码错误 请重新输入")
    elseif PASSWORD_AUTH_ALREADY_SETUP~=nil then
        CommonTipsHelper:Get():ShowCenterTips("用户已经创建email/password")
    elseif PASSWORD_MATCH_ERROR~=nil then
        CommonTipsHelper:Get():ShowCenterTips("两次输入的密码不一致")
    elseif NO_NOTWORK~=nil then
        CommonTipsHelper:Get():ShowCenterTips("没有网络")
    end
end
function PlayerIdentityCallback:OpenAccountView()
    self.playerIdentityCallback:OpenAccountPanel()
end
function PlayerIdentityCallback:OpenSignInPanel()
    self.playerIdentityCallback:OpenSignInPanel()
end
function PlayerIdentityCallback:ContinueBeat()
    self.playerIdentityCallback:ContinueBeat()
end
function PlayerIdentityCallback:JudgePay()
    self.playerIdentityCallback:JudgePay()
end
