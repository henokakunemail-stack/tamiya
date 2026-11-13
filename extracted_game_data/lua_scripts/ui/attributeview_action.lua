



---@class AttributeViewAction:ViewBaseAction
AttributeViewAction = class("AttributeViewAction",ViewBaseAction)

function AttributeViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function AttributeViewAction:OnRegisterEvents()

    self:AddNotificationEvent(UINotifyEvent.AttributeView_SetData,self.SetData)
end


---@return AttributeView
function AttributeViewAction:View()
    return self.view
end

function AttributeViewAction:SetData(type)
    if self:View() then
        self:View():SetData(type)
    end
end


return AttributeViewAction()