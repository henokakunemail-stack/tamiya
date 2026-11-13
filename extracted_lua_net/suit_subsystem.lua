

---@class SuitSubsystem
SuitSubsystem = class("SuitSubsystem")

function SuitSubsystem:initialize( ... )
    --NetResponseEventManager:Get():AddListener(MsgID.GET_ALL_CAR_PLAN_S2C_RES , self, self.RecvMsg_GetList)
    --NetResponseEventManager:Get():AddListener(MsgID.GET_CAR_PLAN_DETAIL_S2C_RES , self, self.RecvMsg_GetDetail)
    --NetResponseEventManager:Get():AddListener(MsgID.CHANGE_CAR_PLAN_NAME_S2C_RES , self, self.RecvMsg_ChangeName)
    --NetResponseEventManager:Get():AddListener(MsgID.USE_CAR_PLAN_S2C_RES , self, self.RecvMsg_UseSuit)
    --NetResponseEventManager:Get():AddListener(MsgID.EQUIP_CAR_PLAN_S2C_RES , self, self.RecvMsg_AddPart)
    --NetResponseEventManager:Get():AddListener(MsgID.UNEQUIP_CAR_PLAN_S2C_RES , self, self.RecvMsg_RemovePart)
end



-------------------------------------------------------------获取套装数据
function SuitSubsystem:SendMsg_GetList()
    NetManager:Get():Send(OldMsgID.GET_ALL_CAR_PLAN_C2S_REQ, "")
end
function SuitSubsystem:RecvMsg_GetList(data)
    ---@type SC_GetAllCarPlanRes
    local msg = assert(Dll_PB.decode("GetAllCarPlanRes", data))
    print(ProtoMsgHelp.block(msg))

    SuitDataManager:Get():SetList(msg)
    UINotify:Get():SendNotification(UINotifyEvent.SuitListView_SetMsgData)
end
-------------------------------------------------------------


-------------------------------------------------------------详细数据
function SuitSubsystem:SendMsg_GetDetail(idx)
    local reqData = {
        idx = idx,
    }
    local reqBytes = assert(Dll_PB.encode("GetCarPlanDetailReq", reqData))
    NetManager:Get():Send(OldMsgID.GET_CAR_PLAN_DETAIL_C2S_REQ, reqBytes)
end
function SuitSubsystem:RecvMsg_GetDetail(data)
    ---@type SC_GetCarPlanDetailRes
    local msg = assert(Dll_PB.decode("GetCarPlanDetailRes", data))
    print(ProtoMsgHelp.block(msg))

    SuitDataManager:Get():SetSuitDetail(msg)

    SuitDataManager:Get():TryOpenTransformView(msg)
end
-------------------------------------------------------------


-------------------------------------------------------------改名
function SuitSubsystem:SendMsg_ChangeName(idx, name)
    local reqData = {
        idx = idx,
        name = name,
    }
    local reqBytes = assert(Dll_PB.encode("ChangeCarPlanNameReq", reqData))
    NetManager:Get():Send(OldMsgID.CHANGE_CAR_PLAN_NAME_C2S_REQ, reqBytes)
end
function SuitSubsystem:RecvMsg_ChangeName(data)
    ---@type SC_ChangeCarPlanNameRes
    local msg = assert(Dll_PB.decode("ChangeCarPlanNameRes", data))
    print(ProtoMsgHelp.block(msg))

    SuitDataManager:Get():SetSuitName(msg.idx, msg.name)
    UINotify:Get():SendNotification(UINotifyEvent.SuitListView_RefreshScroll)
end
-------------------------------------------------------------


-------------------------------------------------------------使用套装
function SuitSubsystem:SendMsg_UseSuit(caridx, idx)
    local reqData = {
        carIdx = caridx,
        carPlanIdx = idx,
    }
    local reqBytes = assert(Dll_PB.encode("UseCarPlanReq", reqData))
    NetManager:Get():Send(OldMsgID.USE_CAR_PLAN_C2S_REQ, reqBytes)
end
function SuitSubsystem:RecvMsg_UseSuit(data)
    ---@type SC_UseCarPlanRes
    local msg = assert(Dll_PB.decode("UseCarPlanRes", data))
    print(ProtoMsgHelp.block(msg))
    CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.SuitUseSucceed))
    UIManager:Get():HidePersistentView("SuitListView")
    --UINotify:Get():SendNotification(UINotifyEvent.GarageView_UpdateViewCache, false)


    KnapsackDataManager:Get():UpdatePartBelong(msg.partBelongs)
    CarCacheManager:Get():UpdateCache()
end
-------------------------------------------------------------


-------------------------------------------------------------更换配件
function SuitSubsystem:SendMsg_AddPart(idx, bagid, pos)
    local reqBytes = self:Encode(idx, bagid, pos)
    NetManager:Get():Send(OldMsgID.EQUIP_CAR_PLAN_C2S_REQ, reqBytes)
end
function SuitSubsystem:RecvMsg_AddPart(data)
    ---@type SC_Equip2CarPlanRes
    local msg = self:Decode(data)
    self:UpdateCarData(msg)
    UINotify:Get():SendNotification(UINotifyEvent.Msg_Assemble)
    CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.AssembleSucceed))
end
function SuitSubsystem:SendMsg_RemovePart(idx, bagid, pos)
    local reqBytes = self:Encode(idx, bagid, pos)
    NetManager:Get():Send(OldMsgID.UNEQUIP_CAR_PLAN_C2S_REQ, reqBytes)
end
function SuitSubsystem:RecvMsg_RemovePart(data)
    ---@type SC_Equip2CarPlanRes
    local msg = self:Decode(data)
    self:UpdateCarData(msg)
    UINotify:Get():SendNotification(UINotifyEvent.Msg_Assemble)
    CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.DisassembleSucceed))
end

function SuitSubsystem:Encode(idx, bagid, pos)
    print("---   SuitSubsystem:Encode ",idx, bagid, pos)
    local reqData = {
        idx = idx,
        partId = bagid,
        pos = pos,
        flag = 1,
    }
    local reqBytes = assert(Dll_PB.encode("Equip2CarPlanReq", reqData))
    return reqBytes
end

---@return SC_Equip2CarPlanRes
function SuitSubsystem:Decode(data)
    ---@type SC_Equip2CarPlanRes
    local msg = assert(Dll_PB.decode("Equip2CarPlanRes", data))
    print(ProtoMsgHelp.block(msg))
    return msg
end

---@param msg SC_Equip2CarPlanRes
function SuitSubsystem:UpdateCarData(msg)
    local suit = SuitDataManager:Get():GetSuit(msg.idx)
    if suit == nil then return end
    local cardata = suit:GetCarData()
    if cardata == nil then return end

    for i = 1, #msg.partPos do
        local grooveId = msg.partPos[i].num1
        local bagid = msg.partPos[i].num2
        local node = cardata.assembleMgr:GetNodeByGrooveID(grooveId)
        node:SetEquipmentData_IgnoreLimit(bagid)
    end
    cardata.assembleMgr:SetGrooveListState(msg.openPos)
    cardata:SetShellCfg()
    cardata.assembleMgr:UpdateClientData()

    suit:UpdateParts(msg.partPos)
end


-------------------------------------------------------------



local __subsystem = SuitSubsystem()
function SuitSubsystem:Get() return __subsystem end
return __subsystem