---@class GuideBase
GuideBase=class("GuideBase")

function GuideBase:initialize()
   self.state=GuideStepState.End
    ---@type GuideData
    self.GuideData=nil
    self.EndFunc=nil
end
function GuideBase:Enter(data)
    if self.state==GuideStepState.Reallying then
        log("引导进行中无法触发下一步引导")
        return false
    end
    ---@type GuideData
    self.GuideData=data
    self.state=GuideStepState.Enter
    self:OnEnter()
    if not UIManager:Get():IsPersistentViewShow("NewbieGuideView") then
        UIManager:Get():ShowPersistentView("NewbieGuideView",CanvasType.MainCanvas,"GuideView",false,true)
    end
    UINotify:Get():SendNotification(UINotifyEvent.GuideEnter,self.GuideData)

    return true
end
function GuideBase:OnEnter()
    self.EnterTime=CS.ServerTime:Get():ServerTimeNow()
end
function GuideBase:Execute()
    self.state=GuideStepState.Reallying
    self:CheckView()
    self:StartTime()
    GuideCheckClickManager.Get():Open()
    self:TriggerBattleFail()
    self:TriggerProtect()
    self:TriggerPauseBattle()
    self:OnBattleLineStartIsFalse()
    UINotify:Get():SendNotification(UINotifyEvent.GuideExecute)
    self:OnExecute()
end
function GuideBase:OnExecute()

end
function GuideBase:Next()
    ---@type GuideData
    local result= self.GuideData:Next()

    if not result then
        UIManager:Get():HidePersistentView("NewbieGuideView")
    end
end
function GuideBase:Skip()
    self:End()
end

function GuideBase:End()
    self.state=GuideStepState.End
    self:CheckNextStepMask()
    self:OnEnd("End")
    GuideManager:Get():Switch()
    self:CompleteGuide(true)
    self:StopVoice()
    self:StopTimer()
    GuideCheckClickManager.Get():Close()
    self:Next()
    if self.EndFunc then self.EndFunc() self.EndFunc=nil end
    PopUpGiftDataManager:Get():DelayPopUpShow()
end

function GuideBase:TrackEvent(type)
    if self.GuideData then
        if self.EnterTime then
            QuickTaHelper:Get():TrackNewStagesEvent(self.GuideData:GetId(),CS.ServerTime:Get():ConvertDateTimeInt(CS.ServerTime:Get():ServerTimeNow())-CS.ServerTime:Get():ConvertDateTimeInt(self.EnterTime),type)
        end
    end
end

function GuideBase:Break()
    self.state=GuideStepState.End
    self:CheckNextStepMask()
    self:OnEnd("Break")
    self:CompleteGuide(false)
    self:StopVoice()
    self:StopTimer()
    GuideCheckClickManager.Get():Close()
    if self.EndFunc then self.EndFunc() self.EndFunc=nil end
end

function GuideBase:Kill()
    self.state=GuideStepState.End
    self:CheckNextStepMask()
    self:OnEnd("Kill")
    GuideManager:Get():SwitchEnd()
    self:CompleteGuide(false)
    self:StopVoice()
    self:StopTimer()
    GuideCheckClickManager.Get():Close()
    if self.EndFunc then self.EndFunc() self.EndFunc=nil end
end


