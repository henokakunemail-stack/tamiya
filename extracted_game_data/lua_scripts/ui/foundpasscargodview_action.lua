---@class FoundPassCarGodViewAction:ViewBaseAction
FoundPassCarGodViewAction = class("FoundPassCarGodViewAction", ViewBaseAction)

function FoundPassCarGodViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return FoundPassCarGodView
function FoundPassCarGodViewAction:View()
    return self.view
end

function FoundPassCarGodViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.FoundPassCarGod_Refresh,self.BuyFinish)
end
function FoundPassCarGodViewAction:BuyFinish()
    self:View():BuyFinish()
end



return FoundPassCarGodViewAction()