
----------聊天中的计时器


function ChatDataManager:GetChatTimeByChatType(chatType)
    local chatTime = 0

    if chatType == ChatType.World then
        chatTime = 15
    elseif chatType == ChatType.Local then
        chatTime = 3
    elseif chatType == ChatType.ShortCut or chatType == ChatType.PVPRoom then
        chatTime = 2
    end
    return chatTime
end

function ChatDataManager:SetTimerIdOrTimeByChatType(chatType, key, value)
    if chatType ~= ChatType.Private then
        if self.chatTimeIds[chatType] == nil then
            self.chatTimeIds[chatType] = {}
        end
        if self.chatTimeIds[chatType][key] == nil then
            self.chatTimeIds[chatType][key] = {}
        end
        if key == ChatTimeOrId.Time then
            value = value or self:GetChatTimeByChatType(chatType)
            self.chatTimeIds[chatType][key][1] = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) + value
        else
            table.insert(self.chatTimeIds[chatType][key], value)
        end
    end
end

function ChatDataManager:GetTimerIdOrTimeByChatType(chatType, key)
    if chatType ~= ChatType.Private then
        if self.chatTimeIds[chatType] ~= nil and self.chatTimeIds[chatType][key] ~= nil then
            if #self.chatTimeIds[chatType][key] > 0 then
                local value = self.chatTimeIds[chatType][key][1]
                return value
            else
                return -100
            end
        else
            return -100
        end
    end
    return -100
end

---@param isRemoveAll boolean @是否移除所有
function ChatDataManager:RemoveTimeIdByChatType(chatType, key, isRemoveAll)
    if chatType == ChatType.World or chatType == ChatType.Local or ChatType.PVPRoom or ChatType.Local then
        if self.chatTimeIds[chatType] ~= nil and self.chatTimeIds[chatType][key] ~= nil then
            if #self.chatTimeIds[chatType][key] > 0 then
                if isRemoveAll then
                    self.chatTimeIds[chatType][key] = {}
                else
                    table.remove(self.chatTimeIds[chatType][key], 1)
                end
            else
                print("当前chatType下没有计时器ID")
            end
        else
            print("没有该chatType的ID表，该chatType不用计时")
        end
    end
end

---@return table<ChatType,number>
function ChatDataManager:GetLeftChatTime()
    local leftTime = {}
    for k, chatType in pairs(self.needTimeCountTypes) do
        local value = self:GetTimerIdOrTimeByChatType(chatType, ChatTimeOrId.Time)
        leftTime[chatType] = value - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    end

    return leftTime
end

---@param leftTime table<ChatType,number> @更新时间前的所剩时间
function ChatDataManager:UpdateTime(leftTime)
    for chatType, leftTimeValue in pairs(leftTime) do
        self:SetTimerIdOrTimeByChatType(chatType, ChatTimeOrId.Time, leftTimeValue)
    end
end
