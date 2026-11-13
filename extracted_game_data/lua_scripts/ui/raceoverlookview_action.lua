


---@class RaceOverlookViewAction:ViewBaseAction
RaceOverlookViewAction = class("RaceOverlookViewAction",ViewBaseAction)

function RaceOverlookViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceOverlookViewAction:OnRegisterEvents()
    --self:AddNotificationEvent(UINotifyEvent.KnapsackView_UpdateScrollView, self.UpdateScrollView)

end

---@return RaceOverlookView
function RaceOverlookViewAction:View()
    return self.view
end



return RaceOverlookViewAction()