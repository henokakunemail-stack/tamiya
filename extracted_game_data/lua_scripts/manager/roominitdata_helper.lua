

local _copyid
local _seed
local _trackId=-1
local _roomId=-1

---@class RoomInitDataHelper
RoomInitDataHelper = class("RoomInitDataHelper")

function RoomInitDataHelper:initialize()

end

---@param msg RaceLocalData
function RoomInitDataHelper:CreateGuideBattle(msg)
    local data = RoomInitDataHelper:BuildMsg_Lua_RaceLocalData(msg)
    return data
end
function RoomInitDataHelper:CreateCustomTrackBattle(msg)
    local data = RoomInitDataHelper:BuildMsg_Lua_CustomTrackData(msg)
    return data
end

---@param msg SC_BeginPve
function RoomInitDataHelper:CreatePVE(msg,idx)
    local data = nil
    if msg.isHistory then
        data = RoomInitDataHelper:BuildMsg_SC_BeginRaceHistoryRes(msg,idx)
    else
        data = RoomInitDataHelper:BuildMsg_SC_BeginRaceRes(msg,idx)
    end
    return data
end
---@param msg SC_BeginPve
function RoomInitDataHelper:CreateNewbie(msg,idx)
    local data = nil
    if msg.isHistory then
        data = RoomInitDataHelper:BuildMsg_SC_BeginRaceHistoryRes(msg,idx)
    else
        data = RoomInitDataHelper:BuildMsg_SC_BeginRaceNewBieRes(msg,idx)
    end
    return data
end

---@param msg SC_BeginPve
function RoomInitDataHelper:CreateRaceSeniorTrain(msg,idx)
    local data = nil
    data = RoomInitDataHelper:BuildMsg_SC_BeginRaceSeniorTrainRes(msg,idx)
    return data
end
function RoomInitDataHelper:CreateRaceSeniorTrainHistory(msg,idx)
    local data = nil
    data = RoomInitDataHelper:BuildMsg_SC_BeginRaceHistoryRes(msg,idx)
    return data
end

---@param msg SC_BeginPve
function RoomInitDataHelper:CreateChallenge(msg,idx)
    local data = RoomInitDataHelper:BuildMsg_SC_BeginChallengeRes(msg,idx)
    return data
end
---@param msg SC_BeginPve
function RoomInitDataHelper:CreateChallengeReplay(msg,idx)
    local data = RoomInitDataHelper:BuildMsg_SC_BeginChallengeResRePlay(msg,idx)
    return data
end

---@param msg SC_RetBeginBattle
function RoomInitDataHelper:CreateRaceSelfLevel(msg)
    local data = RoomInitDataHelper:BuildMsg_SC_SelfLevel(msg)
    return data
end
---@param msg SC_RetBattleRecord
function RoomInitDataHelper:CreateRaceSelfLevelHistory(msg)
    local data = RoomInitDataHelper:BuildMsg_SC_SelfLevelHistory(msg.start,msg.lookrid)
    return data
end

---@param msg SC_BeginFastPvp
function RoomInitDataHelper:CreateRaceTrotHistory(msg)
    local data = RoomInitDataHelper:BuildMsg_SC_RaceTrot(msg)
    return data
end

---@param msg SC_BeginFastPvp
function RoomInitDataHelper:CreateRaceTrot(msg,defaultId)
    local data = RoomInitDataHelper:BuildMsg_SC_RaceTrot(msg,defaultId)
    return data
end

---@param msg SC_RetStart
function RoomInitDataHelper:CreateRaceJcp(msg)
    local data = RoomInitDataHelper:BuildMsg_SC_RetStart(msg,PlayerDataManager:Get():GetPlayerRID(),RaceProtectType.Normal)
    return data
end

---@param msg {sceneId,trackId,carId}
function RoomInitDataHelper:CreateRaceJcpTest(msg)
    local data = RoomInitDataHelper:BuildMsg_SC_RaceTest(msg,RaceProtectType.Normal,3)
    return data
end
---@param msg SC_RetRaceRecord
function RoomInitDataHelper:CreateRaceJcpRecord(msg,lookId)
    local data = RoomInitDataHelper:BuildMsg_SC_RetStart(msg,lookId,RaceProtectType.Normal)
    return data
end


---@param msg {sceneId,trackId,carId}
function RoomInitDataHelper:CreateRaceTopTest(msg)
    local data = RoomInitDataHelper:BuildMsg_SC_RaceTest(msg,RaceProtectType.Protect,1)
    return data
end
---@param msg SC_RetTopStart
function RoomInitDataHelper:CreateRaceTopRace(msg)
    local data = RoomInitDataHelper:BuildMsg_SC_RetStart(msg,PlayerDataManager:Get():GetPlayerRID(),RaceProtectType.Protect)
    return data
end

---@param msg SC_RetTopRecord
function RoomInitDataHelper:CreateRaceTopRecord(msg)
    local data = RoomInitDataHelper:BuildMsg_SC_RaceRecord(msg,RaceProtectType.Protect)
    return data
end






---@param msg table<number,SC_RetGuildPVEStart>
function RoomInitDataHelper:CreateRaceClub3v3(msg)
    local data = RoomInitDataHelper:BuildMsg_SC_RaceClubPve(msg)
    return data
end


---@param msg SC_RetGvgPointStart
function RoomInitDataHelper:CreateRaceGVG(msg)
    local data = RoomInitDataHelper:BuildMsg_SC_RetStart(msg,PlayerDataManager:Get():GetPlayerRID(),RaceProtectType.Normal)
    return data
end

---@param msg SC_RetGvgPointStart
function RoomInitDataHelper:CreateRaceCarGod(msg)
    local data = RoomInitDataHelper:BuildMsg_SC_BeginCarGod(msg,1)
    return data
end
---@param msg SC_MatchInfos
function RoomInitDataHelper:CreateRaceSuperBattle(msg)
    local data = RoomInitDataHelper:BuildMsg_SC_RaceSuperBattle(msg)
    return data
end









---@param msg SC_CommonRaceInfo
function RoomInitDataHelper:CreateSelfChallenge(msg)
    local data = RoomInitDataHelper:BuildMsg_SC_CommonRaceInfo(msg)
    return data
end
--------------------------44444 over
---@param msg SC_BeginPve
function RoomInitDataHelper:CreateRaceSelfChapter(msg,idx)
    local data = RoomInitDataHelper:BuildMsg_SC_BeginSelfChapterRaceRes(msg,idx)
    return data
end
---@param msg SC_CommonRaceInfo
function RoomInitDataHelper:CreateClubRaceSelfChapter(msg)
    local data = RoomInitDataHelper:BuildMsg_SC_CommonRaceInfo(msg)
    return data
end

---@param msg SC_RetBeginBattle
function RoomInitDataHelper:CreateClubRaceSelfLevel(msg)
    local data = RoomInitDataHelper:BuildMsg_SC_SelfLevel(msg)
    return data
end

function RoomInitDataHelper:CreatePVEReplay(msg,idx)
    local data = RoomInitDataHelper:BuildMsg_SC_BeginRaceHistoryRes(msg,idx)
    return data
end
function RoomInitDataHelper:CreateRaceCarGodReplay(msg,idx)
    local data = RoomInitDataHelper:BuildMsg_SC_BeginRaceCarGodHistoryRes(msg,idx)
    return data
end


function RoomInitDataHelper:CreateRaceSeniorTrainReplay(msg,idx)
    local data = RoomInitDataHelper:BuildMsg_SC_RaceSeniorTrainHistoryRes(msg,idx)
    return data
end
--------------------------44444  over
function RoomInitDataHelper:CreatePVP(msg)
    local roomdata = RaceRoomManager:Get():GetRoomData()
    local data = RoomInitDataHelper:BuildMsg_SC_NotifyRoomFight(msg, roomdata:GetTrackData())
    return data
end

function RoomInitDataHelper:CreatePVPReplay(msg)
    local data = RoomInitDataHelper:BuildMsg_Lua_RaceRoomHistoryData(msg)
    return data
end


--------------------------44444  over
---@param msg SC_RetPVPStart
function RoomInitDataHelper:CreateRank(msg)
    local trackdata = CommonHelper:GetRacetrackData(msg.trackid)
    local data = RoomInitDataHelper:BuildMsg_SC_NotifyRoomFight(msg, trackdata)
    return data
end
function RoomInitDataHelper:CreateRankTest(msg)
    local data = RoomInitDataHelper:BuildMsg_SC_RaceTest(msg,msg.raceType or RaceProtectType.Normal,msg.position)
    return data
end
function RoomInitDataHelper:CreateRaceAssembleTest(msg)
    local data = RoomInitDataHelper:BuildMsg_Lua_RaceAssembleTest(msg,msg.raceType or RaceProtectType.Normal,msg.position)
    return data
end

---@param msg SC_RetPVPRecord
function RoomInitDataHelper:CreateRankHistory(msg)
    local trackdata = CommonHelper:GetRacetrackData(msg.start.trackid)
    local data = RoomInitDataHelper:BuildMsg_SC_NotifyHistoryRoomFight(msg, trackdata)
    return data
end

function RoomInitDataHelper:CreateRankReplay(msg)
    local data = RoomInitDataHelper:BuildMsg_Lua_RaceRoomHistoryData(msg)
    return data
end

---@param msg RaceRoomData
function RoomInitDataHelper:CreateRoom(msg)
    local data = RoomInitDataHelper:BuildMsg_SC_NotifyRaceRoomFight(msg, RaceRoomManager:Get():GetTrackData())
    return data
end
---@param msg SC_RetEnterSelfRoom
function RoomInitDataHelper:CreateRoomObServer(msg)
    local data = RoomInitDataHelper:BuildMsg_SC_RetEnterSelfRoom(msg)
    return data
end

function RoomInitDataHelper:CreateRoomReplay(msg)
    local data = RoomInitDataHelper:BuildMsg_Lua_RaceRoomHistoryData(msg)
    return data
end

function RoomInitDataHelper:CreateRaceSelf(msg)
    local data = RoomInitDataHelper:BuildMsg_SC_CommonRaceInfo(msg)
    return data
end

function RoomInitDataHelper:CreateRaceSelfReplay(msg)
    local data = RoomInitDataHelper:BuildMsg_Lua_RaceRoomHistoryData(msg)
    return data
end

function RoomInitDataHelper:CreateClubTrain(msg)
    local data = RoomInitDataHelper:BuildMsg_SC_CommonRaceInfo(msg)
    return data
end
function RoomInitDataHelper:CreateClubTrainReplay(msg)
    --local data = RoomInitDataHelper:BuildMsg_SC_ClubTrainRaceInfo(msg, RaceModel.RaceSelf)
   -- return data
end

function RoomInitDataHelper:CreateRaceWeek(msg)
    local data = RoomInitDataHelper:BuildMsg_SC_CommonRaceInfo(msg)
    return data
end

