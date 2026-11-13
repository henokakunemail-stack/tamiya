---@class RaceRankRankingListRewardView : ViewBase
RaceRankRankingListRewardView = class("RaceRankRankingListRewardView", ViewBase)

function RaceRankRankingListRewardView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceRankRankingListRewardViewAction")
end

function RaceRankRankingListRewardView:Awake()
    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
   self.Tog1= CommonHelper:HButtonSetCallback("Tog1",self.gameObject,function (hbtn)
       self:SetData(1)
    end)
   self.Tog2= CommonHelper:HButtonSetCallback("Tog2",self.gameObject,function (hbtn)
       self:SetData(2)
    end)

    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_H", self.gameObject, typeof(MoreRowScrollView))
end

function RaceRankRankingListRewardView:OnOpen()

end

function RaceRankRankingListRewardView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RankingListReward)
end

function RaceRankRankingListRewardView:SetData(type)
    local rewards={}
    self.Type=type
    CommonHelper:SetToggleState(self.Tog1,type==1)
    CommonHelper:SetToggleState(self.Tog2,type==2)
    if type==1 then
        ---@type dictseasonpointaward_config
        local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictseasonpointaward_config)
        ---@type dictseasonspeedaward_config_cell[]
        rewards=  cfg.GetDataBySeasonid(RaceRankManager:Get():GetSessionId())
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
                if #temp.rewards>0 then
                    table.insert(self.RankingData,temp)
                end
                end
            end
        end
    elseif type==2 then
        ---@type dictrankseasonaward_config
        local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictrankseasonaward_config)
        ---@type dictrankseasonaward_config_cell[]
        rewards=  cfg.GetDataList()
        self.RankingData={}
        for i = 1, #rewards do
            local temp={}
            temp.rank=rewards[i].rankidx
            temp.index=i
            temp.rankstr=CommonHelper:GetTempStr_Default(rewards[i].name)
            temp.rewards=CommonHelper:SetDataByStrIdAndNum(rewards[i].awards,rewards[i].awardnums)
            if temp.rewards and #temp.rewards>0 then
                table.insert(self.RankingData,temp)
            end

        end
        table.sort(self.RankingData,function(a, b)
            return a.index>b.index
        end)
    end

    self:SetScrollView()
end
function RaceRankRankingListRewardView:SetScrollView()
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #self.RankingData, 1,function(dataIndex, itemObj, scroll)
        self:UpdateScrollView(dataIndex, itemObj)
    end)
end
function RaceRankRankingListRewardView:UpdateScrollView(dataIndex, itemObj)
    if self.Type==1 then
        self:SetItem(dataIndex+1 ,self.RankingData[dataIndex+1].rank,self.RankingData[dataIndex+1].rewards,itemObj)
    end
    if self.Type==2 then
        self:SetItem(self.RankingData[dataIndex+1].rank ,self.RankingData[dataIndex+1].rankstr,self.RankingData[dataIndex+1].rewards,itemObj)
    end

end

function RaceRankRankingListRewardView:SetItem(ranking,rankStr,rewards,parent)
    local rank= CommonHelper:SetGameObjectActive("rank",parent,self.Type==1)
    local dan= CommonHelper:SetGameObjectActive("dan",parent,self.Type==2)
    local jackpotper=0
    if self.Type==1 then
        CommonHelper:SetGameObjectActive("first",rank,tonumber(ranking)==1)
        CommonHelper:SetGameObjectActive("second",rank,tonumber(ranking)==2)
        CommonHelper:SetGameObjectActive("third",rank,tonumber(ranking)==3)
        CommonHelper:SetGameObjectActive("normal",rank,ranking>3)
        CommonHelper:SetText("###value",rank,rankStr)
    end
    if self.Type==2 then
        CommonHelper:SetGameObjectActive("dan1",dan,tonumber(ranking)==5)
        CommonHelper:SetGameObjectActive("dan2",dan,tonumber(ranking)==4)
        CommonHelper:SetGameObjectActive("dan3",dan,tonumber(ranking)==3)
        CommonHelper:SetGameObjectActive("dan4",dan,ranking==2)
        CommonHelper:SetGameObjectActive("dan5",dan,ranking==1)
        CommonHelper:SetText("###value",dan,rankStr)
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
