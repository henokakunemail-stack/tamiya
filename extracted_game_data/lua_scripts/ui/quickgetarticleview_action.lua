

---@class QuickGetArticleViewAction:ViewBaseAction
QuickGetArticleViewAction = class("QuickGetArticleViewAction",ViewBaseAction)

function QuickGetArticleViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function QuickGetArticleViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.QuickGetArticleView_SetData, self.SetData)
end

---@return QuickGetArticleView
function QuickGetArticleViewAction:View()
    return self.view
end
function QuickGetArticleViewAction:SetData(msg)
   self:View():SetData(msg)
end


return QuickGetArticleViewAction()