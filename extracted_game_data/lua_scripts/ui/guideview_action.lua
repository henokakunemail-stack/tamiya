---@class GuideViewAction:ViewBaseAction
GuideViewAction = class("GuideViewAction",ViewBaseAction)

function GuideViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return GuideView
function GuideViewAction:View()
    return self.view
end

function GuideViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.GuideEnter , self.Enter)
    self:AddNotificationEvent(UINotifyEvent.GuideExecute , self.Execute)
    self:AddNotificationEvent(UINotifyEvent.ClickGuideEnd , self.ClickGuideEnd)
    self:AddNotificationEvent(UINotifyEvent.ClickGuideOpenSkip , self.GuideOpenSkip)
end

function GuideViewAction:Enter(data)
    self:View():Enter(data)
end
function GuideViewAction:Execute()
    self:View():Execute()
end
function GuideViewAction:GuideOpenSkip()
    self:View():OpenSkip()
end

function GuideViewAction:ClickGuideEnd(combineflag)
    self:View():EndNewBieGuide(combineflag)
end

return GuideViewAction()