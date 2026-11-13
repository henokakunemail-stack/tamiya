---@class RaceSeniorTrainListView : ViewBase
RaceSeniorTrainListView = class("RaceSeniorTrainListView", ViewBase)
-- （1普通关卡；2精英关卡；3BOSS关卡；4剧情关卡）

function RaceSeniorTrainListView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceSeniorTrainListViewAction")
end

function RaceSeniorTrainListView:Awake()
    log("---   ChapterListView awake")

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)
    self.BtnRewardBtn= CommonHelper:HButtonSetCallback("BtnRewardBtn",self.gameObject,function (hbtn)
        UIManager:Get():OpenPopup("PveChapterRewardView", CanvasType.FrontCanvas, "PveChapterRewardView")
        UINotify:Get():SendNotification(UINotifyEvent.PVEChapterRewardView_SetData,{self.chapterData.id,self.chapterData.chapterType})
    end)

    self.ScrollView = UIUtil.GetTypeChildWightByParent("LevelMapScrollView",self.gameObject,typeof(LevelMapScrollView))
    self.PartTypeView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView", self.gameObject, typeof(MoreRowScrollView))
    self.BtnProb=CommonHelper:HButtonSetCallback("BtnProb",self.gameObject,function (hbtn)

        CommonHelper:ShowHelpView(self.chapterData.PropId,nil,HelpStyleType.BlueStyle)
    end)
    CommonHelper:SetHButtonClick(self.BtnProb,HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.BtnProb),true)
    ---@type PVEChapterData
    self.chapterData = nil
end

function RaceSeniorTrainListView:OnOpen()

end
function RaceSeniorTrainListView:ReOpen()
    self:RefreshLevelList()
end

function RaceSeniorTrainListView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RaceSeniorTrainList)
end
function RaceSeniorTrainListView:OnOpenAnimEnd()

end
function RaceSeniorTrainListView:SetData(id)
    self.chapterData = RaceSeniorTrainManager:Get():GetChapterDataByID(id)
    CommonHelper:SetText("###chaptername",self.gameObject,self.chapterData.name)
    self:SetScrollView()
    self:SetBoxSlider()
    self:SetChapterPartView()
    cs_coroutine.start(function()
        coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
        self:CheckTriggerGuide(GuideTriggerType.OpenView)
    end)
end
function RaceSeniorTrainListView:CheckTriggerGuide(triggerType)
    if GuideManager:Get():GetCurGuideStep() and triggerType==GuideManager:Get():GetCurGuideStep():GetTriggerType() then
        self:CheckNewBieGuide()
    end
end
function RaceSeniorTrainListView:RefreshLevelList()
    self.chapterData = RaceSeniorTrainManager:Get():GetChapterDataByID(self.chapterData.id)
    CommonHelper:LevelMapView_Refresh(self.ScrollView)
    self:SetBoxSlider()
end
function RaceSeniorTrainListView:SetChapterPartView()
   CommonHelper:SetText("###chaptersenior",self.gameObject,CommonHelper:GetTempStr_Default(self.chapterData.ChapterHide))
   CommonHelper:SetText("passrota/###value",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.PartReforChangeFormat,self.chapterData.PassRate))
    CommonHelper:InitMoreRowScrollView(self.PartTypeView,#self.chapterData.PartList,1,function (index, itemObj,scroll)
        ---@type SpecialTrainingData
        local temp =self.chapterData.PartList[index+1]
        local  typeName=CommonHelper:GetGoodsTypeName(GoodsType1.Part, temp)
        local  icon=CommonHelper:GetGoodsTypeIcon(GoodsType1.Part, temp)
        CommonHelper:SetText("###text",itemObj,typeName)
        CommonHelper:GetComponentSetImage("typeImage",itemObj,icon,UIModuleID.RaceSeniorTrainList)
    end)

end

