---@param labExpType LabExpType
function TrackDataManager:SetTimerIdByType(labExpType, id, timerId)

    if self.TrackTimerIds[labExpType] == nil then
        self.TrackTimerIds[labExpType] = {}
    end

    self.TrackTimerIds[labExpType][id] = timerId
end

---@param labExpType LabExpType
function TrackDataManager:GetTimerIdByType(labExpType, id)
    if self.TrackTimerIds[labExpType] and self.TrackTimerIds[labExpType][id] then
        return self.TrackTimerIds[labExpType][id]
    end

    return nil
end

---@param labExpType LabExpType
function TrackDataManager:RemoveTimerIdByType(labExpType, id)
    if self.TrackTimerIds[labExpType] then
        self.TrackTimerIds[labExpType][id] = nil
    else
        print("没有该labExpType的ID表，该labExpType还没有计时")
    end
end

---@param itemCDData TrackItemCDData
function TrackDataManager:StartTimer(labExpType, itemCDData, refreshFun, finishFunc)
    local timerId = self:GetTimerIdByType(labExpType, itemCDData:GetId())

    self:StopTimer(timerId, itemCDData:GetId())

    timerId = TimerManager:Get():CreateTimerLoop(1, function()
        local nowTime = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
        if nowTime >= itemCDData:GetStartTime() then

            self:StopTimer(timerId, itemCDData:GetId())

            if finishFunc then
                finishFunc()
            end
        else
            if refreshFun then
                refreshFun(nowTime, itemCDData:GetStartTime())
            end
        end
    end, nil, true)

    self:SetTimerIdByType(labExpType, itemCDData:GetId(), timerId)
end

function TrackDataManager:StopTimer(timerId, id)
    if timerId ~= nil then
        TimerManager:Get():StopTimer(timerId)
        self:RemoveTimerIdByType(self:GetTrackTagType(), id)
    end
end