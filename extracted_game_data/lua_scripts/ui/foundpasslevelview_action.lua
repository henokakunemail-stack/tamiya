---@class FoundPassLevelViewAction:ViewBaseAction
FoundPassLevelViewAction = class("FoundPassLevelViewAction", ViewBaseAction)

function FoundPassLevelViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return FoundPassLevelView
function FoundPassLevelViewAction:View()
    return self.view
end

function FoundPassLevelViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.FoundPassLevel_Refresh,self.BuyFinish)
end
function FoundPassLevelViewAction:BuyFinish()
    self:View():BuyFinish()
end



return FoundPassLevelViewAction()