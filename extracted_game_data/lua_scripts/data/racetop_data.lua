---@class RaceTopData
RaceTopData=class("RaceTopData")
function RaceTopData:initialize()

end
---@ param data SC_RetTopInfo
function RaceTopData:SetData(data)
    self.Rid=data.rid
    self.CurNum = data.curnum
    if data.trackid>0 then
        self.TrackId = data.trackid
        self.TrackData=CommonHelper:GetRacetrackData(self.TrackId)
    else
        self.TrackData=nil
    end
    self.SceneId = data.scenceid
    self.MaxNum=data.maxnum
    self.SeasonId=data.seasonid
    self.CanJoin=data.canjoin
    self.Status = data.status--1外围赛 2选32强过程 3 32强比赛 4选16过程 5 16强比赛 6选8过程 7 8强比赛 8 选4过程 9 4强比赛 10 选2过程 11 最强比赛 12 选择最强  13 b级赛
    self.OpenState = data.open--0未开启1开启
    self.RaceStartTime=data.btime
    self.RaceEndTime=data.etime
    self.StateStartTime=data.cbtime
    self.StateEndTime=data.cetime
    if data.firstRacer then
        self.FirstRacer=RaceTopFirstPlayerInfo()
        self.FirstRacer:SetData(data.firstRacer)
    end
    if CommonHelper:IsNullOrEmpty(data.score) then
        self.SelfScore=0
    else
        self.SelfScore=tonumber(data.score)
    end
end

---@class RaceTopFirstPlayerInfo
RaceTopFirstPlayerInfo=class("RaceTopFirstPlayerInfo")
function RaceTopFirstPlayerInfo:initialize()

end
---@ param data SC_RaceInfo
function RaceTopFirstPlayerInfo:SetData(data)
    self.Time=data.score
    self.Name=data.rolename
    self.HeadIcon=data.headicon
    self.IconFrame=data.iconframe
end

---@class RaceTopGroupInfo
RaceTopGroupInfo=class("RaceTopGroupInfo")
function RaceTopGroupInfo:initialize()

end
---@ param data SC_TopFight
function RaceTopGroupInfo:SetData(data)
    self.Rid = data.rid
    self.RoleName = data.rolename
    self.IconFrame = tonumber(data.iconframe)
    self.HeadIcon = tonumber(data.headicon)
    self.Time = data.time
    self.GoodNum=data.agree
    self.IsGood=false

    self.FRid = data.frid
    self.FRoleName = data.frolename
    self.FIconFrame = tonumber(data.ficonframe)
    self.FHeadIcon = tonumber(data.fheadicon)
    self.FTime = data.ftime
    self.FGoodNum=data.fagree
    self.FIsGood=false
    self.Round =data.round  -- 阶段
    self.WinLose = data.winlost  --1 rid 赢  2 f赢
end
---@class RaceTopGroup
RaceTopGroup=class("RaceTopGroup")
function RaceTopGroup:initialize()

end
---@ param data SC_TopFightRanks
function RaceTopGroup:SetData(msg)
    if CommonHelper:IsNullOrEmpty(msg.agreerid) then
        self.AgreeId=0
    else
        self.AgreeId=tonumber(msg.agreerid)
    end
    local data=msg.ranks
    self.SeasonId=data.seasonid
    self.CurStatus=data.curstatus
    self.GoodList={}
    for i = 1, #msg.rids do
        self.GoodList[msg.rids[i]]=msg.ticks[i]
    end
    self.CanAgree=false
    if data.list32 and #data.list32>0 then
        self.List32={}
        self.CanAgree=true
        for i = 1, #data.list32 do
            local temp=RaceTopGroupInfo()
            temp:SetData(data.list32[i])
            table.insert(self.List32,temp)
        end
    end
    if data.list16 and #data.list16>0 then
        self.List16={}
        self.CanAgree=false
        for i = 1, #data.list16 do
            local temp=RaceTopGroupInfo()
            temp:SetData(data.list16[i])
            table.insert(self.List16,temp)
        end
    end
    if data.list8 and #data.list8>0 then
        self.List8={}
        self.CanAgree=false
        for i = 1, #data.list8 do
            local temp=RaceTopGroupInfo()
            temp:SetData(data.list8[i])
            table.insert(self.List8,temp)
        end
    end
    if data.list4 and #data.list4>0 then
        self.List4={}
        self.CanAgree=false
        for i = 1, #data.list4 do
            local temp=RaceTopGroupInfo()
            temp:SetData(data.list4[i])
            table.insert(self.List4,temp)
        end
    end
    if data.list2 and #data.list2>0 then
        self.List2={}
        self.CanAgree=false
        for i = 1, #data.list2 do
            local temp=RaceTopGroupInfo()
            temp:SetData(data.list2[i])
            table.insert(self.List2,temp)
        end
    end


end




