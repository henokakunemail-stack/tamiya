---@class FoundListViewAction:ViewBaseAction
FoundListViewAction = class("FoundListViewAction", ViewBaseAction)

function FoundListViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return FoundListView
function FoundListViewAction:View()
    return self.view
end

function FoundListViewAction:OnRegisterEvents()

end



return FoundListViewAction()