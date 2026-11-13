---@class MonoHelper
MonoHelper = class("MonoHelper")

---C#调用转菊花
function MonoHelper.PlayScreenEffectWaiting(enable)
    CommonHelper:PlayScreenEffectWaiting(enable)
end
---C#调用全屏遮罩
function MonoHelper.PlayScreenEffectNull(enable)
    CommonHelper:PlayScreenEffectNull(enable)
end
function MonoHelper.SetNewlineText(text,param)
    mono.SetNewlineText(text,param)
end
function MonoHelper.AddExceptionEvent()
    mono.AddExceptionEvent()
end
function MonoHelper.SwitchToKpGame(autoLogin)
    local boxFunc = function()
        local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, CommonHelper:GetTempStr_Default(TemplateStringID.IsSkipToKPGame), CommonHelper:GetTempStr_Default(TemplateStringID.DeleteFriend), CommonHelper:GetTempStr_Default(TemplateStringID.OK), CommonHelper:GetTempStr_Default(TemplateStringID.Cancel), true)
        if ret == MessageBoxHelp.BtnType.OK then
            cs_coroutine.start(function()
                if SDKHelper:Get():ChickSdk() then
                    UnifySDKManager:Get():IAccount():Logout()
                    CS.PhoneRotateHelper:Get():ShowLandscape()
                    if  UnifySDKManager:Get():IAccount().isLogin then
                        coroutine.yield()
                    end
                    coroutine.yield(CS.UnityEngine.WaitForSeconds(3))
                    SceneManager:Get():Clear()
                    UIManager:Get():CloseAllViews()
                    UIManager:Get():CloseAllPopups()
                    UIManager:Get():CloseAllPersistentView()
                    coroutine.yield(CS.UnityEngine.WaitForSeconds(2))
                    mono.SwitchToKpGame(autoLogin)
                else
                    CS.PhoneRotateHelper:Get():ShowLandscape()
                    coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
                    LoginFuncHelper:LoginOut_GameBackToLogin_Combine(false, false, function()
                        SceneManager:Get():Clear()
                        UIManager:Get():CloseAllViews()
                        UIManager:Get():CloseAllPopups()
                        UIManager:Get():CloseAllPersistentView()
                        coroutine.yield(CS.UnityEngine.WaitForSeconds(2))
                        mono.SwitchToKpGame(autoLogin)
                    end, false)
                end
            end)
        end
    end
    MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
end

function MonoHelper.CheckNewPlayerGuide()

end
function MonoHelper.CheckNewPlayerGuide()

end
function MonoHelper.SetPlayerGuide()
    GuideManager:Get():SetPlayerGuide()

end
function MonoHelper.StartNewPlayerGuide(type)
    local stepData=GuideManager:Get():GetCurGuideStep()
    if stepData and stepData:GetTriggerType()==GuideTriggerType.Battle then
        GuideManager:Get():Execute(nil,GuideTriggerType.Battle)
    else
        MonoHelper.ContinueToBattle()
    end
end
function MonoHelper.GetGuideStepTriggerParm()
    local stepData=GuideManager:Get():GetCurGuideStep()
    if stepData then
        return stepData:GetTriggerPara()
    else
        return ""
    end

end
function MonoHelper.TouchScreenGuideDone()
    local stepData=GuideManager:Get():GetCurGuideStep()
    if stepData and stepData:GetCompleteType()==GuideCompletType.DropScreenClose then
        GuideManager:Get():End()
    end
end

function MonoHelper.TriggerSlowMotionEnter()
    print("TriggerSlowMotionEnter")
    local stepData=GuideManager:Get():GetCurGuideStep()
    if stepData and stepData:GetCompleteType()==GuideCompletType.ProtectDone then
        GuideManager:Get():End()
    end
end

function MonoHelper.ContinueToBattle()
    CSLuaHelper:Get():ContinueToBattle()
end

function MonoHelper:CheckAppNetType()
    --   -1:error   0:无网络     1:wifi    2:移动网
    return mono.CheckAppNetType()
end

function MonoHelper:RenderSettingFog(enable, color, mode, startdis, enddis, Density)
    mono.RenderSettingFog(enable, color, mode, startdis, enddis, Density)
end

function MonoHelper:CheckPartMetal(obj)
    return mono.CheckPartMetal(obj)
end

function MonoHelper:ChangeShader(objs, islow, lowshader, highshader)
    mono.ChangeShader(objs, islow, lowshader, highshader)
end

function MonoHelper:TurnOnPhysics()
    mono.TurnOnPhysics()
end

function MonoHelper:TurnOffPhysics()
    mono.TurnOffPhysics()
end
function MonoHelper:TurnOffOutline()
    mono.TurnOffOutline()
end

function MonoHelper:TurnOnOutline()
    mono.TurnOnOutline()
end

function MonoHelper:AesEncryptor_Base64()
    mono.AesEncryptor_Base64()
end
function MonoHelper:RendererSetTexture(renderer,name,texture)
    mono.RendererSetTexture(renderer,name,texture)
end

function MonoHelper:EnableDoubleSpeed(enable,write)
    local raceManager = monoRaceManager
    if BattleDataManager:Get():GetBattleState()==BattleState.Fighting then
        if enable then
            raceManager:EnableSlowMotion(false)
            raceManager:SetTimeScale(2)
            if write then
                PlayerPrefsHelper:SetValue_BattleDoubleSpeed(2)
            end
        else
            raceManager:EnableSlowMotion(true)
            raceManager:SetTimeScale(1)
            if write then
                PlayerPrefsHelper:SetValue_BattleDoubleSpeed(1)
            end
        end
    else
        raceManager:EnableSlowMotion(true)
        raceManager:SetTimeScale(1)
    end
end
function MonoHelper:BattleSkipStartCamera()
    CSLuaHelper:Get():SkipStartCamera()
end
function MonoHelper:ClickAccelBeanBtn(value)
    CSLuaHelper:Get():ClickAccelBeanBtn(value)
end
function MonoHelper:SwitchSelectPlayer2(index)
    CSLuaHelper:Get():SwitchSelectPlayer2(index)
end
