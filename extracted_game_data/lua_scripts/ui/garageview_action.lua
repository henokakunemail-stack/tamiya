
---@class GarageViewAction:ViewBaseAction
GarageViewAction = class("GarageViewAction",ViewBaseAction)

function GarageViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function GarageViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.Msg_Assemble, self.UpdateMsg)
    self:AddNotificationEvent(UINotifyEvent.Msg_PartStarUp, self.UpdateMsg)
    self:AddNotificationEvent(UINotifyEvent.Msg_PartReform, self.UpdateMsg)
    self:AddNotificationEvent(UINotifyEvent.Msg_PartReformLvup, self.UpdateMsg)
    self:AddNotificationEvent(UINotifyEvent.Msg_PartLevelUp, self.UpdateMsg)
    self:AddNotificationEvent(UINotifyEvent.Msg_PartAwake, self.UpdateMsg)
    self:AddNotificationEvent(UINotifyEvent.Msg_PartUp, self.UpdateMsg)
    self:AddNotificationEvent(UINotifyEvent.Msg_PartColor, self.UpdateMsg)
    self:AddNotificationEvent(UINotifyEvent.Msg_ShellGrid, self.UpdateMsgSetAppearance)
    self:AddNotificationEvent(UINotifyEvent.GarageView_ShellHole, self.UpdateMsgSetAppearance)
    self:AddNotificationEvent(UINotifyEvent.Msg_ShellColor, self.UpdateMsgSetAppearance)
    self:AddNotificationEvent(UINotifyEvent.Msg_ShellSticker, self.UpdateMsgSetAppearance)
    self:AddNotificationEvent(UINotifyEvent.Msg_PartInherit, self.UpdateMsg)
    self:AddNotificationEvent(UINotifyEvent.Msg_PartInheritRecastingBack, self.PartInheritRecastingBack)
    self:AddNotificationEvent(UINotifyEvent.Msg_PartLock, self.UpdateMsgPartLock)
    self:AddNotificationEvent(UINotifyEvent.Msg_CarAttrUpdate, self.UpdateMsgCarAttrUpdate)
    self:AddNotificationEvent(UINotifyEvent.Msg_CarIdxOpen, self.UpdateMsgCarIdxOpen)

    self:AddNotificationEvent(UINotifyEvent.GarageView_ResetCar, self.ResetCarMesh)
    self:AddNotificationEvent(UINotifyEvent.GarageView_ResetOrgCar, self.ResetOrgCar)
    self:AddNotificationEvent(UINotifyEvent.GarageView_SetPartListSelect, self.SetPartListSelect)

    self:AddNotificationEvent(UINotifyEvent.GarageView_PartReview, self.PartReview)
    self:AddNotificationEvent(UINotifyEvent.GarageView_ShellHoleReview, self.ShellHoleReview)
    self:AddNotificationEvent(UINotifyEvent.GarageView_ShellColorReview, self.ShellColorReview)
    self:AddNotificationEvent(UINotifyEvent.GarageView_ShellStickerReview, self.ShellStickerReview)
    self:AddNotificationEvent(UINotifyEvent.GarageView_ShellGridReview, self.ShellGridReview)
    self:AddNotificationEvent(UINotifyEvent.GarageView_ReviewPartSticker, self.ReviewPartSticker)


    self:AddNotificationEvent(UINotifyEvent.GarageView_SetPartinfo, self.SetPartinfo)
    self:AddNotificationEvent(UINotifyEvent.GarageView_SetPartinfoByCfg, self.SetPartinfoByCfg)
    self:AddNotificationEvent(UINotifyEvent.GarageView_PartReviewByCfg, self.PartReviewByCfg)
    self:AddNotificationEvent(UINotifyEvent.Msg_PartVerifyAttr, self.OpenVerifyCarResult)

    --self:AddNotificationEvent(UINotifyEvent.GarageView_ShowAttrTip, self.ShowAttrTips)
    --self:AddNotificationEvent(UINotifyEvent.GarageView_ShowFeatureTip, self.ShowFeatureTips)
