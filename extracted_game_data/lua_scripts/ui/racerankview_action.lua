


---@class RaceRankViewAction:ViewBaseAction
RaceRankViewAction = class("RaceRankViewAction",ViewBaseAction)

function RaceRankViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceRankViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceRankView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.RaceRankView_SetSpeedRank, self.SetSpeedScrollView)
end

---@return RaceRankView
function RaceRankViewAction:View()
    return self.view
end

function RaceRankViewAction:SetData()
    if self:View() then
        self:View():SetData()
    end
end

function RaceRankViewAction:SetSpeedScrollView(trackid)
    if self:View() then
        self:View():SetSpeedScrollView(trackid)
    end
end

return RaceRankViewAction()