


---@class DevelopStarResultViewAction:ViewBaseAction
DevelopStarResultViewAction = class("DevelopStarResultViewAction",ViewBaseAction)

function DevelopStarResultViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function DevelopStarResultViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.PartStarUpView_SetData, self.SetData)
end

---@return DevelopStarResultView
function DevelopStarResultViewAction:View()
    return self.view
end

function DevelopStarResultViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data)
    end
end

return DevelopStarResultViewAction()