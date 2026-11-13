
---@class GainwayViewAction:ViewBaseAction
GainwayViewAction = class("GainwayViewAction",ViewBaseAction)

function GainwayViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function GainwayViewAction:OnRegisterEvents()

end

---@return GainwayView
function GainwayViewAction:View()
    return self.view
end



return GainwayViewAction()