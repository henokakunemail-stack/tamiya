---@class ClubRenameViewAction:ViewBaseAction
ClubRenameViewAction = class("ClubRenameViewAction",ViewBaseAction)

function ClubRenameViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ClubRenameViewAction:OnRegisterEvents()
   
end

---@return ClubRenameView
function ClubRenameViewAction:View()
    return self.view
end

function ClubRenameViewAction:SetData(param)
    if self:View() then
        self:View():SetData(param)
    end
end

return ClubRenameViewAction()