---@class BattleStartSwitchViewAction:ViewBaseAction
BattleStartSwitchViewAction = class("BattleStartSwitchViewAction", ViewBaseAction)

function BattleStartSwitchViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function BattleStartSwitchViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.OpenSwitchViewData, self.OpenSwitchViewData)

end

---@return BattleStartSwitchView
function BattleStartSwitchViewAction:View()
    return self.view
end


function BattleStartSwitchViewAction:OpenSwitchViewData(carTrans)
    if self:View() then
        self:View():SetSwitchData(carTrans[1], carTrans[2])
    end
end

return BattleStartSwitchViewAction()