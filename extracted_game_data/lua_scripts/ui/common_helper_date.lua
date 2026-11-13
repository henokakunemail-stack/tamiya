



--------------------------------------------c#侧  datatime操作


--------------------------------------------------------unix时间戳转换成dateTime
---@return CSDateTime
function CommonHelper:UnixTimeConvertTime(unixTime)
    local startTime=nil
    if ServerTime.isUtc then
        startTime=CSDateTime(1970,1,1)
    else
        startTime=CSTimeZone.CurrentTimeZone:ToLocalTime(CSDateTime(1970,1,1))
    end

    local lTime = unixTime * 10000000
    local toNow = CSTimeSpan(lTime)
    local dtResult = startTime:Add(toNow)
    return dtResult
end


--------------------------------------------------------同步服务器时间
function CommonHelper:SetServerTime(time)
    if GameProperties.AreaType==AreaType.AreaTypeDNY then
        ServerTime.isLocal=true
        ServerTime.isAddHour=false
        ServerTime.isUtc=true
        ServerTime.zoneName="UTC"
        ServerTime.Hour=0

        
    end
    if GameProperties.AreaType==AreaType.AreaTypeKR then
        ServerTime.isLocal=true
        ServerTime.isAddHour=false
        ServerTime.isUtc=true
        ServerTime.zoneName="UTC"
        ServerTime.Hour=0
    end
    if GameProperties.AreaType==AreaType.AreaTypeGAT then
        ServerTime.isLocal=true
        ServerTime.isAddHour=false
        ServerTime.isUtc=false
        ServerTime.zoneName="UTC"
        ServerTime.Hour=0
    end
  if GameProperties.AreaType==AreaType.AreaTypeCN then
        ServerTime.isLocal=true
        ServerTime.isAddHour=false
        ServerTime.isUtc=false
        ServerTime.zoneName="UTC"
        ServerTime.Hour=0
    end
    ServerTime:SetServerTime(time)
end


--------------------------------------------------------获取当前时刻
---@return CSDateTime
function CommonHelper:GetNowTime()
    local result = ServerTime:ServerTimeNow()
    return result
end
--------------------------------------------------------获取当前
---@return number
function CommonHelper:ConvertNowTimeDouble()
    local result = ServerTime:ConvertDateTimeDouble(CommonHelper:GetNowTime())
    return result
end

-------------------------------------------------------获取当前的时间差
---@return number 返回的时间差是一个毫秒值
function CommonHelper:SubTime(time)
    local result = ServerTime:SubTime(time)
    return result
end

---@return number 返回的时间差是一个毫秒值
function CommonHelper:SubTimeByDateTime(time)
    local result = ServerTime:SubTimeByDateTime(time)
    return result
end
--------------------------------------------------------获取当天是周几
---@return DayOfWeek
function CommonHelper:GetDayOfWeek(istoday, time)
    if istoday == nil then istoday = true end

    local result = ServerTime:GetDayOfWeek(istoday, time)
    return result
end

---------------------------------------------------------获取当天是周几(中国习惯1~7)
function CommonHelper:GetDayOfWeekChina(istoday, time)
    if istoday == nil then istoday = true end

    local result = ServerTime:GetDayOfWeek(istoday, time)
    if result == DayOfWeek.Sunday then
        result = 7
    end
    return result
end


function CommonHelper:CheckDataIsDayOfWeek(dayOfWeek)
    if dayOfWeek == 7 then
        dayOfWeek = DayOfWeek.Sunday
    end
    return dayOfWeek == CommonHelper:GetDayOfWeek(true,CommonHelper:GetNowTime())
end


--------------------------------------------------------时间戳转换成dateTime
---@return CSDateTime
function CommonHelper:ConvertIntToDataTime(tick)--毫秒

    return ServerTime:ConvertIntToDataTime(tick)

end

---@return string
function CommonHelper:FormatDataString(datetime,string)
   return ServerTime:FormatDataTime(datetime,string)
end

