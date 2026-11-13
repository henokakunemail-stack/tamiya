---@class ChatSubsystem
ChatSubsystem = class("ChatSubsystem")

function ChatSubsystem:initialize(...)
     NetResponseEventManager:Get():AddListener(MsgID.NOTIFY_TALK_INFO_S2C_RES, self, self.RecvMsg_PlayerChatData)
    --NetResponseEventManager:Get():AddListener(MsgID.PUSH_PLAYER_CHAT_RES, self, self.RecvMsg_PushPlayerChatRes)
    --
    --NetResponseEventManager:Get():AddListener(MsgID.PLAYER_LOGIN_CHAT_C2C_RES, self, self.RecvMsg_PlayerLogInG2CRes)
    --
    --NetResponseEventManager:Get():AddListener(MsgID.BAN_TALK_PLAYER_S2C_NOTIFY, self, self.RecvMsg_NotifyBanTalkTime)
    --
    --NetResponseEventManager:Get():AddListener(MsgID.ROOM_CHAT_SB2C_RES, self, self.RecvMsg_RoomChat)
    --
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_CHAT_S2C_RES, self, self.RecvMsg_ClubChat)
end

function ChatSubsystem:SendMsg_ChatData(chatType, content, target, json, subType, index, isNotCheckSpaceCharacter,isquickchat)
    json = json and json or ""
    subType = subType and subType or 0
    index = index and index or 1
    isNotCheckSpaceCharacter = isNotCheckSpaceCharacter and isNotCheckSpaceCharacter or false
    isquickchat = isquickchat and isquickchat or 0
    CommonHelper:SendMsgFilter(chatType, content, function()
        local canSend = true
        if isNotCheckSpaceCharacter then
        elseif chatType ~= ChatType.ShortCut and chatType ~= ChatType.Invite and chatType ~= ChatType.Explain and chatType ~= ChatType.RaceRecord and CommonHelper:IsOnlySpaceCharacter(content) then
            CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ChatInfoIsOnlySpaceCharacter))
            canSend = false
        end
        if canSend then
            local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), chatType, target, content, json, subType, index , isquickchat})
            NetManager:Get():Send(MsgID.SEND_TALK_C2S_REQ, data)
            QuickTa:Get():TrackEvent(TrackEventNames.PlayerSendChatInfo, { sendchatinfo = content })
        end
    end)
end



function ChatSubsystem:RecvMsg_PlayerChatData(data)
    ---@type SC_TalkInfo
    local msg = assert(Dll_PB.decode("TalkInfo", data))
   -- print(ProtoMsgHelp.block(msg))
     ChatDataManager:Get():TalkInfoParser(msg)
end



---------------------------------------------------------------------------进入聊天频道
function ChatSubsystem:SendMsg_PlayerLogInG2CReq(pid)
    local reqData = {
        pid = pid,
    }
    local reqBytes = assert(Dll_PB.encode("PlayerLogoutG2CReq", reqData))
    NetManager:Get():SendChat(OldMsgID.PLAYER_LOGIN_CHAT_C2C_REQ, reqBytes)
end

function ChatSubsystem:RecvMsg_PlayerLogInG2CRes(data)
    print("------------------------收到5012-------------进入聊天频道-------")
end

----------------------------------------------------------------------------进入聊天服，进入之后，才开始收服务端推送的信息
---@param selfCreateClubData ClubData
function ChatSubsystem:SendMsg_PlayerEnterChatReq(chatType, selfCreateClubData, selfPlayerId)
    local reqData = {
        chatType = chatType,
        playerId = selfPlayerId,
        guildId = selfCreateClubData.id,
        guildName = selfCreateClubData.name,
        position = selfCreateClubData.position,
    }
    local reqBytes = assert(Dll_PB.encode("PlayerEnterChatReq", reqData))
    print("自己发送的消息进入聊天的消息体---5013")
    NetManager:Get():SendChat(OldMsgID.PLAYER_ENTER_CHAT_REQ, reqBytes)
end

function ChatSubsystem:RecvMsg_PlayerEnterChatRes(data)
    local msg = assert(Dll_PB.decode("PlayerEnterChatRes", data))
    print(ProtoMsgHelp.block(msg))

    ClubChatDataManager:Get():AfterEnterChat(msg)
end

----世界本服聊天（迁移到SendMsg_ChatData）
---@param chatType ChatType
---@param chatOrLinkType ChatOrLinkType
function ChatSubsystem:SendMsg_PlayerChatReq(chatType, talkInfo, chatOrLinkType)
    local reqData = {
        chatType = chatType,
        talkInfo = talkInfo,
        type = chatOrLinkType,
    }
    local reqBytes = assert(Dll_PB.encode("PlayerChatReq", reqData))
    NetManager:Get():SendChat(OldMsgID.PLAYER_CHAT_REQ, reqBytes)
end

