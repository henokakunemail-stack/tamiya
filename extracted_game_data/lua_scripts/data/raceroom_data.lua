






---@class RaceRoomPlayerData
RaceRoomPlayerData = class("RaceRoomPlayerData")
function RaceRoomPlayerData:initialize()
    self.ID = 0
    self.Name = ""
    self.HeadIcon = ""
    self.Lv = -1
    self.RankScore = -1
    self.Ready = false
    ---@type CarReviewData
    self.CarData = nil
    self.PosIdx = -1
    self.SelfCarId = -1
end

function RaceRoomPlayerData:GetID() return self.ID end
function RaceRoomPlayerData:GetName() return self.Name end
function RaceRoomPlayerData:GetHeadIcon() return self.HeadIcon end
function RaceRoomPlayerData:GetIconFrame() return self.IconFrame end
function RaceRoomPlayerData:GetTitleBack() return self.TitleBack end
function RaceRoomPlayerData:GetCups() return self.Cups end
function RaceRoomPlayerData:GetLV() return self.Lv end
function RaceRoomPlayerData:GetRankScore() return self.RankScore end
function RaceRoomPlayerData:GetReady() return self.Ready end
function RaceRoomPlayerData:GetPosIdx() return self.PosIdx end
function RaceRoomPlayerData:GetSelfCarId() return self.SelfCarId end
---@return CarReviewData
function RaceRoomPlayerData:GetCarData() return self.CarData end
function RaceRoomPlayerData:SetReady(value) self.Ready = value end
function RaceRoomPlayerData:IsLeader() return self.isLeader end


---@param msg SC_SelfRaceInfo
function RaceRoomPlayerData:SetData(msg,LeaderID)
    self.ID = msg.rid
    self.Name = msg.rolename
    self.HeadIcon = msg.headicon
    self.IconFrame = msg.iconframe
    self.TitleBack =msg.titleback
    if msg.titlecup then
        self.Cups=stringSplitToNumber(msg.titlecup,":")
    end

    self.Lv = msg.curlevel
    self.RankScore = msg.score
    self.Ready = msg.ready==1
    self.PosIdx = msg.position
    self.SelfCarId = PlayerPrefsHelper:GetValue_MainMenuViewCarIndex()
    self.isLeader=msg.rid==LeaderID
    self.CarData = CarReviewData()
    self.CarData:SetDataByMsg(msg.car)
    --if self.ID == PlayerDataManager:Get():GetPlayerRID() then
    --    local cardata = CarDataManager:Get():GetCarDataByCarID(self.SelfCarId)
    --    self.CarData = CarReviewData()
    --    self.CarData:SetDataByCarData(cardata)
    --else
    --
    --end
end

---@param partinfos SC_UserCar
function RaceRoomPlayerData:UpdateCarData(partinfos, selfcarid)
    if self.ID == PlayerDataManager:Get():GetPlayerRID() then
        local cardata = CarDataManager:Get():GetCarDataByCarID(selfcarid)
        self.CarData = CarReviewData()
        self.CarData:SetDataByMsg(partinfos)
    else
        self.CarData = CarReviewData()
        self.CarData:SetDataByMsg(partinfos)
    end
end


---@class RaceRoomData
RaceRoomData = class("RaceRoomData")
function RaceRoomData:initialize()
    self.ID = -1
    self.SceneId = -1
    self.Name = ""
    self.Password = "0000"
    self.LeaderID = 0
    self.LeaderName = ""
    self.JoinNum = 0
    self.MaxNum = 0
    self.ObserverNum = 0
    ---@type RaceTrackData
    self.TrackData = nil
    self.TrackType = RaceRoomTrackType.None
    ---@type table<number, RaceRoomPlayerData>
    self.PlayerList = {}
    self.State = SerE_RaceRoomState.None
    self.FightTime = -1
end

function RaceRoomData:GetID() return self.ID end
function RaceRoomData:GetSceneID() return self.SceneId end
function RaceRoomData:GetName() return self.Name end
function RaceRoomData:GetJoinNum() return self.JoinNum end
function RaceRoomData:GetMaxNum() return self.MaxNum end
function RaceRoomData:GetObserverNum() return self.ObserverNum end
function RaceRoomData:GetTrackData() return self.TrackData end
function RaceRoomData:GetPassword() return self.Password end
function RaceRoomData:IsHavePasswd() return self.Password ~= "" end
function RaceRoomData:IsRandomTrack() return self.RoomType == 1 end
function RaceRoomData:GetPlayerList() return self.PlayerList end
function RaceRoomData:GetLeaderID() return self.LeaderID end
function RaceRoomData:IsAllowObserver() return self.ObserverNum >= 0 end
function RaceRoomData:GetSeed() return self.Seed end

