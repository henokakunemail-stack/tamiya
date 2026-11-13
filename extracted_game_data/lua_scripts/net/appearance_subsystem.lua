

---@class AppearanceSubsystem
AppearanceSubsystem = class("AppearanceSubsystem")

function AppearanceSubsystem:initialize( ... )
    NetResponseEventManager:Get():AddListener(MsgID.SHELL_HOLE_S2C_RES , self, self.RecvMsg_Lightweight)
    NetResponseEventManager:Get():AddListener(MsgID.SHELL_SCARF_S2C_RES , self, self.RecvMsg_ShellGrid)
    NetResponseEventManager:Get():AddListener(MsgID.SHELL_COLOR_S2C_RES , self, self.RecvMsg_ShellColor)
    NetResponseEventManager:Get():AddListener(MsgID.SHELL_ALTER_STICK_S2C_RES , self, self.RecvMsg_ShellSticker)
    NetResponseEventManager:Get():AddListener(MsgID.SHELL_RESET_S2C_RES , self, self.RecvMsg_ShellReset)
end

-------------------------------------------------------------车壳换色
function AppearanceSubsystem:SendMsg_ShellColor(shellid, colorid)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),shellid,colorid})
    NetManager:Get():Send(MsgID.SHELL_COLOR_C2S_REQ, reqBytes)
end
function AppearanceSubsystem:RecvMsg_ShellColor(data)
    ---@type SC_UserAlterShell
    local msg = assert(Dll_PB.decode("UserAlterShell", data))
    print(ProtoMsgHelp.block(msg))

    local data = KnapsackDataManager:Get():GetArticleByID(msg.curPart.partinx)
    data:UpdatePartShellColor(msg.curPart.colorid)
    if CarDataManager:Get():GetCarDataByCarID(data:GetCarId()) then
        CarDataManager:Get():GetCarDataByCarID(data:GetCarId()):SetShellColor(msg.curPart.colorid)
    end
    KnapsackDataManager:Get():UpdatePropByConsume(msg.consumeProp)
    UINotify:Get():SendNotification(UINotifyEvent.Msg_ShellColor)
    CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ShellColorSucceed))
end
-------------------------------------------------------------


-------------------------------------------------------------车壳换贴纸
function AppearanceSubsystem:SendMsg_ShellSticker(shellid, colorid)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),shellid,colorid})
    NetManager:Get():Send(MsgID.SHELL_ALTER_STICK_C2S_REQ, reqBytes)
end
function AppearanceSubsystem:RecvMsg_ShellSticker(data)
    ---@type SC_UserAlterShell
    local msg = assert(Dll_PB.decode("UserAlterShell", data))
    print(ProtoMsgHelp.block(msg))
    KnapsackDataManager:Get():UpdatePropByConsume(msg.consumeProp)
    local data = KnapsackDataManager:Get():GetArticleByID(msg.curPart.partinx)
    data:UpdatePartShellSticker(msg.curPart.stickerid)
    if data:GetPartType()==PartType.Shell then
        if CarDataManager:Get():GetCarDataByCarID(data:GetCarId()) then
            CarDataManager:Get():GetCarDataByCarID(data:GetCarId()):SetShellSticker(msg.curPart.stickerid)
        end
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ShellStickerSucceed))
    else
        if CarDataManager:Get():GetCarDataByCarID(data:GetCarId()) then
            CarDataManager:Get():GetCarDataByCarID(data:GetCarId()):GetPartByBagID(data:GetCellID()):UpdateSticker(msg.curPart.stickerid)
        end
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.PartStickerSucceed))
    end
    UINotify:Get():SendNotification(UINotifyEvent.Msg_ShellSticker)

end
-------------------------------------------------------------
local _ResetType=nil
-------------------------------------------------------------车壳换贴纸
function AppearanceSubsystem:SendMsg_ResetSticker(cell,typeId, holeid)
    _ResetType=typeId
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),cell,typeId,holeid})
    NetManager:Get():Send(MsgID.SHELL_RESET_C2S_REQ, reqBytes)
