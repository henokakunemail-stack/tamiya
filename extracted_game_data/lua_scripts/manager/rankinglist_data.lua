---@class RankingListData
RankingListData=class("RankingListData")
function RankingListData:initialize()
    self.type = -1
    ---@type RankingData[]
    self.RankInfoList = nil
    self.SelfData=nil
end

---@param param SC_RetRank
function RankingListData:SetData(param)
    self.type=param.ranktype
    self.RankInfoList={}
    if self.type==RankingListType.Speed then
        if not CommonHelper:IsNullOrEmpty(param.rankjson) then
            local ranks = Dll_JSON.decode(param.rankjson)
            for i = 1, #ranks do
                local data=RankingData()
                data:SetRankScoreData(ranks[i][1],ranks[i][2],ranks[i][3],ranks[i][4],ranks[i][5],ranks[i][6],ranks[i][7],ranks[i][8],ranks[i][9])
                table.insert(self.RankInfoList,data)
            end
        else
           -- CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RankingListNone))
        end
        self.SelfData=RankingData()
        self.SelfData:SetRankSpeedData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),param.score,param.rankid,param.point)
    end
    if self.type==RankingListType.Score then
        if not CommonHelper:IsNullOrEmpty(param.rankjson) then
            local ranks =  Dll_JSON.decode(param.rankjson)
            for i = 1, #ranks do
                local data=RankingData()
                data:SetRankScoreData(ranks[i][1],ranks[i][2],ranks[i][3],ranks[i][4],ranks[i][5],ranks[i][6],ranks[i][8],ranks[i][9],i,nil,nil,ranks[i][9])
                table.insert(self.RankInfoList,data)
            end
        else
           -- CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RankingListNone))
        end
        self.SelfData=RankingData()
        self.SelfData:SetRankScoreData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),param.myrankgroup,param.score,param.score,param.rankid,nil,nil,param.point)
    end
    if self.type==RankingListType.MainClub then
        for i = 1, #param.guildInfo.guildlist do
             local data=RankingData()
             data:SetGuideData(param.guildInfo.guildlist[i],i)
             table.insert(self.RankInfoList,data)
        end
    end
    if self.type==RankingListType.MainSpeed then
        if not CommonHelper:IsNullOrEmpty(param.rankjson) then
            local ranks = Dll_JSON.decode(param.rankjson)
            for i = 1, #ranks do
                local data=RankingData()
                data:SetRankScoreData(ranks[i][1],ranks[i][2],ranks[i][3],ranks[i][4],ranks[i][5],ranks[i][6],ranks[i][7],ranks[i][8],ranks[i][9])
                table.insert(self.RankInfoList,data)
            end
        else
           -- CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RankingListNone))
        end
        self.SelfData=RankingData()
        self.SelfData:SetRankSpeedData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),param.score,param.rankid,param.point)
    end
    if self.type==RankingListType.MainRlSpeed then
        if not CommonHelper:IsNullOrEmpty(param.rankjson) then
            local ranks = Dll_JSON.decode(param.rankjson)
            for i = 1, #ranks do
                local data=RankingData()
                data:SetRankScoreData(ranks[i][1],ranks[i][2],ranks[i][3],ranks[i][4],ranks[i][5],ranks[i][6],ranks[i][7],ranks[i][8],ranks[i][9])
                table.insert(self.RankInfoList,data)
            end
        else
           -- CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RankingListNone))
        end
        self.SelfData=RankingData()
        self.SelfData:SetRankSpeedData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),param.score,param.rankid,param.point)
    end
    if self.type==RankingListType.RaceJCP then
        if not CommonHelper:IsNullOrEmpty(param.rankjson) then
            local ranks = Dll_JSON.decode(param.rankjson)
            for i = 1, #ranks do
                local data=RankingData()
                data:SetRankScoreData(ranks[i][1],ranks[i][2],ranks[i][3],ranks[i][4],ranks[i][5],ranks[i][6],ranks[i][7],ranks[i][8],ranks[i][9])
                table.insert(self.RankInfoList,data)
            end
        else
           -- CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RankingListNone))
        end
        self.SelfData=RankingData()
        self.SelfData:SetRankSpeedData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),param.score,param.rankid,param.point)
    end
    if self.type==RankingListType.RaceXCP then
        if not CommonHelper:IsNullOrEmpty(param.rankjson) then
            local ranks = Dll_JSON.decode(param.rankjson)
            for i = 1, #ranks do
                local data=RankingData()
                data:SetRankScoreData(ranks[i][1],ranks[i][2],ranks[i][3],ranks[i][4],ranks[i][5],0,0,ranks[i][8],ranks[i][9])
                table.insert(self.RankInfoList,data)
            end
        else
           -- CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RankingListNone))
        end
        self.SelfData=RankingData()
        self.SelfData:SetRankSpeedData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),param.score,param.rankid,param.point)
    end
    if self.type==RankingListType.RlSpeed then
        if not CommonHelper:IsNullOrEmpty(param.rankjson) then
            local ranks = Dll_JSON.decode(param.rankjson)
            for i = 1, #ranks do
                local data=RankingData()
                data:SetRankScoreData(ranks[i][1],ranks[i][2],ranks[i][3],ranks[i][4],ranks[i][5],ranks[i][6],ranks[i][7],ranks[i][8],ranks[i][9])
                table.insert(self.RankInfoList,data)
            end
        else
            -- CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RankingListNone))
        end
        self.SelfData=RankingData()
        self.SelfData:SetRankSpeedData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),param.score,param.rankid,param.point)
    end
    if self.type==RankingListType.ChallengeMatch then
        if not CommonHelper:IsNullOrEmpty(param.rankjson) then
            local ranks = Dll_JSON.decode(param.rankjson)
            for i = 1, #ranks do
                local data=RankingData()
                data:SetRankScoreData(ranks[i][1],ranks[i][2],ranks[i][3],ranks[i][4],ranks[i][5],0,0,ranks[i][6],ranks[i][7])
                table.insert(self.RankInfoList,data)
            end
        else
            --CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RankingListNone))
        end
        self.SelfData=RankingData()
        self.SelfData:SetRankSpeedData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),param.score,param.rankid,0,0)
    end
    if self.type==RankingListType.RaceAssemble then
        if not CommonHelper:IsNullOrEmpty(param.rankjson) then
            local ranks = Dll_JSON.decode(param.rankjson)
            for i = 1, #ranks do
                local data=RankingData()
                data:SetRankScoreData(ranks[i][1],ranks[i][2],ranks[i][3],ranks[i][4],ranks[i][5],0,0,ranks[i][6],ranks[i][7])
                table.insert(self.RankInfoList,data)
            end
        else
            --CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RankingListNone))
        end
        self.SelfData=RankingData()
        self.SelfData:SetRankSpeedData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),param.score,param.rankid,0,0)
    end
    if self.type==RankingListType.RaceTrot then
        if not CommonHelper:IsNullOrEmpty(param.rankjson) then
            local ranks = Dll_JSON.decode(param.rankjson)
            for i = 1, #ranks do
                local data=RankingData()
                data:SetRankScoreData(ranks[i][1],ranks[i][2],ranks[i][3],ranks[i][4],ranks[i][5],ranks[i][6],ranks[i][8],ranks[i][8],ranks[i][9])
                table.insert(self.RankInfoList,data)
            end
        else
            --CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RankingListNone))
        end
        self.SelfData=RankingData()
        self.SelfData:SetRankScoreData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),0,param.score,param.score,param.rankid)
    end
    if self.type==RankingListType.RaceTopA then
        if not CommonHelper:IsNullOrEmpty(param.rankjson) then
            local ranks =  Dll_JSON.decode(param.rankjson)
            for i = 1, #ranks do
                local data=RankingData()
                data:SetRankScoreData(ranks[i][1],ranks[i][2],ranks[i][3],ranks[i][4],ranks[i][5],ranks[i][6],ranks[i][8],ranks[i][8],ranks[i][9])
                table.insert(self.RankInfoList,data)
            end
        else
            -- CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RankingListNone))
        end
        self.SelfData=RankingData()
        self.SelfData:SetRankSpeedData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),param.score,param.rankid,param.score)
    end
 if self.type==RankingListType.RaceTopSuperA then
        if not CommonHelper:IsNullOrEmpty(param.rankjson) then
            local ranks =  Dll_JSON.decode(param.rankjson)
            for i = 1, #ranks do
                local data=RankingData()
                data:SetRankScoreData(ranks[i][1],ranks[i][2],ranks[i][3],ranks[i][4],ranks[i][5],ranks[i][6],ranks[i][8],ranks[i][8],ranks[i][9])
                table.insert(self.RankInfoList,data)
            end
        else
            -- CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RankingListNone))
        end
        self.SelfData=RankingData()
        self.SelfData:SetRankSpeedData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),param.score,param.rankid,param.score)
    end
    if self.type==RankingListType.RaceTopB then
        if not CommonHelper:IsNullOrEmpty(param.rankjson) then
            local ranks =  Dll_JSON.decode(param.rankjson)
            for i = 1, #ranks do
                local data=RankingData()
                data:SetRankScoreData(ranks[i][1],ranks[i][2],ranks[i][3],ranks[i][4],ranks[i][5],ranks[i][6],ranks[i][8],ranks[i][8],ranks[i][9])
                table.insert(self.RankInfoList,data)
            end
        else
            -- CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RankingListNone))
        end
        self.SelfData=RankingData()
        self.SelfData:SetRankSpeedData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),param.score,param.rankid,param.score)
    end
 if self.type==RankingListType.RaceTopSuperB then
        if not CommonHelper:IsNullOrEmpty(param.rankjson) then
            local ranks =  Dll_JSON.decode(param.rankjson)
            for i = 1, #ranks do
                local data=RankingData()
                data:SetRankScoreData(ranks[i][1],ranks[i][2],ranks[i][3],ranks[i][4],ranks[i][5],ranks[i][6],ranks[i][8],ranks[i][8],ranks[i][9])
                table.insert(self.RankInfoList,data)
            end
        else
            -- CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RankingListNone))
        end
        self.SelfData=RankingData()
        self.SelfData:SetRankSpeedData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),param.score,param.rankid,param.score)
    end
    if self.type==RankingListType.RaceGVGSpeed2 or self.type==RankingListType.RaceGVGSpeed1 or self.type==RankingListType.RaceGVGSpeed3 then
        ---@type SC_GvgPointRanks
        local data =param
        if data.ranks then
            for i = 1, #data.ranks.userranks do
                local temp=data.ranks.userranks[i]
                local rankData=RankingData()
                rankData:SetRankScoreData(temp.rid,temp.rolename,temp.headicon,temp.iconframe,1,1,temp.point,temp.speed,i,temp.guildname,temp.guildid)
                table.insert(self.RankInfoList,rankData)
                if temp.rid==PlayerDataManager:Get():GetPlayerRID() then
                    self.SelfData=rankData
                end
            end
            if self.SelfData==nil then
                self.SelfData=RankingData()
                self.SelfData:SetRankScoreData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                        PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),0,0,0,0,PlayerDataManager:Get():GetGuildName(),PlayerDataManager:Get():GetGuildId())

            end
        else
            self.SelfData=RankingData()
            self.SelfData:SetRankScoreData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                    PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),0,0,0,0,PlayerDataManager:Get():GetGuildName(),PlayerDataManager:Get():GetGuildId())

        end
    end
    if self.type==RankingListType.RaceGVGPoint then
        ---@type SC_GvgPointRank
        local data =param
        if data.ranks then
            for i = 1, #data.ranks.userranks do
                local temp=data.ranks.userranks[i]
                local rankData=RankingData()
                rankData:SetRankScoreData(temp.rid,temp.rolename,temp.headicon,temp.iconframe,1,1,temp.point,0,temp.rankid,temp.guildname,temp.guildid)
                table.insert(self.RankInfoList,rankData)
                if temp.rid==PlayerDataManager:Get():GetPlayerRID() then
                    self.SelfData=rankData
                end
            end
            if self.SelfData==nil then
                self.SelfData=RankingData()
                self.SelfData:SetRankScoreData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                        PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),0,0,0,0,PlayerDataManager:Get():GetGuildName(),PlayerDataManager:Get():GetGuildId())

            end
        else
            self.SelfData=RankingData()
            self.SelfData:SetRankScoreData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                    PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),0,0,0,0,PlayerDataManager:Get():GetGuildName(),PlayerDataManager:Get():GetGuildId())
        end

    end
    if self.type==RankingListType.RaceSuperBattlePlayerOffPoint then
        ---@type SC_GvgPointRank
        local data =param
        local score=0
        local rank=0
        if data.rankjson then
            if not CommonHelper:IsNullOrEmpty(param.rankjson) then
                local ranks =  Dll_JSON.decode(param.rankjson)
                for i = 1, #ranks do
                    local data=RankingData()
                    data:SetRankSpeedData(ranks[i][1],ranks[i][2],ranks[i][3],ranks[i][4],0,ranks[i][5],i,0,0)
                    if data.Id==PlayerDataManager:Get():GetPlayerRID() then
                        score=data.Score
                        rank=i
                    end
                    table.insert(self.RankInfoList,data)
                end
            else
                -- CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RankingListNone))
            end
            if self.SelfData==nil then
                self.SelfData=RankingData()
                self.SelfData:SetRankSpeedData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                        PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),score,rank,0,0,PlayerDataManager:Get():GetGuildName(),PlayerDataManager:Get():GetGuildId())

            end
        else
            self.SelfData=RankingData()
            self.SelfData:SetRankSpeedData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                    PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),0,0,0,0,PlayerDataManager:Get():GetGuildName(),PlayerDataManager:Get():GetGuildId())
        end

    end
    if self.type==RankingListType.PveChapter then
        if not CommonHelper:IsNullOrEmpty(param.rankjson) then
            local ranks = Dll_JSON.decode(param.rankjson)
            for i = 1, #ranks do
                local data=RankingData()
                data:SetRankScoreData(ranks[i][1],ranks[i][2],ranks[i][3],ranks[i][4],ranks[i][5],ranks[i][6],ranks[i][7],ranks[i][8],ranks[i][9])
                table.insert(self.RankInfoList,data)
            end
        else
            -- CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RankingListNone))
        end
        self.SelfData=RankingData()
        self.SelfData:SetRankSpeedData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),param.score,param.rankid,param.point)
    end
    if self.type==RankingListType.SpecialTraining then
        if not CommonHelper:IsNullOrEmpty(param.rankjson) then
            local ranks = Dll_JSON.decode(param.rankjson)
            for i = 1, #ranks do
                local data=RankingData()
                data:SetRankScoreData(ranks[i][1],ranks[i][2],ranks[i][3],ranks[i][4],ranks[i][5],ranks[i][6],ranks[i][7],ranks[i][8],ranks[i][9])
                table.insert(self.RankInfoList,data)
            end
        else
            -- CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RankingListNone))
        end
        self.SelfData=RankingData()
        self.SelfData:SetRankSpeedData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),param.score,param.rankid,param.point)
    end
    if self.type==RankingListType.RaceClubAll then
        if not CommonHelper:IsNullOrEmpty(param.infos) then
            local ranks = Dll_JSON.decode(param.infos)
            for i = 1, #ranks do
                local data=RankingData()
                --俱乐部id  俱乐部名字 积分  参加人数  经验需要转等级  会长名 俱乐部图标
                data:SetGuideDataPoint(ranks[i][1],ranks[i][2],ranks[i][3],ranks[i][4],ranks[i][6],ranks[i][7],ranks[i][8],ranks[i][9],ranks[i][5])
                table.insert(self.RankInfoList,data)
            end
        else
            -- CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RankingListNone))
        end
    end
    if self.type==RankingListType.RaceSuperBattlePoint then
        ---@type SC_RetRank
        local data =param
        local score=data.score
        local rank=data.rankid
        if data.rankjson then
            if not CommonHelper:IsNullOrEmpty(param.rankjson) then
                local ranks =  Dll_JSON.decode(param.rankjson)
                for i = 1, #ranks do
                    local data=RankingData()
                    data:SetRankScoreData(ranks[i][1],ranks[i][2],ranks[i][3],ranks[i][4],0,0,ranks[i][5],0,ranks[i][6],0)
                    if data.Id==PlayerDataManager:Get():GetPlayerRID() then
                        score=data.RankScore
                        rank=data.Rank
                    end
                    table.insert(self.RankInfoList,data)
                end
            else
                -- CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RankingListNone))
            end
            if self.SelfData==nil then
                self.SelfData=RankingData()
                self.SelfData:SetRankScoreData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                        PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),0,score,0,rank,PlayerDataManager:Get():GetGuildName(),PlayerDataManager:Get():GetGuildId())

            end
        else
            self.SelfData=RankingData()
            self.SelfData:SetRankScoreData(PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetPlayerName(),
                    PlayerDataManager:Get():GetPlayerIcon(),PlayerDataManager:Get():GetPlayerIconFrame(),PlayerDataManager:Get():GetPlayerLV(),0,0,0,0,PlayerDataManager:Get():GetGuildName(),PlayerDataManager:Get():GetGuildId())
        end

    end
