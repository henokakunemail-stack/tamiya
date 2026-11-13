function CommonHelper:SetSequence(seqHandle, loopInterval, loopTimes, normalFunc)
    self:StopSequence(seqHandle)
    seqHandle = UnrealM.ActionSequenceHandle()
    seqHandle:LooperUnscaled(loopInterval, loopTimes, true, nil):Action(normalFunc)
    return seqHandle
end

function CommonHelper:StopSequence(seqHandle)
    if seqHandle ~= nil then
        seqHandle:StopSequence()
        seqHandle = nil
    end
end

function CommonHelper:ConvertByteArrayToString(byteData,encoding)
    encoding=encoding or "ISO-8859-1"
    local str=mono.ConvertByteArrayToString(byteData,encoding)
    return str
end