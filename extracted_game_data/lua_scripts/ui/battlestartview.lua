---@class BattleStartView : ViewBase
BattleStartView = class("BattleStartView", ViewBase)

function BattleStartView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "BattleStartViewAction")
end

function BattleStartView:Awake()
    self:CacheData()
    self:InitBtnFunc()
end

function BattleStartView:CacheData()
    self.PressBtn = self:GetChildWight("PressBtn", typeof(HButton))
    self.PressBtn_TMG = self:GetChildWight("PressBtn", typeof(FXUITweenMoreGroup))
    self.timeCountImg = self:GetChildWight("timeCountImg", typeof(RawImage))
    self.lightImg = self:GetChildWight("LightImg", typeof(RawImage))

    self.tweenState_TMG = self:GetChildWight("tweenState", typeof(FXUITweenMoreGroup))
    self.tweenStateImg = self:GetChildWight("StateImage", typeof(RawImage))

    local timeCountParent = self:GetChild("fx_ui_timeCountImg")
    self.glowdi = self:GetChildByParent("glowdi", timeCountParent)
    self.glow =  self:GetChildByParent("glow",timeCountParent)
end

function BattleStartView:InitBtnFunc()
    CommonHelper:RegisterBtnOnPointDown(self.PressBtn, function(param)
        CSLuaHelper.Get():OnPressStartBtnDown()
        CommonHelper:SetShaderBoolValue("BtnPressImage", self.gameObject, "_BLUEYELLLOW_ON", false)
        CommonHelper:TMG_SetPlayTweenGroup(self.PressBtn_TMG, 0, 0)
        CommonHelper:TMG_PlayAllTween(self.PressBtn_TMG, 0)

        CommonHelper:SetHButtonClick(self.PressBtn, false, false)
    end)

    CommonHelper:RegisterBtnOnPointUp(self.PressBtn, function(param)
        CSLuaHelper.Get():OnRacingStartBtnUp()
        CommonHelper:SetShaderBoolValue("BtnPressImage", self.gameObject, "_BLUEYELLLOW_ON", true)

        CommonHelper:TMG_SetPlayTweenGroup(self.PressBtn_TMG, 0, 1)
        CommonHelper:TMG_PlayAllTween(self.PressBtn_TMG, 1)
    end)
end

function BattleStartView:OnOpen()
    self:InitViewInfo()
    self:CheckNewBieGuide()
end
function BattleStartView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.BattleStart)
end

function BattleStartView:InitViewInfo()
    CommonHelper:SetUITexture(self.lightImg, "uitex_sucai_battlestart_lightstate_1.png", UIModuleID.BattleStart)
    CommonHelper:SetShaderBoolValue("BtnPressImage", self.gameObject, "_BLUEYELLLOW_ON", true)

    CommonHelper:SetGameObjectActive("fx_ui_timeCountImg", self.gameObject, false)
    CommonHelper:CSGameObjectSetActive(self.tweenStateImg.gameObject, false)
    CommonHelper:SetHButtonClick(self.PressBtn, true, true)
end

function BattleStartView:SetLight(countTime)
    if countTime <= 2 then
        if countTime == 0 then
            CommonHelper:SetUITexture(self.lightImg, "uitex_sucai_battlestart_lightstate_2.png", UIModuleID.BattleStart)
            CommonHelper:SetGameObjectActive("fx_ui_timeCountImg", self.gameObject, true);
        end
        CommonHelper:SetUITexture(self.timeCountImg, string.format("uitex_sucai_battlestart_num_%d.png", 3 - countTime), UIModuleID.BattleStart)
    else
        CommonHelper:SetUITexture(self.lightImg, "uitex_sucai_battlestart_lightstate_3.png", UIModuleID.BattleStart)
        CommonHelper:SetUITexture(self.timeCountImg, "uitex_sucai_battlestart_num_go.png", UIModuleID.BattleStart)
    end

    local animator = UIUtil.GetGameobjectComponent(self.timeCountImg.gameObject, typeof(CS.UnityEngine.Animator))
    animator:Play("animation_timecountImg", 0, 0)

    self.glowdi:SetActive(false)
    self.glow:SetActive(false)

    self.glowdi:SetActive(true)
    self.glow:SetActive(true)

end

function BattleStartView:ShowRaceState(time)
    --self:StartTiming()
    print("-----time-------", time)

    if time < 0 then
        CommonHelper:SetUITexture(self.tweenStateImg, "uitex_sucai_battlestart_bg_bad.png", UIModuleID.BattleStart)--抢跑
    elseif time <= 0.3 then
        CommonHelper:SetUITexture(self.tweenStateImg, "uitex_sucai_battlestart_bg_perfact.png", UIModuleID.BattleStart)--完美
    elseif time <= 0.6 then
        CommonHelper:SetUITexture(self.tweenStateImg, "uitex_sucai_battlestart_bg_good.png", UIModuleID.BattleStart)--很棒
    elseif time < 1 then
        CommonHelper:SetUITexture(self.tweenStateImg, "uitex_sucai_battlestart_bg_normal.png", UIModuleID.BattleStart)--出发
    end

    if time < 1 then
        CommonHelper:CSGameObjectSetActive(self.tweenStateImg.gameObject, true)
        CommonHelper:TMG_PlayAllTween(self.tweenState_TMG, 0)
    end
end

--function BattleStartView:StartTiming()
--    if self.timerId ~= nil then
--        TimerManager:Get():StopTimer(self.timerIds)
--    end
--    self.timerId = TimerManager:Get():CreateTimer(2, function()
--        TimerManager:Get():StopTimer(self.timerId)
--        UIManager:Get():CloseView()
--    end)
--end

function BattleStartView:OnBackKey()

end


