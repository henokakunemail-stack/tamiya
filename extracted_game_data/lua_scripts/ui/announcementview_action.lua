---@class AnnouncementViewAction:ViewBaseAction
AnnouncementViewAction = class("AnnouncementViewAction",ViewBaseAction)

function AnnouncementViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return AnnouncementView
function AnnouncementViewAction:View()
    return self.view
end
function AnnouncementViewAction:OnRegisterEvents()
 self:AddNotificationEvent(UINotifyEvent.AnnouncementViewOpen,self.SetContent)
 self:AddNotificationEvent(UINotifyEvent.AnnouncementViewSetContent,self.SetData)
end

function AnnouncementViewAction:SetContent()
    self:View():SetContent()
    QuickTa:Get():TrackEvent(TrackEventNames.FirstOpenAnnouncement,nil,TrackEventType.First)
end
function AnnouncementViewAction:SetData()
    self:View():SetData()
end



return AnnouncementViewAction()