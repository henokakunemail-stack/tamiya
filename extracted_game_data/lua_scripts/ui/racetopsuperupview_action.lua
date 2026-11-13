
---@class RaceTopSuperUpViewAction:ViewBaseAction
RaceTopSuperUpViewAction = class("RaceTopSuperUpViewAction",ViewBaseAction)

function RaceTopSuperUpViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceTopSuperUpViewAction:OnRegisterEvents()

end

---@return RaceTopSuperUpView
function RaceTopSuperUpViewAction:View()
    return self.view
end

return RaceTopSuperUpViewAction()