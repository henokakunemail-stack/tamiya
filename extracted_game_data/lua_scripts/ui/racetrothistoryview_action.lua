---@class RaceTrotHistoryViewAction:ViewBaseAction
RaceTrotHistoryViewAction = class("RaceTrotHistoryViewAction",ViewBaseAction)

function RaceTrotHistoryViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceTrotHistoryViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RankTrotHistory_SetData, self.SetData)
end

---@return RaceTrotHistoryView
function RaceTrotHistoryViewAction:View()
    return self.view
end

function RaceTrotHistoryViewAction:SetData()
    if self:View() then
        self:View():SetData()
    end
end

return RaceTrotHistoryViewAction()