---@class RaceFifaData
RaceFifaData = class("RaceFifaData")
---@param msg SC_RetFifaInfo
function RaceFifaData:initialize(msg)
    self.SeasonId=msg.seasonid
    self.BeginTime=msg.btime
    ---@type dictfifaseason_config_cell
    self.Cfg=CommonHelper:GetTableDataByID(ConfigNames.dictfifaseason_config,self.SeasonId)
    self.PayNumS=stringSplitToNumber(self.Cfg.paystr,":")
    self.PayId=CommonHelper:GetDictCalcData(CommonCfgKey.RaceFifaPayCost)
    local temp=stringSplitToNumber(msg.champion,":")
    self.ChampionId=temp[1]
    self.ChampionPay=temp[2]
    self.ChampionGetReward=msg.championaward
    self.ChampionTime=msg.championtimie
    self.EndTime=msg.etime
    local matchs=msg.basematchs
    ---@type RaceFifaVenueData[]
    self.KnockoutData={}
    ---@type RaceFifaVenueData[]
    self.GroupData={}
    ---@type RaceFifaVenueData[]
    self.AllRaceData={}
    for i = 1, #matchs do
        local temp=RaceFifaVenueData(matchs[i],msg.awardids,msg.matchstr)
        if temp.TeamA~=0 and temp.TeamB~=0 then
            if temp.RaceCfg.tpye==RaceFifaRaceState.RaceKnockout then
                table.insert(self.KnockoutData,temp)
            end
            if temp.RaceCfg.tpye==RaceFifaRaceState.RaceGroup then
                table.insert(self.GroupData,temp)
            end
            table.insert(self.AllRaceData,temp)
        end
    end
    table.sort(self.AllRaceData,function(a, b)
        return a.Id<b.Id
    end)
    table.sort(self.GroupData,function(a, b)
        return a.Id<b.Id
    end)
    table.sort(self.KnockoutData,function(a, b)
        return a.Id<b.Id
    end)
end
---@class RaceFifaVenueData
RaceFifaVenueData = class("RaceFifaVenueData")
---@param info string 比赛信息 1:A:1:21:1.0:2.0:0:0:0:1717568078
---@param awarids number[] 奖励的信息
---@param matchstr string[] 投注信息
function RaceFifaVenueData:initialize(info,awarids,matchstr)
    local infos=stringSplitToNumber(info,":")
    self.Id=infos[1]
    ---@type dictfifagroup_config_cell
    self.RaceCfg=CommonHelper:GetTableDataByID(ConfigNames.dictfifagroup_config,self.Id)
    self.Group=infos[2]
    self.TeamA=infos[3]
    self.TeamB=infos[4]
    self.TeamAOdds=infos[5]
    self.TeamFlatOdds=infos[6]
    self.TeamBOdds=infos[7]
    self.TeamABallCount=infos[8]
    self.TeamBBallCount=infos[9]
    self.Result=infos[10]
    self.BettingEndTime=infos[11]
    self.GetReward=0
    for i = 1, #awarids do
        if awarids[i]==self.Id then
            self.GetReward=awarids[i]
            break
        end
    end
    self.GuessTeam=0
    self.GuessPay=0
    for i = 1, #matchstr do
        local temp=stringSplitToNumber(matchstr[i],":")
        if temp[1]==self.Id then
            self.GuessTeam=temp[2]
            self.GuessPay=temp[3]
            break
        end
    end
end
