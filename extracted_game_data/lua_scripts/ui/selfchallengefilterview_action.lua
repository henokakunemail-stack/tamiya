
---@class SelfChallengeFilterViewAction:ViewBaseAction
SelfChallengeFilterViewAction = class("SelfChallengeFilterViewAction",ViewBaseAction)

function SelfChallengeFilterViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return SelfChallengeFilterView
function SelfChallengeFilterViewAction:View()
    return self.view
end
function  SelfChallengeFilterViewAction:OnRegisterEvents()

end

return SelfChallengeFilterViewAction()