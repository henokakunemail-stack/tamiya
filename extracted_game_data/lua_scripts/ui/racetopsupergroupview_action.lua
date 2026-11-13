
---@class RaceTopSuperGroupViewAction:ViewBaseAction
RaceTopSuperGroupViewAction = class("RaceTopSuperGroupViewAction",ViewBaseAction)

function RaceTopSuperGroupViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceTopSuperGroupViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceTopGroup2_SetData, self.SetData)
end

---@return RaceTopSuperGroupView
function RaceTopSuperGroupViewAction:View()
    return self.view
end
function RaceTopSuperGroupViewAction:SetData(value)
    if self:View() then
        self:View():SetData(value)
    end
end


return RaceTopSuperGroupViewAction()