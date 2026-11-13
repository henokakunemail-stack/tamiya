---@class RaceFifaGuessViewAction:ViewBaseAction
RaceFifaGuessViewAction = class("RaceFifaGuessViewAction",ViewBaseAction)

function RaceFifaGuessViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceFifaGuessViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceFifaGuessView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.RaceFifaGuessView_GuessSuccess, self.GuessSuccess)
end

---@return RaceFifaGuessView
function RaceFifaGuessViewAction:View()
    return self.view
end
function RaceFifaGuessViewAction:GuessSuccess(data)
    if self:View() then
        self:View():GuessSuccess(data[1],data[2])
    end
end
function RaceFifaGuessViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data)
    end
end

return RaceFifaGuessViewAction()