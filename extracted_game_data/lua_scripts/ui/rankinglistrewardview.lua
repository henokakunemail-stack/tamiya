---@class RankingListRewardView : ViewBase
RankingListRewardView = class("RankingListRewardView", ViewBase)

function RankingListRewardView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RankingListRewardViewAction")
end

function RankingListRewardView:Awake()
    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_H", self.gameObject, typeof(MoreRowScrollView))
end

function RankingListRewardView:OnOpen()

end

function RankingListRewardView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RankingListReward)
end

function RankingListRewardView:SetData(type)
    local rewards={}
    self.Type=type
    if type==RankingRewardType.RankScore then
        ---@type dictseasonpointaward_config
        local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictseasonpointaward_config)
        ---@type dictseasonspeedaward_config_cell[]
        rewards=  cfg.GetDataBySeasonid(RaceRankManager:Get():GetSessionCfg().seasonid)
    elseif type==RankingRewardType.RankSpeed or type==RankingRewardType.RankRlSpeed then
        ---@type dictseasonspeedaward_config
        local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictseasonspeedaward_config)
        ---@type dictseasonspeedaward_config_cell[]
        rewards=  cfg.GetDataBySeasonid(RaceRankManager:Get():GetSessionCfg().seasonid)
    elseif type==RankingRewardType.RaceTrot then
        ---@type dictseasonspeedaward_config
        local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictfastaward_config)
        ---@type dictseasonspeedaward_config_cell[]
        rewards=  cfg.GetDataBySeasonid(RaceTrotManager:Get():GetSeasonId())
    elseif type==RankingRewardType.RaceTopB then
        ---@type dictseasonspeedaward_config
        local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dicttopbspeedaward_config)
        ---@type dictseasonspeedaward_config_cell[]
        rewards=  cfg.GetDataBySeasonid(RaceTopManager:Get():GetSeasonId())
    elseif type==RankingRewardType.RaceTop32 then
        ---@type dicttop32speedaward_config
        local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dicttop32speedaward_config)
        ---@type dictseasonspeedaward_config_cell[]
        rewards=  cfg.GetDataBySeasonid(RaceTopManager:Get():GetSeasonId())
    elseif type==RankingRewardType.RaceTopSuperB then
        ---@type dictseasonspeedaward_config
        local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictworldtopbspeedaward_config)
        ---@type dictseasonspeedaward_config_cell[]
        rewards=  cfg.GetDataBySeasonid(RaceTopSuperManager:Get():GetSeasonId())
    elseif type==RankingRewardType.RaceTopSuper32 then
        ---@type dictseasonspeedaward_config
        local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictworldtop32speedaward_config)
        ---@type dictseasonspeedaward_config_cell[]
        rewards=  cfg.GetDataBySeasonid(RaceTopSuperManager:Get():GetSeasonId())
    elseif type==RankingRewardType.RaceJcp then
        ---@type dictjcupspeedaward_config
        local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictjcupspeedaward_config)
        ---@type dictjcupspeedaward_config_cell[]
        rewards=  cfg.GetDataBySeasonid(RaceJcpManager:Get().JcpData.Id)
    elseif type==RankingRewardType.RaceXcp then
        ---@type dictxcupspeedaward_config
        local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictxcupspeedaward_config)
        ---@type dictxcupspeedaward_config_cell[]
        rewards=  cfg.GetDataBySeasonid(RaceXCupManager:Get().XcpData.Id)
    elseif type==RankingRewardType.RaceSelfLevel then
        ---@type dictbattleaward_config
        local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictbattleaward_config)
        ---@type dictbattleaward_config_cell[]
        rewards=  cfg.GetTableDataByAwardId(tonumber(ChallengeMatchManager:Get():GetCurRoom().battles[1].awardid))
    elseif type==RankingRewardType.RaceAssemble then
        ---@type dictbattleaward_config
        local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictbattleaward_config)
        ---@type dictbattleaward_config_cell[]
        rewards=  cfg.GetTableDataByAwardId(RaceAssembleManager:Get():GetAwardId())
    elseif type==RankingRewardType.RaceGVGPoint then
        ---@type dictbattleaward_config
        local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictgvgpointaward_config)
        ---@type dictbattleaward_config_cell[]
        rewards=  cfg.GetDataBySeasonid(RaceGVGManager:Get():GetSeasonId())
    elseif type==RankingRewardType.RaceGVGGroup then
        ---@type dictseasonpointaward_config
        local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictgvgpointgroupaward_config)
        ---@type dictseasonpointaward_config_cell[]
        rewards=  cfg.GetDataBySeasonid(RaceGVGManager:Get():GetSeasonId())
    elseif type==RankingRewardType.RaceGVGSpeed1 or type==RankingRewardType.RaceGVGSpeed2 or type==RankingRewardType.RaceGVGSpeed3 then
        ---@type dictgvgpointspeedaward_config
        local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictgvgpointspeedaward_config)
        ---@type dictgvgpointspeedaward_config_cell[]
        rewards=  cfg.GetDataBySeasonid(RaceGVGManager:Get():GetSeasonId())
    elseif type==RankingRewardType.RaceSuperBattle then
        ---@type dictkilleraward_config
        local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictkilleraward_config)
        ---@type dictkilleraward_config_cell[]
        rewards=  cfg.GetDataBySeasonid(RaceSuperBattleManager:Get():GetData():GetSeasonId())
    end
    if rewards==nil then return end
    if #rewards>0 and rewards[1].speedfrom then
        table.sort(rewards,function(a, b)
            return a.speedfrom<b.speedfrom
        end)
        self.RankingData={}
        for i = 1, #rewards do
            local temp={}
            temp.rank=math.floor(rewards[i].speedfrom)
            temp.rankstart=rewards[i].speedfrom
            if type==RankingRewardType.RankRlSpeed then
                temp.rewards=CommonHelper:SetDataByStrIdAndNum(rewards[i].rlawardids,rewards[i].rlawardnums)
            else
                temp.rewards=CommonHelper:SetDataByStrIdAndNum(rewards[i].awardids,rewards[i].awardnums)
            end
            if type==RankingRewardType.RaceSelfLevel then
                local dictbattleaward= ClientDataManager:Get():GetDataTable(ConfigNames.dictbattleaward_config)
                ---@type dictbattleaward_config_cell
                local cfg=  dictbattleaward.GetTableDataByAwardIdAndRank(tonumber(ChallengeMatchManager:Get():GetCurRoom().battles[1].awardid),temp.rankstart)
                if cfg.jackpotper~=0  then
                    local id=stringSplitToNumber(cfg.jackpottype,":")[1]
                    local index=#temp.rewards+1
                    temp.rewards[index]=RewardData()
                    temp.rewards[index]:SetDataIdProbability(id,cfg.jackpotper)
                end
            end
            if type==RankingRewardType.RaceAssemble then
                local dictbattleaward= ClientDataManager:Get():GetDataTable(ConfigNames.dictbattleaward_config)
                ---@type dictbattleaward_config_cell
                local cfg=  dictbattleaward.GetTableDataByAwardIdAndRank(RaceAssembleManager:Get():GetAwardId(),temp.rankstart)
                if cfg.jackpotper~=0  then
                    local id=stringSplitToNumber(cfg.jackpottype,":")[1]
                    local index=#temp.rewards+1
                    temp.rewards[index]=RewardData()
                    temp.rewards[index]:SetDataIdProbability(id,cfg.jackpotper)
                end
            end
            if rewards[i].speedfrom ~=rewards[i].speedto  then
                temp.rank= CommonHelper:GetTempStr_Default(TemplateStringID.RankRewardShow,rewards[i].speedfrom,rewards[i].speedto)
            end
            if not ((type == RankingRewardType.RaceGVGSpeed1 or type == RankingRewardType.RaceGVGSpeed2 or type == RankingRewardType.RaceGVGSpeed3) and rewards[i].speedto==9999) then---零时处理 俱乐部积分赛奖励不显示 12040101  lujia 12040101
            table.insert(self.RankingData,temp)
            end
        end
    end
    if #rewards>0 and rewards[1].rankfrom then
        table.sort(rewards,function(a, b)
            return a.rankfrom<b.rankfrom
        end)
        self.RankingData={}
        for i = 1, #rewards do
            local temp={}
            temp.rank=math.floor(rewards[i].rankfrom)
            temp.rewards=CommonHelper:SetDataByStrIdAndNum(rewards[i].awardids,rewards[i].awardnums)
            temp.rankstart=rewards[i].rankfrom
            if rewards[i].rankfrom ~=rewards[i].rankto  then
                temp.rank= CommonHelper:GetTempStr_Default(TemplateStringID.RankRewardShow,rewards[i].rankfrom,rewards[i].rankto)
            end
            if not (type == RankingRewardType.RaceGVGGroup and rewards[i].rankto==4) then---零时处理 俱乐部积分赛奖励不显示 12040101  lujia 12040101
            table.insert(self.RankingData,temp)
            end
        end
    end
    if #rewards>0 and rewards[1].pointfrom then
        table.sort(rewards,function(a, b)
            return a.pointfrom<b.pointto
        end)
        self.RankingData={}
        for i = 1, #rewards do
            local temp={}
            temp.rank=math.floor(rewards[i].pointfrom)
            temp.rewards=CommonHelper:SetDataByStrIdAndNum(rewards[i].awardids,rewards[i].awardnums)
            temp.rankstart=rewards[i].pointfrom
            if rewards[i].pointfrom ~=rewards[i].pointto  then
                temp.rank= CommonHelper:GetTempStr_Default(TemplateStringID.RankRewardShow,rewards[i].pointfrom,rewards[i].pointto)
            end
            if not (type == RankingRewardType.RaceGVGPoint and rewards[i].pointto==9999) then---零时处理 俱乐部积分个人赛不显示9999  lujia
            table.insert(self.RankingData,temp)
            end

        end
    end
    if #rewards>0 and rewards[1].rankloc then
        table.sort(rewards,function(a, b)
            return a.rankloc<b.rankloc
        end)
        self.RankingData={}
        local lastReward=nil
        for i = 1, #rewards do
            local temp={}
            temp.rank=math.floor(rewards[i].rankloc)
            temp.rankstart=math.floor(rewards[i].rankloc)
            temp.rewards=CommonHelper:SetDataByStrIdAndNum(rewards[i].awardids,rewards[i].awardnums)
            if rewards[i].rankloc==RaceSuperBattleRewardState.Join then
                lastReward=temp
            else
                table.insert(self.RankingData,temp)
            end
        end
        table.insert(self.RankingData,lastReward)
    end
    self:SetScrollView()
