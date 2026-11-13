


---@class Pre_RaceRuleBaseInfo
Pre_RaceRuleBaseInfo = class("Pre_RaceRuleBaseInfo")

function Pre_RaceRuleBaseInfo:initialize()

end

---@param data RaceSelfData
function Pre_RaceRuleBaseInfo:SetRaceSelfData(root, data, moduleid)

    if data then

        CommonHelper:SetText("raceid", root, "ID:"..data.ID)
        CommonHelper:HButtonSetCallback("BtnCopy",root,function (hbtn)
            CommonHelper:WriteClipboart(tostring(data.ID))
        end)
        CommonHelper:SetText("creatername", root, data.Creater)
        CommonHelper:SetText("racerule", root, CommonHelper:GetTempStr_RaceSelfRule(data.RaceType))
        CommonHelper:SetText("joinerlimit", root, CommonHelper:GetTempStr_RaceSelfJoinerLimit(data.JoinerMax))


        CommonHelper:SetText("curracestate", root, CommonHelper:GetTempStr_RaceSelfState(data:GetRaceState()))
        local dataidx = data:GetRaceState() + 1
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
        CommonHelper:SetText("nextracestate", root, CommonHelper:GetTempStr_RaceSelfState(data:GetRaceState() + 1))
        CommonHelper:SetText("nextdate", root, nextstr1)
        CommonHelper:SetText("nexttime", root, nextstr2)
        if data:GetTrackData() then
            CommonHelper:GetComponentSetTrackIconByData("trackIcon", root, data:GetTrackData(), moduleid)
        end
        CommonHelper:HButtonSetCallback("BtnReview",root,function (hbtn)
            if data:GetTrackData() then
                CommonHelper:LoadReviewTrack(nil, data:GetTrackData())
            end
        end)
    end

end




