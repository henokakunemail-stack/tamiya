


---@class CrossDayTrigger
CrossDayTrigger = class("CrossDayTrigger")

function CrossDayTrigger:initialize()
    self.EventMap = {}
end

---@return CrossDayTrigger
function CrossDayTrigger:Get()
    if self._instance == nil then
        self._instance = CrossDayTrigger()
    end
    return self._instance
end

function CrossDayTrigger:Init()

end

function CrossDayTrigger:RegisterEvent(class, funcName)
    if self.EventMap[class] then
        return
    end

    local data = {}
    data[1] = funcName
    data[2] = nil
    self.EventMap[class] = data
end

function CrossDayTrigger:CrossDay()
    print("---   CrossDayTrigger:CrossDay()")
    for k, v in pairs(self.EventMap) do
        local func = v[1]
        local param = v[2]
        func(k, param)
    end

    --self.EventMap = {}
end