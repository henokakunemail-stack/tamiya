



---@class TrackListViewAction:ViewBaseAction
TrackListViewAction = class("TrackListViewAction",ViewBaseAction)

function TrackListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function TrackListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.TrackListSetCallBack, self.SetCallBack)
    self:AddNotificationEvent(UINotifyEvent.TrackListSetData, self.SetData)
end

---@return TrackListView
function TrackListViewAction:View()
    return self.view
end

function TrackListViewAction:SetCallBack(data)
    if self:View() then
        self:View():SetCallBack(data[1],data[2],data[3],data[4])
    end
end
function TrackListViewAction:SetData()
    if self:View() then
        self:View():AutoSelect()
    end
end

return TrackListViewAction()