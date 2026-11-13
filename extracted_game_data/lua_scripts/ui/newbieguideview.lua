---@class NewBieGuideView:ViewBase
NewBieGuideView = class("NewBieGuideView", ViewBase)
function NewBieGuideView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "NewBieGuideAction")
end
local IsShow=false
---@type newbieguide_config_cell
local stepData=nil
---@type newbieguide_config_cell
local laststepData=nil

local isWaitText=false
function NewBieGuideView:Awake()
    self.buttonRoot=self:GetChildWight("buttonRoot",typeof(RectTransform))
    self.hitClickEffect=self:GetChild("guidehead")
    self.GuideDesc=self:GetChild("GuidePerson")
    self.canvasGroup =UIUtil.GetGameobjectComponent(self.gameObject,typeof(CanvasGroup))
    self.RectGuidance =self:GetChildWight("RectMask",typeof(RectGuidanceController))
    self.CircleGuidance =self:GetChildWight("CircleMask",typeof(CircleGuidanceController))
    self.TweenClick =self:GetChildWight("TweenPostionClick",typeof(FXUITweenMoreGroup))
    self.TweenPerson =self:GetChildWight("TweenPostionPerson",typeof(FXUITweenMoreGroup))
    self.TweenHead =self:GetChildWight("TweenPostionHead",typeof(FXUITweenMoreGroup))

    self.BtnSkip=CommonHelper:HButtonSetCallback("BtnSkip",self.gameObject,function(data)
        NewBieGuideDataManager:Get().StepState=GuideStepState.End
        UINotify:Get():SendNotification(UINotifyEvent.EndNewbieGuide)
        if stepData.triggerType==GuideTriggerType.NetStep then
            MonoHelper.ContinueToBattle()
            CommonHelper:SetHButtonClick(self.BtnSkip,false,true)
            self:StopTimer()
        else
            if self.ClickButton and  self.ClickButton.onPointDown~=nil then
                self.ClickButton:CallPointDownFunction()
            end
            if stepData.complettype==GuideCompletType.PlayVideo then
                self:PlayVideo()
            else
                self:ResetGuideButton()
            end
        end
        self:ExecuteNextGuide()
    end)
    --黑
   self.BtnCloseMask= CommonHelper:HButtonSetCallback("BtnCloseMask2",self.gameObject,function(data)
        NewBieGuideDataManager:Get().StepState=GuideStepState.End
        UINotify:Get():SendNotification(UINotifyEvent.EndNewbieGuide)
        if stepData.triggerType==GuideTriggerType.Battle  then
           MonoHelper.ContinueToBattle()
        end
       self:ExecuteNextGuide()
    end)
    --透明
    self.BtnCloseMask= CommonHelper:HButtonSetCallback("BtnCloseMask1",self.gameObject,function(data)
        NewBieGuideDataManager:Get().StepState=GuideStepState.End
        UINotify:Get():SendNotification(UINotifyEvent.EndNewbieGuide)
        if stepData.triggerType==GuideTriggerType.Battle  then
           MonoHelper.ContinueToBattle()
        end
       self:ExecuteNextGuide()
    end)
    self.StepTimeCount=0
end

