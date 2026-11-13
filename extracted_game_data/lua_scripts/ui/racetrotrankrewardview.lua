---@class RaceTrotRankRewardView : ViewBase
RaceTrotRankRewardView = class("RaceTrotRankRewardView", ViewBase)

function RaceTrotRankRewardView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceTrotRankRewardViewAction")
end

function RaceTrotRankRewardView:Awake()
    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_H", self.gameObject, typeof(MoreRowScrollView))
end

function RaceTrotRankRewardView:OnOpen()
    self:SetData()
end
function RaceTrotRankRewardView:ReOpen()

end


function RaceTrotRankRewardView:OnOpenAnimEnd()

end
function RaceTrotRankRewardView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceTrotReward)
end
function RaceTrotRankRewardView:OnAutoClose()

end

function RaceTrotRankRewardView:SetData()
    ---@type dictseasonspeedaward_config
    local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictfastaward_config)
    ---@type dictseasonspeedaward_config_cell[]
    local rewards=  cfg.GetDataBySeasonid(RaceTrotManager:Get():GetSeasonId())
    table.sort(rewards,function(a, b)
        return a.speedfrom<b.speedfrom
    end)
    self.RankingData={}
    for i = 1, #rewards do
        local temp={}
        temp.rank=rewards[i].speedfrom
        temp.rewards=CommonHelper:SetDataByStrIdAndNum(rewards[i].awardids,rewards[i].awardnums)
        if rewards[i].speedfrom ~=rewards[i].speedto  then
            temp.rank= CommonHelper:GetTempStr_Default(TemplateStringID.RankRewardShow,rewards[i].speedfrom,rewards[i].speedto)
        end
        table.insert(self.RankingData,temp)
    end
    self:SetScrollView()
end
function RaceTrotRankRewardView:SetScrollView()
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #self.RankingData, 1,function(dataIndex, itemObj, scroll)
        self:UpdateScrollView(dataIndex, itemObj)
    end)
end
function RaceTrotRankRewardView:UpdateScrollView(dataIndex, itemObj)
    self:SetItem(dataIndex+1 ,self.RankingData[dataIndex+1].rank,self.RankingData[dataIndex+1].rewards,itemObj)
end

function RaceTrotRankRewardView:SetItem(ranking,rankStr,rewards,parent)
    CommonHelper:SetGameObjectActive("first",parent,tonumber(ranking)==1)
    CommonHelper:SetGameObjectActive("second",parent,tonumber(ranking)==2)
    CommonHelper:SetGameObjectActive("third",parent,tonumber(ranking)==3)
    CommonHelper:SetGameObjectActive("normal",parent,ranking>3)
    CommonHelper:SetText("###value",parent,rankStr)
    for i = 1, 6 do
        local item= CommonHelper:SetGameObjectActive("reward"..i.."/ItemCom_118",parent,rewards[i]~=nil)
        if rewards[i] then
            local param = Param_ItemArticleParam()
            param.count = rewards[i].num
            CommonHelper:SetItemComGroup(item, UIModuleID.RaceTrotReward,rewards[i].id,param,function(btnData)
                CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.RaceTrotReward)
            end,rewards[i].id)
        end
    end

end

