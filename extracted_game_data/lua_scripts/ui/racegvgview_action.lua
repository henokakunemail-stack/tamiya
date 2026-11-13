
---@class RaceGVGViewAction:ViewBaseAction
RaceGVGViewAction = class("RaceGVGViewAction",ViewBaseAction)

function RaceGVGViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceGVGViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceGVG_SetData, self.SetData)
end

---@return RaceGVGView
function RaceGVGViewAction:View()
    return self.view
end

function RaceGVGViewAction:SetData()
    if self:View() then
        self:View():SetData()
    end
end

return RaceGVGViewAction()