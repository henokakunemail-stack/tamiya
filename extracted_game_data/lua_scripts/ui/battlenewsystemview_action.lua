---@class BattleNewSystemViewAction:ViewBaseAction
BattleNewSystemViewAction = class("BattleNewSystemViewAction", ViewBaseAction)

function BattleNewSystemViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function BattleNewSystemViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.BattleNewSystemView_UpdateBattleRank, self.UpdateBattleRank)
    self:AddNotificationEvent(UINotifyEvent.BattleNewSystemView_OnFinishedBattle, self.OnFinishedBattle)
    self:AddNotificationEvent(UINotifyEvent.BattleNewSystemView_UpdateScrollList, self.UpdateScrollList)
    self:AddNotificationEvent(UINotifyEvent.BattleNewSystemView_UpdateAccelerateBtnState, self.UpdateAccelerateBtnState)
    self:AddNotificationEvent(UINotifyEvent.BattleNewSystemView_SkillCardCdFinish, self.SkillCardCdFinish)
    self:AddNotificationEvent(UINotifyEvent.BattleNewSystemView_UpdateProtectBtnState, self.UpdateProtectBtnState)
    self:AddNotificationEvent(UINotifyEvent.BattleNewSystemView_SetBeanCount, self.SetBeanCount)
    self:AddNotificationEvent(UINotifyEvent.BattleNewSystemView_PlayBeanEffect, self.PlayBeanEffect)
    self:AddNotificationEvent(UINotifyEvent.BattleNewSystemView_SetTalkContent, self.SetTalkContent)
    self:AddNotificationEvent(UINotifyEvent.BattleNewSystemView_InitChatList, self.InitChatList)
    self:AddNotificationEvent(UINotifyEvent.BattleNewSystemView_InitBattleExplain, self.InitBattleExplain)
    self:AddNotificationEvent(UINotifyEvent.BattleNewSystemView_OpenGameTools, self.OpenGameTools)
    self:AddNotificationEvent(UINotifyEvent.BattleNewSystemView_Dispose, self.Dispose)
    self:AddNotificationEvent(UINotifyEvent.OpenBattleBreakButton, self.OpenBattleBreakButton)
    self:AddNotificationEvent(UINotifyEvent.BattleNewSystemView_ProtectStage, self.ProtectStageStart)
    self:AddNotificationEvent(UINotifyEvent.BattleNewSystemView_RecoverStart, self.UpdateRecoverStateStart)
    self:AddNotificationEvent(UINotifyEvent.BattleNewSystemView_RecoverEnd, self.UpdateRecoverStateEnd)
    self:AddNotificationEvent(UINotifyEvent.BattleNewSystemView_CountDown, self.UpdateRecoverCountDown)
    self:AddNotificationEvent(UINotifyEvent.BattleNewSystemView_BuffUpdate, self.UpdateBattleList)
    self:AddNotificationEvent(UINotifyEvent.BattleNewSystemView_SetBattleCostImage, self.SetBattleCostImage)

end

---@return BattleNewSystemView
function BattleNewSystemViewAction:View()
    return self.view
end

function BattleNewSystemViewAction:UpdateBattleRank(rankInfo)
    if self:View() then
        self:View():SetRank(rankInfo)
    end
end

function BattleNewSystemViewAction:OnFinishedBattle(finishedData)
    if self:View() then
        self:View():OnFinishedBattle(finishedData)
    end
end
function BattleNewSystemViewAction:InitBattleExplain(battleExplainState)
    if self:View() then
        self:View():InitBattleExplain(battleExplainState)
    end
end
function BattleNewSystemViewAction:OpenGameTools(flag)
    if self:View() then
        self:View():OpenGameTools(flag)
    end
end
function BattleNewSystemViewAction:OpenBattleBreakButton(flag)
    if self:View() then
        self:View():OpenBattleBreakButton(flag)
    end
end
function BattleNewSystemViewAction:ProtectStageStart(dur)
    if self:View() then
        self:View():ProtectStageStart(dur)
    end
end


function BattleNewSystemViewAction:Dispose()
    if self:View() then
        self:View():Dispose()
    end
end


function BattleNewSystemViewAction:UpdateScrollList(userdata)
    if self:View() then
        self:View():UpdateScrollList(userdata)
    end
end
function BattleNewSystemViewAction:UpdateAccelerateBtnState(userdata)
    if self:View() then
        self:View():UpdateAccelerateBtnState(userdata)
    end
end
function BattleNewSystemViewAction:SkillCardCdFinish(idx)
    if self:View() then
        self:View():SkillCardCdFinish(idx)
    end
end

function BattleNewSystemViewAction:UpdateProtectBtnState(userdata)
    if self:View() then
        self:View():UpdateProtectBtnState(userdata)
    end
end

function BattleNewSystemViewAction:UpdateRecoverStateStart(userdata)
    if self:View() then
        self:View():UpdateRecoverState(true)
    end
end

function BattleNewSystemViewAction:UpdateRecoverStateEnd(userdata)
    if self:View() then
        self:View():UpdateRecoverState(false)
    end
end

function BattleNewSystemViewAction:UpdateRecoverCountDown(count)
    if self:View() then
        self:View():RecoverCountDown(count)
    end
end
function BattleNewSystemViewAction:UpdateBattleList(node)
    if self:View() then
        self:View():UpdateBattleList(node[1],node[2],node[3],node[4],node[5],node[6])
    end
end
function BattleNewSystemViewAction:SetBattleCostImage(type)
    if self:View() then
        self:View():SetBattleCostImage(type)
    end
end


function BattleNewSystemViewAction:SetBeanCount()
    if self:View() then
        self:View():SetBeanCount()
    end
end
function BattleNewSystemViewAction:PlayBeanEffect(param)
    if self:View() then
        self:View():PlayBeanEffect(param)
    end
end

function BattleNewSystemViewAction:SetTalkContent(content)
    if self:View() then
        self:View():SetTalkContent(content[1],content[2])
    end
end

function BattleNewSystemViewAction:InitChatList(chatType)
    if self:View() then
        self:View():InitChatList(chatType)
    end
end

return BattleNewSystemViewAction()