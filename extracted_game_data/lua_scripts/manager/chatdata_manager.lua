----聊天总的数据，包括本地，世界，快捷
---@class ChatDataManager
ChatDataManager = class("ChatDataManager")

---@return ChatDataManager
function ChatDataManager:Get()
    if self._instance == nil then
        self._instance = ChatDataManager()
    end
    return self._instance
end

function ChatDataManager:initialize()
    self.worldChatMessageList = {}

    self.localChatMessageList = {}

    self.shortChatMessageList = {}--房间里面的快捷消息
    self:InitExplainData()

    self.privateChatMessageList = {}

    ---@type table<number,ChatPlayerData>
    self.privatePlayerDataDic = {}--私聊玩家信息列表
    self.privatePlayerDataIdxId = {}

    self.roomChatMessageList = {}--房间聊天

    self.clubChatMessageList = {}--俱乐部聊天

    self.inviteMessageList = {}--邀请聊天

    self.systemMessageList = {}--系统聊天

    self.isConnectedSuccess = false

    self.chatTimeIds = {}--当前计时的ID

    self.curSelectPrivateId = -1--私聊当前选择的玩家Id

    self.isReadAllLocalMsg = false--是否已经读取过本地的数据了，在一开始的时候读取，获取到私聊列表

    self.chatType = ChatType.None--当前的聊天类型,用来标记当前是否在聊天界面，不在聊天界面不刷新界面
    -----常量，不需要清除
    self.chatTimeShowInterval = 120--120秒没人发消息，就会显示时间提示

    self.chatMsgLimit = 100--聊天限制条数

    self.needTimeCountTypes = { World = ChatType.World,
                                Local = ChatType.Local,
                                PVPRoom = ChatType.PVPRoom,
                                ShortCut = ChatType.ShortCut }--需要计时的聊天

    self.redPointDic = {}--红点数据，一个好友一个红点，空表--没有红点  不为空--有红点

    self.ChatMd5Dic = {} --发送的内容

    CacheClearTrigger:Get():RegisterEvent(self, self.Clear)
end

---todo   聊天初始化数据
---@param msg SC_TalkInfo[]
function ChatDataManager:Init(msg)
    for i = 1, #msg do
        local chatData = ChatDataManager:Get():SetChatData(msg[i])
        ChatDataManager:Get():AddChatMsgByType(msg[i].infoType, chatData, true, false)
    end
end



function ChatDataManager:GetChatTimeInterval()
    return self.chatTimeShowInterval
end

function ChatDataManager:SetChatType(chatType)
    self.chatType = chatType
end
function ChatDataManager:GetChatType()
    return self.chatType
end

function ChatDataManager:GetChatMsgLimit()
    return self.chatMsgLimit
end

function ChatDataManager:SortMsgByChatType(chatType, playerId)
    local messageList = self:GetChatListByChatType(chatType, playerId)

    ---@param a ChatData
    ---@param b ChatData
    local func = function(a, b)
        local aTime = a:GetSendTimeUnix()
        local bTime = b:GetSendTimeUnix()
        return aTime < bTime
    end

    table.sort(messageList, func)
end

