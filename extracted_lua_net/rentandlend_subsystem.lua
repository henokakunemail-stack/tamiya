---@class RentAndLendSubsystem
RentAndLendSubsystem = class("RentAndLendSubsystem")

function RentAndLendSubsystem:initialize(...)

    --531, --返回请求好友配件
    NetResponseEventManager:Get():AddListener(MsgID.RET_FRIEND_PARTS_S2C_RES, self, self.RecMsg_FriendParts)
    --531, --返回请求租借好友配件
    NetResponseEventManager:Get():AddListener(MsgID.RET_BORROW_PART_S2C_RES, self, self.RecMsg_BorrowPart)
    --535, --返回同意租借配件
    NetResponseEventManager:Get():AddListener(MsgID.RET_ACCEPT_BORROW_S2C_RES, self, self.RecMsg_AcceptBorrow)
    --537, --返回获得租借来的配件
    NetResponseEventManager:Get():AddListener(MsgID.RET_DOWN_BORROW_S2C_RES, self, self.RecMsg_DownBorrow)
    --539, --返回查看配件租借申请
    NetResponseEventManager:Get():AddListener(MsgID.RET_BORROW_APP_S2C_RES, self, self.RecMsg_BorrowApp)
    --541, --返回删除配件租借申请
    NetResponseEventManager:Get():AddListener(MsgID.RET_DEL_BORROW_APP_S2C_RES, self, self.RecMsg_DelBorrowApp)
    --543, --返回拒绝配件租借申请
    NetResponseEventManager:Get():AddListener(MsgID.RET_DENY_BORROW_S2C_RES, self, self.RecMsg_DenyBorrow)
    ---
    --545, --返回请求好友雇佣配件
    NetResponseEventManager:Get():AddListener(MsgID.RET_FRIEND_HIRE_S2C_RES, self, self.RecMsg_FriendHire)
    --547, --返回请求雇佣配件
    NetResponseEventManager:Get():AddListener(MsgID.RET_HIRE_PART_S2C_RES, self, self.RecMsg_HirePart)
    --549, --返回同意雇佣配件
    NetResponseEventManager:Get():AddListener(MsgID.RET_ACCEPT_HIRE_S2C_RES, self, self.RecMsg_AcceptHire)
    --551, --返回获得雇佣来的配件
    NetResponseEventManager:Get():AddListener(MsgID.RET_DOWN_HIRE_S2C_RES, self, self.RecMsg_DownHire)
    --553, --返回查看配件雇佣申请
    NetResponseEventManager:Get():AddListener(MsgID.RET_HIRE_APP_S2C_RES, self, self.RecMsg_HireApp)
    --555, --返回删除配件雇佣申请
    NetResponseEventManager:Get():AddListener(MsgID.RET_DEL_HIRE_APP_S2C_RES, self, self.RecMsg_DelHireApp)
    --557, --返回拒绝配件雇佣申请
    NetResponseEventManager:Get():AddListener(MsgID.RET_DENY_HIRE_S2C_RES, self, self.RecMsg_DenyHire)
    ---
    --559, --返回请求雇佣货币兑换信息
    NetResponseEventManager:Get():AddListener(MsgID.RET_HIRE_EXCH_COIN_S2C_RES, self, self.RecMsg_HireExchCoin)
    --561, --返回请求兑换雇佣货币
    NetResponseEventManager:Get():AddListener(MsgID.RET_HIRE_COIN_S2C_RES, self, self.RecMsg_HireCoin)


end

--530, --请求租借好友配件 P2=好友rid
function RentAndLendSubsystem:SendMsg_FriendParts(friendID)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), friendID })
    NetManager:Get():Send(MsgID.REQ_FRIEND_PARTS_C2S_REQ, data)
end

--531, --返回请求租借好友配件
function RentAndLendSubsystem:RecMsg_FriendParts(data)
    ---@type SC_FriendPart
    local msg = assert(Dll_PB.decode("FriendPart", data))
    print(ProtoMsgHelp.block(msg))

    RentAndLendDataManager:Get():SetChoosePartData(msg)

    print("租借--------", #msg.parts)
    if #msg.parts > 0 then
        if not UIManager:Get():IsPopViewShow("FriendChoosePropView") then
            UIManager:Get():OpenPopup("FriendChoosePropView", CanvasType.MainCanvas, "FriendChoosePropView", true)
        end

        UINotify:Get():SendNotification(UINotifyEvent.InitFriendChoosePart, { FriendRentAndLendType.Lend, -1 })
    else
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendRentNoTypePart))
    end


end

