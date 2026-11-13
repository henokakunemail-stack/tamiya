---@class RaceCarGodInfoViewAction:ViewBaseAction
RaceCarGodInfoViewAction = class("RaceCarGodInfoViewAction", ViewBaseAction)

function RaceCarGodInfoViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceCarGodInfoViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceGVG_SetSeasonData, self.SetSeasonData)
end

---@return RaceCarGodInfoView
function RaceCarGodInfoViewAction:View()
    return self.view
end

function RaceCarGodInfoViewAction:SetSeasonData(data)
    if self:View() then
        self:View():SetSeasonData(data)
    end
end

return RaceCarGodInfoViewAction()