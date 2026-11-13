


---@class RaceRankRoomViewAction:ViewBaseAction
RaceRankRoomViewAction = class("RaceRankRoomViewAction",ViewBaseAction)

function RaceRankRoomViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceRankRoomViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceRankRoomView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.RaceRankRoomView_UpdatePlayerReady, self.UpdatePlayerReady)
    self:AddNotificationEvent(UINotifyEvent.RaceRankRoomView_SetMesh, self.UpdateCarMesh)
    self:AddNotificationEvent(UINotifyEvent.RaceRankRoomView_RefreshUI, self.RefreshUI)
end

---@return RaceRankRoomView
function RaceRankRoomViewAction:View()
    return self.view
end

function RaceRankRoomViewAction:SetData()
    if self:View() then
        self:View():SetData()
    end
end

function RaceRankRoomViewAction:UpdatePlayerReady(pid)
    if self:View() then
        self:View():UpdatePlayerReady(pid)
    end
end

function RaceRankRoomViewAction:UpdateCarMesh(pid)
    if self:View() then
        self:View():UpdateCarMesh(pid)
    end
end

function RaceRankRoomViewAction:RefreshUI()
    if self:View() then
        self:View():RefreshUI()
    end
end

return RaceRankRoomViewAction()