function RoomInitDataHelper:CreateRaceWeekReplay(msg)
    local data = RoomInitDataHelper:BuildMsg_Lua_RaceRoomHistoryData(msg)
    return data
end


---@param msg SC_CommonRaceInfo
function  RoomInitDataHelper:BuildMsg_SC_CommonRaceInfo(msg)
    local result = Lua_RoomInitData()

    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, msg.sceneId)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = msg.sceneId
    result.RaceFlag = 1

    result.Round = msg.round
    result.Seed = msg.seed
    result.ProtectType=1
    result.RaceStyleType=RaceStyleType.Normal
    result:SetTrackData(msg.trackId, msg.trackInfo)
    result.TrackType = result.TrackData.isfield and TrackType.Free or TrackType.Mini

    for i = 1, #msg.teamInfos do
        local team = RoomInitDataHelper:BuildMsg_SC_TeamInfo(msg.teamInfos[i])
        table.insert(result.TeamList, team)
    end

    return result
end

---@param msg SC_BeginPve
function RoomInitDataHelper:BuildMsg_SC_BeginRaceRes(msg,idx)
    local result = Lua_RoomInitData()
    result.LevelId = msg.copyid
    result.SelfCarId=msg.carid
    _copyid= msg.copyid
    _seed=msg.seed
    ---@type dictcopy_config_cell
    local levelData=CommonHelper:GetTableDataByID(ConfigNames.pvelevel_config,msg.copyid)
    ---@type PVELevelBattleData
    local BattleInfo=levelData.BattleInfoList[idx]
    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, BattleInfo.SceneId)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = BattleInfo.SceneId
    result.Seed = msg.starttime
    if levelData and levelData.timescale~=nil then
        BattleDataManager:Get():SetDefaultBattleSpeed(levelData.timescale/1000)
    else
        BattleDataManager:Get():SetDefaultBattleSpeed(1)
    end
    result.ProtectType=1
    result.RaceStyleType=RaceStyleType.Normal
    if levelData.BattleType~=RaceStyleType.Normal then
        result.RaceStyleType=levelData.BattleType
        result.CountDownDuration=levelData.BattleTime
    end
    result.TrackData = CommonHelper:GetRacetrackData(BattleInfo.TrackId)

    result.StartNum = 0
    result.EndNum = 0
    result.Round = BattleInfo.Round
    result.mapid = 1001
    result.RaceFlag = 1
    result.TrackType = 2
    result.supportAutoRecoverType = 1

    local npcs=BattleInfo.NpcIds
    local npcTracks=BattleInfo.NpcTracks
    if levelData.copytype~=LevelType.GuideLevel then
        table.insert(result.TeamList,RoomInitDataHelper:BuildMsg_Self_TeamInfo(BattleInfo.PlayerTrack,msg,BattleInfo.PlayerTrack))
    else
        result.DefaultSelectPlayerID=npcs[2]
    end
    for i = 1, #npcs do
       table.insert(result.TeamList, RoomInitDataHelper:BuildMsg_Npc_TeamInfo(npcTracks[i],npcs[i],npcTracks[i],levelData,false))
    end
    self:Set_Data(result.LevelId,result.Seed,result.TrackType,result.room_id)
    return result
end
---@param msg SC_BeginPve
function RoomInitDataHelper:BuildMsg_SC_BeginRaceNewBieRes(msg,idx)
    local result = Lua_RoomInitData()
    result.LevelId = msg.copyid
    result.SelfCarId=msg.carid
    _copyid= msg.copyid
    _seed=msg.seed
    ---@type dictcopy_config_cell
    local levelData=CommonHelper:GetTableDataByID(ConfigNames.pvelevel_config,msg.copyid)
    ---@type PVELevelBattleData
    local BattleInfo=levelData.BattleInfoList[idx]
    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, BattleInfo.SceneId)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = BattleInfo.SceneId
    result.Seed = msg.starttime
    if levelData and levelData.timescale~=nil then
        BattleDataManager:Get():SetDefaultBattleSpeed(levelData.timescale/1000)
    else
        BattleDataManager:Get():SetDefaultBattleSpeed(1)
    end
    result.ProtectType=1
    result.RaceStyleType=RaceStyleType.Normal
    if levelData.BattleType~=RaceStyleType.Normal then
        result.RaceStyleType=levelData.BattleType
        result.CountDownDuration=levelData.BattleTime
    end
    result.TrackData = CommonHelper:GetRacetrackData(BattleInfo.TrackId)

    result.StartNum = 0
    result.EndNum = 0
    result.Round = BattleInfo.Round
    result.mapid = 1001
    result.RaceFlag = 1
    result.TrackType = 2
    result.supportAutoRecoverType = 1

    local npcs=BattleInfo.NpcIds
    local npcTracks=BattleInfo.NpcTracks
    if levelData.copytype~=LevelType.GuideLevel then
        table.insert(result.TeamList,RoomInitDataHelper:BuildMsg_Self_TeamInfo(BattleInfo.PlayerTrack,msg,BattleInfo.PlayerTrack,18001007))
    else
        result.DefaultSelectPlayerID=npcs[2]
    end
    for i = 1, #npcs do
       table.insert(result.TeamList, RoomInitDataHelper:BuildMsg_Npc_TeamInfo(npcTracks[i],npcs[i],npcTracks[i],levelData,false))
    end
    self:Set_Data(result.LevelId,result.Seed,result.TrackType,result.room_id)
    return result
end

---@param msg SC_BeginPve
function RoomInitDataHelper:BuildMsg_SC_BeginCarGod(msg,idx)
    local result = Lua_RoomInitData()
    result.LevelId = msg.copyid
    result.SelfCarId=msg.carid
    _copyid= msg.copyid
    _seed=msg.seed
    ---@type dictcopy_config_cell
    local levelData=CommonHelper:GetTableDataByID(ConfigNames.pvelevel_config,msg.copyid)
    ---@type PVELevelBattleData
    local BattleInfo=levelData.BattleInfoList[idx]
    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, BattleInfo.SceneId)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = BattleInfo.SceneId
    result.Seed = msg.starttime
    if levelData and levelData.timescale~=nil then
        BattleDataManager:Get():SetDefaultBattleSpeed(levelData.timescale/1000)
    else
        BattleDataManager:Get():SetDefaultBattleSpeed(1)
    end
    result.ProtectType=RaceProtectType.Normal
    result.RaceStyleType=RaceStyleType.Normal
    result.TrackData = CommonHelper:GetRacetrackData(BattleInfo.TrackId)

    result.StartNum = 0
    result.EndNum = 0
    result.Round = BattleInfo.Round
    result.mapid = 1001
    result.RaceFlag = 2
    result.TrackType = 2

    local npcs=BattleInfo.NpcIds
    local npcTracks=BattleInfo.NpcTracks
    if levelData.copytype~=LevelType.GuideLevel or BattleDataManager:Get():GetBattleType()~=RaceModel.Battle or BattleDataManager:Get():GetBattleType()~=RaceModel.NewBieChapter then
        table.insert(result.TeamList,RoomInitDataHelper:BuildMsg_Self_TeamInfo(BattleInfo.PlayerTrack,msg,BattleInfo.PlayerTrack))
    else
        result.DefaultSelectPlayerID=npcs[2]
    end
    for i = 1, #npcs do
       table.insert(result.TeamList, RoomInitDataHelper:BuildMsg_Npc_TeamInfo(npcTracks[i],npcs[i],npcTracks[i],levelData,false))
    end
    self:Set_Data(result.LevelId,result.Seed,result.TrackType,result.room_id)
    return result
end

---@param msg SC_BeginPve
function RoomInitDataHelper:BuildMsg_SC_BeginChallengeRes(msg,idx)
    local result = Lua_RoomInitData()
    result.LevelId = msg.copyid
    result.SelfCarId=msg.carid
    _copyid= msg.copyid
    _seed=msg.seed
    ---@type dictcopy_config_cell
    local levelData=CommonHelper:GetTableDataByID(ConfigNames.pvelevel_config,msg.copyid)
    ---@type PVELevelBattleData
    local BattleInfo=levelData.BattleInfoList[idx]
    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, BattleInfo.SceneId)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = BattleInfo.SceneId
    result.Seed = msg.starttime
    if levelData and levelData.timescale~=nil then
        BattleDataManager:Get():SetDefaultBattleSpeed(levelData.timescale/1000)
    else
        BattleDataManager:Get():SetDefaultBattleSpeed(1)
    end
    result.ProtectType=1
    if levelData.BattleType~=RaceStyleType.Normal then
        result.RaceStyleType=levelData.BattleType
        result.CountDownDuration=levelData.BattleTime
    end
    result.TrackData = CommonHelper:GetRacetrackData(BattleInfo.TrackId)

    result.StartNum = 0
    result.EndNum = 0
    result.Round = BattleInfo.Round
    result.mapid = 1001
    result.RaceFlag = 2
    result.TrackType = 2

    local npcs=BattleInfo.NpcIds
    local npcTracks=BattleInfo.NpcTracks
    if levelData.copytype~=LevelType.GuideLevel or BattleDataManager:Get():GetBattleType()~=RaceModel.Battle or BattleDataManager:Get():GetBattleType()~=RaceModel.NewBieChapter then
        table.insert(result.TeamList,RoomInitDataHelper:BuildMsg_SelfCars_TeamInfo(BattleInfo.PlayerTrack,msg,BattleInfo.PlayerTrack))
    else
        result.DefaultSelectPlayerID=npcs[2]
    end
    for i = 1, #npcs do
        if npcs[i]~=0 then
            table.insert(result.TeamList, RoomInitDataHelper:BuildMsg_Npc_TeamInfo(npcTracks[i],npcs[i],npcTracks[i],levelData,false))
        end
    end
    self:Set_Data(result.LevelId,result.Seed,result.TrackType,result.room_id)
    return result
end

---@param msg SC_BeginPve
function RoomInitDataHelper:BuildMsg_SC_BeginChallengeResRePlay(msg,idx)
    local result = Lua_RoomInitData()
    result.LevelId = msg.copyId
    result.SelfCarId=msg.selfCarID
    ---@type dictcopy_config_cell
    local levelData=CommonHelper:GetTableDataByID(ConfigNames.pvelevel_config,msg.copyId)
    ---@type PVELevelBattleData
    local BattleInfo=levelData.BattleInfoList[idx]
    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, BattleInfo.SceneId)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = BattleInfo.SceneId
    result.Seed = msg.seed
    if levelData and levelData.timescale~=nil then
        BattleDataManager:Get():SetDefaultBattleSpeed(levelData.timescale/1000)
    else
        BattleDataManager:Get():SetDefaultBattleSpeed(1)
    end
    result.ProtectType=1
    if levelData.BattleType~=RaceStyleType.Normal then
        result.RaceStyleType=levelData.BattleType
        result.CountDownDuration=levelData.BattleTime
    end
    result.TrackData = CommonHelper:GetRacetrackData(BattleInfo.TrackId)

    result.StartNum = 0
    result.EndNum = 0
    result.Round = BattleInfo.Round
    result.mapid = 1001
    result.RaceFlag = 2
    result.TrackType = 2



    table.insert(result.TeamList,RoomInitDataHelper:BuildMsg_OtherCars_TeamInfo(BattleInfo.PlayerTrack,msg,BattleInfo.PlayerTrack,idx))
    local npcs=BattleInfo.NpcIds
    local npcTracks=BattleInfo.NpcTracks
    for i = 1, #npcs do
        if npcs[i]>0 then
            table.insert(result.TeamList, RoomInitDataHelper:BuildMsg_Npc_TeamInfo(npcTracks[i],npcs[i],npcTracks[i],levelData,false))
        end
    end
    result.DefaultSelectPlayerID=msg.selfCarID
    self:Set_Data(result.LevelId,result.Seed,result.TrackType,result.room_id)

    return result
