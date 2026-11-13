---@class ChatShareParam
---@field shareType
---@field chatType
---@field shareId
---@field cellId
---@field shareName
ChatShareParam = class("ChatShareParam")
function ChatShareParam:initialize()
    self. shareType = ShareType.Article-- 分享类型 1物品 2车辆 3结算 4回放
    self. chatType = ChatType.None-- 1世界 2公会 3好友 4房间
    self. shareId = -1-- 道具ID/carID/结算ID/回放ID
    self. cellId = -1 --分享物品的时候才有
    self. shareName = "" --分享者的名字
end

---@param msg ChatShareParam
function ChatShareParam:SetData(msg)
    self. shareType = msg.shareType-- 分享类型 1物品 2车辆 3结算 4回放
    self. chatType = msg.chatType-- 1世界 2公会 3好友 4房间
    self. shareId = msg.shareId-- 道具ID/carID/结算ID/回放ID
    self. cellId = msg.cellId --分享物品的时候才有
    self. shareName = msg.shareName --分享者的名字
end

---获取ChatShareParam写入的属性数据
function ChatShareParam:GetWriteChatShareParamData()
    local chatShareParamData = {
        shareType=self.shareType,
        chatType=self.chatType,
        shareId=self.shareId,
        cellId=self.cellId,
        shareName=self.shareName
    }
    return chatShareParamData
end

---@class ChatData
---@field playerData ChatPlayerData
---@field friendPlayerData ChatPlayerData
---@field chatType
---@field sendId
---@field targId
---@field content
---@field imageSpanContent
---@field translateContent
---@field messageType ChatPrefabType
---@field shareId
---@field psInfo table<number,ChatShareParam>
ChatData = class("ChatData")
---@param msg  SC_TalkInfo
function ChatData:initialize()

    self.playerData = ChatPlayerData()

    self.chatType = -1

    self.sendId = ""--消息是谁发的

    self.targId = -1

    self.content = ""

    self.SendIndex=-1

    ---@type ChatPrefabType
    self. messageType = ChatPrefabType.None

    self.shareId = 0--分享id
    ---@type table<number,ChatShareParam> @分享信息
    self.psInfo = {}

end

---获取chatData写入的属性数据
function ChatData:GetWriteChatData()
    local chatData=
    {
        chatType = self.chatType,
        sendId = self.sendId,
        targId = self.targId,
        content = self.content,
        messageType = self.messageType,
        shareId = self.shareId,
        psInfo={}
    }
    if self.playerData~=nil then
        chatData.playerData=self.playerData:GetWritePlayerData()
    end
    if self.friendPlayerData~=nil then
        chatData.friendPlayerData=self.friendPlayerData:GetWritePlayerData()
    end
    for i = 1, #self.psInfo do
        if self.psInfo[i]~=nil then
            table.insert(chatData.psInfo,self.psInfo[i]:GetWriteChatShareParamData())
        else
            table.insert(chatData.psInfo,nil)
        end
    end
    return chatData
end


---@param msg  SC_TalkInfo
function ChatData:SetDataByMessage(msg, messageType)

    self.playerData:SetData(msg)
    self.chatType = msg.infoType
    self.sendId = msg.rid--消息是谁发的
    self.targId = msg.targId -- 发给谁
    self.sendTime = msg.sendtime
    if not CommonHelper:IsNullOrEmpty(msg.content) then
        self.content = msg.content --内容
        self.imageSpanContent = ChatDataManager:EmojiParse(msg.content)
        ---@type ChatPrefabType
        self. messageType = messageType
        if self.chatType==ChatType.PVPRoom then
            if tonumber(msg.subtype)==1 then
                self.chatType=ChatType.PVPRoom
            end
            if tonumber(msg.subtype)==2 then
                self.chatType=ChatType.ShortCut
                self.SendIndex=tonumber(msg.index)
            end
        end
    else
        if msg.contentjson==CommonHelper:GetTempStr_Default(TemplateStringID.RefuseInvite) then

        elseif not CommonHelper:IsNullOrEmpty(msg.contentjson) then
            try( function()
                local shareData = Dll_JSON.decode(msg.contentjson)
                if shareData.shareType==ShareType.RoomInvite then
                    self:SetRoomInviteMsg(msg.contentjson)
                end
                if shareData.shareType==ShareType.ClubInvite then
                    self:SetClubInviteMsg(msg.contentjson)
                end
                if shareData.shareType==ShareType.ChallengeMatchInvite then
                    self:SetChallengeMatchInviteMsg(msg.contentjson)
                end
            end).catch(function(error)
                log("  ChatData json 转换失败 msg.contentjson： "..msg.contentjson)
            end)
        end

    end

