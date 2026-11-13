---@class FriendType
FriendType = {
    None = 0,
    Init = 1, --点击好友按钮请求好友列表
    BlackList = 5, --从好友获取黑名单
    DelFriendInChatPlayerInfo = 6, --从chatplayerinfo里面删除好友
    DelFriendInOtherPlayerInfo = 7, --从otherplayerinfo里面删除好友
    BlackFriendInChatPlayerInfo = 8, --从chatplayerinfo里面拉黑好友
    BlackFriendInOtherPlayerInfo = 9, --从otherplayerinfo里面拉黑好友
    RoomInvite = 10 --房间邀请
}

---@class FriendDataManager
FriendDataManager = class("FriendDataManager")

---@return FriendDataManager
function FriendDataManager:Get()
    if self._instance == nil then
        self._instance = FriendDataManager()
    end
    return self._instance
end

function FriendDataManager:initialize()
    ---@type table<number,FriendData>
    self.FriendDataDic = {}--好友列表
    self.IndexIdList = {}
    self.refreshListTime = 0

    ---@type table<number,FriendData>
    self.searchList = {}--搜索列表

    ---@type table<number,FriendData>
    self.requestList = {}--好友申请列表

    ---@type table<number,BackListData>
    self.blackList = {}--黑名单列表

    ---@type table<number,boolean>
    self.blackDic = {}--黑名单字典 用于判断是否在黑名单中

    ---@type table<number,FriendData>
    self.recommendList = {}--推荐列表

    self.curSelectFriendId = nil--当前选中的好友ID

    self.friendType = FriendType.None

    self.sum = 0--当前好友和申请加自己好友的总人数，有个上限

    self.giveDic = {}--给哪些好友赠送过
    self.recvDic = {}--领取过哪些好友的
    self.sendMeDic = {}--哪些好友给自己送过

    self.sendHeartCount = 0--赠送友情点数量（次数）

    self.receiveHeartCount = 0--领取友情点数量（次数）

    self.redPointDic = {}--红点数据，一个好友一个红点，空表--没有红点，不为空--有红点,这个使用来管理，有没有可以领取的奖励的好友


    CacheClearTrigger:Get():RegisterEvent(self, self.ClearFriendData)

    print("FriendDataManager初始化")
end

----是否可以添加好友
function FriendDataManager:IsCanAddFriend()
    return self.sum < 50
end

function FriendDataManager:SetFriendNum(sum)
    self.sum = sum
end
function FriendDataManager:GetFriendNum()
    return self.sum
end
function FriendDataManager:GetUrl(mid, reqBytes)
    ---@type ServerInfo
    local serverInfo = ClientDataManager:Get():GetServerInfoByIndex(ServerType.Friend, 1)
    local playerId = PlayerDataManager:Get():GetPlayerRID()
    local str = ""
    local convertStr = CommonHelper:ConvertByteArrayToString(reqBytes)
    print("lua        :" .. convertStr)
    --str = string.format("http://%s:%d/friend/base?pid=%d&body=%s&mid=%d", serverInfo.ip, serverInfo.port, playerId, convertStr, mid)
    str = string.format("http://%s:%d/friend/base?", serverInfo.ip, serverInfo.port)

    local jsonStr = {
        pid = tostring(playerId),
        body = convertStr,
        mid = mid,
    }

    jsonStr = Dll_JSON.encode(jsonStr)

    return str, jsonStr
end

function FriendDataManager:SetReceiveHeartCount(receiveHeartCount)
    self.receiveHeartCount = receiveHeartCount
end
function FriendDataManager:GetReceiveHeartCount()
    return self.receiveHeartCount
end
function FriendDataManager:SetSendHeartCount(sendHeartCount)
    self.sendHeartCount = sendHeartCount
end
function FriendDataManager:GetSendHeartCount()
    return self.sendHeartCount
end

---@param friendType FriendType
function FriendDataManager:SetFriendType(friendType)
    self.friendType = friendType
end
function FriendDataManager:GetFriendType()
    return self.friendType
end

function FriendDataManager:SetRefreshListTime(time)
    self.refreshListTime = time
end
function FriendDataManager:GetRefreshListTime()
    return self.refreshListTime
end

function FriendDataManager:SetCurSelectFriendId(friendId)
    self.curSelectFriendId = friendId
