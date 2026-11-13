
---@class SelfChallengeSelectTrackViewAction:ViewBaseAction
SelfChallengeSelectTrackViewAction = class("SelfChallengeSelectTrackViewAction",ViewBaseAction)

function SelfChallengeSelectTrackViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return SelfChallengeSelectTrackView
function SelfChallengeSelectTrackViewAction:View()
    return self.view
end
function  SelfChallengeSelectTrackViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeSelectTrackOpen, self.SetData)
end

function SelfChallengeSelectTrackViewAction:SetData()
    self:View():SetData()
end

return SelfChallengeSelectTrackViewAction()