--532, --请求租借配件 P2=好友rid P3=配件索引 P4=角色名 P5=headicon P6=iconframe P7=curlevel
function RentAndLendSubsystem:SendMsg_BorrowPart(friendID, partID, friendName, headIcon, iconFrame, curLevel)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), friendID, partID, friendName, headIcon, iconFrame, curLevel })
    NetManager:Get():Send(MsgID.REQ_BORROW_PART_C2S_REQ, data)
end

--533, --返回请求租借配件
function RentAndLendSubsystem:RecMsg_BorrowPart(data)
    ---@type SC_BorrowApp
    local msg = assert(Dll_PB.decode("BorrowApp", data))
    print(ProtoMsgHelp.block(msg))

    RentAndLendDataManager:Get():SetBorrowPartData(msg)

    if #msg.downlist > 0 then
        CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist, true)
    end

    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendLendSuccess))

    if not UIManager:Get():IsPopViewShow("FriendChoosePropView") then
        UIManager:Get():OpenPopup("FriendChoosePropView", CanvasType.MainCanvas, "FriendChoosePropView", true)
    end

    UINotify:Get():SendNotification(UINotifyEvent.InitFriendChoosePart, { FriendRentAndLendType.Lend, -1 })
end

--534, --同意租借配件 P2=好友rid P3=配件索引
function RentAndLendSubsystem:SendMsg_AcceptBorrow(friendID, partID)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), friendID, partID })
    NetManager:Get():Send(MsgID.REQ_ACCEPT_BORROW_C2S_REQ, data)
end

--535, --返回同意租借配件
function RentAndLendSubsystem:RecMsg_AcceptBorrow(data)
    ---@type SC_BorrowApp
    local msg = assert(Dll_PB.decode("BorrowApp", data))
    print(ProtoMsgHelp.block(msg))

    RentAndLendDataManager:Get():SetMyBorrowAppDataByID(msg, 1)

    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist[1], false)

    UINotify:Get():SendNotification(UINotifyEvent.InitRentOrLendInfoByType, { FriendRentAndLendType.Lend, 1 })
end

--536, --获得租借来的配件 P2=好友rid P3=配件索引
function RentAndLendSubsystem:SendMsg_DownBorrow(friendID, partID)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), friendID, partID })
    NetManager:Get():Send(MsgID.REQ_DOWN_BORROW_C2S_REQ, data)
end

--537, --返回获得租借来的配件
function RentAndLendSubsystem:RecMsg_DownBorrow(data)
    ---@type SC_BorrowDownPart
    local msg = assert(Dll_PB.decode("BorrowDownPart", data))
    print(ProtoMsgHelp.block(msg))

    KnapsackDataManager:Get():AddPart({ msg.downPart })

    RentAndLendDataManager:Get():SetMyBorrowAppDataByID(msg.curApp, 0)

    UINotify:Get():SendNotification(UINotifyEvent.InitRentOrLendInfoByType, { FriendRentAndLendType.Lend, 0 })

end


--538, --查看配件租借申请 P2类型 0-我的申请 1-申请我的
function RentAndLendSubsystem:SendMsg_BorrowApp(apply)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), apply })
    NetManager:Get():Send(MsgID.REQ_BORROW_APP_C2S_REQ, data)
end

--539, --返回查看配件租借申请
function RentAndLendSubsystem:RecMsg_BorrowApp(data)
    ---@type SC_MyBorrowApp
    local msg = assert(Dll_PB.decode("MyBorrowApp", data))
    print(ProtoMsgHelp.block(msg))

    RentAndLendDataManager:Get():InitMyBorrowAppData(msg)

    if msg.borrowType == 1 then
        RentAndLendDataManager:Get():InitMyBorrowAppOutData(msg)
    end

    if not UIManager:Get():IsPopViewShow("FriendRentAndLendView") then
        UIManager:Get():OpenPopup("FriendRentAndLendView", CanvasType.MainCanvas, "FriendRentAndLendView", true)
    end

    UINotify:Get():SendNotification(UINotifyEvent.InitRentOrLendInfoByType, { FriendRentAndLendType.Lend, msg.borrowType })

end


--540, --删除配件租借申请 P2=好友rid P3=配件索引
function RentAndLendSubsystem:SendMsg_DelBorrowApp(friendID, partID)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), friendID, partID })
    NetManager:Get():Send(MsgID.REQ_DEL_BORROW_APP_C2S_REQ, data)
end

--541, --返回删除配件租借申请
function RentAndLendSubsystem:RecMsg_DelBorrowApp(data)
    ---@type SC_DelPartApp
    local msg = assert(Dll_PB.decode("DelPartApp", data))
    print(ProtoMsgHelp.block(msg))