end

---@return GarageView
function GarageViewAction:View()
    return self.view
end


function GarageViewAction:UpdateMsg(change)
    if self:View() and UIManager:Get():IsViewShow("GarageView") then
        if change==nil then change=true end
        self:View():UpdateMsg(change)
    end
end
function GarageViewAction:UpdateMsgSetAppearance(change)
    if self:View() and UIManager:Get():IsViewShow("GarageView") then
        if change==nil then change=true end
        self:View():UpdateMsg(change)
    end
end

function GarageViewAction:PartInheritRecastingBack(change)
    if self:View() and UIManager:Get():IsViewShow("GarageView") then
        if change==nil then change=true end
        self:View():PartInheritRecastingBack(change)
    end
end

function GarageViewAction:UpdateMsg(change)
    if self:View() and UIManager:Get():IsViewShow("GarageView") then
        if change==nil then change=true end
        self:View():UpdateMsg(change)
    end
end

function GarageViewAction:UpdateMsgPartLock()
    if self:View() and UIManager:Get():IsViewShow("GarageView") then
        self:View():UpdateMsgPartLock()
    end
end

function GarageViewAction:UpdateMsgCarAttrUpdate()
    if self:View() and UIManager:Get():IsViewShow("GarageView") then
        self:View():UpdateMsgCarAttrUpdate()
    end
end

function GarageViewAction:UpdateMsgCarIdxOpen()
    if self:View() and UIManager:Get():IsViewShow("GarageView") then
        self:View():UpdateMsgCarIdxOpen()
    end
end


function GarageViewAction:ResetCarMesh()
    if self:View() and UIManager:Get():IsViewShow("GarageView") then
        self:View():ResetCarMesh()
    end
end
function GarageViewAction:ResetOrgCar()
    if self:View() and UIManager:Get():IsViewShow("GarageView") then
        self:View():SetAppearanceShellInfo()
    end
end
function GarageViewAction:SetPartListSelect()
    if self:View() and UIManager:Get():IsViewShow("GarageView") then
        self:View():SetPartListSelect()
    end
end

function GarageViewAction:PartReview(node)
    self:View():ReviewPart(node[1], node[2],node[3])
end

function GarageViewAction:ShellHoleReview(node)
    self:View():ReviewHole(node)
end

function GarageViewAction:ShellColorReview(node)
    self:View():ReviewColor(node)
end

function GarageViewAction:ShellStickerReview(node)
    self:View():ReviewSticker(node[1],node[2],node[3])
end
function GarageViewAction:ReviewPartSticker(node)
    self:View():ReviewPartSticker(node[1],node[2],node[3],node[4])
end

function GarageViewAction:ShellGridReview(node)
    self:View():ReviewGrid(node[1], node[2])
end





function GarageViewAction:SetPartinfo(param)
    if self:View() then
        self:View():SetPartinfo(param[1], param[2])
    end
end
function GarageViewAction:SetPartinfoByCfg(param)
    if self:View() then
        self:View():SetPartinfoByCfg(param[1],param[2],param[3])
    end
end
function GarageViewAction:PartReviewByCfg(param)
    if self:View() then
        self:View():ReviewPartByCfgId(param[1],param[2],param[3])
    end
end
function GarageViewAction:OpenVerifyCarResult(param)
    if self:View() then
        self:View():OpenVerifyCarResult(param[1],param[2])
    end
end

--function GarageViewAction:ShowAttrTips(param)
--    if self:View() then
--        self:View():ShowAttrTips(param[1], param[2])
--    end
--end
--function GarageViewAction:ShowFeatureTips(param)
--    if self:View() then
--        self:View():ShowFeatureTips(param[1], param[2], param[3])
--    end
--end

return GarageViewAction()