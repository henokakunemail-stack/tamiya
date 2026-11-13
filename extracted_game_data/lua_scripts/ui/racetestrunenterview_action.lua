---@class RaceTestRunEnterViewAction:ViewBaseAction
RaceTestRunEnterViewAction = class("RaceTestRunEnterViewAction",ViewBaseAction)

function RaceTestRunEnterViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceTestRunEnterViewAction:OnRegisterEvents()

    self:AddNotificationEvent(UINotifyEvent.RaceTestRunSetData, self.SetData)
end
---@return RaceTestRunEnterView
function RaceTestRunEnterViewAction:View()
    return self.view
end
function RaceTestRunEnterViewAction:SetData(data)
    if self:View()  then
        self:View():SetData(data)
    end
end


return RaceTestRunEnterViewAction()