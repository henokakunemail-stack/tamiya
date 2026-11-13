---@class DebugPersistViewAction:ViewBaseAction
DebugPersistViewAction = class("DebugPersistViewAction", ViewBaseAction)

function DebugPersistViewAction:initialize()
    ViewBaseAction.initialize(self)
end
function DebugPersistViewAction:View()
    return self.view
end
function DebugPersistViewAction:OnRegisterEvents()

end

return DebugPersistViewAction()