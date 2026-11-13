---@class SkillDetailViewAction:ViewBaseAction
SkillDetailViewAction = class("SkillDetailViewAction", ViewBaseAction)

function SkillDetailViewAction:initialize()
    ViewBaseAction.initialize(self)
end
function SkillDetailViewAction:OnRegisterEvents()

end

---@return SkillDetailView
function SkillDetailViewAction:View()
    return self.view
end

function SkillDetailViewAction:SetData()
    if self:View() then
        self:View():SetData()
    end
end

return SkillDetailViewAction()