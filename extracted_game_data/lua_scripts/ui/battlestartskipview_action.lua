---@class BattleStartSkipViewAction:ViewBaseAction
BattleStartSkipViewAction = class("BattleStartSkipViewAction", ViewBaseAction)

function BattleStartSkipViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function BattleStartSkipViewAction:OnRegisterEvents()


end

---@return BattleStartSkipView
function BattleStartSkipViewAction:View()
    return self.view
end


return BattleStartSkipViewAction()