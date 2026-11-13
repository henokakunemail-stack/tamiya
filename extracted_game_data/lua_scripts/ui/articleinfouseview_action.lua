
---@class ArticleInfoUseViewAction:ViewBaseAction
ArticleInfoUseViewAction = class("ArticleInfoUseViewAction",ViewBaseAction)

function ArticleInfoUseViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ArticleInfoUseViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ArticleInfoUseView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.ArticleInfoUseView_SetCount, self.SetCount)
end

---@return ArticleInfoUseView
function ArticleInfoUseViewAction:View()
    return self.view
end

function ArticleInfoUseViewAction:SetData(cellid)
    if self:View() then
        self:View():SetData(cellid)
    end
end

function ArticleInfoUseViewAction:SetCount(num)
    if self:View() then
        self:View():OnClickBtn_Num(num)
    end
end

return ArticleInfoUseViewAction()