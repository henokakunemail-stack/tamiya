
local _GameObject=nil
local _View=nil
local this=nil
function SelfChallengeCreateView:PreviewViewOpen(gameObject)

    _GameObject=gameObject
    _View=self.gameObject
    this=self
    print(_GameObject.name)
    print(_View.name)
    CommonHelper:SetText("NpcTips",_View,CommonHelper:GetTempStr_Default(TemplateStringID.SelfChallengeSetGameName))
    self.scrollView=UIUtil.GetTypeChildWightByParent("CustomScrollViewTtoM",_GameObject,typeof(CustomScrollView))
    local selfChallengeData=SelfChallengeDataManager:Get():GetSelfChallengeData(SelfChallengeDataManager:Get().SelectId)
    local dataindex={0,0}
    local data={0,1}
    if selfChallengeData~=nil then
        for i = 1, #selfChallengeData.needSetLv do
            if  SelfChallengeDataManager:Get()._SelectScenes[selfChallengeData.needSetLv[i]]~=nil then
                table.insert(data,2)
                table.insert(dataindex,i)
            end
        end
        table.insert(data,3)
        table.insert(dataindex,0)
        if SelfChallengeDataManager:Get():CheckSelectDropReward() then
            table.insert(data,4)
            table.insert(dataindex,0)
        end
        for i = 1, #selfChallengeData.needSetLv do
            if  SelfChallengeDataManager:Get()._FinishRewards[selfChallengeData.needSetLv[i]]~=nil then
                table.insert(data,5)
                table.insert(dataindex,i)
            end
        end
    end

    local curIndex=1;
    CommonHelper:CustomView_Init(self.scrollView, data, function(index, itemObj, scroll)
        ---------------------------------------------------------------------------
        if data[index+1]==0 then
            self.Name=UIUtil.GetTypeChildWightByParent("raceNameInput",itemObj,typeof(InputField))
        end
        ---------------------------------------------------------------------------
        if data[index+1]==1 then
            if SelfChallengeDataManager:Get()._SelectDays~=nil then
                CommonHelper:SetText("chaptertime",itemObj,string.format("%d天",SelfChallengeDataManager:Get()._SelectDays))
            end
            if SelfChallengeDataManager:Get()._SelectPassNum~=nil then
                CommonHelper:SetText("chapternum",itemObj,string.format("%d关",SelfChallengeDataManager:Get()._SelectPassNum))
            end

          --print(SelfChallengeDataManager:Get()._SelectType,"1111111111111111")
            if SelfChallengeDataManager:Get()._SelectType~=nil and SelfChallengeDataManager:Get()._SelectType~=0 then
                CommonHelper:SetText("chapterType",itemObj,string.format(CommonHelper:GetTrackTypeById(SelfChallengeDataManager:Get()._SelectType)))
            end
            if SelfChallengeDataManager:Get()._SelectDifficulty~=nil then
                local diffImg= CommonHelper:GetSelfChallengeDifferentIcon(SelfChallengeDataManager:Get()._SelectDifficulty)
                CommonHelper:GetComponentSetImage("difficulty",itemObj,diffImg,UIModuleID.SelfChallenge)
            end
        end
        ------------------------------------------------------------------------------------
        if data[index+1]==2 then
            local lv=selfChallengeData.needSetLv[dataindex[index+1]]
            CommonHelper:SetText("title",itemObj,string.format("困难关%d",lv))
            local sceneId= SelfChallengeDataManager:Get()._SelectScenes[lv]
            local trackid=SelfChallengeDataManager:Get()._SelectTracks[lv]
            local  scenecfg=CommonHelper:GetTableDataByID(ConfigNames.scene_config,sceneId)
            CommonHelper:GetComponentSetUITexture("sceneIcon",itemObj,scenecfg.icon,UIModuleID.SelfChallenge)
            local name=ClientDataManager:Get():GetTemplateString(scenecfg.name)
            local trackData=CommonHelper:GetRacetrackData(trackid)
            CommonHelper:SetText("sceneandtrackname",itemObj,string.format("%s-%s",name,trackData:GetName()))
            CommonHelper:GetComponentSetTrackIconByData("trackIcon",itemObj,trackData,UIModuleID.SelfChallenge)
            local npcComponent1=UIUtil.GetChild( "NpcComponent1",itemObj)
            local npcComponent2=UIUtil.GetChild("NpcComponent2",itemObj)
            local npcComponent3=UIUtil.GetChild("NpcComponent3",itemObj)
            local npcComponent4=UIUtil.GetChild("NpcComponent4",itemObj)
            local Npc=SelfChallengeDataManager:Get()._SelectNpcs[lv]
            local param1=Param_NPCGroup()
            param1.moduleId=UIModuleID.SelfChallenge
            param1.use=false
            param1.lock=false
            param1.add=true
            param1.showBtn=true
            local param2=Param_NPCGroup()
            param2.moduleId=UIModuleID.SelfChallenge
            param2.use=false
            param2.lock=false
            param2.add=true
            param2.showBtn=true
            local param3=Param_NPCGroup()
            param3.moduleId=UIModuleID.SelfChallenge
            param3.use=false
            param3.lock=false
            param3.add=true
            param3.showBtn=true
            local param4=Param_NPCGroup()
            param4.moduleId=UIModuleID.SelfChallenge
            param4.use=false
            param4.lock=false
            param4.add=true
            param4.showBtn=true
            if Npc~=nil then
                local Npc1=Npc[1]
                if Npc1 ~=nil then
                    local cfg=CommonHelper:GetTableDataByID(ConfigNames.npc_config,Npc1)
                    local hero= CommonHelper:GetTableDataByID(ConfigNames.hero_config,cfg.hero)
                    param1.carId=cfg.carId
                    param1.npcId=cfg.npcId
                    param1.quality=cfg.quality
                    param1.npcIcon=hero.picture..".png"
                    param1.name=cfg.name
                    param1.add=false
                    param1.lock=false
                end
                local Npc2=Npc[2]
                if Npc2 ~=nil then
                    local cfg=CommonHelper:GetTableDataByID(ConfigNames.npc_config,Npc2)
                    local hero= CommonHelper:GetTableDataByID(ConfigNames.hero_config,cfg.hero)
                    if cfg~=nil then
                        param2.carId=cfg.carId
                        param2.npcId=cfg.npcId
                        param2.quality=cfg.quality
                        param2.npcIcon=hero.picture..".png"
                        param2.name=cfg.name
                        param2.add=false
                        param2.lock=false
                    end
                end
                local Npc3=Npc[3]
                if Npc3 ~=nil then
                    local cfg=CommonHelper:GetTableDataByID(ConfigNames.npc_config,Npc3)
                    local hero= CommonHelper:GetTableDataByID(ConfigNames.hero_config,cfg.hero)
                    if cfg~=nil then
                        param3.carId=cfg.carId
                        param3.npcId=cfg.npcId
                        param3.quality=cfg.quality
                        param3.npcIcon=hero.picture..".png"
                        param3.name=cfg.name
                        param3.add=false
                        param3.lock=false
                    end
                end
                local Npc4=Npc[4]
                if Npc4 ~=nil then
                    local cfg=CommonHelper:GetTableDataByID(ConfigNames.npc_config,Npc4)
                    local hero= CommonHelper:GetTableDataByID(ConfigNames.hero_config,cfg.hero)
                    if cfg~=nil then
                        param4.carId=cfg.carId
                        param4.npcId=cfg.npcId
                        param4.quality=cfg.quality
                        param4.npcIcon=hero.picture..".png"
                        param4.name=cfg.name
                        param4.add=false
                        param4.lock=false
                    end
                end
            end
            if trackData~=nil then
                print(trackData.numbers)
                if trackData.numbers==3 then
                    param3.lock=true
                    param3.add=false
                    param3.showBtn=false
                    param4.lock=true
                    param4.add=false
                    param4.showBtn=false
                end
            end
            CommonHelper:SetNpcGroup(npcComponent1,param1)
            CommonHelper:SetNpcGroup(npcComponent2,param2)
            CommonHelper:SetNpcGroup(npcComponent3,param3)
            CommonHelper:SetNpcGroup(npcComponent4,param4)
           -- CommonHelper:SetText("sceneandtrackname",itemObj,cfg)
        end
        --------------------------------------------------------------------------------------------------
        if data[index+1]==3 then
           print(selfChallengeData.flockRewards)
           print(selfChallengeData.holdReward)
            local PartCompoent1= UIUtil.GetChild("ArticleCompoent1",itemObj)
            local PartCompoent2= UIUtil.GetChild("ArticleCompoent2",itemObj)
            local PartCompoent3= UIUtil.GetChild("ArticleCompoent3",itemObj)
            local flockRewardValues={}
            for i, v in pairs(selfChallengeData.flockRewards) do
                table.insert(flockRewardValues,v)
            end
            local flockReward1=flockRewardValues[1]
            local flockReward2=flockRewardValues[2]

            ---@type table<number,RewardData>
            local articleIds1=CommonHelper:GetRewardByDropId(selfChallengeData.holdReward)
            local articleIds2=CommonHelper:GetRewardByDropId(flockReward1)
            local articleIds3=CommonHelper:GetRewardByDropId(flockReward2)


            if articleIds1~=nil then
                local articleData= CommonHelper:GetTableDataByID(ConfigNames.article_config,articleIds1[1].id)
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
                    CommonHelper:SetArticleGroup(PartCompoent1,param)
                end
            end
            if articleIds2~=nil then
                local articleData= CommonHelper:GetTableDataByID(ConfigNames.article_config,articleIds2[1].id)
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
                    CommonHelper:SetArticleGroup(PartCompoent2,param)
                end
            end
            if articleIds3~=nil then
                local articleData= CommonHelper:GetTableDataByID(ConfigNames.article_config,articleIds3[1].id)
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
                    CommonHelper:SetArticleGroup(PartCompoent3,param)
                end
            end
        end
        ---------------------------------------------------------------------------------------------------
        if  data[index+1]==4 then
             print(SelfChallengeDataManager:Get()._DropRewards)
            local PartCompoent1= UIUtil.GetChild("ArticleCompoent1",itemObj)
            local PartCompoent2= UIUtil.GetChild("ArticleCompoent2",itemObj)
            local PartCompoent3= UIUtil.GetChild("ArticleCompoent3",itemObj)
            local dropReward=selfChallengeData.dropReward
            local articleIds1=CommonHelper:GetRewardByDropId(SelfChallengeDataManager:Get()._DropRewards[1])
            local articleIds2=CommonHelper:GetRewardByDropId(SelfChallengeDataManager:Get()._DropRewards[2])
            local articleIds3=CommonHelper:GetRewardByDropId(SelfChallengeDataManager:Get()._DropRewards[3])


            if articleIds1~=nil then
                local articleData= CommonHelper:GetTableDataByID(ConfigNames.article_config,articleIds1[1].id)
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
                    CommonHelper:SetArticleGroup(PartCompoent1,param)
                end
            end
            if articleIds2~=nil then
                local articleData= CommonHelper:GetTableDataByID(ConfigNames.article_config,articleIds2[1].id)
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
                    CommonHelper:SetArticleGroup(PartCompoent2,param)
                end
            end
            if articleIds3~=nil then
                local articleData= CommonHelper:GetTableDataByID(ConfigNames.article_config,articleIds3[1].id)
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
                    CommonHelper:SetArticleGroup(PartCompoent3,param)
                end
            end
        end
        -----------------------------------------------------------------------------------------------------
        if data[index+1]==5 then
            local lv=selfChallengeData.needSetLv[dataindex[index+1]]
            CommonHelper:SetText("title",itemObj,string.format("困难关%d奖励",lv))
            local finishReward= SelfChallengeDataManager:Get()._FinishRewards[lv]
            local PartCompoent1= UIUtil.GetChild("ArticleCompoent1",itemObj)
            local PartCompoent2= UIUtil.GetChild("ArticleCompoent2",itemObj)
            local PartCompoent3= UIUtil.GetChild("ArticleCompoent3",itemObj)
            local dropReward=selfChallengeData.dropReward

            local articleIds1=CommonHelper:GetRewardByDropId(finishReward[1])
            local articleIds2=CommonHelper:GetRewardByDropId(finishReward[2])
            local articleIds3=CommonHelper:GetRewardByDropId(finishReward[3])


            if articleIds1~=nil then
                local articleData= CommonHelper:GetTableDataByID(ConfigNames.article_config,articleIds1[1].id)
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
                    CommonHelper:SetArticleGroup(PartCompoent1,param)
                end
            end
            if articleIds2~=nil then
                local articleData= CommonHelper:GetTableDataByID(ConfigNames.article_config,articleIds2[1].id)
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
                    CommonHelper:SetArticleGroup(PartCompoent2,param)
                end
            end
            if articleIds3~=nil then
                local articleData= CommonHelper:GetTableDataByID(ConfigNames.article_config,articleIds3[1].id)
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
                    CommonHelper:SetArticleGroup(PartCompoent3,param)
                end
            end
        end
    end)

