
---@class RaceSuperBattleRankViewAction:ViewBaseAction
RaceSuperBattleRankViewAction = class("RaceSuperBattleRankViewAction",ViewBaseAction)

function RaceSuperBattleRankViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSuperBattleRankViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceSuperBattleRankList_SetData, self.SetData)
end

---@return RaceSuperBattleRankView
function RaceSuperBattleRankViewAction:View()
    return self.view
end
function RaceSuperBattleRankViewAction:SetData()
    if self:View() then
        self:View():SetData()
    end
end

return RaceSuperBattleRankViewAction()