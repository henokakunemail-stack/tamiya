


---@class CacheClearTrigger
CacheClearTrigger = class("CacheClearTrigger")

function CacheClearTrigger:initialize()
    self.EventMap = {}
end

---@return CacheClearTrigger
function CacheClearTrigger:Get()
    if self._instance == nil then
        self._instance = CacheClearTrigger()
    end
    return self._instance
end

function CacheClearTrigger:Init()

end

function CacheClearTrigger:RegisterEvent(class, funcName)
    if self.EventMap[class] then
        print("---   error:CacheClearTrigger   repeat register event!!!  funcName = ",funcName)
        return
    end

    local data = {}
    data[1] = funcName
    data[2] = nil
    self.EventMap[class] = data
end

function CacheClearTrigger:Logout()
    print("---   CacheClearTrigger:Logout()")
    for k, v in pairs(self.EventMap) do
        local func = v[1]
        local param = v[2]
        if func then
            func(k, param)
        end
    end

    --self.EventMap = {}
end