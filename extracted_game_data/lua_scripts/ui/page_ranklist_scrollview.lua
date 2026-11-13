---@class Page_RankListScrollView:Page_RankListScrollView
Page_RankListScrollView=class("Page_RankListScrollView",Page_SelectCarBase)
function Page_RankListScrollView:initialize()

end
RankListScrollViewGroup={}
RankListScrollViewGroup[RankingListModuleType.RankingListView]={}
RankListScrollViewGroup[RankingListModuleType.RankingListView][1]=RankingListType.Speed
RankListScrollViewGroup[RankingListModuleType.RankingListView][2]=RankingListType.Score
RankListScrollViewGroup[RankingListModuleType.RankingListView][3]=RankingListType.RlSpeed
RankListScrollViewGroup[RankingListModuleType.MainRankingListView]={}
RankListScrollViewGroup[RankingListModuleType.MainRankingListView][1]=RankingListType.MainClub
RankListScrollViewGroup[RankingListModuleType.MainRankingListView][2]=RankingListType.MainSpeed
RankListScrollViewGroup[RankingListModuleType.MainRankingListView][3]=RankingListType.MainRlSpeed
RankListScrollViewGroup[RankingListModuleType.RaceTrotRankListView]={}
RankListScrollViewGroup[RankingListModuleType.RaceTrotRankListView][1]=RankingListType.RaceTrot
RankListScrollViewGroup[RankingListModuleType.RaceTopRankingListView]={}
RankListScrollViewGroup[RankingListModuleType.RaceTopRankingListView][1]=RankingListType.RaceTopA
RankListScrollViewGroup[RankingListModuleType.RaceTopRankingListView][2]=RankingListType.RaceTopB
RankListScrollViewGroup[RankingListModuleType.RaceSuperBattleRankView]={}
RankListScrollViewGroup[RankingListModuleType.RaceSuperBattleRankView][1]=RankingListType.RaceSuperBattlePoint
RankListScrollViewGroup[RankingListModuleType.RaceSuperBattleRankView][2]=RankingListType.RaceSuperBattlePlayerOffPoint
RankListScrollViewGroup[RankingListModuleType.RaceJcpRankListView]={}
RankListScrollViewGroup[RankingListModuleType.RaceJcpRankListView][1]=RankingListType.RaceJCP
RankListScrollViewGroup[RankingListModuleType.RaceXCPRankListView]={}
RankListScrollViewGroup[RankingListModuleType.RaceXCPRankListView][1]=RankingListType.RaceXCP
RankListScrollViewGroup[RankingListModuleType.RaceGVGRankListView]={}
RankListScrollViewGroup[RankingListModuleType.RaceGVGRankListView][1]=RankingListType.RaceGVGSpeed1
RankListScrollViewGroup[RankingListModuleType.RaceGVGRankListView][2]=RankingListType.RaceGVGSpeed2
RankListScrollViewGroup[RankingListModuleType.RaceGVGRankListView][3]=RankingListType.RaceGVGSpeed3
RankListScrollViewGroup[RankingListModuleType.RaceGVGRankListView][4]=RankingListType.RaceClubAll
RankListScrollViewGroup[RankingListModuleType.RaceGVGRankListView][5]=RankingListType.RaceGVGPoint
RankListScrollViewGroup[RankingListModuleType.PveChapterRankListView]={}
RankListScrollViewGroup[RankingListModuleType.PveChapterRankListView][1]=RankingListType.PveChapter
RankListScrollViewGroup[RankingListModuleType.PveChapterRankListView][2]=RankingListType.SpecialTraining
RankListScrollViewGroup[RankingListModuleType.ChallengeMathRankingListView]={}
RankListScrollViewGroup[RankingListModuleType.ChallengeMathRankingListView][1]=RankingListType.ChallengeMatch
RankListScrollViewGroup[RankingListModuleType.RaceTopSuperRankingListView]={}
RankListScrollViewGroup[RankingListModuleType.RaceTopSuperRankingListView][1]=RankingListType.RaceTopSuperA
RankListScrollViewGroup[RankingListModuleType.RaceTopSuperRankingListView][2]=RankingListType.RaceTopSuperB
RankListScrollViewGroup[RankingListModuleType.RaceAssembleRankingListView]={}
RankListScrollViewGroup[RankingListModuleType.RaceAssembleRankingListView][1]=RankingListType.RaceAssemble

