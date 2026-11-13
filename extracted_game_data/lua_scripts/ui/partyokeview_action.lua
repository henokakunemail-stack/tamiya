---@class PartYokeViewAction:ViewBaseAction
PartYokeViewAction = class("PartYokeViewAction",ViewBaseAction)

function PartYokeViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function PartYokeViewAction:OnRegisterEvents()

end

---@return PartYokeView
function PartYokeViewAction:View()
    return self.view
end

function PartYokeViewAction:SetData(param)
    if self:View() then
        self:View():SetData(param[1], param[2], param[3])
    end
end

return PartYokeViewAction()