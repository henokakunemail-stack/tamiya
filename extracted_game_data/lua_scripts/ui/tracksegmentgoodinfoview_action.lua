---@class TrackSegmentGoodInfoViewAction:ViewBaseAction
TrackSegmentGoodInfoViewAction = class("TrackSegmentGoodInfoViewAction",ViewBaseAction)

function TrackSegmentGoodInfoViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function TrackSegmentGoodInfoViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.TrackSegmentSetGoodsInfoView, self.SetData)
end
---@return TrackSegmentGoodInfoView
function TrackSegmentGoodInfoViewAction:View()
    return self.view
end
function TrackSegmentGoodInfoViewAction:SetData(id)
    self:View():SetData(id)
end

return TrackSegmentGoodInfoViewAction()
