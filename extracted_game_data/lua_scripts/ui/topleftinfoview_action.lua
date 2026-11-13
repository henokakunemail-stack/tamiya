


---@class TopLeftInfoViewAction:ViewBaseAction
TopLeftInfoViewAction = class("TopLeftInfoViewAction",ViewBaseAction)

function TopLeftInfoViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function TopLeftInfoViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.Msg_PlayerExp,self.SetExp)
    self:AddNotificationEvent(UINotifyEvent.Msg_PlayerLv,self.SetLv)
    self:AddNotificationEvent(UINotifyEvent.Msg_PlayerIcon,self.SetPlayerIcon)
    self:AddNotificationEvent(UINotifyEvent.Msg_LeftCloseUI,self.CloseAllUI)
end

---@return TopLeftInfoView
function TopLeftInfoViewAction:View()
    return self.view
end

function TopLeftInfoViewAction:SetExp()
    if self:View() then
        self:View():SetExp()
    end
end
function TopLeftInfoViewAction:SetLv()
    if self:View() then
        self:View():SetLv()
    end
end
function TopLeftInfoViewAction:SetPlayerIcon()
    if self:View() then
        self:View():SetPlayerIcon()
    end
end
function TopLeftInfoViewAction:CloseAllUI(flag)
    if self:View() then
        self:View():CloseAllUI(flag)
    end
end

return TopLeftInfoViewAction()