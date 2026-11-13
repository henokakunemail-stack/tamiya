


---@class RaceWeekViewAction:ViewBaseAction
RaceWeekViewAction = class("RaceWeekViewAction",ViewBaseAction)

function RaceWeekViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceWeekViewAction:OnRegisterEvents()
    --self:AddNotificationEvent(UINotifyEvent.PVPRankView_SetData, self.SetData)
end

---@return RaceWeekView
function RaceWeekViewAction:View()
    return self.view
end

function RaceWeekViewAction:SetData()
    if self:View() then
        --self:View():SetData()
    end
end

return RaceWeekViewAction()