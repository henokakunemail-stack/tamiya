
---@class CustomTrackListViewAction:ViewBaseAction
CustomTrackListViewAction = class("CustomTrackListViewAction",ViewBaseAction)

function CustomTrackListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function CustomTrackListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.CustomTrackListViewOpen,self.SetData)
    self:AddNotificationEvent(UINotifyEvent.CustomTrackItemSetData,self.ItemSetData)
end

---@return CustomTrackListView
function CustomTrackListViewAction:View()
    return self.view
end

function CustomTrackListViewAction:SetData()
   self:View():SetData()
end
function CustomTrackListViewAction:ItemSetData(node)
  self:View():SetItem(node[1],node[2])
end

return CustomTrackListViewAction()