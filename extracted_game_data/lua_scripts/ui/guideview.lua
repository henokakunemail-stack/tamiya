---@class GuideView:ViewBase
GuideView = class("GuideView", ViewBase)
function GuideView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "GuideViewAction")
    ---@type GuideData
    self.GuideData=nil
end
local IsMoveToItem=false
local IsGetItem=false
function GuideView:Awake()
    self.buttonRoot=self:GetChildWight("buttonRoot",typeof(RectTransform))
    self.farem=self:GetChildWight("hitfarem",typeof(RectTransform))
    self.hitClickEffect=self:GetChild("guidehead")
    self.GuideDesc=self:GetChild("GuidePerson")
    self.canvasGroup =UIUtil.GetGameobjectComponent(self.gameObject,typeof(CanvasGroup))
    self.RectGuidance =self:GetChildWight("RectMask",typeof(RectGuidanceController))
    self.CircleGuidance =self:GetChildWight("CircleMask",typeof(CircleGuidanceController))
    self.TweenClick =self:GetChildWight("TweenPostionClick",typeof(FXUITweenMoreGroup))
    self.TweenHead =self:GetChildWight("TweenPostionHead",typeof(FXUITweenMoreGroup))
    self.TweenHeadDrag =self:GetChildWight("TweenPostionHeadDrag",typeof(FXUITweenMoreGroup))
    self.BtnSkip=CommonHelper:HButtonSetCallback("BtnSkip",self.gameObject,function(data)
        GuideManager:Get():Kill()
    end)
    --黑
   CommonHelper:HButtonSetCallback("BtnCloseMask2",self.gameObject,function(data)
       if self.GuideData:GetCompleteType()==GuideCompletType.ClickMask then
           GuideManager:Get():End()
       end
    end)
   CommonHelper:HButtonSetCallback("BtnCloseMask1",self.gameObject,function(data)
       if self.GuideData:GetCompleteType()==GuideCompletType.ClickMask then
           GuideManager:Get():End()
       end
    end)

end

function GuideView:Enter(data)
   self.GuideData=data
   self:Reset()
end

function GuideView:Reset()
    IsMoveToItem=false
    IsGetItem=false
    CommonHelper:SetHButtonClick(self.BtnSkip,false,true)
    CommonHelper:SetDoText("###tips",self.GuideDesc,"")
    CommonHelper:SetText("###clickhit",self.GuideDesc,"")
    if self.GuideData:GetShrinkTime()>0 then
        CommonHelper:SetGameObjectActive("RectMask",self.gameObject,false)
        CommonHelper:SetGameObjectActive("CircleMask",self.gameObject,false)
    end
    CommonHelper:SetGameObjectActive("BtnCloseMask2",self.gameObject,false)
    CommonHelper:SetGameObjectActive("BtnCloseMask1",self.gameObject,false)
    CommonHelper:SetGameObjectActive("guidehead",self.gameObject,false)
    CommonHelper:SetGameObjectActive("draghead",self.gameObject,false)
    CommonHelper:SetGameObjectActive("person1",self.gameObject,false)
    CommonHelper:SetGameObjectActive("person2",self.gameObject,false)
    CommonHelper:SetGameObjectActive("defaultmask",self.gameObject,true)
    CommonHelper:SetGameObjectActive("collider",self.gameObject,true)
end
function GuideView:SetHead()
    CommonHelper:SetGameObjectActive("guidehead",self.gameObject,true)
    local centerPos=CS.RectTransformExtensions.GetRectTransformCenterPostion(UIUtil.GetGameobjectComponent(self.GuideButton.gameObject,typeof(RectTransform)))
    self.hitClickEffect.transform.position = Vector3(centerPos.x,centerPos.y,0+100)
    CommonHelper:TMG_PlayAllTween(self.TweenHead)
end
function GuideView:SetHeadDrag()
    if self.GuideData:GetCompleteType()==GuideCompletType.DropScreenClose then
        CommonHelper:SetGameObjectActive("draghead",self.gameObject,true)
        CommonHelper:TMG_PlayAllTween(self.TweenHeadDrag)
    end
