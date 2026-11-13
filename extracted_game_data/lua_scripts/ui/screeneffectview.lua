---@class ScreenEffectView : ViewBase
ScreenEffectView = class("ScreenEffectView", ViewBase)

function ScreenEffectView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ScreenEffectViewAction")

    print("----》---   ScreenEffectView 初始化完成")
end

function ScreenEffectView:Awake()
    print("---   ScreenEffectView awake")

    self.WaitingGroup = self:GetChildByParent("waiting", self.gameObject)

    self.TimerUIMask = -1
    self.TimerWhite1to0 = -1
    self.TimerWhite0to1 = -1
    self.TimerWhite0to0 = -1
end

function ScreenEffectView:OnOpen()

    ViewBase.RegisteAction(self, "ScreenEffectViewAction")

    self:GetChildByParent("alpha0to1", self.gameObject):SetActive(false)
    self:GetChildByParent("alpha1to0", self.gameObject):SetActive(false)
    self:GetChildByParent("alpha0to0", self.gameObject):SetActive(false)
    self.WaitingGroup:SetActive(false)

end

function ScreenEffectView:OnClose()

end

function ScreenEffectView:PlayEffectAlpha0to1(func, class, time)
    TimerManager:Get():StopTimer(self.TimerWhite0to1)
    self.TimerWhite0to1 = -1

    if time == nil then
        time = 0.2
    end
    local obj = self:GetChildByParent("alpha0to1", self.gameObject)
    obj:SetActive(true)
    local tween = TweenAlpha.Begin(obj, 0, 1, time)
    tween.method = EaseType.easeOutQuint;
    self.TimerWhite0to1 = TimerManager:Get():CreateTimer(time, function()
        UIManager:Get():HidePersistentView("ScreenEffectView")
    end)
end

function ScreenEffectView:PlayEffectAlpha1to0(func, class, time)
    TimerManager:Get():StopTimer(self.TimerWhite1to0)
    self.TimerWhite1to0 = -1
    print(time)
    if time == nil then
        time = 0.2
    end
    local obj = self:GetChildByParent("alpha1to0", self.gameObject)
    obj:SetActive(true)
    local tween = TweenAlpha.Begin(obj, 1, 0, time)
    tween.method = EaseType.easeInQuint;
    self.TimerWhite1to0 = TimerManager:Get():CreateTimer(time, function()
        UIManager:Get():HidePersistentView("ScreenEffectView")
    end)
end

function ScreenEffectView:PlayEffectAlpha0to0(func, class, time)
    TimerManager:Get():StopTimer(self.TimerWhite0to0)
    self.TimerWhite0to0 = -1

    if time == nil then
        time = 2
    end
    local obj = self:GetChildByParent("alpha0to0", self.gameObject)
    obj:SetActive(true)
    local tween = UIUtil.GetGameobjectComponent(obj, typeof(TweenAlpha))
    tween:ResetToBeginning()
    tween:Play(true)

    TimerManager:Get():CreateTimer(time, function()
        UIManager:Get():HidePersistentView("ScreenEffectView")
    end)
    self.TimerWhite0to0 = TimerManager:Get():CreateTimer(time / 2, func, class)

end

function ScreenEffectView:PlayWaiting(enable)
    log(debug.traceback("-----ScreenEffectView--------PlayWaiting"), "-----", enable)

    self.WaitingGroup:SetActive(enable)

    if not enable then
        UIManager:Get():HidePersistentView("ScreenEffectView")
    end
end

function ScreenEffectView:UIMask(time)
    TimerManager:Get():StopTimer(self.TimerUIMask)
    self.TimerUIMask = -1

    if time == nil then
        time = 1
    end
    self.TimerUIMask = TimerManager:Get():CreateTimer(time, function()
        UIManager:Get():HidePersistentView("ScreenEffectView")
    end)
end

function ScreenEffectView:StopAllTimer()
    self:PlayWaiting(false)

    TimerManager:Get():StopTimer(self.TimerUIMask)
    TimerManager:Get():StopTimer(self.TimerWhite1to0)
    TimerManager:Get():StopTimer(self.TimerWhite0to1)
    TimerManager:Get():StopTimer(self.TimerWhite0to0)

    self.TimerUIMask = -1
    self.TimerWhite1to0 = -1
    self.TimerWhite0to1 = -1
    self.TimerWhite0to0 = -1

end

function ScreenEffectView:OnBackKey()

end