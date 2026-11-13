

---@class QuickSdkDataManager
QuickSdkDataManager = class("QuickSdkDataManager")
function QuickSdkDataManager:Get()
    if self._instance == nil then
        self._instance = QuickSdkDataManager()
    end
    return self._instance
end

function QuickSdkDataManager:initialize()
    self.isLogin = false--是否已经登陆过游戏，如果登陆过，在登出的时候，就不用重新加载配置，如果没有登陆过，就加载配置
    self.isLoginSDK=false
end


---@param isLogin boolean @是否已经登录过SDK
function QuickSdkDataManager:SetIsLoginSDK(isLogin)
    self.isLoginSDK = isLogin
    print("------self.isLoginSDK:   " .. tostring(isLogin))
end
---@return  boolean
function QuickSdkDataManager:GetIsLoginSDK()
    return self.isLoginSDK
end

---@param isLogin boolean @是否已经登录过游戏
function QuickSdkDataManager:SetIsLogin(isLogin)
    self.isLogin = isLogin
    print("------self.isLogin:   " .. tostring(isLogin))
end
---@return  boolean
function QuickSdkDataManager:GetIsLogin()
    return self.isLogin
end
