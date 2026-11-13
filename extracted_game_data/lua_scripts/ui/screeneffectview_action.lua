
---@class ScreenEffectViewAction:ViewBaseAction
ScreenEffectViewAction = class("ScreenEffectViewAction",ViewBaseAction)

function ScreenEffectViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ScreenEffectViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ScreenEffectView_Alpha0To1, self.PlayTweenAlpha0To1)
    self:AddNotificationEvent(UINotifyEvent.ScreenEffectView_Alpha1To0, self.PlayTweenAlpha1To0)
    self:AddNotificationEvent(UINotifyEvent.ScreenEffectView_Alpha0To0, self.PlayTweenAlpha0To0)
    self:AddNotificationEvent(UINotifyEvent.ScreenEffectView_Waiting, self.PlayWaiting)
    self:AddNotificationEvent(UINotifyEvent.ScreenEffectView_UIMask, self.UIMask)
    self:AddNotificationEvent(UINotifyEvent.ScreenEffectView_StopAllTimer, self.StopAllTimer)
end

---@return ScreenEffectView
function ScreenEffectViewAction:View()
    return self.view
end


function ScreenEffectViewAction:PlayTweenAlpha0To1(node)
    if self:View() then
        self:View():PlayEffectAlpha0to1(node[1], node[2], node[3])
    end

end
function ScreenEffectViewAction:PlayTweenAlpha1To0(node)
    if self:View() then
        self:View():PlayEffectAlpha1to0(node[1], node[2], node[3])
    end

end
function ScreenEffectViewAction:PlayTweenAlpha0To0(node)
    if self:View() then
        self:View():PlayEffectAlpha0to0(node[1], node[2], node[3])
    end

end

function ScreenEffectViewAction:PlayWaiting(enable)
    if self:View() then
        self:View():PlayWaiting(enable)
    end

end

function ScreenEffectViewAction:UIMask(time)
    if self:View() then
        self:View():UIMask(time)
    end

end

function ScreenEffectViewAction:StopAllTimer()
    if self:View() then
        self:View():StopAllTimer()
    end

end


return ScreenEffectViewAction()