---@param messageList table<number,ChatData>
function ChatDataManager:CheckCountRemoveChatMsg(chatType, messageList, targetPlayerId)
    if messageList == nil then
        messageList = self:GetChatListByChatType(chatType, targetPlayerId)
    end

    if #messageList >= self:GetChatMsgLimit() then
        log("当前已经超过最大限制，要清理数据-------->", #messageList + 1)

        local count = math.floor(self:GetChatMsgLimit() * 0.6)

        if chatType == ChatType.Private then
            ChatDataManager:Get():DeleteLocalMsgByIdx(self:GetWriteMsgPath(PlayerDataManager:Get():GetPlayerRID(), targetPlayerId), count, #messageList)
        end

        for i = 1, count do
            table.remove(messageList, 1)
        end
    end
end

---@param chatData ChatData
function ChatDataManager:AddNotificationMsgByType(chatType, chatData)
    local messageList = self:GetChatListByChatType(chatType, -1)
    table.insert(messageList, chatData)
    self:CheckCountRemoveChatMsg(chatType, messageList, -1)
end

---@param chatData ChatData
function ChatDataManager:AddChatMsgByType(chatType, chatData, isCheck, isWrite)
    isWrite = isWrite == nil and true or isWrite
    isCheck = isWrite == nil and true or isWrite

    if false then --- 关闭客户端保存私聊信息  if isWrite then
        if chatData:GetSendId()==PlayerDataManager:Get():GetPlayerRID() then--如果发送者是自己 那要保存目标的PlayerData信息
            local friendData = FriendDataManager:Get():GetFriendDataByID(chatData:GetTargetPlayerId())
            local chatPlayerData=ChatPlayerData()
            chatPlayerData:SetDataByFriendData(friendData)
            chatData:SetFriendPlayerData(chatPlayerData)
        end
        --正常是需要写入的,除非在读取本地数据的时候不需要读取
        ChatDataManager:Get():WriteSingleChatMsgToLocalByChatType(chatData)
    end

    local playerId = chatData:GetTargetPlayerId()
    if chatType == ChatType.Private then
        if playerId == PlayerDataManager:Get():GetPlayerRID() then--如果是私聊都塞到另一个玩家列表中
            playerId = chatData:GetSendId()
        end
    end
    local messageList = self:GetChatListByChatType(chatType, playerId)



    --local lastMsgData = self:AddChatTimeMsg(chatType, messageList, chatData)

    --if lastMsgData ~= nil then
    --    table.insert(messageList, lastMsgData)
    --end

    table.insert(messageList, chatData)

    if isCheck then
        self:CheckCountRemoveChatMsg(chatType, messageList, chatData:GetTargetPlayerId())
    end

    if chatData:GetSendId() == PlayerDataManager:Get():GetPlayerRID() then
        --if chatData:GetChatType() ~= ChatType.Private then
        --    NetEasePoneFunc:Get():ChatLog(chatData:GetChatContent(), chatData:GetChatType(), "", "", chatData:GetSendTimeUnix(), "", "", 0, "")
        --else
        --    NetEasePoneFunc:Get():ChatLog(chatData:GetChatContent(), chatData:GetChatType(), "", "", chatData:GetSendTimeUnix(), "", chatData:GetTargetPlayerId(), chatData:GetPlayerLevel(), chatData:GetName())
        --end
        if chatData:GetChatType() == ChatType.Private then
            local friendPlayerData= chatData:GetFriendPlayerData()
            if friendPlayerData~=nil then
                self:AddPlayerData(friendPlayerData)
            end
        end
    else
        if chatType == ChatType.Private and isWrite then
            self:UpdateRedDic(chatData:GetTargetPlayerId())
        end
        if chatType == ChatType.Private then
            self:AddPlayerData(chatData:GetPlayerData())
        end
    end
end

-----@param curChatData ChatData
--function ChatDataManager:AddChatTimeMsg(chatType, messageList, curChatData)
--    ---@type ChatData
--    local lastMsgData = nil
--    ---@type ChatData
--    local chatTimeData = nil
--    if #messageList > 0 then
--        lastMsgData = messageList[#messageList]
--        if lastMsgData:GetMessageType()==ChatPrefabType.Time then
--            logError("------聊天的最后一条应该是聊天，不应该是时间才对-----------")
--        end
--        if lastMsgData ~= nil then
--            local chatTime = math.floor((curChatData:GetSendTimeUnix() - lastMsgData:GetSendTimeUnix()) * 0.001)
--            if chatTime >= self.chatTimeShowInterval then
--                chatTimeData = ChatData()
--                chatTimeData:SetChatTimeMsg(curChatData:GetSendTimeUnix())
--            end
--        end
--    else
--        if chatType == ChatType.Private then
--            chatTimeData = ChatData()
--            chatTimeData:SetChatTimeMsg(curChatData:GetSendTimeUnix())
--        end
--    end
--
--    return chatTimeData
--end

---@param chatDataTable table<number,SC_ChatInfo>
function ChatDataManager:AddMultiChatMsgByType(chatType, chatDataTable)
    for i = 1, #chatDataTable do
        ---@type ChatData
        local chatInfo = chatDataTable[i]
        if chatType == ChatType.Private then
            --这地方也必定是私聊
            local priChatData = ChatData()
            priChatData:SetPrivateMsg(chatInfo)

            self:AddPlayerData(priChatData:GetPlayerData())

            chatInfo = priChatData
        end

        self:AddChatMsgByType(chatType, chatInfo, true, true)
    end
end

---@return ChatData
function ChatDataManager:GetChatDataByIndexChatType(chatType, index, playerId)
    local messageList = self:GetChatListByChatType(chatType, playerId)

    if messageList[index] then
        return messageList[index]
    else
        logError("没有该索引的消息，索引是:" , tostring(index) , "  chatType:" , tostring(chatType))
    end
end

function ChatDataManager:UpdateChatDataByIndexChatType(chatType, index, chatData, playerId)
    local messageList = self:GetChatListByChatType(chatType, playerId)

    messageList[index] = chatData
end

function ChatDataManager:GetChatListCountByChatType(chatType, playerId)

    local messageList = self:GetChatListByChatType(chatType, playerId)

    if messageList ~= nil then
        return #messageList
    else
        logError("没有该类型的消息-----chatType是:" , tostring(chatType))
        return 0
    end
end

---消息是否需要自动往上滑动,false为不需要，true为需要
function ChatDataManager:IsNeedAutoScroll(scrollView, chatType, playerId)
   -- print("-------------->当前位置", scrollView.verticalNormalizedPosition)
    local messageCount = self:GetChatListCountByChatType(chatType, playerId)

    if messageCount > 0 then
        --私聊自己发消息更新列表
        local lastMsgData = self:GetChatDataByIndexChatType(chatType, messageCount, playerId)
        if lastMsgData:GetSendId() == PlayerDataManager:Get():GetPlayerRID() then
            return true
        end
    end

    return scrollView.verticalNormalizedPosition < 0.01
end

---@param chatType ChatType
function ChatDataManager:GetChatListByChatType(chatType, playerId)
    local messageList = {}
    if chatType == ChatType.World then
        messageList = self.worldChatMessageList
    elseif chatType == ChatType.Local then
        messageList = self.localChatMessageList
    elseif chatType == ChatType.PVPRoom then
        messageList = self.roomChatMessageList
    elseif chatType == ChatType.Club then
        messageList = self.clubChatMessageList
    elseif chatType == ChatType.Invite then
        messageList = self.inviteMessageList
    elseif chatType == ChatType.System then
        messageList = self.systemMessageList
    elseif chatType == ChatType.Private then
        playerId = tostring(playerId)
        if playerId ~= "0" and playerId ~= "-1"  then
            messageList = self.privateChatMessageList[playerId]
        else
            messageList = self.privateChatMessageList
        end
    elseif chatType == ChatType.ShortCut then
        messageList = self.shortChatMessageList
    end
    if messageList == nil then
        self:UpdateChatMsgListByChatType(chatType, {}, playerId)
        return self:GetChatListByChatType(chatType, playerId)
    else
        return messageList
    end
end

function ChatDataManager:UpdateChatMsgListByChatType(chatType, messageList, playerId)
    if chatType == ChatType.World then
        self.worldChatMessageList = messageList
    elseif chatType == ChatType.Local then
        self.localChatMessageList = messageList
    elseif chatType == ChatType.PVPRoom then
        self.roomChatMessageList = messageList
    elseif chatType == ChatType.Club then
        self.clubChatMessageList = messageList
    elseif chatType == ChatType.Invite then
        self.inviteMessageList = messageList
    elseif chatType == ChatType.System then
        self.systemMessageList = messageList
    elseif chatType == ChatType.Private then
        if tostring(playerId) ~= "-1" then
            playerId = tostring(playerId)
            self.privateChatMessageList[playerId] = messageList
        else
            self.privateChatMessageList = messageList
        end
    elseif chatType == ChatType.ShortCut then
        self.shortChatMessageList = messageList
    end
end

function ChatDataManager:ClearChatDataByChatType(chatType, playerId)
    if chatType == ChatType.World then
        self.worldChatMessageList = {}
    elseif chatType == ChatType.Local then
        self.localChatMessageList = {}
    elseif chatType == ChatType.Club then
        self.clubChatMessageList = {}
    elseif chatType == ChatType.Invite then
        self.inviteMessageList = {}
    elseif chatType == ChatType.System then
        self.systemMessageList = {}
    elseif chatType == ChatType.PVPRoom then
        self.roomChatMessageList = {}
        self:RemoveTimeIdByChatType(chatType, ChatTimeOrId.TimeId, true)
    elseif chatType == ChatType.Private then

        if tostring(playerId) ~= "-1" then
            playerId = tostring(playerId)
            self.privateChatMessageList[playerId] = {}
        else
            self.privateChatMessageList = {}
        end

    elseif chatType == ChatType.ShortCut then
        self.shortChatMessageList = {}
        self:RemoveTimeIdByChatType(chatType, ChatTimeOrId.TimeId, true)
    end
end

---@param msg  SC_TalkInfo
---@param chatType ChatType
function ChatDataManager:SetChatData(msg)
    --chatType = chatType or self.chatType


    local chatData = ChatData()
    chatData:SetDataByMessage(msg,ChatPrefabType.Talk)
    if msg.rid == PlayerDataManager:Get():GetPlayerRID() then
        chatData.playerData.guildId = PlayerDataManager:Get():GetGuildId()
        chatData.playerData.guildName = PlayerDataManager:Get():GetGuildName()
    end
    if chatData == ChatType.Private then
        chatData:SetPrivateMsg(msg)
    end
    --elseif chatType == ChatType.PVPRoom then
    --    chatData:SetRoomChatMsg(msg)
    --elseif chatType == ChatType.ShortCut then
    --    chatData:SetShortCutMsg(msg)
    --elseif chatType == ChatType.World or chatType == ChatType.Local or chatType == ChatType.Club then
    --    if msg.chatInfo.type == ChatOrLinkType.Link then
    --        local shareType = self:GetChatShareType(msg.chatInfo.content)
    --        if shareType == ShareType.ClubInvite then
    --            chatData:SetClubInviteMsg(msg)
    --        elseif shareType == ShareType.RoomInvite then
    --            chatData:SetRoomInviteMsg(msg)
    --        end
    --    else
    --        chatData:SetWorldLocalMsg(msg)
    --    end
    --end
    return chatData
end

---@param msg  SC_TalkInfo
function ChatDataManager:UpdateChatDataSelf(msg)
    if msg.playerId == PlayerDataManager:Get():GetPlayerRID() then
        chatInfo.playerData.guildId = PlayerDataManager:Get():GetGuildId()
        chatInfo.playerData.guildName = PlayerDataManager:Get():GetGuildName()
    end
    return msg
end

function ChatDataManager:GetChatShareType(content)
    ---@type RaceRoomShareData
    local paramTab = Dll_JSON.decode(content)
    return paramTab.shareType
end

---@param chatData ChatData
---@param chatType ChatType
function ChatDataManager:UpdateScrollList(chatData, chatType)
    chatType = chatType or self.chatType

    if chatType == chatData:GetChatType() then
        local userdata = {}
        userdata.chatType = chatData:GetChatType()
        userdata.playerId = chatData:GetTargetPlayerId()

        if chatType == ChatType.PVPRoom then
            UINotify:Get():SendNotification(UINotifyEvent.RaceRoomDetailView_UpdateChatScrollView, userdata)
            UINotify:Get():SendNotification(UINotifyEvent.ChatView_UpdateChatScrollView, userdata)
        elseif chatType == ChatType.ShortCut then
            UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_SetTalkContent, {chatData:GetChatContent(),chatData:GetChatIndex()})
            UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_InitChatList, ChatType.ShortCut)
        elseif chatType == ChatType.Private then
            if userdata.playerId == self:GetCurSelectPrivateId() then
                UINotify:Get():SendNotification(UINotifyEvent.ChatView_UpdateChatScrollView, userdata)
            end
        elseif chatType == ChatType.World or chatType == ChatType.Local then
            if chatData:GetChatOrLinkType() == ChatOrLinkType.Link and chatData:GetSendId() == PlayerDataManager:Get():GetPlayerRID() then
                print("自己分享不用刷新聊天UI")
            else
                UINotify:Get():SendNotification(UINotifyEvent.ChatView_UpdateChatScrollView, userdata)
            end
        elseif chatType == ChatType.Club then
            UINotify:Get():SendNotification(UINotifyEvent.ChatView_UpdateChatScrollView, userdata)
        elseif chatType == ChatType.Invite then
            UINotify:Get():SendNotification(UINotifyEvent.ChatView_UpdateChatScrollView, userdata)
        elseif chatType == ChatType.System then
            UINotify:Get():SendNotification(UINotifyEvent.ChatView_UpdateChatScrollView, userdata)
        end
    end
end

function ChatDataManager:Clear()
    self.worldChatMessageList = {}

    self.localChatMessageList = {}

    self.privateChatMessageList = {}

    self.roomChatMessageList = {}

    self.clubChatMessageList = {}

    self.inviteMessageList = {}

    self.isConnectedSuccess = false

    self.curSelectPrivateId = -1

    self.chatTimeIds = {}

    self.isGetOfflineMsg = false--是否已经向服务器申请过离线消息

    self.chatType = ChatType.None--当前的聊天类型,用来标记当前是否在聊天界面，不在聊天界面不刷新界

    self.shortChatMessageList = {}

    self:ClearExplainData()

    self:ClearPlayerData()
end

---@param ... table<SC_TalkInfo>
function ChatDataManager:TalkInfosParser(...)
    local args = {...}
    for _,v in ipairs(args) do
        for _, talkInfo in ipairs(v) do
            self:TalkInfoParser(talkInfo,true)
        end
    end
end

---@param msg SC_TalkInfo
function ChatDataManager:TalkInfoParser(msg,isHistory)
    CommonHelper:RecMsgFilter(msg.infoType,msg.rid,msg.content,function()

        --msg.content = ChatDataManager:EmojiParse(msg.content)
        --if msg.infoType==ChatType.Local then--本服的聊天也要显示到世界中,零时优化服务器压力
        --    msg.infoType=ChatType.World
        --end
        local chatType=msg.infoType

        if chatType == ChatType.World  or chatType == ChatType.Local then
            ---世界本服聊天
            local chatData = ChatDataManager:Get():SetChatData(msg)
            ChatDataManager:Get():AddChatMsgByType(msg.infoType, chatData, true, false)
            ChatDataManager:Get():UpdateScrollList(chatData)
            ---刷新主界面UI
            UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_UpdateChatText, { msg.infoType, -1 })
        elseif chatType == ChatType.Invite then
            ---邀请
            local chatData = ChatDataManager:Get():SetChatData(msg)
            ChatDataManager:Get():AddChatMsgByType(msg.infoType, chatData, true, false)
            ChatDataManager:Get():UpdateScrollList(chatData)
            UINotify:Get():SendNotification(UINotifyEvent.ChatView_SetPrivateShowData,  msg.infoType)
            ---刷新主界面UI
            UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_UpdateChatText, { msg.infoType, -1 })
        elseif chatType == ChatType.System then
            --local chatData = ChatDataManager:Get():SetChatData(msg)
            --ChatDataManager:Get():AddChatMsgByType(msg.infoType, chatData, true, false)
            --ChatDataManager:Get():UpdateScrollList(chatData)
            -----刷新主界面UI
            --UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_UpdateChatText, { msg.infoType, -1 })
        elseif chatType == ChatType.Private then
            ---私聊
            local chatData = ChatDataManager:Get():SetChatData(msg, ChatType.Private)
            if not CommonHelper:IsNullOrEmpty(msg.content) then
                ChatDataManager:Get():AddChatMsgByType(msg.infoType, chatData, true, true)
                ChatDataManager:Get():UpdateScrollList(chatData)
            else
                if PlayerDataManager:Get():GetPlayerRID()~=chatData.sendId then
                    if msg.contentjson==CommonHelper:GetTempStr_Default(TemplateStringID.RefuseInvite) then
                        if msg.targId==PlayerDataManager:Get():GetPlayerRID() then
                            if not isHistory then
                                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RefuseInvite))
                            end
                        end
                    else
                        if not isHistory then
                            InviteDataManager:Get():AddInviteMsgByType(chatData, ChatInviteType.RaceRoom)
                            CommonHelper:OpenInvitePopView()
                        end
                    end
                end
            end
        elseif chatType == ChatType.PVPRoom then
            ---房间赛聊天
            local chatData = ChatDataManager:Get():SetChatData(msg, msg.infoType)
            ChatDataManager:Get():AddChatMsgByType(chatData.chatType, chatData, false, false)
            ChatDataManager:Get():UpdateScrollList(chatData)
        elseif chatType == ChatType.Club then
            ---俱乐部聊天
            local chatData = ChatDataManager:Get():SetChatData(msg, msg.infoType)
            ChatDataManager:Get():AddChatMsgByType(msg.infoType, chatData, true, false)
            ChatDataManager:Get():UpdateScrollList(chatData)
            ----刷新主界面UI
            UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_UpdateChatText, { msg.chatType, -1 })
            ----刷新俱乐部UI
            UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_UpdateChatScrollView)
        elseif chatType == ChatType.System then
            ---系统消息

        else
            ---其它聊天
        end

    end)
    --content = "123123123",
    --infoType = 4,
    --rid = 10202,
    --sendName = "aabb",
    --targId = 0

    --ClubChatDataManager:Get():AfterEnterChat(msg)