end

--542, --拒绝配件租借申请 P2=申请人rid P3=配件索引
function RentAndLendSubsystem:SendMsg_DenyBorrow(friendID, partID)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), friendID, partID })
    NetManager:Get():Send(MsgID.REQ_DENY_BORROW_C2S_REQ, data)
end

--543, --返回拒绝配件租借申请
function RentAndLendSubsystem:RecMsg_DenyBorrow(data)
    ---@type SC_DelPartApp
    local msg = assert(Dll_PB.decode("DelPartApp", data))
    print(ProtoMsgHelp.block(msg))

    RentAndLendDataManager:Get():DelMyBorrowAppDataByID(msg, 1)

    UINotify:Get():SendNotification(UINotifyEvent.InitRentOrLendInfoByType, { FriendRentAndLendType.Lend, 1 })

end

--544, --请求好友雇佣配件 P2=好友rid
function RentAndLendSubsystem:SendMsg_FriendHire(friendID)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), friendID })
    NetManager:Get():Send(MsgID.REQ_FRIEND_HIRE_C2S_REQ, data)
end

--545, --返回请求好友雇佣配件
function RentAndLendSubsystem:RecMsg_FriendHire(data)
    ---@type SC_FriendPart
    local msg = assert(Dll_PB.decode("FriendPart", data))
    print(ProtoMsgHelp.block(msg))

    RentAndLendDataManager:Get():SetChoosePartData(msg)

    if #msg.parts > 0 then
        if not UIManager:Get():IsPopViewShow("FriendChoosePropView") then
            UIManager:Get():OpenPopup("FriendChoosePropView", CanvasType.MainCanvas, "FriendChoosePropView", true)
        end

        UINotify:Get():SendNotification(UINotifyEvent.InitFriendChoosePart, { FriendRentAndLendType.Rent, -1 })
    else
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendRentNoTypePart))
    end
end

--546, --请求雇佣配件 P2=好友rid P3=配件索引
function RentAndLendSubsystem:SendMsg_HirePart(friendID, partID)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), friendID, partID })
    NetManager:Get():Send(MsgID.REQ_HIRE_PART_C2S_REQ, data)
end

--547, --返回请求雇佣配件
function RentAndLendSubsystem:RecMsg_HirePart(data)
    ---@type SC_HireApp
    local msg = assert(Dll_PB.decode("HireApp", data))
    print(ProtoMsgHelp.block(msg))

    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendRentSuccess))

end

--548, --同意雇佣配件 P2=好友rid P3=配件索引
function RentAndLendSubsystem:SendMsg_AcceptHire(friendID, partID)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), friendID, partID })
    NetManager:Get():Send(MsgID.REQ_ACCEPT_HIRE_C2S_REQ, data)
end

--549, --返回同意雇佣配件
function RentAndLendSubsystem:RecMsg_AcceptHire(data)
    ---@type SC_HireApp
    local msg = assert(Dll_PB.decode("HireApp", data))
    print(ProtoMsgHelp.block(msg))

    RentAndLendDataManager:Get():SetMyHireAppDataByID(msg, 1)

    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist[1], false)

    UINotify:Get():SendNotification(UINotifyEvent.InitRentOrLendInfoByType, { FriendRentAndLendType.Rent, 1 })
end

--550, --获得雇佣来的配件 P2=好友rid P3=配件索引
function RentAndLendSubsystem:SendMsg_DownHire(friendID, partID)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), friendID, partID })
    NetManager:Get():Send(MsgID.REQ_DOWN_HIRE_C2S_REQ, data)
end

--551, --返回获得雇佣来的配件
function RentAndLendSubsystem:RecMsg_DownHire(data)
    ---@type SC_HireDownPart
    local msg = assert(Dll_PB.decode("HireDownPart", data))
    print(ProtoMsgHelp.block(msg))

    KnapsackDataManager:Get():AddPart({ msg.downPart })
    CommonHelper:ShowGetRewardDataBySomeDown(msg.curApp.downlist, false)
    KnapsackDataManager:Get():UpdatePropByConsume(msg.payMoney)
    RentAndLendDataManager:Get():SetMyHireAppDataByID(msg.curApp, 0)

    UINotify:Get():SendNotification(UINotifyEvent.InitRentOrLendInfoByType, { FriendRentAndLendType.Rent, 0 })
    UINotify:Get():SendNotification(UINotifyEvent.FriendListView_RefreshRentHaveInfo)

end

