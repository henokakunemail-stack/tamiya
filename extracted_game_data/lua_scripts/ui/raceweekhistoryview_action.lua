


---@class RaceWeekHistoryViewAction:ViewBaseAction
RaceWeekHistoryViewAction = class("RaceWeekHistoryViewAction",ViewBaseAction)

function RaceWeekHistoryViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceWeekHistoryViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceWeekHistoryView_SetData, self.SetData)
end

---@return RaceWeekHistoryView
function RaceWeekHistoryViewAction:View()
    return self.view
end

function RaceWeekHistoryViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data)
    end
end

return RaceWeekHistoryViewAction()