end
function AppearanceSubsystem:RecvMsg_ShellReset(data)
    ---@type SC_UserAlterShell
    local msg = assert(Dll_PB.decode("UserAlterShell", data))
    print(ProtoMsgHelp.block(msg))
    KnapsackDataManager:Get():UpdatePropByConsume(msg.consumeProp)
    local data = KnapsackDataManager:Get():GetArticleByID(msg.curPart.partinx)
    data:OnInitPart(msg.curPart)
    if CarDataManager:Get():GetCarDataByCarID(data:GetCarId()) then
        CarDataManager:Get():GetCarDataByCarID(data:GetCarId()):SetShellColor(data:GetColor())
        CarDataManager:Get():GetCarDataByCarID(data:GetCarId()):SetShellSticker(data:GetSticker())
        CarDataManager:Get():GetCarDataByCarID(data:GetCarId()):SetLightweight(msg.curPart.shellhole)
        CarDataManager:Get():GetCarDataByCarID(data:GetCarId()):SetCopyShellId(data:GetChangeIdx())
        CarDataManager:Get():GetCarDataByCarID(data:GetCarId()):SetCopyShellColor(data:GetPartChangeShellColor())
        CarDataManager:Get():GetCarDataByCarID(data:GetCarId()):SetCopyShellSticker(data:GetPartChangeShellSticker())
        CarDataManager:Get():GetCarDataByCarID(data:GetCarId()):SetCopyLightweight(data:GetPartChangeShellGridList(),data:GetPartChangeLightweight())
    end
    if data:GetCarId() > 0 then
        CarDataManager:Get():UpdateCarAttrByCarId(data:GetCarId(), msg.carAttrs)
    end
    UINotify:Get():SendNotification(UINotifyEvent.Msg_ShellGrid)
    if _ResetType==AppearanceType.Inherit then
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.PartInheritResetSucceed))
    else
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ShellResetSucceed))
    end

end
-------------------------------------------------------------


-------------------------------------------------------------车壳轻量化
function AppearanceSubsystem:SendMsg_Lightweight(carid, index)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),carid,index})
    NetManager:Get():Send(MsgID.SHELL_HOLE_C2S_REQ, reqBytes)
end
function AppearanceSubsystem:RecvMsg_Lightweight(data)
    ---@type SC_UserPart
    local msg = assert(Dll_PB.decode("UserPart", data))
    print(ProtoMsgHelp.block(msg))

    local data = KnapsackDataManager:Get():GetArticleByID(msg.partinx)
    data:UpdatePartLightweight(msg.shellhole)
    if CarDataManager:Get():GetCarDataByCarID(data:GetCarId()) then
        CarDataManager:Get():GetCarDataByCarID(data:GetCarId()):SetLightweight(msg.shellhole)
    end
    UINotify:Get():SendNotification(UINotifyEvent.GarageView_ShellHole)
end
-------------------------------------------------------------

-------------------------------------------------------------车壳纱网
function AppearanceSubsystem:SendMsg_ShellGrid(carid, index, gridid)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),carid,index,gridid})
    NetManager:Get():Send(MsgID.SHELL_SCARF_C2S_REQ, reqBytes)
end
function AppearanceSubsystem:RecvMsg_ShellGrid(data)
    ---@type SC_UserAlterShell
    local msg = assert(Dll_PB.decode("UserAlterShell", data))
    print(ProtoMsgHelp.block(msg))

    local data = KnapsackDataManager:Get():GetArticleByID(msg.curPart.partinx)
    data:UpdatePartLightweight(msg.curPart.shellhole)
    KnapsackDataManager:Get():UpdatePropByConsume(msg.consumeProp)
    if CarDataManager:Get():GetCarDataByCarID(data:GetCarId()) then
        CarDataManager:Get():GetCarDataByCarID(data:GetCarId()):SetLightweight(msg.curPart.shellhole)
    end
    UINotify:Get():SendNotification(UINotifyEvent.Msg_ShellGrid)
    CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ShellGridSucceed))
end
-------------------------------------------------------------




local __subsystem = AppearanceSubsystem()
function AppearanceSubsystem:Get() return __subsystem end
return __subsystem