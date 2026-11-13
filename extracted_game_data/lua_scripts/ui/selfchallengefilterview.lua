
---@class SelfChallengeFilterView : ViewBase
SelfChallengeFilterView = class("SelfChallengeFilterView", ViewBase)
function SelfChallengeFilterView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SelfChallengeFilterViewAction")
end

local _SelectType=0
local _SelectNum=0
local _SelectState=0

function SelfChallengeFilterView:Awake()

    CommonHelper:HButtonSetCallback("BgBth",self.gameObject,function ()
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function ()
        UIManager:Get():ClosePopup()
    end)

    CommonHelper:HButtonSetCallback("BtnEnter",self.gameObject,function ()
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeFilterBack,{_SelectType,_SelectNum,_SelectState})
        UIManager:Get():ClosePopup()
    end)

    self.BtnSpeed=CommonHelper:HButtonSetCallback("BtnSpeed",self.gameObject,function ()
        if _SelectType==SelfChallengeLVType.Speed then
            _SelectType=0
        else
            _SelectType=SelfChallengeLVType.Speed
        end
        self:UpdateToggle()
    end)
    self.BtnCurve=CommonHelper:HButtonSetCallback("BtnCurve",self.gameObject,function ()
        if _SelectType==SelfChallengeLVType.Curve then
            _SelectType=0
        else
            _SelectType=SelfChallengeLVType.Curve
        end
        self:UpdateToggle()
    end)
    self.BtnCross=CommonHelper:HButtonSetCallback("BtnCross",self.gameObject,function ()
        if _SelectType==SelfChallengeLVType.Cross then
            _SelectType=0
        else
            _SelectType=SelfChallengeLVType.Cross
        end
        self:UpdateToggle()
    end)
    self.BtnRamp=CommonHelper:HButtonSetCallback("BtnRamp",self.gameObject,function ()
        if _SelectType==SelfChallengeLVType.Ramp then
            _SelectType=0
        else
            _SelectType=SelfChallengeLVType.Ramp
        end
        self:UpdateToggle()
    end)
    self.BtnSynthesize=CommonHelper:HButtonSetCallback("BtnSynthesize",self.gameObject,function ()
        if _SelectType==SelfChallengeLVType.Synthesize then
            _SelectType=0
        else
            _SelectType=SelfChallengeLVType.Synthesize
        end
        self:UpdateToggle()
    end)
    self.TogThree=CommonHelper:HButtonSetCallback("TogThree",self.gameObject,function ()
        if _SelectNum==SelfChallengeLVNum.Three then
            _SelectNum=0
        else
            _SelectNum=SelfChallengeLVNum.Three
        end
        self:UpdateToggle()
    end)
    self.TogFive=CommonHelper:HButtonSetCallback("TogFive",self.gameObject,function ()
        if _SelectNum==SelfChallengeLVNum.Five then
            _SelectNum=0
        else
            _SelectNum=SelfChallengeLVNum.Five
        end
        self:UpdateToggle()
    end)
    self.TogSeven=CommonHelper:HButtonSetCallback("TogSeven",self.gameObject,function ()
        if _SelectNum==SelfChallengeLVNum.Seven then
            _SelectNum=0
        else
            _SelectNum=SelfChallengeLVNum.Seven
        end
        self:UpdateToggle()
    end)
    self.TogNine=CommonHelper:HButtonSetCallback("TogNine",self.gameObject,function ()
        if _SelectNum==SelfChallengeLVNum.Nine then
            _SelectNum=0
        else
            _SelectNum=SelfChallengeLVNum.Nine
        end
        self:UpdateToggle()
    end)
    self.TogNoJoin=CommonHelper:HButtonSetCallback("TogNoJoin",self.gameObject,function ()
        if _SelectState==SelfChallengeLVState.NoJoin then
            _SelectState=0
        else
            _SelectState=SelfChallengeLVState.NoJoin
        end
        self:UpdateToggle()
    end)
   self.TogGameing=CommonHelper:HButtonSetCallback("TogGameing",self.gameObject,function ()
       if _SelectState==SelfChallengeLVState.Gameing then
           _SelectState=0
       else
           _SelectState=SelfChallengeLVState.Gameing
       end
       self:UpdateToggle()
    end)
   self.TogIsDone=CommonHelper:HButtonSetCallback("TogIsDone",self.gameObject,function ()
       if _SelectState==SelfChallengeLVState.IsDone then
           _SelectState=0
       else
           _SelectState=SelfChallengeLVState.IsDone
       end
       self:UpdateToggle()
    end)

end

function SelfChallengeFilterView:UpdateToggle()

    -------------------------------------
    CommonHelper:SetToggleState(self.BtnSpeed,_SelectType==SelfChallengeLVType.Speed)
    CommonHelper:SetToggleState(self.BtnCurve,_SelectType==SelfChallengeLVType.Curve)
    CommonHelper:SetToggleState(self.BtnCross,_SelectType==SelfChallengeLVType.Cross)
    CommonHelper:SetToggleState(self.BtnRamp,_SelectType==SelfChallengeLVType.Ramp)
    CommonHelper:SetToggleState(self.BtnSynthesize,_SelectType==SelfChallengeLVType.Synthesize)
    -------------------------------------
    CommonHelper:SetToggleState(self.TogThree,_SelectNum==SelfChallengeLVNum.Three)
    CommonHelper:SetToggleState(self.TogFive,_SelectNum==SelfChallengeLVNum.Five)
    CommonHelper:SetToggleState(self.TogSeven,_SelectNum==SelfChallengeLVNum.Seven)
    CommonHelper:SetToggleState(self.TogNine,_SelectNum==SelfChallengeLVNum.Nine)
    -------------------------------------
    CommonHelper:SetToggleState(self.TogNoJoin,_SelectState==SelfChallengeLVState.NoJoin)
    CommonHelper:SetToggleState(self.TogGameing,_SelectState==SelfChallengeLVState.Gameing)
    CommonHelper:SetToggleState(self.TogIsDone,_SelectState==SelfChallengeLVState.IsDone)
    -------------------------------------

end

function SelfChallengeFilterView:OnOpen()

end

function SelfChallengeFilterView:OnClose()

end


