---@class PvpChatData
PvpChatData = class("PvpChatData")

----设置pvp的聊天内容
---@param msg SC_PlayerChatRes
function PvpChatData:initialize(msg)
    self. playerid = msg.playerId
    self. guildId = msg.guildId
    self. chattime = msg.chatTime
    self. playerstate = msg.playerState
    self. talkinfo = msg.talkInfo
    self. chattype = msg.chatType--聊天类型 1公共 2公会 3PVPRoom
    self. playername = msg.playerName
    self. playerPosition = msg.playerPosition
    -- self. convertTime = self:SetChatTime(msg.chatTime)
    self.roomId = msg.roomId
end

---@class PvpChatDataManager
PvpChatDataManager = class("PvpChatDataManager")

function PvpChatDataManager:initialize()
    self.chatList = {}
    self.chatIntervalTime=0
    self.isInitializeScrollList=false--是否初始化了列表
end

function PvpChatDataManager:Get()
    if self._instance == nil then
        self._instance = PvpChatDataManager()
    end
    return self._instance
end


function PvpChatDataManager:SetIsInitializeScrollList(isInitializeScrollList)
     self.isInitializeScrollList=isInitializeScrollList
end
function PvpChatDataManager:GetIsInitializeScrollList()
    return self.isInitializeScrollList
end



---@param msg SC_PlayerChatRes
function PvpChatDataManager:AddMessage(msg)
    local pvpChatData = PvpChatData(msg)
    table.insert(self.chatList, pvpChatData)
end


function PvpChatDataManager:GetMessageCount()
    return #self.chatList
end

function PvpChatDataManager:GetChatDataByIndex(index)
    if self.chatList == nil then
        logError("消息为空")
        return
    end
    return self.chatList[index]
end




function PvpChatDataManager:PvpPlayerChat(msg)
    self:AddMessage(msg)
    if self:GetIsInitializeScrollList() then
        --UINotify:Get():SendNotification(UINotifyEvent.RoomView_UpdateChatScrollView)
    else
        --UINotify:Get():SendNotification(UINotifyEvent.RoomView_InitChatScrollList)
    end
end

function PvpChatDataManager:SetChatIntervalTime(intervalTime)
    self.chatIntervalTime = intervalTime
end
function PvpChatDataManager:GetChatIntervalTime()
    return self.chatIntervalTime
end

function PvpChatDataManager:ClearData()
    self.chatList = {}
    --UINotify:Get():SendNotification(UINotifyEvent.RoomView_UpdateChatScrollView)
end


