---@class RaceTrotRankShowViewAction:ViewBaseAction
RaceTrotRankShowViewAction = class("RaceTrotRankShowViewAction",ViewBaseAction)

function RaceTrotRankShowViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceTrotRankShowViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RankTrotRankShow_SetData, self.SetData)
end

---@return RaceTrotRankShowView
function RaceTrotRankShowViewAction:View()
    return self.view
end

function RaceTrotRankShowViewAction:SetData(param)
    if self:View() then
        self:View():SetData(param[1],param[2],param[3])
    end
end

return RaceTrotRankShowViewAction()