function ChatSubsystem:RecvMsg_PushPlayerChatRes(data)
    ---@type SC_PlayerChatRes
    local msg = assert(Dll_PB.decode("PlayerChatRes", data))
    print("返回推送的消息")
    print(ProtoMsgHelp.block(msg))

    if msg.chatInfo.playerData.playerId == PlayerDataManager:Get():GetPlayerRID() then
        if msg.chatInfo.type == ChatOrLinkType.Link then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ShareSuccess))
        end
    end

    local chatData = ChatDataManager:Get():SetChatData(msg, msg.chatType)

    ChatDataManager:Get():AddChatMsgByType(msg.chatType, chatData, true, false)

    ChatDataManager:Get():UpdateScrollList(chatData)

    ---刷新主界面UI
    UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_UpdateChatText, { msg.chatType, -1 })
end

---@param chatShareParam ChatShareParam
function ChatSubsystem:SendMsg_ChatShareInfoReq(chatShareParam)
    local reqData = {
        shareType = chatShareParam.shareType,
        chatType = chatShareParam.chatType, -- 1世界 2公会 3好友 4房间
        shareId = chatShareParam.shareId, -- 道具ID/carID/结算ID/回放ID
        cellId = chatShareParam.cellId,
        shareName = chatShareParam.shareName,
    }
    local reqBytes = assert(Dll_PB.encode("ChatShareInfoReq", reqData))
    NetManager:Get():SendChat(OldMsgID.CHAT_SHARE_INFO_REQ, reqBytes)
end

function ChatSubsystem:RecvMsg_NotifyBanTalkTime(data)
    ---@type SC_NotifyBanTalkTime
    local msg = assert(Dll_PB.decode("NotifyBanTalkTime", data))
    print(ProtoMsgHelp.block(msg))
    if msg.leftTime == -1 then
        msg.leftTime = "-1"
    end
    PlayerDataManager:Get():SetBanTalkLeftTime(msg.leftTime)
end

---房间赛聊天（迁移到SendMsg_ChatData）
---@param chatType ChatType
---@param chatOrLinkType ChatOrLinkType
function ChatSubsystem:SendMsg_RoomChat(chatType, talkInfo, chatOrLinkType)
    ---@type  SC_PlayerChatReq
    local reqData = {
        chatType = chatType,
        talkInfo = talkInfo,
        type = chatOrLinkType,
    }
    local reqBytes = assert(Dll_PB.encode("PlayerChatReq", reqData))
    NetManager:Get():SendSyncBattleServer(OldMsgID.ROOM_CHAT_C2SB_REQ, reqBytes)
end

function ChatSubsystem:RecvMsg_RoomChat(data)
    ---@type SC_PlayerChatRes
    local msg = assert(Dll_PB.decode("PlayerChatRes", data))
    print("返回房间内聊天的消息")
    print(ProtoMsgHelp.block(msg))

    if msg.chatInfo.playerData.playerId == PlayerDataManager:Get():GetPlayerRID() then
        if msg.chatInfo.type == ChatOrLinkType.Link then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ShareSuccess))
        end
    end

    local chatData = ChatDataManager:Get():SetChatData(msg, msg.chatType)

    ChatDataManager:Get():AddChatMsgByType(msg.chatType, chatData, false, false)

    ChatDataManager:Get():UpdateScrollList(chatData)
end

---俱乐部聊天
---@param chatType ChatType
---@param chatOrLinkType ChatOrLinkType
function ChatSubsystem:SendMsg_ClubChat(chatType, talkInfo, chatOrLinkType)
    ---@type  SC_PlayerChatReq
    local reqData = {
        chatType = chatType,
        talkInfo = talkInfo,
        type = chatOrLinkType,
    }
    local reqBytes = assert(Dll_PB.encode("PlayerChatReq", reqData))
    NetManager:Get():SendGuild(OldMsgID.GUILD_CHAT_C2S_REQ, reqBytes)
end

function ChatSubsystem:RecvMsg_ClubChat(data)
    ---@type SC_PlayerChatRes
    local msg = assert(Dll_PB.decode("PlayerChatRes", data))
    print("返回俱乐部的消息")
    print(ProtoMsgHelp.block(msg))

    if msg.chatInfo.playerData.playerId == PlayerDataManager:Get():GetPlayerRID() then
        if msg.chatInfo.type == ChatOrLinkType.Link then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ShareSuccess))
        end
    end

    local chatData = ChatDataManager:Get():SetChatData(msg, msg.chatType)

    ChatDataManager:Get():AddChatMsgByType(msg.chatType, chatData, true, false)

    ChatDataManager:Get():UpdateScrollList(chatData)

    ----刷新主界面UI
    UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_UpdateChatText, { msg.chatType, -1 })
    ----刷新俱乐部UI
    UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_UpdateChatScrollView)
end

local __subsystem = ChatSubsystem()
function ChatSubsystem:Get()
    return __subsystem
end
return __subsystem


