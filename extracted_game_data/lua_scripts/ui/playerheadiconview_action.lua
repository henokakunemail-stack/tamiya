
---@class PlayerHeadIconViewAction:ViewBaseAction
PlayerHeadIconViewAction = class("PlayerHeadIconViewAction",ViewBaseAction)

function PlayerHeadIconViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return PlayerHeadIconView
function PlayerHeadIconViewAction:View()
    return self.view
end
function PlayerHeadIconViewAction:OnRegisterEvents()

end


return PlayerHeadIconViewAction()