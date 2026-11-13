---@class BoxAwardSubsystem
BoxAwardSubsystem = class("BoxAwardSubsystem")

function BoxAwardSubsystem:initialize(...)
    --517, --返回宝箱队列
    NetResponseEventManager:Get():AddListener(MsgID.RET_BOX_QUEUE_S2C_RET, self, self.RecvMsg_RetBoxQueue)
    --519, --返回打开宝箱
    NetResponseEventManager:Get():AddListener(MsgID.RET_OPEN_BOX_S2C_RET, self, self.RecvMsg_RetOpenBox)
    --521, --返回取消宝箱
    NetResponseEventManager:Get():AddListener(MsgID.RET_CANCEL_BOX_S2C_RET, self, self.RecvMsg_RetCancelBox)
    --523, --返回领取宝箱
    NetResponseEventManager:Get():AddListener(MsgID.RET_BOX_GIFT_S2C_RET, self, self.RecvMsg_RetBoxGift)
    --525, --返回解锁宝箱位置
    NetResponseEventManager:Get():AddListener(MsgID.RET_UNLOCK_BOX_S2C_RET, self, self.RecvMsg_RetUnlockBox)

end

--516, --请求进入宝箱队列
function BoxAwardSubsystem:SendMsg_ReqBoxQueue()
    local reqData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.REQ_BOX_QUEUE_C2S_REQ, reqData)

end

--517, --返回宝箱队列
function BoxAwardSubsystem:RecvMsg_RetBoxQueue(data)
    ---@type SC_UserBoxList
    local msg = assert(Dll_PB.decode("UserBoxList", data))
    log(ProtoMsgHelp.block(msg))

    WelfareBoxDataManager:Get():InitBoxAwardData(msg.myBoxs)
    --UINotify:Get():SendNotification(UINotifyEvent.VideoLuckyTableInitData)

    UINotify:Get():SendNotification(UINotifyEvent.WelfareVideoOpenPage, WelfareFuncType.boxAwards)
    UINotify:Get():SendNotification(UINotifyEvent.WelfareVideo_PageRunAction, { WelfareFuncType.boxAwards, "RefreshView" })

end

--518, --请求打开宝箱 P2=位置 P3=宝箱id
function BoxAwardSubsystem:SendMsg_ReqOpenBox(_num, _id,num)
    num= num==nil and 1 or num
    local reqData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), _num, _id ,num})
    NetManager:Get():Send(MsgID.REQ_OPEN_BOX_C2S_REQ, reqData)

end

--519, --返回打开宝箱
function BoxAwardSubsystem:RecvMsg_RetOpenBox(data)
    ---@type SC_UserBoxOpen
    local msg = assert(Dll_PB.decode("UserBoxOpen", data))
    log(ProtoMsgHelp.block(msg))

    if msg.curConsume[1] then
        KnapsackDataManager:Get():UpdatePropByConsume(msg.curConsume[1])
    end
    WelfareBoxDataManager:Get():SetBoxAwardDataByID(msg.openBox)

    UINotify:Get():SendNotification(UINotifyEvent.WelfareVideo_PageRunAction, { WelfareFuncType.boxAwards, "RefreshView" })
end

--520, --请求取消宝箱 P2=位置
function BoxAwardSubsystem:SendMsg_ReqCancelBox(_num)
    local reqData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), _num })
    NetManager:Get():Send(MsgID.REQ_CANCEL_BOX_C2S_REQ, reqData)

end

--521, --返回取消宝箱
function BoxAwardSubsystem:RecvMsg_RetCancelBox(data)
    ---@type SC_UserBoxCancle
    local msg = assert(Dll_PB.decode("UserBoxCancle", data))
    log(ProtoMsgHelp.block(msg))

    KnapsackDataManager:Get():AddPropAndPartBySomeDown(msg.cancelDown[1])
    WelfareBoxDataManager:Get():SetBoxAwardDataByID(msg.cancleBox)

    UINotify:Get():SendNotification(UINotifyEvent.WelfareVideo_PageRunAction, { WelfareFuncType.boxAwards, "RefreshView" })
end

--522, --领取宝箱 P2=位置 P3=1立即开启
function BoxAwardSubsystem:SendMsg_ReqBoxGift(_num, _now)
    local reqData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), _num, _now })
    NetManager:Get():Send(MsgID.REQ_BOX_GIFT_C2S_REQ, reqData)

end

--523, --返回领取宝箱
function BoxAwardSubsystem:RecvMsg_RetBoxGift(data)
    ---@type SC_UserBoxGift
    local msg = assert(Dll_PB.decode("UserBoxGift", data))
    log(ProtoMsgHelp.block(msg))

    WelfareBoxDataManager:Get():SetBoxAwardDataByID(msg.curBox)

    if msg.boxDown[1] then
        CommonHelper:ShowGetRewardDataBySomeDown(msg.boxDown[1], true)
    end

    if msg.curConsume[1] then
        KnapsackDataManager:Get():UpdatePropByConsume(msg.curConsume[1])
    end


    UINotify:Get():SendNotification(UINotifyEvent.WelfareVideo_PageRunAction, { WelfareFuncType.boxAwards, "RefreshView" })
end

--524, --解锁宝箱位置 P2=位置
function BoxAwardSubsystem:SendMsg_ReqUnlockBox(_num)
    local reqData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), _num })
    NetManager:Get():Send(MsgID.REQ_UNLOCK_BOX_C2S_REQ, reqData)

end

--525, --返回解锁宝箱位置
function BoxAwardSubsystem:RecvMsg_RetUnlockBox(data)
    ---@type SC_UserBoxUnlock
    local msg = assert(Dll_PB.decode("UserBoxUnlock", data))
    log(ProtoMsgHelp.block(msg))

    WelfareBoxDataManager:Get():SetBoxAwardDataByID(msg.unlockBox)

    if msg.curConsume[1] then
        KnapsackDataManager:Get():UpdatePropByConsume(msg.curConsume[1])
    end


    UINotify:Get():SendNotification(UINotifyEvent.WelfareVideo_PageRunAction, { WelfareFuncType.boxAwards, "RefreshView" })
end

local __subsystem = BoxAwardSubsystem()

function BoxAwardSubsystem:Get()
    return __subsystem
end

return __subsystem