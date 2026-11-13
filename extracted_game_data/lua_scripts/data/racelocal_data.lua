--{{{赛事数据，历史记录中玩家信息
---@class RaceLocalPlayerData
RaceLocalPlayerData = class("RaceLocalPlayerData")
function RaceLocalPlayerData:initialize()
    self.pid = -1
    self.name = ""
    self.level = 0
    self.icon = ""
    self.carplanname = ""
    ---@type table<number,string>
    self.attr = {}
    ---@type CarReviewData
    self.CarReviewData = nil
    self.trackId = -1
    self.rank = -1
    self.time = -1
    self.error = -1
    self.PVPScoreOld = -1
    self.PVPScoreDelta = -1
end
---@param msg SC_RcPlayer
function RaceLocalPlayerData:SetData(npcId,trackIdx, type,index)
    self.pid = npcId
   local name,icon= CommonHelper:AnalyseNPCNameAndIconById(npcId)
    self.name = name
    self.level = 1
    self.icon = icon
    self.CarReviewData = CarReviewData()
    self.CarReviewData:SetDataByNPC(npcId)
    self.trackId = trackIdx
    self.rank = trackIdx
    --self.time = msg.time
    --self.error = msg.error
    ---@type npc_config_cell
    local npc_config_cell= CommonHelper:GetTableDataByID(ConfigNames.dictnpc_config,npcId)
    self.attr={}
    self.attr[1]=self:GetAttNum(0)
    self.attr[2]=self:GetAttNum(CarSpeedChange:GetSpeedByIndex(index))
    self.attr[3]=self:GetAttNum(CarSpeedChange:GetTorqueByIndex(index))
    self.attr[4]=self:GetAttNum(npc_config_cell.attr3)
    self.attr[5]=self:GetAttNum(npc_config_cell.attr4)
    self.attr[6]=self:GetAttNum(npc_config_cell.attr5)
    self.attr[7]=self:GetAttNum(npc_config_cell.attr6)
    self.attr[8]=self:GetAttNum(npc_config_cell.attr7)
    self.attr[9]=self:GetAttNum(npc_config_cell.attr8)
    self.attr[10]=self:GetAttNum(npc_config_cell.attr9)
    self.attr[11]=self:GetAttNum(npc_config_cell.attr10)
    self.attr[12]=self:GetAttNum(npc_config_cell.attr11)
    self.attr[13]=self:GetAttNum(npc_config_cell.attr12)
    self.attr[14]=self:GetAttNum(npc_config_cell.attr13)
    self.attr[15]=self:GetAttNum(npc_config_cell.attr14)
    self.attr[16]=self:GetAttNum(npc_config_cell.attr15)
    self.attr[17]=self:GetAttNum(npc_config_cell.attr16)
    self.attr[18]=self:GetAttNum(npc_config_cell.attr17)
    self.attr[19]=self:GetAttNum(npc_config_cell.attr18)
    self.attr[20]=self:GetAttNum(npc_config_cell.attr19)
    self.attr[21]=self:GetAttNum(npc_config_cell.attr20)
    self.attr[22]=self:GetAttNum(npc_config_cell.attr21)
    self.attr[23]=self:GetAttNum(npc_config_cell.attr22)
    self.attr[24]=self:GetAttNum(npc_config_cell.attr23)
    self.attr[25]=self:GetAttNum(0)
    self.attr[26]=self:GetAttNum(0)
    self.attr[27]=self:GetAttNum(npc_config_cell.attr26)
    self.attr[28]=self:GetAttNum(npc_config_cell.attr27)
    self.attr[29]=self:GetAttNum(npc_config_cell.attr28)
    self.attr[30]=self:GetAttNum(npc_config_cell.attr29)
    self.attr[31]=self:GetAttNum(npc_config_cell.attr30)
    self.attr[32]=self:GetAttNum(npc_config_cell.attr31)
    self.attr[33]=self:GetAttNum(0)
    self.attr[34]=self:GetAttNum(0)
    self.attr[35]=self:GetAttNum(0)
    self.attr[36]=self:GetAttNum(0)
    self.attr[37]=self:GetAttNum(0)
    self.attr[38]=self:GetAttNum(0)
    self.attr[39]=self:GetAttNum(0)
    self.attr[40]=self:GetAttNum(npc_config_cell.attr39)
    self.attr[41]=self:GetAttNum(npc_config_cell.attr40)
    self.attr[42]=self:GetAttNum(npc_config_cell.attr41)
    self.attr[43]=self:GetAttNum(npc_config_cell.attr42)
    self.attr[44]=self:GetAttNum(npc_config_cell.attr43)
    self.attr[45]=self:GetAttNum(npc_config_cell.attr44)
    self.attr[46]=self:GetAttNum(npc_config_cell.attr45)
    self.attr[47]=self:GetAttNum(npc_config_cell.attr46)
    self.attr[48]=self:GetAttNum(npc_config_cell.attr47)
    self.attr[49]=self:GetAttNum(npc_config_cell.attr48)
    self.attr[50]=self:GetAttNum(npc_config_cell.attr49)
end
---@param msg SC_RcPlayer
function RaceLocalPlayerData:SetDataNpc(npcId,trackIdx, type,index)
    self.pid = npcId
   local name,icon= CommonHelper:AnalyseNPCNameAndIconById(npcId)
    self.name = name
    self.level = 1
    self.icon = icon
    self.CarReviewData = CarReviewData()
    self.CarReviewData:SetDataByNPC(npcId)
    self.trackId = trackIdx
    self.rank = trackIdx
    --self.time = msg.time
    --self.error = msg.error
    ---@type npc_config_cell
    local npc_config_cell= CommonHelper:GetTableDataByID(ConfigNames.dictnpc_config,npcId)
    self.attr={}
    if npc_config_cell==nil then return end
    self.attr[1]=self:GetAttNum(0)
    self.attr[2]=self:GetAttNum(npc_config_cell.attr1)
    self.attr[3]=self:GetAttNum(npc_config_cell.attr2)
    self.attr[4]=self:GetAttNum(npc_config_cell.attr3)
    self.attr[5]=self:GetAttNum(npc_config_cell.attr4)
    self.attr[6]=self:GetAttNum(npc_config_cell.attr5)
    self.attr[7]=self:GetAttNum(npc_config_cell.attr6)
    self.attr[8]=self:GetAttNum(npc_config_cell.attr7)
    self.attr[9]=self:GetAttNum(npc_config_cell.attr8)
    self.attr[10]=self:GetAttNum(npc_config_cell.attr9)
    self.attr[11]=self:GetAttNum(npc_config_cell.attr10)
    self.attr[12]=self:GetAttNum(npc_config_cell.attr11)
    self.attr[13]=self:GetAttNum(npc_config_cell.attr12)
    self.attr[14]=self:GetAttNum(npc_config_cell.attr13)
    self.attr[15]=self:GetAttNum(npc_config_cell.attr14)
    self.attr[16]=self:GetAttNum(npc_config_cell.attr15)
    self.attr[17]=self:GetAttNum(npc_config_cell.attr16)
    self.attr[18]=self:GetAttNum(npc_config_cell.attr17)
    self.attr[19]=self:GetAttNum(npc_config_cell.attr18)
    self.attr[20]=self:GetAttNum(npc_config_cell.attr19)
    self.attr[21]=self:GetAttNum(npc_config_cell.attr20)
    self.attr[22]=self:GetAttNum(npc_config_cell.attr21)
    self.attr[23]=self:GetAttNum(npc_config_cell.attr22)
    self.attr[24]=self:GetAttNum(npc_config_cell.attr23)
    self.attr[25]=self:GetAttNum(0)
    self.attr[26]=self:GetAttNum(0)
    self.attr[27]=self:GetAttNum(npc_config_cell.attr26)
    self.attr[28]=self:GetAttNum(npc_config_cell.attr27)
    self.attr[29]=self:GetAttNum(npc_config_cell.attr28)
    self.attr[30]=self:GetAttNum(npc_config_cell.attr29)
    self.attr[31]=self:GetAttNum(npc_config_cell.attr30)
    self.attr[32]=self:GetAttNum(npc_config_cell.attr31)
    self.attr[33]=self:GetAttNum(0)
    self.attr[34]=self:GetAttNum(0)
    self.attr[35]=self:GetAttNum(0)
    self.attr[36]=self:GetAttNum(0)
    self.attr[37]=self:GetAttNum(0)
    self.attr[38]=self:GetAttNum(0)
    self.attr[39]=self:GetAttNum(0)
    self.attr[40]=self:GetAttNum(npc_config_cell.attr39)
    self.attr[41]=self:GetAttNum(npc_config_cell.attr40)
    self.attr[42]=self:GetAttNum(npc_config_cell.attr41)
    self.attr[43]=self:GetAttNum(npc_config_cell.attr42)
    self.attr[44]=self:GetAttNum(npc_config_cell.attr43)
    self.attr[45]=self:GetAttNum(npc_config_cell.attr44)
    self.attr[46]=self:GetAttNum(npc_config_cell.attr45)
    self.attr[47]=self:GetAttNum(npc_config_cell.attr46)
    self.attr[48]=self:GetAttNum(npc_config_cell.attr47)
    self.attr[49]=self:GetAttNum(npc_config_cell.attr48)
    self.attr[50]=self:GetAttNum(npc_config_cell.attr49)
end
function RaceLocalPlayerData:GetAttNum(num)
    return math.modf(num*1000)
end
function RaceLocalPlayerData:GetPid() return self.pid end
function RaceLocalPlayerData:GetName() return self.name end
function RaceLocalPlayerData:GetIcon() return self.icon end
function RaceLocalPlayerData:GetRank() return self.rank end
function RaceLocalPlayerData:GetClubName() return "" end
function RaceLocalPlayerData:GetTrackIdx() return self.trackId end
function RaceLocalPlayerData:GetTime() return self.time end
function RaceLocalPlayerData:GetError() return self.error end
function RaceLocalPlayerData:GetCarReviewData() return self.CarReviewData end
function RaceLocalPlayerData:GetAttr() return self.attr end
function RaceLocalPlayerData:GetShellId()
    local cfg = self.CarReviewData:GetShellCfg()
    return cfg.C_ID
end
--}}}



