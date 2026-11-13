


---@class BagMenuViewAction:ViewBaseAction
BagMenuViewAction = class("BagMenuViewAction",ViewBaseAction)

function BagMenuViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function BagMenuViewAction:OnRegisterEvents()
    --self:AddNotificationEvent(UINotifyEvent.KnapsackView_UpdateScrollView, self.UpdateScrollView)

end

---@return BagMenuView
function BagMenuViewAction:View()
    return self.view
end



return BagMenuViewAction()