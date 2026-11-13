
---@class SwapViewAction:ViewBaseAction
SwapViewAction = class("SwapViewAction",ViewBaseAction)

function SwapViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function SwapViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SwapView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.SwapView_ClickNum, self.ClickNum)
end

---@return SwapView
function SwapViewAction:View()
    return self.view
end

function SwapViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data)
    end
end

function SwapViewAction:ClickNum(value)
    if self:View() then
        self:View():OnClickBtn_Num(value)
    end
end




return SwapViewAction()