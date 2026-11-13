
---@class ArticleCountSelectViewAction:ViewBaseAction
ArticleCountSelectViewAction = class("ArticleCountSelectViewAction",ViewBaseAction)

function ArticleCountSelectViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ArticleCountSelectViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ArticleCountSelectView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.ArticleCountSelectView_ClickNum, self.ClickNum)
end

---@return ArticleCountSelectView
function ArticleCountSelectViewAction:View()
    return self.view
end

function ArticleCountSelectViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data[1],data[2],data[3],data[4],data[5],data[6],data[7])
    end
end

function ArticleCountSelectViewAction:ClickNum(value)
    if self:View() then
        self:View():OnClickBtn_Num(value)
    end
end




return ArticleCountSelectViewAction()