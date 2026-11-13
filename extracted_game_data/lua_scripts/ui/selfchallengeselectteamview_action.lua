
---@class SelfChallengeSelectTeamViewAction:ViewBaseAction
SelfChallengeSelectTeamViewAction = class("SelfChallengeSelectTeamViewAction",ViewBaseAction)

function SelfChallengeSelectTeamViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function SelfChallengeSelectTeamViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeSelectTeamView_SetData, self.SetInfo)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeSelectTeamView_Fight, self.OnClickBtn_Fight)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeSelectTeamView_ClickChange, self.ClickChange)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeSelectTeamView_Swap, self.OnClickBtn_Swap)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeSelectTeamView_Refresh, self.Refresh)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeSelectTeamView_UpdateRewardView, self.UpdateRewardView)
end

---@return SelfChallengeSelectTeamView
function SelfChallengeSelectTeamViewAction:View()
    return self.view
end

function SelfChallengeSelectTeamViewAction:SetInfo(data)
    if self:View() then
        self:View():SetInfo(data[1], data[2])
    end
end

function SelfChallengeSelectTeamViewAction:OnClickBtn_Fight()
    if self:View() then
        self:View():OnClickBtn_Fight()
    end
end

function SelfChallengeSelectTeamViewAction:OnClickBtn_Swap()
    if self:View() then
        self:View():OnClickBtn_Swap()
    end
end

function SelfChallengeSelectTeamViewAction:ClickChange(value)
    if self:View() then
        self:View():OnClickChange(value)
    end
end

function SelfChallengeSelectTeamViewAction:Refresh()
    if self:View() then
        self:View():RefreshData()
    end
end

function SelfChallengeSelectTeamViewAction:UpdateRewardView(node)
    if self:View() then
        self:View():UpdateRewardView(node[1],node[2],node[3])
    end
end


return SelfChallengeSelectTeamViewAction()