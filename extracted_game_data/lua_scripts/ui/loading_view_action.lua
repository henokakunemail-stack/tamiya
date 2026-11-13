


---@class LoadingViewAction:ViewBaseAction
LoadingViewAction = class("LoadingViewAction", ViewBaseAction)
-- Action必加1
function LoadingViewAction:initialize(  )
    ViewBaseAction.initialize(self)

end

-- Action必加2
function LoadingViewAction:OnRegisterEvents()
    --logError("LoadingViewAction:OnRegisterEvents")
    self:AddNotificationEvent(UINotifyEvent.LoadingView_IsAutoClose, self.SetAutoClose)
    self:AddNotificationEvent(UINotifyEvent.LoadingView_SetFinishEvt, self.SetFinishEvt)
    self:AddNotificationEvent(UINotifyEvent.UpdateLoadingViewProgress, self.UpdateLoadingProgress)

    self:AddNotificationEvent(UINotifyEvent.UpdateLoadingFinish, self.UpdateLoadingFinish)
end


---@return LoadingView
function LoadingViewAction:View()
    return self.view
end



function LoadingViewAction:SetAutoClose( isclose )
    if self:View() then
        if isclose == nil then isclose = true end
        self:View():SetAutoClose(isclose)
    end
end

function LoadingViewAction:SetFinishEvt( node )
    if self:View() then
        self:View():SetFinishEvt(node[1], node[2])
    end
end

function LoadingViewAction:UpdateLoadingProgress( progress )
    if self:View() then
        self:View():UpdateProgress(progress)
    end
end

function LoadingViewAction:UpdateLoadingFinish()
    if self:View() then
        self:View():UpdateLoadingFinish()
    end
end



-- Action必加3
return LoadingViewAction()