---@class ChallengeMathRankingListRewardView : ViewBase
ChallengeMathRankingListRewardView = class("ChallengeMathRankingListRewardView", ViewBase)

function ChallengeMathRankingListRewardView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ChallengeMathRankingListRewardViewAction")
end

function ChallengeMathRankingListRewardView:Awake()
    CommonHelper:HButtonSetCallback("BtnCloseMask",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_H", self.gameObject, typeof(MoreRowScrollView))
end

function ChallengeMathRankingListRewardView:OnOpen()
    self:SetData()
end

function ChallengeMathRankingListRewardView:OnClose()

end

function ChallengeMathRankingListRewardView:SetData()
    ---@type dictbattleaward_config
    local cfg= ClientDataManager:Get():GetDataTable(ConfigNames.dictbattleaward_config)
    ---@type dictbattleaward_config_cell[]
    local rewards=  cfg.GetTableDataByAwardId(tonumber(ChallengeMatchManager:Get():GetCurRoom().battles[1].awardid))
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
function ChallengeMathRankingListRewardView:SetScrollView()
    CommonHelper:InitMoreRowScrollView(self.ScrollView, #self.RankingData, 1,function(dataIndex, itemObj, scroll)
        self:UpdateScrollView(dataIndex, itemObj)
    end)
end
function ChallengeMathRankingListRewardView:UpdateScrollView(dataIndex, itemObj)
    self:SetItem(dataIndex+1 ,self.RankingData[dataIndex+1].rank,self.RankingData[dataIndex+1].rewards,itemObj)
end

function ChallengeMathRankingListRewardView:SetItem(ranking,rankStr,rewards,parent)
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
            CommonHelper:SetItemComGroup(item, UIModuleID.RankingList,rewards[i].id,param,function(btnData)
                CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.RankingList)
            end,rewards[i].id)
        end
    end

end
