

local __instance
---@class RaceRoomManager
RaceRoomManager = class("RaceRoomManager")
function RaceRoomManager:initialize()
    ---@type RaceRoomData
    self.RoomData = nil
end
---@return RaceRoomManager
function RaceRoomManager:Get()
    if __instance == nil then
        __instance = RaceRoomManager()
    end
    return __instance
end
---@param msg SC_RetEnterSelfRoom
function RaceRoomManager:SetRoomData(msg)
    self.RoomData = RaceRoomData()
    self.RoomData:SetDetailData(msg)
end

---@param msg number
function RaceRoomManager:LoadBattleScene(starttime)
    self.RaceType=RaceRoomBattleType.Join
    self.RoomData:SetSeed(starttime)
    for i = 1, #self.RoomData:GetPlayerList() do
        if not self.RoomData:GetPlayerList()[i]:IsLeader() then
            self.RoomData:GetPlayerList()[i]:SetReady(false)
        end
    end
    BattleDataManager:Get():SetRoomData(self.RoomData, RaceModel.RaceRoom)

    --if history then
    --    BattleDataManager:Get():SetRoomData(history, RaceModel.RaceRoom, true)
    --    BattleDataManager:Get():SetBattleResultData(history)
    --end

    local scenename = BattleDataManager:Get():GetSceneName()
    local trackdata = BattleDataManager:Get():GetTrackData()
    SceneManager:Get():LoadingRealTimePVPScene(scenename, trackdata, RaceModel.RaceRoom)

end
function RaceRoomManager:GetRaceType()
    return self.RaceType
end
---@param msg SC_RetEnterSelfRoom
function RaceRoomManager:LoadObBattleScene(msg)
    self.RaceType=RaceRoomBattleType.Observer
    BattleDataManager:Get():SetRoomData(msg, RaceModel.RaceRoom)

    --if history then
    --    BattleDataManager:Get():SetRoomData(history, RaceModel.RaceRoom, true)
    --    BattleDataManager:Get():SetBattleResultData(history)
    --end

    local scenename = BattleDataManager:Get():GetSceneName()
    local trackdata = BattleDataManager:Get():GetTrackData()
    SceneManager:Get():LoadingRealTimePVPScene(scenename, trackdata, RaceModel.RaceRoom)

end






function RaceRoomManager:GetTrackData() if self.RoomData then return self.RoomData:GetTrackData() end end
function RaceRoomManager:GetObserverNum() if self.RoomData then return self.RoomData:GetObserverNum() end end
function RaceRoomManager:GetPlayerList() if self.RoomData then return self.RoomData:GetPlayerList() end end
function RaceRoomManager:GetName() if self.RoomData then return self.RoomData:GetName() end end
function RaceRoomManager:GetID() if self.RoomData then return self.RoomData:GetID() end end
function RaceRoomManager:GetSceneID() if self.RoomData then return self.RoomData:GetSceneID() end end
function RaceRoomManager:GetPassword() if self.RoomData then return self.RoomData:GetPassword() end end
function RaceRoomManager:IsHavePasswd() if self.RoomData then return self.RoomData:IsHavePasswd() end end
function RaceRoomManager:IsAllowObserver() if self.RoomData then return self.RoomData:IsAllowObserver() end end
function RaceRoomManager:GetJoinNum() if self.RoomData then return self.RoomData:GetJoinNum() end end
function RaceRoomManager:GetMaxNum() if self.RoomData then return self.RoomData:GetMaxNum() end end
function RaceRoomManager:IsInRoom() return self.RoomData ~= nil end
function RaceRoomManager:UpdateRoomState(state)
    if self.RoomData then
        self.RoomData.State = state end
    end
function RaceRoomManager:GetRoomState() return self.RoomData.State end
function RaceRoomManager:GetFightTime() return self.RoomData.FightTime end
function RaceRoomManager:GetLeaderID() return self.RoomData:GetLeaderID() end
function RaceRoomManager:GetSelfPlayerData() if self.RoomData then return self.RoomData:GetCatDataByID(PlayerDataManager:Get():GetPlayerRID()) end end

function RaceRoomManager:IsLeader()
    if self.RoomData then
        return self.RoomData:GetLeaderID() == PlayerDataManager:Get():GetPlayerRID()
    end
    return false
end
function RaceRoomManager:IsRandom()
    if self.RoomData then
        return self.RoomData.RoomType ==1
    end
    return false
end

function RaceRoomManager:GetPlayerDataByID(pid)
    if self.RoomData then
        local list = self.RoomData:GetPlayerList()
        for i = 1, #list do
            local data = list[i]
            if pid == data:GetID() then
                return data
            end
        end
    end
    return nil
end
function RaceRoomManager:SetPlayerReady(pid, value)
    local player = self:GetPlayerDataByID(pid)
    if player then
        player:SetReady(value)
    end