function RaceRoomData:SetSeed(seed)
    self.Seed=seed
end
---@param msg SC_SelfRoomInfo
function RaceRoomData:SetSimpleData(msg)
    self.ID = msg.roomid
    self.SceneId = msg.groundid
    self.Name = msg.roomname
    self.Password = msg.pwd
    self.LeaderID = msg.createracer.rid
    self.LeaderName = msg.createracer.rolename
    self.LeaderIcon = msg.createracer.headicon
    self.LeaderIconFrame = msg.createracer.iconframe
    self.LeaderLv = msg.createracer.curlevel
    self.JoinNum = msg.curnum
    self.RoomType=msg.randomtype
   -- self.ObserverNum = msg.ob < 0 and 0 or msg.ob

    self.TrackData = RaceTrackData()
    self.TrackData:SetData(msg.trackid, msg.selftrack)
    self.MaxNum = self.TrackData:GetRaceNumber()
end

---@param msg SC_RetEnterSelfRoom
function RaceRoomData:SetDetailData(msg, state)
    self.ID = msg.roomid
    self.SceneId = msg.groundid
    self.Name = msg.roomname
    self.Password = msg.pwd
    self.LeaderID = msg.createid
    self.LeaderName = msg.masterName
    self.TrackData = RaceTrackData()
    self.Seed=0
    self.TrackData:SetData(msg.trackid, msg.selftrack)
    self.JoinNum = msg.num
    self.MaxNum = self.TrackData:GetRaceNumber()
    self.TrackType = self.TrackData:GetRaceNumber()
    self.RoomType=msg.randomtype

    self:SetPlayerList(msg.racer)
end

---@param msg SC_SelfRaceInfo[]
function RaceRoomData:SetPlayerList(msg, selfcarid)
    self.PlayerList = {}
    if msg == nil then
        log("---   error:SetPlayerList   房间内玩家数据空")
        return
    end

    for i = 1, #msg do
        local player = RaceRoomPlayerData()
        player:SetData(msg[i],self.LeaderID)
        table.insert(self.PlayerList, player)
    end

    self:SortPlayerList()
    self.JoinNum=#self.PlayerList
end

function RaceRoomData:GetCatDataByID(pid)
    for i = 1, #self.PlayerList do
        local player = self.PlayerList[i]
        if player:GetID() == pid then
            return player
        end
    end
    return nil
end


---@param msg SC_GlobalRoomPlayerInfo
function RaceRoomData:AddPlayer(msg)
    local player = RaceRoomPlayerData()
    player:SetData(msg, -1)
    table.insert(self.PlayerList, player)

    self.JoinNum = self.JoinNum + 1

    self:SortPlayerList()
end
function RaceRoomData:KickoutPlayer(pid)
    for i = 1, #self.PlayerList do
        if self.PlayerList[i]:GetID() == pid then
            table.remove(self.PlayerList, i)
            self.JoinNum = self.JoinNum - 1
            break
        end
    end
    self:SortPlayerList()
end
function RaceRoomData:SortPlayerList()
    table.sort(self.PlayerList,function (a, b)
        return a:GetPosIdx() < b:GetPosIdx()
    end)
end


---@param msg SC_RetAlterTrack
function RaceRoomData:ReviseRoomInfo(msg)
    --self.Name = msg.name
    --self.Password = msg.passwd
    --self.ObserverNum = msg.isOb and 0 or -1
    self.TrackData = RaceTrackData()
    self.TrackData:SetData(msg.trackid, msg.trackInfo)
end

---@param partinfos SC_UserCar
function RaceRoomData:UpdatePlayerCarData(pid, partinfos, selfcarid)
    for i = 1, #self.PlayerList do
        local player = self.PlayerList[i]
        if player:GetID() == pid then
            player:UpdateCarData(partinfos,selfcarid)
            break
        end
    end
end











