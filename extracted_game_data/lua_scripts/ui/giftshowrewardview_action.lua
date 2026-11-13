
---@class GiftShowRewardViewAction:ViewBaseAction
GiftShowRewardViewAction = class("GiftShowRewardViewAction",ViewBaseAction)

function GiftShowRewardViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function GiftShowRewardViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.GiftShowRewardView_SetData, self.SetRewardInfo)
end

---@return GiftShowRewardView
function GiftShowRewardViewAction:View()
    return self.view
end

function GiftShowRewardViewAction:SetRewardInfo(data)
     self:View():SetRewardInfo(data[1],data[2])
end


return GiftShowRewardViewAction()