end





---@param msg SC_BeginPve
function RoomInitDataHelper:BuildMsg_SC_BeginRaceSeniorTrainRes(msg,idx)
    local result = Lua_RoomInitData()
    result.LevelId = msg.copyid
    result.SelfCarId=msg.carid
    _copyid= msg.copyid
    _seed=msg.seed
    ---@type dictcopy_config_cell
    local levelData=CommonHelper:GetTableDataByID(ConfigNames.dicthidecopy_config,msg.copyid)
    ---@type PVELevelBattleData
    local BattleInfo=levelData.BattleInfoList[idx]
    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, BattleInfo.SceneId)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = BattleInfo.SceneId
    result.Seed = msg.starttime

    result.ProtectType=1
    result.RaceStyleType=RaceStyleType.Normal
    result.TrackData = CommonHelper:GetRacetrackData(BattleInfo.TrackId)

    result.StartNum = 0
    result.EndNum = 0
    result.Round = BattleInfo.Round
    result.mapid = 1001
    result.RaceFlag = 1
    result.TrackType = 2

    local npcs=BattleInfo.NpcIds
    local npcTracks=BattleInfo.NpcTracks
    if levelData.copytype~=LevelType.GuideLevel or BattleDataManager:Get():GetBattleType()~=RaceModel.RaceSeniorTrain then
        table.insert(result.TeamList,RoomInitDataHelper:BuildMsg_Self_TeamInfo(BattleInfo.PlayerTrack,msg,BattleInfo.PlayerTrack))
    else
        result.DefaultSelectPlayerID=npcs[2]
    end
    for i = 1, #npcs do
        table.insert(result.TeamList, RoomInitDataHelper:BuildMsg_Npc_TeamInfo(npcTracks[i],npcs[i],npcTracks[i],levelData,false))
    end
    self:Set_Data(result.LevelId,result.Seed,result.TrackType,result.room_id)
    return result
end
---@param msg SC_BeginPve
function RoomInitDataHelper:BuildMsg_SC_BeginSelfChapterRaceRes(msg,idx)
    local result = Lua_RoomInitData()
    result.LevelId = msg.copyid
    result.SelfCarId=msg.carid
    ---@type dictactivitycopy_config_cell
    local levelData=CommonHelper:GetTableDataByID(ConfigNames.dictactivitycopy_config,msg.copyid)
    ---@type PVELevelBattleData
    local BattleInfo=levelData.BattleInfoList[idx]
    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, BattleInfo.SceneId)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = BattleInfo.SceneId
    result.Seed = msg.starttime

    if levelData.BattleType~=RaceStyleType.Normal then
        result.RaceStyleType=levelData.BattleType
        result.CountDownDuration=levelData.BattleTime
    end
    result.TrackData = CommonHelper:GetRacetrackData(BattleInfo.TrackId)

    result.StartNum = 0
    result.EndNum = 0
    result.Round = BattleInfo.Round
    result.mapid = 1001
    result.RaceFlag = 1
    result.TrackType = 2

    local npcs=BattleInfo.NpcIds
    local npcTracks=BattleInfo.NpcTracks
    if levelData.copytype~=LevelType.GuideLevel or BattleDataManager:Get():GetBattleType()~=RaceModel.Battle or BattleDataManager:Get():GetBattleType()~=RaceModel.NewBieChapter then
        table.insert(result.TeamList,RoomInitDataHelper:BuildMsg_SelfCars_TeamInfo(BattleInfo.PlayerTrack,msg,BattleInfo.PlayerTrack))
    else
        result.DefaultSelectPlayerID=npcs[2]
    end
    for i = 1, #npcs do
        if npcs[i]>0 then
            table.insert(result.TeamList, RoomInitDataHelper:BuildMsg_Npc_TeamInfo(npcs[i],npcs[i],npcTracks[i],levelData,false,#msg.cars+i))
        end
    end
    self:Set_Data(result.LevelId,result.Seed,result.TrackType,result.room_id)
    return result
end



---@param msg SC_BeginPve
function RoomInitDataHelper:BuildMsg_SC_BeginRaceHistoryRes(msg,idx)
    local result = Lua_RoomInitData()
    result.LevelId = msg.copyId
    result.SelfCarId=msg.selfCarID
    ---@type dictcopy_config_cell
    local levelData=CommonHelper:GetTableDataByID(ConfigNames.pvelevel_config,msg.copyId)
    ---@type PVELevelBattleData
    local BattleInfo=levelData.BattleInfoList[idx]
    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, BattleInfo.SceneId)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = BattleInfo.SceneId
    result.Seed = msg.seed
    if levelData and levelData.timescale~=nil then
        BattleDataManager:Get():SetDefaultBattleSpeed(levelData.timescale/1000)
    else
        BattleDataManager:Get():SetDefaultBattleSpeed(1)
    end
    result.ProtectType=1
    result.RaceStyleType=RaceStyleType.Normal
    if levelData.BattleType~=RaceStyleType.Normal then
        result.RaceStyleType=levelData.BattleType
        result.CountDownDuration=levelData.BattleTime
    end
    result.TrackData = CommonHelper:GetRacetrackData(BattleInfo.TrackId)

    result.StartNum = 0
    result.EndNum = 0
    result.Round = BattleInfo.Round
    result.mapid = 1001
    result.RaceFlag = 1
    result.TrackType = 2
    result.supportAutoRecoverType = 1


    table.insert(result.TeamList,RoomInitDataHelper:BuildMsg_Other_TeamInfo(BattleInfo.PlayerTrack,msg,BattleInfo.PlayerTrack,idx))
    local npcs=BattleInfo.NpcIds
    local npcTracks=BattleInfo.NpcTracks
    for i = 1, #npcs do
        if npcs[i]>0 then
            table.insert(result.TeamList, RoomInitDataHelper:BuildMsg_Npc_TeamInfo(npcTracks[i],npcs[i],npcTracks[i],levelData,false))
        end
    end
    result.DefaultSelectPlayerID=msg.selfCarID
    self:Set_Data(result.LevelId,result.Seed,result.TrackType,result.room_id)

    return result
end
---@param msg SC_BeginPve
function RoomInitDataHelper:BuildMsg_SC_BeginRaceCarGodHistoryRes(msg,idx)
    local result = Lua_RoomInitData()
    result.LevelId = msg.copyId
    result.SelfCarId=msg.selfCarID
    ---@type dictcopy_config_cell
    local levelData=CommonHelper:GetTableDataByID(ConfigNames.pvelevel_config,msg.copyId)
    ---@type PVELevelBattleData
    local BattleInfo=levelData.BattleInfoList[idx]
    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, BattleInfo.SceneId)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = BattleInfo.SceneId
    result.Seed = msg.seed
    if levelData and levelData.timescale~=nil then
        BattleDataManager:Get():SetDefaultBattleSpeed(levelData.timescale/1000)
    else
        BattleDataManager:Get():SetDefaultBattleSpeed(1)
    end
    result.ProtectType=RaceProtectType.Normal
    result.RaceStyleType=RaceStyleType.Normal
    if levelData.BattleType~=RaceStyleType.Normal then
        result.RaceStyleType=levelData.BattleType
        result.CountDownDuration=levelData.BattleTime
    end
    result.TrackData = CommonHelper:GetRacetrackData(BattleInfo.TrackId)

    result.StartNum = 0
    result.EndNum = 0
    result.Round = BattleInfo.Round
    result.mapid = 1001
    result.RaceFlag = 2
    result.TrackType = 2



    table.insert(result.TeamList,RoomInitDataHelper:BuildMsg_Other_TeamInfo(BattleInfo.PlayerTrack,msg,BattleInfo.PlayerTrack,idx))
    local npcs=BattleInfo.NpcIds
    local npcTracks=BattleInfo.NpcTracks
    for i = 1, #npcs do
        if npcs[i]>0 then
            table.insert(result.TeamList, RoomInitDataHelper:BuildMsg_Npc_TeamInfo(npcTracks[i],npcs[i],npcTracks[i],levelData,false))
        end
    end
    result.DefaultSelectPlayerID=msg.selfCarID
    self:Set_Data(result.LevelId,result.Seed,result.TrackType,result.room_id)

    return result
end



---@param msg SC_BeginPve
function RoomInitDataHelper:BuildMsg_SC_RaceSeniorTrainHistoryRes(msg,idx)
    local result = Lua_RoomInitData()
    result.LevelId = msg.copyId
    result.SelfCarId=msg.selfCarID
    ---@type dictcopy_config_cell
    local levelData=CommonHelper:GetTableDataByID(ConfigNames.dicthidecopy_config,msg.copyId)
    ---@type PVELevelBattleData
    local BattleInfo=levelData.BattleInfoList[idx]
    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, BattleInfo.SceneId)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = BattleInfo.SceneId
    result.Seed = msg.seed

    result.ProtectType=1
    result.RaceStyleType=RaceStyleType.Normal
    result.TrackData = CommonHelper:GetRacetrackData(BattleInfo.TrackId)

    result.StartNum = 0
    result.EndNum = 0
    result.Round = BattleInfo.Round
    result.mapid = 1001
    result.RaceFlag = 1
    result.TrackType = 2



    table.insert(result.TeamList,RoomInitDataHelper:BuildMsg_Other_TeamInfo(BattleInfo.PlayerTrack,msg,BattleInfo.PlayerTrack,idx))
    local npcs=BattleInfo.NpcIds
    local npcTracks=BattleInfo.NpcTracks
    for i = 1, #npcs do
        table.insert(result.TeamList, RoomInitDataHelper:BuildMsg_Npc_TeamInfo(npcTracks[i],npcs[i],npcTracks[i],levelData,false))
    end
    result.DefaultSelectPlayerID=msg.selfCarID
    self:Set_Data(result.LevelId,result.Seed,result.TrackType,result.room_id)

    return result
end

