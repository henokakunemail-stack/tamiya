---@class RaceTrotEnterViewAction:ViewBaseAction
RaceTrotEnterViewAction = class("RaceTrotEnterViewAction",ViewBaseAction)

function RaceTrotEnterViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceTrotSelectEnemyViewAction:OnRegisterEvents()

end

---@return RaceTrotEnterView
function RaceTrotEnterViewAction:View()
    return self.view
end

function RaceTrotEnterViewAction:SetData(isRefresh)
    if self:View() then
        self:View():SetData(isRefresh)
    end
end

return RaceTrotEnterViewAction()