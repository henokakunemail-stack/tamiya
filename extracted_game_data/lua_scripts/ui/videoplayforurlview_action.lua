
---@class VideoPlayForUrlViewAction:ViewBaseAction
VideoPlayForUrlViewAction = class("VideoPlayForUrlViewAction",ViewBaseAction)

function VideoPlayForUrlViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function VideoPlayForUrlViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.VideoPlayer_Play, self.VideoPlayer_Play)
end

---@return VideoPlayForUrlView
function VideoPlayForUrlViewAction:View()
    return self.view
end

function VideoPlayForUrlViewAction:VideoPlayer_Play(param)
    if  self:View() then
        self:View():Play(param[1],param[2],param[3],param[4],param[5])
    end
end



return VideoPlayForUrlViewAction()