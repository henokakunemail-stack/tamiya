function CommonHelper:SetTween(tweenComponent, from, to, duration, delay, finishedCallback, isIgnoreTimeScale)
    if tweenComponent.onFinished.RemoveAllListeners ~= nil then
        --print("移除动画之前的事件，防止多次点击-----------------------")
        tweenComponent.onFinished:RemoveAllListeners()
    end
    tweenComponent.from = from
    tweenComponent.to = to
    tweenComponent.duration = duration
    if delay ~= nil then
        tweenComponent.delay = delay
    end
    if finishedCallback ~= nil then
        tweenComponent.onFinished:AddListener(finishedCallback)
    end
    if isIgnoreTimeScale ~= nil then
        tweenComponent.ignoreTimeScale = isIgnoreTimeScale
    end
    tweenComponent:ResetToBeginning()
    tweenComponent:SetStartToCurrentValue()
    tweenComponent:PlayForward()
end

function CommonHelper:TransferTime(totalMilliSecond, param)
    param = param or 0.001
    local totalSecond = totalMilliSecond * param
    local result = {}
    result.day = math.floor(totalSecond / (3600 * 24))
    result.hour = math.floor(totalSecond / 3600) - result.day * 24
    result.minute = math.floor(totalSecond / 60) - result.day * 24 * 60 - result.hour * 60
    result.second = math.floor(totalSecond - result.day * 24 * 3600 - result.hour * 3600 - result.minute * 60)
    result.milliSecond = math.floor(totalMilliSecond % 1000)
    return result
end

----@return ConvertTime
---@param isDefault @是否返回默认格式，分钟：秒：毫秒，如果为false ，就返回字符串，自己定义
function CommonHelper:TransferTimeToString(result, isDefault)
    local resultTab = {}

    isDefault = isDefault == nil or isDefault == true

    resultTab. day =  tostring(result.day)
    resultTab. hour = (result.hour >= 0 and result.hour < 10) and string.format("0%d", result.hour) or tostring(result.hour)
    resultTab. minute = (result.minute >= 0 and result.minute < 10) and string.format("0%d", result.minute) or tostring(result.minute)
    resultTab. second = (result.second >= 0 and result.second < 10) and string.format("0%d", result.second) or tostring(result.second)
    resultTab. milliSecond = "000"
    if result.milliSecond > 0 and result.milliSecond < 10 then
        resultTab.  milliSecond = string.format("00%d", result.milliSecond)
    elseif result.milliSecond >= 10 and result.milliSecond < 100 then
        resultTab. milliSecond = string.format("0%d", result.milliSecond)
    elseif result.milliSecond >= 100 then
        resultTab.  milliSecond = tostring(result.milliSecond)
    else
        resultTab. milliSecond = "000"
    end
    if isDefault then
        return string.format("%s:%s:%s", resultTab.minute, resultTab.second, resultTab.milliSecond)
    else
        return resultTab
    end
end

---@return ConvertTime
function CommonHelper:GetSelfTransferTimeStr(milliSecond, param)

    local result = CommonHelper:TransferTime(milliSecond, param)

    return CommonHelper:TransferTimeToString(result, false)

end

---@param milliSecond number @毫秒数或者秒数，如果是毫秒数，param就不用赋值
---@param param number @如果传的是秒，这个就要为 1
function CommonHelper:GetComponentTransferTime(textName, parent, milliSecond, param)
    param = param or 0.001
    local result = CommonHelper:TransferTime(milliSecond, param)
    local textCom = CommonHelper:SetText(textName, parent, CommonHelper:TransferTimeToString(result))
    return textCom, result
end

function CommonHelper:GetTrackColorByTrackIdx(trackIdx)
    if trackIdx == 1 then
        return "FFFFFF"
    elseif trackIdx == 2 then
        return "FF0000"
    elseif trackIdx == 3 then
        return "FFFF00"
    elseif trackIdx == 4 then
        return "0000FF"
    elseif trackIdx == 5 then
        return "00FF00"
    end
end
---@return table<number,RewardData>
function CommonHelper:GetRewardGroupByRank(Rank)
    ---@type globalseason_config_cell
   local cfg=RaceRankManager:Get():GetSessionCfg()
   local rewards=stringSplit(cfg.rankReward,'|')
    local result=nil
    local dropID=nil
    for i = 1, #rewards do
        local rankReward=stringSplitToNumber(rewards[i],':')
        if Rank==rankReward[1] then
            result=CommonHelper:GetRewardByDropId(rankReward[2])
            dropID=rankReward[1]
            break
        end
        if Rank>rankReward[1] and rewards[i+1]~=nil and Rank<stringSplitToNumber(rewards[i+1],':')[1] then
            result=CommonHelper:GetRewardByDropId(rankReward[2])
            dropID=rankReward[1]
            break
        end
        if Rank>rankReward[1] and rewards[i+1]==nil then
            result=CommonHelper:GetRewardByDropId(rankReward[2])
            dropID=rankReward[1]
            break
        end
    end
    return result
end

function CommonHelper:GetBattleCompareType(type)
    if type==BattleCompareType.Speed then
        return CommonHelper:GetTempStr_Default(TemplateStringID.CompareSpeed)
    end
    if type==BattleCompareType.LastingLong then
        return CommonHelper:GetTempStr_Default(TemplateStringID.CompareLastingLong)
    end
    if type==BattleCompareType.ShockAbsorption then
        return CommonHelper:GetTempStr_Default(TemplateStringID.CompareShockAbsorption)
    end
end
function CommonHelper:GetBattleTittleNameByName(num)
    if num==1 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.ChapterBattle1Name)
    end
    if num==2 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.ChapterBattle2Name)
    end
    if num==3 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.ChapterBattle3Name)
    end
    if num==4 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.ChapterBattle4Name)
    end
   if num==5 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.ChapterBattle5Name)
    end
end
function CommonHelper:GetSuperBattleGroupName(num)
    if num==1 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleGroupA)
    end
    if num==2 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleGroupB)
    end
    if num==3 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleGroupC)
    end
    if num==4 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleGroupD)
    end
   if num==5 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleGroupE)
    end
    if num==6 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleGroupF)
    end
    if num==7 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleGroupG)
    end
    if num==8 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleGroupH)
    end
    if num==9 then
        return CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperBattleGroupFinals)
    end
end

function CommonHelper:TrackSelectDepartPosition(trackNum,func,type,param)
    UIManager:Get():ShowPersistentView("TrackPositionSelectView",CanvasType.FrontCanvas,"TrackPositionSelectView")
    UINotify:Get():SendNotification(UINotifyEvent.TrackPositionSelectView_SetData,{trackNum,func,type,param})
end