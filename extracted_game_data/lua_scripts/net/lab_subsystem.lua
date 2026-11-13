---@class LabSubsystem
LabSubsystem = class("LabSubsystem")

function LabSubsystem:initialize(...)
    -------------------------------------------------------------
    ---返回分解 129
    NetResponseEventManager:Get():AddListener(MsgID.DECOMPOSE_PART_S2C_RES, self, self.RecvMsg_LabResolveRes)

    --569,-- 返回限定合成列表
    NetResponseEventManager:Get():AddListener(MsgID.SPECIAL_PART_S2C_RES, self, self.RecvMsg_RetSpecialPart)

    --576,-- 返回解锁限定合成配件
    NetResponseEventManager:Get():AddListener(MsgID.UNLOCK_PIC_S2C_RES, self, self.RecvMsg_RetUnlockPic)

    --578,-- 返回合成限定配件
    NetResponseEventManager:Get():AddListener(MsgID.COMPOSE_SPECIAL_S2C_RES, self, self.RecvMsg_RetComposeSpecial)

    --580,-- 返回合成列表
    NetResponseEventManager:Get():AddListener(MsgID.COMPOSE_LIST_S2C_RES, self, self.RecvMsg_RetComposeList)

    --582,-- 返回合成
    NetResponseEventManager:Get():AddListener(MsgID.COMPOSE_S2C_RES, self, self.RecvMsg_RetCompose)

    NetResponseEventManager:Get():AddListener(MsgID.COMPOSE_PART_NEW_S2C_RES, self, self.RecvMsg_RetComposeNew)
    --584,-- 返回升级改造师等级
    NetResponseEventManager:Get():AddListener(MsgID.UP_LEV_BUILDER_S2C_RES, self, self.RecvMsg_RetUpLevBuilder)

    --588,-- 返回配件还原
    NetResponseEventManager:Get():AddListener(MsgID.PART_RETURN_S2C_RET, self, self.RecvMsg_PartReturn)


end

-------------------------------------------------------------分解  128
function LabSubsystem:SendMsg_LabResolveReq(cellIdTab)

    local p_data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), cellIdTab })

    NetManager:Get():Send(MsgID.DECOMPOSE_PART_C2S_REQ, p_data)
end

------返回分解   129  ----------------------------------------------------
function LabSubsystem:RecvMsg_LabResolveRes(data)
    ---@type SC_Decompose
    local msg = assert(Dll_PB.decode("Decompose", data))
    print(ProtoMsgHelp.block(msg))

    CommonHelper:ShowGetRewardDataBySomeDown(msg.curDown, false, nil, GetRewardType.Decompose)

    KnapsackDataManager:Get():DelArticleByPartsId(msg.deParts)

    KnapsackDataManager:Get():AddPropAndPartBySomeDown(msg.curDown)

    UINotify:Get():SendNotification(UINotifyEvent.LabMainMenu_RefreshCurView)

    QuickTaHelper:TrackDeComposeEvent(msg)

end


---------新合成------------------------------------------------------------------------------------------------

---568,--请求限定合成列表
function LabSubsystem:SendMsg_ReqSpecialPart()
    local p_data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.SPECIAL_PART_C2S_REQ, p_data)
end

---569,--返回限定合成列表
function LabSubsystem:RecvMsg_RetSpecialPart(data)
    ---@type SC_UserSpecialParts
    local msg = assert(Dll_PB.decode("UserSpecialParts", data))
    print(ProtoMsgHelp.block(msg))

    LabDataManager:Get():InitLimitComData(msg.partList)
    UINotify:Get():SendNotification(UINotifyEvent.LabMainMenu_OpenCurView)
end

---575, --请求解锁合成配件 P2=配件id
function LabSubsystem:SendMsg_ReqUnlockPic(upID)
    local p_data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), upID })
    NetManager:Get():Send(MsgID.UNLOCK_PIC_C2S_REQ, p_data)
end

---576, --返回解锁限定合成配件
function LabSubsystem:RecvMsg_RetUnlockPic(data)
    ---@type SC_UnlockSpecial
    local msg = assert(Dll_PB.decode("UnlockSpecial", data))
    print(ProtoMsgHelp.block(msg))

    LabDataManager:Get():InitLimitComDataByID(msg.partId)
    UINotify:Get():SendNotification(UINotifyEvent.LabMainMenu_RefreshCurView)
end

---577, --请求合成限定配件 P2=配件id P3=消耗配件索引串
function LabSubsystem:SendMsg_ReqComposeSpecial(partID, partStr)
    if partStr == nil or partStr == "" then
        partStr = 0
    end
    local p_data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), partID, partStr })
    NetManager:Get():Send(MsgID.COMPOSE_SPECIAL_C2S_REQ, p_data)
end

