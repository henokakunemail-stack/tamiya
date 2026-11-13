---@class SeasonOrderTaskViewAction:ViewBaseAction
SeasonOrderTaskViewAction = class("SeasonOrderTaskViewAction", ViewBaseAction)

function SeasonOrderTaskViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return SeasonOrderTaskView
function SeasonOrderTaskViewAction:View()
    return self.view
end

function SeasonOrderTaskViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SeasonOrderTaskView_SetData,self.SetData)
end


function SeasonOrderTaskViewAction:SetData()
    if self:View() then
        self:View():SetData()
    end
end


return SeasonOrderTaskViewAction()