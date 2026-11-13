---@class CarVerifyHistoryViewAction:ViewBaseAction
CarVerifyHistoryViewAction = class("CarVerifyHistoryViewAction",ViewBaseAction)

function CarVerifyHistoryViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function CarVerifyHistoryViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.CarVerifyHistoryView_SetData,self.SetData)
end

---@return CarVerifyHistoryView
function CarVerifyHistoryViewAction:View()
    return self.view
end

function CarVerifyHistoryViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data[1],data[2])
    end
end

return CarVerifyHistoryViewAction()