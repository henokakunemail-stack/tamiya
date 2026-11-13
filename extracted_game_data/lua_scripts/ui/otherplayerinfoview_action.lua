---@class OtherPlayerInfoViewAction:ViewBaseAction
OtherPlayerInfoViewAction = class("OtherPlayerInfoViewAction", ViewBaseAction)
-- Action必加1
function OtherPlayerInfoViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@return OtherPlayerInfoView
function OtherPlayerInfoViewAction:View()
    return self.view
end
-- Action必加2
function OtherPlayerInfoViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.PlayerOtherInfoView_SetData,self.SetData)
    self:AddNotificationEvent(UINotifyEvent.PlayerOtherInfoView_SetBtnInfo,self.SetBtnInfo)
end



function OtherPlayerInfoViewAction:SetData(data)
    self:View():SetData(data)
end
function OtherPlayerInfoViewAction:SetBtnInfo()
    self:View():SetBtnInfo()
end


-- Action必加3
return OtherPlayerInfoViewAction()
