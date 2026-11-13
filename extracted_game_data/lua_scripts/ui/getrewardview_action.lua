
---@class GetRewardViewAction:ViewBaseAction
GetRewardViewAction = class("GetRewardViewAction",ViewBaseAction)

function GetRewardViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function GetRewardViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.OpenGetRewardView, self.SetRewardInfo)
    self:AddNotificationEvent(UINotifyEvent.OpenGetRewardView_RewardData, self.SetRewardInfoByRewardData)
    self:AddNotificationEvent(UINotifyEvent.CloseGetRewardFun, self.SetCloseFun)
end

---@return GetRewardView
function GetRewardViewAction:View()
    return self.view
end

function GetRewardViewAction:SetRewardInfo(items)
    self:View():SetRewardInfo(items)
end

function GetRewardViewAction:SetRewardInfoByRewardData(items)
    self:View():SetRewardInfoByRewardData(items)
end
function GetRewardViewAction:SetCloseFun(fun)
    self:View():SetCloseFun(fun)
end


return GetRewardViewAction()