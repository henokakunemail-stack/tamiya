


---@class RaceRoomViewAction:ViewBaseAction
RaceRoomViewAction = class("RaceRoomViewAction",ViewBaseAction)

function RaceRoomViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceRoomViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceRoomView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.RaceRoomView_Refresh, self.Refresh)
    self:AddNotificationEvent(UINotifyEvent.RaceRoomView_UpdateSearch, self.UpdateSearch)
    self:AddNotificationEvent(UINotifyEvent.RaceRoomView_SetViewInfo, self.SetViewInfo)
end

---@return RaceRoomView
function RaceRoomViewAction:View()
    return self.view
end

function RaceRoomViewAction:SetData(param)
    if self:View() then
        self:View():SetData(param)
    end
end

function RaceRoomViewAction:SetViewInfo(param)
    if self:View() then
        self:View():SetLuaViewInfo(param[1],param[2])
    end
end
function RaceRoomViewAction:Refresh()
    if self:View() then
        self:View():Refresh()
    end
end

function RaceRoomViewAction:UpdateSearch(msg)
    if self:View() then
        self:View():UpdateSearch(msg)
    end
end

return RaceRoomViewAction()