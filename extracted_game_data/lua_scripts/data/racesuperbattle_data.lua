---@class RaceSuperBattleData
RaceSuperBattleData=class("RaceSuperBattleData")
function RaceSuperBattleData:initialize()
   self.Rid=0
   self.Status=0
   self.Open=0
   self.RaceBeginTime=0
   self.RaceEndTime=0
   self.StageBeginTime=0
   self.StageEndTime=0
   self.Score=0
   self.Joined=0
   self.Cars={}
   self.TrackIds={}
   self.Scenes={}
    ---@type RaceSuperBattleMatchInfo[]
   self.MatchInfo=nil
   self.CarIds=nil
   self.BanTracks=nil
end
---@param msg SC_RetKillerInfo
function RaceSuperBattleData:SetData(msg)
    self.Rid=msg.rid
    self.Status=msg.status
    self.SeasonId=msg.seasonid
    self.Open=msg.open
    self.RaceBeginTime=msg.btime
    self.RaceEndTime=msg.etime
    self.StageBeginTime=msg.cbtime
    self.StageEndTime=msg.cetime
    self.Score=tonumber(msg.score)
    self.Joined=msg.joined
    self.Fail=msg.fail
    self.PlayerOffOpen=msg.startext==1
    self.IsUp64=msg.needext==0
    self.OverExt=msg.overext==1
    for i = 1, #msg.cars do
        local temp=CarReviewData()
        temp:SetDataByMsg(msg.cars[i])
        table.insert(self.Cars,temp)
    end
    self.TrackIds=stringSplitToNumber(msg.trackids,':')
    self.Scenes=stringSplitToNumber(msg.trackids,':')
    if msg.matchs and #msg.matchs>0 then
        self.MatchInfo={}
        local temp=RaceSuperBattleMatchInfo()
        temp:SetData(msg.matchs[1])
        for i = 1, #self.TrackIds do
            if msg.matchs[i]==nil then
                table.insert(self.MatchInfo,temp)
            else
                local temp=RaceSuperBattleMatchInfo()
                temp:SetData(msg.matchs[i])
                table.insert(self.MatchInfo,temp)
            end

        end
    end
    if msg.bantracks and #msg.bantracks>0 then
        self.BanTracks={}
        for i = 1, #msg.bantracks do
            table.insert(self.BanTracks,msg.bantracks[i])
        end
    end
    self.RaceState=msg.statustype
    ---@type dictkillerstage_config_cell
    self.RaceStateCfg=CommonHelper:GetTableDataByID(ConfigNames.dictkillerstage_config,self.Status)
    if not CommonHelper:IsNullOrEmpty(msg.carids) then
        self.CarIds= stringSplitToNumber(msg.carids,':')
    end

end

function RaceSuperBattleData:GetState()
    return self.Status
end
function RaceSuperBattleData:GetRaceState()
    return self.RaceState
end
function RaceSuperBattleData:GetRaceEndTime()
    return self.RaceEndTime
end
function RaceSuperBattleData:GetRaceBeginTime()
    return self.RaceBeginTime
end
function RaceSuperBattleData:GetStageEndTime()
    return self.StageEndTime
end
function RaceSuperBattleData:GetCarIds()
    return self.CarIds
end
function RaceSuperBattleData:GetScore()
    return self.Score
end
function RaceSuperBattleData:GetSeasonId()
    return self.SeasonId
end
---@return boolean true 失败        false 成功
function RaceSuperBattleData:GetIsFail()
    return self.Fail==1
end

function RaceSuperBattleData:OffSeason()
    return RaceSuperBattleManager:Get():IsPlayoffState(self.RaceState) and not self.PlayerOffOpen
end
function RaceSuperBattleData:IsUpKnockout()
    if RaceSuperBattleManager:Get():IsPlayoffState(self.RaceState) then
        return not self:GetIsFail() and self.IsUp64
    end
    return false
end
function RaceSuperBattleData:IsPlayoffStateOverExt()
    return  self.OverExt
end
function RaceSuperBattleData:GetMatchNum()
    return  self.RaceStateCfg.matchnum
end

