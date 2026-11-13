


---@class Pre_RaceWeekBaseInfo
Pre_RaceWeekBaseInfo = class("Pre_RaceWeekBaseInfo")
function Pre_RaceWeekBaseInfo:initialize()

end

---@param data RaceWeekData
function Pre_RaceWeekBaseInfo:SetData(root, data, moduleid)
    if data then
        CommonHelper:SetText("racename", root, data:GetName())
        CommonHelper:SetText("racerule", root, data:GetRuleName())

        if data:GetTrackData() then
            CommonHelper:GetComponentSetTrackIconByData("trackIcon", root, data:GetTrackData(), moduleid)
        end
        CommonHelper:HButtonSetCallback("BtnReview",root,function (hbtn)
            if data:GetTrackData() then CommonHelper:LoadReviewTrack(nil, data:GetTrackData()) end
        end)


        CommonHelper:SetText("curracestate", root, CommonHelper:GetTempStr_RaceWeekState(data:GetCurState()))
        local dataidx = data:GetCurState()
        local curdate = data:GetDateTime(dataidx)
        local cutstr1 = ""
        local cutstr2 = ""
        if curdate then
            cutstr1 = string.format("%04d-%02d-%02d", curdate.Year, curdate.Month, curdate.Day)
            cutstr2 = string.format("%02d:%02d", curdate.Hour, curdate.Minute)
        end
        CommonHelper:SetText("curdate", root, cutstr1)
        CommonHelper:SetText("curtime", root, cutstr2)



        local nextdate = data:GetDateTime(dataidx + 1)
        local nextstr1 = ""
        local nextstr2 = ""
        if nextdate then
            nextstr1 = string.format("%04d-%02d-%02d", nextdate.Year, nextdate.Month, nextdate.Day)
            nextstr2 = string.format("%02d:%02d", nextdate.Hour, nextdate.Minute)
        end
        CommonHelper:SetText("nextracestate", root, CommonHelper:GetTempStr_RaceWeekState(data:GetCurState() + 1))
        CommonHelper:SetText("nextdate", root, nextstr1)
        CommonHelper:SetText("nexttime", root, nextstr2)

    end
end