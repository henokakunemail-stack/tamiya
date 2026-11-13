
---@class SelfChallengeSelectNpcViewAction:ViewBaseAction
SelfChallengeSelectNpcViewAction = class("SelfChallengeSelectNpcViewAction",ViewBaseAction)

function SelfChallengeSelectNpcViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return SelfChallengeSelectNpcView
function SelfChallengeSelectNpcViewAction:View()
    return self.view
end
function  SelfChallengeSelectNpcViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeSelectNpcOpen, self.SetData)
end

function SelfChallengeSelectNpcViewAction:SetData(data)
    self:View():SetData(data[1],data[2])
end
return SelfChallengeSelectNpcViewAction()