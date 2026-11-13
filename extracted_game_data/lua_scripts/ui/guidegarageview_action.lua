
---@class GuideGarageViewAction:ViewBaseAction
GuideGarageViewAction = class("GuideGarageViewAction",ViewBaseAction)

function GuideGarageViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function GuideGarageViewAction:OnRegisterEvents()
    --self:AddNotificationEvent(UINotifyEvent.Msg_Assemble, self.UpdateMsg)
    --
    --
    --self:AddNotificationEvent(UINotifyEvent.GarageView_ResetCar, self.ResetCarMesh)



    self:AddNotificationEvent(UINotifyEvent.GuideGarageView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.GuideGarageView_SetPartinfo, self.SetPartinfo)
    self:AddNotificationEvent(UINotifyEvent.GuideGarageView_PartReview, self.PartReview)
    self:AddNotificationEvent(UINotifyEvent.GuideGarageView_PartChange, self.PartChange)
    self:AddNotificationEvent(UINotifyEvent.GuideGarageView_PartRemove, self.PartRemove)
    self:AddNotificationEvent(UINotifyEvent.GuideGarageView_ResetCar, self.ResetCarMesh)
    self:AddNotificationEvent(UINotifyEvent.GuideGarageView_ChangeMain, self.ChangeMain)

    --self:AddNotificationEvent(UINotifyEvent.GarageView_ShowAttrTip, self.ShowAttrTips)
    --self:AddNotificationEvent(UINotifyEvent.GarageView_ShowFeatureTip, self.ShowFeatureTips)
end

---@return GuideGarageView
function GuideGarageViewAction:View()
    return self.view
end
function GuideGarageViewAction:SetData(data)
    if self:View() and UIManager:Get():IsViewShow("GuideGarageView") then
        self:View():SetData(data[1],data[2],data[3])
    end
end





function GuideGarageViewAction:UpdateMsgCarAttrUpdate()
    if self:View() and UIManager:Get():IsViewShow("GuideGarageView") then
        self:View():UpdateMsgCarAttrUpdate()
    end
end
function GuideGarageViewAction:ChangeMain()
    if self:View() and UIManager:Get():IsViewShow("GuideGarageView") then
        self:View():BackMain()
    end
end


function GuideGarageViewAction:ResetCarMesh()
    if self:View() and UIManager:Get():IsViewShow("GuideGarageView") then
        self:View():ResetCarMesh()
    end
end

function GuideGarageViewAction:PartReview(node)
    self:View():ReviewPart(node[1], node[2])
end
function GuideGarageViewAction:PartChange(node)
    self:View():PartChange(node[1], node[2])
end
function GuideGarageViewAction:PartRemove(node)
    self:View():PartRemove(node[1], node[2])
end



function GuideGarageViewAction:SetPartinfo(param)
    if self:View() then
        self:View():SetPartinfo(param[1], param[2])
    end
end


return GuideGarageViewAction()