end


function SelfChallengeCreateView:PreviewViewClose()
    print(_GameObject,"关闭")

end

function SelfChallengeCreateView:CommitParam()
    print("提交","关闭")
    ---@type SelfChallengeData
    local data= SelfChallengeDataManager:Get():GetSelfChallengeData(SelfChallengeDataManager:Get().SelectId)
    SelfChallengeDataManager:Get()._Name=self.Name.text
    if data==nil then
        CommonTipsHelper:Get():ShowCenterTips("请选择关卡挑战劵")
    elseif not SelfChallengeDataManager:Get():CheckSelectDays(data.lastDays)then
        CommonTipsHelper:Get():ShowCenterTips("请选择比赛持续时间")
    elseif not SelfChallengeDataManager:Get():CheckSelectPassNum(data.barrierNums) then
        CommonTipsHelper:Get():ShowCenterTips("请选择关卡数量")
    elseif not SelfChallengeDataManager:Get():CheckSelectType() then
        CommonTipsHelper:Get():ShowCenterTips("请选择关卡类型")
    elseif not SelfChallengeDataManager:Get():CheckSelectDifficulty() then
        CommonTipsHelper:Get():ShowCenterTips("请选择关卡难度")
    elseif not SelfChallengeDataManager:Get():CheckSelectScene(data.needSetLv) then
        CommonTipsHelper:Get():ShowCenterTips("请选择场景")
    elseif not SelfChallengeDataManager:Get():CheckSelectTrack(data.needSetLv) then
        CommonTipsHelper:Get():ShowCenterTips("请选择赛道")
    elseif not SelfChallengeDataManager:Get():CheckSelectNpcs(data.needSetLv) then
        CommonTipsHelper:Get():ShowCenterTips("请选择关卡Npc")
    elseif not SelfChallengeDataManager:Get():CheckSelectDropReward() then
        CommonTipsHelper:Get():ShowCenterTips("请选择掉落奖励")
    elseif not SelfChallengeDataManager:Get():CheckSelectFinishReward(data.needSetLv) then
        CommonTipsHelper:Get():ShowCenterTips("请选择通关奖励")
    elseif not SelfChallengeDataManager:Get():CheckChallengeName() then
        CommonTipsHelper:Get():ShowCenterTips("请设置名字")
    else
        SelfChallengeDataManager:Get():CommitParam()
    end


end