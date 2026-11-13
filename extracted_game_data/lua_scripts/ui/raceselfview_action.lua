


---@class RaceSelfViewAction:ViewBaseAction
RaceSelfViewAction = class("RaceSelfViewAction",ViewBaseAction)

function RaceSelfViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceSelfViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceSelfView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfView_UpdateScrollView, self.UpdateScrollView)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfView_ClickItem, self.ClickItem)
end

---@return RaceSelfView
function RaceSelfViewAction:View()
    return self.view
end

function RaceSelfViewAction:SetData(msg)
    if self:View() then
        self:View():SetData(msg)
    end
end

function RaceSelfViewAction:UpdateScrollView(param)
    if self:View() then
        self:View():UpdateScrollView(param[1], param[2])
    end
end

function RaceSelfViewAction:ClickItem(param)
    if self:View() then
        self:View():ClickBtnScrollViewItem(param)
    end
end

return RaceSelfViewAction()