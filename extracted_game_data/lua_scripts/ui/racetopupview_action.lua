
---@class RaceTopUpViewAction:ViewBaseAction
RaceTopUpViewAction = class("RaceTopUpViewAction",ViewBaseAction)

function RaceTopUpViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceTopUpViewAction:OnRegisterEvents()

end

---@return RaceTopUpView
function RaceTopUpViewAction:View()
    return self.view
end

return RaceTopUpViewAction()