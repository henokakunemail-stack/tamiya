---@class RecruitMiniExchangeMoreViewAction:ViewBaseAction
RecruitMiniExchangeMoreViewAction = class("RecruitMiniExchangeMoreViewAction", ViewBaseAction)

function RecruitMiniExchangeMoreViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RecruitMiniExchangeMoreViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RecruitMiniExchangeMoreView_SetData, self.SetData)
end
---@return RecruitMiniExchangeMoreView
function RecruitMiniExchangeMoreViewAction:View()
    return self.view
end

function RecruitMiniExchangeMoreViewAction:SetData(id)
    if self:View() then
        self:View():SetData(id)
    end
end


return RecruitMiniExchangeMoreViewAction()