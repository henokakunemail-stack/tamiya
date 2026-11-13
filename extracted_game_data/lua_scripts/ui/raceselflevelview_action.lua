


---@class RaceSelfLevelViewAction:ViewBaseAction
RaceSelfLevelViewAction = class("RaceSelfLevelViewAction",ViewBaseAction)

function RaceSelfLevelViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSelfLevelViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceSelfLevelViewSetJoin, self.SetJoin)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfLevelViewSetAll, self.SetAll)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfLevelViewSetDetail, self.SetDetail)
end
function RaceSelfLevelViewAction:SetJoin()

    self:View():UpdateTog(2)

end
function RaceSelfLevelViewAction:SetAll()
    self:View():UpdateTog(1)
end

function RaceSelfLevelViewAction:SetDetail(data)
    self:View():SetDetail(data)
end
---@return RaceSelfLevelView
function RaceSelfLevelViewAction:View()
    return self.view
end

return RaceSelfLevelViewAction()