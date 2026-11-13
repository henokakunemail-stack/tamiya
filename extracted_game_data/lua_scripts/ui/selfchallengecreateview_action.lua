
---@class SelfChallengeCreateViewAction:ViewBaseAction
SelfChallengeCreateViewAction = class("SelfChallengeCreateViewAction",ViewBaseAction)

function SelfChallengeCreateViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return SelfChallengeCreateView
function SelfChallengeCreateViewAction:View()
    return self.view
end

function  SelfChallengeCreateViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeCreateSelectTickets, self.SelectTicketsOpen)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeCreateSelectTicketsClose, self.SelectTicketsClose)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeCreateSelectTicketsBack, self.OnSelectTicketsBack)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeCreateClearData, self.ClearData)

    self:AddNotificationEvent(UINotifyEvent.SelfChallengeCreateSetDifficulty, self.SetDifficultyOpen)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeCreateSetDifficultyClose, self.SetDifficultyClose)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeCreateSetDifficultySetDefault, self.SetDifficultySetDefault)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectDays, self.SetDifficultyUpdateSelectDays)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectPassNum, self.SetDifficultyUpdateSelectPassNum)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectType, self.SetDifficultyUpdateSelectType)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeCreateSetDifficultyUpdateSelectDifficulty, self.SetDifficultyUpdateSelectDifficulty)


    self:AddNotificationEvent(UINotifyEvent.SelfChallengeCreateSelectScene, self.SelectSceneOpen)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeCreateSelectSceneClose, self.SelectSceneClose)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeCreateSelectSceneBack, self.SelectSceneBack)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeSelectTrackBack, self.SelectTrackBack)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeCreateSelectNpcBack, self.SelectSelectNpcBack)


    self:AddNotificationEvent(UINotifyEvent.SelfChallengeCreateSetReward, self.SetRewardOpen)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeCreateSetRewardClose, self.SetRewardClose)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeCreateSetRewardBack, self.SetRewardBack)

    self:AddNotificationEvent(UINotifyEvent.SelfChallengeCreateSetName, self.SetNameOpen)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeCreateSetNameClose, self.SetNameClose)
    self:AddNotificationEvent(UINotifyEvent.SelfChallengeCreateCommitParam, self.CommitParam)

end
-----------------------------------------------
function SelfChallengeCreateViewAction:SelectTicketsOpen(gameObject)
    self:View():SelectTicketsOpen(gameObject)
end

function SelfChallengeCreateViewAction:SelectTicketsClose()
    self:View():SelectTicketsClose()
end

function SelfChallengeCreateViewAction:ClearData()
    self:View():SelectTicketsClearData()
    self:View():SetGameClearData()
    self:View():SelectSceneClearData()
    self:View():SetRewardClearData()
end


function SelfChallengeCreateViewAction:OnSelectTicketsBack(id)
    self:View():OnSelectTicketsBack(id)
end


----------------------------------------
function SelfChallengeCreateViewAction:SetDifficultyOpen(gameObject)
    self:View():SetGameOpen(gameObject)
end

function SelfChallengeCreateViewAction:SetDifficultyClose()
    self:View():SetGameClose()
end

function SelfChallengeCreateViewAction:SetDifficultySetDefault()
    self:View():SetGameSetDefault()
end
function SelfChallengeCreateViewAction:SetDifficultyUpdateSelectDays()
    self:View():UpdateSelectDays()
end
function SelfChallengeCreateViewAction:SetDifficultyUpdateSelectPassNum()
    self:View():UpdateSelectPassNum()
end
function SelfChallengeCreateViewAction:SetDifficultyUpdateSelectType()
    self:View():UpdateSelectType()
end
function SelfChallengeCreateViewAction:SetDifficultyUpdateSelectDifficulty()
    self:View():UpdateSelectDifficulty()
end


-------------------------------------
function SelfChallengeCreateViewAction:SelectSceneOpen(gameObject)
    self:View():SelectSceneOpen(gameObject)
end
function SelfChallengeCreateViewAction:SelectSceneClose()
    self:View():SelectSceneClose()
end
function SelfChallengeCreateViewAction:SelectSceneBack(id)
    self:View():SelectSceneBack(id)
end
function SelfChallengeCreateViewAction:SelectTrackBack(id)
    self:View():SelectTrackBack(id)
end
function SelfChallengeCreateViewAction:SelectSelectNpcBack(id)
    self:View():SelectSelectNpcBack(id)
end


------------------------------------
function SelfChallengeCreateViewAction:SetRewardOpen(gameObject)
    self:View():SetRewardOpen(gameObject)
end
function SelfChallengeCreateViewAction:SetRewardClose()
    self:View():SetRewardClose()
end
function SelfChallengeCreateViewAction:SetRewardBack(data)
    self:View():OnSetRewardBack(data)
end
----------------------------------------
function SelfChallengeCreateViewAction:SetNameOpen(gameObject)
    self:View():PreviewViewOpen(gameObject)
end
function SelfChallengeCreateViewAction:SetNameClose()
    self:View():PreviewViewClose()
end

function SelfChallengeCreateViewAction:CommitParam()
    self:View():CommitParam()
end



return SelfChallengeCreateViewAction()