---@class RecruitMiniExchangeViewAction:ViewBaseAction
RecruitMiniExchangeViewAction = class("RecruitMiniExchangeViewAction", ViewBaseAction)

function RecruitMiniExchangeViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RecruitMiniExchangeViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RecruitMiniExchangeView_SetData, self.SetData)
end
---@return RecruitMiniExchangeView
function RecruitMiniExchangeViewAction:View()
    return self.view
end

function RecruitMiniExchangeViewAction:SetData(id)
    if self:View() then
        self:View():SetData(id)
    end
end


return RecruitMiniExchangeViewAction()