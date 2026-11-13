---@class RecruitGoViewAction:ViewBaseAction
RecruitGoViewAction = class("RecruitGoViewAction", ViewBaseAction)

function RecruitGoViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RecruitGoViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RecruitGoViewSetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.RecruitGoViewRefreshAlert, self.RefreshAlert)
end

---@return RecruitGoView
function RecruitGoViewAction:View()
    return self.view
end

function RecruitGoViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data[1],data[2],data[3])
    end
end

function RecruitGoViewAction:RefreshAlert( data)
    if self:View() then
        self:View():RefreshAlert(data)
    end
end


return RecruitGoViewAction()