function NewBieGuideView:StartNewBieGuide(data)
    if not IsShow then
        UIManager:Get():ShowPersistentView("NewbieGuideView",CanvasType.MainCanvas,"NewBieGuideView",false,true)
    end
    if stepData then
        laststepData=stepData
    end
    CommonHelper:SetGameObjectActive("defaultmask",self.gameObject,true)
    ---@type newbieguide_config_cell
    stepData=self:EnterCurStep()
    UIUtil.ShowCanvasGroup(self.canvasGroup,true)
    self:SetCollider()
    self:SetBtnCloseMask()
    cs_coroutine.start( function()
        log("1111111111111--->>>>",stepData.UiName,stepData.id)
        CommonHelper:SetDoText("###tips",self.GuideDesc,"")
        CommonHelper:SetText("###clickhit",self.GuideDesc,"")
        if stepData.triggerType==GuideTriggerType.Battle then
            UIUtil.ShowCanvasGroup(self.canvasGroup,true)
        else
            if stepData.UiName=="-1" then
                if stepData.complettype==GuideCompletType.OpenView then
                    UINotify:Get():SendNotification(UINotifyEvent.EndNewbieGuide)
                    self:ExecuteNextGuide()
                end
                if stepData.complettype==GuideCompletType.OpenPopupClose then
                    self:OnOpenPopup()
                end
            else
                coroutine.yield(CS.UnityEngine.WaitForSeconds(0.4))
                self.guideObj= GameObject.Find(stepData.UiName)
                --self.
                if self.guideObj==nil then
                    return
                end
                if stepData.Scrolltype==ScrollViewType.None then
                    UIUtil.SetParentGameObject(self.guideObj.transform.parent,self.buttonRoot,false)
                    self.buttonRoot:LocalIdentity()
                    UIUtil.SetParentGameObject(self.buttonRoot,self.guideObj,false)
                end
                if stepData.complettype== GuideCompletType.OpenView then
                    UIUtil.ShowCanvasGroup(self.canvasGroup,false)
                    UIManager:Get():HidePersistentView("NewbieGuideView")
                    UINotify:Get():SendNotification(UINotifyEvent.UpdateNewBieGuideList)
                elseif stepData.complettype==GuideCompletType.Click or stepData.complettype==GuideCompletType.PlayVideo  then
                    local isScroll=false
                    if stepData.Scrolltype~=ScrollViewType.None and stepData.Scrolltype~=ScrollViewType.Custom then
                        isScroll=true
                        self.guideObj= self:OnScrollView(self.guideObj,stepData.Scrolltype,stepData.ScrollIndex)
                        self.ClickButton=UIUtil.GetChild(stepData.completCon,self.guideObj)
                        self.GuideButton=UIUtil.GetChild(stepData.completCon,self.guideObj)
                    end
                    if stepData.ScrollViewName~="-1" then
                        isScroll=true
                        log("111111-------->",stepData.ScrollViewName)
                        local  scrollRect= GameObject.Find(stepData.ScrollViewName)
                        self:ScrollRectClose(scrollRect)
                        self:MoveToItem(stepData.Scrolltype,scrollRect,stepData.ScrollIndex)
                        coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
                        log("2222222--->>>>",stepData.UiName,stepData.ScrollViewName)
                    end
                    if isScroll then
                        UIUtil.SetParentGameObject(self.guideObj.transform.parent,self.buttonRoot,false)
                        self.buttonRoot:LocalIdentity()
                        UIUtil.SetParentGameObject(self.buttonRoot,self.guideObj,false)
                    end
                    self.GuideButton= UIUtil.GetChild(stepData.completCon,self.buttonRoot)
                    self.ClickButton=UIUtil.GetGameobjectComponent(self.GuideButton,typeof(HButton))
                    self.ClickButton:SetComponentEnable(false)

                    self:OnClick()
                    self:OnPointDown()

                    self.ListenerBtn=UIUtil.GetGameobjectComponent(self.GuideButton.gameObject,typeof(GuideButton))
                    self.gameObject.transform:SetAsLastSibling()
                    self:SetHitEffectPos()
                end
            end
        end
        self:OnMaskAnim()
        coroutine.yield(CS.UnityEngine.WaitForSeconds(0.08))
        CommonHelper:SetGameObjectActive("guidehead",self.gameObject,stepData.ArrowTowards==GuideStepArrowTowards.Type_1)
        CommonHelper:SetGameObjectActive("GuidePerson",self.gameObject,stepData.Desc~="-1")
        self:SetGuidePersonPos()
        if isWaitText then
            coroutine.yield(CS.UnityEngine.WaitForSeconds(0.8))
        end
        CommonHelper:SetDoText("###tips",self.GuideDesc,ClientDataManager:Get():GetTemplateString(stepData.Desc),0.8)
        CommonHelper:SetText("###clickhit",self.GuideDesc,ClientDataManager:Get():GetTemplateString(stepData.Desc))
        coroutine.yield(CS.UnityEngine.WaitForSeconds(0.5))
        CommonHelper:SetGameObjectActive("defaultmask",self.gameObject,false)
        NewBieGuideDataManager:Get().StepState=GuideStepState.Reallying
    end)
    return stepData.triggerPara