function RaceSuperBattleData:GetMatchRankState()
    return  self.RaceStateCfg.matchstr
end
function RaceSuperBattleData:GetMatchAddDay()
    return  self.RaceStateCfg.addstage
end
function RaceSuperBattleData:GetGuessType()
    return  self.RaceStateCfg.guesstype
end
function RaceSuperBattleData:GetGuessNum()
    return  self.RaceStateCfg.guessnum
end
function RaceSuperBattleData:GetIsCanBanTrack()
    return  self.BanTracks==nil
end
function RaceSuperBattleData:GetMatchRacer(idx)
    if self.MatchInfo and self.MatchInfo[idx] then
        if self.MatchInfo[idx].Racer2.Rid==PlayerDataManager:Get():GetPlayerRID() then
            if self.MatchInfo[idx].Racer1.Rid<=0 then
                return  nil
            end
            return  self.MatchInfo[idx].Racer1
        end
        if self.MatchInfo[idx].Racer1.Rid==PlayerDataManager:Get():GetPlayerRID() then
            if self.MatchInfo[idx].Racer2.Rid<=0 then
                return  nil
            end
            return  self.MatchInfo[idx].Racer2
        end
        return  nil
    end
    return  nil
end











---@class RaceSuperBattleMatchInfo
RaceSuperBattleMatchInfo=class("RaceSuperBattleMatchInfo")
function RaceSuperBattleMatchInfo:initialize()
    ---@type RaceSuperBattleRacerInfo
    self.Racer1=nil
    ---@type RaceSuperBattleRacerInfo
    self.Racer2=nil
    self.MatchRank=0
end
---@param param SC_MatchInfo
function RaceSuperBattleMatchInfo:SetData(param)
     self.Racer1=RaceSuperBattleRacerInfo()
     self.Racer2=RaceSuperBattleRacerInfo()
     local race1Result={}
    local count1=0
    local count2=0
    for i = 1, #param.winlose do
        race1Result[i]=tonumber(param.winlose[i])==1
        if race1Result[i] then
          count1=count1+1
        end
     end
     local race2Result={}
     for i = 1, #param.winlose do
        race2Result[i]=tonumber(param.winlose[i])==2
         if race2Result[i] then
             count2=count2+1
         end
     end
     self.Racer1:SetData(param.car1,race1Result,param.time1,param.race1)
     self.Racer2:SetData(param.car2,race2Result,param.time2,param.race2)
    if count1>count2 then
        self.Winner=self.Racer1.Rid
    elseif count1<count2 then
        self.Winner=self.Racer2.Rid
    else
        self.Winner=0
    end
    self.MatchRank=tonumber(param.matchstr)
    self.MatchId=tonumber(param.matchid)

end
function RaceSuperBattleMatchInfo:GetWinnerInfo()
    if self.Winner==self.Racer1.Rid then
        return self.Racer1
    end
    if self.Winner==self.Racer2.Rid then
        return self.Racer2
    end
    return nil
end



---@class RaceSuperBattleRacerInfo
RaceSuperBattleRacerInfo=class("RaceSuperBattleRacerInfo")
function RaceSuperBattleRacerInfo:initialize()
    self.Rid=0
    self.Name=""
    self.GuideName=""
    self.Score=0
    self.HeadIcon=0
    self.Lv=0
    self.IconFrame=0
    ---@type CarReviewData[]
    self.Cars=nil
    self.Results=nil
    self.Times=nil
end
---@param car SC_UserCar
---@param info SC_RacerInfo
function RaceSuperBattleRacerInfo:SetData(cars,result,time,info)
    ---@type CarReviewData[]
    self.Cars={}
    for i = 1, #cars do
        local temp=CarReviewData()
        temp:SetDataByMsg(cars[i])
        table.insert(self.Cars,temp)
    end
    self.Results=result
    self.Times={}
    for i = 1, #time do
        self.Times[i]=tonumber(time[i])
    end
    if info then
        self.Rid=tonumber(info.rid)
        self.Name=info.rolename
        self.Score=tonumber(info.score)
        self.HeadIcon=tonumber(info.headicon)
        self.IconFrame=tonumber(info.iconframe)
    end
end