end
function GuideView:SetScrollViewAutoMove()
    if self.GuideData:GetCompleteType()==GuideCompletType.ScrollAutoMoveDone then
        if self.GuideData:GetScrollViewName()~="-1" then
            local  scrollRect= GameObject.Find(self.GuideData:GetScrollViewName())
            self:ScrollRectClose(scrollRect)
            if self.ScrollRect~=nil then
                cs_coroutine.start(function()
                    local speed=0.2
                    local dir=3
                    local back=false
                    if dir==1 then
                        self.ScrollRect.horizontalNormalizedPosition = 0
                    elseif dir==2 then
                        self.ScrollRect.horizontalNormalizedPosition = 1
                    elseif dir==3 then
                        self.ScrollRect.verticalNormalizedPosition = 1
                    elseif dir==4 then
                        self.ScrollRect.verticalNormalizedPosition = 0
                    end
                    coroutine.yield(CS.UnityEngine.WaitForSeconds(1.5))
                    local done=false
                    while not done do
                        if dir==1 then
                            self.ScrollRect.horizontalNormalizedPosition = self.ScrollRect.horizontalNormalizedPosition + speed * 0.02
                            if self.ScrollRect.horizontalNormalizedPosition>=1 then
                                done=true
                            end
                        elseif dir==2 then
                            self.ScrollRect.horizontalNormalizedPosition = self.ScrollRect.horizontalNormalizedPosition - speed * 0.02
                            if self.ScrollRect.horizontalNormalizedPosition<=0 then
                                done=true
                            end
                        elseif dir==3 then
                            self.ScrollRect.verticalNormalizedPosition = self.ScrollRect.verticalNormalizedPosition - speed * 0.02
                            if self.ScrollRect.verticalNormalizedPosition<=0 then
                                done=true
                            end
                        elseif dir==4 then
                            self.ScrollRect.verticalNormalizedPosition = self.ScrollRect.verticalNormalizedPosition + speed * 0.02
                            if self.ScrollRect.verticalNormalizedPosition>=1 then
                                done=true
                            end
                        end
                        coroutine.yield()
                    end
                    if back then
                        coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
                        done=false
                        while not done do
                            if dir==1 then
                                self.ScrollRect.horizontalNormalizedPosition = self.ScrollRect.horizontalNormalizedPosition - speed * 0.02
                                if self.ScrollRect.horizontalNormalizedPosition<=0 then
                                    done=true
                                end
                            elseif dir==2 then
                                self.ScrollRect.horizontalNormalizedPosition = self.ScrollRect.horizontalNormalizedPosition + speed * 0.02
                                if self.ScrollRect.horizontalNormalizedPosition>=1 then
                                    done=true
                                end
                            elseif dir==3 then
                                self.ScrollRect.verticalNormalizedPosition = self.ScrollRect.verticalNormalizedPosition + speed * 0.02
                                if self.ScrollRect.verticalNormalizedPosition>=1 then
                                    done=true
                                end
                            elseif dir==4 then
                                self.ScrollRect.verticalNormalizedPosition = self.ScrollRect.verticalNormalizedPosition - speed * 0.02
                                if self.ScrollRect.verticalNormalizedPosition<=0 then
                                    done=true
                                end
                            end
                            coroutine.yield()
                        end
                    end
                    coroutine.yield(CS.UnityEngine.WaitForSeconds(1.5))
                    if dir==1 then
                        self.ScrollRect.horizontalNormalizedPosition = 0
                    elseif dir==2 then
                        self.ScrollRect.horizontalNormalizedPosition = 1
                    elseif dir==3 then
                        self.ScrollRect.verticalNormalizedPosition = 1
                    elseif dir==4 then
                        self.ScrollRect.verticalNormalizedPosition = 0
                    end
                    GuideManager:Get():End()
                end)
            else
                GuideManager:Get():End()
            end
        end
    end
end

function GuideView:SetVoice()
    if self.GuideData:GetGuideCV()~="-1" then
      --CommonHelper:Audio_PlayAudio(self.GuideData:GetGuideCV(), AudioType.VOICE, false, 1, 0)
    end
end
function GuideView:SetAnim(maskAnim)
    if self.GuideObj==nil then
        return
    end
    if self.GuideData:GetShrinkTime()<=0 then return end
    if maskAnim==GuideAnimType.Rect then
        self.RectGuidance:SetTarget(self.GuideObj)
        self.RectGuidance:Set_shrinkTime(self.GuideData:GetShrinkTime())
    end
    if maskAnim==GuideAnimType.Circle then
        self.CircleGuidance:SetTarget(self.GuideObj)
        self.CircleGuidance:Set_shrinkTime(self.GuideData:GetShrinkTime())
    end
    CommonHelper:SetGameObjectActive("RectMask",self.gameObject,maskAnim==GuideAnimType.Rect)
    CommonHelper:SetGameObjectActive("CircleMask",self.gameObject,maskAnim==GuideAnimType.Circle)
