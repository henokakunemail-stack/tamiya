---@class TrackMainViewAction:ViewBaseAction
TrackMainViewAction = class("TrackMainViewAction", ViewBaseAction)

function TrackMainViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@return TrackMainView
function TrackMainViewAction:View()
    return self.view
end

function TrackMainViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.TrackScienceMenuView_InitData, self.UpdateTrackInfo)
    self:AddNotificationEvent(UINotifyEvent.TrackScienceMenuView_UpdateTitleScroll, self.UpdateTitleScrollInfo)
    self:AddNotificationEvent(UINotifyEvent.TrackScienceMenuView_UpdateMouldScroll, self.UpdateMouldItemScrollInfo)
    self:AddNotificationEvent(UINotifyEvent.TrackScienceMenuView_InitTimeData, self.InitTimeList)
    self:AddNotificationEvent(UINotifyEvent.TrackScienceMenuView_UpdateTimeList, self.UpdateTimeList)
    self:AddNotificationEvent(UINotifyEvent.TrackScienceMenuView_InitIntroduceData, self.UpdateIntroduce)
    self:AddNotificationEvent(UINotifyEvent.TrackScienceMenuView_InitManufactureIntroduceData, self.UpdateMenuFactureIntroduce)
end

function TrackMainViewAction:UpdateTrackInfo()
    if self:View() then
        self:View():InitMouldBaseInfo()
    end
end

function TrackMainViewAction:UpdateTitleScrollInfo()
    if self:View() then
        self:View():InitTitleBtnScrollInfo()
    end
end


function TrackMainViewAction:UpdateMouldItemScrollInfo(data)
    if self:View() then
        self:View():InitMouldBtnScrollInfo(data[1])
    end
end


function TrackMainViewAction:InitTimeList(labExpType)
    if self:View() then
        self:View():InitTimeList(labExpType)
    end
end

function TrackMainViewAction:UpdateTimeList()
    if self:View() then
        self:View():UpdateTimeList()
    end
end

function TrackMainViewAction:UpdateIntroduce(data)
    if self:View() then
        self:View():UpdateIntroduce(data[1], data[2])
    end
end

function TrackMainViewAction:UpdateMenuFactureIntroduce(data)
    if self:View() then
        self:View():UpdateManufactureIntroduce(data[1])
    end
end

return TrackMainViewAction()