function RaceSeniorTrainListView:SetScrollView()

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
            local lastLvelId=PlayerPrefsHelper:GetValue_RaceSeniorTrainLevelRally()
            CommonHelper:SetGameObjectActive("fxrally",levelObj,levelData.id==lastLvelId )
            local star=nil
            if not levelData.isLock then
                if (not levelData.isLock or ( levelCfg.copytype==LevelType.GuideLevel and levelData.starNum>0))and levelData.starNum<=3 then
                    CommonHelper:SetGameObjectActive("ThreeStar",levelObj,true)
                    CommonHelper:SetGameObjectActive("SixStar",levelObj,false)
                    CommonHelper:SetGameObjectActive("PassNum",levelObj,false)
                    star= CommonHelper:SetGameObjectActive("ThreeStar",levelObj,not levelData.isLock or ( levelCfg.copytype==LevelType.GuideLevel and levelData.starNum>0) )
                end
                if (not levelData.isLock or ( levelCfg.copytype==LevelType.GuideLevel and levelData.starNum>0))and levelData.starNum>3 then
                    CommonHelper:SetGameObjectActive("ThreeStar",levelObj,false)
                    CommonHelper:SetGameObjectActive("SixStar",levelObj,true)
                    CommonHelper:SetGameObjectActive("PassNum",levelObj,true)
                    star= CommonHelper:SetGameObjectActive("SixStar",levelObj,not levelData.isLock or ( levelCfg.copytype==LevelType.GuideLevel and levelData.starNum>0) )
                end
            else
                CommonHelper:SetGameObjectActive("ThreeStar",levelObj,false)
                CommonHelper:SetGameObjectActive("PassNum",levelObj,false)
                CommonHelper:SetGameObjectActive("SixStar",levelObj,false)
            end
            CommonHelper:GetComponentSetUITexture("icon",unlock,levelCfg.levelicon,UIModuleID.RaceSeniorTrainList)
            CommonHelper:GetComponentSetUITexture("icon",lock,levelCfg.levelicon,UIModuleID.RaceSeniorTrainList )
            self:SetStar(levelData.starNum,star,levelData.MaxStar)
        else
            CommonHelper:SetGameObjectActive("redpoint",levelObj,levelData.winSum<LevelType.Story_Pass and not levelData.isLock )
        end
        local btn=  CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function(hbth)
            if not levelData.isLock then
                local temp= self.chapterData:GetLevelDataById(hbth.intData)
                if temp.levelCfg.copytype~=LevelType.Story then
                    if temp.levelCfg.copytype==LevelType.GuideLevel and temp.starNum>0 then
                        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.GuideLevelIsPass))
                        return
                    end
                    --RaceSeniorTrainManager:Get():SetCurLevelData(temp)
                   -- SkipModuleHelper:Get():ToSelectCarView(RaceModel.RaceSeniorTrain,temp)
                    PlayerPrefsHelper:SetValue_RaceSeniorTrainLevelRally(hbth.intData)
                   RaceSeniorTrainSubsystem:Get():SendMsg_GetChapterRank(hbth.intData)
                else
                    if temp.winSum<LevelType.Story_Pass then
                        StoryHelper:TouchStory_SelectTeam(temp.id, function()
                            RaceSeniorTrainSubsystem:Get():SendMsg_BattleFinish(temp.id,0,1,0,0,0,0)
                        end)
                    else
                        StoryHelper:TouchStory_SelectTeam(hbth.intData, function()
                            --
                        end)
                    end

                end
            else
                if levelCfg.copytype==LevelType.GuideLevel and levelData.starNum>0 then
                    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.GuideLevelIsPass))
                    return
                end
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.LevelLock))
            end

        end,dataIndex)
        -- CommonHelper:SetHButtonClick(btn,not levelData.isLock,false)
    end)
    if not CommonHelper:CheckPlayerIsNewGuide() and PlayerPrefsHelper:GetValue_RaceSeniorTrainLevelRally()~=0 then
        CommonHelper:LevelMapView_MoveToItem(self.ScrollView,PlayerPrefsHelper:GetValue_RaceSeniorTrainLevelRally(),false)
    end
end

function PveChapterListView:SetStar(num,parent,MaxStar)
    for i = 1, MaxStar do
        CommonHelper:SetGameObjectActive("star"..i,parent,num>=i)
    end
end

function RaceSeniorTrainListView:SetBoxState()
    self:SetBoxSlider()
    -- CommonHelper:RefreshBoxStateSlider(self.BoxStateSlider)
end


function RaceSeniorTrainListView:SetBoxSlider()
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
function RaceSeniorTrainListView:OnOpenAnimEnd()
    self:CheckNewBieGuide()
end


--