end

function ChatDataManager:EmojiParse(content)--example#12#34#56#89#1#02#01

    -- 循环查找所有的'#'及其后两位数字
    local result = {}
    for match in string.gmatch(content, "#(%d%d)") do
        table.insert(result, match)
    end

    if #result > 0 then
        for i = 1, #result do
            if tonumber(result[i])>-1 and tonumber(result[i])<EmojiCount then
                content=string.gsub(content,"#"..result[i],string.format("<sprite=%s>",result[i]))
            end
        end
    end
    result={}
    for match in string.gmatch(content, "#(%d)") do
        table.insert(result, match)
    end
    if #result > 0 then
        for i = 1, #result do
            if tonumber(result[i])>-1 and tonumber(result[i])<EmojiCount then
                content=string.gsub(content,"#"..result[i],string.format("<sprite=%s>",result[i]))
            end
        end
    end
    return content
end

---@param noticeItemData NoticeItemData
function ChatDataManager:PlayRollNotice(noticeItemData)
    local chatData = ChatData()
    chatData:SetDataByNoticeData(noticeItemData)
    ChatDataManager:Get():AddChatMsgByType(chatData.chatType, chatData, true, false)
    ChatDataManager:Get():UpdateScrollList(chatData)
    ---刷新主界面UI
    UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_UpdateChatText, {chatData.chatType, -1 })
end














