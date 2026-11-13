---@class RecruitMiniExchangeedViewAction:ViewBaseAction
RecruitMiniExchangeedViewAction = class("RecruitMiniExchangeedViewAction", ViewBaseAction)

function RecruitMiniExchangeedViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RecruitMiniExchangeedViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RecruitMiniExchangedView_SetData, self.SetData)
end
---@return RecruitMiniExchangeedView
function RecruitMiniExchangeedViewAction:View()
    return self.view
end

function RecruitMiniExchangeedViewAction:SetData(id)
    if self:View() then
        self:View():SetData(id)
    end
end


return RecruitMiniExchangeedViewAction()