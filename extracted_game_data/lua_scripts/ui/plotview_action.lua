



---@class PlotViewAction:ViewBaseAction
PlotViewAction = class("PlotViewAction",ViewBaseAction)

function PlotViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function PlotViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.PlotAction, self.PlayAction)
end

---@return PlotView
function PlotViewAction:View()
    return self.view
end

function PlotViewAction:PlayAction(param)
    if self:View() then
        self:View():PlayAction(param[1], param[2])
    end
end


return PlotViewAction()