end

function GuideView:SetDialog()
    local  desc= self.GuideData:GetDesc()
    local  type= self.GuideData:GetDescType()
    if type==1 then
        local string=CommonHelper:GetTempStr_Default(desc,PlayerDataManager:Get():GetPlayerName())
        CommonHelper:SetDoText("###tips",self.GuideDesc,string,0.8)
        CommonHelper:SetDoText("###tips2",self.GuideDesc,string,0.8)
        cs_coroutine.start(function()
            coroutine.yield(CS.UnityEngine.WaitForSeconds(0.8))
            CommonHelper:SetNewLineText("###tips",self.GuideDesc,string)
            CommonHelper:SetNewLineText("###tips2",self.GuideDesc,string)
        end)
        CommonHelper:SetText("###clickhit",self.GuideDesc,CommonHelper:GetTempStr_Default(desc,PlayerDataManager:Get():GetPlayerName()))
        return
    end
    local string=CommonHelper:GetTempStr_Default(desc,PlayerDataManager:Get():GetPlayerName())
    CommonHelper:SetDoText("###tips",self.GuideDesc,string,0.8)
    CommonHelper:SetDoText("###tips2",self.GuideDesc,string,0.8)
    CommonHelper:SetText("###clickhit",self.GuideDesc,string)
    cs_coroutine.start(function()
        coroutine.yield(CS.UnityEngine.WaitForSeconds(0.8))
        CommonHelper:SetNewLineText("###tips",self.GuideDesc,string)
        CommonHelper:SetNewLineText("###tips2",self.GuideDesc,string)
    end)
end

function GuideView:SetBtnCloseMask()
    CommonHelper:SetGameObjectActive("BtnCloseMask1",self.gameObject,self.GuideData:GetDialogMask()==GuideDialogType.Alpha_0)
    CommonHelper:SetGameObjectActive("BtnCloseMask2",self.gameObject,self.GuideData:GetDialogMask()==GuideDialogType.Black)
end

function GuideView:SetIsCollider()
    CommonHelper:SetGameObjectActive("collider",self.gameObject,self.GuideData:GetIsCollider()==1)
    CommonHelper:SetGameObjectActive("checkscreendrag",self.gameObject,self.GuideData:GetCompleteType()==GuideCompletType.DropScreenClose)
end

function GuideView:SetGuidePersonPos()
    UIUtil:GameobjectLocalPositionY(self.GuideDesc, self.GuideData:GetNPCPosY())
    UIUtil:GameobjectLocalPositionX(self.GuideDesc, self.GuideData:GetNPCPosX())
    CommonHelper:SetGameObjectActive("person1",self.gameObject,1==self.GuideData:GetNPC())
    CommonHelper:SetGameObjectActive("person2",self.gameObject,2==self.GuideData:GetNPC())
    CommonHelper:SetGameObjectActive("person3",self.gameObject,3==self.GuideData:GetNPC())
    CommonHelper:TweenGroupPlotPlayDialog("TweenPostionPerson", self.gameObject)
end
function GuideView:OnOpenPopup()
    if self.GuideData:GetOpenPopupName()=="-1" then
        return
    end
    local OpenPopupName=stringSplit(self.GuideData:GetOpenPopupName(),',')
    if tonumber(OpenPopupName[1])==1 and OpenPopupName[2]=="EncyclopediaView" then
        local type=tonumber(OpenPopupName[3])
        CommonHelper:OpenEncyclopedia(type)
        GuideManager:Get():IsCompleteTypeIsOpen()
    end
    if tonumber(OpenPopupName[1])==1 and OpenPopupName[2]=="GetRewardView" then
        local data={}
        local params=stringSplit(OpenPopupName[3],':')
        for i = 1, #params do
            local rewardData=stringSplitToNumber(params[i],'|')
            if self:FilterSelfShell(rewardData[1]) then
                local temp=RewardData()
                temp:SetDataIdNum(rewardData[1],rewardData[2])
                table.insert(data,temp)
            end
        end
        CommonHelper:ShowGetRewardByRewardData(data)
        GuideManager:Get():IsCompleteTypeIsOpen()
    end
