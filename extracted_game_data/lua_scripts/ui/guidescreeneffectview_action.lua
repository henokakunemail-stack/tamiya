
---@class GuideScreenEffectViewAction:ViewBaseAction
GuideScreenEffectViewAction = class("GuideScreenEffectViewAction",ViewBaseAction)

function GuideScreenEffectViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function GuideScreenEffectViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.GuideScreenEffectView_UIMask, self.UIMask)
end

---@return GuideScreenEffectView
function GuideScreenEffectViewAction:View()
    return self.view
end

function GuideScreenEffectViewAction:UIMask(time)
    if self:View() then
        self:View():UIMask(time)
    end

end


return GuideScreenEffectViewAction()