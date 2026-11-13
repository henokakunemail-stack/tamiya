---@class BattleStartViewAction:ViewBaseAction
BattleStartViewAction = class("BattleStartViewAction", ViewBaseAction)

function BattleStartViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function BattleStartViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.BattleStartView_BattleCountDown, self.BattleCountDown)
    self:AddNotificationEvent(UINotifyEvent.BattleStartView_ShowRaceState, self.ShowRaceState)

end

---@return BattleStartView
function BattleStartViewAction:View()
    return self.view
end

function BattleStartViewAction:BattleCountDown(countDownTime)
    if self:View() then
        self:View():SetLight(countDownTime)
    end
end

function BattleStartViewAction:ShowRaceState(time)
    if self:View() then
        self:View():ShowRaceState(time)
    end
end

return BattleStartViewAction()