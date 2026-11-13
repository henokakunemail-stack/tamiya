----@class CommonFestivalTipsViewAction
CommonFestivalTipsViewAction = class("CommonFestivalTipsViewAction", ViewBaseAction)

function CommonFestivalTipsViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function CommonFestivalTipsViewAction:OnRegisterEvents()

    self:AddNotificationEvent(UINotifyEvent.CommonFestival_RefreshTips, self.RefreshTipsInfo)
    self:AddNotificationEvent(UINotifyEvent.CommonFestival_RefreshTipsCustomGiftLock, self.RefreshTipsInfo)
end

---@return  CommonFestivalTipsView
function CommonFestivalTipsViewAction:View()
    return self.view
end

function CommonFestivalTipsViewAction:RefreshTipsInfo(data)
    if self:View() then
        self:View():RefreshTipsInfo(data[1], data[2], data[3])
    end
end

return CommonFestivalTipsViewAction()