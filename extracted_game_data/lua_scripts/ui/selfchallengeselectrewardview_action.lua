
---@class SelfChallengeSelectRewardViewAction:ViewBaseAction
SelfChallengeSelectRewardViewAction = class("SelfChallengeSelectRewardViewAction",ViewBaseAction)

function SelfChallengeSelectRewardViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return SelfChallengeSelectRewardView
function SelfChallengeSelectRewardViewAction:View()
    return self.view
end
function  SelfChallengeSelectRewardViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeSelectRewardSetData, self.SetData)
end
function SelfChallengeSelectRewardViewAction:SetData(data)
    self:View():SetData(data)
end
return SelfChallengeSelectRewardViewAction()