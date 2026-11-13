
local _GameObject=nil
local _View=nil
local this=nil
local SetData={}
local CurItem=-1
local tempDropId={}
local tempFinishDropId={}
function SelfChallengeCreateView:SetRewardOpen(gameObject)
    _GameObject=gameObject
    _View=self.gameObject
    this=self
    --print(_GameObject.name)
    --print(_View.name)
    SetData={}
    CommonHelper:SetText("NpcTips",_View,CommonHelper:GetTempStr_Default(TemplateStringID.SelfChallengeNoPassReward))
    CommonHelper:HButtonSetCallback("BtnRandom",_GameObject,function (data)
        SetData={}
        local  data=SelfChallengeDataManager:Get():GetSelfChallengeData(SelfChallengeDataManager:Get().SelectId)
        local dropReward={}
        if data~=nil then
            for i, v in pairs(data.dropReward) do
                local group=CommonHelper:GetTableDataByID(ConfigNames.group_config,v)
                local temp=stringSplitToNumber(group.groupIds,',')
                local index=math.random(1,#temp)
                --print(index..":index")
                table.insert(dropReward,temp[index])
            end
            --for k, v in pairs(dropReward) do
            --    print(v,"dddddddddddddddddd")
            --end
            table.insert(SetData,dropReward)
            for i, v in pairs(data.needSetLv) do
                local tempreward={}
                for j, k in pairs(data.finishRewards[v]) do
                    local group=CommonHelper:GetTableDataByID(ConfigNames.group_config,k)
                    local temp=stringSplitToNumber(group.groupIds,',')
                    local index=math.random(1,#temp)
                    -- print(index..":index")
                    table.insert(tempreward,temp[index])
                end
                table.insert(SetData,tempreward)
            end

            SelfChallengeDataManager:Get()._DropRewards=tempDropId
            SelfChallengeDataManager:Get()._FinishRewards=tempFinishDropId
            CommonHelper:MoreRowView_RefreshCurList(self.scrollView,false)
        end
    end)
    self.scrollView=UIUtil.GetTypeChildWightByParent("MoreRowScrollView_V",_GameObject,typeof(MoreRowScrollView))
    ---@type SelfChallengeData
    local data=SelfChallengeDataManager:Get():GetSelfChallengeData(SelfChallengeDataManager:Get().SelectId)
    local list={}
    local lvList={}
    if data~=nil then
        table.insert(SetData,SelfChallengeDataManager:Get()._DropRewards)
        for i = 1, #data.needSetLv do
           local v= SelfChallengeDataManager:Get()._FinishRewards[data.needSetLv[i]]
            table.insert(SetData,v)
        end
        local rewardData=data.dropReward
        local finishRewards=data.finishRewards
        ---@type table<number,table<number,number>>
        table.insert(list,rewardData)
        for i, v in pairs(finishRewards) do
            table.insert(list,v)
            table.insert(lvList,i)
        end
        table.sort(lvList,function(a, b) return a<b end)
    end

    CommonHelper:InitMoreRowScrollView(self.scrollView,#list,1,function (index, itemObj,scroll)

        if index~=0 then
            CommonHelper:SetText("title",itemObj,string.format("关卡%d奖励",lvList[index]))
        end

        local btn= CommonHelper:HButtonSetCallback("BtnSelectOrChange",itemObj,function (data)

              CurItem=data.intData
              UIManager:Get():OpenPopup("SelfChallengeSelectRewardView",CanvasType.MainCanvas ,"SelfChallengeSelectRewardView")
              UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeSelectRewardSetData,list[index+1])

        end,index+1)

        local partComponent1=UIUtil.GetChild("ArticleCompoent1",itemObj)
        local partComponent2=UIUtil.GetChild("ArticleCompoent2",itemObj)
        local partComponent3=UIUtil.GetChild("ArticleCompoent3",itemObj)
        if  SetData[index+1]~=nil and #SetData[index+1]>=1 then
            local dropId1=SetData[index+1][1]
            local dropId2=SetData[index+1][2]
            local dropId3=SetData[index+1][3]
            --print(dropId1,dropId2,dropId3,"sssssssssssssss")
            if index==0 then
                tempDropId={dropId1,dropId2,dropId3}
            else
                tempFinishDropId[lvList[index]]={dropId1,dropId2,dropId3}
            end

            -----@type table <number,RewardData>
            local rewardData1= CommonHelper:GetRewardByDropId(tonumber(dropId1))
            local rewardData2= CommonHelper:GetRewardByDropId(tonumber(dropId2))
            local rewardData3= CommonHelper:GetRewardByDropId(tonumber(dropId3))
         --   print(rewardData1[1].id,rewardData2[1].id,rewardData3[1].id,"article")
            if rewardData1~=nil then
                --print(rewardData1,rewardData2,rewardData3)
                local articleData1= CommonHelper:GetTableDataByID(ConfigNames.article_config,rewardData1[1].id)
                if articleData1 ~=nil then
                    local param=Param_ArticleGroup()
                    param.moduleId = UIModuleID.SelfChallenge
                    param.articleId = articleData1.id
                    param.count = 1

                    param.showname = false
                    param.showcount = false

                    param.icon = articleData1.icon..".png"
                    param.name = articleData1.name
                    param.quality = articleData1.difficulty
                    param.isGray=false
                    param.isFragment = false
                    CommonHelper:SetArticleGroup(partComponent1,param)
                    CommonHelper:SetGameObjectActive("noreward",partComponent1,false)
                else
                    CommonHelper:SetGameObjectActive("noreward",partComponent1,true)
                end
            end
           if rewardData2~=nil then
                local articleData2= CommonHelper:GetTableDataByID(ConfigNames.article_config,rewardData2[1].id)
               if articleData2 ~=nil then
                   local param=Param_ArticleGroup()
                   param.moduleId = UIModuleID.SelfChallenge
                   param.articleId = articleData2.id
                   param.count = 1

                   param.showname = false
                   param.showcount = false

                   param.icon = articleData2.icon..".png"
                   param.name = articleData2.name
                   param.quality = articleData2.difficulty
                   param.isGray=false
                   param.isFragment = false
                   CommonHelper:SetArticleGroup(partComponent2,param)
                   CommonHelper:SetGameObjectActive("noreward",partComponent2,false)
               else
                   CommonHelper:SetGameObjectActive("noreward",partComponent2,true)
               end
            end
           if rewardData3~=nil then
                local articleData3= CommonHelper:GetTableDataByID(ConfigNames.article_config,rewardData3[1].id)
               if articleData3 ~=nil then
                   local param=Param_ArticleGroup()
                   param.moduleId = UIModuleID.SelfChallenge
                   param.articleId = articleData3.id
                   param.count = 1

                   param.showname = false
                   param.showcount = false

                   param.icon = articleData3.icon..".png"
                   param.name = articleData3.name
                   param.quality = articleData3.difficulty
                   param.isGray=false
                   param.isFragment = false
                   CommonHelper:SetArticleGroup(partComponent3,param)
                   CommonHelper:SetGameObjectActive("noreward",partComponent3,false)
               else
                   CommonHelper:SetGameObjectActive("noreward",partComponent3,true)
               end
            end
            CommonHelper:SetText("text",btn.gameObject,"更换")
        else
          --  print("SSSSSSSSSSSSSSSSSSSSSSS")
            CommonHelper:SetGameObjectActive("noreward",partComponent1,true)
            CommonHelper:SetGameObjectActive("noreward",partComponent2,true)
            CommonHelper:SetGameObjectActive("noreward",partComponent3,true)
            CommonHelper:SetText("text",btn.gameObject,"选择")
        end
    end)
end

function SelfChallengeCreateView:SetRewardClose()
    --print(_GameObject,"关闭")
    --for i = 1, #tempDropId do
    --   -- print("tenmp",tempDropId[i])
    --end
    --for i = 1, #tempDropId do
    --    --print("tenmp",tempDropId[i])
    --end

    SelfChallengeDataManager:Get()._DropRewards=tempDropId
    SelfChallengeDataManager:Get()._FinishRewards=tempFinishDropId
end
function SelfChallengeCreateView:SetRewardClearData()
    tempDropId={}
    tempFinishDropId={}
end
function SelfChallengeCreateView:OnSetRewardBack(data)
   --print(data[1],data[2],data[3],"set")
   SetData[CurItem]=data

   CommonHelper:MoreRowView_RefreshCurList(self.scrollView,false)
end