end
function RankingListRewardView:SetScrollView()
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #self.RankingData, 1,function(dataIndex, itemObj, scroll)
        self:UpdateScrollView(dataIndex, itemObj)
    end)
end
function RankingListRewardView:UpdateScrollView(dataIndex, itemObj)
    self:SetItem(dataIndex+1 ,self.RankingData[dataIndex+1].rank,self.RankingData[dataIndex+1].rewards,itemObj,self.RankingData[dataIndex+1].rankstart)
end

function RankingListRewardView:SetItem(ranking,rankStr,rewards,parent,rankstart)
    local rank= CommonHelper:SetGameObjectActive("rank",parent,self.Type~=RankingRewardType.RaceGVGGroup and self.Type~=RankingRewardType.RaceSuperBattle)
    local gvgrank= CommonHelper:SetGameObjectActive("gvgrank",parent,self.Type==RankingRewardType.RaceGVGGroup)
    local superbattlerank= CommonHelper:SetGameObjectActive("superbattlerank",parent,self.Type==RankingRewardType.RaceSuperBattle)
    local jackpotper=0
    if self.Type~=RankingRewardType.RaceGVGGroup  and self.Type~=RankingRewardType.RaceSuperBattle and self.Type~=RankingRewardType.RaceTop32  and self.Type~=RankingRewardType.RaceTopSuper32 then
        CommonHelper:SetGameObjectActive("first",rank,tonumber(ranking)==1)
        CommonHelper:SetGameObjectActive("second",rank,tonumber(ranking)==2)
        CommonHelper:SetGameObjectActive("third",rank,tonumber(ranking)==3)
        CommonHelper:SetGameObjectActive("normal",rank,ranking>3)
        CommonHelper:SetText("###value",rank,rankStr)
    elseif  self.Type==RankingRewardType.RaceGVGGroup then
        for i = 1, 3 do
            CommonHelper:SetGameObjectActive(string.format("rank%d",i),gvgrank,ranking==i)
        end
        CommonHelper:SetText("###value",rank,rankStr)
    elseif  self.Type==RankingRewardType.RaceTop32 or  self.Type==RankingRewardType.RaceTopSuper32 then
        CommonHelper:SetGameObjectActive("first",rank,tonumber(ranking)==1)
        CommonHelper:SetGameObjectActive("second",rank,tonumber(ranking)==2)
        CommonHelper:SetGameObjectActive("third",rank,false)
        CommonHelper:SetGameObjectActive("normal",rank,ranking>=3)
        CommonHelper:SetText("###value",rank,rankStr)
    elseif  self.Type==RankingRewardType.RaceSuperBattle then
        CommonHelper:SetGameObjectActive("first",superbattlerank,ranking==1)
        CommonHelper:SetGameObjectActive("second",superbattlerank,ranking==2)
        CommonHelper:SetGameObjectActive("normal",superbattlerank,ranking>2)
        if rankStr==RaceSuperBattleRewardState.Join then
            CommonHelper:SetText("###rankname",superbattlerank,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperRewardJoin))
        elseif rankStr==RaceSuperBattleRewardState.Playoff then
            CommonHelper:SetText("###rankname",superbattlerank,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperPlayoffReward))
        elseif ranking>2 then
            CommonHelper:SetText("###rankname",superbattlerank,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSuperNoRankReward,rankStr))
        end
    end
    for i = 1, 8 do
        local item= CommonHelper:SetGameObjectActive("reward"..i.."/ItemCom_118",parent,rewards[i]~=nil)
        if rewards[i]  then
            local param = Param_ItemArticleParam()
            if rewards[i].num>-1 then
                param.count = rewards[i].num
            end
            if rewards[i].probability>-1 then
                param.probability = rewards[i].probability
            end

            CommonHelper:SetItemComGroup(item, UIModuleID.RankingListReward,rewards[i].id,param,function(btnData)
                CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.RankingListReward)
            end,rewards[i].id)
        end
    end

end
