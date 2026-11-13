--⏰
---@class SelfChallengeSelfGameListView : ViewBase
SelfChallengeSelfGameListView = class("SelfChallengeSelfGameListView", ViewBase)
function SelfChallengeSelfGameListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SelfChallengeSelfGameListViewAction")
end
local _Data=nil
local _SelectCURIndex=-1
function SelfChallengeSelfGameListView:Awake()

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function ()
        UIManager:Get():CloseView()
    end)

    CommonHelper:HButtonSetCallback("BtnFilter",self.gameObject,function ()
        UIManager:Get():OpenPopup("SelfChallengeFilterView",CanvasType.MainCanvas,"SelfChallengeFilterView")
    end)

    CommonHelper:HButtonSetCallback("BtnEnter",self.gameObject,function ()
        if _Data[_SelectCURIndex]==1 then
            ---@type SelfChallengeData
            local data=SelfChallengeDataManager:Get():GetSelfGameData()[_SelectCURIndex]
            if data~=nil then
                if data.curLevel>data.lvNum then
                    CommonTipsHelper:Get():ShowCenterTips("已通关无法重复")
                --elseif data.subDay>0 then
                --    CommonTipsHelper:Get():ShowCenterTips("该赛事已经结束无法参加")
                else
                    SelfChallengeSubsystem:Get():SendGetSelfChallengeInfo(data.id)
                end
            else
                CommonTipsHelper:Get():ShowCenterTips("请选择要参加的挑战赛")
            end
        end
    end)

    self.CustomScrollView=self:GetChildWight("CustomScrollViewTtoM",typeof(CustomScrollView))
end

function SelfChallengeSelfGameListView:SetData(defaultIndex)
    local gameList=SelfChallengeDataManager:Get():GetSelfGameData()
    _Data={2,2,2}
    local count=0
    for i = 1, #_Data do
        local v=gameList[i]
        if v~=nil then
            if v.isCompile then
                _Data[i]=0
                count=count+1
            end
        end
    end
    for i, v in pairs(gameList) do

    end
    CommonHelper:SetText("myGameNum",self.gameObject,string.format("%d/%d",count,3))
    if defaultIndex>0 and defaultIndex <=#_Data  and  _Data[defaultIndex]==0 then
        _SelectCURIndex=defaultIndex
        _Data[defaultIndex]=1
    end

   CommonHelper:CustomView_Init(self.CustomScrollView,_Data,function (index, itemObj, scroll)
       UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeSelfGameListUpdateScrollView,{index,itemObj,scroll})
   end)
    
end

