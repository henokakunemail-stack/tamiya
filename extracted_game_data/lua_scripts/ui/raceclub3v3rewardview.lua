---@class RaceClub3V3RewardView : ViewBase
RaceClub3V3RewardView = class("RaceClub3V3RewardView", ViewBase)

function RaceClub3V3RewardView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceClub3V3RewardViewAction")
end

function RaceClub3V3RewardView:Awake()
    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (hbtn)
        UIManager:Get():HidePersistentView("RaceClub3V3RewardView")
    end)
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():HidePersistentView("RaceClub3V3RewardView")
    end)
   self.TogClubReward=CommonHelper:HButtonSetCallback("TogClubReward",self.gameObject,function (hbtn)
        self:ClickTog(1)
    end)
   self.TogSelfReward=CommonHelper:HButtonSetCallback("TogSelfReward",self.gameObject,function (hbtn)
       self:ClickTog(2)
    end)
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_V", self.gameObject, typeof(MoreRowScrollView))
end

function RaceClub3V3RewardView:OnOpen()
    --self:SetData()
    self:ClickTog(1,true)
end

function RaceClub3V3RewardView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceClub3V3Reward)
end
function RaceClub3V3RewardView:ClickTog(idx,isRefresh)
    if self.SelectIdx==idx and not isRefresh then return end
    self.SelectIdx=idx
   CommonHelper:SetToggleState(self.TogClubReward,idx==1)
   CommonHelper:SetToggleState(self.TogSelfReward,idx==2)
   self:SetData()
end


function RaceClub3V3RewardView:SetData()
    local cfg=nil
    local award=nil
    if self.SelectIdx==1 then
        ---@type dictguildpoint_config
         cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictguildpoint_config)
         award=RaceClub3V3Manager:Get():GetClubAward()
    end
    if self.SelectIdx==2 then
        ---@type dictguildperson_config
         cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictguildperson_config)
        award=RaceClub3V3Manager:Get():GetSelfAward()
    end
    local rewards= {}
    local tableData=cfg.GetConfigData()
    for k, v in pairs(tableData) do
        table.insert(rewards,v)
    end
    table.sort(rewards,function(a, b)
        return a.C_ID<b.C_ID
    end)
    self.RankingData={}
    for i = 1, #rewards do
        local temp={}
        temp.rewards=CommonHelper:SetDataByStrIdAndNum(rewards[i].awardids,rewards[i].awardnums)
        temp.data=rewards[i]
        temp.state=RaceClub3V3RewardState.Rally
        temp.index=i-1
        if self.SelectIdx==1 then
            if RaceClub3V3Manager:Get():GetClubScore()>=rewards[i].C_ID then
                temp.state=RaceClub3V3RewardState.Done
            end
        end
        if self.SelectIdx==2 then
            if RaceClub3V3Manager:Get():GetSelfScore()>=rewards[i].C_ID then
                temp.state=RaceClub3V3RewardState.Done
            end
        end
        table.insert(self.RankingData,temp)
    end
    local awards= stringSplitToNumber(award,":")
    for i = 1, #self.RankingData do
        if awards[i]==1 then
            self.RankingData[i].state=RaceClub3V3RewardState.GetEnd
        end
    end
    table.sort(self.RankingData,function(a, b)
        if a.state~=b.state then
            return a.state<b.state
        end
        return a.data.C_ID<b.data.C_ID
    end)
    self:SetScrollView()
end
function RaceClub3V3RewardView:SetScrollView()
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #self.RankingData, 1,function(dataIndex, itemObj, scroll)
        self:UpdateScrollView(dataIndex, itemObj)
    end)
end
function RaceClub3V3RewardView:UpdateScrollView(dataIndex, itemObj)
    local state=self.RankingData[dataIndex+1].state
    CommonHelper:SetGameObjectActive("done",itemObj,state==RaceClub3V3RewardState.Done)
    CommonHelper:SetGameObjectActive("rally",itemObj,state==RaceClub3V3RewardState.Rally)
    CommonHelper:SetGameObjectActive("geted",itemObj,state==RaceClub3V3RewardState.GetEnd)
    if state==RaceClub3V3RewardState.GetEnd then
        UIUtil.SetCanvasGroupAlpha("coustom_rank8",itemObj,0.8,true)
    else
        UIUtil.SetCanvasGroupAlpha("coustom_rank8",itemObj,1,true)
    end
    if self.SelectIdx==1 then
        CommonHelper:SetText("###rewardname",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceClub3V3RewardClubScore,self.RankingData[dataIndex+1].data.C_ID))
        CommonHelper:SetText("###progress",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceClub3V3RewardProgress,RaceClub3V3Manager:Get():GetClubScore(),self.RankingData[dataIndex+1].data.C_ID))
        CommonHelper:SetSlider("SliderBaseColor",itemObj,RaceClub3V3Manager:Get():GetClubScore()/self.RankingData[dataIndex+1].data.C_ID)
    end
    if self.SelectIdx==2 then
        CommonHelper:SetText("###rewardname",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceClub3V3RewardSelfScore,self.RankingData[dataIndex+1].data.C_ID))
        CommonHelper:SetText("###progress",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceClub3V3RewardProgress,RaceClub3V3Manager:Get():GetSelfScore(),self.RankingData[dataIndex+1].data.C_ID))
        CommonHelper:SetSlider("SliderBaseColor",itemObj,RaceClub3V3Manager:Get():GetSelfScore()/self.RankingData[dataIndex+1].data.C_ID)
    end
    CommonHelper:HButtonSetCallback("BtnGet",itemObj,function(data)
        if self.SelectIdx==1 then
            RaceClub3v3Subsystem:Get():SendMsg_GetClubReward(data.intData)
        end
        if self.SelectIdx==2 then
            RaceClub3v3Subsystem:Get():SendMsg_GetSelfReward(data.intData)
        end
    end,self.RankingData[dataIndex+1].index)
    local rewards=self.RankingData[dataIndex+1].rewards
    for i = 1, 3 do
        local item= CommonHelper:SetGameObjectActive("reward"..i.."/ItemCom_118",itemObj,rewards[i]~=nil)
        if rewards[i] then
            local param = Param_ItemArticleParam()
            param.count = rewards[i].num
            CommonHelper:SetItemComGroup(item, UIModuleID.RaceClub3V3Reward,rewards[i].id,param,function(btnData)
                CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.RaceClub3V3Reward)
            end,rewards[i].id)
        end
    end
end


