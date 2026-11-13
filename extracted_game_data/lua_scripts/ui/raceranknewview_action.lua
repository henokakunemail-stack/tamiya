---@class RaceRankNewViewAction:ViewBaseAction
RaceRankNewViewAction = class("RaceRankNewViewAction",ViewBaseAction)

function RaceRankNewViewAction:initialize()
    ViewBaseAction.initialize(self)
end
function RaceRankNewViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceRankNew_SetData, self.SetData)
end

---@return RaceRankMatchingView
function RaceRankNewViewAction:View()
    return self.view
end
function RaceRankNewViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data)
    end
end

return RaceRankNewViewAction()