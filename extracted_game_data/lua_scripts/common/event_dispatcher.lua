

---@class EventDispatcher
EventDispatcher = class("EventDispatcher")

function EventDispatcher:initialize()
    self.events_map = {}
end

function EventDispatcher:Get()
    if self._instance == nil then
        self._instance = EventDispatcher()
    end
    return self._instance
end

function EventDispatcher:AddListener(event_type, class, func)
    local e = self.events_map[event_type]
    if e == nil then
        self.events_map[event_type] = {}
    end
    table.insert(self.events_map[event_type], {class, func})
end

function EventDispatcher:RemoveListener(event_type, class)
    local e = self.events_map[event_type]
    if e ~= nil then
        for i=1,#e do 
            if e[i][1] == class then
                table.remove(e, i)
                break
            end    
        end 
    end
end

function EventDispatcher:DispatchEvent(event_type, ...)
    local e = self.events_map[event_type]
    if e == nil then
        print("---   error:EventDispatcher could not found key:",event_type)
    else
        for i=1,#e do
            local target = e[i]
            target[2](target[1], ...)
        end
    end
end

function EventDispatcher:Clear()
    self.events_map = {}
end


