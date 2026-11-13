
---@class InitialPlayerViewAction:ViewBaseAction
InitialPlayerViewAction = class("InitialPlayerViewAction",ViewBaseAction)

function InitialPlayerViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function InitialPlayerViewAction:OnRegisterEvents()

end

---@return InitialPlayerView
function InitialPlayerViewAction:View()
    return self.view
end
return InitialPlayerViewAction()