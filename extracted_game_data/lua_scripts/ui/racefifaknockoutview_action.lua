---@class RaceFifaKnockoutViewAction:ViewBaseAction
RaceFifaKnockoutViewAction = class("RaceFifaKnockoutViewAction",ViewBaseAction)

function RaceFifaKnockoutViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceFifaKnockoutViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceFifaGroupView_GuessSuccess, self.GuessSuccess)
end

---@return RaceFifaKnockoutView
function RaceFifaKnockoutViewAction:View()
    return self.view
end
function RaceFifaKnockoutViewAction:GuessSuccess()
    if self:View() then
        self:View():GuessSuccess()
    end
end

return RaceFifaKnockoutViewAction()