


---@class ChampionshipViewAction:ViewBaseAction
ChampionshipViewAction = class("ChampionshipViewAction",ViewBaseAction)

function ChampionshipViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ChampionshipViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ChampionshipView_SetRaceWeek, self.SetBtnRaceWeek)
end

---@return ChampionshipView
function ChampionshipViewAction:View()
    return self.view
end

function ChampionshipViewAction:SetBtnRaceWeek()
    if self:View() then
        self:View():SetBtnRaceWeek()
    end
end

return ChampionshipViewAction()