---@class RaceLocalData
RaceLocalData = class("RaceLocalData")
function RaceLocalData:initialize()
    self.TrackID=0
    self.Round = 0
    ---@type RaceTrackData
    self.TrackData = nil
    self.ModuleType = 0
    self.Default=0
    self.SceneID = 0
    self.Seed = 0
    ---@type table<number, RaceLocalPlayerData>
    self.PlayerList = {}
end
---@param msg startbattle_config_cell
function RaceLocalData:SetData(msg, type)
    self.TrackID = msg.trackId
    self.Round = msg.round
    self.LevelId=msg.id
    self.Seed = 1
    self.ModuleType=type
    self.SceneID = msg.sceneId
    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, msg.sceneId)
    if cfg then self.SceneName = cfg.resName..".unity" end


    self.TrackData = CommonHelper:GetRacetrackData(msg.trackId)

    self.PlayerList = {}
    local npcs =stringSplitToNumber(msg.npcs,',')
    local tracks =stringSplitToNumber(msg.track,',')
    for i = 1, #npcs do
        local data = RaceLocalPlayerData()
        data:SetData(npcs[i],tracks[i] ,self.ModuleType,i)
        table.insert(self.PlayerList, data)
    end
    table.sort(self.PlayerList,function (a, b)
        return a.rank < b.rank
    end)
    self.Default=npcs[stringSplitToNumber(msg.view,':')[1]]
