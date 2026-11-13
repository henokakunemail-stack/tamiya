


---@class CSharpRoomInitData
CSharpRoomInitData = class("CSharpRoomInitData")

function CSharpRoomInitData:initialize()

end

---@param data Lua_RoomInitData
function CSharpRoomInitData:CreateRoomInitData(data)
    local result = CSRoomInitData()
    result.rLevelId = data.LevelId
    if data.TrackData then
        result.resName = data.TrackData:GetConfigName()
        result.miniTrackData = data.TrackData:ConvertToMiniTrackData()
    end
    result.raceType = data.RaceFlag
    result.trackType = data.TrackType
    result.protectType = data.ProtectType
    result.supportAutoRecoverType = data.supportAutoRecoverType
    result.raceStyleType = data.RaceStyleType
    BattleDataManager:Get():SetRaceStyleType(data.RaceStyleType)
    result.countDownDuration = data.CountDownDuration
    result.selfPlayerId = data.DefaultSelectPlayerID
    result.isCustomTrack = data.IsCustomTrack
    result.isCupShow = BattleDataManager:Get():GetIsCupShow()
    result.gameStartTick=data.StartTime
    result.isSupportSpeedUp=data.IsSupportSpeedUp
    result.startNum = data.StartNum
    result.endNum = data.EndNum
    result.round = data.Round
    result.map_id = data.SceneID
    result.randSeed = data.Seed
    result.room_id = data.room_id
    result.room_ip = data.room_ip
    result.room_port = data.room_port
    result.frame_time_length = data.frame_time_length
    if  data.TrackData:GetMiniTrackType()==MiniTrackType.System or  data.TrackData:GetMiniTrackType()==MiniTrackType.LocalCustomTrack then
        result.track_id=data.TrackData:GetOrgId()
    end
    if  data.TrackData:GetMiniTrackType()==MiniTrackType.SelfCustomTrack or  data.TrackData:GetMiniTrackType()==MiniTrackType.OtherCustomTrack then
        result.track_id=-1
    end

    for i = 1, #data.TeamList do
        local team = CSharpRoomInitData:CreateTeamData(data.TeamList[i])
        if team then
            result.teamsData:Add(team)
        end
    end

    return result

end

---@param data Lua_TeamInitData
function CSharpRoomInitData:CreateTeamData(data)
    if data == nil then return nil end

    local result = CSTeamInitData()
    result.team_id = data.TeamID

    for i = 1, #data.PlayerList do
        local player = CSharpRoomInitData:CreatePlayerData(data.PlayerList[i])
        if player then
            result.playsData:Add(player)
        end
    end

    return result
end

---@param data Lua_PlayerInitData
function CSharpRoomInitData:CreatePlayerData(data)
    if data == nil then return nil end

    local result = CSPlayerInitData()

    result.player_id = data.PlayerID
    result.player_type = data.PlayerType
    result.player_name = data.Name
    result.track_number = data.TrackIdx

    for i = 1, #data.CarList do
        local car = CSharpRoomInitData:CreateCarData(data.CarList[i],data)
        if car then
            result.carsData:Add(car)
        end
    end

    return result

end


---@param data Lua_CarInitData
---@param playerData Lua_PlayerInitData
function CSharpRoomInitData:CreateCarData(data,playerData)
    if data == nil then return nil end

    local result = CSCarInitData()
    result.car_id = data.CarID

    if data.CarshellCfg then
        result.car_hero_id = data.CarshellCfg.holder
        result.car_shellid = data.CarshellCfg.C_ID
    end
    result.buffIds = data.Buffs
    result.beanCount = data.ShellBean
    result.stickerId = data.Stickerid
    result.playerLevel = playerData.PlayerLevel
    result.replayInputInfos = playerData.operate
    result.enableAIType = playerData.enableAIType
    result.attrRawDatas = data.Attrs
    result.skillids = data.SkillIds
    --LuaLogHelper.LogTable("---   ",data.Attrs)

    return result
end