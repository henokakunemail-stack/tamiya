
---@class TrackSegmentNeedViewAction:ViewBaseAction
TrackSegmentNeedViewAction = class("TrackSegmentNeedViewAction",ViewBaseAction)

function TrackSegmentNeedViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function TrackSegmentNeedViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.TrackSegmentShopViewSetPlayerMoney,self.SetPlayerMoney)
end

---@return TrackSegmentNeedView
function TrackSegmentNeedViewAction:View()
    return self.view
end
function TrackSegmentNeedViewAction:SetPlayerMoney()
    if self:View() then
        self:View():SetPlayerMoney()
    end
end

function TrackSegmentNeedViewAction:SetData()
    self:View():SetData()
end
function TrackSegmentNeedViewAction:ItemSetData(node)
    self:View():SetItem(node[1],node[2])
end

return TrackSegmentNeedViewAction()