function SelfChallengeSelfGameListView:UpdateScrollItem(index,itemObj,scroll)
    ---@type SelfChallengeData
    local data=SelfChallengeDataManager:Get():GetSelfGameData()[index+1]
    if _Data[index+1]==0 then
        CommonHelper:SetText("racename",itemObj,data.name)
        CommonHelper:SetText("playername",itemObj,data.masterName)
        CommonHelper:SetText("chapterType",itemObj,CommonHelper:GetTrackTypeById(data.trackType))
        if data.curLevel<=data.lvNum then
            CommonHelper:SetText("chapterNum",itemObj,string.format("%d/%d",data.curLevel,data.lvNum))
        else
            CommonHelper:SetText("chapterNum",itemObj,string.format("%d/%d","已通关"))
        end
        CommonHelper:GetComponentSetImage("chapterDifficulty",itemObj,CommonHelper:GetSelfChallengeDifferentIcon(data.difficulty),UIModuleID.SelfChallenge)
        if data.subDay>0 then
            CommonHelper:SetText("subTime",itemObj,string.format("已结束%d天",data.subDay))
        else
            CommonHelper:SetText("subTime",itemObj,string.format("剩余%d天",-data.subDay))
        end

        local data= SelfChallengeDataManager:Get():GetSelfChallengeDataByTicket(data.tickets)
        local component=UIUtil.GetChild("PartOrArtcleComponent",itemObj)
        local  group=CommonHelper:GetRewardByDropId(data.holdReward)
        local param=Param_PartOrArticleParam()
        param.moduleId=UIModuleID.SelfChallenge
        param.count=group[1].num
        param.id=group[1].id
        param.showcount=true
        param.showname=false
        CommonHelper:SetPartOrArticleGroup(component,param)

    end
    if _Data[index+1]==1 then
        CommonHelper:SetText("racename",itemObj,data.name)
        CommonHelper:SetText("playername",itemObj,data.masterName)
        CommonHelper:SetText("chapterType",itemObj,CommonHelper:GetTrackTypeById(data.trackType))
        if data.curLevel<=data.lvNum then
            CommonHelper:SetText("chapterNum",itemObj,string.format("%d/%d",data.curLevel,data.lvNum))
        else
            CommonHelper:SetText("chapterNum",itemObj,string.format("%d/%d","已通关"))
        end

        CommonHelper:GetComponentSetImage("chapterDifficulty",itemObj,CommonHelper:GetSelfChallengeDifferentIcon(data.difficulty),UIModuleID.SelfChallenge)
       -- local day=math.modf(data.endTime/1000/60/60/24)
        if data.subDay>0 then
            CommonHelper:SetText("subTime",itemObj,string.format("已结束%d天",data.subDay))
        else
            CommonHelper:SetText("subTime",itemObj,string.format("剩余%d天",-data.subDay))
        end

        local temp= SelfChallengeDataManager:Get():GetSelfChallengeDataByTicket(data.tickets)
        CommonHelper:SetSlider("Slider1",itemObj,data.joinNum/temp.joinCounts[4])
      --  local data=CommonHelper:GetTableDataByID(ConfigNames.selfchallenge_config,data.tickets)
        local component=UIUtil.GetChild("PartOrArtcleComponent",itemObj)
        local  group=CommonHelper:GetRewardByDropId(temp.holdReward)
        local param=Param_PartOrArticleParam()
        param.moduleId=UIModuleID.SelfChallenge
        param.count=group[1].num
        param.id=group[1].id
        param.showcount=true
        param.showname=false
        CommonHelper:SetPartOrArticleGroup(component,param)
        local flockRewards=nil
        if temp~=nil then
             flockRewards =temp.flockRewards
        end
        local component=UIUtil.GetChild("PartOrArtcleComponent1",itemObj)
        if flockRewards ~=nil then
        local  group=CommonHelper:GetRewardByDropId(flockRewards[temp.joinCounts[1]])
        local param=Param_PartOrArticleParam()
            if group~=nil then
                param.moduleId=UIModuleID.SelfChallenge
                param.count=group[1].num
                param.id=group[1].id
                param.showcount=true
                param.showname=false
                CommonHelper:SetPartOrArticleGroup(component,param)
            end


        local component=UIUtil.GetChild("PartOrArtcleComponent2",itemObj)
        local  group=CommonHelper:GetRewardByDropId(flockRewards[temp.joinCounts[2]])
        local param=Param_PartOrArticleParam()
            if group~=nil then
                param.moduleId=UIModuleID.SelfChallenge
                param.count=group[1].num
                param.id=group[1].id
                param.showcount=true
                param.showname=false
                CommonHelper:SetPartOrArticleGroup(component,param)
            end
        local component=UIUtil.GetChild("PartOrArtcleComponent3",itemObj)
        local  group=CommonHelper:GetRewardByDropId(flockRewards[temp.joinCounts[3]])
        local param=Param_PartOrArticleParam()
            if group~=nil then
                param.moduleId=UIModuleID.SelfChallenge
                param.count=group[1].num
                param.id=group[1].id
                param.showcount=true
                param.showname=false
                CommonHelper:SetPartOrArticleGroup(component,param)
            end

        local component=UIUtil.GetChild("PartOrArtcleComponent4",itemObj)
        local  group=CommonHelper:GetRewardByDropId(flockRewards[temp.joinCounts[4]])
        local param=Param_PartOrArticleParam()
            if group~=nil then
                param.moduleId=UIModuleID.SelfChallenge
                param.count=group[1].num
                param.id=group[1].id
                param.showcount=true
                param.showname=false
                CommonHelper:SetPartOrArticleGroup(component,param)
            end
        end
        --local Slider1=UIUtil.GetTypeChildWightByParent("Slider1",itemObj,typeof(Slider))
        --Slider1.Value=data.
    end
    CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function (data)

        _SelectCURIndex=data.intData+1
        if _Data[data.intData+1]==2 then
            UIManager:Get():OpenView("SelfChallengeCreateView",CanvasType.MainCanvas,"SelfChallengeCreateView")
        else
            UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeSelfGameListSetData,data.intData+1)
        end
    end,index)

end
function SelfChallengeSelfGameListView:UpdateScrollView()

end

function SelfChallengeSelfGameListView:OnOpen()

end

function SelfChallengeSelfGameListView:OnClose()

end