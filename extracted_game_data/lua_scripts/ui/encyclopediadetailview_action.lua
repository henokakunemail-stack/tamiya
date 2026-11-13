---@class EncyclopediaDetailViewAction : ViewBase
EncyclopediaDetailViewAction = class("EncyclopediaDetailViewAction", ViewBaseAction)

function EncyclopediaDetailViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function EncyclopediaDetailViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.EncyclopediaDetailView_SetData, self.SetData)
end

function EncyclopediaDetailViewAction:SetData(param)
    self:View():SetData(param[1],param[2],param[3])
end


---@return EncyclopediaDetailView
function EncyclopediaDetailViewAction:View()
    return self.view
end

return EncyclopediaDetailViewAction()
