


---@class RaceRankHistoryViewAction:ViewBaseAction
RaceRankHistoryViewAction = class("RaceRankHistoryViewAction",ViewBaseAction)

function RaceRankHistoryViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceRankHistoryViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceRankHistoryView_SetData, self.SetData)
end

---@return RaceRankHistoryView
function RaceRankHistoryViewAction:View()
    return self.view
end

function RaceRankHistoryViewAction:SetData(msg)
    if self:View() then
        self:View():SetData(msg)
    end
end

return RaceRankHistoryViewAction()