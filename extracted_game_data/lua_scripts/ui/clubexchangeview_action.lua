---@class ClubMessageViewAction:ViewBaseAction
ClubExchangeViewAction = class("ClubExchangeViewAction",ViewBaseAction)


function ClubExchangeViewAction:initialize()
    ViewBaseAction.initialize(self)
end


---@return ClubExchangeView
function ClubExchangeViewAction:View()
    return self.view
end
function ClubExchangeViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ClubExchangeView_UpdateExchangeViewInfo, self.UpdateExchangeViewInfo)
    self:AddNotificationEvent(UINotifyEvent.ClubExchangeView_UpdateExchangePlayerAttr, self.UpdateExchangePlayerAttr)
end


function ClubExchangeViewAction:UpdateExchangeViewInfo(msg)
    if self:View() then
        self:View():UpdateExchangeViewInfo(msg)
    end
end
function ClubExchangeViewAction:UpdateExchangePlayerAttr(msg)
    if self:View() then
        self:View():UpdateExchangePlayerAttr(msg)
    end
end




return ClubExchangeViewAction()