---@param RankingData RankingListData
function Page_RankListScrollView:SetData(ScrollView,Self,RankingData,ModuleID,func,RecordFun,defaultValue,ModuleType)
    self.ScrollView=ScrollView
    self.RankingData=RankingData
    self.ModuleID=ModuleID
    self.CurRankType=RankingData.type
    self.ItemClick=func
    self.RecordFun=RecordFun
    self.Self=Self
    self.defaultValue=5
    self.ModuleType=ModuleType
    if defaultValue then self.defaultValue=defaultValue end
    local count=#self.RankingData.RankInfoList>=self.defaultValue and #self.RankingData.RankInfoList or self.defaultValue
    CommonHelper:InitMoreRowScrollView(self.ScrollView, count, 1,function(dataIndex, itemObj, scroll)
        local data=self.RankingData.RankInfoList[dataIndex+1]
        self:UpdateScrollView(data, itemObj,dataIndex)
    end)
    self:SetSelf()
end
function Page_RankListScrollView:SetSelf()
    if self.RankingData.SelfData==nil then
        return
    end
   CommonHelper:SetGameObjectActive("self",self.Self,self.CurRankType==RankingListType.MainSpeed
                                                                                   or self.CurRankType==RankingListType.Speed
                                                                                   or self.CurRankType==RankingListType.MainRlSpeed
                                                                                   or self.CurRankType==RankingListType.Score
                                                                                   or self.CurRankType==RankingListType.ChallengeMatch
                                                                                   or self.CurRankType==RankingListType.RaceAssemble
                                                                                   or self.CurRankType==RankingListType.RaceJCP
                                                                                   or self.CurRankType==RankingListType.RaceXCP
                                                                                   or self.CurRankType==RankingListType.RlSpeed
                                                                                   or self.CurRankType==RankingListType.RaceTrot
                                                                                   or self.CurRankType==RankingListType.RaceTopA
                                                                                   or self.CurRankType==RankingListType.RaceTopSuperA
                                                                                   or self.CurRankType==RankingListType.RaceTopB
                                                                                   or self.CurRankType==RankingListType.RaceTopSuperB
                                                                                   or self.CurRankType==RankingListType.RaceGVGSpeed1
                                                                                   or self.CurRankType==RankingListType.RaceGVGSpeed2
                                                                                   or self.CurRankType==RankingListType.RaceGVGSpeed3
                                                                                   or self.CurRankType==RankingListType.RaceSuperBattlePoint
                                                                                   or self.CurRankType==RankingListType.RaceSuperBattlePlayerOffPoint
                                                                                   or self.CurRankType==RankingListType.PveChapter
                                                                                   or self.CurRankType==RankingListType.SpecialTraining
                                                                                   or self.CurRankType==RankingListType.RaceClubAll
                                                                                   or self.CurRankType==RankingListType.RaceGVGPoint)
    local rank1= CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.MainSpeed),self.Self,self.CurRankType==RankingListType.MainSpeed)
    local rank2=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.MainClub),self.Self,self.CurRankType==RankingListType.MainClub)
    local rank3=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.Speed),self.Self,self.CurRankType==RankingListType.Speed)
    local rank4=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.Score),self.Self,self.CurRankType==RankingListType.Score)
    local rank5=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.RaceJCP),self.Self,self.CurRankType==RankingListType.RaceJCP)
    local rank6=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.RlSpeed),self.Self,self.CurRankType==RankingListType.RlSpeed)
    local rank7=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.ChallengeMatch),self.Self,self.CurRankType==RankingListType.ChallengeMatch)
    local rank8=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.RaceTrot),self.Self,self.CurRankType==RankingListType.RaceTrot)
    local rank9=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.RaceJCP),self.Self,self.CurRankType==RankingListType.RaceJCP)
    local rank10=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.RaceTopA),self.Self,self.CurRankType==RankingListType.RaceTopA)
    local rank11=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.RaceTopB),self.Self,self.CurRankType==RankingListType.RaceTopB)
    local rank12=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.RaceGVGSpeed1),self.Self,self.CurRankType==RankingListType.RaceGVGSpeed1)
    local rank13=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.RaceGVGSpeed2),self.Self,self.CurRankType==RankingListType.RaceGVGSpeed2)
    local rank14=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.RaceGVGSpeed3),self.Self,self.CurRankType==RankingListType.RaceGVGSpeed3)
    local rank15=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.RaceGVGPoint),self.Self,self.CurRankType==RankingListType.RaceGVGPoint)
    local rank16=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.RaceSuperBattlePoint),self.Self,self.CurRankType==RankingListType.RaceSuperBattlePoint)
    local rank17=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.RaceSuperBattlePlayerOffPoint),self.Self,self.CurRankType==RankingListType.RaceSuperBattlePlayerOffPoint)
    local rank18=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.PveChapter),self.Self,self.CurRankType==RankingListType.PveChapter )
    local rank19=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.SpecialTraining),self.Self,self.CurRankType==RankingListType.SpecialTraining)
    local rank20=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.MainRlSpeed),self.Self,self.CurRankType==RankingListType.MainRlSpeed)
    local rank21=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.RaceClubAll),self.Self,self.CurRankType==RankingListType.RaceClubAll)
    local rank22=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.RaceTopSuperA),self.Self,self.CurRankType==RankingListType.RaceTopSuperA)
    local rank23=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.RaceTopSuperB),self.Self,self.CurRankType==RankingListType.RaceTopSuperB)
    local rank24=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.RaceAssemble),self.Self,self.CurRankType==RankingListType.RaceAssemble)
    local rank25=CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",RankingListType.RaceXCP),self.Self,self.CurRankType==RankingListType.RaceXCP)
    local parent=nil
    if self.CurRankType==RankingListType.MainSpeed then
        parent=rank1
    elseif self.CurRankType==RankingListType.MainClub then
        parent=rank2
    elseif self.CurRankType==RankingListType.Speed then
        parent=rank3
    elseif self.CurRankType==RankingListType.Score then
        parent=rank4
    elseif self.CurRankType==RankingListType.RaceJCP then
        parent=rank5
    elseif self.CurRankType==RankingListType.RlSpeed then
        parent=rank6
    elseif self.CurRankType==RankingListType.ChallengeMatch then
        parent=rank7
    elseif self.CurRankType==RankingListType.RaceTrot then
        parent=rank8
    elseif self.CurRankType==RankingListType.RaceJCP then
        parent=rank9
    elseif self.CurRankType==RankingListType.RaceTopA then
        parent=rank10
    elseif self.CurRankType==RankingListType.RaceTopB then
        parent=rank11
    elseif self.CurRankType==RankingListType.RaceGVGSpeed1 then
        parent=rank12
    elseif self.CurRankType==RankingListType.RaceGVGSpeed2 then
        parent=rank13
    elseif self.CurRankType==RankingListType.RaceGVGSpeed3 then
        parent=rank14
    elseif self.CurRankType==RankingListType.RaceGVGPoint then
        parent=rank15
    elseif self.CurRankType==RankingListType.RaceSuperBattlePoint then
        parent=rank16
    elseif self.CurRankType==RankingListType.RaceSuperBattlePlayerOffPoint then
        parent=rank17
    elseif self.CurRankType==RankingListType.PveChapter then
        parent=rank18
    elseif self.CurRankType==RankingListType.SpecialTraining then
        parent=rank19
    elseif self.CurRankType==RankingListType.MainRlSpeed then
        parent=rank20
    elseif self.CurRankType==RankingListType.RaceClubAll then
        parent=rank21
    elseif self.CurRankType==RankingListType.RaceTopSuperA then
        parent=rank22
    elseif self.CurRankType==RankingListType.RaceTopSuperB then
        parent=rank23
     elseif self.CurRankType==RankingListType.RaceAssemble then
        parent=rank24
    elseif self.CurRankType==RankingListType.RaceXCP then
        parent=rank25
    end
    if self.RankingData.SelfData then
        self:SetItem(parent,self.RankingData.SelfData,-1)
    end
