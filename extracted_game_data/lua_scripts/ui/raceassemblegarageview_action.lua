
---@class RaceAssembleGarageViewAction:ViewBaseAction
RaceAssembleGarageViewAction = class("RaceAssembleGarageViewAction",ViewBaseAction)

function RaceAssembleGarageViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceAssembleGarageViewAction:OnRegisterEvents()

    self:AddNotificationEvent(UINotifyEvent.AssembleGarageView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.AssembleGarageView_SetPartinfo, self.SetPartinfo)
    self:AddNotificationEvent(UINotifyEvent.AssembleGarageView_PartReview, self.PartReview)
    self:AddNotificationEvent(UINotifyEvent.AssembleGarageView_ResetCar, self.ResetCarMesh)
    self:AddNotificationEvent(UINotifyEvent.AssembleGarageView_Assemble, self.UpdateMsg)

end

---@return RaceAssembleGarageView
function RaceAssembleGarageViewAction:View()
    return self.view
end
function RaceAssembleGarageViewAction:SetData(data)
    if self:View() and UIManager:Get():IsViewShow("RaceAssembleGarageView") then
        self:View():SetData(data[1],data[2],data[3])
    end
end


function RaceAssembleGarageViewAction:UpdateMsg(change)
    if self:View() and UIManager:Get():IsViewShow("RaceAssembleGarageView") then
        if change==nil then change=true end
        self:View():UpdateMsg(change)
    end
end

function RaceAssembleGarageViewAction:ResetCarMesh()
    if self:View() and UIManager:Get():IsViewShow("RaceAssembleGarageView") then
        self:View():ResetCarMesh()
    end
end

function RaceAssembleGarageViewAction:PartReview(node)
    self:View():ReviewPart(node[1], node[2])
end

function RaceAssembleGarageViewAction:SetPartinfo(param)
    if self:View() then
        self:View():SetPartinfo(param[1], param[2])
    end
end


return RaceAssembleGarageViewAction()