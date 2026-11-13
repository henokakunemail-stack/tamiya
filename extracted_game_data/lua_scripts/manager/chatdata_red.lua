function ChatDataManager:GetRedById(privateId)
    return self.redPointDic[privateId]
end

function ChatDataManager:UpdateRedDic(privateId)
    self:UpdateRedDicAndRefresh(privateId,true)
end

function ChatDataManager:UpdateRedDicAndRefresh(privateId,isRefresh)
    if privateId ~= self.curSelectPrivateId or ChatDataManager:Get():GetChatType() == ChatType.None then
        self.redPointDic[privateId] = privateId
    else
        self.redPointDic[privateId] = nil
    end
    RedPointManager:Get():UpdateValue(RedPointID.Chat)

    if isRefresh then
        UINotify:Get():SendNotification(UINotifyEvent.ChatView_UpdatePrivateList)
    end
end


function ChatDataManager:GetRedPointCount()
    local redCount = 0
    for key, value in pairs(self.redPointDic) do
        redCount = redCount + 1
    end
    return redCount
end

function ChatDataManager:IsHaveRedPoint()
    return self:GetRedPointCount() > 0
end