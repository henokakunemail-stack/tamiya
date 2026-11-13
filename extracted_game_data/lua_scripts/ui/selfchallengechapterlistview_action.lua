
---@class SelfChallengeChapterListViewAction:ViewBaseAction
SelfChallengeChapterListViewAction = class("SelfChallengeChapterListViewAction",ViewBaseAction)

function SelfChallengeChapterListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function SelfChallengeChapterListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeChapterListView_UpdateLevelView, self.UpdateLevelView)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeChapterListView_ClickLevelItem, self.ClickLevelItem)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeChapterListView_SetLevelList, self.SetLevelList)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeChapterListView_ClickBox, self.OnClickBtn_Box)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeChapterListView_UpdateBox, self.SetProcessBar)
end



---@return SelfChallengeChapterListView
function SelfChallengeChapterListViewAction:View()
    return self.view
end

function SelfChallengeChapterListViewAction:SetLevelList(data)
    if self:View() then
        self:View():SetLevelList(data)
    end
end

function SelfChallengeChapterListViewAction:UpdateLevelView(node)
    if self:View() then
        self:View():UpdateLevelView(node[1], node[2])
    end
end

function SelfChallengeChapterListViewAction:ClickLevelItem(type)
    if self:View() then
        self:View():ClickLevelItem(type)
    end
end

function SelfChallengeChapterListViewAction:OnClickBtn_Box(idx)
    if self:View() then
        self:View():OnClickBtn_Box(idx)
    end
end

function SelfChallengeChapterListViewAction:SetProcessBar(type)
    if self:View() then
        self:View():SetProcessBar()
    end
end


return SelfChallengeChapterListViewAction()