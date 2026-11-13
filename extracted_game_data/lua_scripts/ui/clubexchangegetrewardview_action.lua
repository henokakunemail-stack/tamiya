---@class ClubExchangeGetRewardViewAction:ViewBaseAction
ClubExchangeGetRewardViewAction=class("ClubExchangeGetRewardViewAction",ViewBaseAction)

function  ClubExchangeGetRewardViewAction:initialize()
    ViewBaseAction.initialize(self)

end

---@return ClubExchangeGetRewardView
function ClubExchangeGetRewardViewAction:View()
    return self.view
end
function ClubExchangeGetRewardViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ClubExchangeGetRewardView_SetRewardInfo, self.SetRewardInfo)
end

function ClubExchangeGetRewardViewAction:SetRewardInfo(dNums)
    if self:View() then
        self:View():SetRewardInfo(dNums)
    end
end



return ClubExchangeGetRewardViewAction()