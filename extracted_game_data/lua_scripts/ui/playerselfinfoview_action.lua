---@class PlayerSelfInfoViewAction:ViewBaseAction
PlayerSelfInfoViewAction = class("PlayerSelfInfoViewAction", ViewBaseAction)
-- Action必加1
function PlayerSelfInfoViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@return PlayerSelfInfoView
function PlayerSelfInfoViewAction:View()
    return self.view
end
-- Action必加2
function PlayerSelfInfoViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.PlayerSelfInfoViewUpdateTog, self.UpdateTog)
    self:AddNotificationEvent(UINotifyEvent.PlayerSelfInfoViewSetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.PlayerSelfInfoView_ChangeSign,self.ChangeSign)
    self:AddNotificationEvent(UINotifyEvent.PlayerSelfInfoView_ChangeName,self.ChangeName)
    self:AddNotificationEvent(UINotifyEvent.Msg_PlayerIcon,self.UpdatePlayerIcon)
end

function PlayerSelfInfoViewAction:UpdateTog(data)
    if self:View()~=nil then
        if data[2]~=nil then
            self:View():UpdateTog(data[1],data[2])
        else
            self:View():UpdateTog(data[1])
        end
    end
end

function PlayerSelfInfoViewAction:SetData(data)
    if self:View()~=nil then
        self:View():SetData(data[1],data[2])
    end
end

function PlayerSelfInfoViewAction:ChangeSign(sign)
    if self:View()~=nil then
        self:View():SetSign(sign)
    end
end
function PlayerSelfInfoViewAction:ChangeName(name)
    if self:View()~=nil then
        self:View():SetName(name)
    end
end
function PlayerSelfInfoViewAction:UpdatePlayerIcon()
    if self:View()~=nil then
        self:View():UpdatePlayerIcon()
    end
end
-- Action必加3
return PlayerSelfInfoViewAction()
