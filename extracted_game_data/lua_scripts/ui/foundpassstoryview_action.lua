---@class FoundPassStoryViewAction:ViewBaseAction
FoundPassStoryViewAction = class("FoundPassStoryViewAction", ViewBaseAction)

function FoundPassStoryViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return FoundPassStoryView
function FoundPassStoryViewAction:View()
    return self.view
end

function FoundPassStoryViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.FoundPassStory_Refresh,self.BuyFinish)
end
function FoundPassStoryViewAction:BuyFinish()
    self:View():BuyFinish()
end



return FoundPassStoryViewAction()