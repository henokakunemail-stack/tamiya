
---@class SelfChallengeOtherGameListViewAction:ViewBaseAction
SelfChallengeOtherGameListViewAction = class("SelfChallengeOtherGameListViewAction",ViewBaseAction)

function SelfChallengeOtherGameListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@return SelfChallengeOtherGameListView
function SelfChallengeOtherGameListViewAction:View()
    return self.view
end

function  SelfChallengeOtherGameListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeOtherGameListSetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeOtherGameListUpdateScrollView, self.UpdateScrollView)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeFilterBack, self.FilterDone)
end

function SelfChallengeOtherGameListViewAction:SetData()
    self:View():SetData()
end
function SelfChallengeOtherGameListViewAction:UpdateScrollView(data)
    self:View():UpdateScrollItem(data[1],data[2],data[3])
end
function SelfChallengeOtherGameListViewAction:FilterDone(data)
    self:View():FilterDone(data[1],data[2],data[3])
end

return SelfChallengeOtherGameListViewAction()