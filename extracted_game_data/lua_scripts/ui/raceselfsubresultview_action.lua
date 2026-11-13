---@class RaceSelfSubResultViewAction:ViewBaseAction
RaceSelfSubResultViewAction = class("RaceSelfSubResultViewAction",ViewBaseAction)

function RaceSelfSubResultViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSelfSubResultViewAction:OnRegisterEvents()
   -- self:AddNotificationEvent(UINotifyEvent.PVPRankResultView_ClickCarInfo, self.ClickCarInfo)
end

---@return RaceSelfSubResultView
function RaceSelfSubResultViewAction:View()
    return self.view
end

function RaceSelfSubResultViewAction:ClickCarInfo(idx)
    if self:View() then
        self:View():OnClickBtn_CarInfo(idx)
    end
end




return RaceSelfSubResultViewAction()