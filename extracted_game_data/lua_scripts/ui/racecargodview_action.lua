---@class RaceCarGodViewAction:ViewBaseAction
RaceCarGodViewAction = class("RaceCarGodViewAction", ViewBaseAction)

function RaceCarGodViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceCarGodViewAction:OnRegisterEvents()

end

---@return RaceCarGodView
function RaceCarGodViewAction:View()
    return self.view
end

function RaceCarGodViewAction:SetData()

end

return RaceCarGodViewAction()