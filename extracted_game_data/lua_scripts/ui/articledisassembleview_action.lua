
---@class ArticleDisassembleViewAction:ViewBaseAction
ArticleDisassembleViewAction = class("ArticleDisassembleViewAction",ViewBaseAction)

function ArticleDisassembleViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ArticleDisassembleViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ArticleDisassembleViewSetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.ArticleDisassembleViewRefresh, self.Refresh)
end
---@return ArticleDisassembleView
function ArticleDisassembleViewAction:View()
    return self.view
end

function ArticleDisassembleViewAction:SetData(date)
    if self:View() then
        self:View():SetData(date)
    end
end
function ArticleDisassembleViewAction:Refresh(date)
    if self:View() then
        self:View():Refresh()
    end
end

return ArticleDisassembleViewAction()