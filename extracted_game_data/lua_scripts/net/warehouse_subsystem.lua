---@class WarehouseSubsystem
WarehouseSubsystem = class("WarehouseSubsystem")

function WarehouseSubsystem:initialize(...)
    -- 210, --返回配件仓库信息
    NetResponseEventManager:Get():AddListener(MsgID.GET_OPENSTORE_S2C_REQ, self, self.RecMsg_GetOpenStore)

    -- 208, --返回取出配件
    NetResponseEventManager:Get():AddListener(MsgID.GET_PULLPART_S2C_REQ, self, self.RecMsg_GetPullPart)

    -- 199, --返回分解配件
    NetResponseEventManager:Get():AddListener(MsgID.GET_STOREDEC_S2C_REQ, self, self.RecMsg_GetStoreDesc)


end

---请求 --打开配件仓库   --209
function WarehouseSubsystem:SendMsg_GetOpenStore()
    local msgData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.GET_OPENSTORE_C2S_RES, msgData)
end

--- 配件仓库信息 --210,
function WarehouseSubsystem:RecMsg_GetOpenStore(data)
    ---@type SC_PartStore
    local msg = assert(Dll_PB.decode("PartStore", data))
    print(ProtoMsgHelp.block(msg))

    if #msg.storePart == 0 then
        UINotify:Get():SendNotification(UINotifyEvent.AccessoryWarehouseView_InitData,true)
    else
        WarehouseDataManager:Get():InitData(msg.storePart)

        UINotify:Get():SendNotification(UINotifyEvent.AccessoryWarehouseView_InitData,true)
        UINotify:Get():SendNotification(UINotifyEvent.AccessoryWarehouseView_RefreshData, msg)
    end

    --UIManager:Get():OpenView("TrackMainView", CanvasType.MainCanvas, "TrackMainView")
    UIManager:Get():OpenView("WarehouseView", CanvasType.MainCanvas, "WarehouseView")
end

---请求 仓库取出配件 P2=配件id串  P3=数量串  --207
function WarehouseSubsystem:SendMsg_GetPullPart(IdStr, CountStr)
    local msgData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), IdStr, CountStr })
    NetManager:Get():Send(MsgID.GET_PULLPART_C2S_RES, msgData)
end

--- --返回取出配件  208
function WarehouseSubsystem:RecMsg_GetPullPart(data)
    ---@type SC_PullStore
    local msg = assert(Dll_PB.decode("PullStore", data))
    print(ProtoMsgHelp.block(msg))

    WarehouseDataManager:Get():InitDataByID(msg.deStoreParts)
    KnapsackDataManager:Get():AddPropAndPartBySomeDown(msg.pullParts)

    UINotify:Get():SendNotification(UINotifyEvent.AccessoryWarehouseView_InitData,false)
end

---请求 请求分解配件  P2=配件ID串  P3=配件数量串  --198
function WarehouseSubsystem:SendMsg_GetStoreDesc(IdStr, CountStr)
    local msgData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), IdStr, CountStr })
    NetManager:Get():Send(MsgID.GET_STOREDEC_C2S_RES, msgData)

end

--- --返回分解配件  --199
function WarehouseSubsystem:RecMsg_GetStoreDesc(data)
    ---@type SC_DecomposeStore
    local msg = assert(Dll_PB.decode("DecomposeStore", data))
    print(ProtoMsgHelp.block(msg))

    CommonHelper:ShowGetRewardDataBySomeDown(msg.curDown)
    WarehouseDataManager:Get():InitDataByID(msg.deStoreParts)
    KnapsackDataManager:Get():AddPropAndPartBySomeDown(msg.curDown)

    UINotify:Get():SendNotification(UINotifyEvent.AccessoryWarehouseView_InitData,false)
end

local __subsystem = WarehouseSubsystem()
function WarehouseSubsystem:Get()
    return __subsystem
end
return __subsystem