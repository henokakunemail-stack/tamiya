
local _GameObject=nil
local _View=nil
local Days={
    Type1=1,
    Type2=2,
}
local PassNum={
    Type1=1,
    Type2=2,
}
local Type={
    Speed=1,
    Curve=2,
    Cross=3,
    Ramp=4,
}
local Difficulty={
    Difficulty1=1,
    Difficulty2 =2,
    Difficulty3=3,
    Difficulty4=4,
}
local _SelectDays=0
local _SelectPassNum=0
local _SelectType=0
local _SelectDifficulty=0
local self=nil





function SelfChallengeCreateView:SetGameOpen(gameObject)
    _GameObject=gameObject
    _View=self.gameObject

    print(_GameObject.name)
    print(_View.name)

    local data=SelfChallengeDataManager:Get():GetSelfChallengeData(SelfChallengeDataManager:Get().SelectId)
    if data~=nil then
        PassNum.Type1=data.barrierNums[1]
        PassNum.Type2=data.barrierNums[2]
        Days.Type1=data.lastDays[1]
        Days.Type2=data.lastDays[2]
    end

    CommonHelper:SetText("NpcTips",_View,CommonHelper:GetTempStr_Default(TemplateStringID.SelfChallengeHitSetGameTime))

    self.TogSelectSeven= CommonHelper:HButtonSetCallback("TogSelectSeven",_GameObject,function (data)
       _SelectDays=Days.Type1
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectDays)
    end)
    self.TogSelectFourteen= CommonHelper:HButtonSetCallback("TogSelectFourteen",_GameObject,function (data)
      _SelectDays=Days.Type2
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectDays)
    end)
    CommonHelper:SetText("text",self.TogSelectSeven.gameObject,string.format("%d天",Days.Type1))
    CommonHelper:SetText("text",self.TogSelectFourteen.gameObject,string.format("%d天",Days.Type2))

    self.TogSelectFive= CommonHelper:HButtonSetCallback("TogSelectFive",_GameObject,function (data)
       _SelectPassNum=PassNum.Type1
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectPassNum)
    end)
    self. TogSelectSevenLv= CommonHelper:HButtonSetCallback("TogSelectSevenLv",_GameObject,function (data)
       _SelectPassNum=PassNum.Type2
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectPassNum)
    end)
    CommonHelper:SetText("text",self.TogSelectFive.gameObject,string.format("%d关",PassNum.Type1))
    CommonHelper:SetText("text",self.TogSelectSevenLv.gameObject,string.format("%d关",PassNum.Type2))

    self. TogSelectSpeed= CommonHelper:HButtonSetCallback("TogSelectSpeed",_GameObject,function (data)
        _SelectType=Type.Speed
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectType)
    end)
    self.TogSelectCurve= CommonHelper:HButtonSetCallback("TogSelectCurve",_GameObject,function (data)
        _SelectType=Type.Curve
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectType)
    end)
    self.TogSelectCross= CommonHelper:HButtonSetCallback("TogSelectCross",_GameObject,function (data)
        _SelectType=Type.Cross
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectType)
    end)
    self.TogSelectRamp= CommonHelper:HButtonSetCallback("TogSelectRamp",_GameObject,function (data)
        _SelectType=Type.Ramp
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectType)
    end)


    self.TogSelectDifficulty1= CommonHelper:HButtonSetCallback("TogSelectDifficulty1",_GameObject,function (data)
       _SelectDifficulty=Difficulty.Difficulty1
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectDifficulty)
    end)
    self.TogSelectDifficulty2= CommonHelper:HButtonSetCallback("TogSelectDifficulty2",_GameObject,function (data)
        _SelectDifficulty=Difficulty.Difficulty2
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectDifficulty)
    end)
    self.TogSelectDifficulty3= CommonHelper:HButtonSetCallback("TogSelectDifficulty3",_GameObject,function (data)
        _SelectDifficulty=Difficulty.Difficulty3
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectDifficulty)
    end)
    self.TogSelectDifficulty4= CommonHelper:HButtonSetCallback("TogSelectDifficulty4",_GameObject,function (data)
        _SelectDifficulty=Difficulty.Difficulty4
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectDifficulty)
    end)
    if data~=nil and _SelectType==0 and _SelectDays==0 and _SelectPassNum==0 and _SelectDifficulty==0 then
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetDifficultySetDefault)
    else
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectDays)
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectPassNum)
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectType)
        UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectDifficulty)
    end
end

function SelfChallengeCreateView:SetGameClose()
    print(_GameObject,"关闭")
    SelfChallengeDataManager:Get()._SelectType=_SelectType
    SelfChallengeDataManager:Get()._SelectDays=_SelectDays
    SelfChallengeDataManager:Get()._SelectPassNum=_SelectPassNum
    SelfChallengeDataManager:Get()._SelectDifficulty= _SelectDifficulty

end
function SelfChallengeCreateView:SetGameClearData()
    _SelectType=0
    _SelectDays=0
    _SelectPassNum=0
    _SelectDifficulty=0
end

function SelfChallengeCreateView:SetGameSetDefault()

    _SelectDays=Days.Type1
    _SelectPassNum=PassNum.Type1
    _SelectType=Type.Speed
    _SelectDifficulty=Difficulty.Difficulty1

    UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectDays)
    UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectPassNum)
    UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectType)
    UINotify:Get():SendNotification(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectDifficulty)

end
function SelfChallengeCreateView:UpdateSelectDays()
    CommonHelper:SetToggleState(self.TogSelectSeven,_SelectDays==Days.Type1)
    CommonHelper:SetToggleState(self.TogSelectFourteen,_SelectDays==Days.Type2)
end

function SelfChallengeCreateView:UpdateSelectPassNum()
    CommonHelper:SetToggleState(self.TogSelectFive,_SelectPassNum==PassNum.Type1)
    CommonHelper:SetToggleState(self.TogSelectSevenLv,_SelectPassNum==PassNum.Type2)
end

function SelfChallengeCreateView:UpdateSelectType()
    CommonHelper:SetToggleState(self.TogSelectSpeed,_SelectType==Type.Speed)
    CommonHelper:SetToggleState(self.TogSelectCurve,_SelectType==Type.Curve)
    CommonHelper:SetToggleState(self.TogSelectCross,_SelectType==Type.Cross)
    CommonHelper:SetToggleState(self.TogSelectRamp,_SelectType==Type.Ramp)
end

function SelfChallengeCreateView:UpdateSelectDifficulty()
    CommonHelper:SetToggleState(self.TogSelectDifficulty1,_SelectDifficulty==Difficulty.Difficulty1)
    CommonHelper:SetToggleState(self.TogSelectDifficulty2,_SelectDifficulty==Difficulty.Difficulty2)
    CommonHelper:SetToggleState(self.TogSelectDifficulty3,_SelectDifficulty==Difficulty.Difficulty3)
    CommonHelper:SetToggleState(self.TogSelectDifficulty4,_SelectDifficulty==Difficulty.Difficulty4)
end


