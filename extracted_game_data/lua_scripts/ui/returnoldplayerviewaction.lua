----@class ReturnOldPlayerViewAction
ReturnOldPlayerViewAction = class("ReturnOldPlayerViewAction", ViewBaseAction)

function ReturnOldPlayerViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ReturnOldPlayerViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ReturnOldPlayer_RefreshChooseBtn, self.InitChooseData)
    self:AddNotificationEvent(UINotifyEvent.ReturnOldPlayer_SetSign, self.InitSignData)
    self:AddNotificationEvent(UINotifyEvent.ReturnOldPlayer_SetTask, self.InitTaskData)
    self:AddNotificationEvent(UINotifyEvent.ReturnOldPlayer_SetBox, self.InitBoxData)

end

---@return  ReturnOldPlayerView
function ReturnOldPlayerViewAction:View()
    return self.view
end

function ReturnOldPlayerViewAction:InitChooseData()
    if self:View() then
        self:View():InitChooseData()
    end
end

function ReturnOldPlayerViewAction:InitSignData()
    if self:View() then
        self:View():InitSignData()
    end
end

function ReturnOldPlayerViewAction:InitTaskData()
    if self:View() then
        self:View():InitTaskData()
    end
end

function ReturnOldPlayerViewAction:InitBoxData(msg)
    if self:View() then
        self:View():InitBoxData(msg)
    end
end

function ReturnOldPlayerViewAction:SetLastObjState(msg)
    if self:View() then
        self:View():SetLastObjState(msg)
    end
end

return ReturnOldPlayerViewAction()