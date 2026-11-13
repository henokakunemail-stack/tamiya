
local _GameObject=nil
local _View=nil
local this=nil
local BtnChangeOrSelect=nil
local NoSelect=nil
local CurTickets=nil
function SelfChallengeCreateView:SelectTicketsOpen(gameObject)
    _GameObject=gameObject
    _View=self.gameObject

    print(_GameObject.name)

    CommonHelper:SetText("NpcTips",_View,CommonHelper:GetTempStr_Default(TemplateStringID.SelfChallengeHitSelectTickets))
    NoSelect= self:GetChildByParent("noSelect",_GameObject)

    BtnChangeOrSelect=CommonHelper:HButtonSetCallback("BtnChangeOrSelect",_GameObject,function (data)

        UIManager:Get():OpenPopup("SelfChallengeSelectTicketsView",CanvasType.MainCanvas,"SelfChallengeSelectTicketsView")

    end)
    print(SelfChallengeDataManager:Get().SelectId)
    if SelfChallengeDataManager:Get().SelectId~=nil then
        NoSelect:SetActive(false)
        CommonHelper:SetText("text",BtnChangeOrSelect.gameObject,"更换")
        self:OnSelectTicketsBack(SelfChallengeDataManager:Get().SelectId)
    else
        NoSelect:SetActive(true)
        CommonHelper:SetText("text",BtnChangeOrSelect.gameObject,"选择")
        local moreRowScrollView=self:GetChildWightByParent("MoreRowScrollView_V",_GameObject,typeof(MoreRowScrollView))
        CommonHelper:InitMoreRowScrollView(moreRowScrollView,0,1,function (index, itemObj,scroll)

        end)
    end
end
function SelfChallengeCreateView:SelectTicketsClose()
    print(_GameObject,"关闭")
    if CurTickets~=nil then
        SelfChallengeDataManager:Get().SelectId=CurTickets
    end
end
function SelfChallengeCreateView:SelectTicketsClearData()
    CurTickets=nil
end
function SelfChallengeCreateView:OnSelectTicketsBack(id)

    local tickets= self:GetChildByParent("CustomItem",_GameObject)

    NoSelect:SetActive(false)
    CommonHelper:SetText("text",BtnChangeOrSelect.gameObject,"更换")
    ---@type SelfChallengeData
    local data=SelfChallengeDataManager:Get():GetSelfChallengeData(id )
    CurTickets=data.id
    local cfg= CommonHelper:GetTableDataByID(ConfigNames.article_config,data.articleId)

    local param=Param_ArticleGroup()
    param.moduleId = UIModuleID.SelfChallenge
    param.articleId = cfg.id
    param.count = 1

    param.showname = false
    param.showcount = false

    param.icon = cfg.icon..".png"
    param.name = cfg.name
    param.quality = data.difficulty
    param.isGray=false
    param.isFragment = false
    CommonHelper:SetArticleGroup(tickets,param)

    local diffImg=CommonHelper:GetSelfChallengeDifferentIcon(data.difficulty)

    CommonHelper:GetComponentSetImage("difficulty",tickets,diffImg,UIModuleID.SelfChallenge)

    local use=self:GetChildByParent("use",tickets)

    local moreRowScrollView=self:GetChildWightByParent("MoreRowScrollView_V",_GameObject,typeof(MoreRowScrollView))
    local flockRewardsKey={}
    table.insert(flockRewardsKey,-1)
    for i, v in pairs(data.flockRewards) do
        table.insert(flockRewardsKey,i)
    end
    table.sort(flockRewardsKey,function(a, b) return a<b end)
    CommonHelper:InitMoreRowScrollView(moreRowScrollView,#flockRewardsKey,1,function (index, itemObj,scroll)
        local flockReward=nil
        if index==0 then
            flockReward=data.holdReward
            CommonHelper:SetText("Text",itemObj,"举办赛事成功")
        else
            flockReward=data.flockRewards[flockRewardsKey[index+1]]
            CommonHelper:SetText("Text",itemObj,string.format("累计<color=#FF0000>%d</color>参赛",flockRewardsKey[index+1]))
        end
        local PartCompoent= UIUtil.GetChild("ArticleCompoent",itemObj)
        print("dropId",flockReward)
        ---@type table<number,RewardData>
        local articleIds=CommonHelper:GetRewardByDropId(flockReward)

        if articleIds~=nil then
            local articleData= CommonHelper:GetTableDataByID(ConfigNames.article_config,articleIds[1].id)
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
                CommonHelper:SetArticleGroup(PartCompoent,param)
            end
        end
    end)

end

