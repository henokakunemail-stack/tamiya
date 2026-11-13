local __TimerID = 0

---@class TimerManager
TimerManager = class("TimerManager")

function TimerManager:initialize()
    ---@type table<number,TimerData>
    self.timerList = {}
end

---@return TimerManager
function TimerManager:Get()
    if self._instance == nil then
        self._instance = TimerManager()
    end
    return self._instance
end

function TimerManager:CreateTimer(time, func, class)
    __TimerID = __TimerID + 1
    local timer = TimerData()
    timer:Init(__TimerID, time, false, func, class)
    table.insert(self.timerList, timer)
    return __TimerID
end

function TimerManager:CreateTimerLoop(time, func, class, isActionAtStart)
    __TimerID = __TimerID + 1
    local timer = TimerData()
    timer:Init(__TimerID, time, true, func, class, isActionAtStart)
    table.insert(self.timerList, timer)
    return __TimerID
end

function TimerManager:StopTimer(id)
    for i = 1, #self.timerList do
        if self.timerList[i].id == id then
            self.timerList[i]:Stop()
            table.remove(self.timerList, i)
            break
        end
    end
end
function TimerManager:GetTimer(id)
    for i = 1, #self.timerList do
        if self.timerList[i].id == id then
            return self.timerList[i]
        end
    end
end

function TimerManager:ReleaseXLuaRelevance()
    for i = 1, #self.timerList do
        self.timerList[i]:Stop()
    end
    self.timerList = {}
end



---@class TimerData
TimerData = class("TimerData")
function TimerData:Init(id, time, loop, func, class, isActionAtStart)
    self.id = id
    self.loop = loop
    self.func = func
    self.isActionAtStart = isActionAtStart or false
    self.class = class
    self.seqHandle = UnrealM.ActionSequenceHandle()
    self.seqHandle:Looper(time, function(id)
        local data = TimerManager:Get():GetTimer(id)
        if data then
            data:Loop()
        end
    end, self.id, self.isActionAtStart)

end
function TimerData:Stop()
    self.seqHandle:StopSequence()
    self.seqHandle = nil
end

function TimerData:Loop()

    if self.loop == false then
        self.seqHandle:StopSequence()
        TimerManager:Get():StopTimer(self.id)
    end

    if self.func then
        if self.class then
            self.func(self.class)
        else
            self.func()
        end

    end
end

