---@class RaceTrotSelectEnemyViewAction:ViewBaseAction
RaceTrotSelectEnemyViewAction = class("RaceTrotSelectEnemyViewAction",ViewBaseAction)

function RaceTrotSelectEnemyViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceTrotSelectEnemyViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RankTrotSelectEnemy_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.RankTrotSelectEnemy_RefreshWatch, self.RefreshWatch)
end

---@return RaceTrotSelectEnemyView
function RaceTrotSelectEnemyViewAction:View()
    return self.view
end

function RaceTrotSelectEnemyViewAction:SetData(isRefresh)
    if self:View() then
        self:View():SetData(isRefresh)
    end
end
function RaceTrotSelectEnemyViewAction:RefreshWatch()
    if self:View() then
        self:View():RefreshWatch()
    end
end

return RaceTrotSelectEnemyViewAction()