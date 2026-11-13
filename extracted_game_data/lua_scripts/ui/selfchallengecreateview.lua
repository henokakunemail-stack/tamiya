
local ViewID={
    SelectTickets=1,
    SetTimeOrDifficulty=2,
    SelectScene=3,
    SetReward=4,
    ShowGame=5,
}

local _CurShowView=0
local _LastShowView=0
---@class SelfChallengeCreateView : ViewBase
SelfChallengeCreateView = class("SelfChallengeCreateView", ViewBase)
function SelfChallengeCreateView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SelfChallengeCreateViewAction")
end

function SelfChallengeCreateView:Awake()
   CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function(data)
       local boxfunc = function()
           local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Pink,string.format("现在退出将还原所选择内容是否退出"),"退出确认","确定","取消",true)
           if ret == MessageBoxHelp.BtnType.OK then
               SelfChallengeDataManager:Get():Clear()
               UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateClearData)
               UIManager:Get():OpenView("SelfChallengeSelfGameListView",CanvasType.MainCanvas,"SelfChallengeSelfGameListView")
           end
       end
       MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
   end)
   self.BtnNext= CommonHelper:HButtonSetCallback("BtnNext",self.gameObject,function (data)
         self:NextClick()
   end)
   self.BtnLast= CommonHelper:HButtonSetCallback("BtnLast",self.gameObject,function (data)
        self:LastClick()
   end)
   self.SelectTickets= self:GetChildWight("SelectTickets",typeof(CanvasGroup))
   self.SetTimeOrDifficulty= self:GetChildWight("SetTimeOrDifficulty",typeof(CanvasGroup))
   self.SelectScene= self:GetChildWight("SelectScene",typeof(CanvasGroup))
   self.SetReward= self:GetChildWight("SetReward",typeof(CanvasGroup))
   self.ShowGame= self:GetChildWight("ShowGame",typeof(CanvasGroup))
   self:RegisterView()
end

function SelfChallengeCreateView:RegisterView()
    self.ViewDic={}
    self.ViewDic[ViewID.SelectTickets]={gameObject=self.SelectTickets,OpenEvent=UINotifyEvent.SelfChallengeCreateSelectTickets,CloseEvent=UINotifyEvent.SelfChallengeCreateSelectTicketsClose}
    self.ViewDic[ViewID.SetTimeOrDifficulty]={gameObject=self.SetTimeOrDifficulty,OpenEvent=UINotifyEvent.SelfChallengeCreateSetDifficulty,CloseEvent=UINotifyEvent.SelfChallengeCreateSetDifficultyClose}
    self.ViewDic[ViewID.SelectScene]={gameObject=self.SelectScene,OpenEvent=UINotifyEvent.SelfChallengeCreateSelectScene,CloseEvent=UINotifyEvent.SelfChallengeCreateSelectSceneClose}
    self.ViewDic[ViewID.SetReward]={gameObject=self.SetReward,OpenEvent=UINotifyEvent.SelfChallengeCreateSetReward,CloseEvent=UINotifyEvent.SelfChallengeCreateSetRewardClose}
    self.ViewDic[ViewID.ShowGame]={gameObject=self.ShowGame,OpenEvent=UINotifyEvent.SelfChallengeCreateSetName,CloseEvent=UINotifyEvent.SelfChallengeCreateSetNameClose}

end

function SelfChallengeCreateView:OnOpen()
    self:SetDefault()
end

function SelfChallengeCreateView:SwitchNext()
    local curGo=self.ViewDic[_CurShowView].gameObject
    _LastShowView=_CurShowView
    _CurShowView=_CurShowView+1
    if _CurShowView==5 then
        CommonHelper:SetText("text",self.BtnNext.gameObject,"提交")
    else
        CommonHelper:SetText("text",self.BtnNext.gameObject,"下一步")
        self.BtnLast.gameObject:SetActive(true)
        self.BtnNext.gameObject:SetActive(true)
    end
    local Nextgo=self.ViewDic[_CurShowView].gameObject


    TweenAlpha.Begin(Nextgo.gameObject, 0, 1, 0.3)
    TweenPosition.Begin(Nextgo.gameObject, Vector3(800,0,0), Vector3.zero,  0.3)

    TweenAlpha.Begin(curGo.gameObject, 1, 0, 0.3)
    TweenPosition.Begin(curGo.gameObject,Vector3.zero, Vector3(-800,0,0),  0.3)

    self:UpdateCanvasGroup()
end

function SelfChallengeCreateView:SwitchLast()
    local curGo=self.ViewDic[_CurShowView].gameObject
    _LastShowView=_CurShowView
    _CurShowView=_CurShowView-1
    if _CurShowView==1 then
        self.BtnLast.gameObject:SetActive(false)
        CommonHelper:SetText("text",self.BtnNext.gameObject,"下一步")
    else
        CommonHelper:SetText("text",self.BtnNext.gameObject,"下一步")
        self.BtnLast.gameObject:SetActive(true)
        self.BtnNext.gameObject:SetActive(true)
    end
    local last=self.ViewDic[_CurShowView].gameObject


    TweenAlpha.Begin(curGo.gameObject, 1, 0, 0.3)
    TweenPosition.Begin(curGo.gameObject,Vector3.zero,  Vector3(800,0,0),  0.3)


    TweenAlpha.Begin(last.gameObject, 0, 1, 0.3)
    TweenPosition.Begin(last.gameObject,Vector3(-800,0,0),Vector3.zero,   0.3)

    self:UpdateCanvasGroup()
end

function SelfChallengeCreateView:UpdateCanvasGroup()

    UIUtil.ShowCanvasGroup(self.ViewDic[ViewID.SelectTickets].gameObject,_CurShowView==ViewID.SelectTickets)
    UIUtil.ShowCanvasGroup(self.ViewDic[ViewID.ShowGame].gameObject,_CurShowView==ViewID.ShowGame)
    UIUtil.ShowCanvasGroup(self.ViewDic[ViewID.SetReward].gameObject,_CurShowView==ViewID.SetReward)
    UIUtil.ShowCanvasGroup(self.ViewDic[ViewID.SelectScene].gameObject,_CurShowView==ViewID.SelectScene)
    UIUtil.ShowCanvasGroup(self.ViewDic[ViewID.SetTimeOrDifficulty].gameObject,_CurShowView==ViewID.SetTimeOrDifficulty)

    if self.ViewDic[_LastShowView]~=nil then
        UINotify:Get():SendNotification(self.ViewDic[_LastShowView].CloseEvent)
    end
    UINotify:Get():SendNotification(self.ViewDic[_CurShowView].OpenEvent,self.ViewDic[_CurShowView].gameObject.gameObject)

end


function SelfChallengeCreateView:SetDefault()
    _CurShowView=ViewID.SelectTickets
    self:UpdateCanvasGroup()
    CommonHelper:SetText("text",self.BtnNext.gameObject,"下一步")
    local  default=self.ViewDic[_CurShowView].gameObject
    self.BtnLast.gameObject:SetActive(false)
    self.BtnNext.gameObject:SetActive(true)

    TweenAlpha.Begin(default.gameObject, 0, 1, 0)
    TweenPosition.Begin(default.gameObject, Vector3(800,0,0), Vector3.zero,  0)
end

function SelfChallengeCreateView:NextClick()
    if _CurShowView==5 then
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateCommitParam)
    else
        self:SwitchNext()
    end
end



function SelfChallengeCreateView:LastClick()
   self:SwitchLast()
end

function SelfChallengeCreateView:OnClose()

end


