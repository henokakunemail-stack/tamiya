


---@class RaceSelfCacheData
RaceSelfCacheData = class("RaceSelfCacheData")
function RaceSelfCacheData:initialize()
    ---@type table<table<number, number>>
    self.SelectTimes = {}

    ---@type RaceSelfCacheData_Date
    self.DateCache = RaceSelfCacheData_Date()
end








---@class RaceSelfCacheData_Date
RaceSelfCacheData_Date = class("RaceDateUIData")
function RaceSelfCacheData_Date:initialize()
    ---@type table<number, RaceSelfCacheData_Day>
    self.DateList = {}

    local temp = CommonHelper:GetNowTime()
    local checkenable = true
    local hour = temp.Hour
    local minute = temp.Minute
    if hour == 23 and minute >= 30 then
        print("---   RaceDateUIData:initialize()   跨天")
        --当前时刻距离12点不足30分钟，跨天，起始时间设置第二天0点
        temp = CommonHelper:GetDateStartTime(temp, 1)
        checkenable = false
    end

    --第一天
    local firstDate = RaceSelfCacheData_Day()
    firstDate:SetData(1, checkenable, temp)
    table.insert(self.DateList, firstDate)

    --之后6天
    temp = CommonHelper:GetDateStartTime(temp, 0)
    for i = 1, 6 do
        local temp2 = CommonHelper:GetDateStartTime(temp, i)
        local otherDate = RaceSelfCacheData_Day()
        otherDate:SetData(i + 1, false, temp2)
        table.insert(self.DateList, otherDate)
    end
end

---@class RaceSelfCacheData_Day
RaceSelfCacheData_Day = class("RaceDateUIData")
function RaceSelfCacheData_Day:initialize()
    self.DateIdx = 0
    self.Year = 0
    self.Month = 0
    self.Day = 0
    self.Week = 0
    ---@type table<number, RaceSelfCacheData_Time>
    self.Times = {}
end

function RaceSelfCacheData_Day:SetData(idx, checkEnable, time)
    local year = time.Year
    local month = time.Month
    local day = time.Day
    local hour = time.Hour
    local minute = time.Minute
    local week = CommonHelper:GetDayOfWeek(false, time)

    self.DateIdx = idx
    self.Year = year
    self.Month = month
    self.Day = day
    self.Week = week
    ---@type table<number, RaceSelfCacheData_Time>
    self.Times = {}

    for i = 0, 23 do
        local enable = true
        if checkEnable then
            if i < hour or (i == hour and 0 <= minute) then
                enable = false
            end
        end
        local time1 = RaceSelfCacheData_Time()
        time1:SetData(self.DateIdx, i * 2 + 1, i, 0, enable)
        table.insert(self.Times, time1)


        enable = true
        if checkEnable then
            if i < hour or (i == hour and 30 <= minute) then
                enable = false
            end
        end
        local time2 = RaceSelfCacheData_Time()
        time2:SetData(self.DateIdx, i * 2 + 2, i, 30, enable)
        table.insert(self.Times, time2)
    end
end


---@class RaceSelfCacheData_Time
RaceSelfCacheData_Time = class("RaceTimeUIData")
function RaceSelfCacheData_Time:initialize()
    self.DateIdx = 0
    self.TimeIdx = 0
    self.Hour = 0
    self.Minute = 0
    self.Enable = false
    self.State = RaceSelfState.None
end
function RaceSelfCacheData_Time:SetData(dateidx, timeidx, hour, minute, enable)
    self.DateIdx = dateidx
    self.TimeIdx = timeidx
    self.Hour = hour
    self.Minute = minute
    self.Enable = enable
end
function RaceSelfCacheData_Time:SetState(state)
    self.State = state
end