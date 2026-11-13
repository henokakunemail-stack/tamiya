---@class RaceClub3V3Data
RaceClub3V3Data=class("RaceClub3V3Data")
function RaceClub3V3Data:initialize()
    self.SeasonId=-1
    self.CurNum=-1
    self.MaxNum=-1
    self.TrackId={}
    self.SceneId={}
    self.BeginTime = -1
    self.EndTime = -1
    self.SelfScore = -1--个人积分
    self.GuildScore = -1--个人积分
    self.SelfAward = -1
    self.GuildAward = -1
end
---@ param data SC_ReqGuildPveInfo
function RaceClub3V3Data:SetData(data)
    self.SeasonId=data.seasonid
    self.CurNum=data.curnum
    self.MaxNum=data.maxnum
    self.TrackId=data.trackid
    self.SceneId=data.scenceid
    self.BeginTime = data.btime
    self.EndTime = data.etime
    self.SelfScore = data.personscore
    self.GuildScore = data.guildscore
    self.SelfAward = data.personaward
    self.GuildAward = data.guildaward
end
