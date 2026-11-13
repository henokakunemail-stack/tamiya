---@class NewBieGuideAction:ViewBaseAction
NewBieGuideAction = class("NewBieGuideAction",ViewBaseAction)

function NewBieGuideAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return NewBieGuideView
function NewBieGuideAction:View()
    return self.view
end

function NewBieGuideAction:OnRegisterEvents()
    self.handler1 = self:AddNotificationEvent(UINotifyEvent.UpdateNewBieGuideList , self.UpdateData)
    self.handler2 = self:AddNotificationEvent(UINotifyEvent.StartNewBieGuide ,  self.StartNewbieGuide)
    self.handler3 = self:AddNotificationEvent(UINotifyEvent.EndNewbieGuide ,  self.EndNewbieGuide)
    self.handler3 = self:AddNotificationEvent(UINotifyEvent.EscCurNewBie ,  self.ExitCurGuide)

    self:AddNotificationEvent(UINotifyEvent.CloseNewbieGuide,function ()
        if self:View() and UIManager:Get():IsPersistentViewShow("NewbieGuideView") then
            UINotify:Get():SendNotification(UINotifyEvent.EscCurNewBie)
            UIManager:Get():HidePersistentView("NewbieGuideView")
        end
    end)
end
function NewBieGuideAction:SetData()

end
function NewBieGuideAction:UpdateData()
   NewBieGuideDataManager:Get():SwitchCurGuideStep()
end
local  _count=0
function NewBieGuideAction:StartNewbieGuide(data)

    if self:View() then
        self:View():StartNewBieGuide(data)
    else
        UIManager:Get():ShowPersistentView("NewbieGuideView",CanvasType.MainCanvas,"NewBieGuideView",false,true)
        self:View():StartNewBieGuide(data)
    end
end

function NewBieGuideAction:EndNewbieGuide()
    if self:View() then
        self:View():EndNewBieGuide()
    end
end
function NewBieGuideAction:ExitCurGuide()
    self:View():ExitCurGuide()
end

return NewBieGuideAction()