end

function NewBieGuideView:CheckStepTime()
    self.StepTimeCount=self.StepTimeCount+1
    if self.StepTimeCount>2  then
        CommonHelper:CloseGuideScreenEffectUIMask()
    end
    if self.StepTimeCount>30 and stepData.interfaceID~="BattleStartView" then
        CommonHelper:SetHButtonClick(self.BtnSkip,true,true)
    end
end
function NewBieGuideView:OnPointDown()
    if self.ClickButton.onPointDown~=nil then
        GuideButton.Get(self.GuideButton.gameObject):SetPointerDownHandler(function(go)
            if  self.ClickButton.onPointDown~=nil then
                self.ClickButton:CallPointDownFunction()
            end
            NewBieGuideDataManager:Get().StepState=GuideStepState.End
            UINotify:Get():SendNotification(UINotifyEvent.EndNewbieGuide)
            self.ClickButton:SetComponentEnable(true)
            self.ClickButton=nil
            self:ExecuteNextGuide()
        end)
    end

    --if self.ClickButton.onPointUp~=nil then
    --    GuideButton.Get(self.GuideButton.gameObject):SetPointerUpHandler(function(go)
    --        if self.ClickButton and self.ClickButton.onPointUp~=nil then
    --            self.ClickButton.onPointUp(self.ClickButton)
    --            self.ClickButton:SetComponentEnable(true)
    --            self.ClickButton=nil
    --        end
    --    end)
    --end
end

function NewBieGuideView:OnClick()
    if  self.ClickButton.onLuaClickAction~=nil then
        GuideButton.Get(self.GuideButton.gameObject):SetClickEventHandler(function(go)
            NewBieGuideDataManager:Get().StepState=GuideStepState.End
            UINotify:Get():SendNotification(UINotifyEvent.EndNewbieGuide)
            if stepData.complettype==GuideCompletType.PlayVideo then
                self:PlayVideo()
            else
                self:ResetGuideButton()
            end
            self:ExecuteNextGuide()
        end)
    end
end
function NewBieGuideView:OnOpenPopup()
    local OpenPopupName=stringSplit(stepData.OpenPopupName,',')
    if OpenPopupName[1]=="EncyclopediaView" then
        local type=tonumber(OpenPopupName[2])
        CommonHelper:OpenEncyclopedia(type,function()
            UINotify:Get():SendNotification(UINotifyEvent.EndNewbieGuide)
            self:ExecuteNextGuide()
        end)
    end
end
function NewBieGuideView:PlayVideo()
    CommonHelper:PlayerVideo(stepData.videoName, function()
        self:ResetGuideButton()
    end)
end
function NewBieGuideView:ResetGuideButton()
    if self.ClickButton and self.ClickButton.onLuaClickAction~=nil then
         self.ClickButton:CallClickFunction()
        self.ClickButton:SetComponentEnable(true)
        self.ClickButton=nil
    end
end

function NewBieGuideView:SetGuidePersonPos()
    isWaitText=false
    UIUtil:GameobjectLocalPositionY(self.GuideDesc, stepData.NPCPosY)
    UIUtil:GameobjectLocalPositionX(self.GuideDesc, stepData.NPCPosX)
    CommonHelper:SetGameObjectActive("person1",self.gameObject,stepData.NPC==1)
    CommonHelper:SetGameObjectActive("person2",self.gameObject,stepData.NPC==2)
    if laststepData then
        if laststepData.NPC==-1 or stepData.triggerType~=GuideTriggerType.NetStep then
            isWaitText=true
            CommonHelper:TMG_PlayAllTween(self.TweenPerson)
        end
    else
        isWaitText=true
        CommonHelper:TMG_PlayAllTween(self.TweenPerson)
    end
end

