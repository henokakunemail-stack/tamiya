---@class RaceGVGData
RaceGVGData=class("RaceGVGData")
function RaceGVGData:initialize()
    self.Rid=0
    self.CurNum = 0
    self.TrackId = 0
    self.State = 0 --1报名阶段 2分组时间 3 1阶段比赛时间 4 1阶段结算时间 5 2阶段比赛时间 6 2阶段结算时间 7 3阶段比赛时间 8 3阶段结算时间  9 最终结算阶段
    self.OpenSate = 0 --0未开启1开启
    self.BeginTime = 0--开始时间
    self.EndTime = 0--结算结束时间
    self.CBeginTime = 0--当前阶段开始时间
    self.CEndTime = 0--当前阶段结束时间
    self.SceneId=0
    self.Score = 0--我的成绩
    self.FastTime =0 --
    self.SeasonId =0
    self.MaxNum = 0--最大次数
    self.GuildId = 0
    self.GuildName = 0
    self.GuildIcon = 0
    self.GuildScore = 0
    self.FGuildId = 0
    self.FGuildName = 0
    self.FGuildIcon = 0
    self.FGuildScore = 0
    self.CanJoin=0
    self.MatchSuccess=0
end
---@param msg SC_RetGvgPointInfo
function RaceGVGData:SetData(msg)
    self.Rid=msg.rid
    self.CurNum=msg.curnum
    self.TrackId=msg.trackid
    self.TrackData=CommonHelper:GetRacetrackData(self.TrackId)
    self.State=msg.status
    self.OpenSate=msg.open
    self.BeginTime=msg.btime
    self.EndTime = msg.etime
    self.CBeginTime = msg.cbtime
    self.CEndTime = msg.cetime
    self.SceneId=msg.scenceid
    self.Score = msg.score
    self.FastTime =msg.fasttime
    self.SeasonId =msg.seasonid
    self.MaxNum = msg.maxnum
    if not CommonHelper:IsNullOrEmpty(msg.guildid) then self.GuildId = tonumber(msg.guildid) end
    if not CommonHelper:IsNullOrEmpty(msg.guildname) then self.GuildName = msg.guildname end
    if not CommonHelper:IsNullOrEmpty(msg.guildicon) then self.GuildIcon = tonumber(msg.guildicon) end
    if not CommonHelper:IsNullOrEmpty(msg.guildscore) then self.GuildScore = tonumber(msg.guildscore) end
    if not CommonHelper:IsNullOrEmpty(msg.fguildid) then self.FGuildId = tonumber(msg.fguildid) end
    if not CommonHelper:IsNullOrEmpty(msg.fguildname) then self.FGuildName = msg.fguildname end
    if not CommonHelper:IsNullOrEmpty(msg.fguildicon) then self.FGuildIcon = tonumber(msg.fguildicon) end
    if not CommonHelper:IsNullOrEmpty(msg.fguildscore) then self.FGuildScore = tonumber(msg.fguildscore) end
    self.CanJoin=msg.canjoin
    self.MatchSuccess=msg.inx
end