----私聊玩家数据,每次发言都会更新玩家的数据，根据最新的来更新左侧列表里的数据，也就是左侧玩家的数据，是他最后一次发言的数据
----如果当前的数据和他最后一次发言数据有差异，只要重新发言一次，就可以更新
---@class ChatPlayerData
ChatPlayerData = class("ChatPlayerData")

function ChatPlayerData:initialize()
    self.playerId =0
    self.icon = ""
    self.iconFrame = 2
    self.level = 0
    self.name = 0
    self.guildId =0
    self.guildName =""
    self.serverId =0
    self.rLevelId =0
    self.leaveTime =0
    self.sign = 0
    self.rankScore = 0

end

---@param msg  SC_TalkInfo
function ChatPlayerData:SetData(msg)

   self.playerId =msg.rid
   self.icon = msg.headicon
   self.iconFrame = msg.iconframe
   self.level = msg.curlevel
   self.playerName = msg.sendName
   self.guildId = 0
   self.guildName = ""
   self.serverId =0
   self.rLevelId =0
   self.leaveTime = msg.logouttime
   self.sign = 0
   self.rankScore = msg.score

end

function ChatPlayerData:SetReadPlayerData(data)
    self.playerId =data.playerId
    self.icon = data.icon
    self.iconFrame = data.iconFrame
    self.level = data.level
    self.playerName = data.playerName
    self.guildId = data.guildId
    self.guildName = data.guildName
    self.serverId =data.serverId
    self.rLevelId =data.rLevelId
    self.leaveTime = data.leaveTime
    self.sign = data.sign
    self.rankScore = data.rankScore
end

---获取ChatPlayerData写入的属性数据
function ChatPlayerData:GetWritePlayerData()

    local chatPlayerData = {
        playerId=self.playerId,
        icon=self.icon,
        iconFrame=self.iconFrame,
        level=self.level,
        playerName=self.playerName,
        guildId=self.guildId,
        guildName=self.guildName,
        serverId=self.serverId,
        rLevelId=self.rLevelId,
        leaveTime=self.leaveTime,
        sign=self.sign,
        rankScore=self.rankScore,
    }
    return chatPlayerData
end

---@param friendData  FriendData
function ChatPlayerData:SetDataByFriendData(friendData)

    self.playerId =friendData:GetPlayerId()
    self.icon = friendData:GetPlayerIcon()
    self.iconFrame = friendData:GetPlayerIconFrame()
    self.level = friendData:GetPlayerLV()
    self.playerName =friendData:GetPlayerName()
    self.guildId = 0
    self.guildName = ""
    self.serverId =0
    self.rLevelId =0
    self.leaveTime = friendData:GetLeaveTime()
    self.sign = 0
    self.rankScore = friendData:GetRankScore()

end

function ChatPlayerData:GetPlayerId()
    return tonumber(self.playerId)
end

function ChatPlayerData:GetPlayerLV()
    return self.level
end

function ChatPlayerData:GetPlayerIcon()
    return self.icon
end

function ChatPlayerData:GetPlayerIconFrame()
    return self.iconFrame
end

function ChatPlayerData:GetPlayerName()
    return self.playerName
end

function ChatPlayerData:GetLeaveTimeUnix()
    return self.leaveTime
end

function ChatPlayerData:GetServerName()
    return self.serverId
end

function ChatPlayerData:GetRankScore()
    return self.rankScore
end

function ChatPlayerData:SetLeaveTimeUnix(logouttime)
    self.leaveTime=logouttime
end

------------------------------------------------------------


--------------------------私聊数据，私聊不分好友，这里主要是私聊玩家数据
function ChatDataManager:GetCurSelectPrivateId()
    return self.curSelectPrivateId
end
function ChatDataManager:SetCurSelectPrivateId(curSelectPrivateId)
    self.curSelectPrivateId = curSelectPrivateId
end

function ChatDataManager:SetIsReadAllLocalMsg(isReadAllLocalMsg)
    self.isReadAllLocalMsg = isReadAllLocalMsg
end
function ChatDataManager:GetIsReadAllLocalMsg()
    return self.isReadAllLocalMsg
end

function ChatDataManager:GetWriteMsgPath(sendPid, targetPid, path)
    if sendPid and targetPid then
        sendPid = tonumber(sendPid)
        targetPid = tonumber(targetPid)
        return string.format("%s/%d%d.txt", Path.PersistentDataPath, sendPid, targetPid)
    else
        return string.format("%s/%s.txt", Path.PersistentDataPath, path)
    end