--552, --查看配件雇佣申请 P2类型 0-我的申请 1-申请我的
function RentAndLendSubsystem:SendMsg_HireApp(apply)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), apply })
    NetManager:Get():Send(MsgID.REQ_HIRE_APP_C2S_REQ, data)
end

--553, --返回查看配件雇佣申请
function RentAndLendSubsystem:RecMsg_HireApp(data)
    ---@type SC_MyHireApp
    local msg = assert(Dll_PB.decode("MyHireApp", data))
    print(ProtoMsgHelp.block(msg))

    RentAndLendDataManager:Get():InitMyHireAppData(msg)

    if msg.hireType == 1 then
        RentAndLendDataManager:Get():InitMyHireAppOutData(msg)
    end

    if not UIManager:Get():IsPopViewShow("FriendRentAndLendView") then
        UIManager:Get():OpenPopup("FriendRentAndLendView", CanvasType.MainCanvas, "FriendRentAndLendView", true)
    end

    UINotify:Get():SendNotification(UINotifyEvent.InitRentOrLendInfoByType, { FriendRentAndLendType.Rent, msg.hireType })

end

--554, --删除配件雇佣申请 P2=好友rid P3=配件索引
function RentAndLendSubsystem:SendMsg_DelHireApp(friendID, partID)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), friendID, partID })
    NetManager:Get():Send(MsgID.REQ_DEL_HIRE_APP_C2S_REQ, data)
end

--555, --返回删除配件雇佣申请
function RentAndLendSubsystem:RecMsg_DelHireApp(data)
    ---@type SC_DelPartApp
    local msg = assert(Dll_PB.decode("DelPartApp", data))
    print(ProtoMsgHelp.block(msg))


end

--556, --拒绝配件雇佣申请 P2=申请人rid P3=配件索引
function RentAndLendSubsystem:SendMsg_DenyHire(friendID, partID)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), friendID, partID })
    NetManager:Get():Send(MsgID.REQ_DENY_HIRE_C2S_REQ, data)
end

--557, --返回拒绝配件雇佣申请
function RentAndLendSubsystem:RecMsg_DenyHire(data)
    ---@type SC_DelPartApp
    local msg = assert(Dll_PB.decode("DelPartApp", data))
    print(ProtoMsgHelp.block(msg))

    RentAndLendDataManager:Get():DelMyHireAppDataByID(msg, 1)

    UINotify:Get():SendNotification(UINotifyEvent.InitRentOrLendInfoByType, { FriendRentAndLendType.Rent, 1 })

end

--558, --请求雇佣货币兑换信息
function RentAndLendSubsystem:SendMsg_HireExchCoin()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.REQ_HIRE_EXCH_COIN_C2S_REQ, data)
end

--559, --返回请求雇佣货币兑换信息
function RentAndLendSubsystem:RecMsg_HireExchCoin(data)
    ---@type SC_HireCoin
    local msg = assert(Dll_PB.decode("HireCoin", data))
    print(ProtoMsgHelp.block(msg))

    RentAndLendDataManager:Get():InitFriendExchangeData(msg)

    if not UIManager:Get():IsPopViewShow("FriendExchangeView") then
        UIManager:Get():OpenPopup("FriendExchangeView", CanvasType.MainCanvas, "FriendExchangeView", true)
    end

    UINotify:Get():SendNotification(UINotifyEvent.RefreshFriendExchangeData)

end


--560, --请求兑换雇佣货币 P2=待换货币id串 P3=数量串
function RentAndLendSubsystem:SendMsg_HireCoin(CoinID, NumID)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), CoinID, NumID })
    NetManager:Get():Send(MsgID.REQ_HIRE_COIN_C2S_REQ, data)
end

--561, --返回请求兑换雇佣货币
function RentAndLendSubsystem:RecMsg_HireCoin(data)
    ---@type SC_HireCoin
    local msg = assert(Dll_PB.decode("HireCoin", data))
    print(ProtoMsgHelp.block(msg))

    if msg.downlist then
        CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist, true)
    end
    if msg.curConsumes then
        KnapsackDataManager:Get():UpdatePropByConsumeGroup(msg.curConsumes.allConsumes)
    end

    RentAndLendDataManager:Get():InitFriendExchangeData(msg)
    UINotify:Get():SendNotification(UINotifyEvent.RefreshFriendExchangeData)

    UINotify:Get():SendNotification(UINotifyEvent.FriendListView_RefreshRentHaveInfo)

end

function RentAndLendSubsystem:Clear()

end

local __subsystem = RentAndLendSubsystem()

function RentAndLendSubsystem:Get()
    return __subsystem
end

return __subsystem

