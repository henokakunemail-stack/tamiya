
---@class RaceSuperBattleListViewAction:ViewBaseAction
RaceSuperBattleListViewAction = class("RaceSuperBattleListViewAction",ViewBaseAction)

function RaceSuperBattleListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSuperBattleListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceSuperBattleList_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.RaceSuperBattleList_Refresh, self.Refresh)
end

---@return RaceSuperBattleListView
function RaceSuperBattleListViewAction:View()
    return self.view
end
function RaceSuperBattleListViewAction:SetData()
    if self:View() then
        self:View():SetData()
    end
end
function RaceSuperBattleListViewAction:Refresh()
    if self:View() then
        self:View():Refresh()
    end
end

return RaceSuperBattleListViewAction()