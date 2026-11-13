


---@class RaceRoomDetailViewAction:ViewBaseAction
RaceRoomDetailViewAction = class("RaceRoomDetailViewAction",ViewBaseAction)

function RaceRoomDetailViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceRoomDetailViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceRoomDetailView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.RaceRoomDetailView_Revise, self.Revise)
    self:AddNotificationEvent(UINotifyEvent.RaceRoomDetailView_ReviseWithoutMesh, self.ReviseWithoutMesh)
    self:AddNotificationEvent(UINotifyEvent.RaceRoomDetailView_UpdateChatScrollView, self.UpdateChatScrollView)
    self:AddNotificationEvent(UINotifyEvent.RaceRoomDetailView_SetViewInfo, self.SetViewInfo)
end

---@return RaceRoomDetailView
function RaceRoomDetailViewAction:View()
    return self.view
end

function RaceRoomDetailViewAction:SetData()
    if self:View() then
        self:View():SetData()
    end
end

function RaceRoomDetailViewAction:SetViewInfo(param)
    if self:View() then
        self:View():SetLuaViewInfo(param[1],param[2])
    end
end

function RaceRoomDetailViewAction:Revise()
    if self:View() then
        self:View():SetData()
    end
end

function RaceRoomDetailViewAction:ReviseWithoutMesh()
    if self:View() then
        self:View():SetDataWithoutMesh()
    end
end

function RaceRoomDetailViewAction:UpdateChatScrollView(userdata)
    if self:View() then
        self:View():UpdateChatScrollView(userdata)
    end
end


return RaceRoomDetailViewAction()