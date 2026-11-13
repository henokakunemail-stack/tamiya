
---@class NetResponseEventManager
NetResponseEventManager = class("NetResponseEventManager")

function NetResponseEventManager:initialize()
    self.__index = self
    self.__call = self.__call
    self.events_map = {}
end

function NetResponseEventManager:Get()
    if self._instance == nil then
        self._instance = NetResponseEventManager()
    end
    return self._instance
end

function NetResponseEventManager:AddListener(event_type, source, func)
    local e = self.events_map[event_type]
    if e == nil then
        self.events_map[event_type] = {}
    end
    table.insert(self.events_map[event_type], {source, func})
end

function NetResponseEventManager:RemoveListener(event_type, source, func)
    local e = self.events_map[event_type]
    if e ~= nil then
        for i=1,#e do 
            if e[i][1] == source and e[i][2] == func then
                table.remove(e, i)
                break
            end    
        end 
    end
end

function NetResponseEventManager:ClearAll(event_type)
    self.events_map[event_type] = nil
end

function NetResponseEventManager:DispatchEvent(event_type, ...)
    local e = self.events_map[event_type]
    if e == nil then
            logError("event could not found key:"..event_type)
    else
        for i=1,#e do 
            local target = e[i]
            target[2](target[1], ...)
        end 
    end
end
