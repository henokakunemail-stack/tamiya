
---@class SelfChallengeSelfGameListViewAction:ViewBaseAction
SelfChallengeSelfGameListViewAction = class("SelfChallengeSelfGameListViewAction",ViewBaseAction)

function SelfChallengeSelfGameListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@return SelfChallengeSelfGameListView
function SelfChallengeSelfGameListViewAction:View()
    return self.view
end

function  SelfChallengeSelfGameListViewAction:OnRegisterEvents()

    self:AddNotificationEvent(UINotifyEvent.SelfChallengeSelfGameListSetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeSelfGameListUpdateScrollView, self.UpdateScrollView)

end

function SelfChallengeSelfGameListViewAction:SetData(index)
    self:View():SetData(index)
end

function SelfChallengeSelfGameListViewAction:UpdateScrollView(node)
    self:View():UpdateScrollItem(node[1],node[2],node[3])
end
return SelfChallengeSelfGameListViewAction()