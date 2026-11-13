---@class RecruitShowViewAction:ViewBaseAction
RecruitShowViewAction = class("RecruitShowViewAction", ViewBaseAction)

function RecruitShowViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RecruitShowViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RecruitShowView_InitViewInfo, self.InitViewInfo)

    self:AddNotificationEvent(UINotifyEvent.RecruitShowView_SkipAni, self.SkipAni)
    self:AddNotificationEvent(UINotifyEvent.RecruitShowView_LoadCars, self.LoadCar)
    self:AddNotificationEvent(UINotifyEvent.RecruitShowView_FirstShareClose, self.FirstShareClose)
end

---@return RecruitShowView
function RecruitShowViewAction:View()
    return self.view
end

function RecruitShowViewAction:SkipAni()
    if self:View() then
        self:View():SkipAni()
    end
end

function RecruitShowViewAction:InitViewInfo(data)
    if self:View() then
        self:View():InitViewInfo(data[1], data[2],data[3])
    end
end

function RecruitShowViewAction:LoadCar(data)
    if self:View() then
        self:View():LoadCars(data)
    end
end

function RecruitShowViewAction:FirstShareClose()
    if self:View() then
        self:View():FirstShareClose()
    end
end

return RecruitShowViewAction()