end
function GuideView:FilterSelfShell(id)
    return CarDataManager:Get():GetCarDataByCarID(1).assembleMgr:GetNodeByGrooveID(PartGrooveID.Shell):GetPartCfg().C_ID~=id
end

function GuideView:SetDialogMask()
    if self.GuideData:GetUiName()=="-1" then
        CommonHelper:SetGameObjectActive("defaultmask",self.gameObject,false)
        return
    end
    cs_coroutine.start( function()
        self.GuideObj= GameObject.Find(self.GuideData:GetUiName())
        if self.GuideData:GetScrollViewName()~="-1" and self.GuideData:GetCompleteType()~=GuideCompletType.ScrollAutoMoveDone then
            local  scrollRect= GameObject.Find(self.GuideData:GetScrollViewName())
            self:ScrollRectClose(scrollRect)
            self:MoveToItem(self.GuideData:GetScrollType(),scrollRect,self.GuideData:GetScrollIndex())
            coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
            coroutine.yield(self:OnScrollView(self.GuideObj,self.GuideData:GetScrollType(),self.GuideData:GetScrollIndex()))
            while IsGetItem do coroutine.yield() end
        end
        if self.GuideObj==nil then
            return
        end
        coroutine.yield(CS.UnityEngine.WaitForSeconds(0.3))
        self:SetAnim(self.GuideData:GetMaskAnim())
        coroutine.yield(CS.UnityEngine.WaitForSeconds(0.3))
        CommonHelper:SetGameObjectActive("defaultmask",self.gameObject,false)
    end)
end
function GuideView:SetGuideObject()
    if self.GuideData:GetUiName()=="-1" then
        CommonHelper:SetGameObjectActive("defaultmask",self.gameObject,false)
        return
    end
    self.GuideObj= GameObject.Find(self.GuideData:GetUiName())
    cs_coroutine.start( function()
        if self.GuideData:GetScrollViewName()~="-1" then
            local  scrollRect= GameObject.Find(self.GuideData:GetScrollViewName())
            self:ScrollRectClose(scrollRect)
            self:MoveToItem(self.GuideData:GetScrollType(),scrollRect,self.GuideData:GetScrollIndex())
           coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
        else
            if self.GuideData:GetScrollType()~=ScrollViewType.None then
                if self.GuideData:GetScrollIndex()~="-1" then
                    if self.GuideObj then
                        self:ScrollRectClose(self.GuideObj)
                    end
                    coroutine.yield(self:OnScrollView(self.GuideObj,self.GuideData:GetScrollType(),self.GuideData:GetScrollIndex()))
                end
            end
        end
        coroutine.yield(CS.UnityEngine.WaitForSeconds(0.1))
        if self.GuideObj==nil then
            self.GuideObj= GameObject.Find(self.GuideData:GetUiName())
            if self.GuideObj==nil then
                return
            end
        end
        while IsGetItem do coroutine.yield() end
        self.ClickButton=UIUtil.GetChild(self.GuideData:GetCompleteCon(),self.GuideObj)
        self.GuideButton=UIUtil.GetChild(self.GuideData:GetCompleteCon(),self.GuideObj)
        self.ClickButton=UIUtil.GetGameobjectComponent(self.GuideButton,typeof(HButton))
        if self.ClickButton then
            self.ClickButton:SetComponentEnable(false)
        end
        if self.GuideObj then
            self:EnableContentSizeFitter(self.GuideObj.transform.parent.gameObject,false,true)
            self:EnableLayoutGroup(self.GuideObj.transform.parent.gameObject,false,true)
            UIUtil.SetParentGameObject(self.GuideObj.transform.parent,self.buttonRoot,false)
            CS.UIUtil.LocalIdentity(self.buttonRoot)
            UIUtil.SetParentGameObject(self.buttonRoot,self.GuideObj,false)
            CS.UIUtil.LocalScale(self.GuideObj.transform,Vector3.one)
            self:OnClick()
            self.ListenerBtn=UIUtil.GetGameobjectComponent(self.GuideButton.gameObject,typeof(GuideButton))
            self.gameObject.transform:SetAsLastSibling()
            coroutine.yield(CS.UnityEngine.WaitForSeconds(0.5))
            self:SetAnim(self.GuideData:GetMaskAnim())
            self:SetHead()
            coroutine.yield(CS.UnityEngine.WaitForSeconds(0.4))
            CommonHelper:SetGameObjectActive("defaultmask",self.gameObject,false)
        end
   end)
