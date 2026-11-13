

---@class GlobalSdkDataManager
GlobalSdkDataManager = class("GlobalSdkDataManager")
function GlobalSdkDataManager:Get()
    if self._instance == nil then
        self._instance = GlobalSdkDataManager()
    end
    return self._instance
end

function GlobalSdkDataManager:initialize()
    self.loginType=GlobalLoginType.None--登录类型
    self.isLogin = false--是否已经登陆过游戏，如果登陆过，在登出的时候，就不用重新加载配置，如果没有登陆过，就加载配置
end

function GlobalSdkDataManager:GetGlobalLoginType()
    return self.loginType
end
function GlobalSdkDataManager:SetGlobalLoginType(loginType)
     self.loginType=loginType
end


---@param isLogin boolean @是否已经登录过游戏
function GlobalSdkDataManager:SetIsLogin(isLogin)
    self.isLogin = isLogin
    print("------self.isLogin:   " .. tostring(isLogin))
end
---@return  boolean
function GlobalSdkDataManager:GetIsLogin()
    return self.isLogin
end
