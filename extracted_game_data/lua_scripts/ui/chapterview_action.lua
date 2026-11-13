
---@class ChapterViewAction:ViewBaseAction
ChapterViewAction = class("ChapterViewAction",ViewBaseAction)

function ChapterViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ChapterViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ChapterView_ClickTogType, self.ClickTogType)
    self:AddNotificationEvent(UINotifyEvent.ChapterView_UpdateChapterView, self.UpdateChapterView)
end



---@return ChapterView
function ChapterViewAction:View()
    return self.view
end

function ChapterViewAction:ClickTogType(type)
    if self:View() then
        self:View():OnClickTog_Type(type)
    end
end

function ChapterViewAction:UpdateChapterView(node)
    if self:View() then
        self:View():UpdateChapterView(node[1], node[2])
    end
end







return ChapterViewAction()