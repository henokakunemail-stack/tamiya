SurveyViewAction = class("SurveyViewAction", ViewBaseAction)
-- Action必加1
function SurveyViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@return SurveyView
function SurveyViewAction:View()
    return self.view
end
-- Action必加2
function SurveyViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SurveyView_UpdateScrollList, self.UpdateScrollList)
end

function SurveyViewAction:UpdateScrollList()
    self:View():UpdateScrollList()
end

-- Action必加3
return SurveyViewAction()