--{{{ pve 关卡构建自己的数据
---@param msg SC_BeginPve
function RoomInitDataHelper:BuildMsg_Self_TeamInfo(teamId,msg,playertrackno,bgid)
    local result = Lua_TeamInitData()
    result.TeamID = teamId
    local carreviewdata = CarReviewData()
    carreviewdata:SetDataByMsg(msg.car)
    local player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(msg.carid,playertrackno,nil,carreviewdata,1000,nil,PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),bgid or PlayerDataManager:Get():GetBgId(),PlayerDataManager:Get():GetCups(),msg.curlevel)
    table.insert(result.PlayerList, player)
    return result
end
---@param msg SC_BeginPve
function RoomInitDataHelper:BuildMsg_SelfCars_TeamInfo(teamId,msg,playertrackno)
    local result = Lua_TeamInitData()
    result.TeamID = teamId
    local carreviewdatas={}
    for i = 1, #msg.cars do
        local carreviewdata = CarReviewData()
        carreviewdata:SetDataByMsg(msg.cars[i])
        table.insert(carreviewdatas,carreviewdata)
    end
    local player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(msg.carid,playertrackno,nil,nil,playertrackno,carreviewdatas,PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetBgId(),PlayerDataManager:Get():GetCups(),msg.curlevel)
    table.insert(result.PlayerList, player)
    return result
end


---@param number SC_BeginPve
---@param msg PVEChapterRankData
function RoomInitDataHelper:BuildMsg_Other_TeamInfo(teamId,msg,playertrackno,idx)
    local result = Lua_TeamInitData()
    result.TeamID = teamId
    local player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(msg.carid,playertrackno,nil,msg.carData.CarList[idx],1000,nil,msg.carData.pid,msg.carData.name,msg.carData.icon,msg.carData.IconFrame,msg.carData.bgId,msg.carData.cups,msg.carData.playerLevel)
    table.insert(result.PlayerList, player)
    return result
end
---@param number SC_BeginPve
---@param msg PVEChapterRankData
function RoomInitDataHelper:BuildMsg_OtherCars_TeamInfo(teamId,msg,playertrackno)
    local result = Lua_TeamInitData()
    result.TeamID = teamId
    local carreviewdatas={}
    for i = 1, #msg.carData.CarList do
        table.insert(carreviewdatas,msg.carData.CarList[i])
    end
    local player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(msg.carid,playertrackno,nil,nil,1000,carreviewdatas,msg.carData.pid,msg.carData.name,msg.carData.icon,msg.carData.IconFrame,tonumber(msg.carData.bgId),msg.carData.cups,msg.carData.playerLevel,msg.Stop)
    table.insert(result.PlayerList, player)
    return result
end

---@param msg number
function RoomInitDataHelper:BuildMsg_Player_RaceInfo(carid, trackNum, car,carReviewData ,caridx, carreviewdatas,playerid, name, icon,IconFrame,playerBgId,cups,PlayerLevel,operate,enableAIType)
    local result = Lua_PlayerInitData()
    if car then
        result.PlayerID = playerid
        result.TrackIdx = trackNum
        result.Name =name
        result.PlayerLevel=PlayerLevel
        result.operate=operate or ""
        result.enableAIType=enableAIType or 0
        if result.PlayerID==PlayerDataManager:Get():GetPlayerRID() then
            result.PlayerType=PlayerType.Self
        else
            result.PlayerType=PlayerType.Player
        end
        result.Icon = CommonHelper:GetPlayerIconById(icon)
        result.IconFrame = CommonHelper:GetPlayerIconById(IconFrame,nil,HeadIconAttrType.Frame)
        result.PlayerBgId = tonumber(playerBgId)
        if cups then
            for _, v in pairs(cups) do
                table.insert(result.Cups,v)
            end
        else
            result.Cups={}
        end
        RoomInitDataHelper:Up_Data(playerid,BattleDataManager:Get():GetBattleType(),car)
        local car = RoomInitDataHelper:BuildMsg_Self_CarPlayerInfo(car,caridx)
        table.insert(result.CarList, car)
    elseif carReviewData then
        result.PlayerID = playerid
        result.TrackIdx = trackNum
        result.Name =name
        result.PlayerLevel=PlayerLevel
        result.operate=operate or ""
        result.enableAIType=enableAIType or 0
        if result.PlayerID==PlayerDataManager:Get():GetPlayerRID() then
            result.PlayerType=PlayerType.Self
        elseif result.PlayerID<NpcMaxId then
            result.PlayerType=PlayerType.NPC
        else
            result.PlayerType=PlayerType.Player
        end
        result.Icon = CommonHelper:GetPlayerIconById(icon)
        result.IconFrame = CommonHelper:GetPlayerIconById(IconFrame,nil,HeadIconAttrType.Frame)
        result.PlayerBgId =tonumber(playerBgId)
        if cups then
            for _, v in pairs(cups) do
                table.insert(result.Cups,v)
            end
        else
            result.Cups={}
        end
        RoomInitDataHelper:Up_Data(playerid,BattleDataManager:Get():GetBattleType(),carReviewData)
        local car = RoomInitDataHelper:BuildMsg_Other_CarPlayerInfo(carReviewData,caridx)
        table.insert(result.CarList, car)
    elseif carreviewdatas then
        result.PlayerID = playerid
        result.TrackIdx = trackNum
        result.Name =name
        result.PlayerLevel=PlayerLevel
        result.operate=operate or ""
        result.enableAIType=enableAIType or 0
        if result.PlayerID==PlayerDataManager:Get():GetPlayerRID() then
            result.PlayerType=PlayerType.Self
        elseif result.PlayerID<NpcMaxId then
            result.PlayerType=PlayerType.NPC
        else
            result.PlayerType=PlayerType.Player
        end
        result.Icon = CommonHelper:GetPlayerIconById(icon)
        result.IconFrame = CommonHelper:GetPlayerIconById(IconFrame,nil,HeadIconAttrType.Frame)
        result.PlayerBgId = playerBgId
        if cups then
            for _, v in pairs(cups) do
                table.insert(result.Cups,v)
            end
        else
            result.Cups={}
        end
        RoomInitDataHelper:Up_Data(playerid,BattleDataManager:Get():GetBattleType(),carReviewData)
        for i = 1, #carreviewdatas do
            local car = RoomInitDataHelper:BuildMsg_Other_CarPlayerInfo(carreviewdatas[i],i)
            table.insert(result.CarList, car)
        end
    else
        result.PlayerType=PlayerType.NPC
        result.PlayerID = carid
        result.PlayerLevel = 0
        result.TrackIdx = trackNum
        result.enableAIType = enableAIType or 0
        result.Name,result.Icon=CommonHelper:AnalyseNPCNameAndIconById(carid)
        result.IconFrame = CommonHelper:GetPlayerIconById(1,nil,HeadIconAttrType.Frame)
        result.PlayerBgId = playerBgId~=nil and playerBgId or 0
        if cups then
            for _, v in pairs(cups) do
                table.insert(result.Cups,v)
            end
        else
            result.Cups={}
        end
        local car = RoomInitDataHelper:BuildMsg_SC_CarNpcInfo(carid,trackNum,caridx)
        table.insert(result.CarList, car)
    end
    return result
end

---@param msg SC_BeginPve
function RoomInitDataHelper:BuildMsg_Self_CarPlayerInfo(carData,carid)
    --  log("---   BuildMsg_SC_CarPlayerInfo 解析玩家   trackidx = ",msg.carid ,"name = ",msg.name,"icon = ",msg.icon)
    local result = Lua_CarInitData()
    ---@type CarData
    local cardata = carData
    result.CarID =carid
    result.Attrs = cardata:GetBatterAttr()
    result.SkillIds = {130,138}
    for i = 1, #result.Attrs do
        print("战斗数值",i,"------------>>>>",result.Attrs[i])
    end
    result.Buffs =  cardata:GetBuffIds()
    result.ShellBean =  cardata:GetShellBean()
    if cardata then
        for k,v in pairs(PartGrooveID) do
            if v ~= PartGrooveID.Error then
                local msgidx = AssembleHelper:GrooveIDToMsgIdx(v)
                if msgidx ~= -1 then
                    local Node= cardata.assembleMgr:GetNodeByGrooveID(v)
                    if Node then
                        local partid,orgid = Node:GetPartId(true)
                        local sticker = Node:GetSticker(true)
                        local composeids = {}
                        local quality = 0
                        local generation=Node:GetGeneration()
                        local articledata = KnapsackDataManager:Get():GetArticleByID(cardata.assembleMgr:GetNodeByGrooveID(v):GetBagId())
                        if articledata then
                            composeids = articledata:GetPartComposeIds()
                            quality = articledata:GetPartQuality()
                        end

                        local data = Lua_PartData()
                        data:SetData(partid, composeids, quality,generation,1,orgid,sticker)
                        result.PartDataList[msgidx] = data
                    end

                end
            end
        end

        result.Lightweight = cardata:GetLightweight()
        result.Grids = cardata:GetShellGridList()
        result.Colorid = cardata:GetShellColor()
        result.Stickerid = cardata:GetShellSticker()
    end

    result:AnalyseShellCfg()

    return result
end
--}}}
---@param msg SC_BeginPve
function RoomInitDataHelper:BuildMsg_Other_CarPlayerInfo(carData,carid)
    --  log("---   BuildMsg_SC_CarPlayerInfo 解析玩家   trackidx = ",msg.carid ,"name = ",msg.name,"icon = ",msg.icon)
    local str=""
    local result = Lua_CarInitData()
    ---@type CarReviewData
    local cardata = carData
    result.CarID =carid

    result.Attrs = cardata:GetBatterAttr()
    result.SkillIds = {130,138}
    for i = 1, #result.Attrs do
        local temp="战斗数值"..result.CarID..":"..(i-1).."--------->>>>>"..result.Attrs[i]..'\n'
        print(temp)
        str=str..temp
    end
    if CommonSubsystem:Get().IsLoadRankData==false then
        CS.MonoHelper.CheckNpcTimeFileExist()
        CS.MonoHelper.AppendToNpcTime("-------------------------------------------\n")
        CS.MonoHelper.AppendToNpcTime(str)
    end

    result.Buffs =  cardata:GetBuffIds()
    result.ShellBean =  cardata:GetShellBean()
    result.PartDataList=cardata:GetPartList()
    result.Lightweight = cardata:GetLightweight()
    result.Grids = cardata:GetGrids()
    result.Colorid = cardata:GetColorId()
    result.Stickerid = cardata:GetStickerid()
    result:AnalyseShellCfg()
    return result
end
--}}}
---@param number SC_BeginPve
function RoomInitDataHelper:BuildMsg_Npc_TeamInfo(teamId,npcid,npctrack,levelCfg,flag,carId)
    local result = Lua_TeamInitData()
    result.TeamID = teamId
    local player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(npcid,npctrack,nil,nil,carId)
    table.insert(result.PlayerList, player)
    return result