end

---@class RankingData
RankingData=class("RankingData")
function RankingData:initialize()
    self.Id=-1
    self.Name=""
    self.Icon=-1
    self.IconFrame=-1
    self.Rank=-1
    self.GuidePub=-1
    self.LeaderName=-1
    self.Members=-1
    self.NeedLv=-1
    self.Score=0
    self.RankScore=0
    self.GuideName=0
    self.GuideId=0
    self.TittleBg=0
    self.TittleCup= { }
end

---@param param SC_GuildInfo
function RankingData:SetGuideData(param,rank)
    self.Id=param.guildid
    self.Icon=param.guildicon
    self.Lv=param.guildlev
    self.GuideMoney=param.guildmoney
    self.Name= param.guildname
    self.GuidePub= param.guildpub
    self.GuideType= param.guildtype
    self.LeaderId= param.leader
    self.LeaderName= param.leadername
    self.Members= param.members
    self.NeedLv= param.needlev
    self.Rank=rank
    if param.tittlebg then
        self.TittleBg=tonumber(param.tittlebg)
    end
    if param.cup then
        self.TittleCup=stringSplitToNumber(param.cup,":")
    end
end
--俱乐部id  俱乐部名字 积分  参加人数  经验需要转等级  会长名 俱乐部图标
---@param param SC_GuildInfo
function RankingData:SetGuideDataPoint(id,name,point,Members,exp,ladername,icon,desc,rank)
    self.Id=tonumber(id)
    self.Icon=tonumber(icon)
    ---@type dictguildlevel_config
    local  cfgData=ClientDataManager:Get():GetDataTable(ConfigNames.dictguildlevel_config).GetConfigData()
    for k,v in pairs(cfgData) do
        if tonumber(exp) < v.guildexpe then
            self.Lv = v.C_ID
            break
        end
    end
    self.Name=name
    self.LeaderName= ladername
    self.Members= tonumber(Members)
    self.Score=tonumber(point)
    self.Desc=desc
    self.Rank=tonumber(rank)
    if tittlebg then
        self.TittleBg=tonumber(tittlebg)
    end
    if Cup then
        self.TittleCup=stringSplitToNumber(Cup,":")
    end
