


---@class PartLevelupResultViewAction:ViewBaseAction
PartLevelupResultViewAction = class("PartLevelupResultViewAction",ViewBaseAction)

function PartLevelupResultViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function PartLevelupResultViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.PartLevelupResultView_SetData, self.SetData)
end

---@return PartLevelupResultView
function PartLevelupResultViewAction:View()
    return self.view
end

function PartLevelupResultViewAction:SetData(param)
    if self:View() then
        self:View():SetData(param[1], param[2], param[3])
    end
end

return PartLevelupResultViewAction()