function GuideBase:StopVoice()
    if self.GuideData:GetGuideCV()~="-1" then
        print("---->>>>AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
        --CommonHelper:Audio_StopAudioByName(self.GuideData:GetGuideCV())
    end
end
function GuideBase:OnEnd(type)
    self:TrackEvent(type)
end
function GuideBase:CheckNextStepMask()
    if self.GuideData:GetNextStepMask()==1 then
        CommonHelper:PlayGuideScreenEffectUIMask()
    end
end

function GuideBase:StartTime()
    self.time=0
    self:StopTimer()
    self.StepTime=TimerManager:Get():CreateTimerLoop(0.1,function (class)
        class:CheckStepTime()
    end,self)
end
function GuideBase:CheckView()
    --if UIManager:Get():IsPersistentViewShow("AnnouncementView") then
    --    UIManager:Get():HidePersistentView("AnnouncementView")
    --end
    if UIManager:Get():IsPersistentViewShow("ActProclamationView") then
        UIManager:Get():HidePersistentView("ActProclamationView")
    end
end
function GuideBase:CheckStepTime()
    self.time=self.time+0.1
    if self.time>=1then
        CommonHelper:CloseGuideScreenEffectUIMask()
    end
end
function GuideBase:StopTimer()
    if self.StepTime then
        TimerManager:Get():StopTimer(self.StepTime)
        self.StepTime=nil
    end
end
--Click=1,--1.点击按钮算完成
--OpenView=2,--2.打开面板算完成
--ClickMask=4,--4.点击黑色遮罩算完成
--CloseView=5,--5.关闭面板算完成
--OpenPopupClose=6,--6.打开弹窗并关闭
function GuideBase:CompleteGuide(combineflag)
    if self.GuideData:GetCompleteType()==GuideCompletType.Click then self:ClickComplete(combineflag) end
    if self.GuideData:GetCompleteType()==GuideCompletType.OpenView then self:OpenViewComplete() end
    if self.GuideData:GetCompleteType()==GuideCompletType.ClickMask then self:ClickMaskComplete() end
    if self.GuideData:GetCompleteType()==GuideCompletType.CloseView then self:CloseViewComplete() end
    if self.GuideData:GetCompleteType()==GuideCompletType.OpenPopupClose then self:OpenPopupCloseComplete() end
    if self.GuideData:GetCompleteType()==GuideCompletType.DropScreenClose then self:DropScreenClose() end
    if self.GuideData:GetCompleteType()==GuideCompletType.ProtectDone then self:ProtectDone() end
    if self.GuideData:GetCompleteType()==GuideCompletType.ScrollAutoMoveDone then self:ScrollAutoMoveDone() end
end

function GuideBase:ClickComplete(combineflag)
    UINotify:Get():SendNotification(UINotifyEvent.ClickGuideEnd,combineflag)
    self:OnBattleEnd()
    self:OpenPopup()
end
function GuideBase:OpenViewComplete()
    self:OnBattleEnd()
    self:OpenPopup()
end
function GuideBase:ClickMaskComplete()
    self:OnBattleEnd()
    self:OpenPopup()
end
function GuideBase:CloseViewComplete()
    self:OnBattleEnd()
    self:OpenPopup()
end
function GuideBase:OpenPopupCloseComplete()
    self:OnBattleEnd()
    self:OpenPopup()
end
function GuideBase:DropScreenClose()
    self:OnBattleEnd()
    self:OpenPopup()
end
function GuideBase:ProtectDone()
    self:OnBattleEnd()
    self:OpenPopup()
end
function GuideBase:ScrollAutoMoveDone()
    self:OnBattleEnd()
    self:OpenPopup()
end

function GuideBase:OnBattleEnd()
    self:ContinueToBattle()
    self:OnProtectEnd()
end
function GuideBase:ContinueToBattle()
    if self.GuideData:GetIsContinueBattle()==1 then
        print("新手引导继续战斗")
        MonoHelper.ContinueToBattle()
    end
end

function GuideBase:TriggerProtect()
    if self.GuideData:GetTriggerProtect() then
        CSLuaHelper.SwitchMotionSlot()
        GuideManager:Get():End()
    end
end
function GuideBase:OnProtectEnd()
    if self.GuideData:GetTriggerProtect() then
        CSLuaHelper:Get():NextGuideInfo()
    end
end

function GuideBase:TriggerPauseBattle()
    if self.GuideData:GetTriggerPause() then
        CSLuaHelper.BattlePause()
    end
end
function GuideBase:TriggerBattleFail()
    if self.GuideData:GetTriggerCloseNoFail() then
        CSLuaHelper.Get():SetGuideCrashState(false)
        CS.Horizon.Game.LogicLayer.RaceGlobalSetting.IsEnableCurveTurnOver = true
    elseif self.GuideData:GetTriggerNoFail() then
        CSLuaHelper.Get():SetGuideCrashState(true)
        CS.Horizon.Game.LogicLayer.RaceGlobalSetting.IsEnableCurveTurnOver = false
    else

    end
end

function GuideBase:OnBattleLineStartIsFalse()
    if self.GuideData:GetId()==100307 then
        self.line_qidongjia_low_mini_3_res=GameObject.Find("line_qidongjia_low_mini_3_res.prefab")
        if self.line_qidongjia_low_mini_3_res then
            local pos=self.line_qidongjia_low_mini_3_res.transform.position
            local rot=self.line_qidongjia_low_mini_3_res.transform.rotation
            self.TempCoroutine=cs_coroutine.start(function()
                while true do
                    coroutine.yield()
                    if self.TempCoroutine==nil then
                        break
                    end
                    CommonHelper:CSGameObjectSetActive(self.line_qidongjia_low_mini_3_res,true)
                    self.line_qidongjia_low_mini_3_res.transform.position=pos
                    self.line_qidongjia_low_mini_3_res.transform.rotation=rot
                end
            end)
        end
    else
        if self.TempCoroutine then
            cs_coroutine.stop(self.TempCoroutine)
            CommonHelper:CSGameObjectSetActive(self.line_qidongjia_low_mini_3_res,false)
            self.TempCoroutine=nil
        end
    end

end


function GuideBase:OpenPopup()
    if self.GuideData:GetOpenPopupName()=="-1" then
        return
    end
    local OpenPopupName=stringSplit(self.GuideData:GetOpenPopupName(),',')
    if tonumber(OpenPopupName[1])==2  then
        UIManager:Get():ClosePopup()
    end
    local OpenPopupName=stringSplit(self.GuideData:GetOpenPopupName(),',')
    if tonumber(OpenPopupName[1])==2 and UIManager:Get():IsPersistentViewShow(OpenPopupName[2]) then
        UIManager:Get():HidePersistentView(OpenPopupName[2])
    end

end


