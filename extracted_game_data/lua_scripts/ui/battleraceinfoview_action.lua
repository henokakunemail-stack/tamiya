---@class BattleRaceInfoViewAction:ViewBaseAction
BattleRaceInfoViewAction = class("BattleRaceInfoViewAction",ViewBaseAction)

function BattleRaceInfoViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function BattleRaceInfoViewAction:OnRegisterEvents()

end

---@return BattleRaceInfoView
function BattleRaceInfoViewAction:View()
    return self.view
end

return BattleRaceInfoViewAction()