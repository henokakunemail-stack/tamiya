
---@class CustomTrackEditorViewAction:ViewBaseAction
CustomTrackEditorViewAction = class("CustomTrackEditorViewAction",ViewBaseAction)

function CustomTrackEditorViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function CustomTrackEditorViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.CustomTrackEditorOpen,self.SetData)
    self:AddNotificationEvent(UINotifyEvent.CustomTrackSaveSuccess,self.SaveSuccess)
    self:AddNotificationEvent(UINotifyEvent.CustomTrackShopBack,self.ShopBack)
    self:AddNotificationEvent(UINotifyEvent.CustomTrackUpdate,self.CustomTrackUpdate)
    self:AddNotificationEvent(UINotifyEvent.TrackSegmentShopViewOpen,self.SetShopData)
    self:AddNotificationEvent(UINotifyEvent.TrackSegmentShopViewClickItem,self.ClickItem)
    self:AddNotificationEvent(UINotifyEvent.TrackSegmentShopViewSetPlayerMoney,self.SetPlayerMoney)
end

---@return CustomTrackEditorView
function CustomTrackEditorViewAction:View()
    return self.view
end

function CustomTrackEditorViewAction:SetData(data)
   self:View():SetData(data[1],data[2])
end
function CustomTrackEditorViewAction:SaveSuccess()
   self:View():SaveTrackSuccess()
end
function CustomTrackEditorViewAction:ShopBack()
   self:View():ShopBack()
end
function CustomTrackEditorViewAction:CustomTrackUpdate()
    if self:View() then
        self:View():UpdateScrollView()
    end
end

function CustomTrackEditorViewAction:SetShopData(shopid)
    self:View():SetShopData(shopid)
end
function CustomTrackEditorViewAction:ClickItem(data)
    self:View():ClickShopItem(data)
end
function CustomTrackEditorViewAction:SetPlayerMoney()
    self:View():SetPlayerMoney()
end


return CustomTrackEditorViewAction()