end

function GuideView:Execute()
    CommonHelper:SetGameObjectActive("defaultmask",self.gameObject,true)
    print("新手引导类型",self.GuideData:GetType())
    if self.GuideData:GetType()==GuideType.DialogGuide then
         self:SetDialogGuide()
    elseif self.GuideData:GetType()==GuideType.KeyGuide then
         self:SetKeyGuide()
    elseif self.GuideData:GetType()==GuideType.ClickGuide then
         self:SetClickGuide()
    elseif self.GuideData:GetType()==GuideType.BreakGuide then
         self:SetBreakGuide()
    end
end
function GuideView:OpenSkip()
    if  self.GuideData:GetGroup()<GuideState.GuideNewPlayer and not GuideManager:Get().PlayVideo then
        local boxFunc = function()
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, CommonHelper:GetTempStr_Default(TemplateStringID.GuideSkipHit), CommonHelper:GetTempStr_Default(TemplateStringID.DeleteFriend), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), false)
            if ret == MessageBoxHelp.BtnType.OK then
                GuideManager:Get():Kill()
            end
            if ret == MessageBoxHelp.BtnType.Cancel then
                GuideCheckClickManager.Get():Open()
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
    end
end


function GuideView:SetDialogGuide()
    self:SetIsCollider()
    self:SetBtnCloseMask()
    self:SetGuidePersonPos()
    self:SetDialog()
    self:SetDialogMask()
    self:OnOpenPopup()
    self:SetVoice()
    self:SetHeadDrag()
    self:SetScrollViewAutoMove()
end
function GuideView:SetKeyGuide()
    --关键帧分为两种一种是打开某个面板 关闭的要单独调
    if self.GuideData:GetCompleteType()==GuideCompletType.OpenView then
        GuideManager:Get():IsCompleteTypeIsOpen()
    else
        CommonHelper:SetGameObjectActive("collider",self.gameObject,false)
    end
    CommonHelper:SetGameObjectActive("defaultmask",self.gameObject,false)
end
function GuideView:SetClickGuide()
    self:SetIsCollider()
    self:SetBtnCloseMask()
    self:SetGuidePersonPos()
    self:SetDialog(self.GuideData:GetDesc())
    self:SetGuideObject()
    self:SetVoice()
end

function GuideView:SetBreakGuide()
    self:SetIsCollider()
    self:SetBtnCloseMask()
    self:SetGuidePersonPos()
    self:SetDialog(self.GuideData:GetDesc())
    UINotify:Get():SendNotification(UINotifyEvent.OpenBattleBreakButton,true)
    self:SetGuideObject()
    self:SetVoice()
end

function GuideView:ResetGuideButton(combineflag)
    if self.ClickButton and self.ClickButton.onLuaClickAction~=nil then
        if self.GuideData:GetCompleteType()==GuideCompletType.Click then
            if combineflag then
                cs_coroutine.start(function()
                    --coroutine.yield()
                    self.ClickButton:CallClickFunction()
                    self.ClickButton:SetComponentEnable(true)
                    self.ClickButton=nil
                end)
            end
        end
    end
    if self.ClickButton and self.ClickButton.onClickAction~=nil then
        if self.GuideData:GetCompleteType()==GuideCompletType.Click then
            if combineflag then
                cs_coroutine.start(function()
                    --coroutine.yield()
                    self.ClickButton:OnClickFunction()
                    self.ClickButton:SetComponentEnable(true)
                    self.ClickButton=nil
                end)
            end
        end

    end
    if self.ClickButton and self.ClickButton.onPointDown~=nil then
        if self.GuideData:GetCompleteType()==GuideCompletType.Click then
            if combineflag then
                cs_coroutine.start(function()
                    --coroutine.yield()
                    self.ClickButton:CallPointDownFunction()
                    self.ClickButton:SetComponentEnable(true)
                    self.ClickButton=nil
                end)
            end
        end

    end
end

