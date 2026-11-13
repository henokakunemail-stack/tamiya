


---@class CenterTipsViewAction:ViewBaseAction
CenterTipsViewAction = class("CenterTipsViewAction",ViewBaseAction)

function CenterTipsViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function CenterTipsViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ShowTips_Center, self.ShowTips)
end

---@return CenterTipsView
function CenterTipsViewAction:View()
    return self.view
end

function CenterTipsViewAction:ShowTips(param)
    self:View():ShowTips(param)
end



return CenterTipsViewAction()