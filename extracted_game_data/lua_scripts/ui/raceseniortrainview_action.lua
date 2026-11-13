---@class  RaceSeniorTrainViewAction:ViewBaseAction
RaceSeniorTrainViewAction = class("RaceSeniorTrainViewAction",ViewBaseAction)

function RaceSeniorTrainViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSeniorTrainViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceSeniorTrain_SetLevelList, self.SetLevelList)
    self:AddNotificationEvent(UINotifyEvent.RaceSeniorTrain_Refresh, self.RefreshLevelList)
    self:AddNotificationEvent(UINotifyEvent.RaceSeniorTrain_UpdateBox, self.SetBoxState)
end



---@return  RaceSeniorTrainView
function RaceSeniorTrainViewAction:View()
    return self.view
end


return RaceSeniorTrainViewAction()