end

---@param playerData ChatPlayerData
---@return ChatPlayerData
function ChatDataManager:AddPlayerData(playerData)

    --log("     ChatDataManager:AddPlayerData:      "..tostring(playerData) ,debug.traceback() )
    local chatPlayerData = playerData

    if self.privatePlayerDataDic == nil then
        self.privatePlayerDataDic = {}
    end
    if self.privatePlayerDataIdxId == nil then
        self.privatePlayerDataIdxId = {}
    end

    local isNeedRefreshPriList = false

    if self.privatePlayerDataDic[chatPlayerData:GetPlayerId()] == nil then
        table.insert(self.privatePlayerDataIdxId, 1, chatPlayerData:GetPlayerId())
    else
        self:SortPlayerData(chatPlayerData:GetPlayerId())
        isNeedRefreshPriList = self:IsNeedRefreshPriList(self:GetPlayerDataById(chatPlayerData:GetPlayerId()), chatPlayerData)
    end

    self.privatePlayerDataDic[chatPlayerData:GetPlayerId()] = chatPlayerData
    if isNeedRefreshPriList then
        UINotify:Get():SendNotification(UINotifyEvent.ChatView_UpdatePrivateList)
    end

    return chatPlayerData, isNeedRefreshPriList
end

function ChatDataManager:RemovePlayerData(playerId)
    self.privatePlayerDataDic[playerId] = nil
    for i = #self.privatePlayerDataIdxId, 1, -1 do
        if self.privatePlayerDataIdxId[i] == playerId then
            table.remove(self.privatePlayerDataIdxId, i)
            return true
        end
    end
    return false
end

function ChatDataManager:DeletePrivateChat(targetPlayerId)
    if self:RemovePlayerData(targetPlayerId) then
        self:DeleteFile(targetPlayerId)
        self:ClearChatDataByChatType(ChatType.Private, targetPlayerId)
        self:SetCurSelectPrivateId(-1)
    end
end

function ChatDataManager:SortPlayerData(playerId)
    if self.privatePlayerDataIdxId[1] ~= nil and self.privatePlayerDataIdxId[1] ~= playerId then
        for i = #self.privatePlayerDataIdxId, 1, -1 do
            if self.privatePlayerDataIdxId[i] == playerId then
                table.remove(self.privatePlayerDataIdxId, i)
                table.insert(self.privatePlayerDataIdxId, 1, playerId)
                break
            end
        end
    end
end

function ChatDataManager:GetPlayerDataById(playerId)
    if self.privatePlayerDataDic[playerId] ~= nil then
        return self.privatePlayerDataDic[playerId]
    else
        logError("当前私聊列表里没有该id")
        return -1
    end
end

function ChatDataManager:GetPlayerDataByIndex(index)
    local playerId = self.privatePlayerDataIdxId[index]
    if playerId ~= nil then
        return self:GetPlayerDataById(playerId)
    else
        logError("私聊列表里没有该index")
        return -1
    end
end

function ChatDataManager:GetPlayerDataCount()
    if self.privatePlayerDataIdxId ~= nil then
        return #self.privatePlayerDataIdxId
    else
        return 0
    end
end

---是否需要刷新指定玩家的数据,比如该玩家更改了头像
---@param old  ChatPlayerData
---@param new  ChatPlayerData
function ChatDataManager:IsNeedRefreshPriList(old, new)
    if old == -1 then
        return true
    end
    local isNeed = false
    if old:GetPlayerIcon() ~= new:GetPlayerIcon() or old:GetPlayerIconFrame() ~= new:GetPlayerIconFrame() then
        isNeed = true
    end
    if old:GetRankScore() ~= new:GetRankScore() then
        isNeed = true
    end
    if (old:GetLeaveTimeUnix() > 0 and new:GetLeaveTimeUnix() < 0) or (old:GetLeaveTimeUnix() < 0 and new:GetLeaveTimeUnix() > 0) then
        isNeed = true
    end

    return isNeed
end

---@param playerData ChatPlayerData
function ChatDataManager:UpdatePlayerData(playerData)
    self.privatePlayerDataDic[playerData:GetPlayerId()] = playerData
end

function ChatDataManager:ClearPlayerData()

    self.privatePlayerDataDic = {}

    self.privatePlayerDataIdxId = {}

    self.isReadAllLocalMsg = false
end