end

function RankingData:SetRankScoreData(id,name,icon,iconframe,lv,group,rankScore,score,rank,guideName,guideId)
    self.Id=tonumber(id)
    self.Name=name
    self.Icon=tonumber(icon)
    self.IconFrame=tonumber(iconframe)
    self.Lv=tonumber(lv)
    if score then
        self.Score=math.modf(tonumber(score))
    end
    self.RankScore=math.modf(tonumber(rankScore))

    self.Rank=tonumber(rank)
    self.Group=tonumber(group)
    self.GuideName=guideName
    self.GuideId=tonumber(guideId)
    self.Point=tonumber(point)
    if tittlebg then
        self.TittleBg=tonumber(tittlebg)
    end
    if Cup then
        self.TittleCup=stringSplitToNumber(Cup,":")
    end
end

function RankingData:SetRankSpeedData(id,name,icon,iconframe,lv,score,rank,rankscore,group)
    self.Id=tonumber(id)
    self.Name=name
    self.Icon=tonumber(icon)
    self.IconFrame=tonumber(iconframe)
    self.Lv=tonumber(lv)
    self.Score=math.modf(tonumber(score))
    self.Rank=tonumber(rank)
    self.RankScore=tonumber(rankscore)
    self.Group=tonumber(group)
    if tittlebg then
        self.TittleBg=tonumber(tittlebg)
    end
    if Cup then
        self.TittleCup=Cup
    end
end