end


---@param trackData RaceTrackData
function RaceLocalData:SetDataTestRun(trackData, carIdx)
    self.Round = trackData:GetRaceNumber()
    self.Seed = 1
    self.ModuleType=RaceModel.CustomTestBattle
    self.SceneID = 29000002
    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, 29000002)
    if cfg then self.SceneName = cfg.resName..".unity" end


    self.TrackData = trackData

    self.CarIdx=carIdx
    self.Default=PlayerDataManager:Get():GetPlayerRID()
end



---@param msg PVELevelBattleData
function RaceLocalData:SetDataByLevelData(id, msg,NpcId)
    self.TrackID = msg.TrackId
    self.Round = msg.Round
    self.LevelId=id
    self.NpcIdx=NpcId
    self.Seed = 1
    self.ModuleType=UIModuleID.Battle
    self.SceneID = msg.SceneId
    ---@type scene_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.scene_config, msg.SceneId)
    if cfg then self.SceneName = cfg.resName..".unity" end


    self.TrackData = CommonHelper:GetRacetrackData(msg.TrackId)

    self.PlayerList = {}

    for i = 1, #msg.NpcIds do
        local data = RaceLocalPlayerData()
        data:SetDataNpc(msg.NpcIds[i],msg.NpcTracks[i] ,self.ModuleType,i)
        if data:GetAttr() and #data:GetAttr()>0 then
            table.insert(self.PlayerList, data)
        else
            print(self.LevelId)
        end
    end
    table.sort(self.PlayerList,function (a, b)
        return a.rank < b.rank
    end)
    local has=false
    for i = 1, #msg.NpcIds do
        if msg.NpcIds[i]==NpcId then
            has=true
            break
        end
    end
    if  has==false then
        self.Default=msg.NpcIds[1]
    else
        self.Default=NpcId
    end

end

function RaceLocalData:GetPid() return self.ID end
function RaceLocalData:GetDefaultId()
    local index=1
    for i = 1, #self.PlayerList do
        if self.Default==self.PlayerList[i].pid then
            index=i
            break
        end
    end
    return index
end

function RaceLocalData:GetPlayerList() return self.PlayerList end
---@return RaceHistoryPlayerData
function RaceLocalData:GetPlayerByIdx(idx) return self.PlayerList[idx] end
function RaceLocalData:GetPlayerNum() return #self.PlayerList end
function RaceLocalData:GetTrackData() return self.TrackData end
function RaceLocalData:GetSceneName() return self.SceneName end
--}}}