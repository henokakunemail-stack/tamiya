


---@class RaceRoomCreateViewAction:ViewBaseAction
RaceRoomCreateViewAction = class("RaceRoomCreateViewAction",ViewBaseAction)

function RaceRoomCreateViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceRoomCreateViewAction:OnRegisterEvents()
   self:AddNotificationEvent(UINotifyEvent.RaceRoomView_CreateViewAuto, self.AutoSelect)
end

---@return RaceRoomCreateView
function RaceRoomCreateViewAction:View()
    return self.view
end

function RaceRoomCreateViewAction:AutoSelect()
    if self:View() then
        self:View():AutoSelect()
    end
end


return RaceRoomCreateViewAction()
















--
--
--

--RaceRoomCreateViewAction = class("RaceRoomCreateViewAction",ViewBaseAction)
--
--function RaceRoomCreateViewAction:initialize()
--    ViewBaseAction.initialize(self)
--end
--
--function RaceRoomCreateViewAction:OnRegisterEvents()
--    self:AddNotificationEvent(UINotifyEvent.RaceRoomCreateView_TogRoomType, self.TogRoomType)
--    self:AddNotificationEvent(UINotifyEvent.RaceRoomCreateView_TogRuleType, self.TogRuleType)
--    self:AddNotificationEvent(UINotifyEvent.RaceRoomCreateView_TogObserverType, self.TogObserverType)
--    self:AddNotificationEvent(UINotifyEvent.RaceRoomCreateView_TogPasswdType, self.TogPasswdType)
--    self:AddNotificationEvent(UINotifyEvent.RaceRoomCreateView_ClickBtnReview, self.ClickBtnReview)
--    self:AddNotificationEvent(UINotifyEvent.RaceRoomCreateView_ClickBtnChangeTrack, self.ClickBtnChangeTrack)
--    self:AddNotificationEvent(UINotifyEvent.RaceRoomCreateView_ClickBtnCreate, self.ClickBtnCreate)
--    self:AddNotificationEvent(UINotifyEvent.RaceRoomCreateView_SetTrackData, self.SetTrackData)
--end
--
-----@return RaceRoomCreateView
--function RaceRoomCreateViewAction:View()
--    return self.view
--end
--
--function RaceRoomCreateViewAction:TogRoomType(idx)
--    if self:View() then
--        self:View():OnClickTog_RoomType(idx)
--    end
--end
--
--function RaceRoomCreateViewAction:TogRuleType(idx)
--    if self:View() then
--        self:View():OnClickTog_RuleType(idx)
--    end
--end
--
--function RaceRoomCreateViewAction:TogObserverType(idx)
--    if self:View() then
--        self:View():OnClickTog_ObserverType(idx)
--    end
--end
--
--function RaceRoomCreateViewAction:TogPasswdType(idx)
--    if self:View() then
--        self:View():OnClickTog_PasswdType(idx)
--    end
--end
--
--function RaceRoomCreateViewAction:ClickBtnReview()
--    if self:View() then
--        self:View():OnClickBtn_Review()
--    end
--end
--
--function RaceRoomCreateViewAction:ClickBtnChangeTrack()
--    if self:View() then
--        self:View():OnClickBtn_ChangeTrack()
--    end
--end
--
--function RaceRoomCreateViewAction:ClickBtnCreate()
--    if self:View() then
--        self:View():OnClickBtn_Create()
--    end
--end
--
--function RaceRoomCreateViewAction:SetTrackData(node)
--    if self:View() then
--        self:View():SetTrackData(node)
--    end
--end
--
--return RaceRoomCreateViewAction()