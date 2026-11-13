

ArticleMessageBoxViewAction = class("ArticleMessageBoxViewAction",ViewBaseAction)

function ArticleMessageBoxViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ArticleMessageBoxViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ArticleMessageBoxView_SetLayout, self.SetLayout)
    self:AddNotificationEvent(UINotifyEvent.ArticleMessageBoxView_ClickToggle, self.ClickToggle)
end

---@return ArticleMessageBoxView
function ArticleMessageBoxViewAction:View()
    return self.view
end


function ArticleMessageBoxViewAction:SetLayout(param)
    if self:View() then
        self:View():SetLayout(param)
    end
end

function ArticleMessageBoxViewAction:ClickToggle(param)
    if self:View() then
        self:View():ClickToggle(param)
    end
end



return ArticleMessageBoxViewAction()