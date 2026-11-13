---@class Queue
Queue=class("Queue")

function Queue:initialize()
    self.List={}
    self.first=1
    self.last=0
    self.Size=0
end

function Queue:EnQueueFront(value)
    local first = self.first - 1
    self.first = first
    self.List[first] = value
    self.Size=self.Size+1
end

function Queue:EnQueueBack(value)
    local last = self.last + 1
    self.last = last
    self.List[last] = value
    self.Size=self.Size+1
end

function Queue:DeQueueFront()
    local first = self.first
    if first > self.last then
        logError("Queue is empty")
        return nil
    end
    local value = self.List[first]
    self.List[first] = nil
    self.first = first + 1
    self.Size=self.Size-1
    return value
end

function Queue:DeQueueBack()
    local last = self.last
    if self.first > last then
        logError("Queue is empty")
        return nil
    end
    local value = self.List[last]
    self.List[last] = nil
    self.last = last - 1
    self.Size=self.Size-1
    return value
end
function Queue:GetSize()
    return self.Size
end
function Queue:Print(func)

    if self.first > self.last then
        logError("Queue is empty")
        return nil
    end
    for i =self.first, self.last do
          func(i,self.List[i])
    end
end

function Queue:Clear()
    self.List={}
    self.first=1
    self.last=0
    self.Size=0
end