---@class ClubMainMenuViewAction:ViewBaseAction
ClubMainMenuViewAction = class("ClubMainMenuViewAction", ViewBaseAction)

function ClubMainMenuViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@return ClubMainMenuView
function ClubMainMenuViewAction:View()
    return self.view
end
function ClubMainMenuViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ClubMainMenuView_OnExitSuccess, self.OnExitSuccess)
    self:AddNotificationEvent(UINotifyEvent.ClubMainMenuView_InitMemberList, self.InitMemberList)
    self:AddNotificationEvent(UINotifyEvent.ClubMainMenuView_UpdateMemberList, self.UpdateMemberList)
    self:AddNotificationEvent(UINotifyEvent.ClubMainMenuView_InitViewInfo, self.InitViewInfo)
    self:AddNotificationEvent(UINotifyEvent.ClubMainMenuView_UpdateChatScrollView, self.UpdateChatScrollView)
    self:AddNotificationEvent(UINotifyEvent.ClubMainMenuView_UpdateSlider, self.UpdateSlider)
    self:AddNotificationEvent(UINotifyEvent.ClubMainMenuView_OnBtnClick, self.OnBtnClick)
    self:AddNotificationEvent(UINotifyEvent.ClubMainMenuView_SetLuaViewInfo, self.SetLuaViewInfo)
end
function ClubMainMenuViewAction:OnExitSuccess()
    if self:View() then
        self:View():OnExitSuccess()
    end
end

---@param clubMainMenuType ClubMainMenuType
function ClubMainMenuViewAction:InitMemberList(clubMainMenuType)
    if self:View() then
        self:View():InitMemberList(clubMainMenuType)
    end
end

function ClubMainMenuViewAction:UpdateMemberList()
    if self:View() then
        self:View():UpdateMemberList()
    end
end

function ClubMainMenuViewAction:InitViewInfo()
    if self:View() then
        self:View():InitViewInfo()
    end
end

function ClubMainMenuViewAction:UpdateChatScrollView()
    if self:View() then
        self:View():UpdateChatScrollView()
    end
end

function ClubMainMenuViewAction:UpdateSlider()
    if self:View() then
        self:View():UpdateSlider()
    end
end
function ClubMainMenuViewAction:OnBtnClick(param)
    if self:View() then
        self:View():OnBtnClick(param[1],param[2])
    end
end
function ClubMainMenuViewAction:SetLuaViewInfo(param)
    if self:View() then
        self:View():SetLuaViewInfo(param[1],param[2])
    end
end

return ClubMainMenuViewAction()