
---@class BagPartInfoViewAction:ViewBaseAction
BagPartInfoViewAction = class("BagPartInfoViewAction",ViewBaseAction)

function BagPartInfoViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function BagPartInfoViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.BagPartInfoViewSetData, self.SetData)
end
---@return BagPartInfoView
function BagPartInfoViewAction:View()
    return self.view
end

function BagPartInfoViewAction:SetData(date)
    if self:View() then
        self:View():SetData(date)
    end
end

return BagPartInfoViewAction()