---@class RaceFifaTeamListViewAction:ViewBaseAction
RaceFifaTeamListViewAction = class("RaceFifaTeamListViewAction",ViewBaseAction)

function RaceFifaTeamListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceFifaTeamListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceFifaTeamListView_SetDataGuess, self.SetDataGuess)
    self:AddNotificationEvent(UINotifyEvent.RaceFifaTeamListView_SetDataCountry, self.SetDataCountry)
end

---@return RaceFifaTeamListView
function RaceFifaTeamListViewAction:View()
    return self.view
end
function RaceFifaTeamListViewAction:SetDataCountry()
    if self:View() then
        self:View():SetDataCountry()
    end
end
function RaceFifaTeamListViewAction:SetDataGuess(data)
    if self:View() then
        self:View():SetDataGuess(data[1],data[2])
    end
end

return RaceFifaTeamListViewAction()