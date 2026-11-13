---@class ChallengeMatchCreateViewAction:ViewBaseAction
ChallengeMatchCreateViewAction = class("ChallengeMatchCreateViewAction", ViewBaseAction)

function ChallengeMatchCreateViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@return ChallengeMatchCreateView
function ChallengeMatchCreateViewAction:View()
    return self.view
end

function ChallengeMatchCreateViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ChallengeMatchCreate_RefreshChooseTrack, self.RefreshChooseTrack)
    self:AddNotificationEvent(UINotifyEvent.ChallengeMatchCreate_RefreshChooseScene, self.RefreshChooseScene)
    self:AddNotificationEvent(UINotifyEvent.ChallengeMatchCreate_RefreshChooseTicket, self.RefreshTicket)
end

function ChallengeMatchCreateViewAction:RefreshChooseTrack()
    if self:View() then
        self:View():SetChooseTrackSVC()
    end
end

function ChallengeMatchCreateViewAction:RefreshChooseScene()
    if self:View() then
        self:View():SetChooseSceneSVC()
    end
end

function ChallengeMatchCreateViewAction:RefreshTicket(ticketID)
    if self:View() then
        self:View():SetShowAwardSVC(ticketID)
        self:View():RefreshTicketData(ticketID)
    end
end

return ChallengeMatchCreateViewAction()