--------------------------------------------------------dateTime转换成时间戳
---@return number  @返回到秒
function CommonHelper:ConvertDateTimeToInt(datatime)
    return ServerTime:ConvertDateTimeInt(datatime)
end


--------------------------------------------------------自定义时刻转换成时间戳
---@return number
function CommonHelper:ConvertParamToInt(year, month, day, hour, minute, second)
    return ServerTime:ConvertParamToInt(year, month, day, hour, minute, second)
end


--------------------------------------------------------获取第二天的0点
---@return CSDateTime
function CommonHelper:GetDateStartTime(time, n)
    return ServerTime:GetDateStartTime(time, n)
end

function CommonHelper:GetServerToNowTimeDifference()
    local serverStartTime = ClientDataManager:Get():GetServerStartTime()
    local now = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    local differenceValue = now - serverStartTime

    return differenceValue
end

function CommonHelper:GetServerToNowTimeDifference(_time)
    local _Value = self:GetServerToNowTimeDifference()
    return _Value >= _time
end

--------------------------------------------------------
function CommonHelper:GetWeekString(week)
    if week == DayOfWeek.Sunday then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Sunday)
    end
    if week == DayOfWeek.Monday then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Monday)
    end
    if week == DayOfWeek.Tuesday then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Tuesday)
    end
    if week == DayOfWeek.Wednesday then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Wednesday)
    end
    if week == DayOfWeek.Thursday then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Thursday)
    end
    if week == DayOfWeek.Friday then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Friday)
    end
    if week == DayOfWeek.Saturday then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Saturday)
    end
end

function CommonHelper:GetConvertMillSecond(subTime)
    local day = math.modf(subTime / TimeMilliSecond_Day)
    local hour = math.modf((subTime - (day * TimeMilliSecond_Day)) / TimeMilliSecond_Hour)
    local minute = math.modf((subTime - (day * TimeMilliSecond_Day) - (hour * TimeMilliSecond_Hour)) / TimeMilliSecond_Minute)
    local second = math.modf((subTime - (day * TimeMilliSecond_Day) - (hour * TimeMilliSecond_Hour) - (minute * TimeMilliSecond_Minute))/TimeMilliSecond_Second)
    return day,hour,minute,second
end
function CommonHelper:GetConvertSecond(subTime)
    local day = math.modf(subTime / TimeSecond_Day)
    local hour = math.modf((subTime - (day * TimeSecond_Day)) / TimeSecond_Hour)
    local minute = math.modf((subTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour)) / TimeSecond_Minute)
    local second = subTime - (day * TimeSecond_Day) - (hour * TimeSecond_Hour) - (minute * TimeSecond_Minute)
    return day,hour,minute,second
end


---@param leaveTime @毫秒
function CommonHelper:SetLeaveTime(leaveTime)
    if leaveTime==-1 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.OnLine)
    else
        leaveTime=math.floor(leaveTime*0.001)
    end
    local leaveDateTime = CommonHelper:UnixTimeConvertTime(leaveTime)
    local nowTime = CommonHelper:GetNowTime()
    local subTime = nowTime:Subtract(leaveDateTime)
    if subTime.TotalHours >= 72 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Ago3_Day)
    elseif subTime.TotalHours >= 24 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Ago1_Day)
    elseif subTime.TotalHours >= 12 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Ago12_Hour)
    elseif subTime.TotalHours >= 6 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Ago6_Hour)
    elseif subTime.TotalHours >= 3 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Ago3_Hour)
    elseif subTime.TotalHours >= 2 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Ago2_Hour)
    elseif subTime.TotalHours >= 1 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Ago1_Hour)
    elseif subTime.TotalMinutes >= 30 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Ago30_Minute)
    elseif subTime.TotalMinutes >= 10 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Ago10_Minute)
    elseif subTime.TotalMinutes >= 5 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.Ago5_Minute)
    else
        return CommonHelper:GetTempStr_Default(TemplateStringID.Just)
    end
end
