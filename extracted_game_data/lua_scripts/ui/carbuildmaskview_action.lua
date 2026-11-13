


---@class CarBuildMaskViewAction:ViewBaseAction
CarBuildMaskViewAction = class("CarBuildMaskViewAction",ViewBaseAction)

function CarBuildMaskViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function CarBuildMaskViewAction:OnRegisterEvents()
    --self:AddNotificationEvent(UINotifyEvent.PVPRankView_SetData, self.SetData)
end

---@return CarBuildMaskView
function CarBuildMaskViewAction:View()
    return self.view
end

function CarBuildMaskViewAction:SetData()
    if self:View() then
        --self:View():SetData()
    end
end

return CarBuildMaskViewAction()