end
function RoomInitDataHelper:BuildMsg_Npc_GetNpcAttr(npcId)
    local result={}
    ---@type dictnpc_config_cell
    local npccfg = CommonHelper:GetTableDataByID(ConfigNames.dictnpc_config, npcId)
    if npccfg==nil then
        print("npc表空"..npcId)
        return
    end
    table.insert(result,"0")
    table.insert(result,tostring(math.modf(npccfg.attr1*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr2*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr3*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr4*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr5*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr6*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr7*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr8*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr9*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr10*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr11*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr12*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr13*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr14*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr15*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr16*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr17*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr18*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr19*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr20*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr21*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr22*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr23*1000)))
    table.insert(result,tostring(math.modf(0)))
    table.insert(result,tostring(math.modf(0)))
    table.insert(result,tostring(math.modf(npccfg.attr26*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr27*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr28*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr29*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr30*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr31*1000)))
    table.insert(result,"0")
    table.insert(result,"0")
    table.insert(result,"0")
    table.insert(result,"0")
    table.insert(result,"0")
    table.insert(result,"0")
    table.insert(result,"0")
    table.insert(result,tostring(math.modf(npccfg.attr39*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr40*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr41*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr42*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr43*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr44*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr45*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr46*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr47*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr48*1000)))
    table.insert(result,tostring(math.modf(npccfg.attr49*1000)))
    return result
end
---@param npcId number
function RoomInitDataHelper:BuildMsg_SC_CarNpcInfo(npcId,number,carId)
    log("---   BuildMsg_SC_CarNpcInfo 解析npc   trackidx = ",number, "npcid = ", npcId)
    carId=carId or number
    local result = Lua_CarInitData()
    result.CarID = carId
    local carData=CarReviewData()
    carData:SetDataByNPC(npcId)
    result.Attrs = RoomInitDataHelper:BuildMsg_Npc_GetNpcAttr(npcId)
    result.SkillIds = {130,138}
    result.CarCfgId=npcId
    result.PartDataList=carData:GetPartList()
    result.Lightweight = carData:GetLightweight()
    result.Grids = carData:GetGrids()
    result.Colorid = carData:GetColorId()
    result.Stickerid = carData:GetStickerid()
    local shellBaseCfg= result:AnalyseShellCfg()
    result.Buffs=carData:GetBuffIds()
    result.ShellBean=carData:GetShellBean()
    return result
end

---@param npcid number
---@return table<number, Lua_PartData>
function RoomInitDataHelper:AnalyseNpcIdToPartInfo(npcid)
    -- 服务器下发npcid，不下发配件数据，客户端自己生成
    local result ={}
    ---@type dictnpc_config_cell
    local npccfg = CommonHelper:GetTableDataByID(ConfigNames.dictnpc_config, npcid)
    if npccfg then
        ---@type dictcardetail_config_cell
       local carcfg = CommonHelper:GetTableDataByID(ConfigNames.dictcardetail_config, npccfg.suits)
        if carcfg then
            local partlist = AssembleHelper:AnalyseCfgToMsgParts(carcfg)
            for i = 1, #partlist do
                local composeids = {}
                local quality = 0
                local generation=1
                local level=1
                local sticker=0
                ---@type dictpartcell_config_cell
                local cfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partlist[i])
                if cfg then
                    composeids = cfg.NewComposeIDs
                    quality = cfg.quality
                end
                local data = Lua_PartData()
                data:SetData(partlist[i], composeids, quality, generation,level,partlist[i],sticker)
                table.insert(result, data)
            end
        end
    end
    return result
end

---@param suitId number
---@return table<number, Lua_PartData>
function RoomInitDataHelper:AnalyseSuitIdToPartInfo(suitId)
       local result ={}
        ---@type dictcardetail_config_cell
       local carcfg = CommonHelper:GetTableDataByID(ConfigNames.dictcardetail_config, suitId)
        if carcfg then
            local partlist = AssembleHelper:AnalyseCfgToMsgParts(carcfg)
            for i = 1, #partlist do
                local composeids = {}
                local quality = 0
                local generation=1
                local sticker=0
                ---@type dictpartcell_config_cell
                local cfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partlist[i])
                if cfg then
                    composeids = cfg.NewComposeIDs
                    quality = cfg.quality
                end
                local data = Lua_PartData()
                data:SetData(partlist[i], composeids, quality,generation,1,partlist[i],sticker)
                table.insert(result, data)
            end
        end
    return result
end

---@param npcid number
---@return Lua_ShellInfoData
function RoomInitDataHelper:AnalyseNpcIdToShellInfo(npcid)
    -- 服务器下发npcid，不下发配件数据，客户端自己生成
    local result =Lua_ShellInfoData()
    ---@type npc_config_cell
    local npccfg = CommonHelper:GetTableDataByID(ConfigNames.dictnpc_config, npcid)
    if npccfg then
        ---@type car_config_cell
       local carcfg = CommonHelper:GetTableDataByID(ConfigNames.dictcardetail_config, npccfg.suits)
        if carcfg then
            result:SetData(carcfg.npcshow)
        end
    end
    return result
end

---@param suitId number
---@return Lua_ShellInfoData
function RoomInitDataHelper:AnalyseSuitIdToShellInfo(suitId)
    -- 服务器下发npcid，不下发配件数据，客户端自己生成
    local result =Lua_ShellInfoData()
        ---@type dictcardetail_config_cell
       local carcfg = CommonHelper:GetTableDataByID(ConfigNames.dictcardetail_config, suitId)
        if carcfg then
            result:SetData(carcfg.npcshow)
        end
    return result
end

---@param msg SC_CarPlayerInfo
function RoomInitDataHelper:BuildMsg_SC_CarPlayerInfo(msg)
    log("---   BuildMsg_SC_CarPlayerInfo 解析玩家   trackidx = ",msg.uniqueId ,"name = ",msg.name,"icon = ",msg.icon)
    local result = Lua_CarInitData()
    result.CarID = msg.uniqueId
    result.Attrs = msg.attrs
    result.SkillIds = {130,138}
    result.Buffs = msg.buffIds

    if #msg.parts > 0 then

        for i = 1, #msg.parts do
            local partdata = msg.parts[i]
            local partid = partdata.cId
            local composeids = partdata.composeIds
            local generation=1
            if composeids == nil or #composeids == 0 then
                ---@type parts_config_cell
                local cfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, partid)
                if cfg then composeids = cfg.NewComposeIDs end
            end

            local data = Lua_PartData()
            data:SetData(partid, composeids, 1,generation,1,partid,0)
            result.PartDataList[i] = data
            local shellidx = AssembleHelper:GrooveIDToMsgIdx(PartGrooveID.Shell)
            if shellidx == i and partdata.shellInfo then
                result.Lightweight = partdata.shellInfo.lightweight
                result.Grids = partdata.shellInfo.grid
                result.Colorid = partdata.shellInfo.shellcolor
                result.Stickerid = partdata.shellInfo.shellsticker

            end
        end


    else

        local cardata = CarDataManager:Get():GetCarDataByCarID(msg.carIdx)
        if cardata then
            for k,v in pairs(PartGrooveID) do
                if v ~= PartGrooveID.Error then
                    local msgidx = AssembleHelper:GrooveIDToMsgIdx(v)
                    if msgidx ~= -1 then
                        local partid,orgid = cardata.assembleMgr:GetNodeByGrooveID(v):GetPartId(true)
                        local sticker = cardata.assembleMgr:GetNodeByGrooveID(v):GetSticker(true)

                        local composeids = {}
                        local quality = 0
                        local generation=cardata.assembleMgr:GetNodeByGrooveID(v):GetGeneration()
                        local articledata = KnapsackDataManager:Get():GetArticleByID(cardata.assembleMgr:GetNodeByGrooveID(v):GetBagId())
                        if articledata then
                            composeids = articledata:GetPartComposeIds()
                            quality = articledata:GetPartQuality()
                        end

                        local data = Lua_PartData()
                        data:SetData(partid, composeids, quality,generation,1,orgid,sticker)
                        result.PartDataList[msgidx] = data
                    end
                end
            end

            result.Lightweight = cardata:GetLightweight()
            result.Grids = cardata:GetShellGridList()
            result.Colorid = cardata:GetShellColor()
            result.Stickerid = cardata:GetShellSticker()
        end

    end


    result:AnalyseShellCfg()

    return result
end

---@param msg table<number, RaceHistoryPlayerData>
function RoomInitDataHelper:BuildMsg_SC_RcPlayerList(msg)
    local result = {}

    for i = 1, #msg do
        local msgdata = msg[i]
        local teamdata = Lua_TeamInitData()
        local playerdata = Lua_PlayerInitData()
        local cardata = Lua_CarInitData()

        table.insert(result, teamdata)


        teamdata.TeamID = i
        teamdata.PlayerList[1] = playerdata

        playerdata.PlayerID = msgdata.pid
        playerdata.PlayerLevel = msgdata.level
        playerdata.Name = msgdata:GetName()
        playerdata.Icon = msgdata:GetIcon()
        playerdata.GuildName = ""
        playerdata.TrackIdx = msgdata.trackId
        playerdata.CarList[1] = cardata

        cardata.CarID = i
        cardata.Lightweight = 0
        cardata.Grids = {}
        cardata.Colorid = 0
        cardata.Stickerid = 0
        cardata.Attrs = msgdata:GetAttr()
        cardata.SkillIds = {130}
        if msgdata.pid < 100000000 then -- pid小于1亿 npc
            cardata.PartDataList = RoomInitDataHelper:AnalyseNpcIdToPartInfo(msgdata.pid)
            local shellInfo= RoomInitDataHelper:AnalyseNpcIdToShellInfo(msgdata.pid)
            cardata.Lightweight = shellInfo:GetLightweight()
            cardata.Grids = shellInfo:GetGrids() -- 纱网数据
            cardata.Colorid = shellInfo:GetColorid() -- 车壳染色数据
            cardata.Stickerid = shellInfo:GetStickerid() -- 贴纸数据
            cardata:AnalyseShellCfg()
        else
            local carreviewdata = msgdata:GetCarReviewData()
            cardata.PartDataList = carreviewdata:GetPartList()
            cardata.Lightweight = carreviewdata:GetLightweight()
            cardata.Grids = carreviewdata:GetGrids()
            cardata.Colorid = carreviewdata:GetColorId()
            cardata.Stickerid = carreviewdata:GetStickerid()
            cardata.CarshellCfg = carreviewdata:GetShellCfg()
        end
    end

    return result
end
function RoomInitDataHelper:BuildMsg_SC_GetRaceStyleType(racetype)
    if racetype and racetype>0 then
        if racetype==1 then
            return RaceProtectType.Normal,RaceStyleType.Normal
        end
        if racetype==2 then
            return RaceProtectType.Normal,RaceStyleType.Relay
        end
        if racetype==3 then
            return RaceProtectType.Protect,RaceStyleType.Normal
        end
        if racetype==4 then
            return RaceProtectType.Protect,RaceStyleType.Relay
        end
    else
        racetype=RaceRankManager:Get():GetProtectType()
        if racetype==RaceProtectType.Normal then
            return RaceProtectType.Normal,RaceStyleType.Normal
        end
        if racetype==RaceProtectType.Protect then
            return RaceProtectType.Protect,RaceStyleType.Normal
        end
    end
    return RaceProtectType.Normal,RaceStyleType.Normal
