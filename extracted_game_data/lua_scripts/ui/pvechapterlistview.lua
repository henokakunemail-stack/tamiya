

---@class PveChapterListView : ViewBase
PveChapterListView = class("PveChapterListView", ViewBase)
-- （1普通关卡；2精英关卡；3BOSS关卡；4剧情关卡）

function PveChapterListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "PveChapterListViewAction")
end

function PveChapterListView:Awake()
    log("---   ChapterListView awake")

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHome",self.gameObject,function (hbtn)
        SkipModuleHelper:Get():BackToMainMenuView(true)
    end)
    self.BtnRewardBtn= CommonHelper:HButtonSetCallback("BtnRewardBtn",self.gameObject,function (hbtn)
        UIManager:Get():OpenPopup("PveChapterRewardView", CanvasType.FrontCanvas, "PveChapterRewardView")
        UINotify:Get():SendNotification(UINotifyEvent.PVEChapterRewardView_SetData,{self.chapterData.id,self.chapterData.chapterType})
    end)

    self.ScrollView = UIUtil.GetTypeChildWightByParent("LevelMapScrollView",self.gameObject,typeof(LevelMapScrollView))

    self.BtnProb=CommonHelper:HButtonSetCallback("BtnProb",self.gameObject,function (hbtn)

        CommonHelper:ShowHelpView(self.chapterData.PropId,nil,HelpStyleType.BlueStyle)
    end)
    CommonHelper:SetHButtonClick(self.BtnProb,HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.BtnProb),true)
    ---@type PVEChapterData
    self.chapterData = nil
end

function PveChapterListView:OnOpen()
   self:ClearLuaViewInfo()
end
function PveChapterListView:ReOpen()
   self:RefreshLevelList()
    if self:GetLuaViewInfo("PveChapterLevelInfoView") then
        UINotify:Get():SendNotification(UINotifyEvent.PVEChapterListView_SetViewInfo,{"PveChapterLevelInfoView",true})
        UIManager:Get():OpenPopup("PveChapterLevelInfoView",CanvasType.MainCanvas,"PveChapterLevelInfoView")
        UINotify:Get():SendNotification(UINotifyEvent.PVEChapterLevelInfoView_SetData)
    end
end

function PveChapterListView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.ChapterList)
end
function PveChapterListView:OnOpenAnimEnd()
    self:CheckTriggerGuide(GuideTriggerType.OpenAnimEnd)
end
function PveChapterListView:SetData(id)
    self.chapterData = PVEChapterDataManager:Get():GetChapterDataByID(id)
    CommonHelper:SetText("###chaptername",self.gameObject,self.chapterData.name)
    self:SetScrollView()
    self:SetBoxSlider()
    self:CheckTriggerGuide(GuideTriggerType.OpenView)
end
function PveChapterListView:CheckTriggerGuide(triggerType)
    if GuideManager:Get():GetCurGuideStep() and triggerType==GuideManager:Get():GetCurGuideStep():GetTriggerType() then
        self:CheckNewBieGuide()
    end
end
function PveChapterListView:RefreshLevelList()
    self.chapterData = PVEChapterDataManager:Get():GetChapterDataByID(self.chapterData.id)
    CommonHelper:LevelMapView_Refresh(self.ScrollView)
    self:SetBoxSlider()
end

