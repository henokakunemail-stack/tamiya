---@class GuideScreenEffectView : ViewBase
GuideScreenEffectView = class("GuideScreenEffectView", ViewBase)

function GuideScreenEffectView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "GuideScreenEffectViewAction")
end

function GuideScreenEffectView:Awake()
    self.TimerUIMask = -1
end

function GuideScreenEffectView:OnOpen()

end

function GuideScreenEffectView:OnClose()

end

function GuideScreenEffectView:UIMask(time)
    TimerManager:Get():StopTimer(self.TimerUIMask)
    self.TimerUIMask = -1

    if time == nil then
        return
    end
    self.TimerUIMask = TimerManager:Get():CreateTimer(time, function()
        UIManager:Get():HidePersistentView("GuideScreenEffectView")
    end)
end