---578, -- 返回合成限定配件
function LabSubsystem:RecvMsg_RetComposeSpecial(data)
    ---@type SC_UserCompose
    local msg = assert(Dll_PB.decode("UserCompose", data))
    print(ProtoMsgHelp.block(msg))

    KnapsackDataManager:Get():DelArticleByPartsId(msg.counsumPartInx)
    KnapsackDataManager:Get():UpdatePropByConsumeGroup(msg.curConsumes.allConsumes)
    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist, true)

    UINotify:Get():SendNotification(UINotifyEvent.LabMainMenu_RefreshCurView)
end

---579, -- 请求合成列表
function LabSubsystem:SendMsg_ReqComposeList()
    local p_data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.COMPOSE_LIST_C2S_REQ, p_data)
end

---580, -- 返回合成列表
function LabSubsystem:RecvMsg_RetComposeList(data)
    ---@type SC_UserLab
    local msg = assert(Dll_PB.decode("UserLab", data))
    print(ProtoMsgHelp.block(msg))
    LabDataManager:Get():InitComposeList(msg)
    if not UIManager:Get():IsViewShow("LabMainView") then
        UIManager:Get():OpenView("LabMainView", CanvasType.MainCanvas, "LabMainView")
        UINotify:Get():SendNotification(UINotifyEvent.LabMainMenu_InitViewInfo, LabToggleType.Compose)
    end
    UINotify:Get():SendNotification(UINotifyEvent.LabMainMenu_OpenCurView)
end

---581, -- 请求合成P2=配件id
function LabSubsystem:SendMsg_ReqCompose(upID)
    local p_data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), upID })
    NetManager:Get():Send(MsgID.COMPOSE_C2S_REQ, p_data)
end

---582, -- 返回合成
function LabSubsystem:RecvMsg_RetCompose(data)
    ---@type SC_UserCompose
    local msg = assert(Dll_PB.decode("UserCompose", data))
    print(ProtoMsgHelp.block(msg))

    LabDataManager:Get():SetCompositorData(msg.curLab)
    KnapsackDataManager:Get():UpdatePropByConsumeGroup(msg.curConsumes.allConsumes)
    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist, true)
    UINotify:Get():SendNotification(UINotifyEvent.LabMainMenu_RefreshCurView, false)
end

---583, -- 请求升级改造师
function LabSubsystem:SendMsg_ReqUpLevBuilder()
    local p_data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.UP_LEV_BUILDER_C2S_REQ, p_data)
end

---584, -- 返回升级改造师等级
function LabSubsystem:RecvMsg_RetUpLevBuilder(data)
    ---@type SC_UpLevelBuilder
    local msg = assert(Dll_PB.decode("UpLevelBuilder", data))
    print(ProtoMsgHelp.block(msg))
    KnapsackDataManager:Get():UpdatePropByConsumeGroup(msg.myCousume)
    LabDataManager:Get():InitComposeList(msg.curLab)
    UINotify:Get():SendNotification(UINotifyEvent.LabMainMenu_RefreshCurView)
end

---587, -- 请求还原  type=0 全还原  type =1 只还原觉醒
function LabSubsystem:SendMsg_PartReturn(index, type)
    local p_data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), index, type })
    NetManager:Get():Send(MsgID.PART_RETURN_C2S_REQ, p_data)
end

---588, -- 请求还原回调
function LabSubsystem:RecvMsg_PartReturn(data)
    ---@type SC_UserPartReturn
    local msg = assert(Dll_PB.decode("UserPartReturn", data))
    print(ProtoMsgHelp.block(msg))
    local data = KnapsackDataManager:Get():GetArticleByID(msg.returnPart.partinx)
    data:OnInitPart(msg.returnPart)
    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist, true)
    if UIManager:Get():IsViewShow("LabMainView") then
        UINotify:Get():SendNotification(UINotifyEvent.LabMainMenu_RefreshCurView)
    end
    if UIManager:Get():IsViewShow("GarageView") then
        UINotify:Get():SendNotification(UINotifyEvent.Msg_Assemble, false)
    end
end

---581, -- 请求合成P2=配件id
function LabSubsystem:SendMsg_ReqComposeNew(upID, cellId)
    local p_data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), upID, cellId })
    NetManager:Get():Send(MsgID.COMPOSE_PART_NEW_C2S_REQ, p_data)
end

---582, -- 返回合成
function LabSubsystem:RecvMsg_RetComposeNew(data)
    ---@type SC_UserCompose
    local msg = assert(Dll_PB.decode("UserCompose", data))
    print(ProtoMsgHelp.block(msg))
    KnapsackDataManager:Get():UpdatePropByConsumeGroup(msg.curConsumes.allConsumes)
    KnapsackDataManager:Get():DelArticleByPartsId(msg.counsumPartInx)
    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist, true)
    UINotify:Get():SendNotification(UINotifyEvent.LabMainMenu_RefreshCurView)
end


-----------------------------------------------------------------------------------------------------------

local __subsystem = LabSubsystem()
function LabSubsystem:Get()
    return __subsystem
end
return __subsystem