--
--function RaceRoomData:GetTrackData() return self.TrackData end
--function RaceRoomData:GetPlayerList() return self.PlayerList end
--function RaceRoomData:GetPlayerByIdx(idx) return self.PlayerList[idx] end
--
-----@param msg SC_RoomInfo
-----@param trackinfo SC_TrackInfo
--function RaceRoomData:SetData(msg, trackinfo, fighttime, reconnectMsg)
--    self.ID = msg.roomId
--    self.RoomType = msg.limit
--    self.RuleType = msg.raceType
--    self.Name = msg.name
--    self.SceneId = msg.sceneId
--    self.TrackID = msg.trackId
--    self.IsCustom = msg.trackId <= 0
--    self.Password = msg.passwd
--    self.LeaderID = msg.masterId
--    self.LeaderName = msg.masterName
--    self:SetFightTime(fighttime)
--    self.ReconnectMsg = reconnectMsg
--
--    if trackinfo then
--        self.TrackData = CommonHelper:GetRacetrackData(msg.trackId, trackinfo)
--    else
--        self.TrackData = CommonHelper:GetRacetrackData(msg.trackId, nil,nil,msg.selfTrack)
--    end
--
--   -- self.TrackData:SetData(msg.trackId, msg.selfTrack)
--
--
--
--end
--
--function RaceRoomData:SetFightTime(fighttime)
--    if fighttime == nil then fighttime = 0 end
--    self.FightTime = fighttime
--end
--
--
--
--
-----@param msg SC_RoomPlayerInfo
--function RaceRoomData:AddPlayerData(msg)
--    for i = 1, #self.PlayerList do
--        local data = self.PlayerList[i]
--        if data and data.ID == msg.pid then
--            CommonTipsHelper:ShowCenterTips("玩家假如房间数据异常")
--            return
--        end
--    end
--
--    if msg.pid == self.LeaderID then
--        local player = RaceRoomPlayerData()
--        player:SetData(msg.pid, msg.name, msg.head, msg.ready, msg.carIdx)
--        self.PlayerList[1] = player
--    else
--        for i = 2, 5 do
--            if self.PlayerList[i] == nil then
--                local player = RaceRoomPlayerData()
--                player:SetData(msg.pid, msg.name, msg.head, msg.ready, msg.carIdx)
--                self.PlayerList[i] = player
--                break
--            end
--        end
--    end
--
--end
--
--function RaceRoomData:RemovePlayer(id)
--    for i = 1, #self.PlayerList do
--        local data = self.PlayerList[i]
--        if data and data.ID == id then
--            self.PlayerList[i] = nil
--            return
--        end
--    end
--end
--
--function RaceRoomData:SetPlayerReady(id, state)
--    for i = 1, #self.PlayerList do
--        local data = self.PlayerList[i]
--        if data and data.ID == id then
--            self.PlayerList[i].Ready = state
--            return
--        end
--    end
--end
--
--function RaceRoomData:GetReadyState(id)
--    for i = 1, #self.PlayerList do
--        local data = self.PlayerList[i]
--        if data and data.ID == id then
--            return self.PlayerList[i].Ready
--        end
--    end
--end
--
--function RaceRoomData:SetPlayerCar(id, idx)
--    for i = 1, #self.PlayerList do
--        local data = self.PlayerList[i]
--        if data and data.ID == id then
--            self.PlayerList[i].CarIdx = idx
--            return
--        end
--    end
--end
--
--function RaceRoomData:GetPlayerCar(id)
--    for i = 1, #self.PlayerList do
--        local data = self.PlayerList[i]
--        if data and data.ID == id then
--            return self.PlayerList[i].CarIdx
--        end
--    end
--    return -1
--end
--
--
--function RaceRoomData:UpdateRoomInfo(sceneid, trackid, selftrack, name)
--    if sceneid then self.SceneId = sceneid end
--    if trackid then self.TrackID = trackid end
--    if name then self.Name = name end
--
--
--
--
--    self.TrackData = CommonHelper:GetRacetrackData(trackid,selftrack )
--
--end
--
--
--
--
--function RaceRoomData:ResetRoom()
--    for i = 1, #self.PlayerList do
--        local data = self.PlayerList[i]
--        if data then
--            data.Ready = false
--        end
--    end
--end
--
--
--function RaceRoomData:GetFightTime()
--    return self.FightTime
--end
--
--function RaceRoomData:GetReconnectMsg()
--    return self.ReconnectMsg
--end