end

---@param noticeItemData NoticeItemData
function ChatData:SetDataByNoticeData(noticeItemData)
    if  noticeItemData.noticeType ==  NoticeType.SystemNotice then
        self.chatType = ChatType.System
        self.content =  noticeItemData.content ---noticeItemData.content
        self.messageType = ChatPrefabType.Notification
    end
end

---@param msg SC_LatelyChat
function ChatData:SetLatelyMessage(msg, messageType)
    self.shareId = msg.shareId--分享id
    self:SetShareInfoData(msg.psInfo)
end

---@param msg SC_GuildLogData
function ChatData:SetClubLogData(msg)
    self.chatType = ChatType.Club

    self.messageType = ChatPrefabType.Notification

    ---@type notice_config_cell
    local cell=CommonHelper:GetTableDataByID(ConfigNames.notice_config,msg.id)
    self.content = string.gsub(CommonHelper:GetTempStr_Default(cell.templetId), "%{%d%}", msg.args[1])


end

---@param msg  SC_PlayerChatRes
function ChatData:SetWorldLocalBaseData(msg)

    self.playerData.playerId = tostring(msg.chatInfo.playerData.playerId)

    self.chatType = msg.chatType

    self.sendId = tostring(msg.chatInfo.playerData.playerId)

end

----对抗赛世界分享
---@param msg  SC_PlayerChatRes
function ChatData:SetChallengeMatchInviteMsg(msg)
    -- self:SetWorldLocalBaseData(msg)
    self.content=msg
    self.messageType = ChatPrefabType.ChallengeMatchInvite
end

----俱乐部世界和本地分享
---@param msg  SC_PlayerChatRes
function ChatData:SetClubInviteMsg(msg)
   -- self:SetWorldLocalBaseData(msg)
    self.content=msg
    self.messageType = ChatPrefabType.ClubInvite
end

----房间世界和本地分享
---@param msg  SC_PlayerChatRes
function ChatData:SetRoomInviteMsg(msg)
    --self:SetWorldLocalBaseData(msg)
    self.content=msg
    self.messageType = ChatPrefabType.RoomInvite
end

----世界和本地聊天
---@param msg  SC_PlayerChatRes
function ChatData:SetWorldLocalMsg(msg)
    self:SetWorldLocalBaseData(msg)

    self.messageType = ChatPrefabType.Talk

    self.shareId = msg.shareId

    local share = {}
    self:SetShareInfoData(share)
end

----房间内快捷聊天
---@param msg  SC_PlayerChatRes
function ChatData:SetShortCutMsg(msg)
    self:SetWorldLocalMsg(msg)
end

----房间聊天
---@param msg  SC_PlayerChatRes
function ChatData:SetRoomChatMsg(msg)
    self:SetWorldLocalMsg(msg)
end

----俱乐部聊天
---@param msg  SC_PlayerChatRes
function ChatData:SetClubChatMsg(msg)
    self:SetWorldLocalMsg(msg)
end

----设置两分钟没人发言后的时间信息
--function ChatData:SetChatTimeMsg(chatTime)
--    self.chatInfo.sendTime = chatTime
--    self.messageType = ChatPrefabType.Time
--end



--设置好友私聊信息
---@param chatInfo  SC_TalkInfo
function ChatData:SetPrivateMsg(chatInfo)
    self.chatType = ChatType.Private

    self.playerData.playerId = tostring(chatInfo.targId)

    self.messageType = ChatPrefabType.Talk
    self.sendId = tostring(chatInfo.rid)
    self.sendTime = chatInfo.sendtime
end



--读取本地数据,从本地json里面读取，然后组装成一个ChatData数据结构
---@param msg ChatData
function ChatData:DecodePrivateMsg(msg)
    self.chatType = msg.chatType
    self.messageType = msg.messageType
    self.sendId = msg.sendId
    self.targId = msg.targId
    self.content = msg.content

    if msg.playerData~=nil then
        self.playerData = ChatPlayerData()
        self.playerData:SetReadPlayerData(msg.playerData);
    end
    if msg.friendPlayerData~=nil then
        self.friendPlayerData = ChatPlayerData()
        self.friendPlayerData:SetReadPlayerData(msg.friendPlayerData);
    end
end

--自己发消息
function ChatData:SetSelfMsg()
    self.playerData.icon = PlayerDataManager:Get():GetPlayerIcon()
    self.playerData.iconFrame = PlayerDataManager:Get():GetPlayerIconFrame()
    self.playerData.rankScore = PlayerDataManager:Get():GetRankScore()
    self.playerData.guildName = PlayerDataManager:Get():GetGuildName()
    self.playerData.playerName = PlayerDataManager:Get():GetPlayerName()
    self.sendId = tostring(PlayerDataManager:Get():GetPlayerRID())