end
---@param msg SC_RetPVPStart
---@param trackdata RaceTrackData
function RoomInitDataHelper:BuildMsg_SC_NotifyRoomFight(msg, trackdata)
    local result = Lua_RoomInitData()

    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, msg.sceneid)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = msg.sceneid
    result.Seed = msg.starttime
    result.Round = trackdata:GetRaceNumber()
    result.RaceFlag = 2
    local ProtectType,styleType= RoomInitDataHelper:BuildMsg_SC_GetRaceStyleType()
    result.ProtectType=msg.protect
    result.RaceStyleType=styleType
    result.DefaultSelectPlayerID=msg.rid
    result.TrackData = trackdata
    result.TrackType = result.TrackData.isfield and TrackType.Free or TrackType.Mini
    if styleType==RaceStyleType.Relay then
        local team = RoomInitDataHelper:BuildMsg_SC_TeamCarsInfo(msg)
        table.insert(result.TeamList, team)
    else
        for i = 1, #msg.race do
            if result.ProtectType==RaceProtectType.Normal then
                msg.race[i].op=""
            end
            local team = RoomInitDataHelper:BuildMsg_SC_TeamInfo(msg.race[i])
            table.insert(result.TeamList, team)
        end
    end

   self:Set_Data(result.LevelId,result.Seed,result.TrackType,result.room_id)
    return result
end
---@param msg SC_RetPVPRecord
---@param trackdata RaceTrackData
function RoomInitDataHelper:BuildMsg_SC_NotifyHistoryRoomFight(msg, trackdata)
    local result = Lua_RoomInitData()
    local rece=msg.start
    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, rece.sceneid)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = rece.sceneid
    result.Seed = rece.starttime
    result.Round = trackdata:GetRaceNumber()
    result.RaceFlag = 2

    local ProtectType,styleType= RoomInitDataHelper:BuildMsg_SC_GetRaceStyleType(rece.newracetype)
    result.ProtectType=msg.start.protect
    result.RaceStyleType=styleType
    result.DefaultSelectPlayerID=msg.lookrid
    result.TrackData = trackdata
    result.TrackType = result.TrackData.isfield and TrackType.Free or TrackType.Mini

    if styleType==RaceStyleType.Relay then
        local team = RoomInitDataHelper:BuildMsg_SC_TeamCarsInfo(rece)
        table.insert(result.TeamList, team)
    else
        for i = 1, #rece.race do
            if result.ProtectType==RaceProtectType.Normal then
                rece.race[i].op=""
            end
            local team = RoomInitDataHelper:BuildMsg_SC_TeamInfo(rece.race[i])
            table.insert(result.TeamList, team)
        end
    end
    return result
end
---@param msg RaceRoomData
---@param trackdata RaceTrackData
function RoomInitDataHelper:BuildMsg_SC_NotifyRaceRoomFight(msg, trackdata)
    local result = Lua_RoomInitData()

    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, msg:GetSceneID())
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = msg:GetSceneID()
    result.Seed = msg:GetSeed()
    result:SetStartTime(msg:GetSeed()*1000)
    result:SetSupportSpeedUp(true)
    result.Round = trackdata:GetRaceNumber()
    result.RaceFlag = 2
    result.ProtectType=0
    result.RaceStyleType=RaceStyleType.Normal
    result.TrackData = trackdata
    result.TrackType = result.TrackData.isfield and TrackType.Free or TrackType.Mini

    for i = 1, #msg.PlayerList do
        local team = RoomInitDataHelper:BuildMsg_SC_RaceRoomTeamInfo(msg.PlayerList[i])
        table.insert(result.TeamList, team)
    end

    return result
end

---@param msg SC_RetEnterSelfRoom
function RoomInitDataHelper:BuildMsg_SC_RetEnterSelfRoom(msg)
    local result = Lua_RoomInitData()

    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, msg.groundid)
    local trackdata=CommonHelper:GetRacetrackData(msg.trackid,msg.selftrack)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = msg.groundid
    result.Seed = msg.s1
    result:SetStartTime(msg.s1*1000)
    result:SetSupportSpeedUp(true)
    result.Round = trackdata:GetRaceNumber()
    result.RaceFlag = 2
    result.ProtectType=RaceProtectType.Normal
    result.RaceStyleType=RaceStyleType.Normal
    result.TrackData = trackdata
    result.TrackType = result.TrackData.isfield and TrackType.Free or TrackType.Mini

    for i = 1, #msg.racer do
        local team = RoomInitDataHelper:BuildMsg_SC_RaceRoomSelfRaceInfo(msg.racer[i])
        table.insert(result.TeamList, team)
    end
    result.DefaultSelectPlayerID=msg.createid
    return result
end

---@param msg SC_RetBeginBattle
function RoomInitDataHelper:BuildMsg_SC_SelfLevel(msg)
    local result = Lua_RoomInitData()

    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, msg.scenceid)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = msg.scenceid
    result.Seed = msg.starttime
    local trackData=CommonHelper:GetRacetrackData(msg.trackid,msg.trackinfo)
    result.Round = trackData:GetRaceNumber()
    result.RaceFlag = 2
    result.ProtectType=RaceProtectType.Normal
    result.RaceStyleType=RaceStyleType.Normal
    result.TrackData = trackData
    result.TrackType = result.TrackData.isfield and TrackType.Free or TrackType.Mini

    for i = 1, #msg.racers do
        local team = RoomInitDataHelper:BuildMsg_SC_BattleRaceInfo(msg.racers[i])
        table.insert(result.TeamList, team)
    end
    return result
end
---@param msg SC_RetBeginBattle
function RoomInitDataHelper:BuildMsg_SC_SelfLevelHistory(msg,defaultId)
    local result = Lua_RoomInitData()

    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, msg.scenceid)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = msg.scenceid
    result.Seed = msg.starttime
    local trackData=CommonHelper:GetRacetrackData(msg.trackid,msg.trackinfo)
    result.Round = trackData:GetRaceNumber()
    result.RaceFlag = 2

    result.ProtectType=RaceProtectType.Normal
    result.RaceStyleType=RaceStyleType.Normal
    result.TrackData = trackData
    result.TrackType = result.TrackData.isfield and TrackType.Free or TrackType.Mini

    for i = 1, #msg.racers do
        local team = RoomInitDataHelper:BuildMsg_SC_BattleRaceInfo(msg.racers[i])
        table.insert(result.TeamList, team)
    end
    if defaultId then
        result.DefaultSelectPlayerID=defaultId
    end
    return result
end


---@param msg SC_BeginFastPvp
function RoomInitDataHelper:BuildMsg_SC_RaceTrot(msg,defaultId)
    local result = Lua_RoomInitData()

    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, 29000002)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = 29000002
    result.Seed = msg.starttime
    local trackData=CommonHelper:GetRacetrackData(msg.trackid)
    result.Round = trackData:GetRaceNumber()
    result.RaceFlag = 2

    result.ProtectType=1
    result.RaceStyleType=RaceStyleType.Normal
    result.TrackData = trackData
    result.TrackType = result.TrackData.isfield and TrackType.Free or TrackType.Mini

    for i = 1, #msg.racelist do
        local type=0
        local option=""
        if msg.racelist[i].rid~=PlayerDataManager:Get():GetPlayerRID() then
            type=1
            option="-1,0,-1,0"
            PlayerPrefsHelper:SetValue_ReplayInputInfos(option)
        else
            msg.curlevel=PlayerDataManager:Get():GetPlayerLV()
        end
        local team = RoomInitDataHelper:BuildMsg_SC_FighterInfo(msg.racelist[i],msg.curlevel,type,option)
        table.insert(result.TeamList, team)
    end
    if defaultId then
        result.DefaultSelectPlayerID=defaultId
    end
    return result
end


---@param msg SC_RetStart
function RoomInitDataHelper:BuildMsg_SC_RetStart(msg,defaultId,type)
    local result = Lua_RoomInitData()

    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, msg.sceneid)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = msg.sceneid
    result.Seed = msg.starttime
    local trackData=CommonHelper:GetRacetrackData(msg.trackid)
    result.Round = trackData:GetRaceNumber()
    result.RaceFlag = 2

    result.ProtectType=type
    result.RaceStyleType=RaceStyleType.Normal
    result.TrackData = trackData
    result.TrackType = result.TrackData.isfield and TrackType.Free or TrackType.Mini

    for i = 1, #msg.race do
        local team = RoomInitDataHelper:BuildMsg_SC_RaceInfo(msg.race[i])
        table.insert(result.TeamList, team)
    end
    if defaultId then
        result.DefaultSelectPlayerID=defaultId
    end

    return result
end
---@param msg SC_RetStart
function RoomInitDataHelper:BuildMsg_SC_RetStartRecord(msg,defaultId)
    local result = Lua_RoomInitData()

    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, msg.sceneid)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = msg.sceneid
    result.Seed = msg.starttime
    local trackData=CommonHelper:GetRacetrackData(msg.trackid)
    result.Round = trackData:GetRaceNumber()
    result.RaceFlag = 2

    result.ProtectType=1
    result.RaceStyleType=RaceStyleType.Normal
    result.TrackData = trackData
    result.TrackType = result.TrackData.isfield and TrackType.Free or TrackType.Mini

    for i = 1, #msg.race do
        local team = RoomInitDataHelper:BuildMsg_SC_RaceInfo(msg.race[i])
        table.insert(result.TeamList, team)
    end
    if defaultId then
        result.DefaultSelectPlayerID=defaultId
    end

    return result
end


---@param msg SC_MatchInfos
function RoomInitDataHelper:BuildMsg_SC_RaceSuperBattle(msg)
    local result = Lua_RoomInitData()
    local index=tonumber(msg.matchno)
    ---@type SC_MatchInfo
    local matchInfo=msg.matchs[1]
    local sceneId=stringSplitToNumber(matchInfo.groundids,':')[index]
    local trackid=stringSplitToNumber(matchInfo.trackids,':')[index]
    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config,sceneId )
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = sceneId
    result.Seed = matchInfo.seed
    local trackData=CommonHelper:GetRacetrackData(trackid)
    result.Round = trackData:GetRaceNumber()
    result.RaceFlag = 2

    result.ProtectType=RaceProtectType.Normal
    result.RaceStyleType=RaceStyleType.Normal
    result.TrackData = trackData
    result.TrackType = result.TrackData.isfield and TrackType.Free or TrackType.Mini

    local team = RoomInitDataHelper:BuildMsg_SC_MatchInfo(matchInfo,index)
    result.TeamList=team
    result.DefaultSelectPlayerID=tonumber(matchInfo.race1.rid)
    if tonumber(matchInfo.race2.rid)==PlayerDataManager:Get():GetPlayerRID() then
        result.DefaultSelectPlayerID=PlayerDataManager:Get():GetPlayerRID()
    else
        if tonumber(matchInfo.race2.rid)==RaceSuperBattleManager:Get():GetLookId() then
            result.DefaultSelectPlayerID=RaceSuperBattleManager:Get():GetLookId()
        end
    end

    return result