function NewBieGuideView:SetCollider()
    CommonHelper:SetGameObjectActive("collider",self.gameObject,stepData.Iscollider==1)
end

function NewBieGuideView:SetBtnCloseMask()
    CommonHelper:SetGameObjectActive("BtnCloseMask1",self.gameObject,stepData.dialogMask==GuideDialogType.Alpha_0 and(stepData.triggerType==GuideTriggerType.Battle or stepData.complettype==GuideCompletType.ClickMask))
    CommonHelper:SetGameObjectActive("BtnCloseMask2",self.gameObject,stepData.dialogMask==GuideDialogType.Black and(stepData.triggerType==GuideTriggerType.Battle or stepData.complettype==GuideCompletType.ClickMask))
end
function NewBieGuideView:ResetGuidePersonPos()
    CommonHelper:SetGameObjectActive("person1",self.gameObject,false)
    CommonHelper:SetGameObjectActive("person2",self.gameObject,false)
    UIUtil:GameobjectLocalPositionY(self.GuideDesc, -10000)
end

function NewBieGuideView:SetHitEffectPos()
    self.hitClickEffect.transform.position = RectTransformExtensions.GetRectTransformCenterPostion(UIUtil.GetGameobjectComponent(self.GuideButton.gameObject,typeof(RectTransform)))
    CommonHelper:TMG_PlayAllTween(self.TweenHead)
end
function NewBieGuideView:ResetHitEffectPos()
    UIUtil:GameobjectLocalPositionX(self.hitClickEffect, -10000)
end

function NewBieGuideView:ExecuteNextGuide()
    local nextstepData=NewBieGuideDataManager:Get():GetCurGuideStep()
    if nextstepData then
        if nextstepData.triggerType==GuideTriggerType.NetStep then
            UINotify:Get():SendNotification(UINotifyEvent.StartNewBieGuide)
        else
            self:ResetGuidePersonPos()
        end
    end
end

function NewBieGuideView:EndNewBieGuide()

    UIUtil.ShowCanvasGroup(self.canvasGroup,false)
    self:StopTimer()
    CommonHelper:PlayGuideScreenEffectUIMask()
    CommonHelper:SetGameObjectActive("RectMask",self.gameObject,false)
    CommonHelper:SetGameObjectActive("CircleMask",self.gameObject,false)
    NewBieGuideDataManager:Get().ClickCount=NewBieGuideDataManager:Get().ClickCount+1
    if self.guideObj ~= nil  then
        UIUtil.SetParentGameObject(self.buttonRoot.transform.parent,self.guideObj,false)
        UIUtil.SetParentGameObject(self.gameObject,self.buttonRoot,false)
        self.guideObj = nil
    end
    if self.ListenerBtn then
        self.ListenerBtn:SetComponentEnable(false)
    end

    UIManager:Get():HidePersistentView("NewbieGuideView")
    CommonHelper:SetHButtonClick(self.BtnSkip,false,true)
    UINotify:Get():SendNotification(UINotifyEvent.UpdateNewBieGuideList)
    if self.ScrollRect then
        CommonHelper:ScrollViewEnableDrag(self.ScrollRect,self.TempScrollRectH,self.TempScrollRectV)
    end
    self.ScrollRect=nil

end

function NewBieGuideView:CloseGuide()
    UIManager:Get():CloseView()
    if self.canvasGroup~=nil then
        UIUtil.ShowCanvasGroup(self.canvasGroup,false)
    end
    if self.GuideButton ~= nil  then
        UIUtil.SetParentGameObject(self.buttonRoot.transform.parent,self.GuideButton,false)
        UIUtil.SetParentGameObject(self.gameObject,self.buttonRoot,false)
        self.GuideButton = nil
    end
    UIUtil:GameobjectLocalPositionX(self.hitClickEffect, -10000)
end

function NewBieGuideView:OnOpen()
    IsShow=true
end

function NewBieGuideView:OnClose()
    IsShow=false
end
function NewBieGuideView:AutoClose()
    IsShow=false
end

