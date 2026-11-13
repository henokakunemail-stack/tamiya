


---@class RaceMenuViewAction:ViewBaseAction
RaceMenuViewAction = class("RaceMenuViewAction",ViewBaseAction)

function RaceMenuViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceMenuViewAction:OnRegisterEvents()
    --self:AddNotificationEvent(UINotifyEvent.PVPRankView_SetData, self.SetData)
end

---@return RaceMenuView
function RaceMenuViewAction:View()
    return self.view
end

function RaceMenuViewAction:SetData()
    if self:View() then
        --self:View():SetData()
    end
end

return RaceMenuViewAction()