function GuideView:OnClick()
    self.ClickCount=0
    if  self.ClickButton.onLuaClickAction~=nil then
        GuideButton.Get(self.GuideButton.gameObject):SetClickEventHandler(function(go)
            self.ClickCount=self.ClickCount+1
            if self.GuideData:GetCompleteType()==GuideCompletType.Click and self:CheckClickParam(self.ClickCount) then
                GuideManager:Get():End()
            end
            --if self.GuideData:GetCompleteType()==GuideCompletType.OpenGuideGarage then
            --    GuideManager:Get():End()
            --end
        end)
    end
    if  self.ClickButton.onClickAction~=nil then
        GuideButton.Get(self.GuideButton.gameObject):SetClickActionEventHandler(function(go)
            self.ClickCount=self.ClickCount+1
            if self.GuideData:GetCompleteType()==GuideCompletType.Click and self:CheckClickParam(self.ClickCount) then
                GuideManager:Get():End()
            end
            if self.GuideData:GetCompleteType()==GuideCompletType.OpenGuideGarage then
                GuideManager:Get():End()
            end
        end)
    end
    if self.ClickButton.onPointDown~=nil then
        GuideButton.Get(self.GuideButton.gameObject):SetPointerDownHandler(function(go)
            self.ClickCount=self.ClickCount+1
            if self.GuideData:GetCompleteType()==GuideCompletType.Click and self:CheckClickParam(self.ClickCount) then
                GuideManager:Get():End()
            end
            --if self.GuideData:GetCompleteType()==GuideCompletType.OpenGuideGarage then
            --    GuideManager:Get():End()
            --end
        end)
    end
end

function GuideView:CheckClickParam(count)
    if self.GuideData:GetCompleteParam()<=1 then
        return true
    end
    if self.ClickButton and self.ClickButton.onLuaClickAction~=nil then
        if self.GuideData:GetCompleteType()==GuideCompletType.Click then
            self.ClickButton:CallClickFunction()
        end
    end
    if self.ClickButton and self.ClickButton.onClickAction~=nil then
        if self.GuideData:GetCompleteType()==GuideCompletType.Click then
            self.ClickButton:OnClickFunction()
            CSLuaHelper.Get():PlayForceExecuteInputs()
        end
    end
    if self.ClickButton and self.ClickButton.onPointDown~=nil then
        if self.GuideData:GetCompleteType()==GuideCompletType.Click then
            self.ClickButton:CallPointDownFunction()
        end
    end
   return count>=self.GuideData:GetCompleteParam()
end

function GuideView:OnScrollView(scrollViewObj,type,index)
    IsGetItem=true
    cs_coroutine.start(function()
        local scrollView=nil
        local result=nil
        if type==ScrollViewType.Normal then
            scrollView=UIUtil.GetGameobjectComponent(scrollViewObj,typeof(MoreRowScrollView))
            self:MoveToItem(type,scrollViewObj,index)
            coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
            result=CommonHelper:MoreRowView_GetItemObj(scrollView,tonumber(index))

        elseif type==ScrollViewType.Tittle then
            scrollView=UIUtil.GetGameobjectComponent(scrollViewObj,typeof(MoreRowScrollViewTittle))
            local tittleIdx=stringSplit(index,":")
            coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
            result=CommonHelper:MoreRowTitle_GetItemById(scrollView,tittleIdx[1],tonumber(tittleIdx[2]))
        elseif type==ScrollViewType.Custom then
            scrollView=UIUtil.GetGameobjectComponent(scrollViewObj,typeof(CustomScrollView))
            --result=CommonHelper:MoreRowView_GetItemObj(scrollView,index)
        elseif type==ScrollViewType.Level then
            scrollView=UIUtil.GetGameobjectComponent(scrollViewObj,typeof(LevelListScrollView))
            coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
            self:MoveToItem(type,scrollViewObj,index)
            result=CommonHelper:LevelListView_GetItemObj(scrollView,tonumber(index))
        elseif type==ScrollViewType.Carousel then
            scrollView=UIUtil.GetGameobjectComponent(scrollViewObj,typeof(CarouselScrollView))
            coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
            self:MoveToItem(type,scrollViewObj,index)
            result=CommonHelper:InitCarouselScrollView_GetCurPage(scrollView,tonumber(index))
        elseif type==ScrollViewType.LevelTree then
            scrollView=UIUtil.GetGameobjectComponent(scrollViewObj,typeof(LevelMapScrollView))
            coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
            self:MoveToItem(type,scrollViewObj,index)
            result=CommonHelper:LevelMapView_GetItemById(scrollView,tonumber(index))
        elseif type==ScrollViewType.DropDown then
            scrollView=UIUtil.GetGameobjectComponent(scrollViewObj,typeof(UIDropDown))
            result=CommonHelper:DropDown_GetItem(scrollView,tonumber(index))
        end
        self.GuideObj= result
        IsGetItem=false
    end)
