
---@class MessageBoxViewAction
MessageBoxViewAction = class("MessageBoxViewAction",ViewBaseAction)

function MessageBoxViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function MessageBoxViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.MessageBoxView_SetLayout, self.SetLayout)
    self:AddNotificationEvent(UINotifyEvent.MessageBoxView_ClickToggle, self.ClickToggle)
end

---@return MessageBoxView
function MessageBoxViewAction:View()
    return self.view
end


function MessageBoxViewAction:SetLayout(param)
    if self:View() then
        self:View():SetLayout(param)
    end
end

function MessageBoxViewAction:ClickToggle(param)
    if self:View() then
        self:View():ClickToggle(param)
    end
end



return MessageBoxViewAction()