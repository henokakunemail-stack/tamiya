---@class ClubChatDataManager
ClubChatDataManager = class("ClubChatDataManager")

function ClubChatDataManager:Get()
    if self._instance == nil then
        self._instance = ClubChatDataManager()
    end
    return self._instance
end

function ClubChatDataManager:initialize()
    ---@type table<number,ChatData>
    self.messageList = {}
    self.isConnectedSuccess = false
    self.isReceive5002 = false
    self.isInitChatScrollList = false--是否已经初始化了聊天界面
    self.chatIntervalTime = 0--聊天时间间隔
    self.isReceiveLately = false
    self.isReceiveLog = false
end




function ClubChatDataManager:SetIsReceiveLately(isReceiveLately)
    self.isReceiveLately = isReceiveLately
end
function ClubChatDataManager:GetIsReceiveLately()
    return self.isReceiveLately
end

function ClubChatDataManager:SetIsReceiveLog(isReceiveLog)
    self.isReceiveLog = isReceiveLog
end
function ClubChatDataManager:GetIsReceiveLog()
    return self.isReceiveLog
end

function ClubChatDataManager:SetIsReceive5002(isReceive5002)
    self.isReceive5002 = isReceive5002
end
function ClubChatDataManager:GetIsReceive5002()
    return self.isReceive5002
end

function ClubChatDataManager:SetIsConnectedSuccess(isConnectedSuccess)
    self.isConnectedSuccess = isConnectedSuccess
end
function ClubChatDataManager:GetIsConnectedSuccess()
    return self.isConnectedSuccess
end


function ClubChatDataManager:SetIsInitChatScrollList(isInitChatScrollList)
    self.isInitChatScrollList = isInitChatScrollList
end
function ClubChatDataManager:GetIsInitChatScrollList()
    return self.isInitChatScrollList
end

function ClubChatDataManager:SetChatIntervalTime(intervalTime)
    self.chatIntervalTime = intervalTime
end
function ClubChatDataManager:GetChatIntervalTime()
    return self.chatIntervalTime
end

function ClubChatDataManager:GetMessageTotalCount()
    if self.messageList==nil then
        return 0
    else
        return #self.messageList
    end
end

---@return ChatData
function ClubChatDataManager:GetChatDataByIndex(index)
    if self.messageList == nil then
        return
    end
    return self.messageList[index]
end

function ClubChatDataManager:AddChatMessage(msg, clubChatMessageType)
    local clubChatData = ChatData()
    if clubChatMessageType == ChatPrefabType.Talk then
        clubChatData:SetWorldLocalMsg(msg)
    end
    table.insert(self.messageList, clubChatData)
end
function ClubChatDataManager:AddLatelyMessage(latelyMessage, messageType)
    local clubChatData = ChatData()
    clubChatData:SetLatelyMessage(latelyMessage, messageType)
    if messageType == ChatPrefabType.Talk and clubChatData.playerid == 0 then
        return
    end
    table.insert(self.messageList, clubChatData)
end

function ClubChatDataManager:AddMultiplyLatelyMessage(messageList, messageType)
    if self.messageList == nil then
        self.messageList = {}
    end
    if #messageList > 0 then
        for i = 1, #messageList do
            self:AddLatelyMessage(messageList[i], messageType)
        end
    end
    table.sort(self.messageList, function(a, b)
        return a.chattime < b.chattime
    end)
end

---@param msg SC_ChatSysNotice
function ClubChatDataManager:TransferSystemNotice(msg, msgParam, isNotice)
    local notificationContent = ClientDataManager:Get():GetTemplateString(msg.templetId)--[-]欢迎[92DEFF]{1}{1}{1}[-]加入俱乐部！
    notificationContent = string.gsub(notificationContent, "{%w}", function(str)
        return string.format("<color=#%s>", string.sub(str, 2, 7))
    end)
    notificationContent = string.gsub(notificationContent, "(%[%-%])", function(str)
        return string.format("<color=#%s>", "FFFFFF")
    end)
    local i = 0
    notificationContent = string.gsub(notificationContent, "(%{%d%})", function(str)
        if string.match(str, "%d") == "1" then
            i = i + 1
            if isNotice then
                return msgParam[i]
            else
                return msgParam[i].parmStr
            end
        end
    end)
    msg.talkinfo = notificationContent
    return msg
end
---@param msg SC_TalkInfo
function ClubChatDataManager:AfterEnterChat(msg)

    if self:GetIsInChatSystem() then  --在聊天频道
        self:AddMultiplyLatelyMessage({msg.content}, ChatPrefabType.Talk)
        --print("第一次进入聊天界面时--消息长度"..tostring(#msg.latelyChat))
        --local isReceiveLog=self:GetIsReceiveLog()
        --self:SetIsReceiveLately(true)
        local isReceiveLog = true
        if isReceiveLog then
            if not self:GetIsInitChatScrollList() then
                print("初始化聊天列表--接收消息--消息长度")
                UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_InitMemberList)
                self:SetIsInitChatScrollList(true)
            else
                print("已经初始化过了--接收消息--------------更新聊天列表")
                UINotify:Get():SendNotification(UINotifyEvent.ClubChatView_UpdateChatScrollView)
            end
        end
    end
end

function ClubChatDataManager:ClubPlayerChat(msg)
    if self:GetIsInChatSystem() then
        self:AddChatMessage(msg, ChatPrefabType.Talk)
        UINotify:Get():SendNotification(UINotifyEvent.ClubChatView_UpdateChatScrollView)
    end
end


function ClubChatDataManager:ClearChatData(isExit)
    self.messageList = nil
    self.isReceiveLog = false
    self.isReceiveLately = false
    if isExit then
        self.chatIntervalTime = 0
        CommonHelper:ReleasePool(UIModuleID.Club)
    end
end
