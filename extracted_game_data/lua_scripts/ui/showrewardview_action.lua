---@class ShowRewardViewAction:ViewBaseAction
ShowRewardViewAction = class("ShowRewardViewAction",ViewBaseAction)

function ShowRewardViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ShowRewardViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.OpenShowRewardView, self.SetRewardInfo)
end

---@return ShowRewardView
function ShowRewardViewAction:View()
    return self.view
end

function ShowRewardViewAction:SetRewardInfo(data)
    self:View():SetRewardInfo(data[1],data[2])
end


return ShowRewardViewAction()