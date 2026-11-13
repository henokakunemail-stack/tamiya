---@class SpecialTrainingViewAction
SpecialTrainingViewAction = class("SpecialTrainingViewAction", ViewBaseAction)


function SpecialTrainingViewAction:initialize(  )
    ViewBaseAction.initialize(self)
end
---@return SpecialTrainingView
function SpecialTrainingViewAction:View()
    return self.view
end

function SpecialTrainingViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SpecialTrainingViewUpdate,self.SpecialTrainingUpdate)
    self:AddNotificationEvent(UINotifyEvent.SpecialTrainingViewUpdateReward,self.SpecialTrainingUpdateReward)
end
function SpecialTrainingViewAction:SpecialTrainingUpdate()
    self:View():UpdateScrollView()
end
function SpecialTrainingViewAction:SpecialTrainingUpdateReward()
    self:View():SpecialTrainingSetReward()
end


return SpecialTrainingViewAction()