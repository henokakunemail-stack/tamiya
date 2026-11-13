---@class EmailViewAction:ViewBaseAction
EmailViewAction = class("EmailViewAction",ViewBaseAction)

function EmailViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return EmailView
function EmailViewAction:View()
    return self.view
end
function EmailViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.EmailListView_InitEmailList, self.InitEmailList)
    self:AddNotificationEvent(UINotifyEvent.EmailListView_RefreshEmail, self.RefreshView)
    self:AddNotificationEvent(UINotifyEvent.EmailListView_DeleteEmail, self.DeleteEmail)
    self:AddNotificationEvent(UINotifyEvent.EmailGetReward, self.EmailGetReward)
    self:AddNotificationEvent(UINotifyEvent.EmailListView_UpdateEmailView, self.SetDetailContent)
end

function EmailViewAction:InitEmailList()
    self:View():SetView()
end
function EmailViewAction:RefreshView()
    self:View():RefreshView()
end

function EmailViewAction:DeleteEmail()
    self:View():DeleteEmail()
end
function EmailViewAction:EmailGetReward(ids)
    self:View():GetReward(ids)
end
function EmailViewAction:SetDetailContent(id)
    self:View():SetContent(id)
end

return EmailViewAction()