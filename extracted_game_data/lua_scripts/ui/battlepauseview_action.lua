---@class BattlePauseViewAction:ViewBaseAction
BattlePauseViewAction = class("BattlePauseViewAction",ViewBaseAction)

function BattlePauseViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function BattlePauseViewAction:OnRegisterEvents()

end

---@return BattlePauseView
function BattlePauseViewAction:View()
    return self.view
end



return BattlePauseViewAction()