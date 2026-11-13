---@class RaceClub3V3ViewAction:ViewBaseAction
RaceClub3V3ViewAction = class("RaceClub3V3ViewAction",ViewBaseAction)

function RaceClub3V3ViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceClub3V3ViewAction:OnRegisterEvents()

end

---@return RaceClub3V3View
function RaceClub3V3ViewAction:View()
    return self.view
end

function RaceClub3V3ViewAction:SetData()
    if self:View() then
        self:View():SetData()
    end
end

return RaceClub3V3ViewAction()