end
---@param msg SC_SelfRaceInfo
function RaceRoomManager:AddPlayer(msg)
    if self.RoomData then
        self.RoomData:AddPlayer(msg)
    end
end

function RaceRoomManager:KickoutPlayer(pid)
    if self.RoomData then
        self.RoomData:KickoutPlayer(pid)
    end
end

---@param partinfos SC_UserCar
function RaceRoomManager:UpdatePlayerCarData(pid, partinfos,carIdx)
    if self.RoomData then
        self.RoomData:UpdatePlayerCarData(pid, partinfos,carIdx)
    end
end

function RaceRoomManager:SetFightTime(time)
    if self.RoomData then
        if self.RoomData.State == SerE_RaceRoomState.Fight then
            self.RoomData.FightTime = time
        end
    end

end


function RaceRoomManager:ClearData()
    self.RoomData = nil
    ChatDataManager:Get():ClearChatDataByChatType(ChatType.PVPRoom, -1)--离开房间后清除聊天信息
end

---@param msg SC_EnterRoomRes
function RaceRoomManager:RecvRoomInfoMsgInitData(msg)
    self.RoomData = RaceRoomData()
    self.RoomData:SetDetailData(msg.globalRoomInfo, msg.state)
    RaceRoomManager:Get():SetFightTime(msg.tTime)
end

---@param msg SC_EnterRoomRes
function RaceRoomManager:ConnectNormal(msg)
    log("---   跨服PVP收到房间数据，房间赛，无异常")
    self:RecvRoomInfoMsgInitData(msg)

    UIManager:Get():OpenView("RaceRoomDetailView",CanvasType.MainCanvas,"RaceRoomDetailView")
    UINotify:Get():SendNotification(UINotifyEvent.RaceRoomDetailView_SetData)
end

---@param msg SC_EnterRoomRes
function RaceRoomManager:ReconnectOnLogin(msg)
    log("---   通过登录系统，跨服PVP收到房间数据，房间赛，重连，state = ", msg.state)
    self:RecvRoomInfoMsgInitData(msg)

    if msg.state == SerE_RaceRoomState.Wait then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.StartToRaceRoom)
    end
    if msg.state == SerE_RaceRoomState.Loading or msg.state == SerE_RaceRoomState.Fight then
        self:LoadBattleScene(msg.fightInfo, nil)
    end
    if msg.state == SerE_RaceRoomState.Result then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.StartToRaceRoom)
    end
end

---@param msg SC_EnterRoomRes
function RaceRoomManager:ReconnectOnQuickConnect(msg)
    --local oldstate = RaceRankManager:Get():GetRoomState()
    --log("---   十次重连成功，跨服PVP收到房间数据，重连，state = ", msg.state, "oldstate = ",oldstate)
    --
    --self:RecvRoomInfoMsgInitData(msg)
    --if msg.state == SerE_RaceRankState.Ready then
    --    UINotify:Get():SendNotification(UINotifyEvent.RaceRankRoomView_RefreshUI)
    --    return
    --end
    --if msg.state == SerE_RaceRankState.Loading and oldstate == SerE_RaceRankState.Ready then
    --    self:LoadBattleScene(msg.fightInfo, nil)
    --    return
    --end
    --if msg.state == SerE_RaceRankState.Loading and oldstate == SerE_RaceRankState.Loading then
    --    local value = SceneManager:Get():GetLoadingProcess()
    --    local value = math.modf(value * 100)
    --    RaceRankSubsystem:Get():SendMsg_LoadingProcess(value)
    --    return
    --end
    --if msg.state == SerE_RaceRankState.Fight and oldstate == SerE_RaceRankState.Ready then
    --    self:LoadBattleScene(msg.fightInfo, nil)
    --    return
    --end
    --if msg.state == SerE_RaceRankState.Fight and oldstate == SerE_RaceRankState.Loading then
    --    self:LoadBattleScene(msg.fightInfo, nil)
    --    return
    --end
    --if msg.state == SerE_RaceRankState.Fight and oldstate == SerE_RaceRankState.Result then
    --
    --    return
    --end
    --if msg.state == SerE_RaceRankState.Result then
    --    SceneManager:Get():LoadingMainCity()
    --    return
    --end
    --
    --logError("---   天梯快速重连，未知情况","oldstate = ",oldstate,"serverstate = ",msg.state)
end

---@param msg SC_RetAlterTrack
function RaceRoomManager:ReviseRoomInfo(msg)
    self.RoomData:ReviseRoomInfo(msg)
end


function RaceRoomManager:ReEnterBattle()
    local result = MatchManager:Get():IsReconnectOnLogin() and MatchManager:Get():GetType() == SerE_PVPType.RaceRoom
    if result then
        log("---   登录后重新加入房间赛")
        NetManager:Get():ConnectSyncBattleServer()
    end
    return result
end