function NewBieGuideView:OnScrollView(scrollViewObj,type,index)
    local scrollView=nil
    local result=nil
    if type==ScrollViewType.Normal then
        scrollView=UIUtil.GetGameobjectComponent(scrollViewObj,typeof(MoreRowScrollView))
        result=CommonHelper:MoreRowView_GetItemObj(scrollView,index)
    elseif type==ScrollViewType.Tittle then
        scrollView=UIUtil.GetGameobjectComponent(scrollViewObj,typeof(TitleScrollView))
        --result=CommonHelper:MoreRowView_GetItemObj(scrollView,index)
    elseif type==ScrollViewType.Custom then
        scrollView=UIUtil.GetGameobjectComponent(scrollViewObj,typeof(CustomScrollView))
        --result=CommonHelper:MoreRowView_GetItemObj(scrollView,index)
    elseif type==ScrollViewType.Level then
        scrollView=UIUtil.GetGameobjectComponent(scrollViewObj,typeof(LevelListScrollView))
        result=CommonHelper:LevelListView_GetItemObj(scrollView,index)
    elseif type==ScrollViewType.Carousel then
        scrollView=UIUtil.GetGameobjectComponent(scrollViewObj,typeof(CarouselScrollView))
    elseif type==ScrollViewType.LevelTree then
        scrollView=UIUtil.GetGameobjectComponent(scrollViewObj,typeof(LevelMapScrollView))
        result=CommonHelper:LevelMapView_GetItemById(scrollView,index)
    end
    self:MoveToItem(type,scrollViewObj,index)
    self:ScrollRectClose(scrollViewObj)
    return result
end

function NewBieGuideView:MoveToItem(type,scrollViewObj,index)
    if type==ScrollViewType.Normal then

    elseif type==ScrollViewType.Tittle then

    elseif type==ScrollViewType.Custom then
        local  scrollView=UIUtil.GetGameobjectComponent(scrollViewObj,typeof(CustomScrollView))
        CommonHelper:CustomView_ScrollToItem(scrollView,index)
    elseif type==ScrollViewType.Level then

    elseif type==ScrollViewType.Carousel then

    elseif type==ScrollViewType.LevelTree then

    end
end

function NewBieGuideView:ScrollRectClose(scrollViewObj)
    self.ScrollRect= UIUtil.GetGameobjectComponent(scrollViewObj,typeof(ScrollRect))
    self.TempScrollRectH,self.TempScrollRectV=CommonHelper:ScrollViewEnableDrag(self.ScrollRect,false,false)
end

function    NewBieGuideView:EnterCurStep()
    self:StopTimer()
    CommonHelper:SetHButtonClick(self.BtnSkip,false,true)
    self.StepTimeCount=0
    self.StepTime=TimerManager:Get():CreateTimerLoop(1,function (class)
        class:CheckStepTime()
    end,self)
    NewBieGuideDataManager:Get().StepState=GuideStepState.Enter
    local stepData=NewBieGuideDataManager:Get():GetCurGuideStep()
    return stepData
end

function NewBieGuideView:OnMaskAnim()
    if self.guideObj==nil then
        return
    end
    if stepData.maskAnim==GuideAnimType.Rect then
        self.RectGuidance:SetTarget(self.guideObj)
    end
    if stepData.maskAnim==GuideAnimType.Circle then
        self.CircleGuidance:SetTarget(self.guideObj)
    end
    CommonHelper:SetGameObjectActive("RectMask",self.gameObject,stepData.maskAnim==GuideAnimType.Rect)
    CommonHelper:SetGameObjectActive("CircleMask",self.gameObject,stepData.maskAnim==GuideAnimType.Circle)
end

function NewBieGuideView:ExitCurGuide()
    NewBieGuideDataManager:Get().StepState=GuideStepState.End
    UINotify:Get():SendNotification(UINotifyEvent.EndNewbieGuide)
    self:ExecuteNextGuide()
end

function NewBieGuideView:StopTimer()
    if self.StepTime then
        TimerManager:Get():StopTimer(self.StepTime)
        self.StepTime=nil
    end
end

function NewBieGuideView:OnBackKey()

end