end

---@param playerData ChatPlayerData
function ChatData:SetPlayerData(playerData)
    self.playerData = playerData
    self.playerData.playerId = tostring(playerData.playerId)
end

---@param playerData ChatPlayerData
function ChatData:SetFriendPlayerData(playerData)
    self.friendPlayerData = playerData
    self.friendPlayerData.playerId = tostring(playerData.playerId)
end


function ChatData:GetPlayerData()
    return self.playerData
end

function ChatData:GetFriendPlayerData()
    return self.friendPlayerData
end

---这是谁发的消息，比如自己给别人发消息，这个就是自己
function ChatData:GetSendId()
    return tonumber(self.sendId)
end

---这是谁发的消息，比如自己给别人发消息，这个就是自己
function ChatData:SetSendId(sendId)
    self.sendId = tonumber(sendId)
end

---@param chatPrefabType ChatPrefabType
function ChatData:SetMessageType(chatPrefabType)
    self.messageType = chatPrefabType
end

function ChatData:GetPlayerIcon()
    return self.playerData.icon
end

function ChatData:GetPlayerIconFrame()
    return self.playerData.iconFrame
end

function ChatData:GetName()
    return self.playerData.playerName
end

function ChatData:GetClubId()
    return Dll_JSON.decode(self.content).id
end

function ChatData:GetClubName()
    return self.playerData.guildName
end

function ChatData:GetServerId()
    return self.playerData.serverId
end

function ChatData:GetServerName()
    return ClientDataManager:Get():GetServerInfoByServerId(self:GetServerId()).name
end

---这是发送消息的对方ID，比如自己给对方发消息，这个就是对方
function ChatData:GetTargetPlayerId()
    return tonumber(self.targId)
end

function ChatData:GetChatType()
    return self.chatType
end

function ChatData:GetChatOrLinkType()
    return self.type
end

function ChatData:GetLeaveTimeUnix()
    return self.playerData.leaveTime
end

function ChatData:GetSendTimeUnix()
    return self.sendTime
    --return 0
end

function ChatData:GetSendTimeDate()
    return CommonHelper:SetLeaveTime(self.playerData.leaveTime)
end

function ChatData:GetChatContent()
    if CommonHelper:IsNullOrEmpty(self.content) then
        return "*"
    end
    return self.content
end

function ChatData:GetChatImageSpanContent()
    if CommonHelper:IsNullOrEmpty(self.imageSpanContent) then
        return "*"
    end
    return self.imageSpanContent
end

function ChatData:GetChatIndex()
    return self.SendIndex
end

function ChatData:IsTranslate()
    if self.playerData.playerId == PlayerDataManager:Get():GetPlayerRID() then
        return false
    end
    return not (CommonHelper:IsNullOrEmpty(self.translateContent))
end

function ChatData:SetChatTranslateContent(translateContent)
    self.translateContent = translateContent
end

function ChatData:GetChatTranslateContent()
    return self.translateContent
end

function ChatData:IsShow()
    return self.translateContent~="nil" and self.translateContent~="SameLand" and self.translateContent~=self.content
end

function ChatData:GetRankScore()
    return self.playerData.rankScore
end

function ChatData:GetPlayerLevel()
    return self.playerData.level
end

--- ClubShareData / RaceRoomShareData / ChallengeMatchShareData
function ChatData:GetInvitation()
    local strTable = Dll_JSON.decode(self:GetChatContent())
    return strTable
end

---@return
function ChatData:GetChallengeMatchInvitation()
    local strTable = Dll_JSON.decode(self:GetChatContent())
    return strTable
end

---@return ChatPrefabType
function ChatData:GetMessageType()
    return self.messageType
end

---@param msg table<number,ChatShareParam>
function ChatData:SetShareInfoData(msg)
    if #msg > 0 then
        for i = 1, #msg do
            local chatShareParam = ChatShareParam()
            chatShareParam:SetData(msg[i])
            table.insert(self.psInfo, chatShareParam)
        end
    end
end

function ChatData:GetPShareInfo()
    return self.psInfo
end

function ChatData:initialize()

    self.playerData = ChatPlayerData()

    self.chatType = -1

    self.sendId = ""--消息是谁发的

    self.targId = -1

    self.content = ""

    ---@type ChatPrefabType
    self. messageType = ChatPrefabType.None

    self.shareId = 0--分享id
    ---@type table<number,ChatShareParam> @分享信息
    self.psInfo = {}

end

