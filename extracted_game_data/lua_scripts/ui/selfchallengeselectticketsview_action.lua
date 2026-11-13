
---@class SelfChallengeSelectTicketsViewAction:ViewBaseAction
SelfChallengeSelectTicketsViewAction = class("SelfChallengeSelectTicketsViewAction",ViewBaseAction)

function SelfChallengeSelectTicketsViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return SelfChallengeSelectTicketsView
function SelfChallengeSelectTicketsViewAction:View()
    return self.view
end
function  SelfChallengeSelectTicketsViewAction:OnRegisterEvents()

end

return SelfChallengeSelectTicketsViewAction()