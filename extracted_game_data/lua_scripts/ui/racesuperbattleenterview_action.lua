
---@class RaceSuperBattleEnterViewAction:ViewBaseAction
RaceSuperBattleEnterViewAction = class("RaceSuperBattleEnterViewAction",ViewBaseAction)

function RaceSuperBattleEnterViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSuperBattleEnterViewAction:OnRegisterEvents()

end

---@return RaceSuperBattleEnterView
function RaceSuperBattleEnterViewAction:View()
    return self.view
end

return RaceSuperBattleEnterViewAction()