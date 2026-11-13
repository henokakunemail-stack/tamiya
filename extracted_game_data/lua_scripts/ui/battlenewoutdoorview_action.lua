---@class BattleNewOutdoorViewAction:ViewBaseAction
BattleNewOutdoorViewAction = class("BattleNewOutdoorViewAction", ViewBaseAction)

function BattleNewOutdoorViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function BattleNewOutdoorViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.BattleNewOutdoorView_UpdateBattleRank, self.UpdateBattleRank)
    self:AddNotificationEvent(UINotifyEvent.BattleNewOutdoorView_OnFinishedBattle, self.OnFinishedBattle)

    self:AddNotificationEvent(UINotifyEvent.BattleNewOutdoorView_UpdateSkillCardDataCd, self.UpdateSkillCardDataCD)
    self:AddNotificationEvent(UINotifyEvent.BattleNewOutdoorView_SkillCardCdFinish, self.SkillCardCDFinish)
    self:AddNotificationEvent(UINotifyEvent.BattleNewOutdoorView_SetSkillTweenIsPause, self.SetSkillTweenIsPause)
end

---@return BattleNewOutdoorView
function BattleNewOutdoorViewAction:View()
    return self.view
end

function BattleNewOutdoorViewAction:UpdateBattleRank(rankInfo)
    if self.view == nil then
        return
    end
    self:View():SetRank(rankInfo)
end

function BattleNewOutdoorViewAction:OnFinishedBattle(finishedData)
    if self.view == nil then
        return
    end
    self:View():OnFinishedBattle(finishedData)
end






function BattleNewOutdoorViewAction:UpdateSkillCardDataCD(skillCdData)
    if self.view == nil then
        return
    end
    self:View():UpdateSkillCardsDataCD(skillCdData)
end
function BattleNewOutdoorViewAction:SkillCardCDFinish(cardCellIndex)
    if self.view == nil then
        return
    end
    self:View():SkillCardCDFinish(cardCellIndex)
end

function BattleNewOutdoorViewAction:SetSkillTweenIsPause(isPause)
    self:View():PauseAllSkillTween(isPause)
end
return BattleNewOutdoorViewAction()