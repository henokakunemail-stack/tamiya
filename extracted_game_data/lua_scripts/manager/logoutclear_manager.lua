
---@class LogoutClearManager
LogoutClearManager = class("LogoutClearManager")

function LogoutClearManager:initialize()
    self.EventMap = {}
end

---@return LogoutClearManager
function LogoutClearManager:Get()
    if self._instance == nil then
        self._instance = LogoutClearManager()
    end
    return self._instance
end

function LogoutClearManager:Init()

end

function LogoutClearManager:RegisterEvent(class, funcName)
    if self.EventMap[class] then
        print("---   error:LogoutClearManager   repeat register event!!!  funcName = ",funcName)
        return
    end

    local data = {}
    data[1] = funcName
    data[2] = nil
    self.EventMap[class] = data
end

function LogoutClearManager:Logout()
    print("---   LogoutClearManager:Logout()")
    for k, v in pairs(self.EventMap) do
        local func = v[1]
        local param = v[2]
        if func then
            func(k, param)
        end
    end
end