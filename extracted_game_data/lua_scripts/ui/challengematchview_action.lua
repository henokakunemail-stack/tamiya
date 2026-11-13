---@class ChallengeMatchViewAction:ViewBaseAction
ChallengeMatchViewAction = class("ChallengeMatchViewAction", ViewBaseAction)

function ChallengeMatchViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@return ChallengeMatchView
function ChallengeMatchViewAction:View()
    return self.view
end

function ChallengeMatchViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ChallengeMatch_InitData, self.InitData)
    self:AddNotificationEvent(UINotifyEvent.ChallengeMatch_RefreshData, self.RefreshData)
end

function ChallengeMatchViewAction:InitData(flag)
    if self:View() then
        self:View():InitData(flag or true)
    end
end

function ChallengeMatchViewAction:RefreshData()
    if self:View() then
        self:View():RefreshData()
    end
end

return ChallengeMatchViewAction()
