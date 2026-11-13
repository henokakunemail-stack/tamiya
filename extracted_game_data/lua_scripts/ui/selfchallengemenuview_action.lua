
---@class SelfChallengeMenuViewAction:ViewBaseAction
SelfChallengeMenuViewAction = class("SelfChallengeMenuViewAction",ViewBaseAction)

function SelfChallengeMenuViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return SelfChallengeMenuView
function SelfChallengeMenuViewAction:View()
    return self.view
end
function  SelfChallengeMenuViewAction:OnRegisterEvents()

end

return SelfChallengeMenuViewAction()