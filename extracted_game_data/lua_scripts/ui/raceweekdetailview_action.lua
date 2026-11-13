


---@class RaceWeekDetailViewAction:ViewBaseAction
RaceWeekDetailViewAction = class("RaceWeekDetailViewAction",ViewBaseAction)

function RaceWeekDetailViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceWeekDetailViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceWeekDetailView_SetData, self.SetData)
end

---@return RaceWeekDetailView
function RaceWeekDetailViewAction:View()
    return self.view
end

function RaceWeekDetailViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data)
    end
end

return RaceWeekDetailViewAction()