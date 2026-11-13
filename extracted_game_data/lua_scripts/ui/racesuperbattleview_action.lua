
---@class RaceSuperBattleViewAction:ViewBaseAction
RaceSuperBattleViewAction = class("RaceSuperBattleViewAction",ViewBaseAction)

function RaceSuperBattleViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSuperBattleViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceSuperBattle_SetData, self.SetData)
end

---@return RaceSuperBattleView
function RaceSuperBattleViewAction:View()
    return self.view
end
function RaceSuperBattleViewAction:SetData()
    self:View():SetRaceState()
end

return RaceSuperBattleViewAction()