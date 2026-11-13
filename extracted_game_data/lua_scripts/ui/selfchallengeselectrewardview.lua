
---@class SelfChallengeSelectRewardView : ViewBase
SelfChallengeSelectRewardView = class("SelfChallengeSelectRewardView", ViewBase)
function SelfChallengeSelectRewardView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SelfChallengeSelectRewardViewAction")
end
local _UseTittleIndex={}
local RewardData={}
local CurData=nil
function SelfChallengeSelectRewardView:Awake()
    CommonHelper:HButtonSetCallback("BgBtn",self.gameObject,function (data)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtCancel",self.gameObject,function (data)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnEnter",self.gameObject,function (data)
        UIManager:Get():ClosePopup()
        local rewardData={}
        for i, v in ipairs(CurData) do
            local tittle="tittle"..v
            local dropId=RewardData[tittle][_UseTittleIndex[tittle]+1]
            dropId=tonumber(dropId)
            table.insert(rewardData,dropId)
        end
        --for i, v in pairs(_UseTittleIndex) do
        --    print(i,v+1,"      222     ")
        --
        --   local dropId=RewardData[i][v+1]
        --   table.insert(rewardData,dropId)
        --end
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetRewardBack,rewardData)
    end)
    self.tittleScrollView=self:GetChildWight("TitleScrollView",typeof(TitleScrollView))
end

function SelfChallengeSelectRewardView:OnOpen()
    --[[
    --local data = {}
    --for i = 1, 5 do
    --    table.insert(data, "tittle"..i)
    --    table.insert(data, math.random(8,20))
    --    _UseTittleIndex["tittle"..i]=0
    --
    --end
    --
    --
    --CommonHelper:InitTitleScrollView(self.tittleScrollView, data, 5,function(title, itemObj, dataIndex, scroll)
    --  --  UINotify:Get():SendNotification(UINotifyEvent.ChangePartView_UpdateScrollView, {title, dataIndex, itemObj})
    --    self:UpdateItem(title, itemObj, dataIndex, scroll)
    --end)
    ]]--
end

local SelectArticleId
function SelfChallengeSelectRewardView:SetData(data)
    local list = {}
    RewardData={}
    _UseTittleIndex={}
    table.sort(data,function(a, b) return a<b end)
    CurData=data
    for i = 1, #data do

        local tittle= "tittle"..data[i]
        table.insert(list, tittle)
        local group=CommonHelper:GetTableDataByID(ConfigNames.group_config,data[i])
        if group~=nil then
            local temp=stringSplitToNumber(group.groupIds,',')
            table.insert(list,#temp)
            RewardData[tittle]=temp
        end

        _UseTittleIndex[tittle]=0

    end
    --for i, v in pairs(RewardData) do
    --    print(i,"tittttt")
    --    for i = 1, #v do
    --        print(v[i].."ssssss")
    --    end
    --end

    CommonHelper:InitTitleScrollView(self.tittleScrollView, list, 5,function(title, itemObj, dataIndex, scroll)
        self:UpdateItem(title, itemObj, dataIndex, scroll)
    end)

end
function SelfChallengeSelectRewardView:UpdateItem(title, itemObj, dataIndex, scroll)

    if dataIndex == -1 then
        CommonHelper:SetText("title",itemObj,title)
        return
    end

    CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function (data)
        _UseTittleIndex[data.stringData]=data.intData
        CommonHelper:TitleScrollView_RefreshCurList(scroll,false)
    end,dataIndex,title)
    --print(RewardData[title][dataIndex],"dropid")
    local dropId=tonumber(RewardData[title][dataIndex+1])
    print(dropId,"dropId")
    -----@type RewardData
     local rewardData= CommonHelper:GetRewardByDropId(dropId)
    print(rewardData)
    if rewardData~=nil then
        local articleData= CommonHelper:GetTableDataByID(ConfigNames.article_config,rewardData[1].id)
        if articleData ~=nil then
            local param=Param_ArticleGroup()
            param.moduleId = UIModuleID.SelfChallenge
            param.articleId = articleData.id
            param.count = 1

            param.showname = false
            param.showcount = false

            param.icon = articleData.icon..".png"
            param.name = articleData.name
            param.quality = articleData.difficulty
            param.isGray=false
            param.isFragment = false
            CommonHelper:SetArticleGroup(itemObj,param)
        end
    end

    local use=self:GetChildByParent("use",itemObj)
    use:SetActive( dataIndex==_UseTittleIndex[title])

end

function SelfChallengeSelectRewardView:tittleScrollView(title, dataIndex, itemObj)

end

function SelfChallengeSelectRewardView:OnClose()

end


