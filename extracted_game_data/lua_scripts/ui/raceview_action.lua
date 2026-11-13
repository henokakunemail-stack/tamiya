---@class RaceViewAction:ViewBaseAction
RaceViewAction = class("RaceViewAction", ViewBaseAction)

function RaceViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceViewAction:OnRegisterEvents()
   -- self:AddNotificationEvent(UINotifyEvent.MainMenuView_InitBtnInfo, self.InitBtnInfo)
end

---@return RaceView
function RaceViewAction:View()
    return self.view
end


return RaceViewAction()