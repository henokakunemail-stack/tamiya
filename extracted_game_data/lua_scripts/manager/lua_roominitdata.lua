


---@class CS_RoomInitData
---@field teamsData
---@field sceneName
---@field mapId
---@field resName
---@field startNum
---@field endNum
---@field round
---@field raceType
---@field trackType





---@class Lua_RoomInitData
Lua_RoomInitData = class("Lua_RoomInitData")

function Lua_RoomInitData:initialize()
    self.LevelId = -1
    self.SelfCarId = -1
    self.SceneID = -1
    self.SceneName = ".unity" -- 场景资源名
    ---@type RaceTrackData
    self.TrackData = nil
    self.RaceFlag = 1 -- 比赛类型（C#侧使用，1 PVE, 2 PVP）
    self.TrackType = 1 -- 赛道类型（C#侧使用，1 野外, 2 制式)
    self.CupShow = 1 -- 是否展示奖杯
    self.ProtectType = 0 -- 0： 不触发保护， 1：玩家自己触发保护，2：玩家自己和npc都触发保护
    self.supportAutoRecoverType = 0 --
    self.RaceStyleType = RaceStyleType.Normal -- 0： 正常 1 接力 2 限时 3 接力加限时
    self.CountDownDuration = 0 --倒计时
    self.DefaultSelectPlayerID = PlayerDataManager:Get():GetPlayerRID() -- 自己的uid
    self.StartNum = -1
    self.EndNum = -1
    self.Round = -1
    self.IsCustomTrack = false
    self.Seed = 0
    self.StartTime = 0
    self.IsSupportSpeedUp = false

    ---@type table<number, Lua_TeamInitData>
    self.TeamList = {}

    ---不需要赋值的字段
    self.mapid = 0
    self.room_id = 1
    self.room_ip = "192.168.1.101"
    self.room_port = 1
    self.frame_time_length = 33
end
function Lua_RoomInitData:ResetSelfPlayerID()
    local isReset = true
    local default = -1
    for i = 1, #self.TeamList do
        local team = self.TeamList[i]
        for m = 1, #team.PlayerList do
            local player = team.PlayerList[m]
            if default == -1 then default = player.PlayerID
            end
            if player.PlayerID == self.DefaultSelectPlayerID then
                isReset = false
                break
            end
        end
    end

    if isReset then
        self.DefaultSelectPlayerID = default
    end
end
function Lua_RoomInitData:SetTrackData(trackid, trackinfo)
    self.TrackData = CommonHelper:GetRacetrackData(trackid, trackinfo)
end
function Lua_RoomInitData:GetPlayerCount()
    local count = 0
    for i = 1, #self.TeamList do
        local team = self.TeamList[i]
        count = count + #team.PlayerList
    end
    return count
end
function Lua_RoomInitData:SetStartTime(starttime)
    self.StartTime=starttime
end
function Lua_RoomInitData:SetSupportSpeedUp(value)
    self.IsSupportSpeedUp=value
    self.IsSupportSpeedUp = false
end



---@class Lua_TeamInitData
Lua_TeamInitData = class("Lua_TeamInitData")

function Lua_TeamInitData:initialize()
    self.TeamID = -1

    ---@type table<number, Lua_PlayerInitData>
    self.PlayerList = {}
end


---@class Lua_PlayerInitData
Lua_PlayerInitData = class("Lua_PlayerInitData")

function Lua_PlayerInitData:initialize()
    self.PlayerID = -1
    self.PlayerType = PlayerType.None
    self.Icon = ""
    self.PlayerLevel = 0
    self.IconFrame = ""
    self.PlayerBgId=0
    self.Cups={}
    self.Name = ""
    self.GuildName = ""
    self.TrackIdx = -1
    self.operate = ""
    self.enableAIType = 0

    ---@type table<number, Lua_CarInitData>
    self.CarList = {}
end


---@class Lua_CarInitData
Lua_CarInitData = class("Lua_CarInitData")