function RaceRoomManager:QuickReconnect()
    local result = MatchManager:Get():MatchDataIsNil() and MatchManager:Get():GetType() == SerE_PVPType.RaceRoom
    if not result then
        if not MatchManager:Get():MatchDataIsNil() then
            log("---   同步战斗服快速重连成功,重连房间赛")
            MatchManager:Get():SetConnectFlag(RaceRankReconnectFlag.QuickReconnect)
            NetManager:Get():ConnectSyncBattleServer()
        end
    end
    return result
end

function RaceRoomManager:ClientResetPlayerReadyState()
    if self.RoomData then
        local list = self.RoomData:GetPlayerList()
        for i = 1, #list do
            local data = list[i]
            if self.RoomData:GetLeaderID() ~= data:GetID() then
                data:SetReady(false)
            end
        end
    end
end





















--
--function RaceRoomManager:SetRoomData(msg, trackinfo, fighttime, reconnectMsg)
--    CacheClearTrigger:Get():RegisterEvent(self, self.ClearData)
--    self.RoomData = RaceRoomData()
--    self.RoomData:SetData(msg, trackinfo, fighttime, reconnectMsg)
--end
--
-----@return RaceRoomData
--function RaceRoomManager:GetRoomData()
--    return self.RoomData
--end
--
--
--
--
--
-----@param msg table<number, SC_RoomPlayerInfo>
--function RaceRoomManager:SetPlayerData(msg)
--    for i = 1, #msg do
--        self.RoomData:AddPlayerData(msg[i])
--    end
--end
--
--function RaceRoomManager:AddPlayerData(msg)
--    if self.RoomData then
--        self.RoomData:AddPlayerData(msg)
--    end
--
--end
--
--function RaceRoomManager:RemovePlayer(id)
--    self.RoomData:RemovePlayer(id)
--end
--
--
--function RaceRoomManager:GetPlayerByIdx(idx)
--    return self.RoomData:GetPlayerByIdx(idx)
--end
--
--function RaceRoomManager:GetPlayerByID(id)
--    local list = self.RoomData:GetPlayerList()
--    for i = 1, #list do
--        if list[i] and list[i].ID == id then
--            return list[i]
--        end
--    end
--end
--function RaceRoomManager:IsAllPlayerReady()
--    local result = true
--    local list = self.RoomData:GetPlayerList()
--    for i = 1, #list do
--        if not list[i].Ready  then
--            result = false
--            break
--        end
--    end
--
--    return result
--end
--
--
--function RaceRoomManager:SetPlayerReady(id, state)
--    self.RoomData:SetPlayerReady(id, state)
--end
--
--function RaceRoomManager:GetReadyState(isself, id)
--    if isself or isself == nil then id = PlayerDataManager:Get():GetPlayerID() end
--    return self.RoomData:GetReadyState(id)
--end
--
--
--
--function RaceRoomManager:SetPlayerCar(id, idx)
--    self.RoomData:SetPlayerCar(id, idx)
--end
--
--function RaceRoomManager:GetPlayerCar(isself, id)
--    if isself or isself == nil then id = PlayerDataManager:Get():GetPlayerID() end
--    return self.RoomData:GetPlayerCar(id)
--end
--
--
--function RaceRoomManager:UpdateRoomInfo(sceneid, trackid, trackinfo, name)
--    self.RoomData:UpdateRoomInfo(sceneid, trackid, trackinfo, name)
--end
--
--
--
--
--
--
--
--
--
--
--function RaceRoomManager:ClearData()
--    self.RoomData = nil
--end
--
--function RaceRoomManager:ResetRoom()
--    self.RoomData:ResetRoom()
--end
--
--function RaceRoomManager:IsReconnect()
--    local time = self:GetFightTime()
--    return time > 0
--end
--
--function RaceRoomManager:GetFightTime()
--    if self.RoomData == nil then
--        return -1
--    end
--    return self.RoomData:GetFightTime()
--end
--
--function RaceRoomManager:GetReconnectMsg()
--    if self.RoomData == nil then
--        return nil
--    end
--    return self.RoomData:GetReconnectMsg()
--end
--
--
--
--function RaceRoomManager:ReEnterBattle()
--    log("---   登录后重新加入房间赛")
--    if RaceRoomManager:Get():GetReconnectMsg() == nil then
--        logError("---   战斗数据空")
--        return
--    end
--
--    BattleDataManager:Get():SetRoomData(RaceRoomManager:Get():GetReconnectMsg(), RaceModel.RoomPVP)
--    local scenename = BattleDataManager:Get():GetSceneName()
--    local trackdata = BattleDataManager:Get():GetTrackData()
--    SceneManager:Get():LoadingRealTimePVPScene(scenename, trackdata, RaceModel.RoomPVP, function()
--        CommonTipsHelper:Get():ShowCenterTips(TemplateStringID.RaceRoomReconnect)
--    end)
--end
--
--