end

function Page_RankListScrollView:UpdateScrollView(data, itemObj,dataIndex)

    local parent=nil
    for k, v in pairs(RankListScrollViewGroup[self.ModuleType]) do
      local item=  CommonHelper:SetGameObjectActive(string.format("coustom_rank%d",v),itemObj,v==self.CurRankType and data~=nil)
        if v==self.CurRankType then
            parent=item
        end
    end
    if data then
        CommonHelper:SetGameObjectActive("coustom_rank_none",itemObj,false)
    else
        local  coustom_rank_none=CommonHelper:SetGameObjectActive("coustom_rank_none",itemObj,true)
        CommonHelper:SetPlayerIconById("PlayerIcon",coustom_rank_none,99999,99999,nil,UIModuleID.RankingList)
        return
    end
   self:SetItem(parent,data,dataIndex)
end

---@param data RankingData
function Page_RankListScrollView:SetItem(parent,data,dataIndex)
    CommonHelper:SetGameObjectActive("first",parent,data.Rank==1)
    if (self.CurRankType==RankingListType.RaceSuperBattlePoint or self.CurRankType==RankingListType.RaceSuperBattlePlayerOffPoint ) and dataIndex==-1 then
        --CommonHelper:SetGameObjectActive("BtnRecord",parent,data.Rank>0)
        CommonHelper:SetGameObjectActive("BtnRecord",parent,RaceSuperBattleManager:Get():GetIsSign() and #self.RankingData.RankInfoList>0)
    end
    CommonHelper:SetGameObjectActive("rank0",parent,data.Rank<=0)
    CommonHelper:SetGameObjectActive("second",parent,data.Rank==2)
    CommonHelper:SetGameObjectActive("third",parent,data.Rank==3)
    local rank4_9 =CommonHelper:SetGameObjectActive("rank4-9",parent,data.Rank>=4 and data.Rank<=9)
    local rank10_99 = CommonHelper:SetGameObjectActive("rank5-99",parent,data.Rank>=10 and  data.Rank<=99)
    local rank_100=CommonHelper:SetGameObjectActive("rank100",parent,data.Rank>=100 and  data.Rank<=999)
    local rank_1000=CommonHelper:SetGameObjectActive("rank1000",parent,data.Rank>=1000 and  data.Rank<=9999)
    local rank_10000=CommonHelper:SetGameObjectActive("rank10000",parent,data.Rank>=10000 and  data.Rank<=99999)
    if data.Rank>3 then
        if self.CurRankType==RankingListType.PveChapter or  self.CurRankType==RankingListType.SpecialTraining then
            CommonHelper:SetText("###text",rank4_9,tostring(data.Rank))
            CommonHelper:SetText("###text",rank10_99,tostring(data.Rank))
            CommonHelper:SetText("###text",rank_100,tostring(data.Rank))
            CommonHelper:SetText("###text",rank_1000,tostring(data.Rank))
            CommonHelper:SetText("###text",rank_10000,tostring(data.Rank))
        else
            CommonHelper:SetText("rank4-9",rank4_9,tostring(data.Rank))
            CommonHelper:SetText("rank5-99",rank10_99,tostring(data.Rank))
            CommonHelper:SetText("rank100",rank_100,tostring(data.Rank))
            CommonHelper:SetText("rank1000",rank_1000,tostring(data.Rank))
            CommonHelper:SetText("rank10000",rank_10000,tostring(data.Rank))
        end

    end
    if self.ItemClick then
        CommonHelper:HButtonSetCallback("HButton",parent,function(data)
            if self.ItemClick then
                if data.intData>=0 then
                    self.ItemClick(data.intData+1)
                end
            end
        end,dataIndex)
    end
    if self.RecordFun then
        CommonHelper:HButtonSetCallback("BtnRecord",parent,function(data)
            local temp=self.RankingData.RankInfoList[data.intData+1]
            if self.RecordFun then
                if temp then
                    self.RecordFun(temp.Id,temp.Score)
                else
                    self.RecordFun(PlayerDataManager:Get():GetPlayerRID())
                end
            end
        end,dataIndex)
    end
    if self.CurRankType==RankingListType.Score then
--        if data.Score>-1 then
            CommonHelper:GetComponentTransferTime("###bestrecord",parent,data.Score)
        --elseif data.Score<=-1 then
        --    local result=CommonHelper:TransferTime(math.abs(data.Score), 0.001)
        --    CommonHelper:SetText("###bestrecord", parent,"-".. CommonHelper:TransferTimeToString(result))
        --else
        --    CommonHelper:SetText("###bestrecord",parent,"--:--:--")
        --end
    else
        if data.Score>-1 then
            CommonHelper:GetComponentTransferTime("###bestrecord",parent,data.Score)
        elseif data.Score<=-1 then
            local result=CommonHelper:TransferTime(math.abs(data.Score), 0.001)
            CommonHelper:SetText("###bestrecord", parent,"-".. CommonHelper:TransferTimeToString(result))
        else
            CommonHelper:SetText("###bestrecord",parent,"--:--:--")
        end
    end


    CommonHelper:SetPlayerIconById("PlayerIcon",parent,data.Icon,data.IconFrame,nil,self.ModuleID)
    CommonHelper:SetText("###playerName",parent,data.Name)
    CommonHelper:SetText("###guildename",parent,data.GuideName)
    if self.CurRankType==RankingListType.RaceTrot then
        ---@type qualifyingrank_config_cell
        local curcfg = CommonHelper:GetTrotCfgByScore(data.RankScore,false)
        CommonHelper:SetTrotIconGroup("rankicon_s_5", parent, curcfg)
    else
        ---@type qualifyingrank_config_cell
        local curcfg, minscore, maxscore = CommonHelper:GetRankCfgByScore(data.RankScore)
        CommonHelper:SetRankIconGroup("rankicon_s_5", parent, curcfg)
    end

    if self.CurRankType==RankingListType.Score or self.CurRankType==RankingListType.RaceTrot or
            self.CurRankType==RankingListType.RaceJCP or self.CurRankType==RankingListType.RaceGVGSpeed1 or self.CurRankType==RankingListType.RaceXCP
            or self.CurRankType==RankingListType.RaceGVGSpeed2 or self.CurRankType==RankingListType.RaceGVGSpeed3
            or self.CurRankType==RankingListType.RaceGVGPoint or self.CurRankType==RankingListType.RaceSuperBattlePoint then
        CommonHelper:SetText("###score",parent,data.RankScore)
    elseif self.CurRankType==RankingListType.Speed or self.CurRankType==RankingListType.MainSpeed then
        if data.Rank>0 then
            CommonHelper:SetText("###score",parent,10000-data.Rank+1)
        else
            CommonHelper:SetText("###score",parent,0)
        end

    else
        if data.Lv then
            CommonHelper:SetText("###score",parent,"Lv:"..data.Lv)
        end
    end

    if data.Group then
        CommonHelper:SetText("###group",parent,CommonHelper:GetTempStr_Default(string.format("rankinglistgroup_%d",data.Group)))
    end

    local rewardData=nil
    if self.CurRankType==RankingListType.Speed  then
        ---@type dictseasonspeedaward_config
        local table= ClientDataManager:Get():GetDataTable(ConfigNames.dictseasonspeedaward_config)
        ---@type dictseasonspeedaward_config_cell
        rewardData=  table.GetDataByRank(data.Rank,RaceRankManager:Get():GetSessionCfg().seasonid)
    elseif self.CurRankType==RankingListType.RlSpeed then
        ---@type dictseasonspeedaward_config
        local table= ClientDataManager:Get():GetDataTable(ConfigNames.dictseasonspeedaward_config)
        if table.GetDataByRank(data.Rank,RaceRankManager:Get():GetSessionCfg().seasonid) then
            rewardData={}
            rewardData.awardids= table.GetDataByRank(data.Rank,RaceRankManager:Get():GetSessionCfg().seasonid).rlawardids
            rewardData.awardnums= table.GetDataByRank(data.Rank,RaceRankManager:Get():GetSessionCfg().seasonid).rlawardnums
        end
   elseif self.CurRankType==RankingListType.MainRlSpeed then
        ---@type dictseasonspeedaward_config
        local table= ClientDataManager:Get():GetDataTable(ConfigNames.dictseasonspeedaward_config)
        if table.GetDataByRank(data.Rank,RankingListDataManager:Get().SeasonId) then
            rewardData={}
            rewardData.awardids= table.GetDataByRank(data.Rank,RankingListDataManager:Get().SeasonId).rlawardids
            rewardData.awardnums= table.GetDataByRank(data.Rank,RankingListDataManager:Get().SeasonId).rlawardnums
        end
    elseif  self.CurRankType==RankingListType.MainSpeed then
        ---@type dictseasonspeedaward_config
        local table= ClientDataManager:Get():GetDataTable(ConfigNames.dictseasonspeedaward_config)
        ---@type dictseasonspeedaward_config_cell
        rewardData=  table.GetDataByRank(data.Rank,RankingListDataManager:Get().SeasonId)
    elseif self.CurRankType==RankingListType.Score then
        ---@type dictseasonpointaward_config
        local table= ClientDataManager:Get():GetDataTable(ConfigNames.dictseasonpointaward_config)
        ---@type dictseasonpointaward_config_cell
        rewardData=  table.GetDataByRank(data.Rank,RaceRankManager:Get():GetSessionId())
    elseif self.CurRankType==RankingListType.RaceJCP then
        ---@type dictjcupspeedaward_config
        local table= ClientDataManager:Get():GetDataTable(ConfigNames.dictjcupspeedaward_config)
        ---@type dictjcupspeedaward_config_cell
        rewardData=  table.GetDataByRank(data.Rank,RaceJcpManager:Get():GetSeasonId())
    elseif self.CurRankType==RankingListType.RaceXCP then
        ---@type dictjcupspeedaward_config
        local table= ClientDataManager:Get():GetDataTable(ConfigNames.dictxcupspeedaward_config)
        ---@type dictjcupspeedaward_config_cell
        rewardData=  table.GetDataByRank(data.Rank,RaceXCupManager:Get():GetSeasonId())
    elseif self.CurRankType==RankingListType.ChallengeMatch then
        ---@type dictbattleaward_config
        local table= ClientDataManager:Get():GetDataTable(ConfigNames.dictbattleaward_config)
        ---@type dictseasonspeedaward_config_cell
        rewardData=  table.GetTableDataByAwardIdAndRank(tonumber(ChallengeMatchManager:Get():GetCurRoom().battles[1].awardid),data.Rank)
   elseif self.CurRankType==RankingListType.RaceAssemble then
        ---@type dictbattleaward_config
        local table= ClientDataManager:Get():GetDataTable(ConfigNames.dictbattleaward_config)
        ---@type dictseasonspeedaward_config_cell
        rewardData= table.GetTableDataByAwardIdAndRank(RaceAssembleManager:Get():GetAwardId(),data.Rank)
    elseif self.CurRankType==RankingListType.RaceTrot then
        ---@type dictfastaward_config
        local table= ClientDataManager:Get():GetDataTable(ConfigNames.dictfastaward_config)
        ---@type dictseasonspeedaward_config_cell
        rewardData=  table.GetDataByRank(data.Rank,RaceTrotManager:Get():GetSeasonId())
    elseif self.CurRankType==RankingListType.RaceTopB then
        ---@type dicttopbspeedaward_config
        local table= ClientDataManager:Get():GetDataTable(ConfigNames.dicttopbspeedaward_config)
        ---@type dictseasonpointaward_config_cell
        rewardData=  table.GetDataByRank(data.Rank,RaceTopManager:Get():GetSeasonId())
  elseif self.CurRankType==RankingListType.RaceTopSuperB then
        ---@type dictseasonpointaward_config
        local table= ClientDataManager:Get():GetDataTable(ConfigNames.dictworldtopbspeedaward_config)
        ---@type dictseasonpointaward_config_cell
        rewardData=  table.GetDataByRank(data.Rank, RaceTopSuperManager:Get():GetSeasonId())
    elseif self.CurRankType==RankingListType.RaceGVGSpeed1 or self.CurRankType==RankingListType.RaceGVGSpeed2 or self.CurRankType==RankingListType.RaceGVGSpeed3 then
        ---@type dictgvgpointspeedaward_config
        local table= ClientDataManager:Get():GetDataTable(ConfigNames.dictgvgpointspeedaward_config)
        ---@type dictgvgpointspeedaward_config_cell
        rewardData=  table.GetDataByRank(data.Rank,RaceGVGManager:Get():GetSeasonId())
    elseif self.CurRankType==RankingListType.RaceGVGPoint then
        ---@type dictgvgpointspeedaward_config
        local table= ClientDataManager:Get():GetDataTable(ConfigNames.dictgvgpointaward_config)
        ---@type dictgvgpointspeedaward_config_cell
        rewardData=  table.GetDataByRank(data.Rank,RaceGVGManager:Get():GetSeasonId())
    elseif self.CurRankType==RankingListType.RaceTopA then
        CommonHelper:SetGameObjectActive("upracetop",parent,data.Rank<=32 and data.Rank>0)
  elseif self.CurRankType==RankingListType.RaceTopSuperA then
        CommonHelper:SetGameObjectActive("upracetop",parent,data.Rank<=32 and data.Rank>0)
    end

    if rewardData  then
        local rewards=CommonHelper:SetDataByStrIdAndNum(rewardData.awardids,rewardData.awardnums)
        if self.CurRankType==RankingListType.ChallengeMatch then
            local dictbattleaward= ClientDataManager:Get():GetDataTable(ConfigNames.dictbattleaward_config)
            ---@type dictbattleaward_config_cell
            local cfg=  dictbattleaward.GetTableDataByAwardIdAndRank(tonumber(ChallengeMatchManager:Get():GetCurRoom().battles[1].awardid),data.Rank)
            if cfg.jackpotper~=0  then
                local id=stringSplitToNumber(cfg.jackpottype,":")[1]
                local index=#rewards+1
                rewards[index]=RewardData()
                rewards[index]:SetDataIdProbability(id,cfg.jackpotper)
            end
        end
        if self.CurRankType==RankingListType.RaceAssemble then
            local dictbattleaward= ClientDataManager:Get():GetDataTable(ConfigNames.dictbattleaward_config)
            ---@type dictbattleaward_config_cell
            local cfg=  dictbattleaward.GetTableDataByAwardIdAndRank(RaceAssembleManager:Get():GetAwardId(),data.Rank)
            if cfg.jackpotper~=0  then
                local id=stringSplitToNumber(cfg.jackpottype,":")[1]
                local index=#rewards+1
                rewards[index]=RewardData()
                rewards[index]:SetDataIdProbability(id,cfg.jackpotper)
            end
        end
        for i = 1, 4 do
            local item= CommonHelper:SetGameObjectActive("reward"..i.."/ItemCom_118",parent,rewards[i]~=nil)
            if rewards[i] then
                local param = Param_ItemArticleParam()
                if rewards[i].num>-1 then
                    param.count = rewards[i].num
                end
                if rewards[i].probability>-1 then
                    param.probability = rewards[i].probability
                end
                if item then
                    CommonHelper:SetItemComGroup(item,self.ModuleID,rewards[i].id,param,function(btnData)
                        CommonHelper:ShowPartInfoByCfgId(btnData,self.ModuleID)
                    end,rewards[i].id)
                end
            end
        end
    else
        for i = 1, 4 do
            local item= CommonHelper:SetGameObjectActive("reward"..i.."/ItemCom_118",parent,false)
        end
    end
    if self.CurRankType==RankingListType.MainClub then
        CommonHelper:SetPlayerIcon("PlayerIcon",parent,CommonHelper:GetPlayerIconById(tonumber(data.Icon), HeadIconType.ClubIcon)..".png",data.IconFrame,nil,self.ModuleID)
        CommonHelper:SetText("###playerName",parent,data.Name)
        CommonHelper:SetText("###lv",parent,data.Lv)
        CommonHelper:SetText("###ladername",parent,data.LeaderName)
        CommonHelper:SetText("###num",parent,data.Members)
    end
    if self.CurRankType==RankingListType.RaceClubAll then
        CommonHelper:GetComponentSetUITexture("clubicon", parent, CommonHelper:GetPlayerIconById(tonumber(data.Icon), HeadIconType.ClubIcon) .. ".png", UIModuleID.MainRankingList)
        CommonHelper:SetText("###playerName",parent,data.Name)
        CommonHelper:SetText("###lv",parent,data.Lv)
        CommonHelper:SetText("###score",parent,data.Score)
        CommonHelper:SetText("###num",parent,data.Members)
    end

end

