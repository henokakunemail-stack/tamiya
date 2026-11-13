


---@class BagViewAction:ViewBaseAction
BagViewAction = class("BagViewAction",ViewBaseAction)

function BagViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function BagViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.BagViewRefresh, self.Refresh)
end

---@return BagView
function BagViewAction:View()
    return self.view
end

function BagViewAction:SetData()
    if self:View() then
        --self:View():SetData()
    end
end
function BagViewAction:Refresh(data)
    if self:View() and UIManager:Get():IsViewShow("BagView") then
       self:View():RefreshCurList(data)
    end
end

return BagViewAction()