end



---@param msg   {trackId,scenceId,carId}
function RoomInitDataHelper:BuildMsg_SC_RaceTest(msg,ProtectType,postion)
    local result = Lua_RoomInitData()

    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, msg.scenceId)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = msg.scenceId
    result.Seed = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    local trackData=CommonHelper:GetRacetrackData(msg.trackId)
    result.Round = trackData:GetRaceNumber()
    result.RaceFlag = 2
    if postion==nil or postion==0 then postion=math.random(1,result.Round) end
    result.ProtectType=ProtectType
    result.RaceStyleType=msg.raceStyle or RaceStyleType.Normal
    result.TrackData = trackData
    result.TrackType = result.TrackData.isfield and TrackType.Free or TrackType.Mini
    local team = RoomInitDataHelper:BuildMsg_SC_JcpTest(msg,postion)
    table.insert(result.TeamList, team)
    result.DefaultSelectPlayerID=PlayerDataManager:Get():GetPlayerRID()
    return result
end

---@param msg SC_RetGuildPVEStart
function RoomInitDataHelper:BuildMsg_SC_RaceClubPve(msg)
    local result = Lua_RoomInitData()

    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, msg.sceneid)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = msg.sceneid
    result.Seed = msg.starttime
    local trackData=CommonHelper:GetRacetrackData(msg.trackid)
    result.Round = trackData:GetRaceNumber()
    result.RaceFlag = 2

    result.ProtectType=1
    result.RaceStyleType=RaceStyleType.Normal
    result.TrackData = trackData
    result.TrackType = result.TrackData.isfield and TrackType.Free or TrackType.Mini
    local team = RoomInitDataHelper:BuildMsg_SC_ClubPve(msg,math.random(1,result.Round))
    table.insert(result.TeamList, team)
    result.DefaultSelectPlayerID=PlayerDataManager:Get():GetPlayerRID()
    return result
end



---@param msg   SC_RetRaceRecord
function RoomInitDataHelper:BuildMsg_SC_RaceRecord(msg,type)
    local result = RoomInitDataHelper:BuildMsg_SC_RetStart(msg.start,msg.lookrid,type)
    return result
end














---@param msg SC_RaceInfo
function RoomInitDataHelper:BuildMsg_SC_TeamInfo(msg)
    local result = Lua_TeamInitData()
    result.TeamID = msg.position

    if msg.car then
        local car=CarReviewData()
        print("RID",msg.rid)
        car:SetDataByMsg(msg.car)
        local cups=nil
        if msg.titlecup then
            cups = stringSplitToNumber(msg.titlecup,":")
        end
        local player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(msg.rid,msg.position,nil,car,msg.position,nil,msg.rid,msg.rolename,msg.headicon,msg.iconframe,msg.titleback,cups,msg.curlev,msg.op)
        table.insert(result.PlayerList, player)
    else
        local player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(msg.rid,msg.position)
        table.insert(result.PlayerList, player)
    end
    return result
end
---@param msg SC_RetPVPStart
function RoomInitDataHelper:BuildMsg_SC_TeamCarsInfo(msg)
    local result = Lua_TeamInitData()
    result.TeamID = msg.race[1].position
    local playermsg=msg.race[1]
    if msg.race then
        local cars={}
        for i = 1, #msg.race do
            local car=CarReviewData()
            car:SetDataByMsg(msg.race[i].car)
            table.insert(cars,car)
        end
        local cups=nil
        if playermsg.titlecup then
            cups = stringSplitToNumber(playermsg.titlecup,":")
        end
        local player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(playermsg.rid,playermsg.position,nil,nil,playermsg.position,cars,playermsg.rid,playermsg.rolename,playermsg.headicon,playermsg.iconframe,playermsg.titleback,cups,playermsg.curlev,playermsg.op)
        table.insert(result.PlayerList, player)
    else
        local player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(playermsg.rid,playermsg.position)
        table.insert(result.PlayerList, player)
    end
    return result
end

---@param msg RaceRoomPlayerData
function RoomInitDataHelper:BuildMsg_SC_RaceRoomTeamInfo(msg)
    local result = Lua_TeamInitData()
    result.TeamID = msg:GetPosIdx()
    local cups=nil
    if msg.titlecup then
        cups = stringSplitToNumber(msg.titlecup,":")
    end
    local player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(msg:GetID(),msg:GetPosIdx(),nil,msg:GetCarData(),msg:GetPosIdx(),nil,msg:GetID(),msg:GetName(),msg:GetHeadIcon(),msg:GetIconFrame(),msg:GetTitleBack(),msg:GetCups(),msg:GetLV())
    table.insert(result.PlayerList, player)
    return result
end
---@param msg SC_SelfRaceInfo
function RoomInitDataHelper:BuildMsg_SC_RaceRoomSelfRaceInfo(msg)
    local result = Lua_TeamInitData()
    result.TeamID = msg.position
    local carData=CarReviewData()
    carData:SetDataByMsg(msg.car)
    local cups=nil
    if msg.titlecup then
        cups = stringSplitToNumber(msg.titlecup,":")
    end
    local player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(msg.rid,msg.position,nil,carData,msg.position,nil,msg.rid,msg.rolename,msg.headicon,msg.iconframe,msg.titleback,cups,msg.curlevel)
    table.insert(result.PlayerList, player)
    return result
end
---@param msg SC_BattleRaceInfo
function RoomInitDataHelper:BuildMsg_SC_BattleRaceInfo(msg)
    local result = Lua_TeamInitData()
    result.TeamID = msg.position
    local carData=CarReviewData()
    carData:SetDataByMsg(msg.car)
    local cups=nil
    if msg.titlecup then
        cups = stringSplitToNumber(msg.titlecup,":")
    end
    local level=0
    if msg.curlevel then
        level = msg.curlevel
    end
    local player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(msg.rid,msg.position,nil,carData,msg.position,nil,msg.rid,msg.rolename,msg.headicon,msg.iconframe,msg.titleback,cups, level)
    table.insert(result.PlayerList, player)
    return result
end

---@param msg SC_FighterInfo
function RoomInitDataHelper:BuildMsg_SC_FighterInfo(msg,curlevel,aitype,option)
    local result = Lua_TeamInitData()
    result.TeamID = msg.position
    local player =nil

    if msg.rid<NpcMaxId then
        if msg.car then
            local carData=CarReviewData()
            carData:SetDataByMsg(msg.car)
        else
            if msg.car then
                local carData=CarReviewData()
                carData:SetDataByMsg(msg.car)
            else
                player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(msg.rid,msg.position,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,30,option,aitype)
            end
        end
    else
        local carData=CarReviewData()
        carData:SetDataByMsg(msg.car)
        local cups=nil
        if msg.titlecup then
            cups = stringSplitToNumber(msg.titlecup,":")
        end
        player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(msg.rid,msg.position,nil,carData,msg.position,nil,msg.rid,msg.rolename,msg.headicon,msg.iconframe,msg.titleback,cups,curlevel,option,aitype)
    end
    table.insert(result.PlayerList, player)
    return result
end
---@param msg SC_RacerInfo
function RoomInitDataHelper:BuildMsg_SC_RaceInfo(msg)
    local result = Lua_TeamInitData()
    result.TeamID = msg.position
    local player =nil

    
    if msg.rid>0 and msg.rid<NpcMaxId then
        if msg.car then
            local carData=CarReviewData()
            carData:SetDataByMsg(msg.car)
        else
            player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(msg.rid,msg.position)
        end
    else
        local carData= nil
        if msg.car then
            carData=CarReviewData()
            carData:SetDataByMsg(msg.car)
        end
        local carreviewdatas= nil
        if msg.cars and #msg.cars>0 then
            carreviewdatas={}
            for i = 1,#msg.cars  do
                local temp =CarReviewData()
                temp:SetDataByMsg(msg.cars[i])
                table.insert(carreviewdatas,temp)
            end
        end

        local level=msg.curlevel
        if level==nil then
            level=msg.curlev
        end
        local cups=nil
        if msg.titlecup then
            cups = stringSplitToNumber(msg.titlecup,":")
        end
        player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(msg.rid,msg.position,nil,carData,msg.position,carreviewdatas,msg.rid,msg.rolename,msg.headicon,msg.iconframe,msg.titleback,cups,level,msg.op)
    end
    table.insert(result.PlayerList, player)
    return result
end


---@param msg SC_MatchInfo
function RoomInitDataHelper:BuildMsg_SC_MatchInfo(msg,index)
    local TeamList={}
    local result = Lua_TeamInitData()
    result.TeamID = msg.loc1[1]
    local carData=CarReviewData()
    carData:SetDataByMsg(msg.car1[1])
    local cups=nil
    if msg.race1.titlecup then
        cups = stringSplitToNumber(msg.race1.titlecup,":")
    end
    local  player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(tonumber(msg.race1.rid),msg.loc1[1],nil,carData,msg.loc1[1],nil,tonumber(msg.race1.rid),msg.race1.rolename,tonumber(msg.race1.headicon),tonumber(msg.race1.iconframe),msg.race1.titleback,cups,msg.race1.level)
    table.insert(result.PlayerList, player)
    table.insert(TeamList, result)
    local result2 = Lua_TeamInitData()
    result2.TeamID =msg.loc2[1]
    local carData=CarReviewData()
    carData:SetDataByMsg(msg.car2[1])
    local cups2=nil
    if msg.race2.titlecup then
        cups2 = stringSplitToNumber(msg.race2.titlecup,":")
    end
    local  player2 = RoomInitDataHelper:BuildMsg_Player_RaceInfo(tonumber(msg.race2.rid),msg.loc2[1],nil,carData,msg.loc2[1],nil,tonumber(msg.race2.rid),msg.race2.rolename,tonumber(msg.race2.headicon),tonumber(msg.race2.iconframe),msg.race2.titleback,cups2,msg.race2.level)
    table.insert(result2.PlayerList, player2)
    table.insert(TeamList, result2)

   return TeamList
end

