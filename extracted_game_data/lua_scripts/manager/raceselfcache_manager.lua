

local __instance
---@class RaceSelfCacheManager
RaceSelfCacheManager = class("RaceSelfCacheManager")
function RaceSelfCacheManager:initialize()
    ---@type RaceSelfCacheData
    self.CacheData = nil


end
---@return RaceSelfCacheManager
function RaceSelfCacheManager:Get()
    if __instance == nil then
        __instance = RaceSelfCacheManager()
    end
    return __instance
end




function RaceSelfCacheManager:CreateCache()
    self.CacheData = RaceSelfCacheData()

    self:AutoSelectDate()

    self:SetTimeListState()
end




---@return RaceSelfCacheData_Date
function RaceSelfCacheManager:GetCache_Date()
    return self.CacheData.DateCache
end

function RaceSelfCacheManager:ClearCache_Date()
    self.CacheData.DateCache = nil
end

function RaceSelfCacheManager:CheckDateError()
    if self.CacheData.DateCache == nil then
        print("---   error:CheckDateError   self.CacheData.DateCache == nil")
        return
    end

    local now = CommonHelper:GetNowTime()
    local start = self.CacheData.DateCache.DateList[1] + CSTimeSpan(0,30,0)
    if now >= start then
        print("---   DateUIData reset!!!!!!")
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.RaceSelfSelectDateError2))
        self.CacheData.DateCache = RaceSelfCacheData_Date()
        return true
    end
end

function RaceSelfCacheManager:AutoSelectDate()

    if self.CacheData.DateCache == nil then
        print("---   error:RaceSelfData:AutoSelectDate()   self.CacheData.DateCache == nil")
        return
    end
    if self.CacheData.DateCache.DateList == nil then
        print("---   error:RaceSelfData:AutoSelectDate()   self.CacheData.DateCache.DateList == nil")
        return
    end


    local flag = false
    for i = 1, #self.CacheData.DateCache.DateList do
        local date = self.CacheData.DateCache.DateList[i]
        for m = 1, #date.Times do
            local time = date.Times[m]
            if time.Enable then
                if #self.CacheData.SelectTimes == 5 then
                    break
                end

                if flag then
                    local temp = {i, m}
                    table.insert(self.CacheData.SelectTimes, temp)
                end
                flag = not flag
            end
        end
    end


end

function RaceSelfCacheManager:SetTimeListState()
    for i = 1, #self.CacheData.DateCache.DateList do
        local date = self.CacheData.DateCache.DateList[i]
        for m = 1, #date.Times do
            local time = date.Times[m]
            time:SetState(RaceSelfState.None)
            for iii = 1, #self.CacheData.SelectTimes do
                local temp = self.CacheData.SelectTimes[iii]
                local dateidx = temp[1]
                local timeidx = temp[2]
                if date.DateIdx == dateidx and time.TimeIdx == timeidx then
                    time:SetState(iii)
                    break
                end
            end

        end
    end
end

---@return table<table<number, number>>
function RaceSelfCacheManager:GetCache_SelectTimes()
    return self.CacheData.SelectTimes
end

---@return RaceSelfCacheData_Day
function RaceSelfCacheManager:GetCache_Day(dateidx)
    for i = 1, #self.CacheData.DateCache.DateList do
        if i == dateidx then
            return self.CacheData.DateCache.DateList[i]
        end
    end

    return nil
end

---@return RaceSelfCacheData_Time
function RaceSelfCacheManager:GetCache_Time(dateidx, timeidx)
    for i = 1, #self.CacheData.DateCache.DateList do
        if i == dateidx then
            local temp = self.CacheData.DateCache.DateList[i]
            for m = 1, #temp.Times do
                if m == timeidx then
                    return temp.Times[m]
                end
            end
        end
    end

    return nil
end


function RaceSelfCacheManager:ChangeDate(state, dateidx, timeidx)
    self:SortSelectTimes(state, dateidx, timeidx)

    self:SetTimeListState()
end

function RaceSelfCacheManager:SortSelectTimes(state, dateidx, timeidx)
    --------------------------计算第一个可用时刻的idx
    local firstDay = self.CacheData.DateCache.DateList[1]
    local firstidx = 1
    for i = 1, #firstDay.Times do
        if firstDay.Times[i].Enable then
            firstidx = i
            break
        end
    end

    --------------------------替换时刻，计算出5个时刻的idx
    local min = firstidx
    local max = 48 * 7
    local selectidx = (dateidx - 1) * 48 + timeidx
    local oldidxs = {}
    local list = self.CacheData.SelectTimes
    for i = 1, #list do
        local temp = (list[i][1] - 1) * 48 + list[i][2]
        table.insert(oldidxs, temp)
    end

    oldidxs[state] = selectidx
    print("---   000",selectidx, oldidxs[1],oldidxs[2],oldidxs[3],oldidxs[4],oldidxs[5])


    --------------------------第一次排序，左侧数据往前推
    local flag = selectidx
    for i = state - 1, 1, -1 do
        local a = oldidxs[i]
        if a >= flag then
            a = flag - 1
            if a < min then a = min end
            flag = a
            oldidxs[i] = a
        end
    end
    print("---   111",selectidx, oldidxs[1],oldidxs[2],oldidxs[3],oldidxs[4],oldidxs[5])


    --------------------------第二次排序，左侧数据超过做小值，回弹
    local flag2 = oldidxs[1]
    for i = 1 + 1, state do
        local a = oldidxs[i]
        if a <= flag2  then
            a = flag2 + 1
            flag2 = a
            oldidxs[i] = a
        else
            flag2 = oldidxs[i]
        end
    end
    print("---   111",selectidx, oldidxs[1],oldidxs[2],oldidxs[3],oldidxs[4],oldidxs[5])


    --------------------------第三次排序，右侧数据往后推
    local flag3 = oldidxs[state]
    for i = state + 1, #oldidxs do
        local a = oldidxs[i]
        if a <= flag3  then
            a = flag3 + 1
            if a > max then a = max end
            flag3 = a
            oldidxs[i] = a
        end
    end
    print("---   111",selectidx, oldidxs[1],oldidxs[2],oldidxs[3],oldidxs[4],oldidxs[5])


    --------------------------第四次排序，右侧数据超过最大值，回弹
    local flag4 = oldidxs[#oldidxs]
    for i = #oldidxs - 1, state, -1 do
        local a = oldidxs[i]
        if a >= flag4 then
            a = flag4 - 1
            flag4 = a
            oldidxs[i] = a
        else
            flag4 = oldidxs[i]
        end
    end
    print("---   111",selectidx, oldidxs[1],oldidxs[2],oldidxs[3],oldidxs[4],oldidxs[5])


    --------------------------设置最新数据
    self.CacheData.SelectTimes = {}
    for i = 1, #oldidxs do
        local temp = oldidxs[i]
        local dateidx = math.ceil(temp / 48)
        local timeidx = temp % 48
        if timeidx == 0 then timeidx = 48 end
        table.insert(self.CacheData.SelectTimes, {dateidx, timeidx})
    end
end