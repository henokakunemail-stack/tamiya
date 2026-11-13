---@class RaceTrotData
RaceTrotData=class("RaceTrotData")
function RaceTrotData:initialize()
    self.SeasonId=-1--赛季id
    self.CurFastLve=-1 --当前段位
    self.CurScore=-1--当前积分
    self.GetScoreTime=-1--获得积分时间
    self.JoinCount=-1--当日参与次数
    self.MaxCount=-1--最大参与次数
    self.BoxId=-1--当前宝箱id
    self.BoxScore=-1--当前宝箱积分
    self.MaxBoxScore=-1--最大宝箱积分
    self.Step=-1--步骤号 0选赛道1选对手2准备
    ---@type RaceTrackData[]
    self.StandByTrackList=nil --待选赛道 步骤0时有
    self.SelectedTrack=-1--选中赛道id
    ---@type RaceTrotEnemyData[]
    self.EnemyList=nil --待选对手信息 步骤1有
    ---@type RaceTrotEnemyData
    self.SelectedFighter=nil--选中对手
    self.WinSum=-1--本赛季胜利次数
    self.ActNum=-1--本赛季总参与次数
    self.ContinueWinSum=-1--本赛季连胜次数
    self.UpMatch=-1--晋级赛次数 -1未开0开启>0参与次数 最多5次
    self.MatchWin=-1--胜利次数 5局3胜
    self.FreshTrack=-1--刷新赛道次数 通关清0
    self.FreshFighter=-1--刷新对手次数 通关清0
    self.TrackWinPercent=-1--赛道通过率
    self.SourceBoxPoint=nil --宝箱积分获取来源
    self.WatchLoc=nil --是否侦查过
end
---@ param data SC_FastMatch
function RaceTrotData:SetData(data)
    self.SeasonId=data.seasonid
    self.CurFastLve=data.curfastlve
    self.CurScore=data.curpoint
    self.GetScoreTime=data.writetime
    self.JoinCount=data.curdaynum
    self.MaxCount=data.maxdaynum
    self.BoxId=data.boxid
    self.BoxScore=data.boxpoint
    self.MaxBoxScore=data.maxboxpoint
    self.Step=data.stepno
    ---@type number[]
    self.StandByTrackList={}
    if data.standbytrack then
        for i = 1, #data.standbytrack do
            local trackData=CommonHelper:GetRacetrackData(data.standbytrack[i])
            table.insert(self.StandByTrackList,trackData)
        end
    end
    if data.selectedtrack>0 then
        self.SelectedTrack=CommonHelper:GetRacetrackData(data.selectedtrack)
    end
    if data.standbyfighter then
        ---@type RaceTrotEnemyData[]
        self.EnemyList={}
        for i = 1, #data.standbyfighter do
            local temp=RaceTrotEnemyData()
            temp:SetData(data.standbyfighter[i])
            table.insert(self.EnemyList,temp)
        end
    end

    if data.selectedFighter then
        ---@type RaceTrotEnemyData
        self.SelectedFighter=RaceTrotEnemyData()
        self.SelectedFighter:SetData(data.selectedFighter)
    end
    self.WinSum=data.winsum
    self.ActNum=data.actnum
    self.ContinueWinSum=data.continuewin
    self.UpMatch=data.upmatch
    self.MatchWin=data.matchwin
    self.FreshTrack=data.freshtrack
    self.FreshFighter=data.freshfighter
    self.TrackWinPercent=data.trackwinpercent
    self.SourceBoxPoint=data.sourceboxpoint
    self.WatchLoc=data.watchloc
end

---@class RaceTrotEnemyData
RaceTrotEnemyData=class("RaceTrotEnemyData")
function RaceTrotEnemyData:initialize()
    self.Id=-1
    self.Name=""
    self.Position=-1--跑道号
    self.FastLve=-1--段位
    self.Score=-1 --积分
    self.Car=nil --车信息
    self.Icon=-1--头像
    self.IconFrame=-1
    self.AddPoint=-1--打赢掉落积分
    self.PlayerType=PlayerType.None
end
---@ param info SC_FighterInfo
function RaceTrotEnemyData:SetData(info)
    self.Id=info.rid
    self.Car=CarReviewData()
    if self.Id<NpcMaxId then
        self.PlayerType=PlayerType.NPC
        if info.car then
            self.Car:SetDataByMsg(info.car)
        else
            self.Car:SetDataByNPC(self.Id)
        end
    else
        self.PlayerType=PlayerType.Player
        self.Car:SetDataByMsg(info.car)
    end
    self.Name=info.rolename
    self.Position=info.position
    self.FastLve=info.curfastlve
    self.Score=info.curpoint
    self.Icon=info.headicon
    self.IconFrame=info.iconframe
    self.AddPoint=info.point
    self.Watched=info.watched==1
end