end

function GuideView:MoveToItem(type,scrollViewObj,index)
    if index==-1 then
        return
    end
    if not self.GuideData:GetScrollMove() then return end
    if type==ScrollViewType.Normal then
        local  scrollView=UIUtil.GetGameobjectComponent(scrollViewObj,typeof(MoreRowScrollView))
        CommonHelper:MoreRowView_ScrollToItem(scrollView,tonumber(index))
    elseif type==ScrollViewType.Tittle then
        local scrollView=UIUtil.GetGameobjectComponent(scrollViewObj,typeof(MoreRowScrollViewTittle))
        local tittleIdx=stringSplit(index,":")
        CommonHelper:MoreRowTitle_MoveToItem(scrollView,tittleIdx[1],tonumber(tittleIdx[2]))
    elseif type==ScrollViewType.Custom then
        local  scrollView=UIUtil.GetGameobjectComponent(scrollViewObj,typeof(CustomScrollView))
        CommonHelper:CustomView_ScrollToItem(scrollView,tonumber(index))
    elseif type==ScrollViewType.Level then

    elseif type==ScrollViewType.Carousel then
        local  scrollView=UIUtil.GetGameobjectComponent(scrollViewObj,typeof(CustomScrollView))
        CommonHelper:InitCarouselScrollView_MoveToPage(scrollView,tonumber(index))
    elseif type==ScrollViewType.LevelTree then
        local  scrollView=UIUtil.GetGameobjectComponent(scrollViewObj,typeof(LevelMapScrollView))
        CommonHelper:LevelMapView_MoveToItem(scrollView,tonumber(index),false)
    end
end
function GuideView:EnableLayoutGroup(go,flag,isrecord)
    local  group=UIUtil.GetGameobjectComponent(go,typeof(GridLayoutGroup))
    if group then
        if isrecord then
            self.GroupValue=group.enabled
        end
        group.enabled=flag
        return
    end
    group= UIUtil.GetGameobjectComponent(go,typeof(VerticalLayoutGroup))
    if group then
        if isrecord then
            self.GroupValue=group.enabled
        end
        group.enabled=flag
        return
    end
    group=UIUtil.GetGameobjectComponent(go,typeof(HorizontalLayoutGroup))
    if group then
        if isrecord then
            self.GroupValue=group.enabled
        end
        group.enabled=flag
    end

end

function GuideView:EnableContentSizeFitter(go,flag,isrecord)
    local fitter=UIUtil.GetGameobjectComponent(go,typeof(ContentSizeFitter))
    if fitter then
        if isrecord then
            self.ContentSizeFitterValue=fitter.enabled
        end
        fitter.enabled=flag
    end
end



function GuideView:ScrollRectClose(scrollViewObj)
    self.ScrollRect= UIUtil.GetGameobjectComponent(scrollViewObj,typeof(ScrollRect))
    if self.ScrollRect then
        self.TempScrollRectH,self.TempScrollRectV=CommonHelper:ScrollViewEnableDrag(self.ScrollRect,false,false)
    end
end

function GuideView:EndNewBieGuide(combineflag)
    try( function()
        self:ResetGuideButton(combineflag)
        if GuideManager:Get():GetCurGuideStep() and GuideManager:Get():GetCurGuideStep():GetShrinkTime()>0 then
            CommonHelper:SetGameObjectActive("RectMask",self.gameObject,false)
            CommonHelper:SetGameObjectActive("CircleMask",self.gameObject,false)
        end

        if self.GuideObj ~= nil  then
            UIUtil.SetParentGameObject(self.buttonRoot.transform.parent,self.GuideObj,false)
            UIUtil.SetParentGameObject(self.gameObject,self.buttonRoot,false)
            self:EnableContentSizeFitter(self.GuideObj.transform.parent.gameObject,self.ContentSizeFitterValue,true)
            self:EnableLayoutGroup(self.GuideObj.transform.parent.gameObject,self.GroupValue,false)
            self.GuideObj = nil
        end
        if self.ListenerBtn then
            self.ListenerBtn:SetComponentEnable(false)
        end
        CommonHelper:SetHButtonClick(self.BtnSkip,false,true)

        if self.ScrollRect then
            CommonHelper:ScrollViewEnableDrag(self.ScrollRect,self.TempScrollRectH,self.TempScrollRectV)
        end
        self.ScrollRect=nil
    end).catch(function(error)
        logError(error)
    end)
end