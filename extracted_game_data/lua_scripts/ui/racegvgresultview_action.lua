
---@class RaceGVGResultViewAction:ViewBaseAction
RaceGVGResultViewAction = class("RaceGVGResultViewAction",ViewBaseAction)

function RaceGVGResultViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceGVGResultViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceGVGResult_SetData, self.SetData)
end

---@return RaceGVGResultView
function RaceGVGResultViewAction:View()
    return self.view
end

function RaceGVGResultViewAction:SetData()
    if self:View() then
        self:View():SetData()
    end
end

return RaceGVGResultViewAction()