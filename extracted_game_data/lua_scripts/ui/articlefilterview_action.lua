
---@class ArticleFilterViewAction:ViewBaseAction
ArticleFilterViewAction = class("ArticleFilterViewAction",ViewBaseAction)

function ArticleFilterViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ArticleFilterViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ArticleFilterView_ArticleSetData, self.SetDataArticleCell)
    self:AddNotificationEvent(UINotifyEvent.ArticleFilterView_AssembleSiftSetData, self.SetDataAssembleSift)
end
---@return ArticleFilterView
function ArticleFilterViewAction:View()
    return self.view
end

function ArticleFilterViewAction:SetDataArticleCell(node)
    self:View():SetDataArticleCell(node[1],node[2],node[3])
end

function ArticleFilterViewAction:SetDataAssembleSift(node)
    self:View():SetDataAssembleSift(node[1],node[2],node[3],node[4])
end


return ArticleFilterViewAction()