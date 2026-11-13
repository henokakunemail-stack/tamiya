---@class PveChapterRewardView : ViewBase
PveChapterRewardView = class("PveChapterRewardView", ViewBase)

function PveChapterRewardView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "PveChapterRewardViewAction")
end

function PveChapterRewardView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnAllGet",self.gameObject,function (hbtn)
        if self.chapterData.chapterType==PveType.Chapter then
            ChapterSubsystem:Get():SendMsg_GetChapterAllBox(self.chapterData.id)
        end
        if self.chapterData.chapterType==PveType.RaceSeniorTrain then
            RaceSeniorTrainSubsystem:Get():SendMsg_GetChapterAllBox(self.chapterData.id)
        end

    end)
    self.RewardView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_H", self.gameObject, typeof(MoreRowScrollView))
end

function PveChapterRewardView:OnOpen()

end
function PveChapterRewardView:OnClose()
    self:CheckExitNewBieGuide()
    CommonHelper:ReleasePool(UIModuleID.PveChapterReward)
end
function PveChapterRewardView:AutoClose()
    self:CheckExitNewBieGuide()
end




function PveChapterRewardView:SetData(id,type)
    if type==PveType.Chapter then
        ---@type PVEChapterData
        self.chapterData = PVEChapterDataManager:Get():GetChapterDataByID(id)
    end
     if type==PveType.RaceSeniorTrain then
        self.chapterData = RaceSeniorTrainManager:Get():GetChapterDataByID(id)
    end

    self:SetSlider()
    self:SetScrollView()
end
function PveChapterRewardView:SetScrollView()
   CommonHelper:InitMoreRowScrollView(self.RewardView,#self.chapterData.BoxData,1,function(dataIndex, itemObj, scroll)
       local data=self.chapterData.BoxData[dataIndex+1]
       for i = 1, 8 do
          local item= self:GetChildByParent("reward"..i,itemObj)
           if data.rewards[i] then
               local param = Param_ItemArticleParam()
               param.count = data.rewards[i].num
               CommonHelper:SetGameObjectActive("ItemCom_118",item,true)
               CommonHelper:SetItemComGroup(item,UIModuleID.PveChapter,data.rewards[i].id,param)
           else
               CommonHelper:SetGameObjectActive("ItemCom_118",item,false)
           end
       end
       local  Tog=CommonHelper:HButtonSetCallback("TogGet",itemObj,function(hbtn)
           local data=self.chapterData.BoxData[hbtn.intData+1]
           if data.state == LevelBoxState.CanReceive then
               if self.chapterData.chapterType==PveType.Chapter then
                   ChapterSubsystem:Get():SendMsg_GetChapterBox(self.chapterData.id,data.star)
               end
              if self.chapterData.chapterType==PveType.RaceSeniorTrain then
                  RaceSeniorTrainSubsystem:Get():SendMsg_GetChapterBox(self.chapterData.id,data.star)
               end

           end
           if data.state == LevelBoxState.CanNotReceive then
               CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChapterBoxNotGet))
           end
           if data.state == LevelBoxState.ReceiveCompleted then
             CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ChapterBoxHaveGet))
           end
       end,dataIndex)
       local groupValue=data.state==LevelBoxState.ReceiveCompleted and 0.73 or 1
       UIUtil.SetCanvasGroupAlpha("coustom",itemObj,groupValue,data.state~=LevelBoxState.ReceiveCompleted)
       CommonHelper:SetText("###value",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.PveChapterRewardViewStarNum,self.chapterData.starNums[dataIndex+1]))
       CommonHelper:SetToggleState(Tog,data.state==LevelBoxState.CanReceive)
   end)
end
function PveChapterRewardView:SetSlider()
    local per = self.chapterData.process / self.chapterData.MaxStar
    CommonHelper:SetSlider("SliderBaseColor", self.gameObject, per)

    local str = ClientDataManager:Get():GetTemplateString(TemplateStringID.PartReforLimitFormat)
    str = string.format(str, self.chapterData.process, self.chapterData.MaxStar)
    CommonHelper:SetText("###processvalue", self.gameObject , str)
end
function PveChapterRewardView:ReOpen()

end
function PveChapterRewardView:OnClose()

end