function Lua_CarInitData:initialize()
    self.CarID = -1

    self.CarCfgId=-1
    ---@type table<number, Lua_PartData>
    self.PartDataList = {}

    self.Lightweight = 0 -- 玩家轻量化数据
    self.Grids = {} -- 玩家纱网数据
    self.Colorid = 0 -- 玩家车壳染色数据
    self.Stickerid = 0 -- 玩家贴纸数据

    ---@type dictpartcell_config_cell
    self.CarshellCfg = nil

    ---@type number[]
    self.Buffs = {}
    self.ShellBean=0
    ---@type table<number,string>
    self.Attrs = nil
   ---@type table<number,number>
    self.SkillIds = nil
end
function Lua_CarInitData:AnalyseShellCfg()
    local idx = AssembleHelper:GrooveIDToMsgIdx(PartGrooveID.Shell)
    if self.PartDataList and self.PartDataList[idx] then
        local temp = self.PartDataList[idx]
        if temp and temp.PartCfgID > 0 then
            ---@type dictparts_config_cell
            local partcfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, temp.PartCfgID)
            if partcfg then
                ---@type dictpartbase_config_cell
                local partBaseCfg = CommonHelper:GetTableDataByID(ConfigNames.dictpartbase_config, partcfg.baseid)
                self.CarshellCfg = CommonHelper:GetTableDataByID(ConfigNames.dictpartcell_config, partBaseCfg.NewShellId)
                return partBaseCfg
            end
        end
    end
    return nil
end

---@class Lua_PartData
Lua_PartData = class("Lua_PartData")

function Lua_PartData:initialize()
    self.PartCfgID = -1
    self.PartOrgCfgID = -1
    self.ComposeIds = {}
    self.PartQuality = -1
    self.PartStar = -1
    self.PartGeneration=-1
    self.PartLevel=-1
    self.sticker=0
end

function Lua_PartData:SetData(id, list, quality,generation,lv,orgCfgId,sticker)
    if list == nil then list = {}  end

    self.PartCfgID = id
    self.PartOrgCfgID=orgCfgId
    self.ComposeIds = list
    self.PartQuality = quality
    self.PartStar = 1
    self.PartLevel=lv
    self.sticker=sticker
    self.PartGeneration=generation
    if list == nil or #list == 0 then
        if id and id > 0 then
            ---@type dictparts_config_cell
            local cfg = CommonHelper:GetTableDataByID(ConfigNames.parts_config, id)
            if cfg then
                if cfg.composeids ~= "-1" then
                    self.ComposeIds = cfg.NewComposeIDs
                end
            end
        end
    end
end

---@class Lua_ShellInfoData
Lua_ShellInfoData = class("Lua_ShellInfoData")

function Lua_ShellInfoData:initialize()
    self.Lightweight = {true,true,true,true,true}  -- 轻量化数据
    self.Grids = {} -- 纱网数据
    self.Colorid = 0 -- 车壳染色数据
    self.Stickerid = 0 -- 贴纸数据
end

---@param id number npcShowId
function Lua_ShellInfoData:SetData(id)
    if id<=0 or id==nil then
        return
    end
    ---@type npcshow_config_cell
    local npcshowcell= CommonHelper:GetTableDataByID(ConfigNames.npcshow_config,id)
    self.Lightweight ={}
    local temp= stringSplitToNumber(npcshowcell.shellhole,',')
    for i = 1, #temp do
        self.Lightweight[i] =temp[i]==1
    end
    --npcshowcell.shellhole ~=-1 and npcshowcell.shellhole or 0
    self.Grids = npcshowcell.gauce ~="-1" and stringSplitToNumber(npcshowcell.gauce,',') or {} -- 纱网数据
    self.Colorid = npcshowcell.paint ~=-1 and npcshowcell.paint or 0-- 车壳染色数据
    self.Stickerid = npcshowcell.sticker~=-1 and  npcshowcell.sticker or 0-- 贴纸数据
end
function Lua_ShellInfoData:GetLightweight() return self.Lightweight end
function Lua_ShellInfoData:GetGrids() return self.Grids end
function Lua_ShellInfoData:GetColorid() return self.Colorid end
function Lua_ShellInfoData:GetStickerid() return self.Stickerid end