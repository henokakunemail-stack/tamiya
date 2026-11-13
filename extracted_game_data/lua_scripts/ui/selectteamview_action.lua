
---@class SelectTeamViewAction:ViewBaseAction
SelectTeamViewAction = class("SelectTeamViewAction",ViewBaseAction)

function SelectTeamViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function SelectTeamViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SelectTeamView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.SelectTeamView_Fight, self.OnClickBtn_Fight)
    self:AddNotificationEvent(UINotifyEvent.SelectTeamView_ClickChange, self.ClickChange)
    self:AddNotificationEvent(UINotifyEvent.SelectTeamView_Swap, self.OnClickBtn_Swap)
    self:AddNotificationEvent(UINotifyEvent.SelectTeamView_Refresh, self.Refresh)
    self:AddNotificationEvent(UINotifyEvent.SelectTeamView_UpdateRewardView, self.UpdateRewardView)

    self:AddNotificationEvent(UINotifyEvent.Msg_PlayerStamina,self.SetCost )
end

---@return SelectTeamView
function SelectTeamViewAction:View()
    return self.view
end

function SelectTeamViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data[1], data[2])
    end
end

function SelectTeamViewAction:OnClickBtn_Fight()
    if self:View() then
        self:View():OnClickBtn_Fight()
    end
end

function SelectTeamViewAction:OnClickBtn_Swap()
    if self:View() then
        self:View():OnClickBtn_Swap()
    end
end

function SelectTeamViewAction:ClickChange(value)
    if self:View() then
        self:View():OnClickChange(value)
    end
end

function SelectTeamViewAction:Refresh()
    if self:View() then
        self:View():RefreshData()
    end
end

function SelectTeamViewAction:UpdateRewardView(node)
    if self:View() then
        self:View():UpdateRewardView(node[1],node[2],node[3])
    end
end

function SelectTeamViewAction:SetCost()
    if self:View() then
        self:View():SetCost()
    end
end


return SelectTeamViewAction()