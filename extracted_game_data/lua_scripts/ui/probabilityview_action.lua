
---@class ProbabilityViewAction:ViewBaseAction
ProbabilityViewAction = class("ProbabilityViewAction",ViewBaseAction)

function ProbabilityViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ProbabilityViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ProbabilityView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.ProbabilityView_UpdateScroll, self.UpdateScrollView)
end

---@return ProbabilityView
function ProbabilityViewAction:View()
    return self.view
end

function ProbabilityViewAction:SetData()
    if self:View() then
        self:View():InitProList()
    end
end

function ProbabilityViewAction:UpdateScrollView(node)
    if self:View() then
        self:View():UpdateScrollView(node[1], node[2], node[3] )
    end
end


return ProbabilityViewAction()