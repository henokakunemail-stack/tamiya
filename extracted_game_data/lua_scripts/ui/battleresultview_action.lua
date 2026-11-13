---@class BattleResultViewAction:ViewBaseAction
BattleResultViewAction = class("BattleResultViewAction", ViewBaseAction)

function BattleResultViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function BattleResultViewAction:OnRegisterEvents()

end

---@return BattleResultView
function BattleResultViewAction:View()
    return self.view
end

return BattleResultViewAction()