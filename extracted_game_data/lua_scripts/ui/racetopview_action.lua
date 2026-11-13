
---@class RaceTopViewAction:ViewBaseAction
RaceTopViewAction = class("RaceTopViewAction",ViewBaseAction)

function RaceTopViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceTopViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceTop_SetData, self.SetData)
end

---@return RaceTopView
function RaceTopViewAction:View()
    return self.view
end
function RaceTopViewAction:SetData()
    if self:View() then
        self:View():SetData()
    end
end

return RaceTopViewAction()