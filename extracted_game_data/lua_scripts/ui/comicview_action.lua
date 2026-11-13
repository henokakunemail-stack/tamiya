---@class ComicViewAction:ViewBaseAction
ComicViewAction = class("ComicViewAction",ViewBaseAction)

function ComicViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ComicViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ComicView_PlayAction, self.PlayAction)
    self:AddNotificationEvent(UINotifyEvent.ComicView_PlayActionImage, self.PlayActionImage)
end

---@return ComicView
function ComicViewAction:View()
    return self.view
end

function ComicViewAction:PlayAction(param)
    if self:View() then
        self:View():PlayAction(param[1], param[2])
    end
end
function ComicViewAction:PlayActionImage(param)
    if self:View() then
        self:View():PlayActionImage(param[1], param[2])
    end
end


return ComicViewAction()