
---@class RaceTopSuperViewAction:ViewBaseAction
RaceTopSuperViewAction = class("RaceTopSuperViewAction",ViewBaseAction)

function RaceTopSuperViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceTopSuperViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceTopSuper_SetData, self.SetData)
end

---@return RaceTopSuperView
function RaceTopSuperViewAction:View()
    return self.view
end
function RaceTopSuperViewAction:SetData()
    if self:View() then
        self:View():SetData()
    end
end

return RaceTopSuperViewAction()