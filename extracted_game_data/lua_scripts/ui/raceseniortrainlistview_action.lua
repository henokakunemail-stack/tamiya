
---@class RaceSeniorTrainListViewAction:ViewBaseAction
RaceSeniorTrainListViewAction = class("RaceSeniorTrainListViewAction",ViewBaseAction)

function RaceSeniorTrainListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSeniorTrainListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceSeniorTrain_SetLevelList, self.SetLevelList)
    self:AddNotificationEvent(UINotifyEvent.RaceSeniorTrain_Refresh, self.RefreshLevelList)
    self:AddNotificationEvent(UINotifyEvent.RaceSeniorTrain_UpdateBox, self.SetBoxState)
end



---@return RaceSeniorTrainListView
function RaceSeniorTrainListViewAction:View()
    return self.view
end
function RaceSeniorTrainListViewAction:SetLevelList(id)
    if self:View() then
        self:View():SetData(id)
    end
end
function RaceSeniorTrainListViewAction:RefreshLevelList()
    if self:View() then
        self:View():RefreshLevelList()
    end
end

function RaceSeniorTrainListViewAction:SetBoxState()
    if self:View() then
        self:View():SetBoxState()
    end
end



return RaceSeniorTrainListViewAction()
