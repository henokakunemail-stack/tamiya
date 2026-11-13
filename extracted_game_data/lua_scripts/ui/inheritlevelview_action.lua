---@class InheritLevelViewAction:ViewBaseAction
InheritLevelViewAction = class("InheritLevelViewAction",ViewBaseAction)

function InheritLevelViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function InheritLevelViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.InheritLevelView_SetData,self.SetData)
end

---@return InheritLevelView
function InheritLevelViewAction:View()
    return self.view
end

function InheritLevelViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data[1],data[2])
    end
end

return InheritLevelViewAction()