
---@class TrackSegmentShopViewAction:ViewBaseAction
TrackSegmentShopViewAction = class("TrackSegmentShopViewAction",ViewBaseAction)

function TrackSegmentShopViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function TrackSegmentShopViewAction:OnRegisterEvents()

end

---@return TrackSegmentShopView
function TrackSegmentShopViewAction:View()
    return self.view
end

function TrackSegmentShopViewAction:SetData()
    self:View():SetData()
end
function TrackSegmentShopViewAction:ClickItem(data)
    self:View():ClickItem(data)
end
function TrackSegmentShopViewAction:SetPlayerMoney()
    self:View():SetPlayerMoney()
end


return TrackSegmentShopViewAction()