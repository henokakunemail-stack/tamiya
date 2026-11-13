
---@class RaceStreetViewAction:ViewBaseAction
RaceStreetViewAction = class("RaceStreetViewAction",ViewBaseAction)

function RaceStreetViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceStreetViewAction:OnRegisterEvents()

end

---@return RaceStreetView
function RaceStreetViewAction:View()
    return self.view
end

return RaceStreetViewAction()