---@param msg SC_FighterInfo
function RoomInitDataHelper:BuildMsg_SC_JcpTest(msg,position)
    local result = Lua_TeamInitData()
    result.TeamID = position
    local player =nil
    if msg.carId and msg.carId>0 then
        local carData=CarReviewData()
        carData:SetDataByCarData(CarDataManager:Get():GetCarDataByCarID(msg.carId))
        player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(PlayerDataManager:Get():GetPlayerRID(),position,nil,carData,position,nil,PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetBgId(),PlayerDataManager:Get():GetCups(),PlayerDataManager:Get():GetPlayerLV())
    end
    if msg.carIds then
        local carIds=stringSplitToNumber(msg.carIds,":")
        local carreviewdatas={}
        for i = 1, #carIds do
            local carData=CarReviewData()
            carData:SetDataByCarData(CarDataManager:Get():GetCarDataByCarID(carIds[i]))
            table.insert(carreviewdatas,carData)
        end
        player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(PlayerDataManager:Get():GetPlayerRID(),position,nil,nil,position,carreviewdatas,PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetBgId(),PlayerDataManager:Get():GetCups(),PlayerDataManager:Get():GetPlayerLV())
    end
    table.insert(result.PlayerList, player)
    return result
end
---@param msg SC_FighterInfo
function RoomInitDataHelper:BuildMsg_SC_RaceAssembleTest(msg,position)
    local result = Lua_TeamInitData()
    result.TeamID = position
    local player =nil
    if msg.carId and msg.carId>0 then
        local carData=CarReviewData()
        carData:SetDataByCarData(CarDataManager:Get():GetCarDataByCarID(msg.carId))
        player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(PlayerDataManager:Get():GetPlayerRID(),position,nil,carData,position,nil,PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetBgId(),PlayerDataManager:Get():GetCups(),PlayerDataManager:Get():GetPlayerLV())
    end
    if msg.Car then
        local carData=CarReviewData()
        carData:SetDataByCarData(msg.Car)
        player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(PlayerDataManager:Get():GetPlayerRID(),position,nil,carData,position,nil,PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetBgId(),PlayerDataManager:Get():GetCups(),PlayerDataManager:Get():GetPlayerLV())
    end
    if msg.carIds then
        local carIds=stringSplitToNumber(msg.carIds,":")
        local carreviewdatas={}
        for i = 1, #carIds do
            local carData=CarReviewData()
            carData:SetDataByCarData(CarDataManager:Get():GetCarDataByCarID(carIds[i]))
            table.insert(carreviewdatas,carData)
        end
        player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(PlayerDataManager:Get():GetPlayerRID(),position,nil,nil,position,carreviewdatas,PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetBgId(),PlayerDataManager:Get():GetCups(),PlayerDataManager:Get():GetPlayerLV())
    end
    table.insert(result.PlayerList, player)
    return result
end
---@param msg SC_RetGuildPVEStart
function RoomInitDataHelper:BuildMsg_SC_ClubPve(msg,position)
    local result = Lua_TeamInitData()
    result.TeamID = position
    local player =nil
    local carData=CarReviewData()
    carData:SetDataByMsg(msg.cars)
    player = RoomInitDataHelper:BuildMsg_Player_RaceInfo(PlayerDataManager:Get():GetPlayerRID(),position,nil,carData,position,nil,PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetBgId(),PlayerDataManager:Get():GetCups(),msg.curlevel)
    table.insert(result.PlayerList, player)
    return result
end


---@param msg RaceHistoryData
function RoomInitDataHelper:BuildMsg_Lua_RaceRoomHistoryData(msg)
    local result = Lua_RoomInitData()

    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, msg.SceneID)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = msg.SceneID
    result.Seed = msg.Seed
    result.ProtectType=1
    result.RaceStyleType=RaceStyleType.Normal
    result.Round = msg.Round
    result.RaceFlag = 2
    result.TrackData = msg:GetTrackData()
    result.TrackType = result.TrackData.isfield and TrackType.Free or TrackType.Mini




    result.TeamList = RoomInitDataHelper:BuildMsg_SC_RcPlayerList(msg:GetPlayerList())

    result:ResetSelfPlayerID()

    return result
end
---@param msg RaceLocalData
function RoomInitDataHelper:BuildMsg_Lua_RaceLocalData(msg)
    local result = Lua_RoomInitData()

    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, msg.SceneID)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = msg.SceneID
    result.Seed = msg.Seed
    result.ProtectType=1
    result.RaceStyleType=RaceStyleType.Normal
    result.Round = msg.Round
    result.RaceFlag = 2
    result.TrackData = msg:GetTrackData()
    result.TrackType = result.TrackData.isfield and TrackType.Free or TrackType.Mini




    result.TeamList = RoomInitDataHelper:BuildMsg_Local_RcPlayerList(msg:GetPlayerList())

    result.DefaultSelectPlayerID=msg.Default

    return result
end
---@param msg RaceLocalData
function RoomInitDataHelper:BuildMsg_Lua_CustomTrackData(msg)
    local result = Lua_RoomInitData()

    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, msg.SceneID)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = msg.SceneID
    result.Seed = msg.Seed
    result.ProtectType=1
    result.RaceStyleType=RaceStyleType.Normal
    result.Round = msg.Round
    result.RaceFlag = 2
    result.TrackData = msg:GetTrackData()
    result.TrackType = result.TrackData.isfield and TrackType.Free or TrackType.Mini




     result.TeamList=RoomInitDataHelper:BuildMsg_Local_SelfPlayerList(msg.CarIdx)

    result.DefaultSelectPlayerID=msg.Default

    return result
end

function RoomInitDataHelper:BuildMsg_Lua_RaceAssembleTest(msg,ProtectType,postion)
    local result = Lua_RoomInitData()

    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, msg.scenceId)
    if cfg then result.SceneName = cfg.resName..".unity" end
    result.SceneID = msg.scenceId
    result.Seed = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    local trackData=CommonHelper:GetRacetrackData(msg.trackId)
    result.Round = trackData:GetRaceNumber()
    result.RaceFlag = 2
    if postion==nil or postion==0 then postion=math.random(1,result.Round) end
    result.ProtectType=ProtectType
    result.RaceStyleType=msg.raceStyle or RaceStyleType.Normal
    result.TrackData = trackData
    result.TrackType = result.TrackData.isfield and TrackType.Free or TrackType.Mini
    local team = RoomInitDataHelper:BuildMsg_SC_RaceAssembleTest(msg,postion)
    table.insert(result.TeamList, team)
    result.DefaultSelectPlayerID=PlayerDataManager:Get():GetPlayerRID()
    return result
end


---@param msg table<number, RaceLocalPlayerData>
function RoomInitDataHelper:BuildMsg_Local_RcPlayerList(msg)
    local result = {}

    for i = 1, #msg do
        local msgdata = msg[i]
        local teamdata = Lua_TeamInitData()
        local playerdata = Lua_PlayerInitData()
        local cardata = Lua_CarInitData()

        table.insert(result, teamdata)


        teamdata.TeamID = i
        teamdata.PlayerList[1] = playerdata

        playerdata.PlayerID = msgdata.pid
        playerdata.PlayerLevel = msgdata.level
        playerdata.Name = msgdata:GetName()
        playerdata.Icon = msgdata:GetIcon()
        playerdata.GuildName = ""
        playerdata.TrackIdx = msgdata.trackId
        playerdata.CarList[1] = cardata
        playerdata.PlayerType=PlayerType.NPC
        cardata.CarID = i
        cardata.Lightweight = 0
        cardata.Grids = {}
        cardata.Colorid = 0
        cardata.Stickerid = 0
        cardata.Attrs = msgdata:GetAttr()
        cardata.SkillIds = {130}
        if msgdata.pid < 100000000 then -- pid小于1亿 npc
            cardata.PartDataList = RoomInitDataHelper:AnalyseNpcIdToPartInfo(msgdata.pid)
            local shellInfo= RoomInitDataHelper:AnalyseNpcIdToShellInfo(msgdata.pid)
            cardata.Lightweight = shellInfo:GetLightweight()
            cardata.Grids = shellInfo:GetGrids() -- 纱网数据
            cardata.Colorid = shellInfo:GetColorid() -- 车壳染色数据zz
            cardata.Stickerid = shellInfo:GetStickerid() -- 贴纸数据
            cardata.Buffs=msgdata:GetCarReviewData():GetBuffIds()
            cardata.ShellBean=msgdata:GetCarReviewData():GetShellBean()
            cardata:AnalyseShellCfg()
        else
            local carreviewdata = msgdata:GetCarReviewData()
            cardata.PartDataList = carreviewdata:GetPartList()
            cardata.Lightweight = carreviewdata:GetLightweight()
            cardata.Grids = carreviewdata:GetGrids()
            cardata.Colorid = carreviewdata:GetColorId()
            cardata.Stickerid = carreviewdata:GetStickerid()
            cardata.CarshellCfg = carreviewdata:GetShellCfg()
        end
    end

    return result
end
---@param msg table<number, RaceLocalPlayerData>
function RoomInitDataHelper:BuildMsg_Local_SelfPlayerList(caridx)
    local result = {}

    for i = 1, 1 do
        local teamdata = Lua_TeamInitData()
        local playerdata = Lua_PlayerInitData()
        local cardata = Lua_CarInitData()

        table.insert(result, teamdata)


        teamdata.TeamID = i
        teamdata.PlayerList[1] = playerdata

        playerdata.PlayerID = PlayerDataManager:Get():GetPlayerRID()
        playerdata.PlayerLevel = PlayerDataManager:Get():GetPlayerLV()
        playerdata.Name = PlayerDataManager:Get():GetPlayerName()
        playerdata.Icon = CommonHelper:GetPlayerIconById(PlayerDataManager:Get():GetPlayerIcon())
        playerdata.GuildName = ""
        playerdata.TrackIdx = 1
        playerdata.CarList[1] = cardata

        cardata.CarID = i
        cardata.Lightweight = 0
        cardata.Grids = {}
        cardata.Colorid = 0
        cardata.Stickerid = 0
        local car=CarDataManager:Get():GetCarDataByCarID(caridx)
        cardata.Attrs = car:GetBatterAttr()
        cardata.SkillIds = {130}
        cardata.PartDataList = car:GetPartDataList()
        cardata.Lightweight = car:GetLightweight()
        cardata.Grids = car:GetShellGridList()
        cardata.Colorid = car:GetShellColor()
        cardata.Stickerid = car:GetShellSticker()
        cardata.CarshellCfg = car:GetShellCfg()
        cardata.Buffs=car:GetBuffIds()
        cardata.ShellBean=car:GetShellBean()
    end

    return result
end


function RoomInitDataHelper:Set_Data(copyid,seed,trackId,roomId)
    _copyid=copyid
    _seed=seed
    _trackId=trackId
    _roomId=roomId
end

function RoomInitDataHelper:Up_Data(playerId,raceType,carData)
    if playerId==PlayerDataManager:Get():GetPlayerRID() then
        --local carJson=carData:GetJsonData()
        --local trackTable=
        --{
        --    pve_type =raceType,
        --    copyid = _copyid,
        --    seed = _seed,
        --    trackId =_trackId,
        --    roomId = _roomId,
        --    car_data = carJson
        --}
        --QuickTa:Get():TrackEvent(TrackEventNames.FightStart,trackTable)
        RoomInitDataHelper:Set_Data(nil,nil,nil,nil)
    end
end