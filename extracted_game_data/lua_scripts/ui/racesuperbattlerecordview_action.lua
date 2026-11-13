
---@class RaceSuperBattleRecordViewAction:ViewBaseAction
RaceSuperBattleRecordViewAction = class("RaceSuperBattleRecordViewAction",ViewBaseAction)

function RaceSuperBattleRecordViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSuperBattleRecordViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceSuperBattleRecord_SetData, self.SetData)
end

---@return RaceSuperBattleRecordView
function RaceSuperBattleRecordViewAction:View()
    return self.view
end
function RaceSuperBattleRecordViewAction:SetData()
    if self:View() then
        self:View():SetData()
    end
end

return RaceSuperBattleRecordViewAction()