


---@class RaceRankMatchingViewAction:ViewBaseAction
RaceRankMatchingViewAction = class("RaceRankMatchingViewAction",ViewBaseAction)

function RaceRankMatchingViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceRankMatchingViewAction:OnRegisterEvents()
    --self:AddNotificationEvent(UINotifyEvent.PVPRankView_SetData, self.SetData)
end

---@return RaceRankMatchingView
function RaceRankMatchingViewAction:View()
    return self.view
end

function RaceRankMatchingViewAction:SetData()
    if self:View() then
        --self:View():SetData()
    end
end

return RaceRankMatchingViewAction()