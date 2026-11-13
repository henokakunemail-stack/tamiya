---@class RaceAssembleEnterViewAction:ViewBaseAction
RaceAssembleEnterViewAction = class("RaceAssembleEnterViewAction",ViewBaseAction)

function RaceAssembleEnterViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceAssembleEnterViewAction:OnRegisterEvents()

    self:AddNotificationEvent(UINotifyEvent.RaceAssembleSetData, self.SetData)
end
---@return RaceAssembleEnterView
function RaceAssembleEnterViewAction:View()
    return self.view
end
function RaceAssembleEnterViewAction:SetData(data)
    if self:View()  then
        self:View():SetData()
    end
end


return RaceAssembleEnterViewAction()