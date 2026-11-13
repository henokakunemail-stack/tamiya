---@class SeasonOrderLevelViewAction:ViewBaseAction
SeasonOrderLevelViewAction = class("SeasonOrderLevelViewAction", ViewBaseAction)

function SeasonOrderLevelViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return SeasonOrderLevelView
function SeasonOrderLevelViewAction:View()
    return self.view
end

function SeasonOrderLevelViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SeasonOrderLevelView_SetData,self.SetData)
end


function SeasonOrderLevelViewAction:SetData(msg)
    if self:View() then
        self:View():SetData(msg[1],msg[2])
    end
end


return SeasonOrderLevelViewAction()