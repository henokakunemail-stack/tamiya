
---@class SelfChallengeSelectSceneViewAction:ViewBaseAction
SelfChallengeSelectSceneViewAction = class("SelfChallengeSelectSceneViewAction",ViewBaseAction)

function SelfChallengeSelectSceneViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return SelfChallengeSelectSceneView
function SelfChallengeSelectSceneViewAction:View()
    return self.view
end
function  SelfChallengeSelectSceneViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeSelectSceneOpen, self.SetData)
end

function SelfChallengeSelectSceneViewAction:SetData()
    self:View():SetData()
end

return SelfChallengeSelectSceneViewAction()