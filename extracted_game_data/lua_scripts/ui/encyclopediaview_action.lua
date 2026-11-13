---@class EncyclopediaViewAction : ViewBase
EncyclopediaViewAction = class("EncyclopediaViewAction", ViewBaseAction)

function EncyclopediaViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function EncyclopediaViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.EncyclopediaView_ChoosePage, self.ChoosePage)
end

function EncyclopediaViewAction:ChoosePage(page)
    if page == nil or page == EncyclopediaPage.Parts then
        self:View():OnPartsClick()
        return
    end
    self:View():OnAttriClick()
end


---@return EncyclopediaView
function EncyclopediaViewAction:View()
    return self.view
end

return EncyclopediaViewAction()