end
function FriendDataManager:GetCurSelectFriendId()
    return self.curSelectFriendId
end

---@param msg table<number,SC_FriendInfo>
function FriendDataManager:InitFriendsData(msg)
    self.IndexIdList = {}

    self.FriendDataDic = {}

    for i = 1, #msg do
        ---@type FriendData
        local friendData = FriendData()
        friendData:SetFullData(msg[i])
        local friendId = friendData:GetPlayerId()
        table.insert(self.IndexIdList, friendId)
        self.FriendDataDic[friendId] = friendData
    end

    self:SortFriend(FriendSortType.Time)
end

---@param msg  SC_UserFriends
function FriendDataManager:SetHeartData(msg)
    self.giveDic = {}
    self.sendMeDic = {}
    self.recvDic = {}
    local friendId = -1
    for i = 1, #msg.sends do
        friendId = tonumber(msg.sends[i])
        self.giveDic[friendId] = friendId
    end

    for i = 1, #msg.receives do
        friendId = tonumber(msg.receives[i])
        self.sendMeDic[friendId] = friendId
    end

    for i = 1, #msg.gets do
        friendId = tonumber(msg.gets[i])
        self.recvDic[friendId] = friendId
    end
    self:SetSendHeartCount(#msg.sends)
    self:SetReceiveHeartCount(#msg.gets)

    self:UpdateRed()
end
---@param type FriendGiftType
function FriendDataManager:UpdateHeartData(friendIds, type)
    for i = 1, #friendIds do
        local friendId=friendIds[i]
        if self:GetFriendDataByID(friendId) then
            if type == FriendGiftType.Send then
                self.giveDic[friendId] = friendId
                self:SetSendHeartCount(self:GetSendHeartCount() + 1)
            elseif type == FriendGiftType.Recv then
                self.recvDic[friendId] = friendId
                self:SetReceiveHeartCount(self:GetReceiveHeartCount() + 1)
            end

            self:UpdateRed()
        end
    end

end

----自己是否给这个好友送过
function FriendDataManager:IsGive(friendId)
    if self:GetFriendDataByID(friendId) then
        return self.giveDic[friendId] ~= nil
    end
    return false
end
----自己是否领取过该好友
function FriendDataManager:IsRecv(friendId)
    if self:GetFriendDataByID(friendId) then
        return self.recvDic[friendId] ~= nil
    end
    return false
end
----该好友是否给自己送过
function FriendDataManager:IsSendMe(friendId)
    if self:GetFriendDataByID(friendId) then
        return self.sendMeDic[friendId] ~= nil
    end
    return false
end

function FriendDataManager:UpdateRed()
    for id, _ in pairs(self.FriendDataDic) do
        if self:IsSendMe(id) and not self:IsRecv(id) then
            self:UpdateListRedDic(id, id)
        end
    end
end

---------------------------------------------根据ID获得好友信息
---@return FriendData
function FriendDataManager:GetFriendDataByID(id)
    return self.FriendDataDic[id]
end
function FriendDataManager:SetFriendDataByID(id, friendData)
    self.FriendDataDic[id] = friendData
end
--------------------------------------------根据在无限滚动面板上的位置，获取对应的俱乐部
---@return FriendData
function FriendDataManager:GetFriendDataByIndex(index)
    if self.IndexIdList ~= nil then
        if self.IndexIdList[index] ~= nil then
            return self.FriendDataDic[self.IndexIdList[index]]
        else
            logError("GetFriendDataByIndex--当前索引表里面没有该索引")
        end
    else
        logError("GetFriendDataByIndex--当前抽奖数据列表为空")
    end
end

----------------------------------------------获取好友数量
function FriendDataManager:GetFriendListCount()
    if (self.IndexIdList ~= nil) then
        return #self.IndexIdList
    end
    return 0
end

--------------------------------------------好友是否达到上限
function FriendDataManager:IsFriendLimit()
    --获取配置标的好友数量
    local friendCount = self:GetFriendListCount()
    return false
end

---@param friendSortType FriendSortType
function FriendDataManager:SortFriend(friendSortType)
    local func = function(a, b)
        a = FriendDataManager:Get():GetFriendDataByID(a)
        b = FriendDataManager:Get():GetFriendDataByID(b)
        --print("a"..tostring(a:GetLeaveTime()).." b:"..tostring(b:GetLeaveTime()).."  type:"..type(a:GetLeaveTime()))
        if friendSortType == FriendSortType.Time then

            local aTime = a:GetLeaveTime()
            local bTime = b:GetLeaveTime()

            if aTime > 0 and bTime > 0 then
                return aTime > bTime
            end
            if aTime == -1 and bTime > 0 then
                return true
            end
            if aTime > 0 and bTime == -1 then
                return false
            end
            return false
        end

        if friendSortType == FriendSortType.Level then
            local aLevel = a:GetPlayerLV()
            local bLevel = b:GetPlayerLV()
            return aLevel > bLevel
        end
        return false
    end
    -----@param a FriendData
    -----@param b FriendData
    table.sort(self.IndexIdList, func)
end

---@param friendData FriendData
function FriendDataManager:UpdateFriendData(friendData)
    local friendId = friendData:GetPlayerId()
    self.FriendDataDic[friendId] = friendData
end

---@param playerIds table<number,number> 目前只有一个玩家
---@param isAgree FriendApplyType
function FriendDataManager:DueRequestData(playerIds, isAgree)
    --for i = 1, #playerIds dos
    local friendData = self:RemoveRequestFriendById(playerIds)
    if isAgree == FriendApplyType.Agree then
        self:AddFriend(playerIds[i], friendData)
    end
    --end
end

---@param playerId number
function FriendDataManager:AddFriend(playerId, friendData)
    if self:GetFriendDataByID(playerId) then
        print("已经存在该好友了，不能重复添加，检查数据是否正确")
    else
        self.FriendDataDic[playerId] = friendData
        table.insert(self.IndexIdList, playerId)
    end
end

function FriendDataManager:DelFriend(friendId)
    if not self:GetFriendDataByID(friendId) then
        print("不存在该好友，不能删除，检查数据是否正确")
    else
        self.FriendDataDic[friendId] = nil
        for i = #self.IndexIdList, 1, -1 do
            if self.IndexIdList[i] == friendId then
                table.remove(self.IndexIdList, i)
                break
            end
        end
    end
end

-------search----------------------------
---@param msg table<number,SC_FriendInfo>
function FriendDataManager:InitSearchListData(msg)
    self.searchList = {}
    if #msg <= 0 then
        return -1
    else
        for i = 1, #msg do
            local friendData = FriendData()
            friendData:SetFullData(msg[i])
            table.insert(self.searchList, friendData)
        end
    end
end
function FriendDataManager:GetSearchFriendDataByIndex(index)
    return self.searchList[index]
end

function FriendDataManager:GetSearchFriendCount()
    return #self.searchList
end

-------request----------------------------
---@param msg table<number,SC_BasePlayerData>
function FriendDataManager:InitRequestListData(msg)
    self.requestList = {}
    if #msg <= 0 then
        return -1
    else
        for i = 1, #msg do
            local friendData = FriendData()
            friendData:SetFullData(msg[i])
            table.insert(self.requestList, friendData)
        end
    end
end
function FriendDataManager:GetRequestFriendDataByIndex(index)
    return self.requestList[index]
end

function FriendDataManager:GetRequestFriendCount()
    return #self.requestList
end

function FriendDataManager:RemoveRequestFriendById(id)
    ---@type FriendData
    local temp = nil
    for i = #self.requestList, 1, -1 do
        temp = self.requestList[i]
        if id == temp:GetPlayerId() then
            table.remove(self.requestList, i)
            break
        end
    end
    return temp
end

-------black----------------------------
---@param msg table<number,SC_BasePlayerData>
function FriendDataManager:InitBlackListData(msg)
    self.blackList = {}
    if #msg <= 0 then
        return -1
    else
        for i = 1, #msg do
            local friendData = FriendData()
            friendData:SetFullData(msg[i])
            table.insert(self.blackList, friendData)
        end
    end
end

---@param data SC_DenyTalk
function FriendDataManager:UpdateBlackListData(data)
    self.blackList = {}
    self.blackDic = {}
    for i, denyTalkInfo in pairs(data.denys) do
        local backListData = BackListData()
        backListData:SetFullData(denyTalkInfo)
        table.insert(self.blackList,backListData)
        self.blackDic[denyTalkInfo.targId]=true
    end
end

function FriendDataManager:IsBlackListPlayer(playerId)
    return self.blackDic[playerId]
end

function FriendDataManager:GetBlackFriendDataByIndex(index)
    return self.blackList[index]
end

--function FriendDataManager:GetBlackFriendDataById(playerId)
--    for i = 1, #self.blackList do
--        if self.blackList[i]:GetPlayerId() == playerId then
--            return self.blackList[i]
--        end
--    end
--    return nil
--end

function FriendDataManager:GetBlackFriendCount()
    return #self.blackList
end

---@param playerId
function FriendDataManager:AddBlackFriend(playerId)
    if self.blackList == nil then
        self.blackList = {}
    end
    local friendData = self:GetFriendDataByID(playerId)
    table.insert(self.blackList, friendData)
    self:DelFriend(playerId)

end

function FriendDataManager:RemoveBlackFriendById(playerId)
    ---@type FriendData
    local temp = nil
    for i = 1, #self.blackList do
        temp = self.blackList[i]
        if playerId == temp:GetPlayerId() then
            table.remove(self.blackList, i)
            break
        end
    end
    --if not self:IsFriendLimit() then
    --    self:AddFriend(playerId, temp)
    --end
end

-------recommend----------------------------
---@param msg table<number,SC_BasePlayerData>
function FriendDataManager:InitRecommendListData(msg)
    self.recommendList = {}
    if #msg <= 0 then
        return -1
    else
        for i = 1, #msg do
            local friendData = FriendData()
            friendData:SetFullData(msg[i])
            table.insert(self.recommendList, friendData)
        end
    end
end
function FriendDataManager:GetRecommendFriendDataByIndex(index)
    return self.recommendList[index]
end

function FriendDataManager:GetRecommendFriendCount()
    return #self.recommendList
end

------------------common---------------------
---@param friendManagerType FriendManagerType
---@return number
function FriendDataManager:GetFriendCountByType(friendManagerType)
    if friendManagerType == FriendManagerType.AddFriend then
        return self:GetRecommendFriendCount()
    elseif friendManagerType == FriendManagerType.Request then
        return self:GetRequestFriendCount()
    elseif friendManagerType == FriendManagerType.BlackList then
        return self:GetBlackFriendCount()
    elseif friendManagerType == FriendManagerType.SearchList then
        return self:GetSearchFriendCount()
    elseif friendManagerType == FriendManagerType.Friend then
        return self:GetFriendListCount()
    elseif friendManagerType == FriendManagerType.RentAndLend then
        return self:GetFriendListCount()
    end
end

---@param friendManagerType FriendManagerType
---@return FriendData,BackListData
function FriendDataManager:GetFriendListByIndexType(friendManagerType, index)
    if friendManagerType == FriendManagerType.AddFriend then
        return self:GetRecommendFriendDataByIndex(index)
    elseif friendManagerType == FriendManagerType.Request then
        return self:GetRequestFriendDataByIndex(index)
    elseif friendManagerType == FriendManagerType.BlackList then
        return self:GetBlackFriendDataByIndex(index)
    elseif friendManagerType == FriendManagerType.SearchList then
        return self:GetSearchFriendDataByIndex(index)
    elseif friendManagerType == FriendManagerType.Friend then
        return self:GetFriendDataByIndex(index)
    elseif friendManagerType == FriendManagerType.RentAndLend then
        return self:GetFriendDataByIndex(index)
    end
end

----------------------------------------------清空好友列表
function FriendDataManager:ClearFriendData()
    self.IndexIdList = {}
    self.FriendDataDic = {}

    self.requestList = {}
    self.searchList = {}
    self.recommendList = {}

    self.curSelectFriendId = nil
end

function FriendDataManager:ClearBlackData()
    self.blackList = {}
end



--{{{红点

function FriendDataManager:GetListRedById(friendId)
    return self.redPointDic[friendId]
end

function FriendDataManager:UpdateListRedDic(friendId, value)
    self.redPointDic[friendId] = value
end

function FriendDataManager:GetListRedPointCount()
    local redCount = 0
    for key, value in pairs(self.redPointDic) do
        redCount = redCount + 1
    end
    return redCount
end

function FriendDataManager:IsHaveRedPoint_List()
    return self:GetListRedPointCount() > 0
end

function FriendDataManager:IsHaveRedPoint_Apply()
    return self:GetRequestFriendCount() > 0
end

--function FriendDataManager:IsHaveRedPoint_RentAndLend()
--    return true
--end




--}}}