


function RaceSelfCreateView:SetStep3(default)
    self:SetPageGroup(3)

    self.Param_Time = {}


    for i = 1, 5 do
        CommonHelper:HButtonSetCallback("TogSelect"..i.."/BtnSelect",self.Page3,function (hbtn)
            UIManager:Get():OpenPopup("RaceSelfDateView",CanvasType.FrontCanvas,"RaceSelfDateView")
            UINotify:Get():SendNotification(UINotifyEvent.SelfRaceDateView_SetData, hbtn.intData)
        end, i)
    end



    local list = RaceSelfCacheManager:Get():GetCache_SelectTimes()
    for i = 1, #list do
        local dateidx = list[i][1]
        local timeidx = list[i][2]
        local date = RaceSelfCacheManager:Get():GetCache_Day(dateidx)
        local time = RaceSelfCacheManager:Get():GetCache_Time(dateidx, timeidx)
        local str1 = date.Month.."月"..date.Day.."日"
        local str2 = string.format("%s%02d:%02d",CommonHelper:GetWeekString(date.Week),time.Hour, time.Minute)
        CommonHelper:SetText("TogSelect"..i.."/datevalue", self.Page3, str1)
        CommonHelper:SetText("TogSelect"..i.."/weektimevalue", self.Page3, str2)

        local tick = CommonHelper:ConvertParamToInt(date.Year, date.Month, date.Day, time.Hour, time.Minute, 0)
        table.insert(self.Param_Time, tick)
    end



    --self:SetTestTimes()
end


function RaceSelfCreateView:SetTestTimes()
    self.Param_Time = {}
    local time0 = CommonHelper:GetNowTime()
    local time1 = time0 + CSTimeSpan(0,0,30)
    local time2 = time0 + CSTimeSpan(0,0,35)
    local time3 = time0 + CSTimeSpan(0,0,40)
    local time4 = time0 + CSTimeSpan(0,0,45)
    local time5 = time0 + CSTimeSpan(0,0,50)
    table.insert(self.Param_Time, CommonHelper:ConvertDateTimeToInt(time1))
    table.insert(self.Param_Time, CommonHelper:ConvertDateTimeToInt(time2))
    table.insert(self.Param_Time, CommonHelper:ConvertDateTimeToInt(time3))
    table.insert(self.Param_Time, CommonHelper:ConvertDateTimeToInt(time4))
    table.insert(self.Param_Time, CommonHelper:ConvertDateTimeToInt(time5))
end