function PveChapterListView:SetScrollView()

    local data=self.chapterData:CreateTestLevelMapData()
    CommonHelper:LevelMapView_Init(self.ScrollView, data,false, function(dataIndex, itemObj, scroll)
        ---@type PVELevelData
        local levelData=self.chapterData:GetLevelDataById(dataIndex)
        local levelCfg=levelData.levelCfg

        local easy= CommonHelper:SetGameObjectActive("easy",itemObj,levelCfg.copytype==LevelType.Normal or levelCfg.copytype==LevelType.GuideLevel)
        local hard= CommonHelper:SetGameObjectActive("hard",itemObj,levelCfg.copytype==LevelType.Elite)
        local boss= CommonHelper:SetGameObjectActive("boss",itemObj,levelCfg.copytype==LevelType.Boss)
        local story=CommonHelper:SetGameObjectActive("story",itemObj,levelCfg.copytype==LevelType.Story)
        local levelObj=nil
        if levelData.levelCfg.copytype==LevelType.Normal or levelCfg.copytype==LevelType.GuideLevel then
            levelObj=easy
        end
        if levelData.levelCfg.copytype==LevelType.Elite then
            levelObj=hard
        end
        if levelData.levelCfg.copytype==LevelType.Boss then
            levelObj=boss
        end
        if levelData.levelCfg.copytype==LevelType.Story then
            levelObj=story
        end
        if levelData.levelCfg.copytype~=LevelType.Story then
            local unlock= CommonHelper:SetGameObjectActive("unlock",levelObj,not levelData.isLock)
            local lock= CommonHelper:SetGameObjectActive("lock",levelObj,levelData.isLock)
            CommonHelper:SetGameObjectActive("openstart",levelObj,levelData.OpenStar~=0)
            CommonHelper:SetText("###limitvalue",levelObj,levelData.OpenStar)
            CommonHelper:SetGameObjectActive("lockstar",levelObj,levelData.OpenStar>0)
            CommonHelper:SetGameObjectActive("passlevel",levelObj,false)
            local lastLvelId=PlayerPrefsHelper:GetValue_PveChapterLevelRally()
            CommonHelper:SetGameObjectActive("fxrally",levelObj,levelData.id==lastLvelId )
            CommonHelper:GetComponentSetUITexture("icon",unlock,levelCfg.levelicon,UIModuleID.PveChapter)
            CommonHelper:GetComponentSetUITexture("icon",lock,levelCfg.levelicon,UIModuleID.PveChapter)
            local star=nil
            if not levelData.isLock then
                if (not levelData.isLock or ( levelCfg.copytype==LevelType.GuideLevel and levelData.starNum>0))and levelData.MaxStar<=3 then
                    CommonHelper:SetGameObjectActive("ThreeStar",levelObj,false)
                    CommonHelper:SetGameObjectActive("SixStar",levelObj,false)
                    star= CommonHelper:SetGameObjectActive("ThreeStar",levelObj,not levelData.isLock or ( levelCfg.copytype==LevelType.GuideLevel and levelData.starNum>0) )
                    --star= CommonHelper:SetGameObjectActive("ThreeStar",levelObj,false )
                end
                if (not levelData.isLock or ( levelCfg.copytype==LevelType.GuideLevel and levelData.starNum>0))and levelData.MaxStar>3 then
                    CommonHelper:SetGameObjectActive("ThreeStar",levelObj,false)
                    CommonHelper:SetGameObjectActive("SixStar",levelObj,false)
                    star= CommonHelper:SetGameObjectActive("SixStar",levelObj,not levelData.isLock or ( levelCfg.copytype==LevelType.GuideLevel and levelData.starNum>0) )
                    --star= CommonHelper:SetGameObjectActive("SixStar",levelObj,false )
                end
            else
                CommonHelper:SetGameObjectActive("ThreeStar",levelObj,false)
                CommonHelper:SetGameObjectActive("SixStar",levelObj,false)
            end
            CommonHelper:SetGameObjectActive("ThreeStar",levelObj,false)
            CommonHelper:SetGameObjectActive("SixStar",levelObj,false)
            self:SetStar(levelData.starNum,star,levelData.MaxStar)
            star= CommonHelper:SetGameObjectActive("PassNum",levelObj,not levelData.isLock)
            self:SetStarNum(levelData.starNum,star,levelData.MaxStar)
        else
            CommonHelper:SetGameObjectActive("redpoint",levelObj,levelData.winSum<LevelType.Story_Pass and not levelData.isLock)
        end
       local btn=  CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function(hbth)
           if not levelData.isLock then
               local temp= self.chapterData:GetLevelDataById(hbth.intData)
               if temp.levelCfg.copytype~=LevelType.Story then
                --   SkipModuleHelper:Get():ToSelectCarView(RaceModel.Battle,temp)
                   PlayerPrefsHelper:SetValue_PveChapterLevelRally(hbth.intData)
                   ChapterSubsystem:Get():SendMsg_GetChapterRank(hbth.intData,0)
               else
                   if temp.winSum<LevelType.Story_Pass then
                       StoryHelper:TouchStory_SelectTeam(temp.id, function()
                           ChapterSubsystem:Get():SendMsg_BattleFinish(temp.id,0,1,0,0,0,0,0)
                       end)
                   else
                       StoryHelper:TouchStory_SelectTeam(hbth.intData, function()
                           --
                       end)
                   end

               end
           else
               CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.LevelLock))
           end

        end,dataIndex)
       -- CommonHelper:SetHButtonClick(btn,not levelData.isLock,false)
    end)
    if not CommonHelper:CheckPlayerIsNewGuide() and PlayerPrefsHelper:GetValue_PveChapterLevelRally()~=0 then
         CommonHelper:LevelMapView_MoveToItem(self.ScrollView,PlayerPrefsHelper:GetValue_PveChapterLevelRally(),false)
    end
end

function PveChapterListView:SetStar(num,parent,MaxStar)
    for i = 1, MaxStar do
        CommonHelper:SetGameObjectActive("star"..i,parent,num>=i)
    end
end
function PveChapterListView:SetStarNum(num,parent,MaxStar)
    CommonHelper:SetGameObjectActive("textbg1",parent,num>=MaxStar)
    CommonHelper:SetGameObjectActive("textbg2",parent,num<MaxStar)
    CommonHelper:SetGameObjectActive("star1",parent,num>0)
    CommonHelper:SetText("###count",parent,string.format("%d/%d",num,MaxStar))
end

function PveChapterListView:SetBoxState()
    self:SetBoxSlider()
  -- CommonHelper:RefreshBoxStateSlider(self.BoxStateSlider)
end

function PveChapterListView:SetBoxSlider()
    local isRedPoint=false
    for i = 1, #self.chapterData.BoxData do
        if self.chapterData.BoxData[i].state==LevelBoxState.CanReceive then
            isRedPoint=true
            break
        end
    end
    CommonHelper:SetGameObjectActive("redpoint",self.BtnRewardBtn.gameObject,isRedPoint)

    local lastRewardNum=self.chapterData.process
    for i = 1, #self.chapterData.starNums do
        if self.chapterData.starNums[i]>lastRewardNum then
            lastRewardNum=self.chapterData.starNums[i]
            break
        end
    end
    local str = ClientDataManager:Get():GetTemplateString(TemplateStringID.PartReforLimitFormat)
    str = string.format(str, self.chapterData.process, lastRewardNum)
    CommonHelper:SetText("###chapter_reward", self.gameObject , str)

    local per = self.chapterData.process / self.chapterData.MaxStar
    CommonHelper:SetSlider("SliderBaseColor", self.gameObject, per)

    str = ClientDataManager:Get():GetTemplateString(TemplateStringID.PartReforLimitFormat)
    str = string.format(str, self.chapterData.process, self.chapterData.MaxStar)
    CommonHelper:SetText("###processvalue", self.gameObject , str)
end


--
