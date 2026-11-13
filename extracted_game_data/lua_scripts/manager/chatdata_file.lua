----------------聊天中的从本地读取私聊信息
function ChatDataManager:ReadAllChatMsgFromLocal()
    local selfPlayerId = PlayerDataManager:Get():GetPlayerRID()
    local paths = CS.System.IO.Directory.GetFiles(Path.PersistentDataPath, string.format("%d*", selfPlayerId))

    log("私聊的人数有:" , tostring(paths.Length))

    for i = 0, paths.Length - 1 do

        local names = stringSplit(paths[i], '/')

        log("当前匹配的聊天文件的路径长度:", #names, "   完整路径", paths[i])

        names = stringSplit(names[#names], '\\')

        names = #names > 1 and names[#names] or names[1]

        names = string.gsub(names, '.txt', '')

        names = string.gsub(names, tostring(selfPlayerId), '')

        log("私聊对象的ID" , names)

        self:ReadSingleChatMsgFromLocalByChatType(ChatType.Private, names)
    end

end

function ChatDataManager:ReadSingleChatMsgFromLocalByChatType(chatType, playerId)
    self:ClearChatDataByChatType(chatType, playerId)

    local jsonStr = CS.MonoHelper.ReadFileStringByStream(self:GetWriteMsgPath(PlayerDataManager:Get():GetPlayerRID(), playerId), false)

    if not CommonHelper:IsNullOrEmpty(jsonStr) then
        local msgTab = stringSplit(jsonStr, '\r')
        if chatType == ChatType.Private then
            local count = #msgTab - 1
            for i = 1, count do
                local chatData = ChatData()
                chatData:DecodePrivateMsg(Dll_JSON.decode(msgTab[i]))

                self:AddChatMsgByType(chatType, chatData, false, false)
            end
        end
        self:SortMsgByChatType(chatType, playerId)--读取完之后，要排个序，因为离线数据在一开始就已经读取了，时间可能错位
    end
end

---@param chatData ChatData
function ChatDataManager:WriteSingleChatMsgToLocalByChatType(chatData)

    --chatData.class = nil
    --local writeChatData = chatData
    local writeChatData = chatData:GetWriteChatData()
    local jsonStr = string.format("%s\r", Dll_JSON.encode(writeChatData))
    local selfId= tonumber(PlayerDataManager:Get():GetPlayerRID())
    local targetId=chatData:GetTargetPlayerId()
    if targetId==selfId then
        targetId=chatData:GetSendId()
    end
    if jsonStr then

    end
    log("当前写入私聊的路径" , self:GetWriteMsgPath(selfId, targetId))

    CS.MonoHelper.WriteFileStringByStream(self:GetWriteMsgPath(selfId, targetId), jsonStr)
end

function ChatDataManager:DeleteLocalMsgByIdx(filePath, from, to)

    local lines = CS.MonoHelper.ReadFileLines(filePath)

    log("当前已经超过最大限制，要清理数据--------已经存储的txt里面的数据", lines.Length)

    CS.MonoHelper.WriteFileStringByStreamIdx(filePath, lines, from, to)
end

function ChatDataManager:DeleteFile(playerId)

    local path = self:GetWriteMsgPath(PlayerDataManager:Get():GetPlayerRID(), playerId)

    log("删除路径-------->", path)

    CS.MonoHelper.DeleteFile(path)

end


